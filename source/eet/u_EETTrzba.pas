unit u_EETTrzba;

interface

{$IFNDEF UNICODE}
{$DEFINE LEGACY_RIO}
{$ENDIF}
// For Delphi XE3 and up:
{$IF CompilerVersion >= 24.0 }
{$LEGACYIFEND ON}
{$IFEND}

uses
  Windows, SysUtils, Classes, InvokeRegistry, Rio, SOAPHTTPClient, Types, XSBuiltIns,
  SOAPHTTPTrans, WebNode, OPToSOAPDomConv, SOAPEnv, ActiveX, u_EETServiceSOAP, XMLDoc,
  XMLIntf, u_EETSigner, u_EETHttpClient;

type
  TEETTrzba = class;

  TVerifyResponseEvent = procedure(const ResponseCertInfo: TEETSignerCertInfo; var IsValidResponse: boolean) of object;

  TEETTrzba = class(TComponent)
  private
    FOnBeforeSendRequest: TBeforeExecuteEvent;
    FOnAfterSendRequest: TAfterExecuteEvent;
    FValidResponse: boolean;
    FErrorCode: Integer;
    FErrorMessage: string;
    FRequestStream: TMemoryStream;
    FResponseStream: TMemoryStream;
    FValidResponseCert: boolean;
    FOnVerifyResponseEvent: TVerifyResponseEvent;
  protected
    IsInitialized: boolean;
    FSigner: TEETSigner;
    function EETDateTimeToXMLTime(Value: TDateTime): string;
{$IFNDEF USE_LIBEET}
    procedure InsertWsse(ParentNode: IXMLNode);
{$ENDIF}
  public
    URL: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    function NewRevenue: Trzba;
    function SignRevenue(const parameters: Trzba): boolean;
    function SendRevenue(aHttpClient: TEETHttpClient; const parameters: Trzba; SendOnly: boolean = false;
      aTimeOut: Integer = 0): Odpoved;
    function SendRevenueWithRIO(const parameters: Trzba; SendOnly: boolean = false; aTimeOut: Integer = 0): Odpoved;
    function HasWarnings(Odpoved: OdpovedType): boolean;
    procedure SaveToXML(const parameters: Trzba; const DestStream: TStream);
    procedure LoadFromXML(parameters: Trzba; const SourceStream: TStream);
    procedure SignRequest(SOAPRequest: TStream);
    procedure ValidateResponse(SOAPResponse: TStream);
  published
    property ValidResponse: boolean read FValidResponse;
    property ValidResponseCert: boolean read FValidResponseCert;
    property ErrorCode: Integer read FErrorCode;
    property ErrorMessage: string read FErrorMessage;
    property OnBeforeSendRequest: TBeforeExecuteEvent read FOnBeforeSendRequest write FOnBeforeSendRequest;
    property OnAfterSendRequest: TAfterExecuteEvent read FOnAfterSendRequest write FOnAfterSendRequest;
    property Signer: TEETSigner read FSigner;
    property RequestStream: TMemoryStream read FRequestStream;
    property ResponseStream: TMemoryStream read FResponseStream;
    property OnVerifyResponse: TVerifyResponseEvent read FOnVerifyResponseEvent write FOnVerifyResponseEvent;
  end;

implementation

uses StrUtils, u_EETRIO,
{$IFNDEF USE_LIBEET}
  u_wsse, u_wsse_utils, u_xmldsigcoreschema, SOAPConst,
{$ENDIF}
  DateUtils {, TimeSpan};

constructor TEETTrzba.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsInitialized := false;
  CoInitialize(nil);
  FSigner := TEETSigner.Create(nil);
  FRequestStream := TMemoryStream.Create;
  FResponseStream := TMemoryStream.Create;
end;

destructor TEETTrzba.Destroy;
begin
  FRequestStream.Free;
  FResponseStream.Free;
  FSigner.Free;
  CoUnInitialize;
  inherited;
end;

function TEETTrzba.EETDateTimeToXMLTime(Value: TDateTime): string;

