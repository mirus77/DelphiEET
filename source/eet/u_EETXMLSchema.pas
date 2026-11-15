
{************************************************************************************}
{                                                                                    }
{                                  XML Data Binding                                  }
{                                                                                    }
{         Generated on: 15.11.2026 9:39:14                                           }
{       Generated from: C:\Devel\Delphi\Prog\DelphiEET\source\eet\EETXMLSchema.xsd   }
{   Settings stored in: C:\Devel\Delphi\Prog\DelphiEET\source\eet\EETXMLSchema.xdb   }
{                                                                                    }
{************************************************************************************}

unit u_EETXMLSchema;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLTrzbaType = interface;
  IXMLTrzbaHlavickaType = interface;
  IXMLTrzbaDataType = interface;
  IXMLOdpovedType = interface;
  IXMLOdpovedHlavickaType = interface;
  IXMLOdpovedPotvrzeniType = interface;
  IXMLOdpovedChybaType = interface;
  IXMLOdpovedVarovaniType = interface;
  IXMLOdpovedVarovaniTypeList = interface;

{ IXMLTrzbaType }

  IXMLTrzbaType = interface(IXMLNode)
    ['{2FAF79A9-B725-4AEA-AF40-A2CF8CFE593B}']
    { Property Accessors }
    function Get_Hlavicka: IXMLTrzbaHlavickaType;
    function Get_Data: IXMLTrzbaDataType;
    { Methods & Properties }
    property Hlavicka: IXMLTrzbaHlavickaType read Get_Hlavicka;
    property Data: IXMLTrzbaDataType read Get_Data;
  end;

{ IXMLTrzbaHlavickaType }

  IXMLTrzbaHlavickaType = interface(IXMLNode)
    ['{68044DC8-2CE2-4F06-809D-0594A91DF7EC}']
    { Property Accessors }
    function Get_Uuid_zpravy: String;
    function Get_Dat_odesl: String;
    function Get_Prvni_zaslani: Boolean;
    function Get_Overeni: Boolean;
    procedure Set_Uuid_zpravy(const Value: String);
    procedure Set_Dat_odesl(const Value: String);
    procedure Set_Prvni_zaslani(const Value: Boolean);
    procedure Set_Overeni(const Value: Boolean);
    { Methods & Properties }
    property Uuid_zpravy: String read Get_Uuid_zpravy write Set_Uuid_zpravy;
    property Dat_odesl: String read Get_Dat_odesl write Set_Dat_odesl;
    property Prvni_zaslani: Boolean read Get_Prvni_zaslani write Set_Prvni_zaslani;
    property Overeni: Boolean read Get_Overeni write Set_Overeni;
  end;

{ IXMLTrzbaDataType }

  IXMLTrzbaDataType = interface(IXMLNode)
    ['{E36689CC-D608-4652-BF64-8F090E2BBFC2}']
    { Property Accessors }
    function Get_Eic_popl: String;
    function Get_Eic_poverujiciho: String;
    function Get_Povereni_vice_popl: Boolean;
    function Get_Id_jednotky: Integer;
    function Get_Id_pokl: String;
    function Get_Porad_cis: String;
    function Get_Dat_trzby: String;
    function Get_Celk_trzba: String;
    function Get_Urceno_cerp_zuct: String;
    function Get_Cerp_zuct: String;
    procedure Set_Eic_popl(const Value: String);
    procedure Set_Eic_poverujiciho(const Value: String);
    procedure Set_Povereni_vice_popl(const Value: Boolean);
    procedure Set_Id_jednotky(const Value: Integer);
    procedure Set_Id_pokl(const Value: String);
    procedure Set_Porad_cis(const Value: String);
    procedure Set_Dat_trzby(const Value: String);
    procedure Set_Celk_trzba(const Value: String);
    procedure Set_Urceno_cerp_zuct(const Value: String);
    procedure Set_Cerp_zuct(const Value: String);
    { Methods & Properties }
    property Eic_popl: String read Get_Eic_popl write Set_Eic_popl;
    property Eic_poverujiciho: String read Get_Eic_poverujiciho write Set_Eic_poverujiciho;
    property Povereni_vice_popl: Boolean read Get_Povereni_vice_popl write Set_Povereni_vice_popl;
    property Id_jednotky: Integer read Get_Id_jednotky write Set_Id_jednotky;
    property Id_pokl: String read Get_Id_pokl write Set_Id_pokl;
    property Porad_cis: String read Get_Porad_cis write Set_Porad_cis;
    property Dat_trzby: String read Get_Dat_trzby write Set_Dat_trzby;
    property Celk_trzba: String read Get_Celk_trzba write Set_Celk_trzba;
    property Urceno_cerp_zuct: String read Get_Urceno_cerp_zuct write Set_Urceno_cerp_zuct;
    property Cerp_zuct: String read Get_Cerp_zuct write Set_Cerp_zuct;
  end;

