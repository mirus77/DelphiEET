unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SynEdit, SynMemo, SynEditHighlighter, SynHighlighterXML, Soap.XSBuiltIns,
  Vcl.ExtCtrls, {$IFDEF USE_INDY} IdSSLOpenSSL, {$ENDIF} Vcl.ComCtrls;

type
  TTestEETForm = class(TForm)
    synxmlsyn2: TSynXMLSyn;
    synmRequest: TSynMemo;
    grpTrzba: TGroupBox;
    grpResponse: TGroupBox;
    synmResponse: TSynMemo;
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
    procedure btnOdeslatClick(Sender: TObject);
    procedure btnVerifyResponseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFormatRequestClick(Sender: TObject);
    procedure btnFormatOdpovedClick(Sender: TObject);
  private
    procedure BeforeSendExecute(const MethodName: string; SOAPRequest: TStream);
    procedure AfterSendExecute(const MethodName: string; SOAPResponse: TStream);
    {$IFDEF USE_INDY}
    function VerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer) : boolean;
    {$ENDIF}
  public
    procedure DoOdeslatTrzba;
  end;

var
  TestEETForm: TTestEETForm;

implementation

uses
  u_EETServiceSOAP, XMLIntf, XMLDoc, u_EETTrzba, UITypes, u_EETSigner;

{$R *.dfm}

function FormatXML(XMLString : string): string;
var
   oXml : IXMLDocument;
begin
  Result := '';
  oXml := TXMLDocument.Create(nil);
  try
    oXml.LoadFromXML(XMLString);
    oXml.XML.Text:=xmlDoc.FormatXMLData(oXml.XML.Text);
    oXml.Active := true;
    oXml.SaveToXML(Result);
  finally
    oXml := nil;
  end;
end;

procedure TTestEETForm.AfterSendExecute(const MethodName: string; SOAPResponse: TStream);
begin
  (SOAPResponse as TMemoryStream).SaveToFile('response.xml');
  synmResponse.Lines.LoadFromStream(SOAPResponse as TMemoryStream);
  synmResponse.Lines.Text := synmResponse.Lines.Text;
end;

procedure TTestEETForm.BeforeSendExecute(const MethodName: string; SOAPRequest: TStream);
begin
  (SOAPRequest as TMemoryStream).SaveToFile('request.xml');
  SOAPRequest.Seek(0, soFromBeginning);
  synmRequest.Lines.LoadFromStream(SOAPRequest as TMemoryStream);
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
  DoOdeslatTrzba;
end;

procedure TTestEETForm.btnVerifyResponseClick(Sender: TObject);
var
  lSigner : TEETSigner;
  ms : TMemoryStream;
begin
  if not FileExists('response.xml') then exit;

  lSigner := TEETSigner.Create(nil);
  ms := TMemoryStream.Create;
  try
    lSigner.LoadPFXCertFromFile(ExpandFileName('..\cert\EET_CA1_Playground-CZ00000019.p12'), 'eet');
    lSigner.LoadVerifyCertFromFileName(ExpandFileName('..\cert\trusted_CA.der'));
    ms.LoadFromFile('response.xml');
    lSigner.Active := true;
    if lSigner.VerifyXML(ms,'Body', 'Id') then
      MessageDlg('Ovìøení XML - OK.', mtInformation, [mbOK], 0)
    else
      MessageDlg('Neplatný podpis zprávy !!!', mtError, [mbOK], 0)
  finally
    ms.Free;
    lSigner.Free;
  end;
end;

procedure TTestEETForm.DoOdeslatTrzba;

const
  LocFS : TFormatSettings = (
    DecimalSeparator : '.'
  );

var
  Odp : Odpoved;
  eTrzba : Trzba;
  EET : TEETTrzba;
  Lst : TStringList;
  I: Integer;
  ms : TMemoryStream;

  function DoubleToCastka(Value : Double) : String;
  begin
    Result := FormatFloat('0.00', Value, LocFS);
  end;

begin
  EET := TEETTrzba.Create(nil);
  eTrzba := EET.NewTrzba;
  ms := TMemoryStream.Create;
  try
    EET.URL := 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v3';
    EET.OnBeforeSendRequest := BeforeSendExecute;
    EET.OnAfterSendRequest := AfterSendExecute;
{$IFDEF USE_INDY}
    EET.OnVerifyPeer := VerifyPeer;
{$ENDIF}
    EET.RootCertFile := ExpandFileName('..\cert\Geotrust_PCA_G3_Root.pem');
    EET.PFXStream.LoadFromFile(ExpandFileName('..\cert\EET_CA1_Playground-CZ00000019.p12'));
//    EET.PFXStream.LoadFromFile(ExpandFileName('..\cert\01000003.p12'));
    EET.CerStream.LoadFromFile(ExpandFileName('..\cert\trusted_CA.der'));
//    EET.HttpsTrustName := 'www.eet.cz';  // for HTTPS validation default : 'www.eet.cz'
    EET.PFXPassword := 'eet';
    EET.ConnectTimeout := 2000;
    EET.Initialize;

    lblKeyValidFrom.Caption := 'Platnost klíèe od :' + DateTimeToStr(EET.Signer.PrivKeyInfo.notValidBefore);
    lblKeyValidTo.Caption := 'Platnost klíèe do :' + DateTimeToStr(EET.Signer.PrivKeyInfo.notValidAfter);

    eTrzba.Hlavicka.prvni_zaslani := False;
