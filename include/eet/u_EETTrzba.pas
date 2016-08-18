unit u_EETTrzba;
{.$DEFINE USE_INDY}
interface

uses
  Windows,System.SysUtils, System.Classes, InvokeRegistry, Rio, SOAPHTTPClient, Types, XSBuiltIns,
  SOAPHTTPTrans, Soap.WebNode, Soap.OpConvertOptions,
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
  protected
    FPKPData : string;
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
    function OdeslaniTrzby(const parameters: Trzba): Odpoved;
    property OnBeforeSendRequest : TBeforeExecuteEvent read FOnBeforeSendRequest write FOnBeforeSendRequest;
    property OnAfterSendRequest : TAfterExecuteEvent read FOnAfterSendRequest write FOnAfterSendRequest;
  published
    property PFXStream : TMemoryStream read FPFXStream;
    property CERStream : TMemoryStream read FCERStream;
    property PFXPassword : string read FPFXPassword write FPFXPassword;
    property ConnectTimeout : Integer read FConnectTimeout write FConnectTimeout;
    property SendTimeout : Integer read FSendTimeout write FSendTimeout;
    property ReceiveTimeout : Integer read FReceiveTimeout write FReceiveTimeout;
    property ValidResponse : Boolean read FValidResponse;
    property ErrorCode : Integer read FErrorCode;
    property ErrorMessage : string read FErrorMessage;
  end;

implementation

uses StrUtils, wsse, wsse_utils, u_xmldsigcoreschema, synacode, SZCodeBaseX, Soap.SOAPEnv, Soap.SOAPConst, DateUtils, TimeSpan;

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

procedure TEETTrzba.Initialize;
begin
  if IsInitialized then exit;

  if URL='' then
      raise Exception.Create('SOAP URL není vyplnìna !!!');

  IsInitialized:=true;
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
end;

function TEETTrzba.OdeslaniTrzby(const parameters: Trzba): Odpoved;
var
  Service : EET;
  Hdr : TEETHeader;
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
begin
  FValidResponse := True;
  FErrorCode := 0;
  FErrorMessage := '';
  Result := nil;

  Service := GetEET(False, URL, GetEETRIO);
  Hdr := TEETHeader.Create;
   try
     (Service as ISOAPHeaders).Send(Hdr); { add the header to outgoing message }

     // milisecond in output correction
     parameters.Hlavicka.dat_odesl.XSToNative(DateTimeToXMLTime(parameters.Hlavicka.dat_odesl.AsDateTime));
     parameters.Data.dat_trzby.XSToNative(DateTimeToXMLTime(parameters.Data.dat_trzby.AsDateTime));

     // KontrolniKody prepare
     if parameters.KontrolniKody = nil then  parameters.KontrolniKody := TrzbaKontrolniKodyType.Create;
     if parameters.KontrolniKody.pkp = nil then parameters.KontrolniKody.pkp := PkpElementType.Create;
     if parameters.KontrolniKody.bkp = nil then parameters.KontrolniKody.bkp := BkpElementType.Create;

     parameters.KontrolniKody.pkp.Value := '';
     parameters.KontrolniKody.bkp.Value := '';

     // source data for PKP
     FPKPData := '';
     FPKPData := parameters.Data.dic_popl;
     FPKPData := FPKPData + '|' + IntToStr(parameters.Data.id_provoz);
     FPKPData := FPKPData + '|' + parameters.Data.id_pokl;
     FPKPData := FPKPData + '|' + parameters.Data.porad_cis;
     FPKPData := FPKPData + '|' + parameters.Data.dat_trzby.NativeToXS;
     FPKPData := FPKPData + '|' + parameters.Data.celk_trzba.DecimalString;

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

procedure TEETTrzba.SignMessage(SOAPRequest: TStream);
var
  xmlDoc : IXMLDocument;
  iNode : IXMLNode;
  buf: AnsiString;
  BKPCode : string;
  S : string;
  I : integer;
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
  iNode :=  xmlDoc.ChildNodes.FindNode(MySSoapNameSpacePre + ':Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode(MySSoapNameSpacePre + ':Body');
      if iNode <> nil then
        begin
          iNode.Attributes['xmlns:wsu'] := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
          iNode.Attributes['wsu:Id'] := 'id-TheBody';
          iNode := iNode.ChildNodes.FindNode('Trzba', '');
          if (iNode <> nil) and (FPKPData <> '') then
            begin
              iNode := iNode.ChildNodes.FindNode('KontrolniKody', '');
              if (iNode <> nil) then
                begin
                  BKPCode := '';
                  iNode := iNode.ChildNodes.FindNode('pkp', '');
                  if iNode <> nil then
                    begin
                      buf := FSigner.SignString(FPKPData);
                      S := string(EncodeBase64(buf));
                      iNode.Text := S;

                      // generovat BKP z puvodniho cisteho podpisu retezce
                      BKPCode :=  string(SZEncodeBase16(SHA1(buf)));

                      iNode := iNode.ParentNode.ChildNodes.FindNode('bkp', '');
                      if (iNode <> nil) and (BKPCode <> '') then
                        begin
                          iNode.Text := FormatBKP(BKPCode);
                        end;
                    end;
                end;
            end;
        end;
    end;
  iNode :=  xmlDoc.ChildNodes.FindNode(MySSoapNameSpacePre + ':Envelope');
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

procedure TEETTrzba.ValidateResponse(SOAPResponse: TStream);
begin
  FValidResponse := False;

  if FSigner.VerifyCertIncluded then
    begin
      FValidResponse := FSigner.VerifyXML(SOAPResponse as TMemoryStream, 'Body', 'Id');
    end;
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
  SecReference : wsse.IXMLReferenceType;

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
