unit u_EETSigner;

interface

uses Classes, libxml2, libxmlsec, SysUtils;

Type
  TEETSignerKeyInfo = record
    Name : string;
    Subject : string;
    SerialNumber : string;
    notValidBefore : TDateTime;
    notValidAfter : TDateTime;
  end;

  TCERTrustedList = class;

  TEETSigner = class(TComponent)
  private
    FCertPassword: AnsiString;
    FActive: Boolean;
    FPFXStream: TMemoryStream; // stream s (PFX)
    FCERTrustedList : TCERTrustedList;   // stream list s overovacimi certifikaty (CER)
    FMngr: xmlSecKeysMngrPtr;
    FVerifyCertIncluded: Boolean;
    FPrivKeyInfo: TEETSignerKeyInfo;
    procedure InitXMLSec;
    procedure ShutDownXMLSec;
    procedure SetActive(const Value: Boolean);
    procedure CheckActive;
    procedure CheckInactive;
    procedure ReadPrivKeyInfo;
    function ExtractSubjectItem(aSubject, ItemName : string): string;
  public
    {:Nacita klice}
    property Active: Boolean read FActive write SetActive;
    {:Certifikat na overeni nacten}
    property VerifyCertIncluded: Boolean read FVerifyCertIncluded;
    {: Odstranit ovrovaci certifikat}
    procedure ClearVerifyCert;
    {:Nacist PFX certifikat ze souboru s pozaovanym heslem }
    procedure LoadPFXCertFromFile(const PFXFileName: TFileName; const CertPassword: AnsiString);
    {:Nacist PFX certifikat ze sreamu s pozaovanym heslem }
    procedure LoadPFXCertFromStream(PFXStream: TStream; const CertPassword: AnsiString);
    {:Nacist overovaci certifiat ye souboru (CER format)}
    function AddTrustedCertFromFileName(const CerFileName: TFileName) : integer;
    {:Nacist overovaci certifiat ze streamu (CER format)}
    function AddTrustedCertFromStream(const CerStream: TStream) : integer;
    {:Vratit Certificate RAW Data (base64 string)}
    function GetRawCertDataAsBase64String(): String;

    {:Podpis XML dokumentu.

    Podepisuje XML dokment a vraci True pokud je uspesne podepsan}
    function SignXML(XMLStream: TMemoryStream): Boolean;
    {:Podepsuje retezec a vraci otisk}
    function SignString(const s: string): AnsiString;
    {:Vraci otisk}
    function MakeBKP(const Data: string): String;
    {:Vraci otisk}
    function MakePKP(const Data: string): String;
    {:Overeni XML ve streamu}
    function VerifyXML(XMLSTream: TMemoryStream;
      const SignedNodeName: UTF8String = ''; const IdProp: UTF8String = 'wsu:Id'): boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    property PrivKeyInfo : TEETSignerKeyInfo read FPrivKeyInfo;
end;

  TCERTrustedList = class(TList)
  private
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function AddCert(Stream : TMemoryStream): Integer;
    function GetStream(Index: Integer): TMemoryStream;
  end;

implementation

uses
  {$IFDEF DEBUG}
  vcruntime ,
  {$ENDIF}
  SZCodeBaseX, synacode,
  u_EETSignerExceptions, StrUtils, System.DateUtils, libxmlsec_openssl, libeay32;

const
  PFXCERT_KEYNAME:PAnsiChar   = 'p';
  FISKXML_TNSSCHEMA_URI = 'http://fs.mfcr.cz/eet/schema/v3';

var
  EETSignerCount: Integer = 0;

{ TEETSigner }

procedure TEETSigner.CheckActive;
begin
  if not Active
  then raise EEETSignerException.Create(sSignerInactive);
end;

procedure TEETSigner.CheckInactive;
begin
  if Active
  then raise EEETSignerException.Create(sSignerInactive);
end;

procedure TEETSigner.ClearVerifyCert;
begin
  FCERTrustedList.Clear;
end;