//    eTrzba.Hlavicka.overeni := True;

    eTrzba.Data.dic_popl := 'CZ00000019';
    eTrzba.Data.id_provoz := 273;
    eTrzba.Data.id_pokl := '/5546/RO24';
    eTrzba.Data.porad_cis := '0/6460/ZQ42';
    eTrzba.Data.dat_trzby.AsDateTime := now;
    eTrzba.Data.celk_trzba.DecimalString := DoubleToCastka(34113);
    eTrzba.Data.cerp_zuct.DecimalString := DoubleToCastka(679.00);
    eTrzba.Data.cest_sluz.DecimalString := DoubleToCastka(5460.00);
    eTrzba.Data.dan1.DecimalString := DoubleToCastka(-172.39);
    eTrzba.Data.dan2.DecimalString := DoubleToCastka(-530.73);
    eTrzba.Data.dan3.DecimalString := DoubleToCastka(975.65);
    eTrzba.Data.pouzit_zboz1.DecimalString := DoubleToCastka(784.00);
    eTrzba.Data.pouzit_zboz2.DecimalString := DoubleToCastka(967.00);
    eTrzba.Data.pouzit_zboz3.DecimalString := DoubleToCastka(189.00);
    eTrzba.Data.urceno_cerp_zuct.DecimalString := DoubleToCastka(324.00);
    eTrzba.Data.zakl_dan1.DecimalString := DoubleToCastka(-820.92);
    eTrzba.Data.zakl_dan2.DecimalString := DoubleToCastka(-3538.20);
    eTrzba.Data.zakl_dan3.DecimalString := DoubleToCastka(9756.46);
    eTrzba.Data.zakl_nepodl_dph.DecimalString := DoubleToCastka(3036.00);

//    EET.SignTrzba(eTrzba); // normalizace datumu a vygenervani PKP,BKP

    // test ulozeni do XML a nacteni z XML
//    EET.SaveToXML(eTrzba, ms);
//    ms.Position := 0;
//    eTrzba.Free;
//    eTrzba := EET.NewTrzba;
//    EET.LoadFromXML(eTrzba, ms);

    Odp := EET.OdeslaniTrzby(eTrzba);
    if (EET.ErrorCode = 0) and (Odp <> nil) then
      begin
        if Odp.Potvrzeni <> nil then
          begin
            if EET.ValidResponse then
              begin
                Lst := TStringList.Create;
                try
                  if EET.HasVarovani(Odp) then
                    begin
                      Lst.Add('Varovaní : ');
                      for I := 0 to Length(Odp.Varovani) - 1 do
                        Lst.Add(Format('%s - kód : %d', [Odp.Varovani[I].Text, Odp.Varovani[I].kod_varov]));
                    end;
                  if SameText(Odp.Hlavicka.uuid_zpravy, eTrzba.Hlavicka.uuid_zpravy) then
                    Lst.Add(Format('FIK : %s', [Odp.Potvrzeni.fik]));
                  if EET.HasVarovani(Odp) then
                    MessageDlg(Lst.Text, mtWarning, [mbOK], 0)
                  else
                    MessageDlg(Lst.Text, mtInformation, [mbOK], 0)
                finally
                  Lst.Free;
                end;
              end
            else
              MessageDlg('Neplatný podpis odpovìdi !!!', mtError, [mbOK], 0);
          end
        else
          begin
            if Odp.Chyba <> nil then
              begin
                if Odp.Chyba.Kod <> 0 then
                  ShowMessageFmt('Chyba : %d - %s', [Odp.Chyba.Kod,Odp.Chyba.Text]);
                {$IFDEF DEBUG}
                if Odp.Chyba.Kod = 0 then
                  ShowMessageFmt('Chyba : %d - %s', [Odp.Chyba.Kod,Odp.Chyba.Text]);
                {$ENDIF}
              end
            end;
      end
    else
      begin
        if EET.ErrorCode <> 0 then
          ShowMessageFmt('Chyba : %d - %s', [EET.ErrorCode,EET.ErrorMessage]);
      end;
    synmResponse.Lines.Add('<!-- PKP : ' + eTrzba.KontrolniKody.pkp.Text + ' -->');
  finally
    if Odp <> nil then FreeAndNil(Odp);    
    eTrzba.Free;
    EET.Free;
    ms.Free;
  end;
end;

procedure TTestEETForm.FormCreate(Sender: TObject);
begin
  lblKeyValidFrom.Caption := 'Platnost klíèe od :';
  lblKeyValidTo.Caption := 'Platnost klíèe do :';

  pgcDebug.ActivePage := tsRequest;
end;

procedure TTestEETForm.FormShow(Sender: TObject);
begin
  if FileExists('request.xml') then
    synmRequest.Lines.LoadFromFile('request.xml', TEncoding.UTF8);
  if FileExists('response.xml') then
    synmResponse.Lines.LoadFromFile('response.xml', TEncoding.UTF8);
end;

{$IFDEF USE_INDY}
function TTestEETForm.VerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): boolean;
begin
  Result := AOk;
  if ADepth = 0 then
    begin
      synmRequest.Lines.Add('<!-- https : Subject ' + Certificate.Subject.OneLine + ' -->');
    end;
end;
{$ENDIF}

end.
