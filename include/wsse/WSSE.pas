
{**************************************************************************************************************}
{                                                                                                              }
{                                               XML Data Binding                                               }
{                                                                                                              }
{         Generated on: 2. 7. 2016 16:36:46                                                                    }
{       Generated from: L:\Data\owncloud\documentsPPK\EET\verze 2\oasis-200401-wss-wssecurity-secext-1.0.xsd   }
{   Settings stored in: L:\Data\owncloud\documentsPPK\EET\verze 2\oasis-200401-wss-wssecurity-secext-1.0.xdb   }
{                                                                                                              }
{**************************************************************************************************************}

unit wsse;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLUsernameTokenType = interface;
  IXMLAttributedString = interface;
  IXMLBinarySecurityTokenType = interface;
  IXMLReferenceType = interface;
  IXMLEmbeddedType = interface;
  IXMLKeyIdentifierType = interface;
  IXMLSecurityTokenReferenceType = interface;
  IXMLSecurityHeaderType = interface;
  IXMLTransformationParametersType = interface;
  IXMLPasswordString = interface;
  IXMLEncodedString = interface;

{ IXMLUsernameTokenType }

  IXMLUsernameTokenType = interface(IXMLNode)
    ['{0D280DD3-A7BB-42A1-A1D4-81577F338241}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_Username: IXMLAttributedString;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property Username: IXMLAttributedString read Get_Username;
  end;

{ IXMLAttributedString }

  IXMLAttributedString = interface(IXMLNode)
    ['{42687C2A-DB0F-48CE-A6CC-A42BB61F59F0}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
  end;

{ IXMLBinarySecurityTokenType }

  IXMLBinarySecurityTokenType = interface(IXMLNode)
    ['{61B14EA0-BEE8-4D7A-9DA3-305E0522647F}']
    { Property Accessors }
    function Get_ValueType: UnicodeString;
    function Get_EncodingType: UnicodeString;
    procedure Set_ValueType(Value: UnicodeString);
    procedure Set_EncodingType(Value: UnicodeString);
    { Methods & Properties }
    property ValueType: UnicodeString read Get_ValueType write Set_ValueType;
    property EncodingType: UnicodeString read Get_EncodingType write Set_EncodingType;
  end;

{ IXMLReferenceType }

  IXMLReferenceType = interface(IXMLNode)
    ['{C35E741A-DA8C-4F08-A33B-E03F3D36ED03}']
    { Property Accessors }
    function Get_URI: UnicodeString;
    function Get_ValueType: UnicodeString;
    procedure Set_URI(Value: UnicodeString);
    procedure Set_ValueType(Value: UnicodeString);
    { Methods & Properties }
    property URI: UnicodeString read Get_URI write Set_URI;
    property ValueType: UnicodeString read Get_ValueType write Set_ValueType;
  end;

{ IXMLEmbeddedType }

  IXMLEmbeddedType = interface(IXMLNode)
    ['{5904C15C-D529-4AE1-B8B8-2AD9BF2A81A7}']
    { Property Accessors }
    function Get_ValueType: UnicodeString;
    procedure Set_ValueType(Value: UnicodeString);
    { Methods & Properties }
    property ValueType: UnicodeString read Get_ValueType write Set_ValueType;
  end;

{ IXMLKeyIdentifierType }

  IXMLKeyIdentifierType = interface(IXMLNode)
    ['{EDC345F7-2738-4C57-811D-EF27F024548C}']
    { Property Accessors }
    function Get_ValueType: UnicodeString;
    procedure Set_ValueType(Value: UnicodeString);
    { Methods & Properties }
    property ValueType: UnicodeString read Get_ValueType write Set_ValueType;
  end;

{ IXMLSecurityTokenReferenceType }

  IXMLSecurityTokenReferenceType = interface(IXMLNode)
    ['{FC9FBC51-44CB-4F4D-8550-905B83760031}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_Usage: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_Usage(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property Usage: UnicodeString read Get_Usage write Set_Usage;
  end;

{ IXMLSecurityHeaderType }

  IXMLSecurityHeaderType = interface(IXMLNode)
    ['{4D536CF6-110D-4D44-BC4C-C4CA5FA23385}']
    { Property Accessors }
    function Get_BinarySecurityToken : IXMLBinarySecurityTokenType;
    { Methods & Properties }
    property BinarySecurityToken: IXMLBinarySecurityTokenType read Get_BinarySecurityToken;
  end;

{ IXMLTransformationParametersType }

  IXMLTransformationParametersType = interface(IXMLNode)
    ['{DF12E7B7-C3FC-4CBD-B922-95076239931B}']
  end;

{ IXMLPasswordString }

  IXMLPasswordString = interface(IXMLNode)
    ['{8EAC6537-CC94-4BE1-9396-9100A6148AAB}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
  end;

{ IXMLEncodedString }

  IXMLEncodedString = interface(IXMLNode)
    ['{4A1FBB2E-7E6B-4BF6-BB06-B8293BB3771D}']
    { Property Accessors }
    function Get_EncodingType: UnicodeString;
    procedure Set_EncodingType(Value: UnicodeString);
    { Methods & Properties }
    property EncodingType: UnicodeString read Get_EncodingType write Set_EncodingType;
  end;

{ Forward Decls }

  TXMLUsernameTokenType = class;
  TXMLAttributedString = class;
  TXMLBinarySecurityTokenType = class;
  TXMLReferenceType = class;
  TXMLEmbeddedType = class;
  TXMLKeyIdentifierType = class;
  TXMLSecurityTokenReferenceType = class;
  TXMLSecurityHeaderType = class;
  TXMLTransformationParametersType = class;
  TXMLPasswordString = class;
  TXMLEncodedString = class;

{ TXMLUsernameTokenType }

  TXMLUsernameTokenType = class(TXMLNode, IXMLUsernameTokenType)
  protected
    { IXMLUsernameTokenType }
    function Get_Id: UnicodeString;
    function Get_Username: IXMLAttributedString;
    procedure Set_Id(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAttributedString }

  TXMLAttributedString = class(TXMLNode, IXMLAttributedString)
  protected
    { IXMLAttributedString }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
  end;

{ TXMLBinarySecurityTokenType }

  TXMLBinarySecurityTokenType = class(TXMLNode, IXMLBinarySecurityTokenType)
  protected
    { IXMLBinarySecurityTokenType }
    function Get_ValueType: UnicodeString;
    function Get_EncodingType: UnicodeString;
    procedure Set_ValueType(Value: UnicodeString);
    procedure Set_EncodingType(Value: UnicodeString);
  end;

{ TXMLReferenceType }

  TXMLReferenceType = class(TXMLNode, IXMLReferenceType)
  protected
    { IXMLReferenceType }
    function Get_URI: UnicodeString;
    function Get_ValueType: UnicodeString;
    procedure Set_URI(Value: UnicodeString);
    procedure Set_ValueType(Value: UnicodeString);
  end;

{ TXMLEmbeddedType }

  TXMLEmbeddedType = class(TXMLNode, IXMLEmbeddedType)
  protected
    { IXMLEmbeddedType }
    function Get_ValueType: UnicodeString;
    procedure Set_ValueType(Value: UnicodeString);
  end;

{ TXMLKeyIdentifierType }

  TXMLKeyIdentifierType = class(TXMLNode, IXMLKeyIdentifierType)
  protected
    { IXMLKeyIdentifierType }
    function Get_ValueType: UnicodeString;
    procedure Set_ValueType(Value: UnicodeString);
  end;

{ TXMLSecurityTokenReferenceType }

  TXMLSecurityTokenReferenceType = class(TXMLNode, IXMLSecurityTokenReferenceType)
  protected
    { IXMLSecurityTokenReferenceType }
    function Get_Id: UnicodeString;
    function Get_Usage: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_Usage(Value: UnicodeString);
  end;

{ TXMLSecurityHeaderType }

  TXMLSecurityHeaderType = class(TXMLNode, IXMLSecurityHeaderType)
  protected
    { IXMLSecurityHeaderType }
    function Get_BinarySecurityToken: IXMLBinarySecurityTokenType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTransformationParametersType }

  TXMLTransformationParametersType = class(TXMLNode, IXMLTransformationParametersType)
  protected
    { IXMLTransformationParametersType }
  end;

{ TXMLPasswordString }

  TXMLPasswordString = class(TXMLNode, IXMLPasswordString)
  protected
    { IXMLPasswordString }
    function Get_Type_: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
  end;

{ TXMLEncodedString }

  TXMLEncodedString = class(TXMLNode, IXMLEncodedString)
  protected
    { IXMLEncodedString }
    function Get_EncodingType: UnicodeString;
    procedure Set_EncodingType(Value: UnicodeString);
  end;

{ Global Functions }

function GetUsernameToken(Doc: IXMLDocument): IXMLUsernameTokenType;
function LoadUsernameToken(const FileName: string): IXMLUsernameTokenType;
function NewUsernameToken: IXMLUsernameTokenType;
function GetBinarySecurityToken(Doc: IXMLDocument): IXMLBinarySecurityTokenType;
function LoadBinarySecurityToken(const FileName: string): IXMLBinarySecurityTokenType;
function NewBinarySecurityToken: IXMLBinarySecurityTokenType;
function GetReference(Doc: IXMLDocument): IXMLReferenceType;
function LoadReference(const FileName: string): IXMLReferenceType;
function NewReference: IXMLReferenceType;
function GetEmbedded(Doc: IXMLDocument): IXMLEmbeddedType;
function LoadEmbedded(const FileName: string): IXMLEmbeddedType;
function NewEmbedded: IXMLEmbeddedType;
function GetKeyIdentifier(Doc: IXMLDocument): IXMLKeyIdentifierType;
function LoadKeyIdentifier(const FileName: string): IXMLKeyIdentifierType;
function NewKeyIdentifier: IXMLKeyIdentifierType;
function GetSecurityTokenReference(Doc: IXMLDocument): IXMLSecurityTokenReferenceType;
function LoadSecurityTokenReference(const FileName: string): IXMLSecurityTokenReferenceType;
function NewSecurityTokenReference: IXMLSecurityTokenReferenceType;
function GetSecurity(Doc: IXMLDocument): IXMLSecurityHeaderType;
function LoadSecurity(const FileName: string): IXMLSecurityHeaderType;
function NewSecurity: IXMLSecurityHeaderType;
function GetTransformationParameters(Doc: IXMLDocument): IXMLTransformationParametersType;
function LoadTransformationParameters(const FileName: string): IXMLTransformationParametersType;
function NewTransformationParameters: IXMLTransformationParametersType;
function GetPassword(Doc: IXMLDocument): IXMLPasswordString;
function LoadPassword(const FileName: string): IXMLPasswordString;
function NewPassword: IXMLPasswordString;
function GetNonce(Doc: IXMLDocument): IXMLEncodedString;
function LoadNonce(const FileName: string): IXMLEncodedString;
function NewNonce: IXMLEncodedString;

const
  WSSETargetNamespaceExt = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';

implementation

{ Global Functions }

uses WSSE_utils;

function GetUsernameToken(Doc: IXMLDocument): IXMLUsernameTokenType;
begin
  Result := Doc.GetDocBinding('UsernameToken', TXMLUsernameTokenType, WSSETargetNamespaceExt) as IXMLUsernameTokenType;
end;

function LoadUsernameToken(const FileName: string): IXMLUsernameTokenType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('UsernameToken', TXMLUsernameTokenType, WSSETargetNamespaceExt) as IXMLUsernameTokenType;
end;

function NewUsernameToken: IXMLUsernameTokenType;
begin
  Result := NewXMLDocument.GetDocBinding('UsernameToken', TXMLUsernameTokenType, WSSETargetNamespaceExt) as IXMLUsernameTokenType;
end;
function GetBinarySecurityToken(Doc: IXMLDocument): IXMLBinarySecurityTokenType;
begin
  Result := Doc.GetDocBinding('wsse:BinarySecurityToken', TXMLBinarySecurityTokenType, WSSETargetNamespaceExt) as IXMLBinarySecurityTokenType;
end;

function LoadBinarySecurityToken(const FileName: string): IXMLBinarySecurityTokenType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:BinarySecurityToken', TXMLBinarySecurityTokenType, WSSETargetNamespaceExt) as IXMLBinarySecurityTokenType;
end;

function NewBinarySecurityToken: IXMLBinarySecurityTokenType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:BinarySecurityToken', TXMLBinarySecurityTokenType, '' {WSSETargetNamespaceExt}) as IXMLBinarySecurityTokenType;
  Result.Attributes['EncodingType'] := 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
end;
function GetReference(Doc: IXMLDocument): IXMLReferenceType;
begin
  Result := Doc.GetDocBinding('wsse:Reference', TXMLReferenceType, WSSETargetNamespaceExt) as IXMLReferenceType;
end;

function LoadReference(const FileName: string): IXMLReferenceType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:Reference', TXMLReferenceType, WSSETargetNamespaceExt) as IXMLReferenceType;
end;

function NewReference: IXMLReferenceType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:Reference', TXMLReferenceType, WSSETargetNamespaceExt) as IXMLReferenceType;
end;
function GetEmbedded(Doc: IXMLDocument): IXMLEmbeddedType;
begin
  Result := Doc.GetDocBinding('wsse:Embedded', TXMLEmbeddedType, WSSETargetNamespaceExt) as IXMLEmbeddedType;
end;

function LoadEmbedded(const FileName: string): IXMLEmbeddedType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:Embedded', TXMLEmbeddedType, WSSETargetNamespaceExt) as IXMLEmbeddedType;
end;

function NewEmbedded: IXMLEmbeddedType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:Embedded', TXMLEmbeddedType, WSSETargetNamespaceExt) as IXMLEmbeddedType;
end;

function GetKeyIdentifier(Doc: IXMLDocument): IXMLKeyIdentifierType;
begin
  Result := Doc.GetDocBinding('wsse:KeyIdentifier', TXMLKeyIdentifierType, WSSETargetNamespaceExt) as IXMLKeyIdentifierType;
end;

function LoadKeyIdentifier(const FileName: string): IXMLKeyIdentifierType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:KeyIdentifier', TXMLKeyIdentifierType, WSSETargetNamespaceExt) as IXMLKeyIdentifierType;
end;

function NewKeyIdentifier: IXMLKeyIdentifierType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:KeyIdentifier', TXMLKeyIdentifierType, WSSETargetNamespaceExt) as IXMLKeyIdentifierType;
end;

function GetSecurityTokenReference(Doc: IXMLDocument): IXMLSecurityTokenReferenceType;
begin
  Result := Doc.GetDocBinding('wsse:SecurityTokenReference', TXMLSecurityTokenReferenceType, WSSETargetNamespaceExt) as IXMLSecurityTokenReferenceType;
end;

function LoadSecurityTokenReference(const FileName: string): IXMLSecurityTokenReferenceType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:SecurityTokenReference', TXMLSecurityTokenReferenceType, WSSETargetNamespaceExt) as IXMLSecurityTokenReferenceType;
end;

function NewSecurityTokenReference: IXMLSecurityTokenReferenceType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:SecurityTokenReference', TXMLSecurityTokenReferenceType, WSSETargetNamespaceExt) as IXMLSecurityTokenReferenceType;
  Result.DeclareNamespace('wsu',WSSETargetNamespaceUtility);
end;

function GetSecurity(Doc: IXMLDocument): IXMLSecurityHeaderType;
begin
  Result := Doc.GetDocBinding('wsse:Security', TXMLSecurityHeaderType, WSSETargetNamespaceExt) as IXMLSecurityHeaderType;
end;

function LoadSecurity(const FileName: string): IXMLSecurityHeaderType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:Security', TXMLSecurityHeaderType, WSSETargetNamespaceExt) as IXMLSecurityHeaderType;
end;

function NewSecurity: IXMLSecurityHeaderType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:Security', TXMLSecurityHeaderType, WSSETargetNamespaceExt) as IXMLSecurityHeaderType;
  Result.DeclareNamespace('wsu',WSSETargetNamespaceUtility);
end;

function GetTransformationParameters(Doc: IXMLDocument): IXMLTransformationParametersType;
begin
  Result := Doc.GetDocBinding('wsse:TransformationParameters', TXMLTransformationParametersType, WSSETargetNamespaceExt) as IXMLTransformationParametersType;
end;

function LoadTransformationParameters(const FileName: string): IXMLTransformationParametersType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:TransformationParameters', TXMLTransformationParametersType, WSSETargetNamespaceExt) as IXMLTransformationParametersType;
end;

function NewTransformationParameters: IXMLTransformationParametersType;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:TransformationParameters', TXMLTransformationParametersType, WSSETargetNamespaceExt) as IXMLTransformationParametersType;
end;

function GetPassword(Doc: IXMLDocument): IXMLPasswordString;
begin
  Result := Doc.GetDocBinding('wsse:Password', TXMLPasswordString, WSSETargetNamespaceExt) as IXMLPasswordString;
end;

function LoadPassword(const FileName: string): IXMLPasswordString;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:Password', TXMLPasswordString, WSSETargetNamespaceExt) as IXMLPasswordString;
end;

function NewPassword: IXMLPasswordString;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:Password', TXMLPasswordString, WSSETargetNamespaceExt) as IXMLPasswordString;
end;

function GetNonce(Doc: IXMLDocument): IXMLEncodedString;
begin
  Result := Doc.GetDocBinding('wsse:Nonce', TXMLEncodedString, WSSETargetNamespaceExt) as IXMLEncodedString;
end;

function LoadNonce(const FileName: string): IXMLEncodedString;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wsse:Nonce', TXMLEncodedString, WSSETargetNamespaceExt) as IXMLEncodedString;
end;

function NewNonce: IXMLEncodedString;
begin
  Result := NewXMLDocument.GetDocBinding('wsse:Nonce', TXMLEncodedString, WSSETargetNamespaceExt) as IXMLEncodedString;
end;

{ TXMLUsernameTokenType }

procedure TXMLUsernameTokenType.AfterConstruction;
begin
  RegisterChildNode('wsse:Username', TXMLAttributedString);
  inherited;
end;

function TXMLUsernameTokenType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLUsernameTokenType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLUsernameTokenType.Get_Username: IXMLAttributedString;
begin
  Result := ChildNodes['Username'] as IXMLAttributedString;
end;

{ TXMLAttributedString }

function TXMLAttributedString.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLAttributedString.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

{ TXMLBinarySecurityTokenType }

function TXMLBinarySecurityTokenType.Get_EncodingType: UnicodeString;
begin
  Result := AttributeNodes['EncodingType'].Text;
end;

function TXMLBinarySecurityTokenType.Get_ValueType: UnicodeString;
begin
  Result := AttributeNodes['ValueType'].Text;
end;

procedure TXMLBinarySecurityTokenType.Set_EncodingType(Value: UnicodeString);
begin
  SetAttribute('EncodingType', Value);
end;

procedure TXMLBinarySecurityTokenType.Set_ValueType(Value: UnicodeString);
begin
  SetAttribute('ValueType', Value);
end;

{ TXMLReferenceType }

function TXMLReferenceType.Get_URI: UnicodeString;
begin
  Result := AttributeNodes['URI'].Text;
end;

procedure TXMLReferenceType.Set_URI(Value: UnicodeString);
begin
  SetAttribute('URI', Value);
end;

function TXMLReferenceType.Get_ValueType: UnicodeString;
begin
  Result := AttributeNodes['ValueType'].Text;
end;

procedure TXMLReferenceType.Set_ValueType(Value: UnicodeString);
begin
  SetAttribute('ValueType', Value);
end;

{ TXMLEmbeddedType }

function TXMLEmbeddedType.Get_ValueType: UnicodeString;
begin
  Result := AttributeNodes['ValueType'].Text;
end;

procedure TXMLEmbeddedType.Set_ValueType(Value: UnicodeString);
begin
  SetAttribute('ValueType', Value);
end;

{ TXMLKeyIdentifierType }

function TXMLKeyIdentifierType.Get_ValueType: UnicodeString;
begin
  Result := AttributeNodes['ValueType'].Text;
end;

procedure TXMLKeyIdentifierType.Set_ValueType(Value: UnicodeString);
begin
  SetAttribute('ValueType', Value);
end;

{ TXMLSecurityTokenReferenceType }

function TXMLSecurityTokenReferenceType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLSecurityTokenReferenceType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLSecurityTokenReferenceType.Get_Usage: UnicodeString;
begin
  Result := AttributeNodes['Usage'].Text;
end;

procedure TXMLSecurityTokenReferenceType.Set_Usage(Value: UnicodeString);
begin
  SetAttribute('Usage', Value);
end;

{ TXMLSecurityHeaderType }

{ TXMLTransformationParametersType }

{ TXMLPasswordString }

function TXMLPasswordString.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPasswordString.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

{ TXMLEncodedString }

function TXMLEncodedString.Get_EncodingType: UnicodeString;
begin
  Result := AttributeNodes['EncodingType'].Text;
end;

procedure TXMLEncodedString.Set_EncodingType(Value: UnicodeString);
begin
  SetAttribute('EncodingType', Value);
end;

{ TXMLSecurityHeaderType }

procedure TXMLSecurityHeaderType.AfterConstruction;
begin
  RegisterChildNode('BinarySecurityToken', TXMLBinarySecurityTokenType);
  inherited;
end;

function TXMLSecurityHeaderType.Get_BinarySecurityToken: IXMLBinarySecurityTokenType;
begin
  Result := ChildNodes['BinarySecurityToken'] as IXMLBinarySecurityTokenType;
end;

end.