constructor TEETSigner.Create(AOwner: TComponent);
begin
  Inc(EETSignerCount);
  InitXMLSec;
  inherited Create(AOwner);
  FPFXStream := TMemoryStream.Create;
  FCERTrustedList := TCERTrustedList.Create;
  FMngr := nil;
  FActive := False;
  FVerifyCertIncluded := False;
  FPrivKeyInfo.Name := '';
  FPrivKeyInfo.Subject := '';
  FPrivKeyInfo.notValidBefore := 0;
  FPrivKeyInfo.notValidAfter := 0;
end;

destructor TEETSigner.Destroy;
begin
  if Active
  then Active := False;
  FPFXStream.Free;
  FCERTrustedList.Free;
  Dec(EETSignerCount);
  ShutDownXMLSec;
  inherited;
end;

function TEETSigner.ExtractSubjectItem(aSubject, ItemName: string): string;
var
  TempList : TStringList;
begin
  Result := '';
  TempList:= TStringList.Create;
  try
    TempList.Delimiter := '/';
    TempList.DelimitedText := aSubject;
    if TempList.IndexOfName(ItemName) <> -1 then
      Result := Trim(TempList.Values[ItemName]);
  finally
    TempList.Free;
  end;
end;

function TEETSigner.GetRawCertDataAsBase64String: String;
var
  Doc: xmlDocPtr;
  Cur, CurData: xmlNodePtr;
  erCode: integer;
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  secKey: xmlSecKeyPtr;
  secKeyData : xmlSecKeyDataPtr;
  sSubject : string;
// for OpenSSL Section;
//  iPos, iSize: integer;
//  x509cert : pX509;
begin
  Result := '';
  secKey := nil; Doc := nil; keyInfoCtx := nil;
  CheckActive;
  try
    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeyInfoCtxCreate']);

    secKey :=  xmlSecKeysMngrFindKey(FMngr, PFXCERT_KEYNAME, keyInfoCtx);
    if secKey = nil
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeysMngrFindKey']);

    secKeyData := xmlSecKeyGetData(secKey, xmlSecKeyDataX509GetKlass);
    if secKeyData = nil
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeyGetData']);

    // OpenSSL section - start
    {
    iSize := xmlSecOpenSSLKeyDataX509GetCertsSize(secKeyData);
    for iPos := 0 to iSize - 1 do
      begin
        x509cert := xmlSecOpenSSLKeyDataX509GetCert(secKeyData, iPos);
        if x509cert <> nil then
          begin
            sSubject := '';
            if xmlSecOpenSSLX509CertGetSubject(X509_get_subject_name(x509cert), sSubject) = 0 then
              sSubject := ExtractSubjectItem(sSubject, 'CN');
            if SameText(FPrivKeyInfo.Subject, sSubject) then
              begin
                Result := xmlSecOpenSSLX509CertBase64DerWrite(x509cert, 0);
                Break;
              end;
          end;
      end;
    }
    // OpenSSL section - end

    // Independent xmlsec library section - start
    doc := xmlSecCreateTree(xmlCharPtr('Keys'), xmlSecNs);
    if doc = nil
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecCreateTree']);

    cur := xmlSecAddChild(xmlDocGetRootElement(doc), xmlSecNodeKeyInfo, xmlSecDSigNs);
    if Cur = nil
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 1']);

    if (nil = xmlSecAddChild(cur, xmlSecNodeKeyName, xmlSecDSigNs))
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 2']);

    CurData := xmlSecAddChild(cur, secKeyData.id.dataNodeName, secKeyData.id.dataNodeNs);
    if (nil = CurData)
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 3']);

    if (nil = xmlSecAddChild(curData, xmlSecNodeX509SubjectName, xmlSecDSigNs))
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 5']);

    if (nil = xmlSecAddChild(curData, xmlSecNodeX509Certificate, xmlSecDSigNs))
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 4']);

    keyInfoCtx.mode                 := xmlSecKeyInfoModeWrite;
    keyInfoCtx.base64LineSize       := 0; // no lineBreaks in X509Certificate

    erCode := xmlSecKeyInfoNodeWrite(cur, secKey, keyInfoCtx);
    if erCode < 0
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeyInfoNodeWrite']);

    Cur := xmlSecFindNode(cur, xmlSecNodeX509Data, secKeyData.id.dataNodeNs);
    if Cur = nil
    then raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecFindNode : ' + string(xmlSecNodeX509Data)]);

    Cur := xmlSecFindNode(cur, xmlSecNodeX509Certificate, secKeyData.id.dataNodeNs);
    if Cur <> nil then
      begin
        while Cur <> nil do
          begin
            if SameText(string(cur.name), string(xmlSecNodeX509Certificate)) then
              Result := string(xmlNodeGetContent(Cur));
            if SameText(string(cur.name), string(xmlSecNodeX509SubjectName)) then
              sSubject := ExtractSubjectItem(StringReplace(string(xmlNodeGetContent(Cur)), ',', '/', [rfReplaceAll]), 'CN');
            if SameText(FPrivKeyInfo.Subject, sSubject) then
              Cur := nil; // break loop
            if Cur <> nil then Cur := Cur.next;
          end;
      end
    else
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecFindNode : ' + string(xmlSecNodeX509Certificate)]);
    // Independent xmlsec library section - end

  finally
    if doc <> nil
    then xmlFreeDoc(doc);
    if keyInfoCtx <> nil
    then xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil
    then xmlSecKeyDestroy(secKey);
  end;
