unit u_EETSigner;

interface

uses Classes,
{$IFDEF USE_LIBEET}
     u_libeet,
{$ELSE}
     libxml2, libxmlsec,
{$ENDIF}
     SysUtils;

const
  FISKXML_TNSSCHEMA_URI = 'http://fs.mfcr.cz/eet/schema/v3';

Type
  TEETSignerCertInfo = record
    Name : string;
    Subject : string;
    CommonName : string;
    Organisation : string;
    Country : string;
    IssuerName : string;
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
    FPrivKeyInfo: TEETSignerCertInfo;
    FResponseCertInfo: TEETSignerCertInfo;
    procedure InitXMLSec;
    procedure ShutDownXMLSec;
    procedure SetActive(const Value: Boolean);
    procedure CheckActive;
    procedure CheckInactive;
    procedure ClearCertInfo(CertInfo : TEETSignerCertInfo);
    procedure ReadPrivKeyCertInfo;
    procedure ReadResponseCertInfo;
    function ExtractSubjectItem(aSubject, ItemName : string): string;
    {$IFNDEF USE_LIBEET}
    procedure AddBSTCert(aValue : AnsiString);
    procedure RemoveBSTCert;
    {$ENDIF}
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
    function VerifyXML(XMLStream: TMemoryStream;
      const SignedNodeName: UTF8String = ''; const IdProp: UTF8String = 'wsu:Id'): boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    property PrivKeyInfo : TEETSignerCertInfo read FPrivKeyInfo;
    property ResponseCertInfo : TEETSignerCertInfo read FResponseCertInfo;
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
  StrUtils, DateUtils,
  {$IFNDEF USE_LIBEET}
  synacode, libxmlsec_openssl, libeay32,
  {$IFDEF DEBUG}
  vcruntime ,
  {$ENDIF}
  {$ENDIF}
  u_EETSignerExceptions;

{$IFNDEF USE_LIBEET}
const
  PFXCERT_KEYNAME : PAnsiChar   = 'p';
  RESPONSECERT_KEYNAME : PAnsiChar = 'responsecert';
{$ENDIF}

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

procedure TEETSigner.ClearCertInfo(CertInfo : TEETSignerCertInfo);
begin
  CertInfo.Name := '';
  CertInfo.Subject := '';
  CertInfo.CommonName := '';
  CertInfo.Organisation := '';
  CertInfo.Country := '';
  CertInfo.notValidBefore := 0;
  CertInfo.notValidAfter := 0;
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
  ClearCertInfo(FPrivKeyInfo);
  ClearCertInfo(FResponseCertInfo);
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
    TempList.StrictDelimiter := True;
    TempList.DelimitedText := aSubject;
    if TempList.IndexOfName(ItemName) <> -1 then
      Result := Trim(TempList.Values[ItemName]);
  finally
    TempList.Free;
  end;
end;

function TEETSigner.GetRawCertDataAsBase64String: String;
{$IFNDEF USE_LIBEET}
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
{$ENDIF}
begin
  Result := '';
{$IFNDEF USE_LIBEET}
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
{$ENDIF}
end;

procedure TEETSigner.InitXMLSec;
begin
  if EETSignerCount > 1
  then Exit;
{$IFNDEF USE_LIBEET}
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
{$ELSE}
  if not InitLibEETSigner('')
  then raise EEETSignerException.Create(sSignerLibEETInitLibError);
  if (eetSignerInit < 0)
  then raise EEETSignerException.Create(sSignerLibEETSignerInitError);
{$ENDIF}
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
{$IFNDEF USE_LIBEET}
var
  buf : AnsiString;
  I : Integer;
{$ENDIF}

{$IFNDEF USE_LIBEET}
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
  function String2Hex(const Buffer: Ansistring): string;
   var
     n: Integer;
   begin
     Result := '';
     for n := 1 to Length(Buffer) do
       Result := LowerCase(Result + IntToHex(Ord(Buffer[n]), 2));
   end;
{$ENDIF}

begin
{$IFNDEF USE_LIBEET}
  Result := '';
 // generovat PKP
  buf := SignString(Data);
  if Length(buf) > 0 then
    begin
      // generovat BKP z puvodniho cisteho podpisu retezce
      Result := FormatBKP(string(String2Hex(SHA1(buf))));
    end;
{$ELSE}
  Result := eetSignerMakeBKP(FMngr, Data);
{$ENDIF}
end;

