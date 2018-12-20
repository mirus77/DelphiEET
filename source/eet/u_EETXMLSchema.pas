
{***************************************************************************************************************************}
{                                                                                                                           }
{                                                     XML Data Binding                                                      }
{                                                                                                                           }
{         Generated on: 19.12.2018 22:50:05                                                                                 }
{       Generated from: C:\eet\EETXMLSchema.xsd   }
{   Settings stored in: C:\eet\EETXMLSchema.xdb   }
{                                                                                                                           }
{***************************************************************************************************************************}

unit u_EETXMLSchema;
{* version 3.1 *}

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
    ['{2BA29260-2B7B-42B8-98C2-4FF9704B55AD}']
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
    ['{33FDC95C-14FA-4D58-B4B1-E708175B86E8}']
    { Property Accessors }
    function Get_Uuid_zpravy: String;
    function Get_Dat_odesl: String;
    function Get_Prvni_zaslani: Boolean;
    function Get_Overeni: Boolean;
    procedure Set_Uuid_zpravy(Value: String);
    procedure Set_Dat_odesl(Value: String);
    procedure Set_Prvni_zaslani(Value: Boolean);
    procedure Set_Overeni(Value: Boolean);
    { Methods & Properties }
    property Uuid_zpravy: String read Get_Uuid_zpravy write Set_Uuid_zpravy;
    property Dat_odesl: String read Get_Dat_odesl write Set_Dat_odesl;
    property Prvni_zaslani: Boolean read Get_Prvni_zaslani write Set_Prvni_zaslani;
    property Overeni: Boolean read Get_Overeni write Set_Overeni;
  end;

{ IXMLTrzbaDataType }

  IXMLTrzbaDataType = interface(IXMLNode)
    ['{2EE7B387-F080-421C-BAD2-F25CFF7B7047}']
    { Property Accessors }
    function Get_Dic_popl: String;
    function Get_Dic_poverujiciho: String;
    function Get_Id_provoz: Integer;
    function Get_Id_pokl: String;
    function Get_Porad_cis: String;
    function Get_Dat_trzby: String;
    function Get_Celk_trzba: String;
    function Get_Zakl_nepodl_dph: String;
    function Get_Zakl_dan1: String;
    function Get_Dan1: String;
    function Get_Zakl_dan2: String;
    function Get_Dan2: String;
    function Get_Zakl_dan3: String;
    function Get_Dan3: String;
    function Get_Cest_sluz: String;
    function Get_Pouzit_zboz1: String;
    function Get_Pouzit_zboz2: String;
    function Get_Pouzit_zboz3: String;
    function Get_Urceno_cerp_zuct: String;
    function Get_Cerp_zuct: String;
    function Get_Rezim: Integer;
    procedure Set_Dic_popl(Value: String);
    procedure Set_Dic_poverujiciho(Value: String);
    procedure Set_Id_provoz(Value: Integer);
    procedure Set_Id_pokl(Value: String);
    procedure Set_Porad_cis(Value: String);
    procedure Set_Dat_trzby(Value: String);
    procedure Set_Celk_trzba(Value: String);
    procedure Set_Zakl_nepodl_dph(Value: String);
    procedure Set_Zakl_dan1(Value: String);
    procedure Set_Dan1(Value: String);
    procedure Set_Zakl_dan2(Value: String);
    procedure Set_Dan2(Value: String);
    procedure Set_Zakl_dan3(Value: String);
    procedure Set_Dan3(Value: String);
    procedure Set_Cest_sluz(Value: String);
    procedure Set_Pouzit_zboz1(Value: String);
    procedure Set_Pouzit_zboz2(Value: String);
    procedure Set_Pouzit_zboz3(Value: String);
    procedure Set_Urceno_cerp_zuct(Value: String);
    procedure Set_Cerp_zuct(Value: String);
    procedure Set_Rezim(Value: Integer);
    { Methods & Properties }
    property Dic_popl: String read Get_Dic_popl write Set_Dic_popl;
    property Dic_poverujiciho: String read Get_Dic_poverujiciho write Set_Dic_poverujiciho;
    property Id_provoz: Integer read Get_Id_provoz write Set_Id_provoz;
    property Id_pokl: String read Get_Id_pokl write Set_Id_pokl;
    property Porad_cis: String read Get_Porad_cis write Set_Porad_cis;
    property Dat_trzby: String read Get_Dat_trzby write Set_Dat_trzby;
    property Celk_trzba: String read Get_Celk_trzba write Set_Celk_trzba;
    property Zakl_nepodl_dph: String read Get_Zakl_nepodl_dph write Set_Zakl_nepodl_dph;
    property Zakl_dan1: String read Get_Zakl_dan1 write Set_Zakl_dan1;
    property Dan1: String read Get_Dan1 write Set_Dan1;
    property Zakl_dan2: String read Get_Zakl_dan2 write Set_Zakl_dan2;
    property Dan2: String read Get_Dan2 write Set_Dan2;
    property Zakl_dan3: String read Get_Zakl_dan3 write Set_Zakl_dan3;
    property Dan3: String read Get_Dan3 write Set_Dan3;
    property Cest_sluz: String read Get_Cest_sluz write Set_Cest_sluz;
    property Pouzit_zboz1: String read Get_Pouzit_zboz1 write Set_Pouzit_zboz1;
    property Pouzit_zboz2: String read Get_Pouzit_zboz2 write Set_Pouzit_zboz2;
    property Pouzit_zboz3: String read Get_Pouzit_zboz3 write Set_Pouzit_zboz3;
    property Urceno_cerp_zuct: String read Get_Urceno_cerp_zuct write Set_Urceno_cerp_zuct;
    property Cerp_zuct: String read Get_Cerp_zuct write Set_Cerp_zuct;
    property Rezim: Integer read Get_Rezim write Set_Rezim;
  end;

