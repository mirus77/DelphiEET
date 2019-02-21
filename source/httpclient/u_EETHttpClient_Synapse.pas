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
  NewUrl:String;
  Redirected: boolean;
  i : integer;
begin
  NewUrl := aUrl;
  HTTP := THTTPSend.Create;
  try
    repeat
      Redirected := False;
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
      if HTTP.HTTPMethod('POST', NewUrl) then
        begin
          case HTTP.Resultcode of
            301, 302, 307:
            begin
              for i := 0 to HTTP.Headers.Count - 1 do
                if (Pos('location: ', lowercase(HTTP.Headers.Strings[i])) = 1) then
                begin
                  NewUrl := StringReplace(HTTP.Headers.Strings[i], 'location: ', '', [rfIgnoreCase]);
                  HTTP.Clear;
                  Redirected := True;
                  break;
                end;
            end;
          end;
        end
      else
        begin
          if HTTP.Sock.LastError <> 0 then
            raise EEETHttpClientException.Create(Self.ClassName + ' : ' + HTTP.Sock.LastErrorDesc);
          if HTTP.Sock.SSL.LastError <> 0 then
            raise EEETHttpClientException.Create(Self.ClassName + ' : ' + HTTP.Sock.SSL.LastErrorDesc);
        end;
    until not Redirected;
    aResponseStream.CopyFrom(HTTP.Document, 0);
    if HTTP.Resultcode >= 300 then
      raise EEETHttpClientException.Create(Self.ClassName + ' : ' + IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString);
  finally
    HTTP.Free;
  end;
end;

end.