function TEETSigner.MakePKP(const Data: string): String;
{$IFNDEF USE_LIBEET}
var
  buf : AnsiString;
{$ENDIF}
begin
{$IFNDEF USE_LIBEET}
  Result := '';
 // generovat PKP
  buf := SignString(Data);
  if Length(buf) > 0 then
    begin
      Result := string(EncodeBase64(buf));
    end;
{$ELSE}
  Result := eetSignerMakePKP(FMngr, Data);
{$ENDIF}
end;

{$IFNDEF USE_LIBEET}
procedure TEETSigner.AddBSTCert(aValue: AnsiString);
var
  certstring : AnsiString;
  secKey, tmpkey, secKeyNew : xmlSecKeyPtr;
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  store : xmlSecKeyStorePtr;
  list : xmlSecPtrListPtr;
  size, Pos : xmlSecSize;
  {$IFDEF DEBUG}
  keysfilename : AnsiString;
  {$ENDIF}

  function xmlSecKeyStoreCheckSize(store : xmlSecKeyStorePtr; size : xmlSecSize): boolean;
  begin
    Result := (store^.id.objSize >= size);
  end;

  function xmlSecSimpleKeysStoreGetList(store : xmlSecKeyStorePtr) : xmlSecPtrListPtr;
  begin
    Result := nil;
    if xmlSecKeyStoreCheckSize(store, sizeof(xmlSecKeyStore) + sizeof(xmlSecPtrList)) then
      begin
        Result := xmlSecPtrListPtr(Pointer(NativeInt(xmlSecBytePtr(store)) + sizeof(xmlSecKeyStore)));
      end;
  end;
begin
  CheckActive;
  certstring := AnsiString('-----BEGIN CERTIFICATE----- ')+#10;
  certstring := certstring + aValue + #10;
  certstring := certstring + AnsiString('-----END CERTIFICATE-----')+#10;

  keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
  if keyInfoCtx = nil
  then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate - BSTCert']);

  secKey := xmlSecKeysMngrFindKey(FMngr, RESPONSECERT_KEYNAME, keyInfoCtx);

  try
    secKeyNew := xmlSecCryptoAppKeyLoadMemory(Pointer(certstring), xmlSecSize(Length(certstring)),
        xmlSecKeyDataFormatCertPem, nil, nil, nil);

    if secKeyNew = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecCryptoAppKeyLoadMemory - BSTCert']);

    if xmlSecKeySetName(secKeyNew, RESPONSECERT_KEYNAME) <> 0
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeySetName - BSTCert']);

    if secKey = nil then
      begin
        if (xmlSecCryptoAppDefaultKeysMngrAdoptKey(FMngr, secKeyNew) <> 0)
        then raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['xmlSecCryptoAppDefaultKeysMngrAdoptKey - BSTCert']);
      end
    else
      begin
        store := xmlSecKeysMngrGetKeysStore(FMngr);
        list := xmlSecSimpleKeysStoreGetList(store);
        size := xmlSecPtrListGetSize(list);
        for pos := 0 to size - 1 do
          begin
           tmpkey := xmlSecKeyPtr(xmlSecPtrListGetItem(list, pos));
           if((tmpkey <> nil) and (xmlSecKeyMatch(tmpkey, RESPONSECERT_KEYNAME, Pointer(Addr(keyInfoCtx.keyReq))) = 1))
           then
             begin
               if xmlSecKeyCopy(tmpkey, secKeyNew) < 0
               then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyCopy - BSTCert - replace']);
               if xmlSecKeySetName(tmpKey, RESPONSECERT_KEYNAME)<> 0
               then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeySetName - BSTCert - replace'])
             end;
          end;
      end;
  finally
    if keyInfoCtx <> nil then
       xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil then
       xmlSecKeyDestroy(secKey);
  end;

  {$IFDEF DEBUG}
  keysfilename:= 'keys-response.xml';
  if xmlSecCryptoAppDefaultKeysMngrSave(FMngr,@keysfilename[1],$FFFF) < 0 then
     raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
  {$ENDIF}
end;
{$ENDIF}

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

