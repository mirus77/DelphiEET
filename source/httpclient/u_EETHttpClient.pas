{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

unit u_EETHttpClient;

interface

uses SysUtils, Classes, ActiveX;

type
  EEETHttpClientException = class(Exception);

  TEETHttpClient = class(TComponent)
  protected
    FProxyPort: integer;
    FSendTimeout: integer;
    FProxyPassword: string;
    FProxyHost: string;
    FProxyUsername: string;
    FConnectTimeout: integer;
    FReceiveTimeout: integer;
    FUseProxy: boolean;
    FRootCertFile: string;
    FHttpsTrustName: string;
  public
    constructor Create(aOwner: TComponent); override;
    procedure SendRequest(aUrl: String; aRequestStream: TStream; aResponseStream: TStream); virtual; abstract;
  published
    property ConnectTimeout: integer read FConnectTimeout write FConnectTimeout;
    property SendTimeout: integer read FSendTimeout write FSendTimeout;
    property ReceiveTimeout: integer read FReceiveTimeout write FReceiveTimeout;
    property UseProxy: boolean read FUseProxy write FUseProxy;
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: integer read FProxyPort write FProxyPort;
    property ProxyUsername: string read FProxyUsername write FProxyUsername;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
    property RootCertFile: string read FRootCertFile write FRootCertFile;
    property HttpsTrustName: string read FHttpsTrustName write FHttpsTrustName;
  end;

  TEETTrzbaThread = class(TThread)
  private
    FRequest: TMemoryStream;
    FResponse: TMemoryStream;
  public
    ErrMessage: String;
    URL: string;
    ErrCode: integer;
    HttpClient: TEETHttpClient;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure LoadRequestFromStream(SoapRequest: TStream);
    procedure SaveResponseToStream(SoapResponse: TStream);
    procedure Execute; override;
  end;

implementation

{ TEETHttpClient }

constructor TEETHttpClient.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FConnectTimeout := 2000;
  FSendTimeout := 3000;
  FReceiveTimeout := 3000;
  FUseProxy := False;
  FProxyHost := '';
  FProxyPort := 3128;
  FProxyUsername := '';
  FProxyPassword := '';
end;

{ TEETTrzbaThread }

procedure TEETTrzbaThread.AfterConstruction;
begin
  inherited;
  FRequest := TMemoryStream.Create;
  FResponse := TMemoryStream.Create;
end;

procedure TEETTrzbaThread.BeforeDestruction;
begin
  inherited;
  FRequest.Free;
  FResponse.Free;
end;

procedure TEETTrzbaThread.Execute;
begin
  try
    ErrCode := 0;
    CoInitialize(nil);
    try
      FRequest.Seek(0, soFromBeginning);
      FResponse.Clear;
      HttpClient.SendRequest(URL, FRequest, FResponse);
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

procedure TEETTrzbaThread.LoadRequestFromStream(SoapRequest: TStream);
begin
  FRequest.Position := 0;
  FRequest.LoadFromStream(SoapRequest);
end;

procedure TEETTrzbaThread.SaveResponseToStream(SoapResponse: TStream);
begin
  FResponse.Position := 0;
  SoapResponse.CopyFrom(FResponse, FResponse.Size - FResponse.Position);
end;

end.
