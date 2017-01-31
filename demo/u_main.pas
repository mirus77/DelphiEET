unit u_main;

interface
{$IFNDEF UNICODE}
{$DEFINE LEGACY_RIO}
{$ENDIF}
// For Delphi XE3 and up:
{$IF CompilerVersion >= 24.0 }
  {$LEGACYIFEND ON}
{$IFEND}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, SynEdit, SynMemo, SynEditHighlighter, SynHighlighterXML, XSBuiltIns, InvokeRegistry,
  ExtCtrls, {$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)} IdSSLOpenSSL, {$IFEND} ComCtrls;

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
    pnlCertInfo: TPanel;
    lblSpace1: TLabel;
    pnl1: TPanel;
    lblKeySubject: TLabel;
    procedure btnOdeslatClick(Sender: TObject);
    procedure btnVerifyResponseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFormatRequestClick(Sender: TObject);
    procedure btnFormatOdpovedClick(Sender: TObject);
  private
    {$IFDEF LEGACY_RIO}
    procedure BeforeSendExecute(const MethodName: string; var SOAPRequest: InvString);
    {$ELSE}
    procedure BeforeSendExecute(const MethodName: string; SOAPRequest: TStream);
    {$ENDIF}
    procedure AfterSendExecute(const MethodName: string; SOAPResponse: TStream);
    {$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
    function VerifyPeer(Certificate: TIdX509; AOk: Boolean{$IFNDEF LEGACY_RIO}; ADepth, AError: Integer{$ENDIF}) : boolean;
    {$IFEND}
  public
    procedure DoOdeslatTrzba;
  end;

var
  TestEETForm: TTestEETForm;

implementation

uses
  u_EETServiceSOAP, XMLIntf, XMLDoc, u_EETTrzba, {$IF CompilerVersion > 24} UITypes,{$IFEND} u_EETSigner;

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
end;

{$IFDEF LEGACY_RIO}
procedure TTestEETForm.BeforeSendExecute(const MethodName: string; var SOAPRequest: InvString);
var
  MemStream : TMemoryStream;
  S : string;
begin
  MemStream := TMemoryStream.Create;
  try
    S := UTF8Encode(SOAPRequest);
    MemStream.Position := 0;
    MemStream.Write(S[1], Length(S));
    MemStream.SaveToFile('request.xml');
  finally
    MemStream.Free;
  end;
end;
{$ELSE}
procedure TTestEETForm.BeforeSendExecute(const MethodName: string; SOAPRequest: TStream);
begin
  (SOAPRequest as TMemoryStream).SaveToFile('request.xml');
  SOAPRequest.Seek(0, soFromBeginning);
end;
{$ENDIF}

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
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\trusted_CA_pg.der'));
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\trusted_CA_prod.der'));
    lSigner.AddTrustedCertFromFileName(ExpandFileName('..\cert\trusted_CA_prod_ROOT.der'));
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

  function DoubleToCastkaType(Value : Double) : CastkaType;
  begin
    Result := CastkaType.Create;
    Result.DecimalString := FormatFloat('0.00', Value, LocFS);
  end;

begin
  EET := TEETTrzba.Create(nil);
  eTrzba := EET.NewTrzba;
  ms := TMemoryStream.Create;
  try
    EET.URL := 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v3';
//    EET.URL := 'https://prod.eet.cz:443/eet/services/EETServiceSOAP/v3';
    EET.OnBeforeSendRequest := BeforeSendExecute;
    EET.OnAfterSendRequest := AfterSendExecute;
{$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
    EET.OnVerifyPeer := VerifyPeer;
    EET.RootCertFile := ExpandFileName('..\cert\Geotrust_PCA_G3_Root.pem');
{$IFEND}
    EET.PFXStream.LoadFromFile(ExpandFileName('..\cert\EET_CA1_Playground-CZ00000019.p12'));
    EET.AddTrustedCertFromFileName(ExpandFileName('..\cert\trusted_CA_pg.der'));
    EET.AddTrustedCertFromFileName(ExpandFileName('..\cert\trusted_CA_prod.der'));
    EET.AddTrustedCertFromFileName(ExpandFileName('..\cert\trusted_CA_prod_ROOT.der'));
//    EET.HttpsTrustName := 'www.eet.cz';  // for HTTPS validation default : 'www.eet.cz'
    EET.PFXPassword := 'eet';
    EET.ConnectTimeout := 2000;
//    EET.UseProxy := true;
//    EET.ProxyHost := 'proxy';
    EET.Initialize;

    lblKeySubject.Caption := 'Pøedmìt :' + EET.Signer.PrivKeyInfo.Subject;
    lblKeyValidFrom.Caption := 'Platnost klíèe od :' + DateTimeToStr(EET.Signer.PrivKeyInfo.notValidBefore);
    lblKeyValidTo.Caption := 'Platnost klíèe do :' + DateTimeToStr(EET.Signer.PrivKeyInfo.notValidAfter);

    eTrzba.Hlavicka.prvni_zaslani := False;
//    eTrzba.Hlavicka.overeni := True;

    eTrzba.Data.dic_popl := 'CZ00000019';
    eTrzba.Data.id_provoz := 273;
    eTrzba.Data.id_pokl := '/5546/RO24';
    eTrzba.Data.porad_cis := '0/6460/ZQ42';
    eTrzba.Data.dat_trzby.AsDateTime := now;
    eTrzba.Data.celk_trzba := DoubleToCastkaType(34113);
    eTrzba.Data.cerp_zuct := DoubleToCastkaType(679.00);
    eTrzba.Data.cest_sluz := DoubleToCastkaType(5460.00);
    eTrzba.Data.dan1 := DoubleToCastkaType(-172.39);
    eTrzba.Data.dan2 := DoubleToCastkaType(-530.73);
    eTrzba.Data.dan3 := DoubleToCastkaType(975.65);
    eTrzba.Data.pouzit_zboz1 := DoubleToCastkaType(784.00);
    eTrzba.Data.pouzit_zboz2 := DoubleToCastkaType(967.00);
    eTrzba.Data.pouzit_zboz3 := DoubleToCastkaType(189.00);
    eTrzba.Data.urceno_cerp_zuct := DoubleToCastkaType(324.00);
    eTrzba.Data.zakl_dan1 := DoubleToCastkaType(-820.92);
    eTrzba.Data.zakl_dan2 := DoubleToCastkaType(-3538.20);
    eTrzba.Data.zakl_dan3 := DoubleToCastkaType(9756.46);
    eTrzba.Data.zakl_nepodl_dph := DoubleToCastkaType(3036.00);

//    EET.SignTrzba(eTrzba); // normalizace datumu a vygenervani PKP,BKP

    // test ulozeni do XML a nacteni z XML
    // nacteni nefunguje v Delphi 2007
//    ms.Clear;
//    EET.SaveToXML(eTrzba, ms);
//    ms.Position := 0;
//    ms.SaveToFile('eTrzba.xml');
//    eTrzba.Free;
//    eTrzba := EET.NewTrzba;
//    EET.LoadFromXML(eTrzba, ms);
//    ms.Clear;
//    EET.SaveToXML(eTrzba, ms);
//    ms.Position := 0;
//    ms.SaveToFile('eTrzbaLoaded.xml');

{$IF Defined(USE_DIRECTINDY)}
{$MESSAGE HINT 'USE_DIRECTINDY'}
    Odp := EET.OdeslaniTrzbyDirectIndy(eTrzba);
{$ELSE}
  {$IF Defined(USE_INDY)}
     {$MESSAGE HINT 'USE_INDY'}
  {$ELSE}
     {$MESSAGE HINT 'USE WinInet default SOAP WebRequest'}
  {$IFEND}
    Odp := EET.OdeslaniTrzby(eTrzba, false, 5000);
{$IFEND}

    ms.Clear;
    EET.SaveToXML(eTrzba, ms);
    ms.Position := 0;
    ms.SaveToFile('eTrzbaSigned.xml');

    // nacteni xml Soap Request po zpracovani
    // nacteni xml Soap Response po zpracovani
    // vyjmuto z eventù Before a After, protože zamrzala aplikace pøi použití WainForSingleObject
    EET.RequestStream.Position := 0;
    EET.ResponseStream.Position := 0;
    synmRequest.Lines.LoadFromStream(EET.RequestStream);
    synmResponse.Lines.LoadFromStream(EET.ResponseStream);

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
  lblKeySubject.Caption := 'Pøedmìt :';
  lblKeyValidFrom.Caption := 'Platnost klíèe od :';
  lblKeyValidTo.Caption := 'Platnost klíèe do :';

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

{$IF Defined(USE_INDY) OR Defined(USE_DIRECTINDY)}
function TTestEETForm.VerifyPeer(Certificate: TIdX509; AOk: Boolean{$IFNDEF LEGACY_RIO}; ADepth, AError: Integer{$ENDIF}): boolean;
begin
  Result := AOk;
  {$IFNDEF LEGACY_RIO}
  if ADepth = 0 then
    begin
      synmRequest.Lines.Add('<!-- https : Subject ' + Certificate.Subject.OneLine + ' -->');
    end;
  {$ENDIF}
end;
{$IFEND}

end.