{ IXMLTrzbaKontrolniKodyType }

  IXMLTrzbaKontrolniKodyType = interface(IXMLNode)
    ['{13B47BAC-6C0D-42E7-99F8-9BF030F6E368}']
    { Property Accessors }
    function Get_Pkp: IXMLPkpElementType;
    function Get_Bkp: IXMLBkpElementType;
    { Methods & Properties }
    property Pkp: IXMLPkpElementType read Get_Pkp;
    property Bkp: IXMLBkpElementType read Get_Bkp;
  end;

{ IXMLPkpElementType }

  IXMLPkpElementType = interface(IXMLNode)
    ['{B18054F0-45E8-4853-879D-1907FE0FB226}']
    { Property Accessors }
    function Get_Digest: String;
    function Get_Cipher: String;
    function Get_Encoding: String;
    procedure Set_Digest(Value: String);
    procedure Set_Cipher(Value: String);
    procedure Set_Encoding(Value: String);
    { Methods & Properties }
    property Digest: String read Get_Digest write Set_Digest;
    property Cipher: String read Get_Cipher write Set_Cipher;
    property Encoding: String read Get_Encoding write Set_Encoding;
  end;

{ IXMLBkpElementType }

  IXMLBkpElementType = interface(IXMLNode)
    ['{E16C7126-1308-4699-AD7B-34E6C9A668C7}']
    { Property Accessors }
    function Get_Digest: String;
    function Get_Encoding: String;
    procedure Set_Digest(Value: String);
    procedure Set_Encoding(Value: String);
    { Methods & Properties }
    property Digest: String read Get_Digest write Set_Digest;
    property Encoding: String read Get_Encoding write Set_Encoding;
  end;

{ IXMLOdpovedType }

  IXMLOdpovedType = interface(IXMLNode)
    ['{8DFBD307-D5A6-4555-B254-DAF3EAF371C8}']
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
    ['{1EEE7B75-2D64-4808-BD4F-0C3C16416A89}']
    { Property Accessors }
    function Get_Uuid_zpravy: String;
    function Get_Bkp: String;
    function Get_Dat_prij: String;
    function Get_Dat_odmit: String;
    procedure Set_Uuid_zpravy(Value: String);
    procedure Set_Bkp(Value: String);
    procedure Set_Dat_prij(Value: String);
    procedure Set_Dat_odmit(Value: String);
    { Methods & Properties }
    property Uuid_zpravy: String read Get_Uuid_zpravy write Set_Uuid_zpravy;
    property Bkp: String read Get_Bkp write Set_Bkp;
    property Dat_prij: String read Get_Dat_prij write Set_Dat_prij;
    property Dat_odmit: String read Get_Dat_odmit write Set_Dat_odmit;
  end;