end;

procedure TEETSigner.InitXMLSec;
begin
  if EETSignerCount > 1
  then Exit;

  xmlInitParser();
  __xmlLoadExtDtdDefaultValue^ := XML_DETECT_IDS or XML_COMPLETE_ATTRS;
  xmlSubstituteEntitiesDefault(1);
  __xmlIndentTreeOutput^ := 0;  // nemaji se formatovat XML elementy

  xmlSecBase64SetDefaultLineSize(0); // Kvuli jednoradkove SignatureValue

  if (xmlSecInit() < 0)
  then raise EEETSignerException.Create(sSignerXmlSecInitError);

  if (xmlSecCheckVersionExt(1, 2, 18, xmlSecCheckVersionABICompatible) <> 1)
  then raise EEETSignerException.Create(sSignerInitWrongDll);

  if (xmlSecCryptoDLLoadLibrary('openssl') < 0)
  then raise EEETSignerException.Create(sSignerInitNoXmlsecOpensslDll);
//  if (xmlSecCryptoDLLoadLibrary('mscrypto') < 0)
//  then raise EEETSignerException.Create(sSignerInitNoXmlsecMSCryptoDll);

  if (xmlSecCryptoAppInit(nil) < 0)
  then raise EEETSignerException.Create(sSignerXmlSecInitError);

  if (xmlSecCryptoInit() < 0)
  then raise EEETSignerException.Create(sSignerXmlSecInitError);
end;

procedure TEETSigner.LoadPFXCertFromFile(const PFXFileName: TFileName; const CertPassword: AnsiString);
begin
  CheckInactive;
  if CertPassword = ''
  then raise EEETSignerException.Create(sSignerNoPassword);
  FPFXStream.Clear;
  FPFXStream.LoadFromFile(PFXFileName);
  FCertPassword := CertPassword;
end;

procedure TEETSigner.LoadPFXCertFromStream(PFXStream: TStream; const CertPassword: AnsiString);
begin
  CheckInactive;
  if CertPassword = ''
  then raise EEETSignerException.Create(sSignerNoPassword);
  FPFXStream.Clear;
  FPFXStream.LoadFromStream(PFXStream);
  FCertPassword := CertPassword;
end;

function TEETSigner.MakeBKP(const Data: string): String;
var
  buf : AnsiString;
  I : Integer;

  function FormatBKP(Value : string): string;
  begin
    Result := '';
    I := 1;
    while I <= Length(Value) do
      begin
        Result := Result + Value[I];
        if (I mod 8 = 0) and (I < Length(Value)) then
          Result := Result + '-';
        Inc(I);
      end;
  end;

begin
 // generovat PKP
  buf := SignString(Data);
  if Length(buf) > 0 then
    begin
      // generovat BKP z puvodniho cisteho podpisu retezce
      Result := FormatBKP(string(SZEncodeBase16(SHA1(buf))));
    end;
end;

function TEETSigner.MakePKP(const Data: string): String;
var
  buf : AnsiString;
begin
 // generovat PKP
  buf := SignString(Data);
  if Length(buf) > 0 then
    begin
      Result := string(EncodeBase64(buf));
    end;
end;

