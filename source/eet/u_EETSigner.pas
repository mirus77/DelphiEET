unit u_EETSigner;

interface

{* functions SHA1 is independent on libeay32.dll when use synacode.pas unit, DEFINE USE_SYNACODE *}
{.$DEFINE USE_SYNACODE}

{$IF CompilerVersion >= 24.0}
  {$LEGACYIFEND ON}
{$IFEND}

uses Classes,
{$IFDEF USE_LIBEET}
  u_libeet,
{$ELSE}
  libxml2, libxmlsec, libeay32,
{$ENDIF}
  SysUtils;

const
  FISKXML_TNSSCHEMA_URI = 'http://fs.mfcr.cz/eet/schema/v3';

Type
  TEETSignerCertInfo = record
    Name: string;
    Subject: string;
    CommonName: string;
    Organisation: string;
    Country: string;
    IssuerName: string;
    SerialNumber: string;
    notValidBefore: TDateTime;
    notValidAfter: TDateTime;
  end;

  TCERTrustedList = class;

  TEETSigner = class(TComponent)
  private
    FCertPassword: AnsiString;
    FActive: Boolean;
    FPFXStream: TMemoryStream; // stream with (PFX)
    FCERTrustedList: TCERTrustedList;
    // stream list with verification certificates (CER)
    FMngr: xmlSecKeysMngrPtr;
    FVerifyCertIncluded: Boolean;
    FPrivKeyInfo: TEETSignerCertInfo;
    FResponseCertInfo: TEETSignerCertInfo;
    procedure InitXMLSec;
    procedure ShutDownXMLSec;
    procedure SetActive(const Value: Boolean);
    procedure CheckActive;
    procedure CheckInactive;
    procedure ClearCertInfo(CertInfo: TEETSignerCertInfo);
    procedure ReadPrivKeyCertInfo;
    procedure ReadResponseCertInfo;
    function ExtractSubjectItem(aSubject, ItemName: string): string;
{$IFNDEF USE_LIBEET}
    procedure AddBSTCert(aValue: AnsiString);
    procedure RemoveBSTCert;
{$ENDIF}
  public
    { :Load keys and certs }
    property Active: Boolean read FActive write SetActive;
    { :Certificat for verify is loaded }
    property VerifyCertIncluded: Boolean read FVerifyCertIncluded;
    { :Delete verify certificates }
    procedure ClearVerifyCert;
    { :Load PFX certificate from file with required password }
    procedure LoadPFXCertFromFile(const PFXFileName: TFileName; const CertPassword: AnsiString);
    { :Load PFX certificate fro setram with required password }
    procedure LoadPFXCertFromStream(PFXStream: TStream; const CertPassword: AnsiString);
    { :Load verification certificate from file (CER format) }
    function AddTrustedCertFromFileName(const CerFileName: TFileName): integer;
    { :Load verification certificate from stream (CER format) }
    function AddTrustedCertFromStream(const CerStream: TStream): integer;
    { :Get Public Certificate in RAW Data (base64 string) }
    function GetRawCertDataAsBase64String(): String;

    { :Sign XML document

      Sign XML document and return True if success status }
    function SignXML(XMLStream: TMemoryStream): Boolean;
    { :Sign string and return Fingerprint }
    function SignString(const s: string): AnsiString;
    { :Return Fingerprint }
    function MakeBKP(const Data: string): String;
    { :Return Fingerprint }
    function MakePKP(const Data: string): String;
    { :Verify XML in stream }
    function VerifyXML(XMLStream: TMemoryStream; const SignedNodeName: UTF8String = '';
      const IdProp: UTF8String = 'wsu:Id'): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
    property PrivKeyInfo: TEETSignerCertInfo read FPrivKeyInfo;
    property ResponseCertInfo: TEETSignerCertInfo read FResponseCertInfo;
  end;

  TCERTrustedList = class(TList)
  private
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function AddCert(Stream: TMemoryStream): integer;
    function GetStream(Index: integer): TMemoryStream;
  end;

{$IFNDEF USE_LIBEET}
{$IFNDEF USE_SYNACODE}
procedure EETSigner_EVP_MD_CTX_init(ctx: pEVP_MD_CTX); cdecl;
function EETSigner_EVP_DigestInit_ex(ctx: pEVP_MD_CTX; const _type: pEVP_MD; impl: Pointer): integer; cdecl;
function EETSigner_EVP_DigestUpdate(ctx: pEVP_MD_CTX; const d: Pointer; cnt: cardinal): integer; cdecl;
function EETSigner_EVP_DigestFinal_ex(ctx: pEVP_MD_CTX; md: PAnsiChar; var s: cardinal): integer; cdecl;
procedure EETSigner_EVP_MD_CTX_cleanup(ctx: pEVP_MD_CTX); cdecl;
{$ENDIF}
{$ENDIF}

implementation