procedure TEETSigner.ReadPrivKeyCertInfo;
var
{$IFNDEF USE_LIBEET}
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  secKey: xmlSecKeyPtr;
  ItemCount, I : Integer;
  DataItem : xmlSecKeyDataPtr;
  x509cert : pX509;
  a_time : TDateTime;
  a_serialnumber : string;
  a_subject : string;
  a_issuername : string;
{$ELSE}
  x509cert : libeetX509Ptr;
  a_time, b_time : TDateTime;
{$ENDIF}
begin
  CheckActive;
{$IFNDEF USE_LIBEET}
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
             if xmlSecOpenSSLX509CertGetX509Name(X509_get_subject_name(x509cert), a_subject) = 0 then
               begin
                 FPrivKeyInfo.Subject := a_subject;
                 FPrivKeyInfo.CommonName := ExtractSubjectItem(a_subject, 'CN');
                 FPrivKeyInfo.Organisation := ExtractSubjectItem(a_subject, 'O');
                 FPrivKeyInfo.Country := ExtractSubjectItem(a_subject, 'C');
               end;
             if Length(FPrivKeyInfo.CommonName) > 2 then
               if Copy(FPrivKeyInfo.CommonName,1,2) = 'CZ'  then
                 begin
                   FPrivKeyInfo.Name := 'p';
                   if xmlSecOpenSSLX509CertGetTime(X509_get_notBefore(x509cert), a_time) = 0 then
                     FPrivKeyInfo.notValidBefore :=a_time;
                   if xmlSecOpenSSLX509CertGetTime(X509_get_notAfter(x509cert), a_time) = 0 then
                     FPrivKeyInfo.notValidAfter := a_time;
                   if xmlSecOpenSSLX509CertGetSerialNumber(X509_get_serialNumber(x509cert), a_serialnumber) = 0 then
                     FPrivKeyInfo.SerialNumber :=a_serialnumber;
                   if xmlSecOpenSSLX509CertGetX509Name(X509_get_issuer_name(x509cert), a_issuername) = 0 then
                     FPrivKeyInfo.IssuerName := a_issuername;
                   Break;
                 end;
           end;
      end;

    FPrivKeyInfo.Name := String(secKey.name);
  finally
    if keyInfoCtx <> nil
    then xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil
    then xmlSecKeyDestroy(secKey);
  end;
{$ELSE}
  x509cert := eetSignerGetX509KeyCert(FMngr);
  if x509cert <> nil then
    begin
      FPrivKeyInfo.Name := 'p';
      FPrivKeyInfo.Subject := eetSignerX509GetSubject(x509cert);
      FPrivKeyInfo.CommonName := ExtractSubjectItem(eetSignerX509GetSubject(x509cert), 'CN');
      FPrivKeyInfo.Organisation := ExtractSubjectItem(eetSignerX509GetSubject(x509cert), 'O');
      FPrivKeyInfo.Country := ExtractSubjectItem(eetSignerX509GetSubject(x509cert), 'C');
      FPrivKeyInfo.IssuerName := eetSignerX509GetIssuerName(x509cert);
      FPrivKeyInfo.SerialNumber := eetSignerX509GetSerialNum(x509cert);
      if (eetSignerX509GetValidDate(x509cert, a_time, b_time) = 0) then
        begin
          FPrivKeyInfo.notValidBefore := a_time;
          FPrivKeyInfo.notValidAfter := b_time;
        end;
      eetFree(x509cert);
    end;
{$ENDIF}
end;

