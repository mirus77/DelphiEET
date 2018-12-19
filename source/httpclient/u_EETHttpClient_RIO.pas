unit u_EETHttpClient_RIO;

interface

// For Delphi XE3 and up:
{$IF CompilerVersion >= 24.0 }
  {$LEGACYIFEND ON}
{$IFEND}

// For Delphi 10.3 and up:
{$IF CompilerVersion >= 33.0 }
  {$DEFINE NetHTTPClient}
{$IFEND}

uses SysUtils, Classes, Windows, u_EETHttpClient, SOAPHTTPClient,
  {$IFDEF NetHTTPClient}Net.HttpClient,{$ENDIF}
  u_EETServiceSOAP, SOAPHTTPTrans;

type
  TEETRIO = class;

  TEETHttpClientRIO = class(TEETHttpClient)
  protected
    FResponseStream: TMemoryStream;
    function GetEETRIO : TEETRIO;
    procedure LoadFromXML(parameters: Trzba; const SourceStream : TStream);
    procedure SaveToXML(const parameters: Trzba; const DestStream : TStream);
  public
    constructor Create(aOwner : TComponent); override;
    destructor Destroy; override;
    procedure SendRequest(aUrl : String; aRequestStream: TStream; aResponseStream: TStream); override;
  published
    property ResponseStream: TMemoryStream read FResponseStream;
  end;

  TEETRIO = class(THTTPRIO)
  private
    FHttpClient: TEETHttpClientRIO;
  protected
    procedure HTTPWebNode_BeforePost(const AHTTPReqResp: THTTPReqResp; {$IFDEF NetHTTPClient}AClient : THttpClient{$ELSE}AData: Pointer{$ENDIF});
    procedure HTTPRIO_AfterExecute(const MethodName: string; SOAPResponse: TStream);
    {$IFNDEF NetHTTPClient}
    function DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property HttpClient : TEETHttpClientRIO read FHttpClient write FHttpClient;
  end;


implementation

uses InvokeRegistry, OPToSOAPDomConv, XMLDoc, XMLIntf, StrUtils;

{$IFNDEF NetHTTPClient}
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

{ TEETHttpClientRIO }

constructor TEETHttpClientRIO.Create(aOwner: TComponent);
begin
  FResponseStream := TMemoryStream.Create;
end;

destructor TEETHttpClientRIO.Destroy;
begin
  FResponseStream.Free;
  inherited Destroy;
end;

function TEETHttpClientRIO.GetEETRIO: TEETRIO;
begin
  Result := TEETRIO.Create(nil);
  Result.HttpClient := self;
  Result.HTTPWebNode.ConnectTimeout := Self.ConnectTimeout;
//  Result.HTTPWebNode.SendTimeout := Self.SendTimeout;
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

procedure TEETHttpClientRIO.LoadFromXML(parameters: Trzba; const SourceStream: TStream);
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

procedure TEETHttpClientRIO.SaveToXML(const parameters: Trzba;
  const DestStream: TStream);
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
    NodeObject.Attributes['xmlns'] := 'http://fs.mfcr.cz/eet/schema/v3';
    XMLAnsiStr := AnsiString(NodeObject.XML);
    XML.Active := False;
    XMLAnsiStr := AnsiString(AnsiReplaceStr(string(XMLAnsiStr), ' xmlns=""', ''));
    DestStream.WriteBuffer(Pointer(XMLAnsiStr)^, Length(XMLAnsiStr) * SizeOf(XMLAnsiStr[1]));
  finally
    XML := nil;
  end;
end;

procedure TEETHttpClientRIO.SendRequest(aUrl: String; aRequestStream,
  aResponseStream: TStream);
var
  Service : EET;
  aTrzba : Trzba;
  Odp : Odpoved;
begin
  Service := GetEET(False, aURL, GetEETRIO);
  aTrzba := Trzba.Create;
  try
    aRequestStream.Position := 0;
    TMemoryStream(aRequestStream).SaveToFile('request-before-send.xml');
    LoadFromXML(aTrzba, aRequestStream);
    Odp := Service.OdeslaniTrzby(aTrzba);
    FResponseStream.Position := 0;
    FResponseStream.SaveToStream(aResponseStream);
  finally
    aTrzba.Free;
  end;
end;

{ TEETRIO }

constructor TEETRIO.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFNDEF LEGACY_RIO}
  {$IFNDEF NetHTTPClient}
  HTTPWebNode.OnWinInetError := DoOnWinInetError;
  {$ENDIF}
  HTTPWebNode.InvokeOptions := HTTPWebNode.InvokeOptions - [soIgnoreInvalidCerts];
  {$ENDIF}

  {$IFNDEF LEGACY_RIO}
  HTTPWebNode.WebNodeOptions := [];
  {$ENDIF}

  HTTPWebNode.OnBeforePost := HTTPWebNode_BeforePost;
  OnAfterExecute := HTTPRIO_AfterExecute;
end;

destructor TEETRIO.Destroy;
begin

  inherited Destroy;
end;

{$IFNDEF NetHTTPClient}
function TEETRIO.DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
begin
  if LastError <> ERROR_SUCCESS then
      raise Exception.Create(GetWinInetError(LastError));
    Result := ERROR_SUCCESS;
end;
{$ENDIF}

procedure TEETRIO.HTTPRIO_AfterExecute(const MethodName: string;
  SOAPResponse: TStream);
begin
  SOAPResponse.Position:=0;
  if Assigned(FHttpClient) then
    begin
      FHttpClient.ResponseStream.Clear;
      FHttpClient.ResponseStream.CopyFrom(SOAPResponse, SOAPResponse.Size - SOAPResponse.Position);
    end;
end;

{$IFDEF NetHTTPClient}
procedure TEETRIO.HTTPWebNode_BeforePost(const AHTTPReqResp: THTTPReqResp;
  AClient: THttpClient);
begin

end;
{$ELSE}
procedure TEETRIO.HTTPWebNode_BeforePost(const AHTTPReqResp: THTTPReqResp;
  AData: Pointer);
begin

end;
{$ENDIF}

end.