{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

unit u_main;

{* Configure USE_*_CLIENT in EETDefines.inc *}
{$I EETDefines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, SynEdit, SynEditHighlighter,
  SynHighlighterXML, ExtCtrls, ComCtrls,
  u_EETSigner,
  {$IFDEF USE_INDY_CLIENT}    u_EETHttpClient_Indy,   {$ENDIF}
  {$IFDEF USE_NETHTTP_CLIENT} u_EETHttpClient_Net,    {$ENDIF}
  {$IFDEF USE_SBRIDGE_CLIENT} u_EETHttpClient_SB,     {$ENDIF}
  {$IFDEF USE_SYNAPSE_CLIENT} u_EETHttpClient_Synapse,{$ENDIF}
  u_EETHttpClient;

type
  TTestEETForm = class(TForm)
    synxmlsyn2: TSynXMLSyn;
    synmRequest: TSynEdit;
    grpTrzba: TGroupBox;
    grpResponse: TGroupBox;
    synmResponse: TSynEdit;
    btnOdeslat: TButton;
    pnlDebug: TPanel;
    btnVerifyResponse: TButton;
    pgcDebug: TPageControl;
    tsRequest: TTabSheet;
    tsResponse: TTabSheet;
    btnFormatOdpoved: TButton;
    btnFormatRequest: TButton;
    lblKeyValidFrom: TLabel;
    lblKeyValidTo: TLabel;
    pnlCertInfo: TPanel;
    lblSpace1: TLabel;
    pnlKeySubject: TPanel;
    lblKeySubject: TLabel;
    pnlLog: TPanel;
    tsLog: TTabSheet;
    grpLog: TGroupBox;
    mmoLog: TMemo;
    procedure btnOdeslatClick(Sender: TObject);
    procedure btnVerifyResponseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFormatRequestClick(Sender: TObject);
    procedure btnFormatOdpovedClick(Sender: TObject);
  private
    procedure VerifyResponseCert(const ResponseCertInfo: TEETSignerCertInfo; var IsValidResponse: boolean);
  public
    procedure DoSendRevenue;
  end;

var
  TestEETForm: TTestEETForm;

implementation

uses
  u_EETXMLSchema, XMLIntf, XMLDoc,
{$IF CompilerVersion > 24} UITypes, {$IFEND}
  u_EETTrzba;

{$R *.dfm}

function FormatXML(XMLString: string): string;
var
  oXml: IXMLDocument;
begin
  Result := '';
  oXml := TXMLDocument.Create(nil);
  try
    oXml.LoadFromXML(XMLString);
    oXml.XML.Text := XMLDoc.FormatXMLData(oXml.XML.Text);
    oXml.Active := true;
    oXml.SaveToXML(Result);
  finally
    oXml := nil;
  end;
end;

procedure TTestEETForm.btnFormatOdpovedClick(Sender: TObject);
begin
  synmResponse.Lines.Text := FormatXML(synmResponse.Lines.Text);
end;

procedure TTestEETForm.btnFormatRequestClick(Sender: TObject);
begin
  synmRequest.Lines.Text := FormatXML(synmRequest.Lines.Text);
end;

procedure TTestEETForm.btnOdeslatClick(Sender: TObject);
begin
  synmRequest.Lines.Clear;
  synmResponse.Lines.Clear;
  pgcDebug.ActivePage := tsRequest;
  pgcDebug.ActivePage := tsResponse;
  DoSendRevenue;
end;

procedure TTestEETForm.btnVerifyResponseClick(Sender: TObject);
var
  lSigner: TEETSigner;
  ms: TMemoryStream;
  bValidResponseCert: boolean;
begin
  if not FileExists('response.xml') then
    exit;

  lSigner := TEETSigner.Create(nil);
  ms := TMemoryStream.Create;
  try
    lSigner.LoadPFXCertFromFile(ExpandFileName('..\cert\CA_EET-Playground-CZ00000019.p12'), 'aaaa1111');
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\ca_eet-root_cert-playground.crt'));
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\ca_eet-sub_cert-playground.crt'));
    // odpoved EET 2.0 podepisuje certifikat GFR vydany I.CA
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\ica_root_rsa_05-2022.der'));
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\ica_public_rsa_06-2022.der'));
    ms.LoadFromFile('response.xml');
    lSigner.Active := true;
    if lSigner.VerifyXML(ms, 'Body', 'Id') then
      begin
        VerifyResponseCert(lSigner.ResponseCertInfo, bValidResponseCert);
        if bValidResponseCert then
          MessageDlg('XML Verifying - OK.', mtInformation, [mbOK], 0)
        else
          MessageDlg('Invalid message signature !!!', mtError, [mbOK], 0);
      end
    else
      MessageDlg('Invalid response !!!', mtError, [mbOK], 0);
  finally
    ms.Free;
    lSigner.Free;
  end;
end;

procedure TTestEETForm.DoSendRevenue;
var
  Odp: IXMLOdpovedType;
  eTrzba: IXMLTrzbaType;
  EET: TEETTrzba;
  Lst: TStringList;
  I: Integer;
  ms: TMemoryStream;
  aClient: TEETHttpClient;
begin
  EET := TEETTrzba.Create(nil);
  ms := TMemoryStream.Create;
  eTrzba := EET.NewRevenue;
  {$IFDEF USE_INDY_CLIENT} aClient := TEETHttpClientIndy.Create(nil); {$ENDIF}
  {$IFDEF USE_NETHTTP_CLIENT}  aClient := TEETHttpClientNet.Create(nil); {$ENDIF}
  {$IFDEF USE_SBRIDGE_CLIENT} aClient := TEETHttpClientSB.Create(nil); {$ENDIF}
  {$IFDEF USE_SYNAPSE_CLIENT} aClient := TEETHttpClientSynapse.Create(nil); {$ENDIF}
  try
    // Verify HTTPS Server certificate
    aClient.RootCertFile := ExpandFileName('..\cert\DigiCertGlobalRootG2.cer');
    // Verify CommonName of HTTPS Sever certificate
    aClient.HttpsTrustName := 'pg.trzbyeet.gov.cz'; // CN HTTPS serveru (produkce: 'trzbyeet.gov.cz')
    aClient.ConnectTimeout := 2000;
    aClient.ReceiveTimeout := 3000;
    // aClient.UseProxy := true;
    // aClient.ProxyHost := 'proxy';

    EET.URL := 'https://pg.trzbyeet.gov.cz/eet/services/EETServiceSOAP/v4';
    // EET.URL := 'https://trzbyeet.gov.cz/eet/services/EETServiceSOAP/v4';
    EET.OnVerifyResponse := VerifyResponseCert;
    EET.Signer.LoadPFXCertFromFile(ExpandFileName('..\cert\CA_EET-Playground-CZ00000019.p12'), 'aaaa1111');
    EET.Signer.AddTrustedCertFromFileName(ExpandFileName('..\cert\ca_eet-root_cert-playground.crt'));
    EET.Signer.AddTrustedCertFromFileName(ExpandFileName('..\cert\ca_eet-sub_cert-playground.crt'));
    // odpoved EET 2.0 podepisuje certifikat GFR vydany I.CA
    EET.Signer.AddTrustedCertFromFileName(ExpandFileName('..\cert\ica_root_rsa_05-2022.der'));
    EET.Signer.AddTrustedCertFromFileName(ExpandFileName('..\cert\ica_public_rsa_06-2022.der'));
    EET.Initialize; { * init signer * }

    lblKeySubject.Caption := 'Certificate Subject :' + EET.Signer.PrivKeyInfo.CommonName;
    lblKeyValidFrom.Caption := 'Certificate Key valid from :' + DateTimeToStr(EET.Signer.PrivKeyInfo.notValidBefore);
    lblKeyValidTo.Caption := 'Certificate Key valid to :' + DateTimeToStr(EET.Signer.PrivKeyInfo.notValidAfter);

    eTrzba.Hlavicka.prvni_zaslani := True; // pri opakovanem odeslani False + nove uuid_zpravy a dat_odesl
    // eTrzba.Hlavicka.overeni := True;    // jen test spojeni, vraci kod 0 bez POK

    eTrzba.Data.Eic_popl := 'CZ00000019';
    eTrzba.Data.Id_jednotky := 273;
    eTrzba.Data.id_pokl := '/5546/RO24';
    eTrzba.Data.porad_cis := '0/6460/ZQ42';
    eTrzba.Data.dat_trzby := EET.DateTimeToXMLTime(now);
    eTrzba.Data.celk_trzba := DoubleToCastkaType(34113);
    // nepovinne - uvadet jen kdyz jsou relevantni:
    // eTrzba.Data.urceno_cerp_zuct := DoubleToCastkaType(324.00);
    // eTrzba.Data.cerp_zuct := DoubleToCastkaType(679.00);

    // BEGIN - test for saving to XML and load from XML
     ms.Clear;
     EET.SaveToXML(eTrzba, ms);
     ms.Position := 0;
     ms.SaveToFile('eTrzba.xml');
     eTrzba := nil; // Free before LoadFromXML
     eTrzba := EET.LoadFromXML(ms);
     ms.Clear;
     EET.SaveToXML(eTrzba, ms);
     ms.Position := 0;
     ms.SaveToFile('eTrzbaLoaded.xml');
    // END - test for saving to XML and load from XML

    Odp := EET.SendRevenue(aClient, eTrzba, False, 0);

    // loading xml Soap Request for treatment
    // loading xml Soap Response for treatment
    EET.RequestStream.Position := 0;
    EET.ResponseStream.Position := 0;
    synmRequest.Lines.LoadFromStream(EET.RequestStream);
    synmResponse.Lines.LoadFromStream(EET.ResponseStream);

    // backup request and response to file
    EET.RequestStream.SaveToFile('request.xml');
    EET.ResponseStream.SaveToFile('response.xml');

    if (EET.ErrorCode = 0) and (Odp <> nil) then
      begin
        // pozor: Odp.Potvrzeni/Odp.Chyba uzel automaticky vytvori, nikdy nejsou nil
        if Odp.Potvrzeni.Pok <> '' then
          begin
            if EET.ValidResponse and EET.ValidResponseCert then
              begin
                Lst := TStringList.Create;
                try
                  if EET.HasWarnings(Odp) then
                    begin
                      Lst.Add('Warnings : ');
                      for I := 0 to Odp.Varovani.Count - 1 do
                        Lst.Add(Format('%s - code : %d', [Odp.Varovani[I].Text, Odp.Varovani[I].kod_varov]));
                    end;
                  if SameText(Odp.Hlavicka.uuid_zpravy, eTrzba.Hlavicka.uuid_zpravy) then
                    Lst.Add(Format('POK : %s', [Odp.Potvrzeni.Pok]));
                  if EET.HasWarnings(Odp) then
                    MessageDlg(Lst.Text, mtWarning, [mbOK], 0)
                  else
                    MessageDlg(Lst.Text, mtInformation, [mbOK], 0)
                finally
                  Lst.Free;
                end;
              end
            else
              begin
                if EET.ValidResponse and (EET.ValidResponseCert = False) then
                  MessageDlg('Invalid response origin !!!', mtError, [mbOK], 0)
                else
                  MessageDlg('Invalid response signature !!!', mtError, [mbOK], 0);
              end
          end
        else
          begin
            if Odp.Chyba <> nil then
              begin
                if Odp.Chyba.Kod <> 0 then
                  ShowMessageFmt('Error : %d - %s', [Odp.Chyba.Kod, Odp.Chyba.Text]);
{$IFDEF DEBUG}
                if Odp.Chyba.Kod = 0 then
                  ShowMessageFmt('Error : %d - %s', [Odp.Chyba.Kod, Odp.Chyba.Text]);
{$ENDIF}
              end
          end;
      end
    else
      begin
        if EET.ErrorCode <> 0 then
          ShowMessageFmt('Error : %d - %s', [EET.ErrorCode, EET.ErrorMessage]);
        if Odp = nil then
          ShowMessageFmt('Error : %s', ['Invalid response']);
      end;
    mmoLog.Lines.Add('ResponseCert : Subject ' + EET.Signer.ResponseCertInfo.Subject + ', Common Name : ' + EET.Signer.ResponseCertInfo.CommonName);
  finally
    Odp := nil;
    eTrzba := nil;
    EET.Free;
    ms.Free;
    aClient.Free;
  end;
end;

procedure TTestEETForm.FormCreate(Sender: TObject);
begin
  lblKeySubject.Caption := 'Certificate Subject :';
  lblKeyValidFrom.Caption := 'Certificate Key valid from :';
  lblKeyValidTo.Caption := 'Certificate Key valid to :';

  pgcDebug.ActivePage := tsRequest;
{$IFDEF USE_LIBEET};
  Caption := Caption + ' - USE libeetsigner.dll';
{$ELSE}
  Caption := Caption + ' - USE xmlsec library';
{$ENDIF}
end;

procedure TTestEETForm.FormShow(Sender: TObject);
begin
  if FileExists('request.xml') then
    synmRequest.Lines.LoadFromFile('request.xml'{$IFNDEF LEGACY_RIO}, TEncoding.UTF8{$ENDIF});
  if FileExists('response.xml') then
    synmResponse.Lines.LoadFromFile('response.xml'{$IFNDEF LEGACY_RIO}, TEncoding.UTF8{$ENDIF});
end;

procedure TTestEETForm.VerifyResponseCert(const ResponseCertInfo: TEETSignerCertInfo; var IsValidResponse: boolean);
begin
  IsValidResponse := true;
  if GetCurrentThreadID = MainThreadID then
    begin
      mmoLog.Lines.Add('OnVerifyResponseCert : Subject ' + ResponseCertInfo.Subject + ', Common Name : ' + ResponseCertInfo.CommonName);
    end;
end;

end.