uses
  StrUtils, DateUtils, {$IF CompilerVersion >= 23.0 }AnsiStrings,{$IFEND}
{$IFNDEF USE_LIBEET}
  libxmlsec_openssl,
{$IFDEF USE_SYNACODE}synacode,{$ENDIF}
{$IFDEF DEBUG}
  vcruntime,
{$ENDIF}
{$ENDIF}
  u_EETSignerExceptions;

{$IFNDEF USE_LIBEET}

const
  PFXCERT_KEYNAME: PAnsiChar = 'p';
  RESPONSECERT_KEYNAME: PAnsiChar = 'responsecert';
  LIBEAY_DLL_NAME = 'libeay32.dll';
{$ENDIF}

var
  EETSignerCount: integer = 0;

{$IFNDEF USE_LIBEET}
{$IFNDEF USE_SYNACODE}
{ Some OpensSSL function for function SHA1 }
procedure EETSigner_EVP_MD_CTX_init; external LIBEAY_DLL_NAME name 'EVP_MD_CTX_init';
function EETSigner_EVP_DigestInit_ex; external LIBEAY_DLL_NAME name 'EVP_DigestInit_ex';
function EETSigner_EVP_DigestUpdate; external LIBEAY_DLL_NAME name 'EVP_DigestUpdate';
function EETSigner_EVP_DigestFinal_ex; external LIBEAY_DLL_NAME name 'EVP_DigestFinal_ex';
procedure EETSigner_EVP_MD_CTX_cleanup; external LIBEAY_DLL_NAME name 'EVP_MD_CTX_cleanup';
{$ENDIF}
{$ENDIF}
{ TEETSigner }

procedure TEETSigner.CheckActive;
begin
  if not Active then
    raise EEETSignerException.Create(sSignerInactive);
end;

procedure TEETSigner.CheckInactive;
begin
  if Active then
    raise EEETSignerException.Create(sSignerInactive);
end;

procedure TEETSigner.ClearCertInfo(CertInfo: TEETSignerCertInfo);
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
  if Active then
    Active := False;
  FPFXStream.Free;
  FCERTrustedList.Free;
  Dec(EETSignerCount);
  ShutDownXMLSec;
  inherited;
end;

function TEETSigner.ExtractSubjectItem(aSubject, ItemName: string): string;
var
  TempList: TStringList;
begin
  Result := '';
  TempList := TStringList.Create;
  try
    TempList.Delimiter := '/';
    {$IF CompilerVersion > 15}
    TempList.StrictDelimiter := True;
    {$IFEND}
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
  secKeyData: xmlSecKeyDataPtr;
  sSubject: string;
{$ENDIF}
begin
  Result := '';
{$IFNDEF USE_LIBEET}
  secKey := nil;
  Doc := nil;
  keyInfoCtx := nil;
  CheckActive;
  try
    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeyInfoCtxCreate']);

    secKey := xmlSecKeysMngrFindKey(FMngr, PFXCERT_KEYNAME, keyInfoCtx);
    if secKey = nil then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeysMngrFindKey']);

    secKeyData := xmlSecKeyGetData(secKey, xmlSecKeyDataX509GetKlass);
    if secKeyData = nil then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeyGetData']);

    // Independent xmlsec library section - start
    Doc := xmlSecCreateTree(xmlCharPtr('Keys'), xmlSecNs);
    if Doc = nil then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecCreateTree']);

    Cur := xmlSecAddChild(xmlDocGetRootElement(Doc), xmlSecNodeKeyInfo, xmlSecDSigNs);
    if Cur = nil then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 1']);

    if (nil = xmlSecAddChild(Cur, xmlSecNodeKeyName, xmlSecDSigNs)) then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 2']);

    CurData := xmlSecAddChild(Cur, secKeyData.id.dataNodeName, secKeyData.id.dataNodeNs);
    if (nil = CurData) then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 3']);

    if (nil = xmlSecAddChild(CurData, xmlSecNodeX509SubjectName, xmlSecDSigNs)) then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 5']);

    if (nil = xmlSecAddChild(CurData, xmlSecNodeX509Certificate, xmlSecDSigNs)) then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecAddChild 4']);

    keyInfoCtx.mode := xmlSecKeyInfoModeWrite;
    keyInfoCtx.base64LineSize := 0; // no lineBreaks in X509Certificate

    erCode := xmlSecKeyInfoNodeWrite(Cur, secKey, keyInfoCtx);
    if erCode < 0 then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecKeyInfoNodeWrite']);

    Cur := xmlSecFindNode(Cur, xmlSecNodeX509Data, secKeyData.id.dataNodeNs);
    if Cur = nil then
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecFindNode : ' + string(xmlSecNodeX509Data)]);

    Cur := xmlSecFindNode(Cur, xmlSecNodeX509Certificate, secKeyData.id.dataNodeNs);
    if Cur <> nil then
      begin
        while Cur <> nil do
          begin
            if SameText(string(Cur.Name), string(xmlSecNodeX509Certificate)) then
              Result := string(xmlNodeGetContent(Cur));
            if SameText(string(Cur.Name), string(xmlSecNodeX509SubjectName)) then
              sSubject := ExtractSubjectItem(StringReplace(string(xmlNodeGetContent(Cur)), ',', '/', [rfReplaceAll]), 'CN');
            if SameText(FPrivKeyInfo.Subject, sSubject) then
              Cur := nil; // break loop
            if Cur <> nil then
              Cur := Cur.next;
          end;
      end
    else
      raise EEETSignerException.CreateFmt(sSignerGetRawData, ['xmlSecFindNode : ' + string(xmlSecNodeX509Certificate)]);
    // Independent xmlsec library section - end

  finally
    if Doc <> nil then
      xmlFreeDoc(Doc);
    if keyInfoCtx <> nil then
      xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil then
      xmlSecKeyDestroy(secKey);
  end;
{$ENDIF}
end;

