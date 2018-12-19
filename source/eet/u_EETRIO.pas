unit u_EETRIO;

interface
{$IFNDEF UNICODE}
{$DEFINE LEGACY_RIO}
{$ENDIF}
// For Delphi XE3 and up:
{$IF CompilerVersion >= 24.0 }
{$LEGACYIFEND ON}
{$IFEND}
{$IF CompilerVersion >= 33.0}
{$DEFINE DELPHI33_UP}
{$IFEND}
{.$DEFINE USE_INDY}

uses
  Windows, SysUtils, Classes, InvokeRegistry, Rio, SOAPHTTPClient, u_EETTrzba, SOAPHTTPTrans,
{$IFDEF DELPHI33_UP} Net.HttpClient, Net.URLClient, {$ENDIF}
  ActiveX, u_EETServiceSOAP;

type
  TEETRIO = class(THTTPRIO)
  private
    FEET: TEETTrzba;
  protected
{$IFDEF LEGACY_RIO}
    procedure HTTPRIO_BeforeExecute(const MethodName: string; var SOAPRequest: InvString);
{$ELSE}
    procedure HTTPRIO_BeforeExecute(const MethodName: string; SOAPRequest: TStream);
{$ENDIF}
    procedure HTTPRIO_AfterExecute(const MethodName: string; SOAPResponse: TStream);
{$IFNDEF DELPHI33_UP}
    function DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property EET: TEETTrzba read FEET write FEET;
  end;

  TEETTrzbaRIOThread = class(TThread)
  private
  public
    ErrMessage: String;
    ErrCode: Integer;
    EET: EET;
    EETOdpoved: Odpoved;
    EETTrzba: Trzba;
    procedure Execute; override;
  end;

function GetEETRIO(aEET: TEETTrzba; aConnTimeOut: Integer = 5000; aReceiveTimeOut: Integer = 10000): TEETRIO;

implementation

{$IFNDEF DELPHI33_UP}

function GetWinInetError(ErrorCode: Cardinal): string;
const
  winetdll = 'wininet.dll';
var
  Len: Integer;
  Buffer: PChar;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ALLOCATE_BUFFER or
    FORMAT_MESSAGE_IGNORE_INSERTS or FORMAT_MESSAGE_ARGUMENT_ARRAY, Pointer(GetModuleHandle(winetdll)), ErrorCode, 0, @Buffer,
    SizeOf(Buffer), nil);
  try
    while (Len > 0) and {$IFDEF UNICODE}(CharInSet(Buffer[Len - 1], [#0 .. #32, '.']))
{$ELSE}(Buffer[Len - 1] in [#0 .. #32, '.']) {$ENDIF} do
      Dec(Len);
    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;
{$ENDIF}

function GetEETRIO(aEET: TEETTrzba; aConnTimeOut: Integer; aReceiveTimeOut: Integer): TEETRIO;
begin
  Result := TEETRIO.Create(nil);
  Result.EET := aEET;
  Result.HTTPWebNode.ConnectTimeout := aConnTimeOut;
{$IFNDEF DELPHI33_UP}
  Result.HTTPWebNode.SendTimeout := aReceiveTimeOut;
{$ENDIF}
  Result.HTTPWebNode.ReceiveTimeout := aReceiveTimeOut;
  Result.HTTPWebNode.InvokeOptions := Result.HTTPWebNode.InvokeOptions - [soIgnoreInvalidCerts];
  { *
    if (FProxyHost <> '') and FUseProxy then
    begin
    if FProxyPort > 0 then
    Result.HTTPWebNode.Proxy := Format('%s:%d',[FProxyHost, FProxyPort]) // 'server_ip:port'
    else
    Result.HTTPWebNode.Proxy := FProxyHost;
    Result.HTTPWebNode.Username := FProxyUsername;
    Result.HTTPWebNode.Password := FProxyPassword;
    end;
  }
end;

{ TEETRIO }

constructor TEETRIO.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFNDEF USE_INDY}
{$IFNDEF LEGACY_RIO}
{$IFNDEF DELPHI33_UP}
  HTTPWebNode.OnWinInetError := DoOnWinInetError;
{$ENDIF}
  HTTPWebNode.InvokeOptions := HTTPWebNode.InvokeOptions - [soIgnoreInvalidCerts];
{$ENDIF}
{$ENDIF}
{$IFNDEF LEGACY_RIO}
  HTTPWebNode.WebNodeOptions := [];
{$ENDIF}
  OnBeforeExecute := HTTPRIO_BeforeExecute;
  OnAfterExecute := HTTPRIO_AfterExecute;
end;

destructor TEETRIO.Destroy;
begin
  inherited Destroy;
end;

{$IFNDEF DELPHI33_UP}

function TEETRIO.DoOnWinInetError(LastError: DWord; Request: Pointer): DWord;
begin
  if LastError <> ERROR_SUCCESS then
    raise Exception.Create(GetWinInetError(LastError));
  Result := ERROR_SUCCESS;
end;
{$ENDIF}

procedure TEETRIO.HTTPRIO_AfterExecute(const MethodName: string; SOAPResponse: TStream);
begin
  SOAPResponse.Position := 0;
  if Assigned(FEET) then
    begin
      FEET.ResponseStream.Clear;
      FEET.ResponseStream.CopyFrom(SOAPResponse, SOAPResponse.Size - SOAPResponse.Position);
      SOAPResponse.Position := 0;
      if Assigned(FEET.OnAfterSendRequest) then
        FEET.OnAfterSendRequest(MethodName, SOAPResponse);
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
        { * Make SOAP wsse BinaryToken * }
        FEET.SignRequest(MemStream);
        MemStream.Position := 0;
        SetLength(S, MemStream.Size);
        MemStream.Read(S[1], MemStream.Size);
        MemStream.Position := 0;
        { * Copy to public request stream * }
        FEET.RequestStream.Clear;
        FEET.RequestStream.CopyFrom(MemStream, MemStream.Size);
        SOAPRequest := UTF8Decode(S);
      finally
        MemStream.Free;
      end;
      { * Other custom operation before posting request * }
      if Assigned(FEET.OnBeforeSendRequest) then
        FEET.OnBeforeSendRequest(MethodName, SOAPRequest);
    end;
end;
{$ELSE}

procedure TEETRIO.HTTPRIO_BeforeExecute(const MethodName: string; SOAPRequest: TStream);
begin
  SOAPRequest.Position := 0;
  if Assigned(FEET) then
    begin
      { * Make SOAP wsse BinaryToken * }
      FEET.SignRequest(SOAPRequest);
      SOAPRequest.Position := 0;
      { * Copy to public request stream * }
      FEET.RequestStream.Clear;
      SOAPRequest.Position := 0;
      FEET.RequestStream.CopyFrom(SOAPRequest, SOAPRequest.Size - SOAPRequest.Position);
      { * Other custom operation before posting request * }
      SOAPRequest.Position := 0;
      if Assigned(FEET.OnBeforeSendRequest) then
        FEET.OnBeforeSendRequest(MethodName, SOAPRequest);
    end;
end;
{$ENDIF}
{ TEETTrzbaRIOThread }

procedure TEETTrzbaRIOThread.Execute;
begin
  try
    ErrCode := 0;
    EETOdpoved := nil;
    CoInitialize(nil);
    try
      EETOdpoved := EET.OdeslaniTrzby(EETTrzba);
    except
      on E: Exception do
        begin
          ErrCode := -3;
          ErrMessage := '[' + E.ClassName + '] ' + E.Message;
        end;
    end;
    CoUninitialize;
  except
  end;
end;

end.