function TEETSigner.AddTrustedCertFromFileName(const CerFileName: TFileName) : integer;
var
  Stream : TMemoryStream;
begin
  CheckInactive;
  Stream := TMemoryStream.Create;
  Stream.LoadFromFile(CerFileName);
  Result := FCERTrustedList.AddCert(Stream);
end;

function TEETSigner.AddTrustedCertFromStream(const CerStream: TStream) : integer;
var
  Stream : TMemoryStream;
begin
  CheckInactive;
  Stream := TMemoryStream.Create;
  Stream.LoadFromStream(CerStream);
  Result := FCERTrustedList.AddCert(Stream);
end;

procedure TEETSigner.ReadPrivKeyInfo;
var
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  secKey: xmlSecKeyPtr;
  ItemCount, I : Integer;
  DataItem : xmlSecKeyDataPtr;
  x509cert : pX509;
  a_time : TDateTime;
  a_serialnumber : string;
  a_subject : string;
begin
  CheckActive;

  keyInfoCtx := nil;
  secKey := nil;

  try
    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate']);

    secKey :=  xmlSecKeysMngrFindKey(FMngr, PFXCERT_KEYNAME, keyInfoCtx);
    if secKey = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeysMngrFindKey']);

    // read PrivKeyInfo
    ItemCount := xmlSecPtrListGetSize(secKey.dataList);
    for I := 0 to ItemCount - 1 do
      begin
        DataItem := xmlSecPtrListGetItem(secKey.dataList, I);
         if (xmlSecKeyDataIsValid(DataItem) and xmlSecKeyDataCheckId(DataItem, xmlSecOpenSSLKeyDataX509Id)) then
           begin
             x509cert := xmlSecOpenSSLKeyDataX509GetKeyCert(DataItem);
             if xmlSecOpenSSLX509CertGetTime(X509_get_notBefore(x509cert), a_time) = 0 then
               FPrivKeyInfo.notValidBefore :=a_time;
             if xmlSecOpenSSLX509CertGetTime(X509_get_notAfter(x509cert), a_time) = 0 then
               FPrivKeyInfo.notValidAfter := a_time;
             if xmlSecOpenSSLX509CertGetSerialNumber(X509_get_serialNumber(x509cert), a_serialnumber) = 0 then
               FPrivKeyInfo.SerialNumber :=a_serialnumber;
             if xmlSecOpenSSLX509CertGetSubject(X509_get_subject_name(x509cert), a_subject) = 0 then
               FPrivKeyInfo.Subject := ExtractSubjectItem(a_subject, 'CN');
           end;
      end;

    FPrivKeyInfo.Name := String(secKey.name);
  finally
    if keyInfoCtx <> nil
    then xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil
    then xmlSecKeyDestroy(secKey);
  end;
end;

procedure TEETSigner.SetActive(const Value: Boolean);
var
  Key: xmlSecKeyPtr;
{$IFDEF DEBUG}
  keysfilename : AnsiString;
{$ENDIF}
  certkeyformat : xmlSecKeyDataFormat;
  certkeystring : AnsiString;
  ms : TMemoryStream;
  I: Integer;
