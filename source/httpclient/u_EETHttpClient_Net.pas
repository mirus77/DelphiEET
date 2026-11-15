{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

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
      aHttp.Post(aURL, aRequestStream, aResponseStream, [TNetHeader.Create('Content-Type', 'text/xml; charset=utf-8'), TNetHeader.Create('SOAPAction', '"http://fs.gov.cz/eet/OdeslaniTrzby"')]);
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
  {* Newer Delphi (e.g. 13) fires the event for every HTTPS connection, older versions only on a certificate error.
     Accepted on input = result of the system check (chain, CN, date) - we only make it stricter. *}
  Accepted := Accepted and (Certificate.Start < Now) and (Now < Certificate.Expiry);
  // CertName = CN of the certificate (CertGetNameString / CERT_NAME_SIMPLE_DISPLAY_TYPE)
  if Accepted and (HttpsTrustName <> '') then
    Accepted := SameText(Certificate.CertName, HttpsTrustName);
end;

end.