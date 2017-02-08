
{**************************************************************************************}
{                                                                                      }
{                                   XML Data Binding                                   }
{                                                                                      }
{         Generated on: 2. 2. 2017 20:16:36                                            }
{       Generated from: EETXMLSchema.xsd   }
{   Settings stored in: EETXMLSchema.xdb   }
{                                                                                      }
{**************************************************************************************}

unit u_EETXMLSchema;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLTrzbaType = interface;
  IXMLTrzbaHlavickaType = interface;
  IXMLTrzbaDataType = interface;
  IXMLTrzbaKontrolniKodyType = interface;
  IXMLPkpElementType = interface;
  IXMLBkpElementType = interface;
  IXMLOdpovedType = interface;
  IXMLOdpovedHlavickaType = interface;
  IXMLOdpovedPotvrzeniType = interface;
  IXMLOdpovedChybaType = interface;
  IXMLOdpovedVarovaniType = interface;
  IXMLOdpovedVarovaniTypeList = interface;

{ IXMLTrzbaType }

  IXMLTrzbaType = interface(IXMLNode)
    ['{B511D68E-0647-434A-8CBE-5D0AD7A3FF98}']
    { Property Accessors }
    function Get_Hlavicka: IXMLTrzbaHlavickaType;
    function Get_Data: IXMLTrzbaDataType;
    function Get_KontrolniKody: IXMLTrzbaKontrolniKodyType;
    { Methods & Properties }
    property Hlavicka: IXMLTrzbaHlavickaType read Get_Hlavicka;
    property Data: IXMLTrzbaDataType read Get_Data;
    property KontrolniKody: IXMLTrzbaKontrolniKodyType read Get_KontrolniKody;
  end;

{ IXMLTrzbaHlavickaType }

  IXMLTrzbaHlavickaType = interface(IXMLNode)
    ['{3C549707-B8F8-4E26-8458-0A1462617E36}']
    { Property Accessors }
    function Get_Uuid_zpravy: UnicodeString;
    function Get_Dat_odesl: UnicodeString;
    function Get_Prvni_zaslani: Boolean;
    function Get_Overeni: Boolean;
    procedure Set_Uuid_zpravy(Value: UnicodeString);
    procedure Set_Dat_odesl(Value: UnicodeString);
    procedure Set_Prvni_zaslani(Value: Boolean);
    procedure Set_Overeni(Value: Boolean);
    { Methods & Properties }
    property Uuid_zpravy: UnicodeString read Get_Uuid_zpravy write Set_Uuid_zpravy;
    property Dat_odesl: UnicodeString read Get_Dat_odesl write Set_Dat_odesl;
    property Prvni_zaslani: Boolean read Get_Prvni_zaslani write Set_Prvni_zaslani;
    property Overeni: Boolean read Get_Overeni write Set_Overeni;
  end;