procedure TEETSigner.InitXMLSec;
begin
  if EETSignerCount > 1 then
    Exit;
{$IFNDEF USE_LIBEET}
  xmlInitParser();
  __xmlLoadExtDtdDefaultValue^ := XML_DETECT_IDS or XML_COMPLETE_ATTRS;
  xmlSubstituteEntitiesDefault(1);
  __xmlIndentTreeOutput^ := 0; // don't format XML elements

  xmlSecBase64SetDefaultLineSize(0); // for single line SignatureValue

  if (xmlSecInit() < 0) then
    raise EEETSignerException.Create(sSignerXmlSecInitError);

  if (xmlSecCheckVersionExt(1, 2, 18, xmlSecCheckVersionABICompatible) <> 1) then
    raise EEETSignerException.Create(sSignerInitWrongDll);

  if (xmlSecCryptoDLLoadLibrary('openssl') < 0) then
    raise EEETSignerException.Create(sSignerInitNoXmlsecOpensslDll);
  // if (xmlSecCryptoDLLoadLibrary('mscrypto') < 0)
  // then raise EEETSignerException.Create(sSignerInitNoXmlsecMSCryptoDll);

  if (xmlSecCryptoAppInit(nil) < 0) then
    raise EEETSignerException.Create(sSignerXmlSecInitError);

  if (xmlSecCryptoInit() < 0) then
    raise EEETSignerException.Create(sSignerXmlSecInitError);
{$ELSE}
  if not InitLibEETSigner('') then
    raise EEETSignerException.Create(sSignerLibEETInitLibError);
  if (eetSignerInit < 0) then
    raise EEETSignerException.Create(sSignerLibEETSignerInitError);
{$ENDIF}
end;

procedure TEETSigner.LoadPFXCertFromFile(const PFXFileName: TFileName; const CertPassword: AnsiString);
begin
  CheckInactive;
  if CertPassword = '' then
    raise EEETSignerException.Create(sSignerNoPassword);
  FPFXStream.Clear;
  FPFXStream.LoadFromFile(PFXFileName);
  FCertPassword := CertPassword;
end;

procedure TEETSigner.LoadPFXCertFromStream(PFXStream: TStream; const CertPassword: AnsiString);
begin
  CheckInactive;
  if CertPassword = '' then
    raise EEETSignerException.Create(sSignerNoPassword);
  FPFXStream.Clear;
  FPFXStream.LoadFromStream(PFXStream);
  FCertPassword := CertPassword;
end;

function TEETSigner.MakeBKP(const Data: string): String;
{$IFNDEF USE_LIBEET}
var
  buf: AnsiString;
  I: integer;
{$ENDIF}
{$IFNDEF USE_LIBEET}
  function FormatBKP(Value: string): string;
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
  function String2Hex(const Buffer: AnsiString): string;
  var
    n: integer;
  begin
    Result := '';
    for n := 1 to Length(Buffer) do
      Result := LowerCase(Result + IntToHex(Ord(Buffer[n]), 2));
  end;
{$IFNDEF USE_SYNACODE}
  function _SHA1(const Buffer: AnsiString): AnsiString;
  var
    ctx: pEVP_MD_CTX;
    res, md_size: integer;
    digest_len: cardinal;
    digest: AnsiString;
  begin
    Result := '';
    SetLength(digest, EVP_MAX_MD_SIZE);
    res := 0;
    digest_len := Length(digest);
    // EVP_MD_CTX_create alternative
    ctx := OPENSSL_malloc(sizeof(ctx^));
    if ctx <> nil then
      begin
        EETSigner_EVP_MD_CTX_init(ctx);
        if (1 = EETSigner_EVP_DigestInit_ex(ctx, EVP_sha1(), nil)) then
          begin
            if (1 = EETSigner_EVP_DigestUpdate(ctx, PAnsiChar(Buffer), Length(Buffer))) then
              begin
                if (1 = EETSigner_EVP_DigestFinal_ex(ctx, PAnsiChar(digest), digest_len)) then
                else
                  res := -3
              end
            else
              res := -2;
          end
        else
          res := -1;
        if res = 0 then
          begin
            md_size := ctx.digest.md_size;
            SetLength(Result, md_size);
            Result := {$IF CompilerVersion >= 23.0 }AnsiStrings.{$IFEND}StrLCopy(PAnsiChar(Result), PAnsiChar(digest), md_size);
          end;
        // EVP_MD_CTX_destroy alternative
        EETSigner_EVP_MD_CTX_cleanup(ctx);
        OPENSSL_free(ctx);
      end;
  end;
{$ENDIF}
{$ENDIF}