const
  Neg: array [boolean] of string = ('+', '-');
var
  Bias: Integer;

  // http://qc.embarcadero.com/wc/qcmain.aspx?d=43488
  // matches the relative standard or daylight date to a real date in a given year
  function EncodeDayLightChange(Change: TSystemTime; const Year: Word): TDateTime;
  begin
    // wDay indicates the nth occurance of the day specified in wDayOfWeek in the given month
    // wDayOfWeek indicates the day (0=sunday,  1=monday, ...,6=saturday)
    // delphi coding is             (7=sunday,  1=monday, ...,6=saturday)
    with Change do
      begin
        if wDayOfWeek = 0 then
          wDayOfWeek := 7;
        // Encoding the day of change (if wDay = 5 then try it and if needed decrement to find the last
        // occurance of the day in this month)
        while not TryEncodeDayOfWeekInMonth(Year, wMonth, wDay, wDayOfWeek, result) do
          begin
            dec(wDay); // we assume there are only 4 occurances of the given day
            if wDay < 1 then // this is just to make sure it realy terminates
              TryEncodeDayOfWeekInMonth(Year, wMonth, 1, 7, result)
          end;
        // finally add the time when change is due
        result := result + EncodeTime(wHour, wMinute, 0, 0);
      end;
  end;

  function GetTimeZoneBias(const Date: TDateTime): Integer;
  var
    TimeZoneInfo: TTimeZoneInformation;
    DayLightBegin: TDateTime;
    DayLightEnd: TDateTime;
    Y, M, D: Word;

  begin
    case GetTimeZoneInformation(TimeZoneInfo) of
      TIME_ZONE_ID_UNKNOWN:
        result := TimeZoneInfo.Bias;
      TIME_ZONE_ID_STANDARD, TIME_ZONE_ID_DAYLIGHT:
        begin
          result := TimeZoneInfo.Bias;
          // is the time we want to convert in the daylight intervall ?
          DecodeDate(Date, Y, M, D);
          DayLightEnd := EncodeDayLightChange(TimeZoneInfo.StandardDate, Y);
          DayLightBegin := EncodeDayLightChange(TimeZoneInfo.DaylightDate, Y);
          if (Date >= DayLightBegin) and (Date < DayLightEnd) then
            result := result + TimeZoneInfo.DaylightBias;
        end;
    else
      result := 0;
    end;
  end;

begin
  result := FormatDateTime('yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''', Value); { Do not localize }
  Bias := GetTimeZoneBias(Value);
  result := Format('%s%s%.2d:%.2d', [result, Neg[Bias > 0], { Do not localize }
    Abs(Bias) div MinsPerHour, Abs(Bias) mod MinsPerHour]);
end;

procedure TEETTrzba.Finalize;
begin
  if FSigner.Active then
    FSigner.Active := false;
  IsInitialized := false;
end;

function TEETTrzba.HasWarnings(Odpoved: OdpovedType): boolean;
begin
  result := false;
  if Odpoved = nil then
    exit;
  result := Length(Odpoved.Varovani) > 0;
end;

procedure TEETTrzba.Initialize;
begin
  if IsInitialized then
    exit;

  if URL = '' then
    raise Exception.Create('SOAP URL is empty !!!');

  if not FSigner.Active then
    FSigner.Active := True;

  IsInitialized := True;
end;

{$IFNDEF USE_LIBEET}

procedure TEETTrzba.InsertWsse(ParentNode: IXMLNode);
var
  SecHeader: IXMLSecurityHeaderType;
  Signature: IXMLSignatureType;
  SigReference: IXMLReferenceType;
  SigTransForm: IXMLTransformType;
  SecTokenReference: IXMLSecurityTokenReferenceType;
  SecReference: u_wsse.IXMLReferenceType;