{ IXMLTrzbaDataType }

  IXMLTrzbaDataType = interface(IXMLNode)
    ['{3EB075DC-854B-4806-82E2-9F2391E1EE98}']
    { Property Accessors }
    function Get_Dic_popl: UnicodeString;
    function Get_Dic_poverujiciho: UnicodeString;
    function Get_Id_provoz: Integer;
    function Get_Id_pokl: UnicodeString;
    function Get_Porad_cis: UnicodeString;
    function Get_Dat_trzby: UnicodeString;
    function Get_Celk_trzba: UnicodeString;
    function Get_Zakl_nepodl_dph: UnicodeString;
    function Get_Zakl_dan1: UnicodeString;
    function Get_Dan1: UnicodeString;
    function Get_Zakl_dan2: UnicodeString;
    function Get_Dan2: UnicodeString;
    function Get_Zakl_dan3: UnicodeString;
    function Get_Dan3: UnicodeString;
    function Get_Cest_sluz: UnicodeString;
    function Get_Pouzit_zboz1: UnicodeString;
    function Get_Pouzit_zboz2: UnicodeString;
    function Get_Pouzit_zboz3: UnicodeString;
    function Get_Urceno_cerp_zuct: UnicodeString;
    function Get_Cerp_zuct: UnicodeString;
    function Get_Rezim: Integer;
    procedure Set_Dic_popl(Value: UnicodeString);
    procedure Set_Dic_poverujiciho(Value: UnicodeString);
    procedure Set_Id_provoz(Value: Integer);
    procedure Set_Id_pokl(Value: UnicodeString);
    procedure Set_Porad_cis(Value: UnicodeString);
    procedure Set_Dat_trzby(Value: UnicodeString);
    procedure Set_Celk_trzba(Value: UnicodeString);
    procedure Set_Zakl_nepodl_dph(Value: UnicodeString);
    procedure Set_Zakl_dan1(Value: UnicodeString);
    procedure Set_Dan1(Value: UnicodeString);
    procedure Set_Zakl_dan2(Value: UnicodeString);
    procedure Set_Dan2(Value: UnicodeString);
    procedure Set_Zakl_dan3(Value: UnicodeString);
    procedure Set_Dan3(Value: UnicodeString);
    procedure Set_Cest_sluz(Value: UnicodeString);
    procedure Set_Pouzit_zboz1(Value: UnicodeString);
    procedure Set_Pouzit_zboz2(Value: UnicodeString);
    procedure Set_Pouzit_zboz3(Value: UnicodeString);
    procedure Set_Urceno_cerp_zuct(Value: UnicodeString);
    procedure Set_Cerp_zuct(Value: UnicodeString);
    procedure Set_Rezim(Value: Integer);
    { Methods & Properties }
    property Dic_popl: UnicodeString read Get_Dic_popl write Set_Dic_popl;
    property Dic_poverujiciho: UnicodeString read Get_Dic_poverujiciho write Set_Dic_poverujiciho;
    property Id_provoz: Integer read Get_Id_provoz write Set_Id_provoz;
    property Id_pokl: UnicodeString read Get_Id_pokl write Set_Id_pokl;
    property Porad_cis: UnicodeString read Get_Porad_cis write Set_Porad_cis;
    property Dat_trzby: UnicodeString read Get_Dat_trzby write Set_Dat_trzby;
    property Celk_trzba: UnicodeString read Get_Celk_trzba write Set_Celk_trzba;
    property Zakl_nepodl_dph: UnicodeString read Get_Zakl_nepodl_dph write Set_Zakl_nepodl_dph;
    property Zakl_dan1: UnicodeString read Get_Zakl_dan1 write Set_Zakl_dan1;
    property Dan1: UnicodeString read Get_Dan1 write Set_Dan1;
    property Zakl_dan2: UnicodeString read Get_Zakl_dan2 write Set_Zakl_dan2;
    property Dan2: UnicodeString read Get_Dan2 write Set_Dan2;
    property Zakl_dan3: UnicodeString read Get_Zakl_dan3 write Set_Zakl_dan3;
    property Dan3: UnicodeString read Get_Dan3 write Set_Dan3;
    property Cest_sluz: UnicodeString read Get_Cest_sluz write Set_Cest_sluz;
    property Pouzit_zboz1: UnicodeString read Get_Pouzit_zboz1 write Set_Pouzit_zboz1;
    property Pouzit_zboz2: UnicodeString read Get_Pouzit_zboz2 write Set_Pouzit_zboz2;
    property Pouzit_zboz3: UnicodeString read Get_Pouzit_zboz3 write Set_Pouzit_zboz3;
    property Urceno_cerp_zuct: UnicodeString read Get_Urceno_cerp_zuct write Set_Urceno_cerp_zuct;
    property Cerp_zuct: UnicodeString read Get_Cerp_zuct write Set_Cerp_zuct;
    property Rezim: Integer read Get_Rezim write Set_Rezim;
  end;

{ IXMLTrzbaKontrolniKodyType }

  IXMLTrzbaKontrolniKodyType = interface(IXMLNode)
    ['{88198115-71DB-4F1D-893D-C84C116B842F}']
    { Property Accessors }
    function Get_Pkp: IXMLPkpElementType;
    function Get_Bkp: IXMLBkpElementType;
    { Methods & Properties }
    property Pkp: IXMLPkpElementType read Get_Pkp;
    property Bkp: IXMLBkpElementType read Get_Bkp;
  end;

{ IXMLPkpElementType }

  IXMLPkpElementType = interface(IXMLNode)
    ['{B5E5A592-20C7-4A49-B41A-100C8849A247}']
    { Property Accessors }
    function Get_Digest: UnicodeString;
    function Get_Cipher: UnicodeString;
    function Get_Encoding: UnicodeString;
    procedure Set_Digest(Value: UnicodeString);
    procedure Set_Cipher(Value: UnicodeString);
    procedure Set_Encoding(Value: UnicodeString);
    { Methods & Properties }
    property Digest: UnicodeString read Get_Digest write Set_Digest;
    property Cipher: UnicodeString read Get_Cipher write Set_Cipher;
    property Encoding: UnicodeString read Get_Encoding write Set_Encoding;
  end;

{ IXMLBkpElementType }

  IXMLBkpElementType = interface(IXMLNode)
    ['{B9F37235-72DA-4F66-958D-1BF69B4762B9}']
    { Property Accessors }
    function Get_Digest: UnicodeString;
    function Get_Encoding: UnicodeString;
    procedure Set_Digest(Value: UnicodeString);
    procedure Set_Encoding(Value: UnicodeString);
    { Methods & Properties }
    property Digest: UnicodeString read Get_Digest write Set_Digest;
    property Encoding: UnicodeString read Get_Encoding write Set_Encoding;
  end;

