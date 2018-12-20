{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

{*
    requirement : SecureBridge components at https://www.devart.com/sbridge/
*}

unit u_EETHttpClient_SB;

interface

uses SysUtils, Classes, ScHttp, ScBridge, u_EETHttpClient;

type
  TEETHttpClientSB = class(TEETHttpClient)
  private
    procedure ScRemoteCertificateValidation(Sender: TObject; RemoteCertificate: TScCertificate; CertificateList: TList; var Errors: TScCertificateStatusSet);
  protected
  public
    constructor Create(aOwner : TComponent); override;
    procedure SendRequest(aUrl : String; aRequestStream: TStream; aResponseStream: TStream); override;
  end;

implementation

{ TEETHttpClientSB }

constructor TEETHttpClientSB.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FRootCertFile := '';
  FHttpsTrustName := 'www.eet.cz';
end;

procedure TEETHttpClientSB.ScRemoteCertificateValidation(Sender: TObject; RemoteCertificate: TScCertificate;
  CertificateList: TList; var Errors: TScCertificateStatusSet);
var
  Cert : TScCertificate;
  CACert : TScCertificate;
begin
  if FHttpsTrustName <> '' then
    begin
      // Compare Subject of server certificate with trusted defined subject 'www.eet.cz'
      if not SameText(RemoteCertificate.Subject, FHttpsTrustName) then
        Errors := Errors + [csOtherError];
    end;

  if FRootCertFile <> '' then
    begin
      CACert := TScCertificate.Create(nil);
      try
        CACert.ImportFrom(FRootCertFile, '');
        if CertificateList.Count > 0 then
          begin
            // Get publisher of server certificate
            Cert := TScCertificate(CertificateList[CertificateList.Count-1]);
            // Verify publisher of server certificate with trusted CA
            Cert.VerifyCertificate(CACert, Errors);
          end;
      finally
        CACert.Free;
      end;
    end;
end;

procedure TEETHttpClientSB.SendRequest(aUrl: String; aRequestStream, aResponseStream: TStream);
var
  aRequest: TScHttpWebRequest;
  aResponse : TScHttpWebResponse;
  Buf: TBytes;
begin
  aResponse := nil;
  aRequest := TScHttpWebRequest.Create(aUrl);
  try
    aRequest.Method := rmPOST;
    aRequest.SSLOptions.OnServerCertificateValidation := ScRemoteCertificateValidation;
    aRequest.ReadWriteTimeout := FConnectTimeout + FReceiveTimeout;
    aRequest.ContentType := 'text/xml';
    if FUseProxy then
      begin
        aRequest.Proxy.Address := FProxyHost;
        aRequest.Proxy.Port := FProxyPort;
        if FProxyUsername <> '' then
          begin
            aRequest.Proxy.Credentials.UserName := FProxyUsername;
            aRequest.Proxy.Credentials.Password := FProxyPassword;
          end;
      end;
    aRequestStream.Position := 0;
    SetLength(Buf, aRequestStream.Size); // Allocate buffer
    aRequestStream.Read(Buf, aRequestStream.Size);
    aRequest.ContentLength := Length(Buf);
    aRequest.WriteBuffer(Buf);
    SetLength(Buf, 0); // Clear buffer
    try
      // Http post
      aResponse := aRequest.GetResponse;
      if aResponse.StatusCode = TScHttpStatusCode.scOK then
        begin
          Buf := aResponse.ReadAsBytes;
          aResponseStream.WriteBuffer(Buf, Length(Buf));
          SetLength(Buf, 0); // Clear buffer
        end;
    except
      on E: Exception do
        raise EEETHttpClientException.Create(E.Message);
    end;
  finally
    if aResponse <> nil then aResponse.Free;
    aRequest.Free;
  end;
end;

end.