begin
  // Security
  SecHeader := NewSecurity;
  SecHeader.OwnerDocument.Options := [doNodeAutoCreate]; // speed optimization for ChildNodes.Add(???)
  SecHeader.Attributes['SOAP-ENV:mustUnderstand'] := '1';
  SecHeader.BinarySecurityToken.EncodingType :=
    'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
  SecHeader.BinarySecurityToken.ValueType :=
    'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3';
  SecHeader.BinarySecurityToken.Attributes['wsu:Id'] := 'id-TheCert';

  // Signature
  Signature := NewSignature;
  Signature.OwnerDocument.Options := [doNodeAutoCreate]; // speed optimization for ChildNodes.Add(???)
  Signature.SignedInfo.CanonicalizationMethod.Algorithm := 'http://www.w3.org/2001/10/xml-exc-c14n#';
  Signature.Id := 'id-TheSignature';
  Signature.SignedInfo.CanonicalizationMethod.AddChild('ec:InclusiveNamespaces', 'http://www.w3.org/2001/10/xml-exc-c14n#')
    .Attributes['PrefixList'] := 'soap';
  Signature.SignedInfo.SignatureMethod.Algorithm := 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256';

  SigReference := Signature.SignedInfo.Reference.Add;
  SigReference.URI := '#id-TheBody';

  SigTransForm := SigReference.Transforms.Add;
  SigTransForm.Algorithm := 'http://www.w3.org/2001/10/xml-exc-c14n#';
  SigTransForm.AddChild('ec:InclusiveNamespaces', 'http://www.w3.org/2001/10/xml-exc-c14n#').Attributes['PrefixList'] := '';

  SigReference.DigestMethod.Algorithm := 'http://www.w3.org/2001/04/xmlenc#sha256';
  SigReference.DigestValue := '';

  Signature.SignatureValue.Text := '';

  // SecurityTokenReferenco pro KeyInfo;
  SecTokenReference := NewSecurityTokenReference;
  SecTokenReference.OwnerDocument.Options := [doNodeAutoCreate];
  SecTokenReference.Attributes['wsu:Id'] := 'id-TheSecurityTokenReference';

  SecReference := NewReference;
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

procedure TEETTrzba.LoadFromXML(parameters: Trzba; const SourceStream: TStream);
var
  Converter: IObjConverter;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML, XMLin: IXMLDocument;
begin
  XML := NewXMLDocument;
  XMLin := NewXMLDocument;
  XMLin.LoadFromStream(SourceStream);

  NodeRoot := XML.AddChild('Root');
  NodeParent := XMLin.DocumentElement;

  Converter := TSOAPDomConv.Create(NIL);
  parameters.SOAPToObject(NodeRoot, NodeParent, Converter);
end;

function TEETTrzba.NewRevenue: Trzba;

  function Hexa(cislo: Integer): String;
  begin
    result := IntToStr(cislo);
    if cislo = 10 then
      result := 'a';
    if cislo = 11 then
      result := 'b';
    if cislo = 12 then
      result := 'c';
    if cislo = 13 then
      result := 'd';
    if cislo = 14 then
      result := 'e';
    if cislo = 15 then
      result := 'f';
  end;

  function NewGuid: string;
  var
    I: Integer;
  begin
    result := '';
    for I := 1 to 8 do
      result := result + Hexa(Round(Int(Random(16))));
    result := result + '-';
    for I := 1 to 4 do
      result := result + Hexa(Round(Int(Random(16))));
    result := result + '-4';
    for I := 1 to 3 do
      result := result + Hexa(Round(Int(Random(16))));
    result := result + '-';
    result := result + Hexa(8 + Round(Int(Random(4))));
    for I := 1 to 3 do
      result := result + Hexa(Round(Int(Random(16))));
    result := result + '-';
    for I := 1 to 12 do
      result := result + Hexa(Round(Int(Random(16))));
  end;