{ IXMLOdpovedType }

  IXMLOdpovedType = interface(IXMLNode)
    ['{1177506C-DBE1-4CD5-918D-C19B3FA454F0}']
    { Property Accessors }
    function Get_Hlavicka: IXMLOdpovedHlavickaType;
    function Get_Potvrzeni: IXMLOdpovedPotvrzeniType;
    function Get_Chyba: IXMLOdpovedChybaType;
    function Get_Varovani: IXMLOdpovedVarovaniTypeList;
    { Methods & Properties }
    property Hlavicka: IXMLOdpovedHlavickaType read Get_Hlavicka;
    property Potvrzeni: IXMLOdpovedPotvrzeniType read Get_Potvrzeni;
    property Chyba: IXMLOdpovedChybaType read Get_Chyba;
    property Varovani: IXMLOdpovedVarovaniTypeList read Get_Varovani;
  end;

{ IXMLOdpovedHlavickaType }

  IXMLOdpovedHlavickaType = interface(IXMLNode)
    ['{3E9D735F-E300-484A-94FC-76E3E01F3F37}']
    { Property Accessors }
    function Get_Uuid_zpravy: UnicodeString;
    function Get_Bkp: UnicodeString;
    function Get_Dat_prij: UnicodeString;
    function Get_Dat_odmit: UnicodeString;
    procedure Set_Uuid_zpravy(Value: UnicodeString);
    procedure Set_Bkp(Value: UnicodeString);
    procedure Set_Dat_prij(Value: UnicodeString);
    procedure Set_Dat_odmit(Value: UnicodeString);
    { Methods & Properties }
    property Uuid_zpravy: UnicodeString read Get_Uuid_zpravy write Set_Uuid_zpravy;
    property Bkp: UnicodeString read Get_Bkp write Set_Bkp;
    property Dat_prij: UnicodeString read Get_Dat_prij write Set_Dat_prij;
    property Dat_odmit: UnicodeString read Get_Dat_odmit write Set_Dat_odmit;
  end;

{ IXMLOdpovedPotvrzeniType }

  IXMLOdpovedPotvrzeniType = interface(IXMLNode)
    ['{3B095ED6-4F48-4641-89B4-B83D5FB95F8D}']
    { Property Accessors }
    function Get_Fik: UnicodeString;
    function Get_Test: Boolean;
    procedure Set_Fik(Value: UnicodeString);
    procedure Set_Test(Value: Boolean);
    { Methods & Properties }
    property Fik: UnicodeString read Get_Fik write Set_Fik;
    property Test: Boolean read Get_Test write Set_Test;
  end;

{ IXMLOdpovedChybaType }

  IXMLOdpovedChybaType = interface(IXMLNode)
    ['{519F7F79-609C-4C9E-A619-819CC4621A0C}']
    { Property Accessors }
    function Get_Kod: Integer;
    function Get_Test: Boolean;
    procedure Set_Kod(Value: Integer);
    procedure Set_Test(Value: Boolean);
    { Methods & Properties }
    property Kod: Integer read Get_Kod write Set_Kod;
    property Test: Boolean read Get_Test write Set_Test;
  end;

{ IXMLOdpovedVarovaniType }

  IXMLOdpovedVarovaniType = interface(IXMLNode)
    ['{2D225DB2-EB1F-4C1C-B2C4-544D01DC053E}']
    { Property Accessors }
    function Get_Kod_varov: Integer;
    procedure Set_Kod_varov(Value: Integer);
    { Methods & Properties }
    property Kod_varov: Integer read Get_Kod_varov write Set_Kod_varov;
  end;

{ IXMLOdpovedVarovaniTypeList }

  IXMLOdpovedVarovaniTypeList = interface(IXMLNodeCollection)
    ['{AC6051A7-FC26-4CB9-9063-7E29CE1D7BC3}']
    { Methods & Properties }
    function Add: IXMLOdpovedVarovaniType;
    function Insert(const Index: Integer): IXMLOdpovedVarovaniType;

    function Get_Item(Index: Integer): IXMLOdpovedVarovaniType;
    property Items[Index: Integer]: IXMLOdpovedVarovaniType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLTrzbaType = class;
  TXMLTrzbaHlavickaType = class;
  TXMLTrzbaDataType = class;
  TXMLTrzbaKontrolniKodyType = class;
  TXMLPkpElementType = class;
  TXMLBkpElementType = class;
  TXMLOdpovedType = class;
  TXMLOdpovedHlavickaType = class;
  TXMLOdpovedPotvrzeniType = class;
  TXMLOdpovedChybaType = class;
  TXMLOdpovedVarovaniType = class;
  TXMLOdpovedVarovaniTypeList = class;

