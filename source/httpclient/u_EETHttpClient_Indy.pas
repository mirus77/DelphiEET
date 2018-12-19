unit u_EETHttpClient_Indy;

interface
{$IFNDEF UNICODE}
{$DEFINE LEGACY_RIO}
{$ENDIF}

uses SysUtils, Classes, IdHttp, IdURI, IdSSLOpenSSL, u_EETHttpClient;

type
  TEETHttpClientIndy = class(TEETHttpClient)
  private
    function DoVerifyPeer(Certificate: TIdX509; AOk: Boolean{$IFNDEF LEGACY_RIO}; ADepth, AError: Integer{$ENDIF}): Boolean;
  protected
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure SendRequest(aUrl: String; aRequestStream: TStream; aResponseStream: TStream); override;
  published
  end;

implementation

uses DateUtils;

{ TEETHttpClientIndy }

constructor TEETHttpClientIndy.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FRootCertFile := '';
  FHttpsTrustName := 'www.eet.cz';
end;

destructor TEETHttpClientIndy.Destroy;
begin
  inherited Destroy;
end;

function TEETHttpClientIndy.DoVerifyPeer(Certificate: TIdX509; AOk: Boolean{$IFNDEF LEGACY_RIO};
  ADepth, AError: Integer{$ENDIF}): Boolean;
var
  TempList: TStringList;
  Cn: String;
begin
  Result := AOk;
  // check subject validity
  if Result {$IFNDEF LEGACY_RIO}and (ADepth = 0){$ENDIF} and (FHttpsTrustName <> '') then
    begin
      // check common name by HtttpTrustName
      Cn := '';
      TempList := TStringList.Create;
      try
        TempList.Delimiter := '/';
        TempList.DelimitedText := Certificate.Subject.OneLine;
        Cn := Trim(TempList.Values['CN']);
      finally
        TempList.Free;
      end;
      Result := SameText(Cn, FHttpsTrustName)
    end;
end;

procedure TEETHttpClientIndy.SendRequest(aUrl: String; aRequestStream: TStream; aResponseStream: TStream);
var
  FIdHttpClient: TIdHttp;
  aUri: TIdUri;
begin
  FIdHttpClient := TIdHttp.Create(nil);
  aUri := TIdUri.Create(aUrl);
  try
    try
      FIdHttpClient.HandleRedirects := True;
      FIdHttpClient.ConnectTimeout := FConnectTimeout;
      FIdHttpClient.HTTPOptions := FIdHttpClient.HTTPOptions + [hoKeepOrigProtocol];
      if UpperCase(aUri.Protocol) = 'HTTPS' then
        FIdHttpClient.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(FIdHttpClient);
      if FIdHttpClient.IOHandler is TIdSSLIOHandlerSocketOpenSSL then
        begin
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).Port := 0;
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).DefaultPort := 0;
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.Method := sslvTLSv1_1;
          TIdSSLIOHandlerSocketOpenSSL(FIdHttpClient.IOHandler).SSLOptions.SSLVersions := [sslvTLSv1_1];
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
      if FUseProxy then
        begin
          FIdHttpClient.ProxyParams.ProxyServer := FProxyHost;
          FIdHttpClient.ProxyParams.ProxyPort := FProxyPort;
          if FProxyUsername <> '' then
            begin
              FIdHttpClient.ProxyParams.ProxyUsername := FProxyUsername;
              FIdHttpClient.ProxyParams.ProxyPassword := FProxyPassword;
            end;
        end;
      FIdHttpClient.Post(aUrl, aRequestStream, aResponseStream);
    except
      on E: Exception do
        raise EEETHttpClientException.Create(E.Message);
    end;
  finally
    aUri.Free;
    FIdHttpClient.Free;
  end;
end;

end.