procedure TEETSigner.ReadResponseCertInfo;
var
{$IFNDEF USE_LIBEET}
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  secKey: xmlSecKeyPtr;
  ItemCount, I : Integer;
  DataItem : xmlSecKeyDataPtr;
  x509cert : pX509;
  a_time : TDateTime;
  a_serialnumber : string;
  a_subject : string;
  a_issuername : string;
{$ELSE}
  x509cert : libeetX509Ptr;
  a_time, b_time : TDateTime;
{$ENDIF}
begin
  CheckActive;
{$IFNDEF USE_LIBEET}
  keyInfoCtx := nil;
  secKey := nil;
  try
    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate']);

    secKey :=  xmlSecKeysMngrFindKey(FMngr, RESPONSECERT_KEYNAME, keyInfoCtx);
    if secKey = nil
    then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeysMngrFindKey']);

    // read PrivKeyInfo
    ItemCount := xmlSecPtrListGetSize(secKey.dataList);
    for I := 0 to ItemCount - 1 do
      begin
        DataItem := xmlSecPtrListGetItem(secKey.dataList, I);
         if (xmlSecKeyDataIsValid(DataItem) and xmlSecKeyDataCheckId(DataItem, xmlSecOpenSSLKeyDataX509Id)) then
           begin
             x509cert := xmlSecOpenSSLKeyDataX509GetCert(DataItem, I);
             if x509cert <> nil then
               begin
                 if xmlSecOpenSSLX509CertGetX509Name(X509_get_subject_name(x509cert), a_subject) = 0 then
                   begin
                     FResponseCertInfo.Subject := a_subject;
                     FResponseCertInfo.CommonName := ExtractSubjectItem(a_subject, 'CN');
                     FResponseCertInfo.Organisation := ExtractSubjectItem(a_subject, 'O');
                     FResponseCertInfo.Country := ExtractSubjectItem(a_subject, 'C');
                   end;
                 if xmlSecOpenSSLX509CertGetTime(X509_get_notBefore(x509cert), a_time) = 0 then
                   FResponseCertInfo.notValidBefore := a_time;
                 if xmlSecOpenSSLX509CertGetTime(X509_get_notAfter(x509cert), a_time) = 0 then
                   FResponseCertInfo.notValidAfter := a_time;
                 if xmlSecOpenSSLX509CertGetSerialNumber(X509_get_serialNumber(x509cert), a_serialnumber) = 0 then
                   FResponseCertInfo.SerialNumber := a_serialnumber;
                 if xmlSecOpenSSLX509CertGetX509Name(X509_get_issuer_name(x509cert), a_issuername) = 0 then
                   FResponseCertInfo.IssuerName := a_issuername;
               end;
           end;
      end;
    FResponseCertInfo.Name := String(secKey.name);
  finally
    if keyInfoCtx <> nil
    then xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil
    then xmlSecKeyDestroy(secKey);
  end;
{$ELSE}
  x509cert := eetSignerGetX509ResponseCert(FMngr);
  if x509cert <> nil then
    begin
      FResponseCertInfo.Name := 'response';
      FResponseCertInfo.Subject := eetSignerX509GetSubject(x509cert);
      FResponseCertInfo.CommonName := ExtractSubjectItem(eetSignerX509GetSubject(x509cert), 'CN');
      FResponseCertInfo.Organisation := ExtractSubjectItem(eetSignerX509GetSubject(x509cert), 'O');
      FResponseCertInfo.Country := ExtractSubjectItem(eetSignerX509GetSubject(x509cert), 'C');
      FResponseCertInfo.IssuerName := eetSignerX509GetIssuerName(x509cert);
      FResponseCertInfo.SerialNumber := eetSignerX509GetSerialNum(x509cert);
      if (eetSignerX509GetValidDate(x509cert, a_time, b_time) = 0) then
        begin
          FResponseCertInfo.notValidBefore := a_time;
          FResponseCertInfo.notValidAfter := b_time;
        end;
      eetFree(x509cert);
    end;
{$ENDIF}
end;

{$IFNDEF USE_LIBEET}
procedure TEETSigner.RemoveBSTCert;
var
  secKey, tmpKey : xmlSecKeyPtr;
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  store : xmlSecKeyStorePtr;
  list : xmlSecPtrListPtr;
  size, Pos : xmlSecSize;
  {$IFDEF DEBUG}
  keysfilename : AnsiString;
  {$ENDIF}

  function xmlSecKeyStoreCheckSize(store : xmlSecKeyStorePtr; size : xmlSecSize): boolean;
  begin
    Result := (store^.id.objSize >= size);
  end;

  function xmlSecSimpleKeysStoreGetList(store : xmlSecKeyStorePtr) : xmlSecPtrListPtr;
  begin
    Result := nil;
    if xmlSecKeyStoreCheckSize(store, sizeof(xmlSecKeyStore) + sizeof(xmlSecPtrList)) then
      begin
        Result := xmlSecPtrListPtr(Pointer(NativeInt(xmlSecBytePtr(store)) + sizeof(xmlSecKeyStore)));
      end;
  end;
