{ *
  requirement : Synapse library at http://synapse.ararat.cz
  * }
unit u_EETHttpClient_Synapse;

interface

uses SysUtils, Classes, HTTPSend, ssl_openssl, u_EETHttpClient;

type
  TEETHttpClientSynapse = class(TEETHttpClient)
  private
    FRootCertFile: string;
    FHttpsTrustName: string;
  protected
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure SendRequest(aUrl: String; aRequestStream: TStream; aResponseStream: TStream); override;
  published
    property RootCertFile: string read FRootCertFile write FRootCertFile;
    property HttpsTrustName: string read FHttpsTrustName write FHttpsTrustName;
  end;

implementation

{ TEETHttpClientSynapse }

constructor TEETHttpClientSynapse.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

end;

destructor TEETHttpClientSynapse.Destroy;
begin

  inherited Destroy;
end;

procedure TEETHttpClientSynapse.SendRequest(aUrl: String; aRequestStream, aResponseStream: TStream);
var
  HTTP: THTTPSend;
begin
  HTTP := THTTPSend.Create;
  try
    if FUseProxy then
      begin
        HTTP.ProxyHost := FProxyHost;
        HTTP.ProxyPort := IntToStr(FProxyPort);
        if FProxyUsername <> '' then
          begin
            HTTP.ProxyUser := FProxyUsername;
            HTTP.ProxyPass := FProxyPassword;
          end;
      end;
    HTTP.Sock.SSL.VerifyCert := Trim(FRootCertFile) <> '';
    if (HTTP.Sock.SSL.VerifyCert) then
      HTTP.Sock.SSL.CertCAFile := FRootCertFile;
    HTTP.Sock.ConnectionTimeout := FConnectTimeout;
    HTTP.Document.LoadFromStream(aRequestStream);
    HTTP.MimeType := 'text/xml';
    if HTTP.HTTPMethod('POST', aUrl) then
      begin
        aResponseStream.CopyFrom(HTTP.Document, 0)
      end
    else
      begin
        if HTTP.Sock.LastError <> 0 then
          raise EEETHttpClientException.Create(Self.ClassName + ' : ' + HTTP.Sock.LastErrorDesc);
        if HTTP.Sock.SSL.LastError <> 0 then
          raise EEETHttpClientException.Create(Self.ClassName + ' : ' + HTTP.Sock.SSL.LastErrorDesc);
      end;
  finally
    HTTP.Free;
  end;
end;

end.
