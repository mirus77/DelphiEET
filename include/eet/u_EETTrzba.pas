unit u_EETTrzba;

interface

uses
  Windows,System.SysUtils, System.Classes, InvokeRegistry, Rio, SOAPHTTPClient, Types, XSBuiltIns,
  SOAPHTTPTrans, Soap.WebNode, Soap.OpConvertOptions, Soap.OPToSOAPDomConv,
  {$IFDEF USE_INDY}
    IdHTTP, IdCookie, IdCookieManager, IdHeaderList, IdURI, IdComponent, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  {$ELSE}
    WinInet,
  {$ENDIF}
  ActiveX, u_EETServiceSOAP, Xml.XMLDoc, Xml.XMLIntf, u_EETSigner;

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
    procedure HTTPRIO_BeforeExecute(const MethodName: string;
      SOAPRequest: TStream);
    procedure HTTPRIO_AfterExecute(const MethodName: string;
      SOAPResponse: TStream);
    function DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
    {$IFDEF USE_INDY}
    function DoVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
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
    FOnBeforeSendRequest: TBeforeExecuteEvent;
    FOnAfterSendRequest: TAfterExecuteEvent;
    FConnectTimeout: Integer;
    FReceiveTimeout: Integer;
    FValidResponse: Boolean;
    FCERStream: TMemoryStream;
    FSendTimeout: Integer;
    FErrorCode: Integer;
    FErrorMessage: string;
    {$IFDEF USE_INDY}
    FOnVerifyPeer: TVerifyPeerEvent;
    {$ENDIF}
    FRootCertFile: string;
    FHttpsTrustName: string;
  protected
    IsInitialized: boolean;
    FSigner : TEETSigner;
    FPFXStream : TMemoryStream;
    FPFXPassword : string;
    function GetEETRIO : TEETRIO;
    procedure SignMessage(SOAPRequest: TStream);
    procedure ValidateResponse(SOAPResponse: TStream);
  public
    URL: string;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    function NewTrzba : Trzba;
    function SignTrzba(const parameters: Trzba): Boolean;
    function OdeslaniTrzby(const parameters: Trzba; SendOnly : Boolean = false): Odpoved;
    function HasVarovani(Odpoved : OdpovedType) : Boolean;
    procedure SaveToXML(const parameters: Trzba; const DestStream : TStream);
    procedure LoadFromXML(const parameters: Trzba; const SourceStream : TStream);
  published
    property PFXStream : TMemoryStream read FPFXStream;
    property CERStream : TMemoryStream read FCERStream;
    property PFXPassword : string read FPFXPassword write FPFXPassword;
    property RootCertFile : string read FRootCertFile write FRootCertFile;
    property HttpsTrustName : string read FHttpsTrustName write FHttpsTrustName;
    property ConnectTimeout : Integer read FConnectTimeout write FConnectTimeout;
    property SendTimeout : Integer read FSendTimeout write FSendTimeout;
    property ReceiveTimeout : Integer read FReceiveTimeout write FReceiveTimeout;
    property ValidResponse : Boolean read FValidResponse;
    property ErrorCode : Integer read FErrorCode;
    property ErrorMessage : string read FErrorMessage;
    property OnBeforeSendRequest : TBeforeExecuteEvent read FOnBeforeSendRequest write FOnBeforeSendRequest;
    property OnAfterSendRequest : TAfterExecuteEvent read FOnAfterSendRequest write FOnAfterSendRequest;
    property Signer : TEETSigner read FSigner;
    {$IFDEF USE_INDY}
    property OnVerifyPeer : TVerifyPeerEvent read FOnVerifyPeer write FOnVerifyPeer;
    {$ENDIF}
  end;

implementation

uses StrUtils, u_wsse, u_wsse_utils, u_xmldsigcoreschema, synacode, SZCodeBaseX, Soap.SOAPConst, DateUtils, TimeSpan;

type
  TEETHeader = class(TSOAPHeader)
  public
   function ObjectToSOAP(RootNode, ParentNode: IXMLNode;
                            const ObjConverter: IObjConverter;
                            const NodeName, NodeNamespace, ChildNamespace: InvString; ObjConvOpts: TObjectConvertOptions;
                            out RefID: InvString): IXMLNode; override;
  end;


constructor TEETTrzba.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsInitialized:=false;
  CoInitialize(nil);
  FEETService := nil;
  FSigner := TEETSigner.Create(nil);
  FPFXPassword := '';
  FPFXStream := TMemoryStream.Create;
  FCERStream := TMemoryStream.Create;
  FHttpsTrustName := 'www.eet.cz';
  FConnectTimeout := 2000;
  FSendTimeout := 3000;
  FReceiveTimeout := 3000;
end;

destructor TEETTrzba.Destroy;
begin
  FSigner.Free;
  FPFXStream.Free;
  FCERStream.Free;
  CoUnInitialize;
  inherited;
end;