begin
{$IFNDEF USE_LIBEET}
  Result := '';
  // generovat PKP
  buf := SignString(Data);
  if Length(buf) > 0 then
    begin
      // generate BKP from original signing string
      Result := FormatBKP(string(String2Hex({$IFNDEF USE_SYNACODE}_SHA1{$ELSE}SHA1{$ENDIF}(buf))));
    end;
{$ELSE}
    Result := eetSignerMakeBKP(FMngr, Data);
{$ENDIF}
end;

function TEETSigner.MakePKP(const Data: string): String;
{$IFNDEF USE_LIBEET}
var
  buf: AnsiString;
  function _EncodeBase64(Buffer: AnsiString): AnsiString;
  var
    resPtr: xmlCharPtr;
  begin
    resPtr := xmlSecBase64Encode(xmlSecBytePtr(Buffer), Length(Buffer), 0);
    Result := '';
    if resPtr <> nil then
      begin
        Result := AnsiString(resPtr);
        xmlFree(resPtr);
      end;
  end;
{$ENDIF}

begin
{$IFNDEF USE_LIBEET}
  Result := '';
  // generovat PKP
  buf := SignString(Data);
  if Length(buf) > 0 then
    begin
      Result := string(_EncodeBase64(buf));
    end;
{$ELSE}
  Result := eetSignerMakePKP(FMngr, Data);
{$ENDIF}
end;

{$IFNDEF USE_LIBEET}

procedure TEETSigner.AddBSTCert(aValue: AnsiString);
var
  certstring: AnsiString;
  secKey, tmpkey, secKeyNew: xmlSecKeyPtr;
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  store: xmlSecKeyStorePtr;
  list: xmlSecPtrListPtr;
  size, Pos: xmlSecSize;
{$IFDEF DEBUG}
  keysfilename: AnsiString;
{$ENDIF}
  function xmlSecKeyStoreCheckSize(store: xmlSecKeyStorePtr; size: xmlSecSize): Boolean;
  begin
    Result := (store^.id.objSize >= size);
  end;

  function xmlSecSimpleKeysStoreGetList(store: xmlSecKeyStorePtr): xmlSecPtrListPtr;
  begin
    Result := nil;
    if xmlSecKeyStoreCheckSize(store, sizeof(xmlSecKeyStore) + sizeof(xmlSecPtrList)) then
      begin
        Result := xmlSecPtrListPtr(Pointer(NativeInt(xmlSecBytePtr(store)) + sizeof(xmlSecKeyStore)));
      end;
  end;

begin
  CheckActive;
  certstring := AnsiString('-----BEGIN CERTIFICATE----- ') + #10;
  certstring := certstring + aValue + #10;
  certstring := certstring + AnsiString('-----END CERTIFICATE-----') + #10;

  keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
  if keyInfoCtx = nil then
    raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate - BSTCert']);

  secKey := xmlSecKeysMngrFindKey(FMngr, RESPONSECERT_KEYNAME, keyInfoCtx);

  try
    secKeyNew := xmlSecCryptoAppKeyLoadMemory(Pointer(certstring), xmlSecSize(Length(certstring)), xmlSecKeyDataFormatCertPem,
      nil, nil, nil);

    if secKeyNew = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecCryptoAppKeyLoadMemory - BSTCert']);

    if xmlSecKeySetName(secKeyNew, RESPONSECERT_KEYNAME) <> 0 then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeySetName - BSTCert']);

    if secKey = nil then
      begin
        if (xmlSecCryptoAppDefaultKeysMngrAdoptKey(FMngr, secKeyNew) <> 0) then
          raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['xmlSecCryptoAppDefaultKeysMngrAdoptKey - BSTCert']);
      end
    else
      begin
        store := xmlSecKeysMngrGetKeysStore(FMngr);
        list := xmlSecSimpleKeysStoreGetList(store);
        size := xmlSecPtrListGetSize(list);
        for Pos := 0 to size - 1 do
          begin
            tmpkey := xmlSecKeyPtr(xmlSecPtrListGetItem(list, Pos));
            if ((tmpkey <> nil) and (xmlSecKeyMatch(tmpkey, RESPONSECERT_KEYNAME, Pointer(Addr(keyInfoCtx.keyReq))) = 1)) then
              begin
                if xmlSecKeyCopy(tmpkey, secKeyNew) < 0 then
                  raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyCopy - BSTCert - replace']);
                if xmlSecKeySetName(tmpkey, RESPONSECERT_KEYNAME) <> 0 then
                  raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeySetName - BSTCert - replace'])
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
  keysfilename := 'keys-response.xml';
  if xmlSecCryptoAppDefaultKeysMngrSave(FMngr, @keysfilename[1], $FFFF) < 0 then
    raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
{$ENDIF}
end;
{$ENDIF}