begin
  CheckActive;

  keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
  if keyInfoCtx = nil
  then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate - BSTCert']);

  secKey := xmlSecKeysMngrFindKey(FMngr, RESPONSECERT_KEYNAME, keyInfoCtx);

  try
    if secKey <> nil then
      begin
        store := xmlSecKeysMngrGetKeysStore(FMngr);
        list := xmlSecSimpleKeysStoreGetList(store);
        size := xmlSecPtrListGetSize(list);
        for pos := 0 to size - 1 do
          begin
           tmpkey := xmlSecKeyPtr(xmlSecPtrListGetItem(list, pos));
           if((tmpkey <> nil) and (xmlSecKeyMatch(tmpkey, RESPONSECERT_KEYNAME, Pointer(Addr(keyInfoCtx.keyReq))) = 1))
           then
             begin
               if xmlSecPtrListRemove(list,pos) < 0
               then raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecPtrListRemove - BSTCert']);
             end;
          end;
      end;
  finally
    if keyInfoCtx <> nil then
       xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil then
       xmlSecKeyDestroy(secKey);
  end;

  {$IFDEF DEBUG}
  keysfilename:= 'keys-response-BSTremoved.xml';
  if xmlSecCryptoAppDefaultKeysMngrSave(FMngr,@keysfilename[1],$FFFF) < 0 then
     raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
  {$ENDIF}
end;
{$ENDIF}

procedure TEETSigner.SetActive(const Value: Boolean);
var
  ms : TMemoryStream;
  I: Integer;
{$IFNDEF USE_LIBEET}
  Key: xmlSecKeyPtr;
{$IFDEF DEBUG}
  keysfilename : AnsiString;
{$ENDIF}
  certkeyformat : xmlSecKeyDataFormat;
  certkeystring : AnsiString;
{$ELSE}
{$ENDIF}
begin
  if Active = Value
  then Exit;

{$IFNDEF USE_LIBEET}
  Key := nil;
{$ENDIF}

  if FActive // pokud je aktivni, tak uklidit
  then begin
    FCertPassword := '';
{$IFNDEF USE_LIBEET}
    if FMngr <> nil
    then begin
      xmlSecKeysMngrDestroy(FMngr);
      FMngr := nil;
    end;
    FreeXMLSecOpenSSL;
{$ELSE}
    if FMngr <> nil
    then begin
      eetSignerKeysMngrDestroy(FMngr);
      FMngr := nil;
    end;
    eetSignerCleanUp;
{$ENDIF}
    FPFXStream.Clear;
    FCERTrustedList.Clear;
    FActive := False;
    ClearCertInfo(FPrivKeyInfo);
    ClearCertInfo(FResponseCertInfo);
    Exit;
  end;

{$IFNDEF USE_LIBEET}
  if not InitXMLSecOpenSSL then raise EEETSignerException.Create(sSignerInitNoXmlsecOpensslDll);
{$ENDIF}

  if FCertPassword = '' // mora biti password
  then raise EEETSignerException.Create(sSignerNoPassword);

  try
    try
      {$ASSERTIONS ON}
      {$BOOLEVAL OFF}
      if FPFXStream.Size > 0
      then begin
        ClearCertInfo(FPrivKeyInfo);
        ClearCertInfo(FResponseCertInfo);

        {$IFNDEF USE_LIBEET}
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
        {$ELSE}
        FMngr := eetSignerKeysMngrCreate();
        if (FMngr = nil)
        then raise EEETSignerException.Create(sSignerKeyMngrCreateFail);

        if (eetSignerLoadPFXKeyMemory(FMngr, FPFXStream.Memory,FPFXStream.Size,string(FCertPassword)) < 0)
        then
          raise EEETSignerException.Create(sSignerInvalidPFXCert);
        {$ENDIF}
      end
      else raise EEETSignerException.Create(sSignerInvalidPFXCert);

      //load verify certificate
      if FCERTrustedList.Count > 0
      then begin
        {$IFNDEF USE_LIBEET}
        certkeyformat := xmlSecKeyDataFormatCertDer;
        {$ENDIF}

        for I := 0 to FCERTrustedList.Count - 1 do
          begin
            ms := FCERTrustedList.GetStream(I);
            {$IFNDEF USE_LIBEET}
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
            {$ELSE}
            if (eetSignerAddTrustedCertMemory(FMngr, ms.Memory, ms.Size) < 0)
            then  begin
              FVerifyCertIncluded := False;
              raise EEETSignerException.Create(sSignerInvalidVerifyCert)
            end
            {$ENDIF}
          end;
        FVerifyCertIncluded := FCERTrustedList.Count > 0;
      end;

      FActive := True;

      {$IFNDEF USE_LIBEET}
      {$IFDEF DEBUG}
      keysfilename:= 'keys.xml';
      if xmlSecCryptoAppDefaultKeysMngrSave(FMngr,@keysfilename[1],$FFFF) < 0 then
         raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
      {$ENDIF}
      {$ENDIF}

      ReadPrivKeyCertInfo;
    except
      FActive := False;
      FVerifyCertIncluded := False;
      {$IFNDEF USE_LIBEET}
      if Key <> nil
      then xmlSecKeyDestroy(Key);
      if FMngr <> nil
      then begin
        xmlSecKeysMngrDestroy(FMngr);
        FMngr := nil;
      end;
      {$ELSE}
      if FMngr <> nil
      then begin
        eetSignerKeysMngrDestroy(FMngr);
        FMngr := nil;
      end;
      eetSignerCleanUp;
      {$ENDIF}
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
{$IFNDEF USE_LIBEET}
    xmlSecCryptoShutdown();
    xmlSecCryptoAppShutdown();
    xmlSecShutdown();
{$ELSE}
    eetSignerShutdown;
{$ENDIF}
  end;