function TEETTrzba.GetEETRIO: TEETRIO;
begin
  Result := TEETRIO.Create(nil);
  Result.EET := self;
  Result.HTTPWebNode.ConnectTimeout := Self.ConnectTimeout;
  Result.HTTPWebNode.SendTimeout := Self.SendTimeout;
  Result.HTTPWebNode.ReceiveTimeout := Self.ReceiveTimeout;
end;

function TEETTrzba.HasVarovani(Odpoved: OdpovedType): Boolean;
begin
  Result := False;
  if Odpoved = nil then exit;
  Result := Length(Odpoved.Varovani) > 0;
end;

procedure TEETTrzba.Initialize;
begin
  if IsInitialized then exit;

  if URL='' then
      raise Exception.Create('SOAP URL není vyplnìna !!!');

  if not FSigner.Active then
    begin
      if FPFXStream.Size > 0 then
        FSigner.LoadPFXCertFromStream(FPFXStream,AnsiString(FPFXPassword));
      if FPFXStream.Size > 0 then
        FSigner.LoadVerifyCertFromStream(FCERStream);
      FSigner.Active := True;
    end;

  IsInitialized:=true;
end;

procedure TEETTrzba.LoadFromXML(const parameters: Trzba; const SourceStream: TStream);
var
  Converter: IObjConverter;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML, XMLin: IXMLDocument;
begin
  XML   := NewXMLDocument;
  XMLin := NewXMLDocument;
  XMLin.LoadFromStream(SourceStream);

  NodeRoot:= XML.AddChild('Root');
  NodeParent:= NodeRoot.AddChild('Parent');
  NodeParent.ChildNodes.Add(XMLin.DocumentElement);

  Converter:= TSOAPDomConv.Create(NIL);
  parameters.SOAPToObject(NodeRoot, XMLin.DocumentElement, Converter);
end;

function TEETTrzba.NewTrzba: Trzba;
begin
  Result := Trzba.Create;
  Result.Hlavicka := TrzbaHlavickaType.Create;
  Result.Hlavicka.uuid_zpravy := TGuid.NewGuid.ToString;
  Result.Hlavicka.uuid_zpravy := LowerCase(Copy(Result.Hlavicka.uuid_zpravy, 2, Length(Result.Hlavicka.uuid_zpravy)-2));

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

function TEETTrzba.OdeslaniTrzby(const parameters: Trzba; SendOnly : Boolean): Odpoved;
var
  Service : EET;
  Hdr : TEETHeader;
begin
  FValidResponse := True;
  FErrorCode := 0;
  FErrorMessage := '';
  Result := nil;

  Service := GetEET(False, URL, GetEETRIO);
  Hdr := TEETHeader.Create;
   try
     (Service as ISOAPHeaders).Send(Hdr); { add the header to outgoing message }

     if not SendOnly then SignTrzba(parameters);

     try
       Result := Service.OdeslaniTrzby(parameters); { invoke the service }
     except
       on E:Exception do
         begin
           FErrorCode := -1;
           FErrorMessage := E.Message;
         end;
     end;
   finally
     Hdr.Free;
   end;
end;

procedure TEETTrzba.SaveToXML(const parameters: Trzba; const DestStream: TStream);
var
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML, XMLout: IXMLDocument;
  XMLStr: String;
begin
  XML:= NewXMLDocument;
  XMLout:= NewXMLDocument;
  NodeRoot:= XML.AddChild('Root');
  NodeParent:= NodeRoot.AddChild('Parent');
  Converter:= TSOAPDomConv.Create(NIL);
  NodeObject:= parameters.ObjectToSOAP(NodeRoot, NodeParent, Converter, 'Trzba', '', '', [ocoDontPrefixNode,ocoDontPutTypeAttr], XMLStr);
//  Target.SOAPToObject(NodeRoot, NodeObject, Converter);
  NodeObject.Attributes['xmlns'] := 'http://fs.mfcr.cz/eet/schema/v3';
  XMLout.Options := [doNodeAutoCreate];
  XMLout.DocumentElement := NodeObject;
  XMLout.SaveToStream(DestStream);
end;

procedure TEETTrzba.SignMessage(SOAPRequest: TStream);
var
  xmlDoc : IXMLDocument;
  iNode : IXMLNode;
