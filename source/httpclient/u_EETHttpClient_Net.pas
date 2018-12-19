unit u_EETHttpClient_Net;

interface

uses SysUtils, Classes, Net.HttpClient, Net.URLClient, u_EETHttpClient;

type
  {*
    This Client check only HTTPS Certificate and not check HTTPTrustName
   *}
  TEETHttpClientNet = class(TEETHttpClient)
  private
  protected
     procedure ValidateCertificateEvent(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
  public
    procedure SendRequest(aUrl : String; aRequestStream: TStream; aResponseStream: TStream); override;
  published
  end;

implementation

{ TEETHttpClientNet }

procedure TEETHttpClientNet.SendRequest(aUrl : String; aRequestStream: TStream; aResponseStream: TStream);
var
  aHttp : THttpClient;
  aUri : TUri;
begin
  aHttp := THttpClient.Create;
  try
    aHttp.HandleRedirects := true;
    aHttp.ConnectionTimeout := FConnectTimeout;
    aHttp.ResponseTimeout := FReceiveTimeout;

    aUri := TUri.Create(aUrl);
    if aUri.Scheme = aUri.SCHEME_HTTPS then
      begin
        aHttp.SecureProtocols := [THTTPSecureProtocol.TLS11, THTTPSecureProtocol.TLS12];
        aHttp.OnValidateServerCertificate := ValidateCertificateEvent;
      end;

    if FUseProxy then
        aHttp.ProxySettings := TProxySettings.Create(FProxyHost, FProxyPort, FProxyUsername, FProxyPassword);

    aRequestStream.Position := 0;
    try
      aHttp.Post(aURL, aRequestStream, aResponseStream);
    except
      on E: Exception do
        raise EEETHttpClientException.Create(E.Message);
    end;
  finally
    aHttp.Free;
  end;
end;

procedure TEETHttpClientNet.ValidateCertificateEvent(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  {* Trigger only if server certificate is not valid for HttpClient !!! *}
  Accepted := False;
end;

end.