begin
  result := Trzba.Create;
  result.Hlavicka := TrzbaHlavickaType.Create;
  result.Hlavicka.uuid_zpravy := NewGuid;
  // Result.Hlavicka.uuid_zpravy := TGuid.NewGuid.ToString;
  // Result.Hlavicka.uuid_zpravy := LowerCase(Copy(Result.Hlavicka.uuid_zpravy, 2, Length(Result.Hlavicka.uuid_zpravy)-2));

  result.Hlavicka.dat_odesl := dateTime.Create;
  result.Hlavicka.dat_odesl.UseZeroMilliseconds := false;

  result.Hlavicka.prvni_zaslani := True;
  result.Hlavicka.overeni := false;

  result.Hlavicka.dat_odesl.AsDateTime := now;

  result.Data := TrzbaDataType.Create;
  result.Data.dat_trzby := dateTime.Create;
  result.Data.dat_trzby.UseZeroMilliseconds := false;
  // Result.Data.celk_trzba := CastkaType.Create;
  // Result.Data.cerp_zuct := CastkaType.Create;
  // Result.Data.cest_sluz := CastkaType.Create;
  // Result.Data.dan1 := CastkaType.Create;
  // Result.Data.dan2 := CastkaType.Create;
  // Result.Data.dan3 := CastkaType.Create;
  // Result.Data.pouzit_zboz1 := CastkaType.Create;
  // Result.Data.pouzit_zboz2 := CastkaType.Create;
  // Result.Data.pouzit_zboz3 := CastkaType.Create;
  // Result.Data.urceno_cerp_zuct := CastkaType.Create;
  // Result.Data.zakl_dan1 := CastkaType.Create;
  // Result.Data.zakl_dan2 := CastkaType.Create;
  // Result.Data.zakl_dan3 := CastkaType.Create;
  // Result.Data.zakl_nepodl_dph := CastkaType.Create;

  // KontrolniKody prepare
  result.KontrolniKody := TrzbaKontrolniKodyType.Create;
  result.KontrolniKody.pkp := PkpElementType.Create;
  result.KontrolniKody.bkp := BkpElementType.Create;
end;

function TEETTrzba.SendRevenue(aHttpClient: TEETHttpClient; const parameters: Trzba; SendOnly: boolean;
  aTimeOut: Integer): Odpoved;
var
  SOAPRequest, SOAPResponse: TMemoryStream;
  TT: TEETTrzbaThread;
  h: tHandle;
  WaitResult: DWORD;
  Tmp: Cardinal;

{$IFNDEF USE_LIBEET}
  DocTrzba: IXMLDocument;
  aSOAPEnv: TSoapEnvelope;
  Doc: IXMLDocument;
  HeaderNode: IXMLNode;
{$ENDIF}
  EnvNode, BodyNode, OdpovedNode: IXMLNode;

  procedure GenerateRequest;
  begin
{$IFNDEF USE_LIBEET}
    DocTrzba := NewXMLDocument;
    aSOAPEnv := TSoapEnvelope.Create;
    Doc := NewXMLDocument;
    try
      Doc.Options := [doNodeAutoCreate];
      DocTrzba.Options := [doNodeAutoCreate];
{$ENDIF}
      if not SendOnly then
        SignRevenue(parameters);
      SOAPRequest.Clear;
      SaveToXML(parameters, SOAPRequest);
      SOAPRequest.Position := 0;

{$IFNDEF USE_LIBEET}
      { * Make SOAP Envelope with DocTrzba body - BEGIN * }
      DocTrzba.LoadFromStream(SOAPRequest);
      EnvNode := aSOAPEnv.MakeEnvelope(Doc, []);
      HeaderNode := aSOAPEnv.MakeHeader(EnvNode, []);
      BodyNode := aSOAPEnv.MakeBody(EnvNode, []);
      BodyNode.ChildNodes.Add(DocTrzba.DocumentElement);
      SOAPRequest.Clear;
      Doc.SaveToStream(SOAPRequest);
      BodyNode := nil;
      HeaderNode := nil;
      EnvNode := nil;
      { * Make SOAP Envelope with DocTrzba body - END* }
{$ENDIF}
      { * Sign SOAP Envelope with customer certificate* }
      SignRequest(SOAPRequest);

      { * Copy Request to public property * }
      RequestStream.Clear;
      SOAPRequest.Position := 0;
      RequestStream.CopyFrom(SOAPRequest, SOAPRequest.Size - SOAPRequest.Position);

