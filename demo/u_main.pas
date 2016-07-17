unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SynEdit, SynMemo, SynEditHighlighter, SynHighlighterXML, Soap.XSBuiltIns,
  Vcl.ExtCtrls, Vcl.ComCtrls;

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
    procedure btnOdeslatClick(Sender: TObject);
    procedure btnVerifyResponseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFormatRequestClick(Sender: TObject);
    procedure btnFormatOdpovedClick(Sender: TObject);
  private
    procedure BeforeSendExecute(const MethodName: string; SOAPRequest: TStream);
    procedure AfterSendExecute(const MethodName: string; SOAPResponse: TStream);
  public
    procedure DoOdeslatTrzba;
  end;

var
  TestEETForm: TTestEETForm;

implementation

uses
  u_EETServiceSOAP,  XMLIntf, XMLDoc, u_EETTrzba, UITypes, u_EETSigner, libxml2, libxmlsec;

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
    lSigner.LoadPFXCertFromFile(ExpandFileName('..\cert\01000003.p12'), 'eet');
    lSigner.LoadVerifyCertFromFileName(ExpandFileName('..\cert\trusted_CA.cer'));  // cert not used
    ms.LoadFromFile('response.xml');
    lSigner.Active := true;
    if lSigner.VerifyCertIncluded then
      begin
        if lSigner.VerifyXML(ms,'Body', 'Id') then
          MessageDlg('Ovìøení XML - OK.', mtInformation, [mbOK], 0)
        else
          MessageDlg('Neplatný podpis zprávy !!!', mtError, [mbOK], 0)
      end
    else
      MessageDlg('Není vložen ovìøovací certifikat', mtError, [mbOK], 0);
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

  function DoubleToCastka(Value : Double) : String;
  begin
    Result := FormatFloat('0.00', Value, LocFS);
  end;

begin
  EET := TEETTrzba.Create(nil);
  eTrzba := EET.NewTrzba;
  try
//    EET.URL := 'http://localhost';
    EET.URL := 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v2';
    EET.OnBeforeSendRequest := BeforeSendExecute;
    EET.OnAfterSendRequest := AfterSendExecute;
    EET.PFXStream.LoadFromFile(ExpandFileName('..\cert\01000003.p12'));
    EET.CerStream.LoadFromFile(ExpandFileName('..\cert\trusted_CA.cer'));
    EET.PFXPassword := 'eet';
    EET.ReceiveTimeout := 100;
    EET.Initialize;

    eTrzba.Hlavicka.prvni_zaslani := False;
//    eTrzba.Hlavicka.overeni := True;

    eTrzba.Data.dic_popl := 'CZ1212121218';
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

    Odp := EET.OdeslaniTrzby(eTrzba);
    if Odp.Potvrzeni <> nil then
      begin
        if EET.ValidResponse then
          begin
            if SameText(Odp.Hlavicka.uuid_zpravy, eTrzba.Hlavicka.uuid_zpravy) then
               ShowMessageFmt('OK. FIK : %s', [Odp.Potvrzeni.fik]);
          end
        else
          MessageDlg('Neplatný podpis odpovìdi !!!', mtError, [mbOK], 0);
      end
    else
      begin
        if Odp.Chyba <> nil then
          begin
            if Odp.Chyba.Kod <> 0 then
              ShowMessageFmt('Chyba : %d - %s', [Odp.Chyba.Kod,Odp.Chyba.Zprava]);
            {$IFDEF DEBUG}
            if Odp.Chyba.Kod = 0 then
              ShowMessageFmt('Chyba : %d - %s', [Odp.Chyba.Kod,Odp.Chyba.Zprava]);
            {$ENDIF}
          end
        end;
  finally
    eTrzba.Free;
    EET.Free;
  end;
end;

procedure TTestEETForm.FormCreate(Sender: TObject);
begin
  pgcDebug.ActivePage := tsRequest;
end;

procedure TTestEETForm.FormShow(Sender: TObject);
begin
  if FileExists('request.xml') then
    synmRequest.Lines.LoadFromFile('request.xml', TEncoding.UTF8);
  if FileExists('response.xml') then
    synmResponse.Lines.LoadFromFile('response.xml', TEncoding.UTF8);
end;

end.