{ TXMLTrzbaType }

  TXMLTrzbaType = class(TXMLNode, IXMLTrzbaType)
  protected
    { IXMLTrzbaType }
    function Get_Hlavicka: IXMLTrzbaHlavickaType;
    function Get_Data: IXMLTrzbaDataType;
    function Get_KontrolniKody: IXMLTrzbaKontrolniKodyType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTrzbaHlavickaType }

  TXMLTrzbaHlavickaType = class(TXMLNode, IXMLTrzbaHlavickaType)
  protected
    { IXMLTrzbaHlavickaType }
    function Get_Uuid_zpravy: UnicodeString;
    function Get_Dat_odesl: UnicodeString;
    function Get_Prvni_zaslani: Boolean;
    function Get_Overeni: Boolean;
    procedure Set_Uuid_zpravy(Value: UnicodeString);
    procedure Set_Dat_odesl(Value: UnicodeString);
    procedure Set_Prvni_zaslani(Value: Boolean);
    procedure Set_Overeni(Value: Boolean);
  end;

{ TXMLTrzbaDataType }

  TXMLTrzbaDataType = class(TXMLNode, IXMLTrzbaDataType)
  protected
    { IXMLTrzbaDataType }
    function Get_Dic_popl: UnicodeString;
    function Get_Dic_poverujiciho: UnicodeString;
    function Get_Id_provoz: Integer;
    function Get_Id_pokl: UnicodeString;
    function Get_Porad_cis: UnicodeString;
    function Get_Dat_trzby: UnicodeString;
    function Get_Celk_trzba: UnicodeString;
    function Get_Zakl_nepodl_dph: UnicodeString;
    function Get_Zakl_dan1: UnicodeString;
    function Get_Dan1: UnicodeString;
    function Get_Zakl_dan2: UnicodeString;
    function Get_Dan2: UnicodeString;
    function Get_Zakl_dan3: UnicodeString;
    function Get_Dan3: UnicodeString;
    function Get_Cest_sluz: UnicodeString;
    function Get_Pouzit_zboz1: UnicodeString;
    function Get_Pouzit_zboz2: UnicodeString;
    function Get_Pouzit_zboz3: UnicodeString;
    function Get_Urceno_cerp_zuct: UnicodeString;
    function Get_Cerp_zuct: UnicodeString;
    function Get_Rezim: Integer;
    procedure Set_Dic_popl(Value: UnicodeString);
    procedure Set_Dic_poverujiciho(Value: UnicodeString);
    procedure Set_Id_provoz(Value: Integer);
    procedure Set_Id_pokl(Value: UnicodeString);
    procedure Set_Porad_cis(Value: UnicodeString);
    procedure Set_Dat_trzby(Value: UnicodeString);
    procedure Set_Celk_trzba(Value: UnicodeString);
    procedure Set_Zakl_nepodl_dph(Value: UnicodeString);
    procedure Set_Zakl_dan1(Value: UnicodeString);
    procedure Set_Dan1(Value: UnicodeString);
    procedure Set_Zakl_dan2(Value: UnicodeString);
    procedure Set_Dan2(Value: UnicodeString);
    procedure Set_Zakl_dan3(Value: UnicodeString);
    procedure Set_Dan3(Value: UnicodeString);
    procedure Set_Cest_sluz(Value: UnicodeString);
    procedure Set_Pouzit_zboz1(Value: UnicodeString);
    procedure Set_Pouzit_zboz2(Value: UnicodeString);
    procedure Set_Pouzit_zboz3(Value: UnicodeString);
    procedure Set_Urceno_cerp_zuct(Value: UnicodeString);
    procedure Set_Cerp_zuct(Value: UnicodeString);
    procedure Set_Rezim(Value: Integer);
  end;

{ TXMLTrzbaKontrolniKodyType }

  TXMLTrzbaKontrolniKodyType = class(TXMLNode, IXMLTrzbaKontrolniKodyType)
  protected
    { IXMLTrzbaKontrolniKodyType }
    function Get_Pkp: IXMLPkpElementType;
    function Get_Bkp: IXMLBkpElementType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPkpElementType }

  TXMLPkpElementType = class(TXMLNode, IXMLPkpElementType)
  protected
    { IXMLPkpElementType }
    function Get_Digest: UnicodeString;
    function Get_Cipher: UnicodeString;
    function Get_Encoding: UnicodeString;
    procedure Set_Digest(Value: UnicodeString);
    procedure Set_Cipher(Value: UnicodeString);
    procedure Set_Encoding(Value: UnicodeString);
  end;

