{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

{ *
  requirement : Synapse library at http://synapse.ararat.cz
  * }

unit u_EETHttpClient_Synapse;

interface

uses SysUtils, Classes, HTTPSend, ssl_openssl, u_EETHttpClient;

type
  TEETHttpClientSynapse = class(TEETHttpClient)
  private
  protected
  public
    procedure SendRequest(aUrl: String; aRequestStream: TStream; aResponseStream: TStream); override;
  published
  end;

implementation

{ TEETHttpClientSynapse }

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