{ IXMLOdpovedType }

  IXMLOdpovedType = interface(IXMLNode)
    ['{4FC23A43-48A0-4FAF-A206-033C0ABF7541}']
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
    ['{C8A020A9-AD80-448C-9FBE-69876D51D7AF}']
    { Property Accessors }
    function Get_Uuid_zpravy: String;
    function Get_Dat_prij: String;
    function Get_Dat_odmit: String;
    procedure Set_Uuid_zpravy(const Value: String);
    procedure Set_Dat_prij(const Value: String);
    procedure Set_Dat_odmit(const Value: String);
    { Methods & Properties }
    property Uuid_zpravy: String read Get_Uuid_zpravy write Set_Uuid_zpravy;
    property Dat_prij: String read Get_Dat_prij write Set_Dat_prij;
    property Dat_odmit: String read Get_Dat_odmit write Set_Dat_odmit;
  end;

{ IXMLOdpovedPotvrzeniType }

  IXMLOdpovedPotvrzeniType = interface(IXMLNode)
    ['{701784A1-96DC-4279-A245-B2AF2BA3D4D2}']
    { Property Accessors }
    function Get_Pok: String;
    function Get_Test: Boolean;
    procedure Set_Pok(const Value: String);
    procedure Set_Test(const Value: Boolean);
    { Methods & Properties }
    property Pok: String read Get_Pok write Set_Pok;
    property Test: Boolean read Get_Test write Set_Test;
  end;

{ IXMLOdpovedChybaType }

  IXMLOdpovedChybaType = interface(IXMLNode)
    ['{7F474599-44BE-46AE-B0DA-01FAEDDFA31F}']
    { Property Accessors }
    function Get_Kod: Integer;
    function Get_Test: Boolean;
    procedure Set_Kod(const Value: Integer);
    procedure Set_Test(const Value: Boolean);
    { Methods & Properties }
    property Kod: Integer read Get_Kod write Set_Kod;
    property Test: Boolean read Get_Test write Set_Test;
  end;

{ IXMLOdpovedVarovaniType }

  IXMLOdpovedVarovaniType = interface(IXMLNode)
    ['{DB80AEC3-C873-418D-A3A5-2220DA1555CF}']
    { Property Accessors }
    function Get_Kod_varov: Integer;
    procedure Set_Kod_varov(const Value: Integer);
    { Methods & Properties }
    property Kod_varov: Integer read Get_Kod_varov write Set_Kod_varov;
  end;

{ IXMLOdpovedVarovaniTypeList }

  IXMLOdpovedVarovaniTypeList = interface(IXMLNodeCollection)
    ['{BEA3BFF3-8308-4E2C-8B8C-6AB1C29D3A45}']
    { Methods & Properties }
    function Add: IXMLOdpovedVarovaniType;
    function Insert(const Index: Integer): IXMLOdpovedVarovaniType;

    function Get_Item(const Index: Integer): IXMLOdpovedVarovaniType;
    property Items[const Index: Integer]: IXMLOdpovedVarovaniType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLTrzbaType = class;
  TXMLTrzbaHlavickaType = class;
  TXMLTrzbaDataType = class;
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
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTrzbaHlavickaType }

  TXMLTrzbaHlavickaType = class(TXMLNode, IXMLTrzbaHlavickaType)
  protected
    { IXMLTrzbaHlavickaType }
    function Get_Uuid_zpravy: String;
    function Get_Dat_odesl: String;
    function Get_Prvni_zaslani: Boolean;
    function Get_Overeni: Boolean;
    procedure Set_Uuid_zpravy(const Value: String);
    procedure Set_Dat_odesl(const Value: String);
    procedure Set_Prvni_zaslani(const Value: Boolean);
    procedure Set_Overeni(const Value: Boolean);
  end;