begin
  if Active = Value
  then Exit;

  Key := nil;

  if FActive // pokud je aktivni, tak uklidit
  then begin
    FCertPassword := '';
    if FMngr <> nil
    then begin
      xmlSecKeysMngrDestroy(FMngr);
      FMngr := nil;
    end;
    FPFXStream.Clear;
    FCERTrustedList.Clear;
    FActive := False;
    FreeXMLSecOpenSSL;
    Exit;
  end;

  if not InitXMLSecOpenSSL then raise EEETSignerException.Create(sSignerInitNoXmlsecOpensslDll);

  if FCertPassword = '' // mora biti password
  then raise EEETSignerException.Create(sSignerNoPassword);

  try
    try
      {$ASSERTIONS ON}
      {$BOOLEVAL OFF}
      if FPFXStream.Size > 0
      then begin
        FPrivKeyInfo.Name := '';
        FPrivKeyInfo.SerialNumber := '';
        FPrivKeyInfo.notValidBefore := 0;
        FPrivKeyInfo.notValidAfter := 0;

        FMngr := xmlSecKeysMngrCreate();
        if (FMngr = nil) or (xmlSecCryptoAppDefaultKeysMngrInit(FMngr) <> 0)
        then raise EEETSignerException.Create(sSignerKeyMngrCreateFail);

        Key := xmlSecCryptoAppKeyLoadMemory(
          FPFXStream.Memory,
          FPFXStream.Size,
          xmlSecKeyDataFormatPkcs12,
          Pointer(FCertPassword), nil, nil);
        if (Key = nil)
        then raise EEETSignerException.Create(sSignerInvalidPFXCert);
        if xmlSecKeySetName(Key, PFXCERT_KEYNAME) <> 0
        then Assert(False);
        Key.usage := 1;

        if (xmlSecCryptoAppDefaultKeysMngrAdoptKey(FMngr, Key) <> 0)
        then raise EEETSignerException.Create(sSignerInvalidPFXCert)
        else Key := nil;
      end
      else raise EEETSignerException.Create(sSignerInvalidPFXCert);

      //load verify certificate
      if FCERTrustedList.Count > 0
      then begin
        certkeyformat := xmlSecKeyDataFormatCertDer;

        for I := 0 to FCERTrustedList.Count - 1 do
          begin
            ms := FCERTrustedList.GetStream(I);
            SetLength(certkeystring, ms.Size);
            ms.Seek(0, soFromBeginning);
            ms.Read(PAnsiChar(certkeystring)^, ms.Size);
            ms.Seek(0, soFromBeginning);
            if Pos(AnsiString('-BEGIN CERTIFICATE-'), certkeystring) > 0 then
              certkeyformat := xmlSecKeyDataFormatCertPem;

            if xmlSecCryptoAppKeysMngrCertLoadMemory(
                FMngr,
                ms.Memory,
                ms.Size,
                certkeyformat,
                $100 {xmlSecKeyDataTypeTrusted} ) < 0
            then  begin
              FVerifyCertIncluded := False;
              raise EEETSignerException.Create(sSignerInvalidVerifyCert)
            end
          end;
        FVerifyCertIncluded := FCERTrustedList.Count > 0;
      end;

      FActive := True;

      {$IFDEF DEBUG}
      keysfilename:= 'keys.xml';
      if xmlSecCryptoAppDefaultKeysMngrSave(FMngr,@keysfilename[1],$FFFF) < 0 then
         raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
      {$ENDIF}

      ReadPrivKeyInfo;
    except
      FActive := False;
      FVerifyCertIncluded := False;
      if Key <> nil
      then xmlSecKeyDestroy(Key);
      if FMngr <> nil
      then begin
        xmlSecKeysMngrDestroy(FMngr);
        FMngr := nil;
      end;
      raise;
    end;
  finally
    FCertPassword := '';
    FCERTrustedList.Clear;
    FPFXStream.Clear;
  end;
end;

procedure TEETSigner.ShutDownXMLSec;
begin
  if EETSignerCount = 0 then
  begin
    xmlSecCryptoShutdown();
    xmlSecCryptoAppShutdown();
    xmlSecShutdown();
  end;
end;

function TEETSigner.SignString(const s: string): AnsiString;
const
  SIGSIZE = 256;