{ TXMLBkpElementType }

  TXMLBkpElementType = class(TXMLNode, IXMLBkpElementType)
  protected
    { IXMLBkpElementType }
    function Get_Digest: UnicodeString;
    function Get_Encoding: UnicodeString;
    procedure Set_Digest(Value: UnicodeString);
    procedure Set_Encoding(Value: UnicodeString);
  end;

{ TXMLOdpovedType }

  TXMLOdpovedType = class(TXMLNode, IXMLOdpovedType)
  private
    FVarovani: IXMLOdpovedVarovaniTypeList;
  protected
    { IXMLOdpovedType }
    function Get_Hlavicka: IXMLOdpovedHlavickaType;
    function Get_Potvrzeni: IXMLOdpovedPotvrzeniType;
    function Get_Chyba: IXMLOdpovedChybaType;
    function Get_Varovani: IXMLOdpovedVarovaniTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOdpovedHlavickaType }

  TXMLOdpovedHlavickaType = class(TXMLNode, IXMLOdpovedHlavickaType)
  protected
    { IXMLOdpovedHlavickaType }
    function Get_Uuid_zpravy: UnicodeString;
    function Get_Bkp: UnicodeString;
    function Get_Dat_prij: UnicodeString;
    function Get_Dat_odmit: UnicodeString;
    procedure Set_Uuid_zpravy(Value: UnicodeString);
    procedure Set_Bkp(Value: UnicodeString);
    procedure Set_Dat_prij(Value: UnicodeString);
    procedure Set_Dat_odmit(Value: UnicodeString);
  end;

{ TXMLOdpovedPotvrzeniType }

  TXMLOdpovedPotvrzeniType = class(TXMLNode, IXMLOdpovedPotvrzeniType)
  protected
    { IXMLOdpovedPotvrzeniType }
    function Get_Fik: UnicodeString;
    function Get_Test: Boolean;
    procedure Set_Fik(Value: UnicodeString);
    procedure Set_Test(Value: Boolean);
  end;

{ TXMLOdpovedChybaType }

  TXMLOdpovedChybaType = class(TXMLNode, IXMLOdpovedChybaType)
  protected
    { IXMLOdpovedChybaType }
    function Get_Kod: Integer;
    function Get_Test: Boolean;
    procedure Set_Kod(Value: Integer);
    procedure Set_Test(Value: Boolean);
  end;

{ TXMLOdpovedVarovaniType }

  TXMLOdpovedVarovaniType = class(TXMLNode, IXMLOdpovedVarovaniType)
  protected
    { IXMLOdpovedVarovaniType }
    function Get_Kod_varov: Integer;
    procedure Set_Kod_varov(Value: Integer);
  end;

{ TXMLOdpovedVarovaniTypeList }

  TXMLOdpovedVarovaniTypeList = class(TXMLNodeCollection, IXMLOdpovedVarovaniTypeList)
  protected
    { IXMLOdpovedVarovaniTypeList }
    function Add: IXMLOdpovedVarovaniType;
    function Insert(const Index: Integer): IXMLOdpovedVarovaniType;

    function Get_Item(Index: Integer): IXMLOdpovedVarovaniType;
  end;

{ Global Functions }

function GetEETTrzba(Doc: IXMLDocument): IXMLTrzbaType;
function LoadEETTrzba(const FileName: string): IXMLTrzbaType;
function NewEETTrzba: IXMLTrzbaType;

const
  TargetNamespace = 'http://fs.mfcr.cz/eet/schema/v3';

implementation

{ Global Functions }