{ TXMLTrzbaDataType }

  TXMLTrzbaDataType = class(TXMLNode, IXMLTrzbaDataType)
  protected
    { IXMLTrzbaDataType }
    function Get_Eic_popl: String;
    function Get_Eic_poverujiciho: String;
    function Get_Povereni_vice_popl: Boolean;
    function Get_Id_jednotky: Integer;
    function Get_Id_pokl: String;
    function Get_Porad_cis: String;
    function Get_Dat_trzby: String;
    function Get_Celk_trzba: String;
    function Get_Urceno_cerp_zuct: String;
    function Get_Cerp_zuct: String;
    procedure Set_Eic_popl(const Value: String);
    procedure Set_Eic_poverujiciho(const Value: String);
    procedure Set_Povereni_vice_popl(const Value: Boolean);
    procedure Set_Id_jednotky(const Value: Integer);
    procedure Set_Id_pokl(const Value: String);
    procedure Set_Porad_cis(const Value: String);
    procedure Set_Dat_trzby(const Value: String);
    procedure Set_Celk_trzba(const Value: String);
    procedure Set_Urceno_cerp_zuct(const Value: String);
    procedure Set_Cerp_zuct(const Value: String);
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
    function Get_Uuid_zpravy: String;
    function Get_Dat_prij: String;
    function Get_Dat_odmit: String;
    procedure Set_Uuid_zpravy(const Value: String);
    procedure Set_Dat_prij(const Value: String);
    procedure Set_Dat_odmit(const Value: String);
  end;

{ TXMLOdpovedPotvrzeniType }

  TXMLOdpovedPotvrzeniType = class(TXMLNode, IXMLOdpovedPotvrzeniType)
  protected
    { IXMLOdpovedPotvrzeniType }
    function Get_Pok: String;
    function Get_Test: Boolean;
    procedure Set_Pok(const Value: String);
    procedure Set_Test(const Value: Boolean);
  end;

{ TXMLOdpovedChybaType }

  TXMLOdpovedChybaType = class(TXMLNode, IXMLOdpovedChybaType)
  protected
    { IXMLOdpovedChybaType }
    function Get_Kod: Integer;
    function Get_Test: Boolean;
    procedure Set_Kod(const Value: Integer);
    procedure Set_Test(const Value: Boolean);
  end;

{ TXMLOdpovedVarovaniType }

  TXMLOdpovedVarovaniType = class(TXMLNode, IXMLOdpovedVarovaniType)
  protected
    { IXMLOdpovedVarovaniType }
    function Get_Kod_varov: Integer;
    procedure Set_Kod_varov(const Value: Integer);
  end;

{ TXMLOdpovedVarovaniTypeList }

  TXMLOdpovedVarovaniTypeList = class(TXMLNodeCollection, IXMLOdpovedVarovaniTypeList)
  protected
    { IXMLOdpovedVarovaniTypeList }
    function Add: IXMLOdpovedVarovaniType;
    function Insert(const Index: Integer): IXMLOdpovedVarovaniType;

    function Get_Item(const Index: Integer): IXMLOdpovedVarovaniType;
  end;

{ Global Functions }

function GetTrzba(Doc: IXMLDocument): IXMLTrzbaType;
function LoadTrzba(const FileName: string): IXMLTrzbaType;
function NewTrzba: IXMLTrzbaType;

// Helper: amount -> CastkaType string (decimal point, 2 decimals), e.g. 34113 -> "34113.00"
function DoubleToCastkaType(Value: Double): String;