end;

function TEETSigner.SignString(const s: string): AnsiString;
{$IFNDEF USE_LIBEET}
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
{$ENDIF}
begin
  Result := '';
  CheckActive;

{$IFNDEF USE_LIBEET}
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
{$ELSE}
  Result := eetSignerSignString(FMngr, s);
{$ENDIF}
end;

function TEETSigner.SignXML(XMLStream: TMemoryStream): Boolean;
var
{$IFNDEF USE_LIBEET}
  Doc: xmlDocPtr;
  Node, BodyNode: xmlNodePtr;
  Buf: PUTF8String;
  BufSz: integer;
  erCode: integer;
  DSigCtx: xmlSecDSigCtxPtr;
{$ELSE}
  output : ansistring;
{$ENDIF}

{$IFNDEF USE_LIBEET}
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
{$ENDIF}

begin
  CheckActive;

  {$BOOLEVAL OFF}
  if (XMLStream = nil) or (XMLStream.Size = 0)
  then raise EEETSignerException.Create(sSignerEmptyXML);

{$IFNDEF USE_LIBEET}
  Doc := nil; {Node := nil;}
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
      if BufSz>0 then XMLStream.WriteBuffer(Buf^, BufSz);
      xmlFree(Buf);
    end;
  finally
//    if Node = nil
//    then xmlFreeNode(Node);
    if Doc <> nil
    then xmlFreeDoc(Doc);
    xmlSecDSigCtxDestroy(DSigCtx);
  end;
{$ELSE}
  Result := (eetSignerSignRequest(FMngr, XMLStream.Memory, XMLStream.Size, output) = 0);
  if Result then
    begin
      XMLStream.SetSize(Length(output));
      XMLStream.Position := 0;
      XMLStream.WriteBuffer(PAnsiChar(output)^, Length(output));
    end;
{$ENDIF}
end;

function TEETSigner.VerifyXML(XMLStream: TMemoryStream; const SignedNodeName, IdProp: UTF8String): boolean;
{$IFNDEF USE_LIBEET}
var
  Doc: xmlDocPtr;
  Node, SignatureNode: xmlNodePtr;
  BSTNode: xmlNodePtr;
  KeyInfoNode, x509Data, x509Certificate : xmlNodePtr;
  DsigCtx: xmlSecDSigCtxPtr;
  Attr: xmlAttrPtr;
  IdVal: xmlCharPtr;
{$ENDIF}
begin
  CheckActive;
  ClearCertInfo(FResponseCertInfo);
{$IFNDEF USE_LIBEET}
  RemoveBSTCert;
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
          xmlAddID(nil, Doc, IdVal, Attr);
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
              xmlAddID(nil, Doc, IdVal, Attr);
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
        if Result then
          AddBSTCert(xmlNodeGetContent(BSTNode));
      end;

  finally
    if Doc <> nil
    then xmlFreeDoc(Doc);
    if DsigCtx <> nil
    then xmlSecDSigCtxDestroy(DsigCtx);
  end;
{$ELSE}
  Result := (eetSignerVerifyResponse(FMngr, XMLStream.Memory, XMLStream.Size) = 1);
{$ENDIF}
  if Result then ReadResponseCertInfo;
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
