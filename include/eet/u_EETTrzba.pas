unit u_EETTrzba;

interface
{$IFNDEF UNICODE}
{$DEFINE LEGACY_RIO}
{$ENDIF}
uses
  Windows, SysUtils, Classes, InvokeRegistry, Rio, SOAPHTTPClient, Types, XSBuiltIns,
  SOAPHTTPTrans, WebNode, {OpConvertOptions,} OPToSOAPDomConv, SOAPEnv,
  {$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
    IdHTTP, IdCookie, IdCookieManager, IdHeaderList, IdURI, IdComponent, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  {$ELSE}
     WinInet,
  {$IFEND}
  ActiveX, u_EETServiceSOAP, XMLDoc, XMLIntf, u_EETSigner;

type
  TEETTrzba = class;

  TEETRIO = class(THTTPRIO)
  private
    FEET: TEETTrzba;
  protected
    {$IFDEF USE_INDY}
    FIdCookieManager : TIdCookieManager;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    {$ENDIF}
    procedure HTTPWebNode_BeforePost(const AHTTPReqResp: THTTPReqResp; AData: Pointer);
    {$IFDEF LEGACY_RIO}
    procedure HTTPRIO_BeforeExecute(const MethodName: string;
      var SOAPRequest: InvString);
    {$ELSE}
    procedure HTTPRIO_BeforeExecute(const MethodName: string;
      SOAPRequest: TStream);
    {$ENDIF}
    procedure HTTPRIO_AfterExecute(const MethodName: string;
      SOAPResponse: TStream);
    {$IFNDEF USE_INDY}
    function DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property EET : TEETTrzba read FEET write FEET;
  end;

  TEETTrzba = class(TComponent)
  private
    FEETService : EET;
{$IF Defined(USE_DIRECTINDY)}
    FIdHttpClient : TIdHTTP;
{$IFEND}
    FOnBeforeSendRequest: TBeforeExecuteEvent;
    FOnAfterSendRequest: TAfterExecuteEvent;
    FConnectTimeout: Integer;
    FReceiveTimeout: Integer;
    FValidResponse: Boolean;
    FSendTimeout: Integer;
    FErrorCode: Integer;
    FErrorMessage: string;
{$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
    FOnVerifyPeer: TVerifyPeerEvent;
{$IFEND}
    FRootCertFile: string;
    FHttpsTrustName: string;
    FProxyPort: integer;
    FProxyPassword: string;
    FProxyHost: string;
    FProxyUsername: string;
    FUseProxy: boolean;
    FRequestStream: TMemoryStream;
    FResponseStream: TMemoryStream;
  protected
    IsInitialized: boolean;
    FSigner : TEETSigner;
    FPFXStream : TMemoryStream;
    FPFXPassword : string;
    FCERTrustedList : TCERTrustedList;
    function GetEETRIO : TEETRIO;
    procedure SignMessage(SOAPRequest: TStream);
    procedure ValidateResponse(SOAPResponse: TStream);
{$IFNDEF USE_LIBEET}
    procedure InsertWsse(ParentNode : IXMLNode);
{$ENDIF}
  public
    URL: string;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    function NewTrzba : Trzba;
    function SignTrzba(const parameters: Trzba): Boolean;
    function OdeslaniTrzby(const parameters: Trzba; SendOnly : Boolean = false; aTimeOut : Integer = 0): Odpoved;
    {$IF Defined(USE_DIRECTINDY)}
    function OdeslaniTrzbyDirectIndy(const parameters: Trzba; SendOnly : Boolean = false): Odpoved;
    {$IFEND}
    function HasVarovani(Odpoved : OdpovedType) : Boolean;
    procedure SaveToXML(const parameters: Trzba; const DestStream : TStream);
    procedure LoadFromXML(const parameters: Trzba; const SourceStream : TStream);
    function AddTrustedCertFromFileName(const CerFileName: TFileName) : integer;
    function AddTrustedCertFromStream(const CerStream: TStream) : integer;
{$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
    function DoVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
{$IFEND}
  published
    property PFXStream : TMemoryStream read FPFXStream;
    property PFXPassword : string read FPFXPassword write FPFXPassword;
    property RootCertFile : string read FRootCertFile write FRootCertFile;
    property HttpsTrustName : string read FHttpsTrustName write FHttpsTrustName;
    property ConnectTimeout : Integer read FConnectTimeout write FConnectTimeout;
    property SendTimeout : Integer read FSendTimeout write FSendTimeout;
    property ReceiveTimeout : Integer read FReceiveTimeout write FReceiveTimeout;
    property UseProxy : boolean read FUseProxy write FUseProxy;
    property ProxyHost : string read FProxyHost write FProxyHost;
    property ProxyPort : integer read FProxyPort write FProxyPort;
    property ProxyUsername : string read FProxyUsername write FProxyUsername;
    property ProxyPassword : string read FProxyPassword write FProxyPassword;
    property ValidResponse : Boolean read FValidResponse;
    property ErrorCode : Integer read FErrorCode;
    property ErrorMessage : string read FErrorMessage;
    property OnBeforeSendRequest : TBeforeExecuteEvent read FOnBeforeSendRequest write FOnBeforeSendRequest;
    property OnAfterSendRequest : TAfterExecuteEvent read FOnAfterSendRequest write FOnAfterSendRequest;
    property Signer : TEETSigner read FSigner;
    property RequestStream : TMemoryStream read FRequestStream;
    property ResponseStream : TMemoryStream read FResponseStream;
{$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
    property OnVerifyPeer : TVerifyPeerEvent read FOnVerifyPeer write FOnVerifyPeer;
{$IFEND}
  end;

  TEETTrzbaThread = class(TThread)
  private
    FEET: EET;
    FErrorCode: Integer;
    FErrorMessage: String;
    FOdpoved: Odpoved;
    FTrzba: Trzba;
  public
    procedure Execute; override;
    property EET : EET read FEET write FEET;
    property ETrzba : Trzba read FTrzba write FTrzba;
    property EETOdpoved : Odpoved read FOdpoved;
    property ErrorCode : Integer read FErrorCode;
    property ErrorMessage : String read FErrorMessage;
  end;

implementation

uses StrUtils,
{$IFNDEF USE_LIBEET}
   u_wsse, u_wsse_utils, u_xmldsigcoreschema, SOAPConst,
{$ENDIF}
   DateUtils{, TimeSpan};

{$IFNDEF USE_INDY}
function GetWinInetError(ErrorCode:Cardinal): string;
const
   winetdll = 'wininet.dll';
var
  Len: Integer;
  Buffer: PChar;
begin
  Len := FormatMessage(
  FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or
  FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or  FORMAT_MESSAGE_ARGUMENT_ARRAY,
  Pointer(GetModuleHandle(winetdll)), ErrorCode, 0, @Buffer, SizeOf(Buffer), nil);
  try
    while (Len > 0) and {$IFDEF UNICODE}(CharInSet(Buffer[Len - 1], [#0..#32, '.'])) {$ELSE}(Buffer[Len - 1] in [#0..#32, '.']) {$ENDIF} do Dec(Len);
    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;
{$ENDIF}

function TEETTrzba.AddTrustedCertFromFileName(const CerFileName: TFileName): integer;
var
  Stream : TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  Stream.LoadFromFile(CerFileName);
  Result := FCERTrustedList.AddCert(Stream);
end;

function TEETTrzba.AddTrustedCertFromStream(const CerStream: TStream): integer;
var
  Stream : TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  Stream.LoadFromStream(CerStream);
  Result := FCERTrustedList.AddCert(Stream);
end;

constructor TEETTrzba.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsInitialized:=false;
  CoInitialize(nil);
  FEETService := nil;
{$IF Defined(USE_DIRECTINDY)}
  FIdHttpClient := TIdHTTP.Create(nil);
  FIdHttpClient.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(FIdHttpClient);
{$IFEND}
  FSigner := TEETSigner.Create(nil);
  FPFXPassword := '';
  FPFXStream := TMemoryStream.Create;
  FCERTrustedList := TCERTrustedList.Create;
  FHttpsTrustName := 'www.eet.cz';
  FConnectTimeout := 2000;
  FSendTimeout := 3000;
  FReceiveTimeout := 3000;
  FUseProxy := False;
  FProxyHost := '';
  FProxyPort := 3128;
  FProxyUsername := '';
  FProxyPassword := '';
  FRequestStream := TMemoryStream.Create;
  FResponseStream := TMemoryStream.Create;
end;

destructor TEETTrzba.Destroy;
begin
{$IF Defined(USE_DIRECTINDY)}
  FIdHttpClient.Free;
{$IFEND}
  FRequestStream.Free;
  FResponseStream.Free;
  FSigner.Free;
  FCERTrustedList.Free;
  FPFXStream.Free;
  CoUnInitialize;
  inherited;
end;

{$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
function TEETTrzba.DoVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
var
  TempList: TStringList;
  Cn: String;
begin
//  Result := AOk;

  // check range validity
  Result := CompareDateTime(Certificate.notBefore, Now) = CompareDateTime(Now, Certificate.notAfter);
  if Result and (FHttpsTrustName <> '') and (ADepth = 0) then
    begin
      // check common name by HtttpTrustName
      Cn := '';
      TempList:= TStringList.Create;
      try
        TempList.Delimiter := '/';
        TempList.DelimitedText := Certificate.Subject.OneLine;
        Cn := Trim(TempList.Values['CN']);
      finally
        TempList.Free;
      end;
      Result := SameText(Cn, FHttpsTrustName)
    end;
  if Result and Assigned(FOnVerifyPeer) then Result := FOnVerifyPeer(Certificate, Result, ADepth, AError);
end;
{$IFEND}

function TEETTrzba.GetEETRIO: TEETRIO;
begin
  Result := TEETRIO.Create(nil);
  Result.EET := self;
  Result.HTTPWebNode.ConnectTimeout := Self.ConnectTimeout;
  Result.HTTPWebNode.SendTimeout := Self.SendTimeout;
  Result.HTTPWebNode.ReceiveTimeout := Self.ReceiveTimeout;
  if (FProxyHost <> '') and FUseProxy then
    begin
      if FProxyPort > 0 then
        Result.HTTPWebNode.Proxy := Format('%s:%d',[FProxyHost, FProxyPort]) // 'server_ip:port'
      else
        Result.HTTPWebNode.Proxy := FProxyHost;
      Result.HTTPWebNode.Username := FProxyUsername;
      Result.HTTPWebNode.Password := FProxyPassword;
    end;
end;

function TEETTrzba.HasVarovani(Odpoved: OdpovedType): Boolean;
begin
  Result := False;
  if Odpoved = nil then exit;
  Result := Length(Odpoved.Varovani) > 0;
end;

procedure TEETTrzba.Initialize;
var
  I: Integer;
begin
  if IsInitialized then exit;

  if URL='' then
      raise Exception.Create('SOAP URL není vyplnìna !!!');

  if not FSigner.Active then
    begin
      if FPFXStream.Size > 0 then
        FSigner.LoadPFXCertFromStream(FPFXStream,AnsiString(FPFXPassword));
      for I := 0 to FCERTrustedList.Count - 1 do
        FSigner.AddTrustedCertFromStream(FCERTrustedList.GetStream(I));
      FSigner.Active := True;
    end;

  IsInitialized:=true;
end;

{$IFNDEF USE_LIBEET}
procedure TEETTrzba.InsertWsse(ParentNode: IXMLNode);
var
  SecHeader : IXMLSecurityHeaderType;
  Signature : IXMLSignatureType;
  SigReference : IXMLReferenceType;
  SigTransForm : IXMLTransformType;
  SecTokenReference : IXMLSecurityTokenReferenceType;
  SecReference : u_wsse.IXMLReferenceType;
begin
  // Security
  SecHeader := NewSecurity;
  SecHeader.OwnerDocument.Options := [doNodeAutoCreate];  // tohle zabrani pomalemu vytvareni ChildNodes.Add(???)
  SecHeader.Attributes['SOAP-ENV:mustUnderstand'] := '1';
  SecHeader.BinarySecurityToken.EncodingType := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
  SecHeader.BinarySecurityToken.ValueType := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3';
  SecHeader.BinarySecurityToken.Attributes['wsu:Id'] := 'id-TheCert';

  // Signature
  Signature := NewSignature;
  Signature.OwnerDocument.Options := [doNodeAutoCreate];
  Signature.SignedInfo.CanonicalizationMethod.Algorithm:='http://www.w3.org/2001/10/xml-exc-c14n#';
  Signature.Id := 'id-TheSignature';
  Signature.SignedInfo.CanonicalizationMethod.AddChild('ec:InclusiveNamespaces', 'http://www.w3.org/2001/10/xml-exc-c14n#').Attributes['PrefixList']:= 'soap';
  Signature.SignedInfo.SignatureMethod.Algorithm:='http://www.w3.org/2001/04/xmldsig-more#rsa-sha256';

  SigReference := Signature.SignedInfo.Reference.Add;
  SigReference.URI:='#id-TheBody';

  SigTransForm := SigReference.Transforms.Add;
  SigTransForm.Algorithm:='http://www.w3.org/2001/10/xml-exc-c14n#';
  SigTransForm.AddChild('ec:InclusiveNamespaces', 'http://www.w3.org/2001/10/xml-exc-c14n#').Attributes['PrefixList']:='';

  SigReference.DigestMethod.Algorithm:='http://www.w3.org/2001/04/xmlenc#sha256';
  SigReference.DigestValue:='';

  Signature.SignatureValue.Text := '';

  // SecurityTokenReferenco pro KeyInfo;
  SecTokenReference := NewSecurityTokenReference;
  SecTokenReference.OwnerDocument.Options := [doNodeAutoCreate];
  SecTokenReference.Attributes['wsu:Id'] := 'id-TheSecurityTokenReference';

  SecReference :=  NewReference;
  SecReference.OwnerDocument.Options := [doNodeAutoCreate];
  SecReference.URI := '#id-TheCert';
  SecReference.ValueType := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3';

  Signature.KeyInfo.Id := 'TheKeyInfo';

  SecTokenReference.ChildNodes.Add(SecReference);
  Signature.KeyInfo.ChildNodes.Add(SecTokenReference);

  SecHeader.ChildNodes.Add(Signature);

  ParentNode.ChildNodes.Add(SecHeader);
end;
{$ENDIF}

procedure TEETTrzba.LoadFromXML(const parameters: Trzba; const SourceStream: TStream);
var
  Converter: IObjConverter;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML, XMLin: IXMLDocument;
begin
  XML := NewXMLDocument;
  XMLin := NewXMLDocument;
  XMLin.LoadFromStream(SourceStream);

  NodeRoot:= XML.AddChild('Root');
  NodeParent:= XMLin.DocumentElement;

  Converter:= TSOAPDomConv.Create(NIL);
  parameters.SOAPToObject(NodeRoot, NodeParent, Converter);
end;

function TEETTrzba.NewTrzba: Trzba;

  function Hexa(cislo: Integer): String;
  var vrat: String;
  begin
    vrat := IntToStr(cislo);
    if cislo = 10 then vrat := 'a';
    if cislo = 11 then vrat := 'b';
    if cislo = 12 then vrat := 'c';
    if cislo = 13 then vrat := 'd';
    if cislo = 14 then vrat := 'e';
    if cislo = 15 then vrat := 'f';
    Hexa := vrat;
  end;

  function NewGuid : string;
  var I : Integer;
  begin
    Result := '';
    Randomize;
    for I := 1 to 8 do Result := Result + Hexa(Round(Int(Random(16))));
    Result := Result + '-';
    for I := 1 to 4 do Result := Result + Hexa(Round(Int(Random(16))));
    Result := Result + '-4';
    for I := 1 to 3 do Result := Result + Hexa(Round(Int(Random(16))));
    Result := Result + '-';
    Result := Result + Hexa(8 + Round(Int(Random(4))));
    for I := 1 to 3 do Result := Result + Hexa(Round(Int(Random(16))));
    Result := Result + '-';
    for I := 1 to 12 do Result := Result + Hexa(Round(Int(Random(16))));
  end;
begin
  Result := Trzba.Create;
  Result.Hlavicka := TrzbaHlavickaType.Create;
  Result.Hlavicka.uuid_zpravy := NewGuid;
//  Result.Hlavicka.uuid_zpravy := TGuid.NewGuid.ToString;
//  Result.Hlavicka.uuid_zpravy := LowerCase(Copy(Result.Hlavicka.uuid_zpravy, 2, Length(Result.Hlavicka.uuid_zpravy)-2));

  Result.Hlavicka.dat_odesl := dateTime.Create;
  Result.Hlavicka.dat_odesl.UseZeroMilliseconds := false;


  Result.Hlavicka.prvni_zaslani := True;
  Result.Hlavicka.overeni := False;

  Result.Hlavicka.dat_odesl.AsDateTime := now;

  Result.Data := TrzbaDataType.Create;
  Result.Data.dat_trzby := dateTime.Create;
  Result.Data.dat_trzby.UseZeroMilliseconds := false;
  Result.Data.celk_trzba := CastkaType.Create;
  Result.Data.cerp_zuct := CastkaType.Create;
  Result.Data.cest_sluz := CastkaType.Create;
  Result.Data.dan1 := CastkaType.Create;
  Result.Data.dan2 := CastkaType.Create;
  Result.Data.dan3 := CastkaType.Create;
  Result.Data.pouzit_zboz1 := CastkaType.Create;
  Result.Data.pouzit_zboz2 := CastkaType.Create;
  Result.Data.pouzit_zboz3 := CastkaType.Create;
  Result.Data.urceno_cerp_zuct := CastkaType.Create;
  Result.Data.zakl_dan1 := CastkaType.Create;
  Result.Data.zakl_dan2 := CastkaType.Create;
  Result.Data.zakl_dan3 := CastkaType.Create;
  Result.Data.zakl_nepodl_dph := CastkaType.Create;

  // KontrolniKody prepare
  Result.KontrolniKody := TrzbaKontrolniKodyType.Create;
  Result.KontrolniKody.pkp := PkpElementType.Create;
  Result.KontrolniKody.bkp := BkpElementType.Create;
end;

function TEETTrzba.OdeslaniTrzby(const parameters: Trzba; SendOnly : Boolean; aTimeOut : Integer): Odpoved;
var
  Service : EET;
  TT : TEETTrzbaThread;
  h: tHandle;
  WaitResult: DWORD;
  Tmp : Cardinal;
begin
  FValidResponse := True;
  FErrorCode := 0;
  FErrorMessage := '';
  Result := nil;

  Service := GetEET(False, URL, GetEETRIO);
  if not SendOnly then SignTrzba(parameters);

  try
    if aTimeOut <> 0 then
      begin
          TT := TEETTrzbaThread.Create(True);
          TT.FreeOnTerminate := True;
          TT.EET := Service;
          TT.ETrzba := parameters;
          h := TT.Handle;
          {$IFDEF LEGACY_RIO}
          TT.Resume;
          {$ELSE}
          TT.Start;
          {$ENDIF}
          if aTimeOut < 0 then
            WaitResult := WaitForSingleObject(h, Windows.INFINITE)
          else
            WaitResult := WaitForSingleObject(h, aTimeOut);
          case WaitResult of
            WAIT_OBJECT_0:
               begin
                 // Thread dobìhl vèas, výsledky jsou validní, zpracovat je
                 Result := TT.EETOdpoved;
                 FErrorCode := TT.ErrorCode;
                 FErrorMessage := TT.ErrorMessage;
               end;
          else
            begin
              // Thread ještì nedobìhl
              if GetHandleInformation(h, Tmp) then
                TT.Terminate; // signalizujeme, že s ním konèíme, ale je ttt stale validni?
              if WaitResult = WAIT_TIMEOUT then
                begin
                  FErrorCode := -2;
                  FErrorMessage := 'Send timeout expired !!!';
                end
              else
                begin
                  // volání ve vláknì selhalo, ošetøit..
                  FErrorCode := -2;
                  FErrorMessage := 'Send timeout expired !!!';
                end;
            end;
           end; // Case
      end
    else
      Result := Service.OdeslaniTrzby(parameters); { invoke the service }
  except
   on E:Exception do
     begin
       FErrorCode := -1;
       FErrorMessage := E.Message;
     end;
  end;
end;

{$IF Defined(USE_DIRECTINDY)}
function TEETTrzba.OdeslaniTrzbyDirectIndy(const parameters: Trzba; SendOnly: Boolean): Odpoved;
var
  SoapRequest, SOAPResponse : TMemoryStream;
{$IFNDEF USE_LIBEET}
  DocTrzba : IXMLDocument;
  Service : EET;
  SoapEnv : TSoapEnvelope;
  Doc : IXMLDocument;
  HeaderNode : IXMLNode;
{$ENDIF}
  EnvNode, BodyNode, OdpovedNode : IXMLNode;

  procedure ParseOdpoved;
  var
    Converter: IObjConverter;
    XMLin: IXMLDocument;
  begin
    XMLin := NewXMLDocument;
    XMLin.LoadFromStream(SOAPResponse);
    EnvNode := XMLin.DocumentElement;
    OdpovedNode := nil;
    BodyNode := nil;
    if EnvNode <> nil then
      BodyNode := EnvNode.ChildNodes.FindNode('Body');
    if BodyNode <> nil then
      OdpovedNode := BodyNode.ChildNodes.FindNode('Odpoved', FISKXML_TNSSCHEMA_URI);

    if OdpovedNode <> nil then
      begin
        Converter:= TSOAPDomConv.Create(NIL);
        if Result = nil then Result := Odpoved.Create;
        Result.SOAPToObject(EnvNode, OdpovedNode, Converter);
      end;
  end;
begin
  FValidResponse := True;
  FErrorCode := 0;
  FErrorMessage := '';
  Result := nil;

  FIdHttpClient.HandleRedirects := True;
  FIdHttpClient.ConnectTimeout := FConnectTimeout;
  FIdHttpClient.HTTPOptions := FIdHttpClient.HTTPOptions + [hoKeepOrigProtocol];
  if FIdHttpClient.IOHandler is TIdSSLIOHandlerSocketOpenSSL then
    begin
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).Port := 0;
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).DefaultPort := 0;
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.Method := sslvTLSv1_2;
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.SSLVersions := [sslvTLSv1_2];
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.Mode := sslmClient;
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.VerifyMode := [];
      TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.VerifyDepth := 0;
      if FRootCertFile <> '' then
        begin
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.RootCertFile := FRootCertFile;
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.VerifyMode := [sslvrfPeer];
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.VerifyDepth := 2;
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).OnVerifyPeer := DoVerifyPeer;
        end;
    end;

{$IFNDEF USE_LIBEET}
  DocTrzba := NewXMLDocument;
  Service := GetEET(False, URL, GetEETRIO);
  SoapEnv := TSoapEnvelope.Create;
  Doc := NewXMLDocument;
  try
      Doc.Options := [doNodeAutoCreate];
      DocTrzba.Options := [doNodeAutoCreate];
{$ENDIF}
     if not SendOnly then SignTrzba(parameters);

      SoapRequest := TMemoryStream.Create;
      SoapResponse := TMemoryStream.Create;
      try
        try
          SoapRequest.Clear;
          SaveToXML(parameters, SoapRequest);
          SoapRequest.Seek(0, soFromBeginning);
{$IFNDEF USE_LIBEET}
          DocTrzba.LoadFromStream(SoapRequest);
          EnvNode := SoapEnv.MakeEnvelope(Doc, []);
          HeaderNode := SoapEnv.MakeHeader(EnvNode, []);
          BodyNode := SoapEnv.MakeBody(EnvNode, []);
          BodyNode.ChildNodes.Add(DocTrzba.DocumentElement);
          SoapRequest.Clear;
          Doc.SaveToStream(SoapRequest);
          BodyNode := nil;
          HeaderNode := nil;
          EnvNode := nil;
{$ENDIF}
          SoapRequest.Seek(0, soFromBeginning);
          SignMessage(SoapRequest);
          SoapRequest.Seek(0, soFromBeginning);
          RequestStream.Clear;
          RequestStream.CopyFrom(SoapRequest, SoapRequest.Size);
          if Assigned(FOnBeforeSendRequest) then FOnBeforeSendRequest('OdeslatTrzbu', SOAPRequest);

          FIdHttpClient.Post(URL, SoapRequest, SOAPResponse);

          SOAPResponse.Seek(0, soFromBeginning);
          ResponseStream.Clear;
          ResponseStream.CopyFrom(SOAPResponse, SOAPResponse.Size);

          SoapResponse.Seek(0, soFromBeginning);
          if Assigned(FOnAfterSendRequest) then FOnAfterSendRequest('OdeslatTrbu', SOAPResponse);
          ValidateResponse(SOAPResponse);

          SOAPResponse.Seek(0, soFromBeginning);
          ParseOdpoved;
        except
          on E:Exception do
            begin
              FErrorCode := -1;
              FErrorMessage := E.Message;
            end;
        end;
      finally
        SoapRequest.Free;
        SOAPResponse.Free;
      end;
{$IFNDEF USE_LIBEET}
   finally
     SoapEnv.Free;
     Doc := nil;
     DocTrzba := nil;
   end;
{$ENDIF}
end;
{$IFEND}

procedure TEETTrzba.SaveToXML(const parameters: Trzba; const DestStream: TStream);
var
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeRoot: IXMLNode;
  XML: IXMLDocument;
  XMLStr: {$IFDEF LEGACY_RIO}InvString{$ELSE}String{$ENDIF};
  XMLAnsiStr: AnsiString;
begin
  XML:= TXMLDocument.Create(nil);
  Converter:= TSOAPDomConv.Create(NIL);
  try
    XML.Active := True;
    XML.Options := [doNodeAutoCreate];
    XML.Encoding := 'utf-8';
    NodeRoot:= XML.CreateNode('Root');
    NodeObject:= parameters.ObjectToSOAP(NodeRoot, NodeRoot, Converter, 'Trzba', '', {$IFNDEF LEGACY_RIO} '',{$ENDIF} [ocoDontPrefixNode, ocoDontPutTypeAttr], XMLStr);
    NodeObject.Attributes['xmlns'] := FISKXML_TNSSCHEMA_URI;
    XMLAnsiStr := AnsiString(NodeObject.XML);
    XML.Active := False;
    XMLAnsiStr := AnsiReplaceStr(string(XMLAnsiStr), ' xmlns=""', '');
    DestStream.WriteBuffer(Pointer(XMLAnsiStr)^, Length(XMLAnsiStr) * SizeOf(XMLAnsiStr[1]));
  finally
    XML := nil;
  end;
end;

procedure TEETTrzba.SignMessage(SOAPRequest: TStream);
var
{$IFNDEF USE_LIBEET}
  xmlDoc, xmlDocTemp : IXMLDocument;
  iNode : IXMLNode;
{$ENDIF}
  I : integer;
begin
  if not FSigner.Active then
    begin
      if FPFXStream.Size > 0 then
        FSigner.LoadPFXCertFromStream(FPFXStream,AnsiString(FPFXPassword));
      for I := 0 to FCERTrustedList.Count - 1 do
        FSigner.AddTrustedCertFromStream(FCERTrustedList.GetStream(I));
      FSigner.Active := True;
    end;

{$IFNDEF USE_LIBEET}
  xmlDocTemp := NewXMLDocument;
  xmlDocTemp.Options  := [];
  xmlDocTemp.LoadFromStream(SOAPRequest as TMemoryStream);

  xmlDoc := NewXMLDocument;
  xmlDoc.Options  := [];
  iNode := xmlDoc.AddChild('soap:Envelope');
  iNode.DeclareNamespace('soap', 'http://schemas.xmlsoap.org/soap/envelope/');
  iNode.Attributes['xmlns:wsu'] := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
  iNode.AddChild(SSoapNameSpacePre + ':Header', 'http://schemas.xmlsoap.org/soap/envelope/');
  iNode := iNode.AddChild('soap:Body');
  iNode.ChildNodes.Add(xmlDocTemp.DocumentElement.ChildNodes.FindNode(SSoapNameSpacePre + ':Body').ChildNodes[0]);

  iNode :=  xmlDoc.ChildNodes.FindNode('soap:Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode('soap:Body');
      if iNode <> nil then
        begin
          iNode.Attributes['wsu:Id'] := 'id-TheBody';
        end;
    end;
  iNode :=  xmlDoc.ChildNodes.FindNode('soap:Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode( SSoapNameSpacePre + ':Header');
      if iNode <> nil then
        begin
          InsertWsse(iNode);
          iNode := iNode.ChildNodes.FindNode('wsse:Security', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          if iNode <> nil then
            begin
              iNode := iNode.ChildNodes.FindNode('wsse:BinarySecurityToken', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
              if iNode <> nil then
                iNode.Text := string(FSigner.GetRawCertDataAsBase64String);
            end;
        end;
    end;
  (SOAPRequest as TMemoryStream).Clear;
  xmlDoc.SaveToStream(SOAPRequest as TMemoryStream);
{$ENDIF}

  FSigner.SignXML(SOAPRequest as TMemoryStream);
end;

function TEETTrzba.SignTrzba(const parameters: Trzba): Boolean;
var
  sPKPData : string;

  // http://qc.embarcadero.com/wc/qcmain.aspx?d=43488
  // matches the relative standard or daylight date to a real date in a given year
  function EncodeDayLightChange (Change : TSystemTime; const Year : Word) : TDateTime;
  begin
    // wDay indicates the nth occurance of the day specified in wDayOfWeek in the given month
    // wDayOfWeek indicates the day (0=sunday,  1=monday, ...,6=saturday)
    // delphi coding is             (7=sunday,  1=monday, ...,6=saturday)
    with change do begin
      if wDayOfWeek = 0 then wDayOfWeek := 7;
      // Encoding the day of change (if wDay = 5 then try it and if needed decrement to find the last
      // occurance of the day in this month)
      while not TryEncodeDayOfWeekInMonth (Year, wMonth, wDay, wDayOfWeek, result) do begin
        dec (wday); // we assume there are only 4 occurances of the given day
        if wDay < 1 then // this is just to make sure it realy terminates
          TryEncodeDayOfWeekInMonth (Year, wMonth, 1, 7, result)
      end;
    // finally add the time when change is due
    result := result + EncodeTime (wHour, wMinute, 0, 0);
    end;
  end;

  function GetTimeZoneBias(const Date: TDateTime): Integer;
  var
    TimeZoneInfo  : TTimeZoneInformation;
    DayLightBegin : tDateTime;
    DayLightEnd   : tDateTime;
    Y,M,D         : Word;

  begin
    case GetTimeZoneInformation(TimeZoneInfo) of
      TIME_ZONE_ID_UNKNOWN: Result  := TimeZoneInfo.Bias;
      TIME_ZONE_ID_STANDARD,
      TIME_ZONE_ID_DAYLIGHT: begin
                               Result := TimeZoneInfo.Bias;
                               // is the time we want to convert in the daylight intervall ?
                               DecodeDate(Date,Y,M,D);
                               DayLightEnd   := EncodeDayLightChange (TimeZoneInfo.StandardDate, Y);
                               DayLightBegin := EncodeDayLightChange (TimeZoneInfo.DaylightDate, Y);
                               if (Date >= DayLightBegin) and (Date < DayLightEnd) then
                                 Result := Result + TimeZoneInfo.DaylightBias;
                              end;
    else
      Result := 0;
    end;
  end;

  function DateTimeToXMLTime(Value: TDateTime): string;
  const
    Neg: array[Boolean] of string=  ('+', '-');
  var
    Bias: Integer;
  begin
    Result := FormatDateTime('yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''', Value); { Do not localize }
    Bias := GetTimeZoneBias(Value);
    Result := Format('%s%s%.2d:%.2d', [Result, Neg[Bias > 0],                         { Do not localize }
                                       Abs(Bias) div MinsPerHour,
                                       Abs(Bias) mod MinsPerHour]);
  end;

begin
  Result := False;
  if not IsInitialized then exit;

  // milisecond in output correction
  parameters.Hlavicka.dat_odesl.XSToNative(DateTimeToXMLTime(parameters.Hlavicka.dat_odesl.AsDateTime));
  parameters.Data.dat_trzby.XSToNative(DateTimeToXMLTime(parameters.Data.dat_trzby.AsDateTime));

  // KontrolniKody prepare
  if parameters.KontrolniKody = nil then  parameters.KontrolniKody := TrzbaKontrolniKodyType.Create;
  if parameters.KontrolniKody.pkp = nil then parameters.KontrolniKody.pkp := PkpElementType.Create;
  if parameters.KontrolniKody.bkp = nil then parameters.KontrolniKody.bkp := BkpElementType.Create;

  parameters.KontrolniKody.pkp.Text := '';
  parameters.KontrolniKody.bkp.Text := '';

  // source data for PKP
  sPKPData := '';
  sPKPData := parameters.Data.dic_popl;
  sPKPData := sPKPData + '|' + IntToStr(parameters.Data.id_provoz);
  sPKPData := sPKPData + '|' + parameters.Data.id_pokl;
  sPKPData := sPKPData + '|' + parameters.Data.porad_cis;
  sPKPData := sPKPData + '|' + parameters.Data.dat_trzby.NativeToXS;
  sPKPData := sPKPData + '|' + parameters.Data.celk_trzba.DecimalString;

  // generovat PKP
  parameters.KontrolniKody.pkp.Text := FSigner.MakePKP(sPKPData);
  // generovat BKP
  parameters.KontrolniKody.bkp.Text := FSigner.MakeBKP(sPKPData);

  Result := parameters.KontrolniKody.pkp.Text <> ''
end;

procedure TEETTrzba.ValidateResponse(SOAPResponse: TStream);
begin
  FValidResponse := False;

//  if FSigner.VerifyCertIncluded then
//    begin
      FValidResponse := FSigner.VerifyXML(SOAPResponse as TMemoryStream, 'Body', 'Id');
//    end;
end;

{ TEETRIO }

constructor TEETRIO.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF USE_INDY}
  IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(self);
  IdSSLIOHandlerSocketOpenSSL1.Port := 0;
  IdSSLIOHandlerSocketOpenSSL1.DefaultPort := 0;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1_2;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.SSLVersions := [sslvTLSv1_2];
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Mode := sslmClient;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyMode := [];
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyDepth := 0;
  HTTPWebNode.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  {$ELSE}
    {$IFNDEF LEGACY_RIO}
      HTTPWebNode.OnWinInetError := DoOnWinInetError;
      HTTPWebNode.InvokeOptions := HTTPWebNode.InvokeOptions - [soIgnoreInvalidCerts];
    {$ENDIF}
  {$ENDIF}

  {$IFNDEF LEGACY_RIO}
  HTTPWebNode.WebNodeOptions := [];
  {$ENDIF}

  HTTPWebNode.OnBeforePost := HTTPWebNode_BeforePost;
  OnBeforeExecute := HTTPRIO_BeforeExecute;
  OnAfterExecute := HTTPRIO_AfterExecute;
end;

destructor TEETRIO.Destroy;
begin
  inherited;
end;

{$IFNDEF USE_INDY}
function TEETRIO.DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
begin
  if LastError <> ERROR_SUCCESS then
    raise Exception.Create(GetWinInetError(LastError));
  Result := ERROR_SUCCESS;
end;
{$ENDIF}

procedure TEETRIO.HTTPRIO_AfterExecute(const MethodName: string; SOAPResponse: TStream);
begin
  SOAPResponse.Position:=0;
  if Assigned(FEET) then
    begin
      FEET.ResponseStream.Clear;
      FEET.ResponseStream.CopyFrom(SOAPResponse, SOAPResponse.Size);
      SOAPResponse.Position:=0;
      if Assigned(FEET.OnAfterSendRequest) then FEET.OnAfterSendRequest(MethodName, SOAPResponse);
      FEET.ValidateResponse(SOAPResponse);
    end;
end;

{$IFDEF LEGACY_RIO}
procedure TEETRIO.HTTPRIO_BeforeExecute(const MethodName: string; var SOAPRequest: InvString);
var
  MemStream: TMemoryStream;
  S: string;
begin
  if Assigned(FEET) then
    begin
      MemStream := TMemoryStream.Create;
      try
        S := UTF8Encode(SOAPRequest);
        MemStream.Write(S[1], Length(S));
        MemStream.Position := 0;
        FEET.SignMessage(MemStream);
        MemStream.Position := 0;
        SetLength(S, MemStream.Size);
        MemStream.Read(S[1], MemStream.Size);
        MemStream.Position := 0;
        FEET.RequestStream.Clear;
        FEET.RequestStream.CopyFrom(MemStream, MemStream.Size);
        SOAPRequest := UTF8Decode(S);
      finally
        MemStream.Free;
      end;
      if Assigned(FEET.OnBeforeSendRequest) then FEET.OnBeforeSendRequest(MethodName, SOAPRequest);
    end;
end;
{$ELSE}
procedure TEETRIO.HTTPRIO_BeforeExecute(const MethodName: string; SOAPRequest: TStream);
begin
  SOAPRequest.Position:=0;
  if Assigned(FEET) then
    begin
      FEET.SignMessage(SOAPRequest);
      SOAPRequest.Position:=0;
      FEET.RequestStream.Clear;
      FEET.RequestStream.CopyFrom(SOAPRequest, SOAPRequest.Size);
      SOAPRequest.Position:=0;
      if Assigned(FEET.OnBeforeSendRequest) then FEET.OnBeforeSendRequest(MethodName, SOAPRequest);
    end;
end;
{$ENDIF}

procedure TEETRIO.HTTPWebNode_BeforePost(const AHTTPReqResp: THTTPReqResp; AData: Pointer);
begin
{$IFDEF USE_INDY}
  TIdHTTP(AData).ConnectTimeout := AHTTPReqResp.ConnectTimeout;
  TIdHTTP(AData).HTTPOptions := TIdHTTP(AData).HTTPOptions + [hoKeepOrigProtocol];
  if TIdHTTP(AData).IOHandler is TIdSSLIOHandlerSocketOpenSSL then
    if Assigned(FEET) then
      begin
        if FEET.RootCertFile <> '' then
          begin
            TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).SSLOptions.RootCertFile := FEET.RootCertFile;
            TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).SSLOptions.VerifyMode := [sslvrfPeer];
            TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).SSLOptions.VerifyDepth := 2;
            TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).OnVerifyPeer := FEET.DoVerifyPeer;
          end;
      end;
{$ENDIF}
end;

{ TEETTrzbaThread }

procedure TEETTrzbaThread.Execute;
begin
  try
    FOdpoved := nil;
    CoInitialize(nil);
    try
      FOdpoved := EET.OdeslaniTrzby(FTrzba);
    except
      on E : Exception do
        begin
          FErrorCode := 2;
          fErrorMessage := E.Message;
        end;
    end;
    CoUninitialize;
  except
  end;
end;

end.