{ IXMLOdpovedPotvrzeniType }

  IXMLOdpovedPotvrzeniType = interface(IXMLNode)
    ['{87E0D095-87EA-48E1-9F81-392A829354DB}']
    { Property Accessors }
    function Get_Fik: String;
    function Get_Test: Boolean;
    procedure Set_Fik(Value: String);
    procedure Set_Test(Value: Boolean);
    { Methods & Properties }
    property Fik: String read Get_Fik write Set_Fik;
    property Test: Boolean read Get_Test write Set_Test;
  end;

{ IXMLOdpovedChybaType }

  IXMLOdpovedChybaType = interface(IXMLNode)
    ['{41F66ED5-9B24-46F9-A75C-0B0F7F2AA39B}']
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
    ['{2FFBA433-913F-4342-B9E0-43C2CD46C557}']
    { Property Accessors }
    function Get_Kod_varov: Integer;
    procedure Set_Kod_varov(Value: Integer);
    { Methods & Properties }
    property Kod_varov: Integer read Get_Kod_varov write Set_Kod_varov;
  end;

{ IXMLOdpovedVarovaniTypeList }

  IXMLOdpovedVarovaniTypeList = interface(IXMLNodeCollection)
    ['{BB39FDED-E1C4-4349-8908-1416028D7912}']
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
    function Get_Uuid_zpravy: String;
    function Get_Dat_odesl: String;
    function Get_Prvni_zaslani: Boolean;
    function Get_Overeni: Boolean;
    procedure Set_Uuid_zpravy(Value: String);
    procedure Set_Dat_odesl(Value: String);
    procedure Set_Prvni_zaslani(Value: Boolean);
    procedure Set_Overeni(Value: Boolean);
  end;

{ TXMLTrzbaDataType }

  TXMLTrzbaDataType = class(TXMLNode, IXMLTrzbaDataType)
  protected
    { IXMLTrzbaDataType }
    function Get_Dic_popl: String;
    function Get_Dic_poverujiciho: String;
    function Get_Id_provoz: Integer;
    function Get_Id_pokl: String;
    function Get_Porad_cis: String;
    function Get_Dat_trzby: String;
    function Get_Celk_trzba: String;
    function Get_Zakl_nepodl_dph: String;
    function Get_Zakl_dan1: String;
    function Get_Dan1: String;
    function Get_Zakl_dan2: String;
    function Get_Dan2: String;
    function Get_Zakl_dan3: String;
    function Get_Dan3: String;
    function Get_Cest_sluz: String;
    function Get_Pouzit_zboz1: String;
    function Get_Pouzit_zboz2: String;
    function Get_Pouzit_zboz3: String;
    function Get_Urceno_cerp_zuct: String;
    function Get_Cerp_zuct: String;
    function Get_Rezim: Integer;
    procedure Set_Dic_popl(Value: String);
    procedure Set_Dic_poverujiciho(Value: String);
    procedure Set_Id_provoz(Value: Integer);
    procedure Set_Id_pokl(Value: String);
    procedure Set_Porad_cis(Value: String);
    procedure Set_Dat_trzby(Value: String);
    procedure Set_Celk_trzba(Value: String);
    procedure Set_Zakl_nepodl_dph(Value: String);
    procedure Set_Zakl_dan1(Value: String);
    procedure Set_Dan1(Value: String);
    procedure Set_Zakl_dan2(Value: String);
    procedure Set_Dan2(Value: String);
    procedure Set_Zakl_dan3(Value: String);
    procedure Set_Dan3(Value: String);
    procedure Set_Cest_sluz(Value: String);
    procedure Set_Pouzit_zboz1(Value: String);
    procedure Set_Pouzit_zboz2(Value: String);
    procedure Set_Pouzit_zboz3(Value: String);
    procedure Set_Urceno_cerp_zuct(Value: String);
    procedure Set_Cerp_zuct(Value: String);
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
    function Get_Digest: String;
    function Get_Cipher: String;
    function Get_Encoding: String;
    procedure Set_Digest(Value: String);
    procedure Set_Cipher(Value: String);
    procedure Set_Encoding(Value: String);
  end;

{ TXMLBkpElementType }

  TXMLBkpElementType = class(TXMLNode, IXMLBkpElementType)
  protected
    { IXMLBkpElementType }
    function Get_Digest: String;
    function Get_Encoding: String;
    procedure Set_Digest(Value: String);
    procedure Set_Encoding(Value: String);
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
    function Get_Bkp: String;
    function Get_Dat_prij: String;
    function Get_Dat_odmit: String;
    procedure Set_Uuid_zpravy(Value: String);
    procedure Set_Bkp(Value: String);
    procedure Set_Dat_prij(Value: String);
    procedure Set_Dat_odmit(Value: String);
  end;