begin
  if not FSigner.Active then
    begin
      if FPFXStream.Size > 0 then
        FSigner.LoadPFXCertFromStream(FPFXStream,AnsiString(FPFXPassword));
      if FPFXStream.Size > 0 then
        FSigner.LoadVerifyCertFromStream(FCERStream);
      FSigner.Active := True;
    end;

  xmlDoc := NewXMLDocument;
  xmlDoc.Options  := [];
  xmlDoc.LoadFromStream(SOAPRequest as TMemoryStream);
  iNode :=  xmlDoc.ChildNodes.FindNode(SSoapNameSpacePre + ':Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode(SSoapNameSpacePre + ':Body');
      if iNode <> nil then
        begin
          iNode.Attributes['xmlns:wsu'] := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
          iNode.Attributes['wsu:Id'] := 'id-TheBody';
        end;
    end;
  iNode :=  xmlDoc.ChildNodes.FindNode(SSoapNameSpacePre + ':Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode( SSoapNameSpacePre + ':Header');
      if iNode <> nil then
        begin
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
  FSigner.SignXML(SOAPRequest as TMemoryStream);
end;

function TEETTrzba.SignTrzba(const parameters: Trzba): Boolean;
var
  buf: AnsiString;
  I : integer;
  sPKPData : string;

  function DateTimeToXMLTime(Value: TDateTime): string;
  const
    Neg: array[Boolean] of string=  ('+', '-');
  var
    Bias: Integer;
    tz:TTimeZone;
  begin
    Result := FormatDateTime('yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''', Value); { Do not localize }
    tz := TTimeZone.Local;
    Bias := Trunc(tz.GetUTCOffset(Value).Negate.TotalMinutes);
    if (Bias <> 0) then
    begin
      Result := Format('%s%s%.2d:%.2d', [Result, Neg[Bias > 0],                         { Do not localize }
                                         Abs(Bias) div MinsPerHour,
                                         Abs(Bias) mod MinsPerHour]);
    end
  end;

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
  buf := FSigner.SignString(sPKPData);
  if Length(buf) > 0 then
    begin
      parameters.KontrolniKody.pkp.Text := string(EncodeBase64(buf));
      // generovat BKP z puvodniho cisteho podpisu retezce
      parameters.KontrolniKody.bkp.Text := FormatBKP(string(SZEncodeBase16(SHA1(buf))));
    end;

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
  HTTPWebNode.GetHTTPReqResp.OnWinInetError := DoOnWinInetError;
  {$ENDIF}

  HTTPWebNode.WebNodeOptions := [];

  HTTPWebNode.OnBeforePost := HTTPWebNode_BeforePost;
  OnBeforeExecute:=HTTPRIO_BeforeExecute;
  OnAfterExecute:=HTTPRIO_AfterExecute;
end;

destructor TEETRIO.Destroy;
begin
  inherited;
end;

function TEETRIO.DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
begin
  Result := ERROR_SUCCESS;
end;

{$IFDEF USE_INDY}
function TEETRIO.DoVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth,
  AError: Integer): Boolean;
var
  TempList: TStringList;
  Cn: String;
begin
  Result := AOk;
  if Assigned(FEET) then
    begin
      // check range validity
      Result := CompareDateTime(Certificate.notBefore, Now) = CompareDateTime(Now, Certificate.notAfter);
      if Result and (FEET.HttpsTrustName <> '') and (ADepth = 0) then
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
          Result := SameText(Cn, EET.HttpsTrustName)
        end;
      if Result and Assigned(FEET.OnVerifyPeer) then Result := FEET.OnVerifyPeer(Certificate, Result, ADepth, AError);
    end;
end;
{$ENDIF}

procedure TEETRIO.HTTPRIO_AfterExecute(const MethodName: string; SOAPResponse: TStream);
begin
  SOAPResponse.Position:=0;
  if Assigned(FEET) then
    begin
      if Assigned(FEET.OnAfterSendRequest) then FEET.OnAfterSendRequest(MethodName, SOAPResponse);
      FEET.ValidateResponse(SOAPResponse);
    end;
end;

procedure TEETRIO.HTTPRIO_BeforeExecute(const MethodName: string; SOAPRequest: TStream);
begin
  SOAPRequest.Position:=0;
  if Assigned(FEET) then
    begin
      FEET.SignMessage(SOAPRequest);
      if Assigned(FEET.OnBeforeSendRequest) then FEET.OnBeforeSendRequest(MethodName, SOAPRequest);
    end;
end;


procedure TEETRIO.HTTPWebNode_BeforePost(const AHTTPReqResp: THTTPReqResp; AData: Pointer);
begin
{$IFDEF USE_INDY}
  TIdHTTP(AData).ConnectTimeout := AHTTPReqResp.ConnectTimeout;
  if TIdHTTP(AData).IOHandler is TIdSSLIOHandlerSocketOpenSSL then
    if Assigned(FEET) then
      if FEET.RootCertFile <> '' then
        begin
          TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).SSLOptions.RootCertFile := FEET.RootCertFile;
          TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).SSLOptions.VerifyMode := [sslvrfPeer];
          TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).SSLOptions.VerifyDepth := 2;
          TIdSSLIOHandlerSocketOpenSSL(TIdHTTP(AData).IOHandler).OnVerifyPeer := DoVerifyPeer;
        end;
{$ENDIF}
end;

{ TEETHeader }

function TEETHeader.ObjectToSOAP(RootNode, ParentNode: IXMLNode; const ObjConverter: IObjConverter; const NodeName, NodeNamespace,
  ChildNamespace: InvString; ObjConvOpts: TObjectConvertOptions; out RefID: InvString): IXMLNode;
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
  Signature.SignedInfo.CanonicalizationMethod.AddChild('ec:InclusiveNamespaces', 'http://www.w3.org/2001/10/xml-exc-c14n#').Attributes['PrefixList']:='soap';
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

end.