function TEETSigner.AddTrustedCertFromFileName(const CerFileName: TFileName): integer;
var
  Stream: TMemoryStream;
begin
  CheckInactive;
  Stream := TMemoryStream.Create;
  Stream.LoadFromFile(CerFileName);
  Result := FCERTrustedList.AddCert(Stream);
end;

function TEETSigner.AddTrustedCertFromStream(const CerStream: TStream): integer;
var
  Stream: TMemoryStream;
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
  ItemCount, I: integer;
  DataItem: xmlSecKeyDataPtr;
  x509cert: pX509;
  a_time: TDateTime;
  a_serialnumber: string;
  a_subject: string;
  a_issuername: string;
{$ELSE}
  x509cert: libeetX509Ptr;
  a_time, b_time: TDateTime;
{$ENDIF}
begin
  CheckActive;
{$IFNDEF USE_LIBEET}
  keyInfoCtx := nil;
  secKey := nil;
  try
    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate']);

    secKey := xmlSecKeysMngrFindKey(FMngr, PFXCERT_KEYNAME, keyInfoCtx);
    if secKey = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeysMngrFindKey']);

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
              if Copy(FPrivKeyInfo.CommonName, 1, 2) = 'CZ' then
                begin
                  FPrivKeyInfo.Name := 'p';
                  if xmlSecOpenSSLX509CertGetTime(X509_get_notBefore(x509cert), a_time) = 0 then
                    FPrivKeyInfo.notValidBefore := a_time;
                  if xmlSecOpenSSLX509CertGetTime(X509_get_notAfter(x509cert), a_time) = 0 then
                    FPrivKeyInfo.notValidAfter := a_time;
                  if xmlSecOpenSSLX509CertGetSerialNumber(X509_get_serialNumber(x509cert), a_serialnumber) = 0 then
                    FPrivKeyInfo.SerialNumber := a_serialnumber;
                  if xmlSecOpenSSLX509CertGetX509Name(X509_get_issuer_name(x509cert), a_issuername) = 0 then
                    FPrivKeyInfo.IssuerName := a_issuername;
                  Break;
                end;
          end;
      end;

    FPrivKeyInfo.Name := String(secKey.Name);
  finally
    if keyInfoCtx <> nil then
      xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil then
      xmlSecKeyDestroy(secKey);
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
  ItemCount, I: integer;
  DataItem: xmlSecKeyDataPtr;
  x509cert: pX509;
  a_time: TDateTime;
  a_serialnumber: string;
  a_subject: string;
  a_issuername: string;
{$ELSE}
  x509cert: libeetX509Ptr;
  a_time, b_time: TDateTime;
{$ENDIF}
begin
  CheckActive;
{$IFNDEF USE_LIBEET}
  keyInfoCtx := nil;
  secKey := nil;
  try
    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate']);

    secKey := xmlSecKeysMngrFindKey(FMngr, RESPONSECERT_KEYNAME, keyInfoCtx);
    if secKey = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeysMngrFindKey']);

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
    FResponseCertInfo.Name := String(secKey.Name);
  finally
    if keyInfoCtx <> nil then
      xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil then
      xmlSecKeyDestroy(secKey);
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
  secKey, tmpkey: xmlSecKeyPtr;
  keyInfoCtx: xmlSecKeyInfoCtxPtr;
  store: xmlSecKeyStorePtr;
  list: xmlSecPtrListPtr;
  size, Pos: xmlSecSize;
{$IFDEF DEBUG}
  keysfilename: AnsiString;
{$ENDIF}
  function xmlSecKeyStoreCheckSize(store: xmlSecKeyStorePtr; size: xmlSecSize): Boolean;
  begin
    Result := (store^.id.objSize >= size);
  end;

  function xmlSecSimpleKeysStoreGetList(store: xmlSecKeyStorePtr): xmlSecPtrListPtr;
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
  if keyInfoCtx = nil then
    raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate - BSTCert']);

  secKey := xmlSecKeysMngrFindKey(FMngr, RESPONSECERT_KEYNAME, keyInfoCtx);

  try
    if secKey <> nil then
      begin
        store := xmlSecKeysMngrGetKeysStore(FMngr);
        list := xmlSecSimpleKeysStoreGetList(store);
        size := xmlSecPtrListGetSize(list);
        for Pos := 0 to size - 1 do
          begin
            tmpkey := xmlSecKeyPtr(xmlSecPtrListGetItem(list, Pos));
            if ((tmpkey <> nil) and (xmlSecKeyMatch(tmpkey, RESPONSECERT_KEYNAME, Pointer(Addr(keyInfoCtx.keyReq))) = 1)) then
              begin
                if xmlSecPtrListRemove(list, Pos) < 0 then
                  raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecPtrListRemove - BSTCert']);
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
  keysfilename := 'keys-response-BSTremoved.xml';
  if xmlSecCryptoAppDefaultKeysMngrSave(FMngr, @keysfilename[1], $FFFF) < 0 then
    raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
{$ENDIF}
end;
{$ENDIF}