{$IFNDEF USE_LIBEET}
    finally
      aSOAPEnv.Free;
      Doc := nil;
      DocTrzba := nil;
    end;
{$ENDIF}
  end;

  procedure ParseResponse;
  var
    Converter: IObjConverter;
    XMLin: IXMLDocument;
  begin
    XMLin := NewXMLDocument;
    SOAPResponse.Position := 0;
    XMLin.LoadFromStream(SOAPResponse);
    EnvNode := XMLin.DocumentElement;
    OdpovedNode := nil; // init
    BodyNode := nil; // init
    if EnvNode <> nil then
      BodyNode := EnvNode.ChildNodes.FindNode('Body');
    if BodyNode <> nil then
      OdpovedNode := BodyNode.ChildNodes.FindNode('Odpoved', FISKXML_TNSSCHEMA_URI);

    if OdpovedNode <> nil then
      begin
        Converter := TSOAPDomConv.Create(NIL);
        if result = nil then
          result := Odpoved.Create;
        result.SOAPToObject(EnvNode, OdpovedNode, Converter);
      end;
  end;

begin
  Assert(aHttpClient <> nil, 'EETHttpClient is not defined');
  FValidResponse := True;
  FValidResponseCert := True;
  FErrorCode := 0;
  FErrorMessage := '';
  result := nil;

  // milisecond in output correction
  parameters.Hlavicka.dat_odesl.XSToNative(EETDateTimeToXMLTime(parameters.Hlavicka.dat_odesl.AsDateTime));
  parameters.Data.dat_trzby.XSToNative(EETDateTimeToXMLTime(parameters.Data.dat_trzby.AsDateTime));

  SOAPRequest := TMemoryStream.Create;
  SOAPResponse := TMemoryStream.Create;
  try
    try
      GenerateRequest;
{$IFNDEF LEGACY_RIO}
      if Assigned(FOnBeforeSendRequest) then
        FOnBeforeSendRequest('OdeslatTrzbu', SOAPRequest);
{$ENDIF}
      try
        if aTimeOut <> 0 then
          begin
            TT := TEETTrzbaThread.Create(True);
            try
              TT.FreeOnTerminate := false;
              TT.URL := URL;
              TT.HttpClient := aHttpClient;
              TT.LoadRequestFromStream(SOAPRequest);
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
                    // Thread arrived in time, response is valid
                    FErrorCode := TT.ErrCode;
                    FErrorMessage := TT.ErrMessage;
                    SOAPResponse.Clear;
                    TT.SaveResponseToStream(SOAPResponse);
                  end;
              else
                begin
                  // Thread still running
                  if GetHandleInformation(h, Tmp) then
                    TT.Terminate; // Thread handle still valid, we signal termination?
                  if WaitResult = WAIT_TIMEOUT then
                    begin
                      FErrorCode := -2;
                      FErrorMessage := 'Send timeout expired !!!';
                    end
                  else
                    begin
                      // calling in the Thread has failed
                      FErrorCode := -2;
                      FErrorMessage := 'Send timeout expired !!!';
                    end;
                end;
              end; // Case
            finally
              TT.Free;
            end;
          end
        else
          begin
            aHttpClient.SendRequest(URL, SOAPRequest, SOAPResponse);
          end;

        if FErrorCode = 0 then
          begin
            { * copy response to public property * }
            SOAPResponse.Position := 0;
            FResponseStream.Clear;
            FResponseStream.CopyFrom(SOAPResponse, SOAPResponse.Size);

            { * check SOAP response for valid XML signature* }
            ValidateResponse(SOAPResponse);

            { * parse response to result object if response XML is Valid * }
            if FValidResponse then
              ParseResponse;

            { * custom actions on the request * }
            SOAPResponse.Position := 0;
            if Assigned(FOnAfterSendRequest) then
              FOnAfterSendRequest('OdeslatTrbu', SOAPResponse);
          end;

      except
        on E: Exception do
          begin
            // error in sending request and parsing response
            FErrorCode := -3;
            FErrorMessage := '[' + E.ClassName + '] ' + E.Message;
          end;
      end;

    except
      on E: Exception do
        begin
          // error in generaterequest
          FErrorCode := -1;
          FErrorMessage := E.Message;
        end;
    end;
  finally
    SOAPRequest.Free;
    SOAPResponse.Free;
  end;
