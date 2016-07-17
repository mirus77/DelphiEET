
{***************************************************************************************************************}
{                                                                                                               }
{                                               XML Data Binding                                                }
{                                                                                                               }
{         Generated on: 2. 7. 2016 16:35:17                                                                     }
{       Generated from: L:\Data\owncloud\documentsPPK\EET\verze 2\oasis-200401-wss-wssecurity-utility-1.0.xsd   }
{   Settings stored in: L:\Data\owncloud\documentsPPK\EET\verze 2\oasis-200401-wss-wssecurity-utility-1.0.xdb   }
{                                                                                                               }
{***************************************************************************************************************}

unit WSSE_utils;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLTimestampType = interface;
  IXMLAttributedDateTime = interface;
  IXMLAttributedURI = interface;

{ IXMLTimestampType }

  IXMLTimestampType = interface(IXMLNode)
    ['{7253A9F2-CA9A-41E7-ACC8-D076FE2AD7E5}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_Created: IXMLAttributedDateTime;
    function Get_Expires: IXMLAttributedDateTime;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property Created: IXMLAttributedDateTime read Get_Created;
    property Expires: IXMLAttributedDateTime read Get_Expires;
  end;

{ IXMLAttributedDateTime }

  IXMLAttributedDateTime = interface(IXMLNode)
    ['{FDDA5B01-928E-4064-A0A5-91E06EA1A633}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
  end;

{ IXMLAttributedURI }

  IXMLAttributedURI = interface(IXMLNode)
    ['{0E6EA59F-0DB6-47A1-BAC8-1D803896EF2A}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
  end;

{ Forward Decls }

  TXMLTimestampType = class;
  TXMLAttributedDateTime = class;
  TXMLAttributedURI = class;

{ TXMLTimestampType }

  TXMLTimestampType = class(TXMLNode, IXMLTimestampType)
  protected
    { IXMLTimestampType }
    function Get_Id: UnicodeString;
    function Get_Created: IXMLAttributedDateTime;
    function Get_Expires: IXMLAttributedDateTime;
    procedure Set_Id(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAttributedDateTime }

  TXMLAttributedDateTime = class(TXMLNode, IXMLAttributedDateTime)
  protected
    { IXMLAttributedDateTime }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
  end;

{ TXMLAttributedURI }

  TXMLAttributedURI = class(TXMLNode, IXMLAttributedURI)
  protected
    { IXMLAttributedURI }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
  end;

{ Global Functions }

function GetTimestamp(Doc: IXMLDocument): IXMLTimestampType;
function LoadTimestamp(const FileName: string): IXMLTimestampType;
function NewTimestamp: IXMLTimestampType;

const
  WSSETargetNamespaceUtility = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';

implementation

{ Global Functions }

function GetTimestamp(Doc: IXMLDocument): IXMLTimestampType;
begin
  Result := Doc.GetDocBinding('Timestamp', TXMLTimestampType, WSSETargetNamespaceUtility) as IXMLTimestampType;
end;

function LoadTimestamp(const FileName: string): IXMLTimestampType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Timestamp', TXMLTimestampType, WSSETargetNamespaceUtility) as IXMLTimestampType;
end;

function NewTimestamp: IXMLTimestampType;
begin
  Result := NewXMLDocument.GetDocBinding('Timestamp', TXMLTimestampType, WSSETargetNamespaceUtility) as IXMLTimestampType;
end;

{ TXMLTimestampType }

procedure TXMLTimestampType.AfterConstruction;
begin
  RegisterChildNode('Created', TXMLAttributedDateTime);
  RegisterChildNode('Expires', TXMLAttributedDateTime);
  inherited;
end;

function TXMLTimestampType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLTimestampType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLTimestampType.Get_Created: IXMLAttributedDateTime;
begin
  Result := ChildNodes['Created'] as IXMLAttributedDateTime;
end;

function TXMLTimestampType.Get_Expires: IXMLAttributedDateTime;
begin
  Result := ChildNodes['Expires'] as IXMLAttributedDateTime;
end;

{ TXMLAttributedDateTime }

function TXMLAttributedDateTime.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLAttributedDateTime.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

{ TXMLAttributedURI }

function TXMLAttributedURI.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLAttributedURI.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

end.