procedure TEETSigner.SetActive(const Value: Boolean);
var
  ms: TMemoryStream;
  I: integer;
{$IFNDEF USE_LIBEET}
  Key: xmlSecKeyPtr;
{$IFDEF DEBUG}
  keysfilename: AnsiString;
{$ENDIF}
  certkeyformat: xmlSecKeyDataFormat;
  certkeystring: AnsiString;
{$ELSE}
{$ENDIF}
begin
  if Active = Value then
    Exit;

{$IFNDEF USE_LIBEET}
  Key := nil;
{$ENDIF}
  if FActive // if active, so do clean
  then
    begin
      FCertPassword := '';
{$IFNDEF USE_LIBEET}
      if FMngr <> nil then
        begin
          xmlSecKeysMngrDestroy(FMngr);
          FMngr := nil;
        end;
      FreeXMLSecOpenSSL;
{$ELSE}
      if FMngr <> nil then
        begin
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
  if not InitXMLSecOpenSSL then
    raise EEETSignerException.Create(sSignerInitNoXmlsecOpensslDll);
{$ENDIF}
  if FCertPassword = '' // No password filled
  then
    raise EEETSignerException.Create(sSignerNoPassword);

  try
    try
{$ASSERTIONS ON}
{$BOOLEVAL OFF}
      if FPFXStream.size > 0 then
        begin
          ClearCertInfo(FPrivKeyInfo);
          ClearCertInfo(FResponseCertInfo);