end;

function TEETTrzba.SendRevenueWithRIO(const parameters: Trzba; SendOnly: boolean; aTimeOut: Integer): Odpoved;
var
  TT: TEETTrzbaRIOThread;
  Service: EET;
  h: tHandle;
  WaitResult: DWORD;
  Tmp: Cardinal;

begin
  FValidResponse := True;
  FValidResponseCert := True;
  FErrorCode := 0;
  FErrorMessage := '';
  result := nil;

  Service := GetEET(false, URL, GetEETRIO(self));

  // milisecond in output correction
  parameters.Hlavicka.dat_odesl.XSToNative(EETDateTimeToXMLTime(parameters.Hlavicka.dat_odesl.AsDateTime));
  parameters.Data.dat_trzby.XSToNative(EETDateTimeToXMLTime(parameters.Data.dat_trzby.AsDateTime));

  if not SendOnly then
    SignRevenue(parameters);

  try
    if aTimeOut <> 0 then
      begin
        TT := TEETTrzbaRIOThread.Create(True);
        try
          TT.FreeOnTerminate := false;
          TT.EET := Service;
          TT.EETTrzba := parameters;
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
                // Thread arrived in time, response is valid
                FErrorCode := TT.ErrCode;
                FErrorMessage := TT.ErrMessage;
                result := TT.EETOdpoved;
              end;
          else
            begin
              // Thread still running
              if GetHandleInformation(h, Tmp) then
                TT.Terminate; // Thread handle still valid, we signal termination?
              if WaitResult = WAIT_TIMEOUT then
                begin
                  FErrorCode := -2;
                  FErrorMessage := 'Send timeout expired !!!';
                end
              else
                begin
                  // calling in the Thread has failed
                  FErrorCode := -2;
                  FErrorMessage := 'Send timeout expired !!!';
                end;
            end;
          end; // Case
        finally
          TT.Free;
        end;
      end
    else
      result := Service.OdeslaniTrzby(parameters); { invoke the service }

  except
    on E: Exception do
      begin
        // error in sending request and parsing response
        FErrorCode := -3;
        FErrorMessage := E.Message;
      end;
  end;
end;

procedure TEETTrzba.SaveToXML(const parameters: Trzba; const DestStream: TStream);
var
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeRoot: IXMLNode;
  XML: IXMLDocument;
  XMLStr: {$IFDEF LEGACY_RIO}InvString{$ELSE}String{$ENDIF};
  XMLAnsiStr: AnsiString;
begin
  XML := TXMLDocument.Create(nil);
  Converter := TSOAPDomConv.Create(NIL);
  try
    XML.Active := True;
    XML.Options := [doNodeAutoCreate];
    XML.Encoding := 'utf-8';
    NodeRoot := XML.CreateNode('Root');
    NodeObject := parameters.ObjectToSOAP(NodeRoot, NodeRoot, Converter, 'Trzba', '', {$IFNDEF LEGACY_RIO} '',
{$ENDIF} [ocoDontPrefixNode, ocoDontPutTypeAttr], XMLStr);
    NodeObject.Attributes['xmlns'] := FISKXML_TNSSCHEMA_URI;
    XMLAnsiStr := AnsiString(NodeObject.XML);
    XML.Active := false;
    XMLAnsiStr := AnsiString(AnsiReplaceStr(string(XMLAnsiStr), ' xmlns=""', ''));
    DestStream.WriteBuffer(Pointer(XMLAnsiStr)^, Length(XMLAnsiStr) * SizeOf(XMLAnsiStr[1]));
  finally
    XML := nil;
  end;
end;