var
  TransCtx: xmlSecTransformCtxPtr;
  transId: xmlSecTransformId;
  TransMethod: xmlSecTransformPtr;
  buf: UTF8String;
  bufSz: Integer;
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  secKey: xmlSecKeyPtr;
begin
  Result := '';
  CheckActive;

  new(TransCtx);
  keyInfoCtx := nil;
  secKey := nil;
  buf := UTF8Encode(s);
  bufSz := Length(buf);
  try
    if xmlSecTransformCtxInitialize(TransCtx) <> 0
    then raise EEETSignerException.Create(sSignerTransformCtxFail);

    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate']);

    secKey :=  xmlSecKeysMngrFindKey(FMngr, PFXCERT_KEYNAME, keyInfoCtx);
    if secKey = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeysMngrFindKey']);

    transId := xmlSecTransformRsaSha256GetKlass();

    TransMethod := xmlSecTransformCtxCreateAndAppend(TransCtx, transId);
    if TransMethod = nil
    then raise EEETSignerException.Create(sSignerTransformCtxFail);
    TransMethod.operation := xmlSecTransformOperationSign;

    if xmlSecTransformSetKey(TransMethod, secKey) <> 0
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecTransformSetKey']);

    if xmlSecTransformCtxPrepare(TransCtx, 1) <> 0
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecTransformCtxPrepare']);

    if xmlSecTransformDefaultPushBin(TransCtx.first, Pointer(Buf), bufSz, 1, TransCtx) <> 0
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecTransformDefaultPushBin']);

    if TransCtx.result.size <> SIGSIZE // potpis je uvijek SIGSIZE (256 byte) velièine
    then raise EEETSignerException.CreateFmt(sSignerUnexpectedSignature, [TransCtx.result.size]);

    setlength(Result, SIGSIZE);
    Move(TransCtx.result.data^, Result[1], TransCtx.result.size);
  finally
    xmlSecTransformCtxFinalize(TransCtx);
    Dispose(TransCtx);
    if keyInfoCtx <> nil
    then xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil
    then xmlSecKeyDestroy(secKey);
  end;
end;

function TEETSigner.SignXML(XMLStream: TMemoryStream): Boolean;
var
  Doc: xmlDocPtr;
  Node, BodyNode: xmlNodePtr;
  Buf: PUTF8String;
  BufSz: integer;
  erCode: integer;
  DSigCtx: xmlSecDSigCtxPtr;

  procedure RegisterID(xmlNode : xmlNodePtr; idName : xmlCharPtr);
  var
    attr : xmlAttrPtr;
    tmp : xmlAttrPtr;
    name : xmlCharPtr;
  begin
    {* find pointer to id attribute *}
    attr := xmlHasProp(xmlNode, idName);
    if((attr = nil) or (attr.children = nil)) then exit;

    {* get the attribute (id) value *}
    name := xmlNodeListGetString(xmlNode.doc, attr.children, 1);
    if(name = nil) then exit;

    {* check that we don't have that id already registered *}
    tmp := xmlGetID(xmlNode.doc, name);
    if(tmp <> nil) then
      begin
        xmlFree(name);
        exit;
      end;

    {* finally register id *}
    xmlAddID(nil, xmlNode.doc, name, attr);

    {* and do not forget to cleanup *}
    xmlFree(name);
  end;
begin
  CheckActive;
  {$BOOLEVAL OFF}
  if (XMLStream = nil) or (XMLStream.Size = 0)
  then raise EEETSignerException.Create(sSignerEmptyXML);

  Doc := nil; Node := nil;
  DSigCtx := xmlSecDSigCtxCreate(FMngr);
  try
    Buf := nil; BufSz := 0;

    Doc := xmlSecParseMemory(XMLStream.Memory, XMLStream.Size, 0);
    Assert(Doc <> nil);

    Node := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeSignature()), xmlCharPtr(xmlSecDSigNs()));
    Assert(Node <> nil);

    BodyNode := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeBody), xmlCharPtr(xmlSecSoap11Ns));
    Assert(BodyNode <> nil);

    RegisterID(BodyNode, 'Id'); // kvuli node:Reference failed zaregistrovat hodnotu wsu:Id jako Id

    DSigCtx.keyInfoWriteCtx.base64LineSize := 0;

    erCode := xmlSecDSigCtxSign(DSigCtx, Node);
    Result := erCode = 0;
    Assert(erCode = 0);

    if Result
    then begin
      xmlDocDumpMemory(Doc, @Buf, @BufSz);
      XMLStream.SetSize(BufSz);
      XMLStream.Position := 0;
      XMLStream.WriteBuffer(Buf^, BufSz);
      xmlBufferFree(Pointer(Buf));
    end;
  finally
    if Node = nil
    then xmlFreeNode(Node);
    if Doc <> nil
    then xmlFreeDoc(Doc);
    xmlSecDSigCtxDestroy(DSigCtx);
  end;
end;

function TEETSigner.VerifyXML(XMLSTream: TMemoryStream; const SignedNodeName, IdProp: UTF8String): boolean;
var
  Doc: xmlDocPtr;
  Node, SignatureNode: xmlNodePtr;
  BSTNode: xmlNodePtr;
  KeyInfoNode, x509Data, x509Certificate : xmlNodePtr;
  DsigCtx: xmlSecDSigCtxPtr;
  Attr: xmlAttrPtr;
  IdVal: AnsiString;