{$IFNDEF USE_LIBEET}
          FMngr := xmlSecKeysMngrCreate();
          if (FMngr = nil) or (xmlSecCryptoAppDefaultKeysMngrInit(FMngr) <> 0) then
            raise EEETSignerException.Create(sSignerKeyMngrCreateFail);

          Key := xmlSecCryptoAppKeyLoadMemory(FPFXStream.Memory, FPFXStream.size, xmlSecKeyDataFormatPkcs12,
            Pointer(FCertPassword), nil, nil);
          if (Key = nil) then
            raise EEETSignerException.Create(sSignerInvalidPFXCert);
          if xmlSecKeySetName(Key, PFXCERT_KEYNAME) <> 0 then
            Assert(False);
          Key.usage := 1;

          if (xmlSecCryptoAppDefaultKeysMngrAdoptKey(FMngr, Key) <> 0) then
            raise EEETSignerException.Create(sSignerInvalidPFXCert)
          else
            Key := nil;
{$ELSE}
          FMngr := eetSignerKeysMngrCreate();
          if (FMngr = nil) then
            raise EEETSignerException.Create(sSignerKeyMngrCreateFail);

          if (eetSignerLoadPFXKeyMemory(FMngr, FPFXStream.Memory, FPFXStream.size, string(FCertPassword)) < 0) then
            raise EEETSignerException.Create(sSignerInvalidPFXCert);
{$ENDIF}
        end
      else
        raise EEETSignerException.Create(sSignerInvalidPFXCert);

      // load verify certificate
      if FCERTrustedList.Count > 0 then
        begin
{$IFNDEF USE_LIBEET}
          certkeyformat := xmlSecKeyDataFormatCertDer;
{$ENDIF}
          for I := 0 to FCERTrustedList.Count - 1 do
            begin
              ms := FCERTrustedList.GetStream(I);
{$IFNDEF USE_LIBEET}
              SetLength(certkeystring, ms.size);
              ms.Seek(0, soFromBeginning);
              ms.Read(PAnsiChar(certkeystring)^, ms.size);
              ms.Seek(0, soFromBeginning);
              if Pos(AnsiString('-BEGIN CERTIFICATE-'), certkeystring) > 0 then
                certkeyformat := xmlSecKeyDataFormatCertPem;

              if xmlSecCryptoAppKeysMngrCertLoadMemory(FMngr, ms.Memory, ms.size, certkeyformat,
                $100 { xmlSecKeyDataTypeTrusted } ) < 0 then
                begin
                  FVerifyCertIncluded := False;
                  raise EEETSignerException.Create(sSignerInvalidVerifyCert)
                end
{$ELSE}
              if (eetSignerAddTrustedCertMemory(FMngr, ms.Memory, ms.size) < 0) then
                begin
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
      keysfilename := 'keys.xml';
      if xmlSecCryptoAppDefaultKeysMngrSave(FMngr, @keysfilename[1], $FFFF) < 0 then
        raise EEETSignerException.CreateFmt('Error: failed to save keys to "%s"', [String(keysfilename)]);
{$ENDIF}
{$ENDIF}
      ReadPrivKeyCertInfo;
    except
      FActive := False;
      FVerifyCertIncluded := False;
{$IFNDEF USE_LIBEET}
      if Key <> nil then
        xmlSecKeyDestroy(Key);
      if FMngr <> nil then
        begin
          xmlSecKeysMngrDestroy(FMngr);
          FMngr := nil;
        end;
{$ELSE}
      if FMngr <> nil then
        begin
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
  bufSz: integer;
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
    if xmlSecTransformCtxInitialize(TransCtx) <> 0 then
      raise EEETSignerException.Create(sSignerTransformCtxFail);

    keyInfoCtx := xmlSecKeyInfoCtxCreate(FMngr);
    if keyInfoCtx = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeyInfoCtxCreate']);

    secKey := xmlSecKeysMngrFindKey(FMngr, PFXCERT_KEYNAME, keyInfoCtx);
    if secKey = nil then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecKeysMngrFindKey']);

    transId := xmlSecTransformRsaSha256GetKlass();

    TransMethod := xmlSecTransformCtxCreateAndAppend(TransCtx, transId);
    if TransMethod = nil then
      raise EEETSignerException.Create(sSignerTransformCtxFail);
    TransMethod.operation := xmlSecTransformOperationSign;

    if xmlSecTransformSetKey(TransMethod, secKey) <> 0 then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecTransformSetKey']);

    if xmlSecTransformCtxPrepare(TransCtx, 1) <> 0 then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecTransformCtxPrepare']);

    if xmlSecTransformDefaultPushBin(TransCtx.first, Pointer(buf), bufSz, 1, TransCtx) <> 0 then
      raise EEETSignerException.CreateFmt(sSignerSignFail, ['xmlSecTransformDefaultPushBin']);

    if TransCtx.Result.size <> SIGSIZE
    // potpis je uvijek SIGSIZE (256 byte) velièine
    then
      raise EEETSignerException.CreateFmt(sSignerUnexpectedSignature, [TransCtx.Result.size]);

    SetLength(Result, SIGSIZE);
    Move(TransCtx.Result.Data^, Result[1], TransCtx.Result.size);
  finally
    xmlSecTransformCtxFinalize(TransCtx);
    Dispose(TransCtx);
    if keyInfoCtx <> nil then
      xmlSecKeyInfoCtxDestroy(keyInfoCtx);
    if secKey <> nil then
      xmlSecKeyDestroy(secKey);
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
  buf: PUTF8String;
  bufSz: integer;
  erCode: integer;
  DSigCtx: xmlSecDSigCtxPtr;
{$ELSE}
  output: AnsiString;
{$ENDIF}
{$IFNDEF USE_LIBEET}
  procedure RegisterID(xmlNode: xmlNodePtr; idName: xmlCharPtr);
  var
    attr: xmlAttrPtr;
    tmp: xmlAttrPtr;
    Name: xmlCharPtr;
  begin
    { * find pointer to id attribute * }
    attr := xmlHasProp(xmlNode, idName);
    if ((attr = nil) or (attr.children = nil)) then
      Exit;

    { * get the attribute (id) value * }
    name := xmlNodeListGetString(xmlNode.Doc, attr.children, 1);
    if (name = nil) then
      Exit;

    { * check that we don't have that id already registered * }
    tmp := xmlGetID(xmlNode.Doc, name);
    if (tmp <> nil) then
      begin
        xmlFree(name);
        Exit;
      end;

    { * finally register id * }
    xmlAddID(nil, xmlNode.Doc, name, attr);

    { * and do not forget to cleanup * }
    xmlFree(name);
  end;
{$ENDIF}

begin
  CheckActive;

{$BOOLEVAL OFF}
  if (XMLStream = nil) or (XMLStream.size = 0) then
    raise EEETSignerException.Create(sSignerEmptyXML);

{$IFNDEF USE_LIBEET}
  Doc := nil; { Node := nil; }
  DSigCtx := xmlSecDSigCtxCreate(FMngr);
  try
    buf := nil;
    bufSz := 0;

    Doc := xmlSecParseMemory(XMLStream.Memory, XMLStream.size, 0);
    Assert(Doc <> nil);

    Node := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeSignature()), xmlCharPtr(xmlSecDSigNs()));
    Assert(Node <> nil);

    BodyNode := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeBody), xmlCharPtr(xmlSecSoap11Ns));
    Assert(BodyNode <> nil);

    RegisterID(BodyNode, 'Id');
    // kvuli node:Reference failed zaregistrovat hodnotu wsu:Id jako Id

    DSigCtx.keyInfoWriteCtx.base64LineSize := 0;

    erCode := xmlSecDSigCtxSign(DSigCtx, Node);
    Result := erCode = 0;
    Assert(erCode = 0);

    if Result then
      begin
        xmlDocDumpMemory(Doc, @buf, @bufSz);
        XMLStream.SetSize(bufSz);
        XMLStream.Position := 0;
        if bufSz > 0 then
          XMLStream.WriteBuffer(buf^, bufSz);
        xmlFree(buf);
      end;
  finally
    if Doc <> nil then
      xmlFreeDoc(Doc);
    xmlSecDSigCtxDestroy(DSigCtx);
  end;
{$ELSE}
  Result := (eetSignerSignRequest(FMngr, XMLStream.Memory, XMLStream.size, output) = 0);
  if Result then
    begin
      XMLStream.SetSize(Length(output));
      XMLStream.Position := 0;
      XMLStream.WriteBuffer(PAnsiChar(output)^, Length(output));
    end;
{$ENDIF}
end;