procedure TEETTrzba.SignRequest(SOAPRequest: TStream);
{$IFNDEF USE_LIBEET}
var
  XMLDoc, xmlDocTemp: IXMLDocument;
  iNode: IXMLNode;
{$ENDIF}
begin
  if not FSigner.Active then
    FSigner.Active := True;

  (SOAPRequest as TMemoryStream).Position := 0;

{$IFNDEF USE_LIBEET}
  xmlDocTemp := NewXMLDocument;
  xmlDocTemp.Options := [];
  xmlDocTemp.LoadFromStream(SOAPRequest as TMemoryStream);

  XMLDoc := NewXMLDocument;
  XMLDoc.Options := [];
  iNode := XMLDoc.AddChild('soap:Envelope');
  iNode.DeclareNamespace('soap', 'http://schemas.xmlsoap.org/soap/envelope/');
  iNode.Attributes['xmlns:wsu'] := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
  iNode.AddChild(SSoapNameSpacePre + ':Header', 'http://schemas.xmlsoap.org/soap/envelope/');
  iNode := iNode.AddChild('soap:Body');
  iNode.ChildNodes.Add(xmlDocTemp.DocumentElement.ChildNodes.FindNode(SSoapNameSpacePre + ':Body').ChildNodes[0]);

  iNode := XMLDoc.ChildNodes.FindNode('soap:Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode('soap:Body');
      if iNode <> nil then
        begin
          iNode.Attributes['wsu:Id'] := 'id-TheBody';
        end;
    end;
  iNode := XMLDoc.ChildNodes.FindNode('soap:Envelope');
  if iNode <> nil then
    begin
      iNode := iNode.ChildNodes.FindNode(SSoapNameSpacePre + ':Header');
      if iNode <> nil then
        begin
          InsertWsse(iNode);
          iNode := iNode.ChildNodes.FindNode('wsse:Security',
            'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
          if iNode <> nil then
            begin
              iNode := iNode.ChildNodes.FindNode('wsse:BinarySecurityToken',
                'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd');
              if iNode <> nil then
                iNode.Text := string(FSigner.GetRawCertDataAsBase64String);
            end;
        end;
    end;
  (SOAPRequest as TMemoryStream).Clear;
  XMLDoc.SaveToStream(SOAPRequest as TMemoryStream);
{$ENDIF}
  FSigner.SignXML(SOAPRequest as TMemoryStream);
end;

function TEETTrzba.SignRevenue(const parameters: Trzba): boolean;
var
  sPKPData: string;
begin
  result := false;
  if not IsInitialized then
    exit;

  // milisecond in output correction
  parameters.Hlavicka.dat_odesl.XSToNative(EETDateTimeToXMLTime(parameters.Hlavicka.dat_odesl.AsDateTime));
  parameters.Data.dat_trzby.XSToNative(EETDateTimeToXMLTime(parameters.Data.dat_trzby.AsDateTime));

  // prepare element KontrolniKody
  if parameters.KontrolniKody = nil then
    parameters.KontrolniKody := TrzbaKontrolniKodyType.Create;
  if parameters.KontrolniKody.pkp = nil then
    parameters.KontrolniKody.pkp := PkpElementType.Create;
  if parameters.KontrolniKody.bkp = nil then
    parameters.KontrolniKody.bkp := BkpElementType.Create;

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

  // generate PKP
  parameters.KontrolniKody.pkp.Text := FSigner.MakePKP(sPKPData);
  // generate BKP
  parameters.KontrolniKody.bkp.Text := FSigner.MakeBKP(sPKPData);

  result := parameters.KontrolniKody.pkp.Text <> '';
end;

procedure TEETTrzba.ValidateResponse(SOAPResponse: TStream);
begin
  FValidResponse := false;
  FValidResponseCert := false;

  FValidResponse := FSigner.VerifyXML(SOAPResponse as TMemoryStream, 'Body', 'Id');

  if FValidResponse then
    begin
      FValidResponseCert := True;
      if Assigned(FOnVerifyResponseEvent) then
        FOnVerifyResponseEvent(FSigner.ResponseCertInfo, FValidResponse);
    end;
end;

initialization

Randomize;

end.
