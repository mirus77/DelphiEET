// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : L:\Data\owncloud\documentsPPK\EET\verze 2\EETServiceSOAP.wsdl
//  >Import : L:\Data\owncloud\documentsPPK\EET\verze 2\EETServiceSOAP.wsdl>0
//  >Import : L:\Data\owncloud\documentsPPK\EET\verze 2\EETXMLSchema.xsd
// Encoding : UTF-8
// Version  : 1.0
// (1. 7. 2016 22:49:47 - - $Rev: 76228 $)
// ************************************************************************ //

unit u_EETServiceSOAP;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_ATTR = $0010;
  IS_TEXT = $0020;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:decimal         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:int             - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:schema          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  OdpovedHlavickaType  = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[GblCplx] }
  OdpovedPotvrzeniType = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[GblCplx] }
  TrzbaHlavickaType    = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[GblCplx] }
  TrzbaType            = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[Lit][GblCplx] }
  Trzba                = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[Lit][GblElm] }
  OdpovedType          = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[Lit][GblCplx] }
  Odpoved              = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[Lit][GblElm] }
  TrzbaKontrolniKodyType = class;               { "http://fs.mfcr.cz/eet/schema/v2"[GblCplx] }
  TrzbaDataType        = class;                 { "http://fs.mfcr.cz/eet/schema/v2"[GblCplx] }

  {$SCOPEDENUMS ON}
  { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  PkpEncodingType = (base64);

  { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  BkpDigestType = (SHA1);

  { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  BkpEncodingType = (base16);

  { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  PkpCipherType = (RSA2048);

  { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  PkpDigestType = (SHA256);

  { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  RezimType = (_0, _1);

  {$SCOPEDENUMS OFF}

  FikType         =  type string;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  BkpType         =  type string;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  dateTime        = class(TXSDateTime) end;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  UUIDType        =  type string;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }


  // ************************************************************************ //
  // XML       : OdpovedHlavickaType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // ************************************************************************ //
  OdpovedHlavickaType = class(TRemotable)
  private
    Fuuid_zpravy: UUIDType;
    Fuuid_zpravy_Specified: boolean;
    Fbkp: BkpType;
    Fbkp_Specified: boolean;
    Fdat_prij: dateTime;
    Fdat_prij_Specified: boolean;
    Fdat_odmit: dateTime;
    Fdat_odmit_Specified: boolean;
    procedure Setuuid_zpravy(Index: Integer; const AUUIDType: UUIDType);
    function  uuid_zpravy_Specified(Index: Integer): boolean;
    procedure Setbkp(Index: Integer; const ABkpType: BkpType);
    function  bkp_Specified(Index: Integer): boolean;
    procedure Setdat_prij(Index: Integer; const AdateTime: dateTime);
    function  dat_prij_Specified(Index: Integer): boolean;
    procedure Setdat_odmit(Index: Integer; const AdateTime: dateTime);
    function  dat_odmit_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property uuid_zpravy: UUIDType  Index (IS_ATTR or IS_OPTN) read Fuuid_zpravy write Setuuid_zpravy stored uuid_zpravy_Specified;
    property bkp:         BkpType   Index (IS_ATTR or IS_OPTN) read Fbkp write Setbkp stored bkp_Specified;
    property dat_prij:    dateTime  Index (IS_ATTR or IS_OPTN) read Fdat_prij write Setdat_prij stored dat_prij_Specified;
    property dat_odmit:   dateTime  Index (IS_ATTR or IS_OPTN) read Fdat_odmit write Setdat_odmit stored dat_odmit_Specified;
  end;

  CZDICType       =  type string;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }


  // ************************************************************************ //
  // XML       : OdpovedPotvrzeniType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // ************************************************************************ //
  OdpovedPotvrzeniType = class(TRemotable)
  private
    Ffik: FikType;
    Ftest: Boolean;
    Ftest_Specified: boolean;
    procedure Settest(Index: Integer; const ABoolean: Boolean);
    function  test_Specified(Index: Integer): boolean;
  published
    property fik:  FikType  Index (IS_ATTR) read Ffik write Ffik;
    property test: Boolean  Index (IS_ATTR or IS_OPTN) read Ftest write Settest stored test_Specified;
  end;



  // ************************************************************************ //
  // XML       : TrzbaHlavickaType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // ************************************************************************ //
  TrzbaHlavickaType = class(TRemotable)
  private
    Fuuid_zpravy: UUIDType;
    Fdat_odesl: dateTime;
    Fprvni_zaslani: Boolean;
    Fovereni: Boolean;
    Fovereni_Specified: boolean;
    procedure Setovereni(Index: Integer; const ABoolean: Boolean);
    function  overeni_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property uuid_zpravy:   UUIDType  Index (IS_ATTR) read Fuuid_zpravy write Fuuid_zpravy;
    property dat_odesl:     dateTime  Index (IS_ATTR) read Fdat_odesl write Fdat_odesl;
    property prvni_zaslani: Boolean   Index (IS_ATTR) read Fprvni_zaslani write Fprvni_zaslani;
    property overeni:       Boolean   Index (IS_ATTR or IS_OPTN) read Fovereni write Setovereni stored overeni_Specified;
  end;



  // ************************************************************************ //
  // XML       : TrzbaType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TrzbaType = class(TRemotable)
  private
    FHlavicka: TrzbaHlavickaType;
    FData: TrzbaDataType;
    FKontrolniKody: TrzbaKontrolniKodyType;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Hlavicka:      TrzbaHlavickaType       read FHlavicka write FHlavicka;
    property Data:          TrzbaDataType           read FData write FData;
    property KontrolniKody: TrzbaKontrolniKodyType  read FKontrolniKody write FKontrolniKody;
  end;



  // ************************************************************************ //
  // XML       : Trzba, global, <element>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // Info      : Wrapper
  // ************************************************************************ //
  Trzba = class(TrzbaType)
  private
  published
  end;

  IdProvozType    =  type Integer;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }

  { ================== WARNING ================== }
  { WARNING - Attribute - Name:kod, Type:Integer }
  { WARNING - Attribute - Name:test, Type:Boolean }
  OdpovedChybaType = class(TRemotable)      { "http://fs.mfcr.cz/eet/schema/v2"[GblCplxMxd] }
  private
    Ftest: boolean;
    FZprava: string;
    Fkod: integer;
  published
    property kod:   integer  Index (IS_ATTR) read Fkod write Fkod;
    property test:   boolean  Index (IS_ATTR) read Ftest write Ftest;
    property Zprava:   string  Index (IS_TEXT) read FZprava write FZprava;
  end;


  // ************************************************************************ //
  // XML       : OdpovedType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  OdpovedType = class(TRemotable)
  private
    FHlavicka: OdpovedHlavickaType;
    FPotvrzeni: OdpovedPotvrzeniType;
    FPotvrzeni_Specified: boolean;
    FChyba: OdpovedChybaType;
    FChyba_Specified: boolean;
    procedure SetPotvrzeni(Index: Integer; const AOdpovedPotvrzeniType: OdpovedPotvrzeniType);
    function  Potvrzeni_Specified(Index: Integer): boolean;
    procedure SetChyba(Index: Integer; const AOdpovedChybaType: OdpovedChybaType);
    function  Chyba_Specified(Index: Integer): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Hlavicka:  OdpovedHlavickaType   read FHlavicka write FHlavicka;
    property Potvrzeni: OdpovedPotvrzeniType  Index (IS_OPTN) read FPotvrzeni write SetPotvrzeni stored Potvrzeni_Specified;
    property Chyba:     OdpovedChybaType      Index (IS_OPTN) read FChyba write SetChyba stored Chyba_Specified;
  end;



  // ************************************************************************ //
  // XML       : Odpoved, global, <element>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // Info      : Wrapper
  // ************************************************************************ //
  Odpoved = class(OdpovedType)
  private
  published
  end;


  { ================== WARNING ================== }
  { WARNING - Attribute - Name:digest, Type:BkpDigestType }
  { WARNING - Attribute - Name:encoding, Type:BkpEncodingType }
  BkpElementType  = class(TRemotable)       { "http://fs.mfcr.cz/eet/schema/v2"[GblCplxMxd] }
  private
    Fencoding: BkpEncodingType;
    Fdigest: BkpDigestType;
    Fvalue: string;
  published
    property digest:   BkpDigestType  Index (IS_ATTR) read Fdigest write Fdigest;
    property encoding:   BkpEncodingType  Index (IS_ATTR) read Fencoding write Fencoding;
    property Value:   string  Index (IS_TEXT) read Fvalue write Fvalue;
  end;

  CastkaType      = class(TXSDecimal) end;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }
  string_         =  type string;      { "http://fs.mfcr.cz/eet/schema/v2"[GblSmpl] }

  { ================== WARNING ================== }
  { WARNING - Attribute - Name:digest, Type:PkpDigestType }
  { WARNING - Attribute - Name:cipher, Type:PkpCipherType }
  { WARNING - Attribute - Name:encoding, Type:PkpEncodingType }
  PkpElementType  = class(TRemotable)       { "http://fs.mfcr.cz/eet/schema/v2"[GblCplxMxd] }
  private
    Fencoding: PkpEncodingType;
    Fdigest: PkpDigestType;
    Fcipher: PkpCipherType;
    Fvalue: string;
  published
    property cipher:   PkpCipherType  Index (IS_ATTR) read Fcipher write Fcipher;
    property digest:   PkpDigestType  Index (IS_ATTR) read Fdigest write Fdigest;
    property encoding:   PkpEncodingType  Index (IS_ATTR) read Fencoding write Fencoding;
    property Value:   string  Index (IS_TEXT) read Fvalue write Fvalue;
  end;



  // ************************************************************************ //
  // XML       : TrzbaKontrolniKodyType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // ************************************************************************ //
  TrzbaKontrolniKodyType = class(TRemotable)
  private
    Fpkp: PkpElementType;
    Fbkp: BkpElementType;
  public
    destructor Destroy; override;
  published
    property pkp: PkpElementType  read Fpkp write Fpkp;
    property bkp: BkpElementType  read Fbkp write Fbkp;
  end;



  // ************************************************************************ //
  // XML       : TrzbaDataType, global, <complexType>
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // ************************************************************************ //
  TrzbaDataType = class(TRemotable)
  private
    Fdic_popl: CZDICType;
    Fdic_poverujiciho: CZDICType;
    Fdic_poverujiciho_Specified: boolean;
    Fid_provoz: IdProvozType;
    Fid_pokl: string_;
    Fporad_cis: string_;
    Fdat_trzby: dateTime;
    Fcelk_trzba: CastkaType;
    Fzakl_nepodl_dph: CastkaType;
    Fzakl_nepodl_dph_Specified: boolean;
    Fzakl_dan1: CastkaType;
    Fzakl_dan1_Specified: boolean;
    Fdan1: CastkaType;
    Fdan1_Specified: boolean;
    Fzakl_dan2: CastkaType;
    Fzakl_dan2_Specified: boolean;
    Fdan2: CastkaType;
    Fdan2_Specified: boolean;
    Fzakl_dan3: CastkaType;
    Fzakl_dan3_Specified: boolean;
    Fdan3: CastkaType;
    Fdan3_Specified: boolean;
    Fcest_sluz: CastkaType;
    Fcest_sluz_Specified: boolean;
    Fpouzit_zboz1: CastkaType;
    Fpouzit_zboz1_Specified: boolean;
    Fpouzit_zboz2: CastkaType;
    Fpouzit_zboz2_Specified: boolean;
    Fpouzit_zboz3: CastkaType;
    Fpouzit_zboz3_Specified: boolean;
    Furceno_cerp_zuct: CastkaType;
    Furceno_cerp_zuct_Specified: boolean;
    Fcerp_zuct: CastkaType;
    Fcerp_zuct_Specified: boolean;
    Frezim: RezimType;
    procedure Setdic_poverujiciho(Index: Integer; const ACZDICType: CZDICType);
    function  dic_poverujiciho_Specified(Index: Integer): boolean;
    procedure Setzakl_nepodl_dph(Index: Integer; const ACastkaType: CastkaType);
    function  zakl_nepodl_dph_Specified(Index: Integer): boolean;
    procedure Setzakl_dan1(Index: Integer; const ACastkaType: CastkaType);
    function  zakl_dan1_Specified(Index: Integer): boolean;
    procedure Setdan1(Index: Integer; const ACastkaType: CastkaType);
    function  dan1_Specified(Index: Integer): boolean;
    procedure Setzakl_dan2(Index: Integer; const ACastkaType: CastkaType);
    function  zakl_dan2_Specified(Index: Integer): boolean;
    procedure Setdan2(Index: Integer; const ACastkaType: CastkaType);
    function  dan2_Specified(Index: Integer): boolean;
    procedure Setzakl_dan3(Index: Integer; const ACastkaType: CastkaType);
    function  zakl_dan3_Specified(Index: Integer): boolean;
    procedure Setdan3(Index: Integer; const ACastkaType: CastkaType);
    function  dan3_Specified(Index: Integer): boolean;
    procedure Setcest_sluz(Index: Integer; const ACastkaType: CastkaType);
    function  cest_sluz_Specified(Index: Integer): boolean;
    procedure Setpouzit_zboz1(Index: Integer; const ACastkaType: CastkaType);
    function  pouzit_zboz1_Specified(Index: Integer): boolean;
    procedure Setpouzit_zboz2(Index: Integer; const ACastkaType: CastkaType);
    function  pouzit_zboz2_Specified(Index: Integer): boolean;
    procedure Setpouzit_zboz3(Index: Integer; const ACastkaType: CastkaType);
    function  pouzit_zboz3_Specified(Index: Integer): boolean;
    procedure Seturceno_cerp_zuct(Index: Integer; const ACastkaType: CastkaType);
    function  urceno_cerp_zuct_Specified(Index: Integer): boolean;
    procedure Setcerp_zuct(Index: Integer; const ACastkaType: CastkaType);
    function  cerp_zuct_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property dic_popl:         CZDICType     Index (IS_ATTR) read Fdic_popl write Fdic_popl;
    property dic_poverujiciho: CZDICType     Index (IS_ATTR or IS_OPTN) read Fdic_poverujiciho write Setdic_poverujiciho stored dic_poverujiciho_Specified;
    property id_provoz:        IdProvozType  Index (IS_ATTR) read Fid_provoz write Fid_provoz;
    property id_pokl:          string_       Index (IS_ATTR) read Fid_pokl write Fid_pokl;
    property porad_cis:        string_       Index (IS_ATTR) read Fporad_cis write Fporad_cis;
    property dat_trzby:        dateTime      Index (IS_ATTR) read Fdat_trzby write Fdat_trzby;
    property celk_trzba:       CastkaType    Index (IS_ATTR) read Fcelk_trzba write Fcelk_trzba;
    property zakl_nepodl_dph:  CastkaType    Index (IS_ATTR or IS_OPTN) read Fzakl_nepodl_dph write Setzakl_nepodl_dph stored zakl_nepodl_dph_Specified;
    property zakl_dan1:        CastkaType    Index (IS_ATTR or IS_OPTN) read Fzakl_dan1 write Setzakl_dan1 stored zakl_dan1_Specified;
    property dan1:             CastkaType    Index (IS_ATTR or IS_OPTN) read Fdan1 write Setdan1 stored dan1_Specified;
    property zakl_dan2:        CastkaType    Index (IS_ATTR or IS_OPTN) read Fzakl_dan2 write Setzakl_dan2 stored zakl_dan2_Specified;
    property dan2:             CastkaType    Index (IS_ATTR or IS_OPTN) read Fdan2 write Setdan2 stored dan2_Specified;
    property zakl_dan3:        CastkaType    Index (IS_ATTR or IS_OPTN) read Fzakl_dan3 write Setzakl_dan3 stored zakl_dan3_Specified;
    property dan3:             CastkaType    Index (IS_ATTR or IS_OPTN) read Fdan3 write Setdan3 stored dan3_Specified;
    property cest_sluz:        CastkaType    Index (IS_ATTR or IS_OPTN) read Fcest_sluz write Setcest_sluz stored cest_sluz_Specified;
    property pouzit_zboz1:     CastkaType    Index (IS_ATTR or IS_OPTN) read Fpouzit_zboz1 write Setpouzit_zboz1 stored pouzit_zboz1_Specified;
    property pouzit_zboz2:     CastkaType    Index (IS_ATTR or IS_OPTN) read Fpouzit_zboz2 write Setpouzit_zboz2 stored pouzit_zboz2_Specified;
    property pouzit_zboz3:     CastkaType    Index (IS_ATTR or IS_OPTN) read Fpouzit_zboz3 write Setpouzit_zboz3 stored pouzit_zboz3_Specified;
    property urceno_cerp_zuct: CastkaType    Index (IS_ATTR or IS_OPTN) read Furceno_cerp_zuct write Seturceno_cerp_zuct stored urceno_cerp_zuct_Specified;
    property cerp_zuct:        CastkaType    Index (IS_ATTR or IS_OPTN) read Fcerp_zuct write Setcerp_zuct stored cerp_zuct_Specified;
    property rezim:            RezimType     Index (IS_ATTR) read Frezim write Frezim;
  end;


  // ************************************************************************ //
  // Namespace : http://fs.mfcr.cz/eet/schema/v2
  // soapAction: http://fs.mfcr.cz/eet/OdeslaniTrzby
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : EETSOAP
  // service   : EETService
  // port      : EETServiceSOAP
  // URL       : https://pg.eet.cz:443/eet/services/EETServiceSOAP/v2
  // ************************************************************************ //
  EET = interface(IInvokable)
  ['{3C72869B-D2EF-EE25-FF09-1F3AB16DA933}']

    // Cannot unwrap: 
    //     - Input element wrapper name does not match operation's name
    //     - More than one strictly out element was found
    function  OdeslaniTrzby(const parameters: Trzba): Odpoved; stdcall;
  end;

function GetEET(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): EET;


implementation
  uses System.SysUtils;

function GetEET(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): EET;
const
  defWSDL = 'L:\Data\owncloud\documentsPPK\EET\verze 2\EETServiceSOAP.wsdl';
  defURL  = 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v2';
  defSvc  = 'EETService';
  defPrt  = 'EETServiceSOAP';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as EET);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor OdpovedHlavickaType.Destroy;
begin
  System.SysUtils.FreeAndNil(Fdat_prij);
  System.SysUtils.FreeAndNil(Fdat_odmit);
  inherited Destroy;
end;

procedure OdpovedHlavickaType.Setuuid_zpravy(Index: Integer; const AUUIDType: UUIDType);
begin
  Fuuid_zpravy := AUUIDType;
  Fuuid_zpravy_Specified := True;
end;

function OdpovedHlavickaType.uuid_zpravy_Specified(Index: Integer): boolean;
begin
  Result := Fuuid_zpravy_Specified;
end;

procedure OdpovedHlavickaType.Setbkp(Index: Integer; const ABkpType: BkpType);
begin
  Fbkp := ABkpType;
  Fbkp_Specified := True;
end;

function OdpovedHlavickaType.bkp_Specified(Index: Integer): boolean;
begin
  Result := Fbkp_Specified;
end;

procedure OdpovedHlavickaType.Setdat_prij(Index: Integer; const AdateTime: dateTime);
begin
  Fdat_prij := AdateTime;
  Fdat_prij_Specified := True;
end;

function OdpovedHlavickaType.dat_prij_Specified(Index: Integer): boolean;
begin
  Result := Fdat_prij_Specified;
end;

procedure OdpovedHlavickaType.Setdat_odmit(Index: Integer; const AdateTime: dateTime);
begin
  Fdat_odmit := AdateTime;
  Fdat_odmit_Specified := True;
end;

function OdpovedHlavickaType.dat_odmit_Specified(Index: Integer): boolean;
begin
  Result := Fdat_odmit_Specified;
end;

procedure OdpovedPotvrzeniType.Settest(Index: Integer; const ABoolean: Boolean);
begin
  Ftest := ABoolean;
  Ftest_Specified := True;
end;

function OdpovedPotvrzeniType.test_Specified(Index: Integer): boolean;
begin
  Result := Ftest_Specified;
end;

destructor TrzbaHlavickaType.Destroy;
begin
  System.SysUtils.FreeAndNil(Fdat_odesl);
  inherited Destroy;
end;

procedure TrzbaHlavickaType.Setovereni(Index: Integer; const ABoolean: Boolean);
begin
  Fovereni := ABoolean;
  Fovereni_Specified := True;
end;

function TrzbaHlavickaType.overeni_Specified(Index: Integer): boolean;
begin
  Result := Fovereni_Specified;
end;

constructor TrzbaType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor TrzbaType.Destroy;
begin
  System.SysUtils.FreeAndNil(FHlavicka);
  System.SysUtils.FreeAndNil(FData);
  System.SysUtils.FreeAndNil(FKontrolniKody);
  inherited Destroy;
end;

constructor OdpovedType.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor OdpovedType.Destroy;
begin
  System.SysUtils.FreeAndNil(FHlavicka);
  System.SysUtils.FreeAndNil(FPotvrzeni);
  System.SysUtils.FreeAndNil(FChyba);
  inherited Destroy;
end;

procedure OdpovedType.SetPotvrzeni(Index: Integer; const AOdpovedPotvrzeniType: OdpovedPotvrzeniType);
begin
  FPotvrzeni := AOdpovedPotvrzeniType;
  FPotvrzeni_Specified := True;
end;

function OdpovedType.Potvrzeni_Specified(Index: Integer): boolean;
begin
  Result := FPotvrzeni_Specified;
end;

procedure OdpovedType.SetChyba(Index: Integer; const AOdpovedChybaType: OdpovedChybaType);
begin
  FChyba := AOdpovedChybaType;
  FChyba_Specified := True;
end;

function OdpovedType.Chyba_Specified(Index: Integer): boolean;
begin
  Result := FChyba_Specified;
end;

destructor TrzbaKontrolniKodyType.Destroy;
begin
  System.SysUtils.FreeAndNil(Fpkp);
  System.SysUtils.FreeAndNil(Fbkp);
  inherited Destroy;
end;

destructor TrzbaDataType.Destroy;
begin
  System.SysUtils.FreeAndNil(Fdat_trzby);
  System.SysUtils.FreeAndNil(Fcelk_trzba);
  System.SysUtils.FreeAndNil(Fzakl_nepodl_dph);
  System.SysUtils.FreeAndNil(Fzakl_dan1);
  System.SysUtils.FreeAndNil(Fdan1);
  System.SysUtils.FreeAndNil(Fzakl_dan2);
  System.SysUtils.FreeAndNil(Fdan2);
  System.SysUtils.FreeAndNil(Fzakl_dan3);
  System.SysUtils.FreeAndNil(Fdan3);
  System.SysUtils.FreeAndNil(Fcest_sluz);
  System.SysUtils.FreeAndNil(Fpouzit_zboz1);
  System.SysUtils.FreeAndNil(Fpouzit_zboz2);
  System.SysUtils.FreeAndNil(Fpouzit_zboz3);
  System.SysUtils.FreeAndNil(Furceno_cerp_zuct);
  System.SysUtils.FreeAndNil(Fcerp_zuct);
  inherited Destroy;
end;

procedure TrzbaDataType.Setdic_poverujiciho(Index: Integer; const ACZDICType: CZDICType);
begin
  Fdic_poverujiciho := ACZDICType;
  Fdic_poverujiciho_Specified := True;
end;

function TrzbaDataType.dic_poverujiciho_Specified(Index: Integer): boolean;
begin
  Result := Fdic_poverujiciho_Specified;
end;

procedure TrzbaDataType.Setzakl_nepodl_dph(Index: Integer; const ACastkaType: CastkaType);
begin
  Fzakl_nepodl_dph := ACastkaType;
  Fzakl_nepodl_dph_Specified := True;
end;

function TrzbaDataType.zakl_nepodl_dph_Specified(Index: Integer): boolean;
begin
  Result := Fzakl_nepodl_dph_Specified;
end;

procedure TrzbaDataType.Setzakl_dan1(Index: Integer; const ACastkaType: CastkaType);
begin
  Fzakl_dan1 := ACastkaType;
  Fzakl_dan1_Specified := True;
end;

function TrzbaDataType.zakl_dan1_Specified(Index: Integer): boolean;
begin
  Result := Fzakl_dan1_Specified;
end;

procedure TrzbaDataType.Setdan1(Index: Integer; const ACastkaType: CastkaType);
begin
  Fdan1 := ACastkaType;
  Fdan1_Specified := True;
end;

function TrzbaDataType.dan1_Specified(Index: Integer): boolean;
begin
  Result := Fdan1_Specified;
end;

procedure TrzbaDataType.Setzakl_dan2(Index: Integer; const ACastkaType: CastkaType);
begin
  Fzakl_dan2 := ACastkaType;
  Fzakl_dan2_Specified := True;
end;

function TrzbaDataType.zakl_dan2_Specified(Index: Integer): boolean;
begin
  Result := Fzakl_dan2_Specified;
end;

procedure TrzbaDataType.Setdan2(Index: Integer; const ACastkaType: CastkaType);
begin
  Fdan2 := ACastkaType;
  Fdan2_Specified := True;
end;

function TrzbaDataType.dan2_Specified(Index: Integer): boolean;
begin
  Result := Fdan2_Specified;
end;

procedure TrzbaDataType.Setzakl_dan3(Index: Integer; const ACastkaType: CastkaType);
begin
  Fzakl_dan3 := ACastkaType;
  Fzakl_dan3_Specified := True;
end;

function TrzbaDataType.zakl_dan3_Specified(Index: Integer): boolean;
begin
  Result := Fzakl_dan3_Specified;
end;

procedure TrzbaDataType.Setdan3(Index: Integer; const ACastkaType: CastkaType);
begin
  Fdan3 := ACastkaType;
  Fdan3_Specified := True;
end;

function TrzbaDataType.dan3_Specified(Index: Integer): boolean;
begin
  Result := Fdan3_Specified;
end;

procedure TrzbaDataType.Setcest_sluz(Index: Integer; const ACastkaType: CastkaType);
begin
  Fcest_sluz := ACastkaType;
  Fcest_sluz_Specified := True;
end;

function TrzbaDataType.cest_sluz_Specified(Index: Integer): boolean;
begin
  Result := Fcest_sluz_Specified;
end;

procedure TrzbaDataType.Setpouzit_zboz1(Index: Integer; const ACastkaType: CastkaType);
begin
  Fpouzit_zboz1 := ACastkaType;
  Fpouzit_zboz1_Specified := True;
end;

function TrzbaDataType.pouzit_zboz1_Specified(Index: Integer): boolean;
begin
  Result := Fpouzit_zboz1_Specified;
end;

procedure TrzbaDataType.Setpouzit_zboz2(Index: Integer; const ACastkaType: CastkaType);
begin
  Fpouzit_zboz2 := ACastkaType;
  Fpouzit_zboz2_Specified := True;
end;

function TrzbaDataType.pouzit_zboz2_Specified(Index: Integer): boolean;
begin
  Result := Fpouzit_zboz2_Specified;
end;

procedure TrzbaDataType.Setpouzit_zboz3(Index: Integer; const ACastkaType: CastkaType);
begin
  Fpouzit_zboz3 := ACastkaType;
  Fpouzit_zboz3_Specified := True;
end;

function TrzbaDataType.pouzit_zboz3_Specified(Index: Integer): boolean;
begin
  Result := Fpouzit_zboz3_Specified;
end;

procedure TrzbaDataType.Seturceno_cerp_zuct(Index: Integer; const ACastkaType: CastkaType);
begin
  Furceno_cerp_zuct := ACastkaType;
  Furceno_cerp_zuct_Specified := True;
end;

function TrzbaDataType.urceno_cerp_zuct_Specified(Index: Integer): boolean;
begin
  Result := Furceno_cerp_zuct_Specified;
end;

procedure TrzbaDataType.Setcerp_zuct(Index: Integer; const ACastkaType: CastkaType);
begin
  Fcerp_zuct := ACastkaType;
  Fcerp_zuct_Specified := True;
end;

function TrzbaDataType.cerp_zuct_Specified(Index: Integer): boolean;
begin
  Result := Fcerp_zuct_Specified;
end;

initialization
  { EET }
  InvRegistry.RegisterInterface(TypeInfo(EET), 'http://fs.mfcr.cz/eet/schema/v2', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(EET), 'http://fs.mfcr.cz/eet/OdeslaniTrzby');
  InvRegistry.RegisterInvokeOptions(TypeInfo(EET), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(EET), ioLiteral);
  RemClassRegistry.RegisterXSInfo(TypeInfo(PkpEncodingType), 'http://fs.mfcr.cz/eet/schema/v2', 'PkpEncodingType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(BkpDigestType), 'http://fs.mfcr.cz/eet/schema/v2', 'BkpDigestType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(BkpEncodingType), 'http://fs.mfcr.cz/eet/schema/v2', 'BkpEncodingType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(FikType), 'http://fs.mfcr.cz/eet/schema/v2', 'FikType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(BkpType), 'http://fs.mfcr.cz/eet/schema/v2', 'BkpType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(dateTime), 'http://fs.mfcr.cz/eet/schema/v2', 'dateTime');
  RemClassRegistry.RegisterXSInfo(TypeInfo(UUIDType), 'http://fs.mfcr.cz/eet/schema/v2', 'UUIDType');
  RemClassRegistry.RegisterXSClass(OdpovedHlavickaType, 'http://fs.mfcr.cz/eet/schema/v2', 'OdpovedHlavickaType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(CZDICType), 'http://fs.mfcr.cz/eet/schema/v2', 'CZDICType');
  RemClassRegistry.RegisterXSClass(OdpovedPotvrzeniType, 'http://fs.mfcr.cz/eet/schema/v2', 'OdpovedPotvrzeniType');
  RemClassRegistry.RegisterXSClass(TrzbaHlavickaType, 'http://fs.mfcr.cz/eet/schema/v2', 'TrzbaHlavickaType');
  RemClassRegistry.RegisterXSClass(TrzbaType, 'http://fs.mfcr.cz/eet/schema/v2', 'TrzbaType');
  RemClassRegistry.RegisterSerializeOptions(TrzbaType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(Trzba, 'http://fs.mfcr.cz/eet/schema/v2', 'Trzba');
  RemClassRegistry.RegisterXSInfo(TypeInfo(IdProvozType), 'http://fs.mfcr.cz/eet/schema/v2', 'IdProvozType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(OdpovedChybaType), 'http://fs.mfcr.cz/eet/schema/v2', 'OdpovedChybaType');
  RemClassRegistry.RegisterXSClass(OdpovedType, 'http://fs.mfcr.cz/eet/schema/v2', 'OdpovedType');
  RemClassRegistry.RegisterSerializeOptions(OdpovedType, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(Odpoved, 'http://fs.mfcr.cz/eet/schema/v2', 'Odpoved');
  RemClassRegistry.RegisterXSInfo(TypeInfo(BkpElementType), 'http://fs.mfcr.cz/eet/schema/v2', 'BkpElementType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(PkpCipherType), 'http://fs.mfcr.cz/eet/schema/v2', 'PkpCipherType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(PkpDigestType), 'http://fs.mfcr.cz/eet/schema/v2', 'PkpDigestType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(CastkaType), 'http://fs.mfcr.cz/eet/schema/v2', 'CastkaType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://fs.mfcr.cz/eet/schema/v2', 'string_', 'string');
  RemClassRegistry.RegisterXSInfo(TypeInfo(PkpElementType), 'http://fs.mfcr.cz/eet/schema/v2', 'PkpElementType');
  RemClassRegistry.RegisterXSClass(TrzbaKontrolniKodyType, 'http://fs.mfcr.cz/eet/schema/v2', 'TrzbaKontrolniKodyType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(RezimType), 'http://fs.mfcr.cz/eet/schema/v2', 'RezimType');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(RezimType), '_0', '0');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(RezimType), '_1', '1');
  RemClassRegistry.RegisterXSClass(TrzbaDataType, 'http://fs.mfcr.cz/eet/schema/v2', 'TrzbaDataType');

end.