const
  TargetNamespace = 'http://fs.gov.cz/eet/schema/v4';

implementation

uses Variants, SysUtils, xmlutil;

const
  LocFS: TFormatSettings = (DecimalSeparator: '.');

{ Global Functions }

function GetTrzba(Doc: IXMLDocument): IXMLTrzbaType;
begin
  Result := Doc.GetDocBinding('Trzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function LoadTrzba(const FileName: string): IXMLTrzbaType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Trzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function NewTrzba: IXMLTrzbaType;
begin
  Result := NewXMLDocument.GetDocBinding('Trzba', TXMLTrzbaType, TargetNamespace) as IXMLTrzbaType;
end;

function DoubleToCastkaType(Value: Double): String;
begin
  Result := FormatFloat('0.00', Value, LocFS);
end;

{ TXMLTrzbaType }

procedure TXMLTrzbaType.AfterConstruction;
begin
  RegisterChildNode('Hlavicka', TXMLTrzbaHlavickaType);
  RegisterChildNode('Data', TXMLTrzbaDataType);
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

{ TXMLTrzbaHlavickaType }

function TXMLTrzbaHlavickaType.Get_Uuid_zpravy: String;
begin
  Result := AttributeNodes['uuid_zpravy'].Text;
end;

procedure TXMLTrzbaHlavickaType.Set_Uuid_zpravy(const Value: String);
begin
  SetAttribute('uuid_zpravy', Value);
end;

function TXMLTrzbaHlavickaType.Get_Dat_odesl: String;
begin
  Result := AttributeNodes['dat_odesl'].Text;
end;

procedure TXMLTrzbaHlavickaType.Set_Dat_odesl(const Value: String);
begin
  SetAttribute('dat_odesl', Value);
end;

function TXMLTrzbaHlavickaType.Get_Prvni_zaslani: Boolean;
begin
  Result := XmlStrToBool(AttributeNodes['prvni_zaslani'].Text);
end;

procedure TXMLTrzbaHlavickaType.Set_Prvni_zaslani(const Value: Boolean);
begin
  SetAttribute('prvni_zaslani', Value);
end;

function TXMLTrzbaHlavickaType.Get_Overeni: Boolean;
begin
  Result := XmlStrToBool(AttributeNodes['overeni'].Text);
end;

procedure TXMLTrzbaHlavickaType.Set_Overeni(const Value: Boolean);
begin
  SetAttribute('overeni', Value);
end;

{ TXMLTrzbaDataType }

function TXMLTrzbaDataType.Get_Eic_popl: String;
begin
  Result := AttributeNodes['eic_popl'].Text;
end;

procedure TXMLTrzbaDataType.Set_Eic_popl(const Value: String);
begin
  SetAttribute('eic_popl', Value);
end;

function TXMLTrzbaDataType.Get_Eic_poverujiciho: String;
begin
  Result := AttributeNodes['eic_poverujiciho'].Text;
end;

procedure TXMLTrzbaDataType.Set_Eic_poverujiciho(const Value: String);
begin
  SetAttribute('eic_poverujiciho', Value);
end;

function TXMLTrzbaDataType.Get_Povereni_vice_popl: Boolean;
begin
  Result := XmlStrToBool(AttributeNodes['povereni_vice_popl'].Text);
end;

procedure TXMLTrzbaDataType.Set_Povereni_vice_popl(const Value: Boolean);
begin
  SetAttribute('povereni_vice_popl', Value);
end;

function TXMLTrzbaDataType.Get_Id_jednotky: Integer;
begin
  Result := XmlStrToInt(AttributeNodes['id_jednotky'].Text);
end;

procedure TXMLTrzbaDataType.Set_Id_jednotky(const Value: Integer);
begin
  SetAttribute('id_jednotky', Value);
end;

function TXMLTrzbaDataType.Get_Id_pokl: String;
begin
  Result := AttributeNodes['id_pokl'].Text;
end;

procedure TXMLTrzbaDataType.Set_Id_pokl(const Value: String);
begin
  SetAttribute('id_pokl', Value);
end;

function TXMLTrzbaDataType.Get_Porad_cis: String;
begin
  Result := AttributeNodes['porad_cis'].Text;
end;

procedure TXMLTrzbaDataType.Set_Porad_cis(const Value: String);
begin
  SetAttribute('porad_cis', Value);
end;

function TXMLTrzbaDataType.Get_Dat_trzby: String;
begin
  Result := AttributeNodes['dat_trzby'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dat_trzby(const Value: String);
begin
  SetAttribute('dat_trzby', Value);
end;

function TXMLTrzbaDataType.Get_Celk_trzba: String;
begin
  Result := AttributeNodes['celk_trzba'].Text;
end;

procedure TXMLTrzbaDataType.Set_Celk_trzba(const Value: String);
begin
  SetAttribute('celk_trzba', Value);
end;

function TXMLTrzbaDataType.Get_Urceno_cerp_zuct: String;
begin
  Result := AttributeNodes['urceno_cerp_zuct'].Text;
end;

procedure TXMLTrzbaDataType.Set_Urceno_cerp_zuct(const Value: String);
begin
  SetAttribute('urceno_cerp_zuct', Value);
end;

function TXMLTrzbaDataType.Get_Cerp_zuct: String;
begin
  Result := AttributeNodes['cerp_zuct'].Text;
end;

procedure TXMLTrzbaDataType.Set_Cerp_zuct(const Value: String);
begin
  SetAttribute('cerp_zuct', Value);
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

function TXMLOdpovedHlavickaType.Get_Uuid_zpravy: String;
begin
  Result := AttributeNodes['uuid_zpravy'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Uuid_zpravy(const Value: String);
begin
  SetAttribute('uuid_zpravy', Value);
end;

function TXMLOdpovedHlavickaType.Get_Dat_prij: String;
begin
  Result := AttributeNodes['dat_prij'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Dat_prij(const Value: String);
begin
  SetAttribute('dat_prij', Value);
end;

function TXMLOdpovedHlavickaType.Get_Dat_odmit: String;
begin
  Result := AttributeNodes['dat_odmit'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Dat_odmit(const Value: String);
begin
  SetAttribute('dat_odmit', Value);
end;

{ TXMLOdpovedPotvrzeniType }

function TXMLOdpovedPotvrzeniType.Get_Pok: String;
begin
  Result := AttributeNodes['pok'].Text;
end;

procedure TXMLOdpovedPotvrzeniType.Set_Pok(const Value: String);
begin
  SetAttribute('pok', Value);
end;

function TXMLOdpovedPotvrzeniType.Get_Test: Boolean;
begin
  Result := XmlStrToBool(AttributeNodes['test'].Text);
end;

procedure TXMLOdpovedPotvrzeniType.Set_Test(const Value: Boolean);
begin
  SetAttribute('test', Value);
end;

{ TXMLOdpovedChybaType }

function TXMLOdpovedChybaType.Get_Kod: Integer;
begin
  Result := XmlStrToInt(AttributeNodes['kod'].Text);
end;

procedure TXMLOdpovedChybaType.Set_Kod(const Value: Integer);
begin
  SetAttribute('kod', Value);
end;

function TXMLOdpovedChybaType.Get_Test: Boolean;
begin
  Result := XmlStrToBool(AttributeNodes['test'].Text);
end;

procedure TXMLOdpovedChybaType.Set_Test(const Value: Boolean);
begin
  SetAttribute('test', Value);
end;

{ TXMLOdpovedVarovaniType }

function TXMLOdpovedVarovaniType.Get_Kod_varov: Integer;
begin
  Result := XmlStrToInt(AttributeNodes['kod_varov'].Text);
end;

procedure TXMLOdpovedVarovaniType.Set_Kod_varov(const Value: Integer);
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

function TXMLOdpovedVarovaniTypeList.Get_Item(const Index: Integer): IXMLOdpovedVarovaniType;
begin
  Result := List[Index] as IXMLOdpovedVarovaniType;
end;

end.