begin
  CheckActive;

  Doc := nil; DsigCtx := nil; {Attr := nil;}
  Result := False;
  try
    Doc := xmlSecParseMemory( xmlSecBytePtr(XMLStream.Memory), XMLStream.Size, 0);
    if Doc = nil
    then raise EEETXMLException.Create(sXMLNotXML);

    if SignedNodeName <> ''
    then begin
      // add Id Atrribute for reference
      Node := xmlSecFindNode(xmlDocGetRootElement(Doc), PAnsiChar(SignedNodeName), PAnsiChar(FISKXML_TNSSCHEMA_URI));
      if Node = nil then
        Node := xmlSecFindNode(xmlDocGetRootElement(Doc), PAnsiChar(SignedNodeName), PAnsiChar(xmlSecSoap11Ns));
      if Node <> nil
      then begin
        Attr := xmlHasProp(Node, PAnsiChar(IdProp) );
        if Attr <> nil
        then begin
          IdVal := xmlGetProp(Node, PAnsiChar(IdProp));
          xmlAddID(nil, Doc, @(IdVal[1]), Attr);
        end;
      end;
    end;

    BSTNode := xmlSecFindNode(xmlDocGetRootElement(Doc), PAnsiChar('BinarySecurityToken'), PAnsiChar('http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'));

    SignatureNode := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeSignature), xmlCharPtr(xmlSecDSigNs));
    if SignatureNode <> nil
    then
      begin
        DsigCtx := xmlSecDSigCtxCreate(FMngr);
        Assert(DsigCtx <> nil);

        if (BSTNode <> nil) then
          begin
            Attr := xmlHasProp(BSTNode, PAnsiChar(IdProp) );
            if Attr <> nil
            then begin
              IdVal := xmlGetProp(BSTNode, PAnsiChar(IdProp));
              xmlAddID(nil, Doc, @(IdVal[1]), Attr);
            end;

            // simulate X509Certifica node from
            // hack KeyInfo for verify from BinarySecurityToken
            KeyInfoNode := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeKeyInfo), xmlCharPtr(xmlSecDSigNs));
            if KeyInfoNode <> nil then
              begin
                xmlUnlinkNode(KeyInfoNode);
                xmlFreeNode(KeyInfoNode);
              end;

            KeyInfoNode := xmlSecAddChild(SignatureNode, xmlCharPtr(xmlSecNodeKeyInfo), xmlCharPtr(xmlSecDSigNs));
            if KeyInfoNode = nil
            then raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['KeyInfoNode']);

            X509Data := xmlSecTmplKeyInfoAddX509Data(KeyInfoNode);
            if X509Data = nil
            then raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['X509Data']);

            X509Certificate := xmlSecTmplX509DataAddCertificate(X509Data);
            if X509Certificate = nil
            then raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['X509Certificate']);

            xmlNodeSetContent(X509Certificate, xmlNodeGetContent(BSTNode));
            xmlSecAddChildNode(X509Data, X509Certificate);
          end;

        {$IFDEF DEBUG}
        _xmlDocDump(Doc, PAnsiChar(ansistring('beforeverify.xml')));
        {$ENDIF}

        {$BOOLEVAL OFF}
        if (xmlSecDSigCtxVerify(DsigCtx, SignatureNode) = 0) then
            Result := (DsigCtx^.status = xmlSecDSigStatusSucceeded);
      end;

  finally
    if Doc <> nil
    then xmlFreeDoc(Doc);
    if DsigCtx <> nil
    then xmlSecDSigCtxDestroy(DsigCtx);
  end;
end;

{ TCERTrustedList }

function TCERTrustedList.AddCert(Stream: TMemoryStream): Integer;
begin
  Result := -1;
  if Stream = nil then Exit;
  Result := Add(Stream);
end;

function TCERTrustedList.GetStream(Index: Integer): TMemoryStream;
begin
  Result := TMemoryStream(Get(Index));
end;

procedure TCERTrustedList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
     TMemoryStream(Ptr).Free;
end;

end.
