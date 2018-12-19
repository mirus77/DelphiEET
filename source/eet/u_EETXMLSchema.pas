
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 7. 6. 2016 13:13:19                                  }
{       Generated from: L:\Data\owncloud\documentsPPK\EET\EETXMLSchema.xsd   }
{   Settings stored in: L:\Data\owncloud\documentsPPK\EET\EETXMLSchema.xdb   }
{                                                                            }
{****************************************************************************}

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

{ IXMLTrzbaType }

  IXMLTrzbaType = interface(IXMLNode)
    ['{58FF9299-8DD3-4F7C-BEAE-2F42121E8260}']
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
    ['{2F970350-D6BC-4564-9A78-0A5C78BF4027}']
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
    ['{8B9FC64C-97C2-4407-908D-207CFFE69218}']
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
    ['{A6D93FAA-B5A2-4440-837C-F75619DBA765}']
    { Property Accessors }
    function Get_Pkp: IXMLPkpElementType;
    function Get_Bkp: IXMLBkpElementType;
    { Methods & Properties }
    property Pkp: IXMLPkpElementType read Get_Pkp;
    property Bkp: IXMLBkpElementType read Get_Bkp;
  end;

{ IXMLPkpElementType }

  IXMLPkpElementType = interface(IXMLNode)
    ['{D2657B5C-B83C-4863-9ECC-5FA8E9B505BA}']
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
    ['{A53762DD-3652-4831-9736-8CDE41E80216}']
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
    ['{700BF826-9A76-42AC-9363-EA31193C2EF8}']
    { Property Accessors }
    function Get_Hlavicka: IXMLOdpovedHlavickaType;
    function Get_Potvrzeni: IXMLOdpovedPotvrzeniType;
    function Get_Chyba: IXMLOdpovedChybaType;
    { Methods & Properties }
    property Hlavicka: IXMLOdpovedHlavickaType read Get_Hlavicka;
    property Potvrzeni: IXMLOdpovedPotvrzeniType read Get_Potvrzeni;
    property Chyba: IXMLOdpovedChybaType read Get_Chyba;
  end;

{ IXMLOdpovedHlavickaType }

  IXMLOdpovedHlavickaType = interface(IXMLNode)
    ['{3892F08E-5B41-45D9-A4C0-335693EBF8A8}']
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
    ['{EB80793C-865D-48DD-9704-CD532B38FDD1}']
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
    ['{1FCE025D-C50F-459C-85ED-F3D18C289083}']
    { Property Accessors }
    function Get_Kod: Integer;
    function Get_Test: Boolean;
    procedure Set_Kod(Value: Integer);
    procedure Set_Test(Value: Boolean);
    { Methods & Properties }
    property Kod: Integer read Get_Kod write Set_Kod;
    property Test: Boolean read Get_Test write Set_Test;
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
  protected
    { IXMLOdpovedType }
    function Get_Hlavicka: IXMLOdpovedHlavickaType;
    function Get_Potvrzeni: IXMLOdpovedPotvrzeniType;
    function Get_Chyba: IXMLOdpovedChybaType;
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

{ Global Functions }

function GetEETTrzba(Doc: IXMLDocument): IXMLTrzbaType;
function LoadEETTrzba(const FileName: string): IXMLTrzbaType;
function NewEETTrzba: IXMLTrzbaType;
function GetEETOdpoved(Doc: IXMLDocument): IXMLOdpovedType;
function LoadEETOdpoved(const FileName: string): IXMLOdpovedType;
function NewEETOdpoved: IXMLOdpovedType;

const
  TargetNamespace = 'http://fs.mfcr.cz/eet/schema/v1';

implementation

{ Global Functions }

function GetEETTrzba(Doc: IXMLDocument): IXMLTrzbaType;
begin
  Result := Doc.GetDocBinding('EETTrzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function LoadEETTrzba(const FileName: string): IXMLTrzbaType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('EETTrzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function NewEETTrzba: IXMLTrzbaType;
begin
  Result := NewXMLDocument.GetDocBinding('EETTrzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;
function GetEETOdpoved(Doc: IXMLDocument): IXMLOdpovedType;
begin
  Result := Doc.GetDocBinding('EETOdpoved', TXMLOdpovedType, TargetNamespace) as IXMLOdpovedType;
end;

function LoadEETOdpoved(const FileName: string): IXMLOdpovedType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('EETOdpoved', TXMLOdpovedType, TargetNamespace) as IXMLOdpovedType;
end;

function NewEETOdpoved: IXMLOdpovedType;
begin
  Result := NewXMLDocument.GetDocBinding('EETOdpoved', TXMLOdpovedType, TargetNamespace) as IXMLOdpovedType;
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

end.