function GetEETTrzba(Doc: IXMLDocument): IXMLTrzbaType;
begin
  Result := Doc.GetDocBinding('Trzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function LoadEETTrzba(const FileName: string): IXMLTrzbaType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Trzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function NewEETTrzba: IXMLTrzbaType;
begin
  Result := NewXMLDocument.GetDocBinding('Trzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

{ TXMLTrzbaType }

procedure TXMLTrzbaType.AfterConstruction;
begin
  RegisterChildNode('Hlavicka', TXMLTrzbaHlavickaType);
  RegisterChildNode('Data', TXMLTrzbaDataType);
  RegisterChildNode('KontrolniKody', TXMLTrzbaKontrolniKodyType);
  inherited;
end;

function TXMLTrzbaType.Get_Hlavicka: IXMLTrzbaHlavickaType;
begin
  Result := ChildNodes['Hlavicka'] as IXMLTrzbaHlavickaType;
end;

function TXMLTrzbaType.Get_Data: IXMLTrzbaDataType;
begin
  Result := ChildNodes['Data'] as IXMLTrzbaDataType;
end;

function TXMLTrzbaType.Get_KontrolniKody: IXMLTrzbaKontrolniKodyType;
begin
  Result := ChildNodes['KontrolniKody'] as IXMLTrzbaKontrolniKodyType;
end;

{ TXMLTrzbaHlavickaType }

function TXMLTrzbaHlavickaType.Get_Uuid_zpravy: UnicodeString;
begin
  Result := AttributeNodes['uuid_zpravy'].Text;
end;

procedure TXMLTrzbaHlavickaType.Set_Uuid_zpravy(Value: UnicodeString);
begin
  SetAttribute('uuid_zpravy', Value);
end;

function TXMLTrzbaHlavickaType.Get_Dat_odesl: UnicodeString;
begin
  Result := AttributeNodes['dat_odesl'].Text;
end;

procedure TXMLTrzbaHlavickaType.Set_Dat_odesl(Value: UnicodeString);
begin
  SetAttribute('dat_odesl', Value);
end;

function TXMLTrzbaHlavickaType.Get_Prvni_zaslani: Boolean;
begin
  Result := AttributeNodes['prvni_zaslani'].NodeValue;
end;

procedure TXMLTrzbaHlavickaType.Set_Prvni_zaslani(Value: Boolean);
begin
  SetAttribute('prvni_zaslani', Value);
end;

function TXMLTrzbaHlavickaType.Get_Overeni: Boolean;
begin
  Result := AttributeNodes['overeni'].NodeValue;
end;

procedure TXMLTrzbaHlavickaType.Set_Overeni(Value: Boolean);
begin
  SetAttribute('overeni', Value);
end;

{ TXMLTrzbaDataType }

function TXMLTrzbaDataType.Get_Dic_popl: UnicodeString;
begin
  Result := AttributeNodes['dic_popl'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dic_popl(Value: UnicodeString);
begin
  SetAttribute('dic_popl', Value);
end;

function TXMLTrzbaDataType.Get_Dic_poverujiciho: UnicodeString;
begin
  Result := AttributeNodes['dic_poverujiciho'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dic_poverujiciho(Value: UnicodeString);
begin
  SetAttribute('dic_poverujiciho', Value);
end;

function TXMLTrzbaDataType.Get_Id_provoz: Integer;
begin
  Result := AttributeNodes['id_provoz'].NodeValue;
end;

procedure TXMLTrzbaDataType.Set_Id_provoz(Value: Integer);
begin
  SetAttribute('id_provoz', Value);
end;

function TXMLTrzbaDataType.Get_Id_pokl: UnicodeString;
begin
  Result := AttributeNodes['id_pokl'].Text;
end;

procedure TXMLTrzbaDataType.Set_Id_pokl(Value: UnicodeString);
begin
  SetAttribute('id_pokl', Value);
end;

function TXMLTrzbaDataType.Get_Porad_cis: UnicodeString;
begin
  Result := AttributeNodes['porad_cis'].Text;
end;

procedure TXMLTrzbaDataType.Set_Porad_cis(Value: UnicodeString);
begin
  SetAttribute('porad_cis', Value);
end;

function TXMLTrzbaDataType.Get_Dat_trzby: UnicodeString;
begin
  Result := AttributeNodes['dat_trzby'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dat_trzby(Value: UnicodeString);
begin
  SetAttribute('dat_trzby', Value);
end;

function TXMLTrzbaDataType.Get_Celk_trzba: UnicodeString;
begin
  Result := AttributeNodes['celk_trzba'].Text;
end;

procedure TXMLTrzbaDataType.Set_Celk_trzba(Value: UnicodeString);
begin
  SetAttribute('celk_trzba', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_nepodl_dph: UnicodeString;
begin
  Result := AttributeNodes['zakl_nepodl_dph'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_nepodl_dph(Value: UnicodeString);
begin
  SetAttribute('zakl_nepodl_dph', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_dan1: UnicodeString;
begin
  Result := AttributeNodes['zakl_dan1'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_dan1(Value: UnicodeString);
begin
  SetAttribute('zakl_dan1', Value);
end;

function TXMLTrzbaDataType.Get_Dan1: UnicodeString;
begin
  Result := AttributeNodes['dan1'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dan1(Value: UnicodeString);
begin
  SetAttribute('dan1', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_dan2: UnicodeString;
begin
  Result := AttributeNodes['zakl_dan2'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_dan2(Value: UnicodeString);
begin
  SetAttribute('zakl_dan2', Value);
end;

function TXMLTrzbaDataType.Get_Dan2: UnicodeString;
begin
  Result := AttributeNodes['dan2'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dan2(Value: UnicodeString);
begin
  SetAttribute('dan2', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_dan3: UnicodeString;
begin
  Result := AttributeNodes['zakl_dan3'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_dan3(Value: UnicodeString);
begin
  SetAttribute('zakl_dan3', Value);
end;

function TXMLTrzbaDataType.Get_Dan3: UnicodeString;
begin
  Result := AttributeNodes['dan3'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dan3(Value: UnicodeString);
begin
  SetAttribute('dan3', Value);
end;

function TXMLTrzbaDataType.Get_Cest_sluz: UnicodeString;
begin
  Result := AttributeNodes['cest_sluz'].Text;
end;

procedure TXMLTrzbaDataType.Set_Cest_sluz(Value: UnicodeString);
begin
  SetAttribute('cest_sluz', Value);
end;

function TXMLTrzbaDataType.Get_Pouzit_zboz1: UnicodeString;
begin
  Result := AttributeNodes['pouzit_zboz1'].Text;
end;

procedure TXMLTrzbaDataType.Set_Pouzit_zboz1(Value: UnicodeString);
begin
  SetAttribute('pouzit_zboz1', Value);
end;

function TXMLTrzbaDataType.Get_Pouzit_zboz2: UnicodeString;
begin
  Result := AttributeNodes['pouzit_zboz2'].Text;
end;

procedure TXMLTrzbaDataType.Set_Pouzit_zboz2(Value: UnicodeString);
begin
  SetAttribute('pouzit_zboz2', Value);
end;

function TXMLTrzbaDataType.Get_Pouzit_zboz3: UnicodeString;
begin
  Result := AttributeNodes['pouzit_zboz3'].Text;
end;

procedure TXMLTrzbaDataType.Set_Pouzit_zboz3(Value: UnicodeString);
begin
  SetAttribute('pouzit_zboz3', Value);
end;

function TXMLTrzbaDataType.Get_Urceno_cerp_zuct: UnicodeString;
begin
  Result := AttributeNodes['urceno_cerp_zuct'].Text;
end;

procedure TXMLTrzbaDataType.Set_Urceno_cerp_zuct(Value: UnicodeString);
begin
  SetAttribute('urceno_cerp_zuct', Value);
end;

function TXMLTrzbaDataType.Get_Cerp_zuct: UnicodeString;
begin
  Result := AttributeNodes['cerp_zuct'].Text;
end;

procedure TXMLTrzbaDataType.Set_Cerp_zuct(Value: UnicodeString);
begin
  SetAttribute('cerp_zuct', Value);
end;

function TXMLTrzbaDataType.Get_Rezim: Integer;
begin
  Result := AttributeNodes['rezim'].NodeValue;
end;

procedure TXMLTrzbaDataType.Set_Rezim(Value: Integer);
begin
  SetAttribute('rezim', Value);
end;

{ TXMLTrzbaKontrolniKodyType }

procedure TXMLTrzbaKontrolniKodyType.AfterConstruction;
begin
  RegisterChildNode('pkp', TXMLPkpElementType);
  RegisterChildNode('bkp', TXMLBkpElementType);
  inherited;
end;

function TXMLTrzbaKontrolniKodyType.Get_Pkp: IXMLPkpElementType;
begin
  Result := ChildNodes['pkp'] as IXMLPkpElementType;
end;

function TXMLTrzbaKontrolniKodyType.Get_Bkp: IXMLBkpElementType;
begin
  Result := ChildNodes['bkp'] as IXMLBkpElementType;
end;

{ TXMLPkpElementType }

function TXMLPkpElementType.Get_Digest: UnicodeString;
begin
  Result := AttributeNodes['digest'].Text;
end;

procedure TXMLPkpElementType.Set_Digest(Value: UnicodeString);
begin
  SetAttribute('digest', Value);
end;

function TXMLPkpElementType.Get_Cipher: UnicodeString;
begin
  Result := AttributeNodes['cipher'].Text;
end;

procedure TXMLPkpElementType.Set_Cipher(Value: UnicodeString);
begin
  SetAttribute('cipher', Value);
end;

function TXMLPkpElementType.Get_Encoding: UnicodeString;
begin
  Result := AttributeNodes['encoding'].Text;
end;

procedure TXMLPkpElementType.Set_Encoding(Value: UnicodeString);
begin
  SetAttribute('encoding', Value);
end;

{ TXMLBkpElementType }

function TXMLBkpElementType.Get_Digest: UnicodeString;
begin
  Result := AttributeNodes['digest'].Text;
end;

procedure TXMLBkpElementType.Set_Digest(Value: UnicodeString);
begin
  SetAttribute('digest', Value);
end;

function TXMLBkpElementType.Get_Encoding: UnicodeString;
begin
  Result := AttributeNodes['encoding'].Text;
end;

procedure TXMLBkpElementType.Set_Encoding(Value: UnicodeString);
begin
  SetAttribute('encoding', Value);
end;

{ TXMLOdpovedType }

procedure TXMLOdpovedType.AfterConstruction;
begin
  RegisterChildNode('Hlavicka', TXMLOdpovedHlavickaType);
  RegisterChildNode('Potvrzeni', TXMLOdpovedPotvrzeniType);
  RegisterChildNode('Chyba', TXMLOdpovedChybaType);
  RegisterChildNode('Varovani', TXMLOdpovedVarovaniType);
  FVarovani := CreateCollection(TXMLOdpovedVarovaniTypeList, IXMLOdpovedVarovaniType, 'Varovani') as IXMLOdpovedVarovaniTypeList;
  inherited;
end;

function TXMLOdpovedType.Get_Hlavicka: IXMLOdpovedHlavickaType;
begin
  Result := ChildNodes['Hlavicka'] as IXMLOdpovedHlavickaType;
end;

function TXMLOdpovedType.Get_Potvrzeni: IXMLOdpovedPotvrzeniType;
begin
  Result := ChildNodes['Potvrzeni'] as IXMLOdpovedPotvrzeniType;
end;

function TXMLOdpovedType.Get_Chyba: IXMLOdpovedChybaType;
begin
  Result := ChildNodes['Chyba'] as IXMLOdpovedChybaType;
end;

function TXMLOdpovedType.Get_Varovani: IXMLOdpovedVarovaniTypeList;
begin
  Result := FVarovani;
end;

{ TXMLOdpovedHlavickaType }

function TXMLOdpovedHlavickaType.Get_Uuid_zpravy: UnicodeString;
begin
  Result := AttributeNodes['uuid_zpravy'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Uuid_zpravy(Value: UnicodeString);
begin
  SetAttribute('uuid_zpravy', Value);
end;

function TXMLOdpovedHlavickaType.Get_Bkp: UnicodeString;
begin
  Result := AttributeNodes['bkp'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Bkp(Value: UnicodeString);
begin
  SetAttribute('bkp', Value);
end;

function TXMLOdpovedHlavickaType.Get_Dat_prij: UnicodeString;
begin
  Result := AttributeNodes['dat_prij'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Dat_prij(Value: UnicodeString);
begin
  SetAttribute('dat_prij', Value);
end;

function TXMLOdpovedHlavickaType.Get_Dat_odmit: UnicodeString;
begin
  Result := AttributeNodes['dat_odmit'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Dat_odmit(Value: UnicodeString);
begin
  SetAttribute('dat_odmit', Value);
end;

{ TXMLOdpovedPotvrzeniType }

function TXMLOdpovedPotvrzeniType.Get_Fik: UnicodeString;
begin
  Result := AttributeNodes['fik'].Text;
end;

procedure TXMLOdpovedPotvrzeniType.Set_Fik(Value: UnicodeString);
begin
  SetAttribute('fik', Value);
end;

function TXMLOdpovedPotvrzeniType.Get_Test: Boolean;
begin
  Result := AttributeNodes['test'].NodeValue;
end;

procedure TXMLOdpovedPotvrzeniType.Set_Test(Value: Boolean);
begin
  SetAttribute('test', Value);
end;

{ TXMLOdpovedChybaType }

function TXMLOdpovedChybaType.Get_Kod: Integer;
begin
  Result := AttributeNodes['kod'].NodeValue;
end;

procedure TXMLOdpovedChybaType.Set_Kod(Value: Integer);
begin
  SetAttribute('kod', Value);
end;

function TXMLOdpovedChybaType.Get_Test: Boolean;
begin
  Result := AttributeNodes['test'].NodeValue;
end;

procedure TXMLOdpovedChybaType.Set_Test(Value: Boolean);
begin
  SetAttribute('test', Value);
end;

{ TXMLOdpovedVarovaniType }

function TXMLOdpovedVarovaniType.Get_Kod_varov: Integer;
begin
  Result := AttributeNodes['kod_varov'].NodeValue;
end;

procedure TXMLOdpovedVarovaniType.Set_Kod_varov(Value: Integer);
begin
  SetAttribute('kod_varov', Value);
end;

{ TXMLOdpovedVarovaniTypeList }

function TXMLOdpovedVarovaniTypeList.Add: IXMLOdpovedVarovaniType;
begin
  Result := AddItem(-1) as IXMLOdpovedVarovaniType;
end;

function TXMLOdpovedVarovaniTypeList.Insert(const Index: Integer): IXMLOdpovedVarovaniType;
begin
  Result := AddItem(Index) as IXMLOdpovedVarovaniType;
end;

function TXMLOdpovedVarovaniTypeList.Get_Item(Index: Integer): IXMLOdpovedVarovaniType;
begin
  Result := List[Index] as IXMLOdpovedVarovaniType;
end;

end.