function TEETSigner.VerifyXML(XMLStream: TMemoryStream; const SignedNodeName, IdProp: UTF8String): Boolean;
{$IFNDEF USE_LIBEET}
var
  Doc: xmlDocPtr;
  Node, SignatureNode: xmlNodePtr;
  BSTNode: xmlNodePtr;
  KeyInfoNode, x509Data, x509Certificate: xmlNodePtr;
  DSigCtx: xmlSecDSigCtxPtr;
  attr: xmlAttrPtr;
  IdVal: xmlCharPtr;
{$ENDIF}
begin
  CheckActive;
  ClearCertInfo(FResponseCertInfo);
{$IFNDEF USE_LIBEET}
  RemoveBSTCert;
  Doc := nil;
  DSigCtx := nil; { Attr := nil; }
  Result := False;
  try
    Doc := xmlSecParseMemory(xmlSecBytePtr(XMLStream.Memory), XMLStream.size, 0);
    if Doc = nil then
      raise EEETXMLException.Create(sXMLNotXML);

    if SignedNodeName <> '' then
      begin
        // add Id Atrribute for reference
        Node := xmlSecFindNode(xmlDocGetRootElement(Doc), PAnsiChar(SignedNodeName), PAnsiChar(FISKXML_TNSSCHEMA_URI));
        if Node = nil then
          Node := xmlSecFindNode(xmlDocGetRootElement(Doc), PAnsiChar(SignedNodeName), PAnsiChar(xmlSecSoap11Ns));
        if Node <> nil then
          begin
            attr := xmlHasProp(Node, PAnsiChar(IdProp));
            if attr <> nil then
              begin
                IdVal := xmlGetProp(Node, PAnsiChar(IdProp));
                xmlAddID(nil, Doc, IdVal, attr);
              end;
          end;
      end;

    BSTNode := xmlSecFindNode(xmlDocGetRootElement(Doc), PAnsiChar('BinarySecurityToken'),
      PAnsiChar('http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'));

    SignatureNode := xmlSecFindNode(xmlDocGetRootElement(Doc), xmlCharPtr(xmlSecNodeSignature), xmlCharPtr(xmlSecDSigNs));
    if SignatureNode <> nil then
      begin
        DSigCtx := xmlSecDSigCtxCreate(FMngr);
        Assert(DSigCtx <> nil);

        if (BSTNode <> nil) then
          begin
            attr := xmlHasProp(BSTNode, PAnsiChar(IdProp));
            if attr <> nil then
              begin
                IdVal := xmlGetProp(BSTNode, PAnsiChar(IdProp));
                xmlAddID(nil, Doc, IdVal, attr);
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
            if KeyInfoNode = nil then
              raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['KeyInfoNode']);

            x509Data := xmlSecTmplKeyInfoAddX509Data(KeyInfoNode);
            if x509Data = nil then
              raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['X509Data']);

            x509Certificate := xmlSecTmplX509DataAddCertificate(x509Data);
            if x509Certificate = nil then
              raise EEETSignerException.CreateFmt(sSignerVerifyFail, ['X509Certificate']);

            xmlNodeSetContent(x509Certificate, xmlNodeGetContent(BSTNode));
            xmlSecAddChildNode(x509Data, x509Certificate);
          end;

{$IFDEF DEBUG}
        _xmlDocDump(Doc, PAnsiChar(AnsiString('beforeverify.xml')));
{$ENDIF}
{$BOOLEVAL OFF}
        if (xmlSecDSigCtxVerify(DSigCtx, SignatureNode) = 0) then
          Result := (DSigCtx^.status = xmlSecDSigStatusSucceeded);
        if Result then
          AddBSTCert(xmlNodeGetContent(BSTNode));
      end;

  finally
    if Doc <> nil then
      xmlFreeDoc(Doc);
    if DSigCtx <> nil then
      xmlSecDSigCtxDestroy(DSigCtx);
  end;
{$ELSE}
  Result := (eetSignerVerifyResponse(FMngr, XMLStream.Memory, XMLStream.size) = 1);
{$ENDIF}
  if Result then
    ReadResponseCertInfo;
end;

{ TCERTrustedList }

function TCERTrustedList.AddCert(Stream: TMemoryStream): integer;
begin
  Result := -1;
  if Stream = nil then
    Exit;
  Result := Add(Stream);
end;

function TCERTrustedList.GetStream(Index: integer): TMemoryStream;
begin
  Result := TMemoryStream(Get(Index));
end;

procedure TCERTrustedList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
    TMemoryStream(Ptr).Free;
end;

end.