{ TXMLOdpovedPotvrzeniType }

  TXMLOdpovedPotvrzeniType = class(TXMLNode, IXMLOdpovedPotvrzeniType)
  protected
    { IXMLOdpovedPotvrzeniType }
    function Get_Fik: String;
    function Get_Test: Boolean;
    procedure Set_Fik(Value: String);
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

function GetTrzba(Doc: IXMLDocument): IXMLTrzbaType;
function LoadTrzba(const FileName: string): IXMLTrzbaType;
function NewTrzba: IXMLTrzbaType;

const
  TargetNamespace = 'http://fs.mfcr.cz/eet/schema/v3';

implementation

uses xmlutil;

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

function TXMLTrzbaHlavickaType.Get_Uuid_zpravy: String;
begin
  Result := AttributeNodes['uuid_zpravy'].Text;
end;

procedure TXMLTrzbaHlavickaType.Set_Uuid_zpravy(Value: String);
begin
  SetAttribute('uuid_zpravy', Value);
end;

function TXMLTrzbaHlavickaType.Get_Dat_odesl: String;
begin
  Result := AttributeNodes['dat_odesl'].Text;
end;

procedure TXMLTrzbaHlavickaType.Set_Dat_odesl(Value: String);
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

function TXMLTrzbaDataType.Get_Dic_popl: String;
begin
  Result := AttributeNodes['dic_popl'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dic_popl(Value: String);
begin
  SetAttribute('dic_popl', Value);
end;

function TXMLTrzbaDataType.Get_Dic_poverujiciho: String;
begin
  Result := AttributeNodes['dic_poverujiciho'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dic_poverujiciho(Value: String);
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

function TXMLTrzbaDataType.Get_Id_pokl: String;
begin
  Result := AttributeNodes['id_pokl'].Text;
end;

procedure TXMLTrzbaDataType.Set_Id_pokl(Value: String);
begin
  SetAttribute('id_pokl', Value);
end;

function TXMLTrzbaDataType.Get_Porad_cis: String;
begin
  Result := AttributeNodes['porad_cis'].Text;
end;

procedure TXMLTrzbaDataType.Set_Porad_cis(Value: String);
begin
  SetAttribute('porad_cis', Value);
end;

function TXMLTrzbaDataType.Get_Dat_trzby: String;
begin
  Result := AttributeNodes['dat_trzby'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dat_trzby(Value: String);
begin
  SetAttribute('dat_trzby', Value);
end;

function TXMLTrzbaDataType.Get_Celk_trzba: String;
begin
  Result := AttributeNodes['celk_trzba'].Text;
end;

procedure TXMLTrzbaDataType.Set_Celk_trzba(Value: String);
begin
  SetAttribute('celk_trzba', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_nepodl_dph: String;
begin
  Result := AttributeNodes['zakl_nepodl_dph'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_nepodl_dph(Value: String);
begin
  SetAttribute('zakl_nepodl_dph', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_dan1: String;
begin
  Result := AttributeNodes['zakl_dan1'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_dan1(Value: String);
begin
  SetAttribute('zakl_dan1', Value);
end;

function TXMLTrzbaDataType.Get_Dan1: String;
begin
  Result := AttributeNodes['dan1'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dan1(Value: String);
begin
  SetAttribute('dan1', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_dan2: String;
begin
  Result := AttributeNodes['zakl_dan2'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_dan2(Value: String);
begin
  SetAttribute('zakl_dan2', Value);
end;

function TXMLTrzbaDataType.Get_Dan2: String;
begin
  Result := AttributeNodes['dan2'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dan2(Value: String);
begin
  SetAttribute('dan2', Value);
end;

function TXMLTrzbaDataType.Get_Zakl_dan3: String;
begin
  Result := AttributeNodes['zakl_dan3'].Text;
end;

procedure TXMLTrzbaDataType.Set_Zakl_dan3(Value: String);
begin
  SetAttribute('zakl_dan3', Value);
end;

function TXMLTrzbaDataType.Get_Dan3: String;
begin
  Result := AttributeNodes['dan3'].Text;
end;

procedure TXMLTrzbaDataType.Set_Dan3(Value: String);
begin
  SetAttribute('dan3', Value);
end;

function TXMLTrzbaDataType.Get_Cest_sluz: String;
begin
  Result := AttributeNodes['cest_sluz'].Text;
end;

procedure TXMLTrzbaDataType.Set_Cest_sluz(Value: String);
begin
  SetAttribute('cest_sluz', Value);
end;

function TXMLTrzbaDataType.Get_Pouzit_zboz1: String;
begin
  Result := AttributeNodes['pouzit_zboz1'].Text;
end;

procedure TXMLTrzbaDataType.Set_Pouzit_zboz1(Value: String);
begin
  SetAttribute('pouzit_zboz1', Value);
end;

function TXMLTrzbaDataType.Get_Pouzit_zboz2: String;
begin
  Result := AttributeNodes['pouzit_zboz2'].Text;
end;

procedure TXMLTrzbaDataType.Set_Pouzit_zboz2(Value: String);
begin
  SetAttribute('pouzit_zboz2', Value);
end;

function TXMLTrzbaDataType.Get_Pouzit_zboz3: String;
begin
  Result := AttributeNodes['pouzit_zboz3'].Text;
end;

procedure TXMLTrzbaDataType.Set_Pouzit_zboz3(Value: String);
begin
  SetAttribute('pouzit_zboz3', Value);
end;

function TXMLTrzbaDataType.Get_Urceno_cerp_zuct: String;
begin
  Result := AttributeNodes['urceno_cerp_zuct'].Text;
end;

procedure TXMLTrzbaDataType.Set_Urceno_cerp_zuct(Value: String);
begin
  SetAttribute('urceno_cerp_zuct', Value);
end;

function TXMLTrzbaDataType.Get_Cerp_zuct: String;
begin
  Result := AttributeNodes['cerp_zuct'].Text;
end;

procedure TXMLTrzbaDataType.Set_Cerp_zuct(Value: String);
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

function TXMLPkpElementType.Get_Digest: String;
begin
  Result := AttributeNodes['digest'].Text;
end;

procedure TXMLPkpElementType.Set_Digest(Value: String);
begin
  SetAttribute('digest', Value);
end;

function TXMLPkpElementType.Get_Cipher: String;
begin
  Result := AttributeNodes['cipher'].Text;
end;

procedure TXMLPkpElementType.Set_Cipher(Value: String);
begin
  SetAttribute('cipher', Value);
end;

function TXMLPkpElementType.Get_Encoding: String;
begin
  Result := AttributeNodes['encoding'].Text;
end;

procedure TXMLPkpElementType.Set_Encoding(Value: String);
begin
  SetAttribute('encoding', Value);
end;

{ TXMLBkpElementType }

function TXMLBkpElementType.Get_Digest: String;
begin
  Result := AttributeNodes['digest'].Text;
end;

procedure TXMLBkpElementType.Set_Digest(Value: String);
begin
  SetAttribute('digest', Value);
end;

function TXMLBkpElementType.Get_Encoding: String;
begin
  Result := AttributeNodes['encoding'].Text;
end;

procedure TXMLBkpElementType.Set_Encoding(Value: String);
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

function TXMLOdpovedHlavickaType.Get_Uuid_zpravy: String;
begin
  Result := AttributeNodes['uuid_zpravy'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Uuid_zpravy(Value: String);
begin
  SetAttribute('uuid_zpravy', Value);
end;

function TXMLOdpovedHlavickaType.Get_Bkp: String;
begin
  Result := AttributeNodes['bkp'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Bkp(Value: String);
begin
  SetAttribute('bkp', Value);
end;

function TXMLOdpovedHlavickaType.Get_Dat_prij: String;
begin
  Result := AttributeNodes['dat_prij'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Dat_prij(Value: String);
begin
  SetAttribute('dat_prij', Value);
end;

function TXMLOdpovedHlavickaType.Get_Dat_odmit: String;
begin
  Result := AttributeNodes['dat_odmit'].Text;
end;

procedure TXMLOdpovedHlavickaType.Set_Dat_odmit(Value: String);
begin
  SetAttribute('dat_odmit', Value);
end;

{ TXMLOdpovedPotvrzeniType }

function TXMLOdpovedPotvrzeniType.Get_Fik: String;
begin
  Result := AttributeNodes['fik'].Text;
end;

procedure TXMLOdpovedPotvrzeniType.Set_Fik(Value: String);
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