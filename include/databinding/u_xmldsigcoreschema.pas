
{*******************************************************************************************}
{                                                                                           }
{                                     XML Data Binding                                      }
{                                                                                           }
{         Generated on: 2. 7. 2016 17:09:23                                                 }
{       Generated from: xmldsig-core-schema.xsd   }
{   Settings stored in: xmldsig-core-schema.xdb   }
{                                                                                           }
{*******************************************************************************************}

unit u_xmldsigcoreschema;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLSignatureType = interface;
  IXMLSignedInfoType = interface;
  IXMLCanonicalizationMethodType = interface;
  IXMLSignatureMethodType = interface;
  IXMLReferenceType = interface;
  IXMLReferenceTypeList = interface;
  IXMLTransformsType = interface;
  IXMLTransformType = interface;
  IXMLDigestMethodType = interface;
  IXMLSignatureValueType = interface;
  IXMLKeyInfoType = interface;
  IXMLKeyValueType = interface;
  IXMLKeyValueTypeList = interface;
  IXMLDSAKeyValueType = interface;
  IXMLRSAKeyValueType = interface;
  IXMLRetrievalMethodType = interface;
  IXMLRetrievalMethodTypeList = interface;
  IXMLX509DataType = interface;
  IXMLX509DataTypeList = interface;
  IXMLX509IssuerSerialType = interface;
  IXMLX509IssuerSerialTypeList = interface;
  IXMLPGPDataType = interface;
  IXMLPGPDataTypeList = interface;
  IXMLSPKIDataType = interface;
  IXMLSPKIDataTypeList = interface;
  IXMLObjectType = interface;
  IXMLObjectTypeList = interface;
  IXMLManifestType = interface;
  IXMLSignaturePropertiesType = interface;
  IXMLSignaturePropertyType = interface;
  IXMLString_List = interface;
  IXMLBase64BinaryList = interface;

{ IXMLSignatureType }

  IXMLSignatureType = interface(IXMLNode)
    ['{E07BCC9E-52D9-444F-AEFA-24422B670C2C}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_SignedInfo: IXMLSignedInfoType;
    function Get_SignatureValue: IXMLSignatureValueType;
    function Get_KeyInfo: IXMLKeyInfoType;
    function Get_Object_: IXMLObjectTypeList;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property SignedInfo: IXMLSignedInfoType read Get_SignedInfo;
    property SignatureValue: IXMLSignatureValueType read Get_SignatureValue;
    property KeyInfo: IXMLKeyInfoType read Get_KeyInfo;
    property Object_: IXMLObjectTypeList read Get_Object_;
  end;

{ IXMLSignedInfoType }

  IXMLSignedInfoType = interface(IXMLNode)
    ['{06320445-8658-4DBE-AF41-439C68D77527}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_CanonicalizationMethod: IXMLCanonicalizationMethodType;
    function Get_SignatureMethod: IXMLSignatureMethodType;
    function Get_Reference: IXMLReferenceTypeList;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property CanonicalizationMethod: IXMLCanonicalizationMethodType read Get_CanonicalizationMethod;
    property SignatureMethod: IXMLSignatureMethodType read Get_SignatureMethod;
    property Reference: IXMLReferenceTypeList read Get_Reference;
  end;

{ IXMLCanonicalizationMethodType }

  IXMLCanonicalizationMethodType = interface(IXMLNode)
    ['{66EA02B5-AF83-46C4-ACB7-A715037F0260}']
    { Property Accessors }
    function Get_Algorithm: UnicodeString;
    procedure Set_Algorithm(Value: UnicodeString);
    { Methods & Properties }
    property Algorithm: UnicodeString read Get_Algorithm write Set_Algorithm;
  end;

{ IXMLSignatureMethodType }

  IXMLSignatureMethodType = interface(IXMLNode)
    ['{164029D8-FE5C-44C1-A0EC-1AECEBD4173D}']
    { Property Accessors }
    function Get_Algorithm: UnicodeString;
    function Get_HMACOutputLength: Integer;
    procedure Set_Algorithm(Value: UnicodeString);
    procedure Set_HMACOutputLength(Value: Integer);
    { Methods & Properties }
    property Algorithm: UnicodeString read Get_Algorithm write Set_Algorithm;
    property HMACOutputLength: Integer read Get_HMACOutputLength write Set_HMACOutputLength;
  end;

{ IXMLReferenceType }

  IXMLReferenceType = interface(IXMLNode)
    ['{4488F6A9-0AB0-4C92-BC83-B495DCDB8BC0}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_URI: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Transforms: IXMLTransformsType;
    function Get_DigestMethod: IXMLDigestMethodType;
    function Get_DigestValue: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_URI(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_DigestValue(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property URI: UnicodeString read Get_URI write Set_URI;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Transforms: IXMLTransformsType read Get_Transforms;
    property DigestMethod: IXMLDigestMethodType read Get_DigestMethod;
    property DigestValue: UnicodeString read Get_DigestValue write Set_DigestValue;
  end;

{ IXMLReferenceTypeList }

  IXMLReferenceTypeList = interface(IXMLNodeCollection)
    ['{F0F82BE0-2D5F-4CED-A887-E71E0CF6DD2E}']
    { Methods & Properties }
    function Add: IXMLReferenceType;
    function Insert(const Index: Integer): IXMLReferenceType;

    function Get_Item(Index: Integer): IXMLReferenceType;
    property Items[Index: Integer]: IXMLReferenceType read Get_Item; default;
  end;

{ IXMLTransformsType }

  IXMLTransformsType = interface(IXMLNodeCollection)
    ['{019D3AF9-6BAB-4B97-9E39-C59BEF1E72C7}']
    { Property Accessors }
    function Get_Transform(Index: Integer): IXMLTransformType;
    { Methods & Properties }
    function Add: IXMLTransformType;
    function Insert(const Index: Integer): IXMLTransformType;
    property Transform[Index: Integer]: IXMLTransformType read Get_Transform; default;
  end;

{ IXMLTransformType }

  IXMLTransformType = interface(IXMLNodeCollection)
    ['{EEECD9B1-91A8-4C13-B0B3-0D17AC93DDCF}']
    { Property Accessors }
    function Get_Algorithm: UnicodeString;
    function Get_XPath(Index: Integer): UnicodeString;
    procedure Set_Algorithm(Value: UnicodeString);
    { Methods & Properties }
    function Add(const XPath: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const XPath: UnicodeString): IXMLNode;
    property Algorithm: UnicodeString read Get_Algorithm write Set_Algorithm;
    property XPath[Index: Integer]: UnicodeString read Get_XPath; default;
  end;

{ IXMLDigestMethodType }

  IXMLDigestMethodType = interface(IXMLNode)
    ['{73576EB8-A32E-4C49-A8FE-B757F987D4A9}']
    { Property Accessors }
    function Get_Algorithm: UnicodeString;
    procedure Set_Algorithm(Value: UnicodeString);
    { Methods & Properties }
    property Algorithm: UnicodeString read Get_Algorithm write Set_Algorithm;
  end;

{ IXMLSignatureValueType }

  IXMLSignatureValueType = interface(IXMLNode)
    ['{93E4E1F9-2400-4F62-B5C5-456AA4942B23}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
  end;

{ IXMLKeyInfoType }

  IXMLKeyInfoType = interface(IXMLNode)
    ['{6B9248B2-6DE8-487E-88D2-F69EB227DD47}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_KeyName: IXMLString_List;
    function Get_KeyValue: IXMLKeyValueTypeList;
    function Get_RetrievalMethod: IXMLRetrievalMethodTypeList;
    function Get_X509Data: IXMLX509DataTypeList;
    function Get_PGPData: IXMLPGPDataTypeList;
    function Get_SPKIData: IXMLSPKIDataTypeList;
    function Get_MgmtData: IXMLString_List;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property KeyName: IXMLString_List read Get_KeyName;
    property KeyValue: IXMLKeyValueTypeList read Get_KeyValue;
    property RetrievalMethod: IXMLRetrievalMethodTypeList read Get_RetrievalMethod;
    property X509Data: IXMLX509DataTypeList read Get_X509Data;
    property PGPData: IXMLPGPDataTypeList read Get_PGPData;
    property SPKIData: IXMLSPKIDataTypeList read Get_SPKIData;
    property MgmtData: IXMLString_List read Get_MgmtData;
  end;

{ IXMLKeyValueType }

  IXMLKeyValueType = interface(IXMLNode)
    ['{B3AABFC3-7078-4EA3-AC3A-47AD5764D197}']
    { Property Accessors }
    function Get_DSAKeyValue: IXMLDSAKeyValueType;
    function Get_RSAKeyValue: IXMLRSAKeyValueType;
    { Methods & Properties }
    property DSAKeyValue: IXMLDSAKeyValueType read Get_DSAKeyValue;
    property RSAKeyValue: IXMLRSAKeyValueType read Get_RSAKeyValue;
  end;

{ IXMLKeyValueTypeList }

  IXMLKeyValueTypeList = interface(IXMLNodeCollection)
    ['{B2DDBCF6-9888-4E1D-AEFA-00E84D26BF53}']
    { Methods & Properties }
    function Add: IXMLKeyValueType;
    function Insert(const Index: Integer): IXMLKeyValueType;

    function Get_Item(Index: Integer): IXMLKeyValueType;
    property Items[Index: Integer]: IXMLKeyValueType read Get_Item; default;
  end;

{ IXMLDSAKeyValueType }

  IXMLDSAKeyValueType = interface(IXMLNode)
    ['{4AE5FAD5-DDA2-4537-88BE-BFE72F8319AC}']
    { Property Accessors }
    function Get_P: UnicodeString;
    function Get_Q: UnicodeString;
    function Get_G: UnicodeString;
    function Get_Y: UnicodeString;
    function Get_J: UnicodeString;
    function Get_Seed: UnicodeString;
    function Get_PgenCounter: UnicodeString;
    procedure Set_P(Value: UnicodeString);
    procedure Set_Q(Value: UnicodeString);
    procedure Set_G(Value: UnicodeString);
    procedure Set_Y(Value: UnicodeString);
    procedure Set_J(Value: UnicodeString);
    procedure Set_Seed(Value: UnicodeString);
    procedure Set_PgenCounter(Value: UnicodeString);
    { Methods & Properties }
    property P: UnicodeString read Get_P write Set_P;
    property Q: UnicodeString read Get_Q write Set_Q;
    property G: UnicodeString read Get_G write Set_G;
    property Y: UnicodeString read Get_Y write Set_Y;
    property J: UnicodeString read Get_J write Set_J;
    property Seed: UnicodeString read Get_Seed write Set_Seed;
    property PgenCounter: UnicodeString read Get_PgenCounter write Set_PgenCounter;
  end;

{ IXMLRSAKeyValueType }

  IXMLRSAKeyValueType = interface(IXMLNode)
    ['{154BCFFC-421A-4D13-840B-828BC287B67B}']
    { Property Accessors }
    function Get_Modulus: UnicodeString;
    function Get_Exponent: UnicodeString;
    procedure Set_Modulus(Value: UnicodeString);
    procedure Set_Exponent(Value: UnicodeString);
    { Methods & Properties }
    property Modulus: UnicodeString read Get_Modulus write Set_Modulus;
    property Exponent: UnicodeString read Get_Exponent write Set_Exponent;
  end;

{ IXMLRetrievalMethodType }

  IXMLRetrievalMethodType = interface(IXMLNode)
    ['{7F40200B-B5D4-4D43-86EE-DD496AD4FDEA}']
    { Property Accessors }
    function Get_URI: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Transforms: IXMLTransformsType;
    procedure Set_URI(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property URI: UnicodeString read Get_URI write Set_URI;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Transforms: IXMLTransformsType read Get_Transforms;
  end;

{ IXMLRetrievalMethodTypeList }

  IXMLRetrievalMethodTypeList = interface(IXMLNodeCollection)
    ['{1F2DF520-D671-4A28-B7DA-11300EB38CC8}']
    { Methods & Properties }
    function Add: IXMLRetrievalMethodType;
    function Insert(const Index: Integer): IXMLRetrievalMethodType;

    function Get_Item(Index: Integer): IXMLRetrievalMethodType;
    property Items[Index: Integer]: IXMLRetrievalMethodType read Get_Item; default;
  end;

{ IXMLX509DataType }

  IXMLX509DataType = interface(IXMLNode)
    ['{11C1DA9A-3097-4EA8-95B8-7A7248EFB6DE}']
    { Property Accessors }
    function Get_X509IssuerSerial: IXMLX509IssuerSerialTypeList;
    function Get_X509SKI: IXMLBase64BinaryList;
    function Get_X509SubjectName: IXMLString_List;
    function Get_X509Certificate: IXMLBase64BinaryList;
    function Get_X509CRL: IXMLBase64BinaryList;
    { Methods & Properties }
    property X509IssuerSerial: IXMLX509IssuerSerialTypeList read Get_X509IssuerSerial;
    property X509SKI: IXMLBase64BinaryList read Get_X509SKI;
    property X509SubjectName: IXMLString_List read Get_X509SubjectName;
    property X509Certificate: IXMLBase64BinaryList read Get_X509Certificate;
    property X509CRL: IXMLBase64BinaryList read Get_X509CRL;
  end;

{ IXMLX509DataTypeList }

  IXMLX509DataTypeList = interface(IXMLNodeCollection)
    ['{C9587FD3-E0C6-4E8A-9ADE-1734A64CBBA8}']
    { Methods & Properties }
    function Add: IXMLX509DataType;
    function Insert(const Index: Integer): IXMLX509DataType;

    function Get_Item(Index: Integer): IXMLX509DataType;
    property Items[Index: Integer]: IXMLX509DataType read Get_Item; default;
  end;

{ IXMLX509IssuerSerialType }

  IXMLX509IssuerSerialType = interface(IXMLNode)
    ['{44205E05-1E82-4BCE-9EC7-8A329E154036}']
    { Property Accessors }
    function Get_X509IssuerName: UnicodeString;
    function Get_X509SerialNumber: Integer;
    procedure Set_X509IssuerName(Value: UnicodeString);
    procedure Set_X509SerialNumber(Value: Integer);
    { Methods & Properties }
    property X509IssuerName: UnicodeString read Get_X509IssuerName write Set_X509IssuerName;
    property X509SerialNumber: Integer read Get_X509SerialNumber write Set_X509SerialNumber;
  end;

{ IXMLX509IssuerSerialTypeList }

  IXMLX509IssuerSerialTypeList = interface(IXMLNodeCollection)
    ['{599C9066-2362-43BA-83BD-EC0C4C856B11}']
    { Methods & Properties }
    function Add: IXMLX509IssuerSerialType;
    function Insert(const Index: Integer): IXMLX509IssuerSerialType;

    function Get_Item(Index: Integer): IXMLX509IssuerSerialType;
    property Items[Index: Integer]: IXMLX509IssuerSerialType read Get_Item; default;
  end;

{ IXMLPGPDataType }

  IXMLPGPDataType = interface(IXMLNode)
    ['{1B35FD37-7C5A-41C3-9BE9-4CD839B4ADCF}']
    { Property Accessors }
    function Get_PGPKeyID: UnicodeString;
    function Get_PGPKeyPacket: UnicodeString;
    procedure Set_PGPKeyID(Value: UnicodeString);
    procedure Set_PGPKeyPacket(Value: UnicodeString);
    { Methods & Properties }
    property PGPKeyID: UnicodeString read Get_PGPKeyID write Set_PGPKeyID;
    property PGPKeyPacket: UnicodeString read Get_PGPKeyPacket write Set_PGPKeyPacket;
  end;

{ IXMLPGPDataTypeList }

  IXMLPGPDataTypeList = interface(IXMLNodeCollection)
    ['{70FE6474-372B-449B-9DE7-567DBE48710A}']
    { Methods & Properties }
    function Add: IXMLPGPDataType;
    function Insert(const Index: Integer): IXMLPGPDataType;

    function Get_Item(Index: Integer): IXMLPGPDataType;
    property Items[Index: Integer]: IXMLPGPDataType read Get_Item; default;
  end;

{ IXMLSPKIDataType }

  IXMLSPKIDataType = interface(IXMLNodeCollection)
    ['{710D3934-ED53-4233-879C-C61521C967BC}']
    { Property Accessors }
    function Get_SPKISexp(Index: Integer): UnicodeString;
    { Methods & Properties }
    function Add(const SPKISexp: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const SPKISexp: UnicodeString): IXMLNode;
    property SPKISexp[Index: Integer]: UnicodeString read Get_SPKISexp; default;
  end;

{ IXMLSPKIDataTypeList }

  IXMLSPKIDataTypeList = interface(IXMLNodeCollection)
    ['{F5702348-AB62-4D6A-977C-66422DD68332}']
    { Methods & Properties }
    function Add: IXMLSPKIDataType;
    function Insert(const Index: Integer): IXMLSPKIDataType;

    function Get_Item(Index: Integer): IXMLSPKIDataType;
    property Items[Index: Integer]: IXMLSPKIDataType read Get_Item; default;
  end;

{ IXMLObjectType }

  IXMLObjectType = interface(IXMLNode)
    ['{98DD54FD-A35B-41B1-9635-7475BF7F27A8}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_MimeType: UnicodeString;
    function Get_Encoding: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_MimeType(Value: UnicodeString);
    procedure Set_Encoding(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property MimeType: UnicodeString read Get_MimeType write Set_MimeType;
    property Encoding: UnicodeString read Get_Encoding write Set_Encoding;
  end;

{ IXMLObjectTypeList }

  IXMLObjectTypeList = interface(IXMLNodeCollection)
    ['{56685268-9F4F-4E68-A524-3210776A842E}']
    { Methods & Properties }
    function Add: IXMLObjectType;
    function Insert(const Index: Integer): IXMLObjectType;

    function Get_Item(Index: Integer): IXMLObjectType;
    property Items[Index: Integer]: IXMLObjectType read Get_Item; default;
  end;

{ IXMLManifestType }

  IXMLManifestType = interface(IXMLNodeCollection)
    ['{0C08D08C-9DE9-4BA5-8AA6-49F055E784E3}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_Reference(Index: Integer): IXMLReferenceType;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    function Add: IXMLReferenceType;
    function Insert(const Index: Integer): IXMLReferenceType;
    property Id: UnicodeString read Get_Id write Set_Id;
    property Reference[Index: Integer]: IXMLReferenceType read Get_Reference; default;
  end;

{ IXMLSignaturePropertiesType }

  IXMLSignaturePropertiesType = interface(IXMLNodeCollection)
    ['{E87DD1EB-F1BC-49DE-95D7-C0C5B2E9DC6A}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_SignatureProperty(Index: Integer): IXMLSignaturePropertyType;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    function Add: IXMLSignaturePropertyType;
    function Insert(const Index: Integer): IXMLSignaturePropertyType;
    property Id: UnicodeString read Get_Id write Set_Id;
    property SignatureProperty[Index: Integer]: IXMLSignaturePropertyType read Get_SignatureProperty; default;
  end;

{ IXMLSignaturePropertyType }

  IXMLSignaturePropertyType = interface(IXMLNode)
    ['{18A349A0-10F0-47F5-A3B1-7370BB2209C9}']
    { Property Accessors }
    function Get_Target: UnicodeString;
    function Get_Id: UnicodeString;
    procedure Set_Target(Value: UnicodeString);
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Target: UnicodeString read Get_Target write Set_Target;
    property Id: UnicodeString read Get_Id write Set_Id;
  end;

{ IXMLString_List }

  IXMLString_List = interface(IXMLNodeCollection)
    ['{315A4453-12A2-4DE8-8076-823E8D695ED6}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ IXMLBase64BinaryList }

  IXMLBase64BinaryList = interface(IXMLNodeCollection)
    ['{74CFC4E9-D9E5-4144-8174-749F26D7A600}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ Forward Decls }

  TXMLSignatureType = class;
  TXMLSignedInfoType = class;
  TXMLCanonicalizationMethodType = class;
  TXMLSignatureMethodType = class;
  TXMLReferenceType = class;
  TXMLReferenceTypeList = class;
  TXMLTransformsType = class;
  TXMLTransformType = class;
  TXMLDigestMethodType = class;
  TXMLSignatureValueType = class;
  TXMLKeyInfoType = class;
  TXMLKeyValueType = class;
  TXMLKeyValueTypeList = class;
  TXMLDSAKeyValueType = class;
  TXMLRSAKeyValueType = class;
  TXMLRetrievalMethodType = class;
  TXMLRetrievalMethodTypeList = class;
  TXMLX509DataType = class;
  TXMLX509DataTypeList = class;
  TXMLX509IssuerSerialType = class;
  TXMLX509IssuerSerialTypeList = class;
  TXMLPGPDataType = class;
  TXMLPGPDataTypeList = class;
  TXMLSPKIDataType = class;
  TXMLSPKIDataTypeList = class;
  TXMLObjectType = class;
  TXMLObjectTypeList = class;
  TXMLManifestType = class;
  TXMLSignaturePropertiesType = class;
  TXMLSignaturePropertyType = class;
  TXMLString_List = class;
  TXMLBase64BinaryList = class;

{ TXMLSignatureType }

  TXMLSignatureType = class(TXMLNode, IXMLSignatureType)
  private
    FObject_: IXMLObjectTypeList;
  protected
    { IXMLSignatureType }
    function Get_Id: UnicodeString;
    function Get_SignedInfo: IXMLSignedInfoType;
    function Get_SignatureValue: IXMLSignatureValueType;
    function Get_KeyInfo: IXMLKeyInfoType;
    function Get_Object_: IXMLObjectTypeList;
    procedure Set_Id(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSignedInfoType }

  TXMLSignedInfoType = class(TXMLNode, IXMLSignedInfoType)
  private
    FReference: IXMLReferenceTypeList;
  protected
    { IXMLSignedInfoType }
    function Get_Id: UnicodeString;
    function Get_CanonicalizationMethod: IXMLCanonicalizationMethodType;
    function Get_SignatureMethod: IXMLSignatureMethodType;
    function Get_Reference: IXMLReferenceTypeList;
    procedure Set_Id(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCanonicalizationMethodType }

  TXMLCanonicalizationMethodType = class(TXMLNode, IXMLCanonicalizationMethodType)
  protected
    { IXMLCanonicalizationMethodType }
    function Get_Algorithm: UnicodeString;
    procedure Set_Algorithm(Value: UnicodeString);
  end;

{ TXMLSignatureMethodType }

  TXMLSignatureMethodType = class(TXMLNode, IXMLSignatureMethodType)
  protected
    { IXMLSignatureMethodType }
    function Get_Algorithm: UnicodeString;
    function Get_HMACOutputLength: Integer;
    procedure Set_Algorithm(Value: UnicodeString);
    procedure Set_HMACOutputLength(Value: Integer);
  end;

{ TXMLReferenceType }

  TXMLReferenceType = class(TXMLNode, IXMLReferenceType)
  protected
    { IXMLReferenceType }
    function Get_Id: UnicodeString;
    function Get_URI: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Transforms: IXMLTransformsType;
    function Get_DigestMethod: IXMLDigestMethodType;
    function Get_DigestValue: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_URI(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_DigestValue(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLReferenceTypeList }

  TXMLReferenceTypeList = class(TXMLNodeCollection, IXMLReferenceTypeList)
  protected
    { IXMLReferenceTypeList }
    function Add: IXMLReferenceType;
    function Insert(const Index: Integer): IXMLReferenceType;

    function Get_Item(Index: Integer): IXMLReferenceType;
  end;

{ TXMLTransformsType }

  TXMLTransformsType = class(TXMLNodeCollection, IXMLTransformsType)
  protected
    { IXMLTransformsType }
    function Get_Transform(Index: Integer): IXMLTransformType;
    function Add: IXMLTransformType;
    function Insert(const Index: Integer): IXMLTransformType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTransformType }

  TXMLTransformType = class(TXMLNodeCollection, IXMLTransformType)
  protected
    { IXMLTransformType }
    function Get_Algorithm: UnicodeString;
    function Get_XPath(Index: Integer): UnicodeString;
    procedure Set_Algorithm(Value: UnicodeString);
    function Add(const XPath: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const XPath: UnicodeString): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDigestMethodType }

  TXMLDigestMethodType = class(TXMLNode, IXMLDigestMethodType)
  protected
    { IXMLDigestMethodType }
    function Get_Algorithm: UnicodeString;
    procedure Set_Algorithm(Value: UnicodeString);
  end;

{ TXMLSignatureValueType }

  TXMLSignatureValueType = class(TXMLNode, IXMLSignatureValueType)
  protected
    { IXMLSignatureValueType }
    function Get_Id: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
  end;

{ TXMLKeyInfoType }

  TXMLKeyInfoType = class(TXMLNode, IXMLKeyInfoType)
  private
    FKeyName: IXMLString_List;
    FKeyValue: IXMLKeyValueTypeList;
    FRetrievalMethod: IXMLRetrievalMethodTypeList;
    FX509Data: IXMLX509DataTypeList;
    FPGPData: IXMLPGPDataTypeList;
    FSPKIData: IXMLSPKIDataTypeList;
    FMgmtData: IXMLString_List;
  protected
    { IXMLKeyInfoType }
    function Get_Id: UnicodeString;
    function Get_KeyName: IXMLString_List;
    function Get_KeyValue: IXMLKeyValueTypeList;
    function Get_RetrievalMethod: IXMLRetrievalMethodTypeList;
    function Get_X509Data: IXMLX509DataTypeList;
    function Get_PGPData: IXMLPGPDataTypeList;
    function Get_SPKIData: IXMLSPKIDataTypeList;
    function Get_MgmtData: IXMLString_List;
    procedure Set_Id(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLKeyValueType }

  TXMLKeyValueType = class(TXMLNode, IXMLKeyValueType)
  protected
    { IXMLKeyValueType }
    function Get_DSAKeyValue: IXMLDSAKeyValueType;
    function Get_RSAKeyValue: IXMLRSAKeyValueType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLKeyValueTypeList }

  TXMLKeyValueTypeList = class(TXMLNodeCollection, IXMLKeyValueTypeList)
  protected
    { IXMLKeyValueTypeList }
    function Add: IXMLKeyValueType;
    function Insert(const Index: Integer): IXMLKeyValueType;

    function Get_Item(Index: Integer): IXMLKeyValueType;
  end;

{ TXMLDSAKeyValueType }

  TXMLDSAKeyValueType = class(TXMLNode, IXMLDSAKeyValueType)
  protected
    { IXMLDSAKeyValueType }
    function Get_P: UnicodeString;
    function Get_Q: UnicodeString;
    function Get_G: UnicodeString;
    function Get_Y: UnicodeString;
    function Get_J: UnicodeString;
    function Get_Seed: UnicodeString;
    function Get_PgenCounter: UnicodeString;
    procedure Set_P(Value: UnicodeString);
    procedure Set_Q(Value: UnicodeString);
    procedure Set_G(Value: UnicodeString);
    procedure Set_Y(Value: UnicodeString);
    procedure Set_J(Value: UnicodeString);
    procedure Set_Seed(Value: UnicodeString);
    procedure Set_PgenCounter(Value: UnicodeString);
  end;

{ TXMLRSAKeyValueType }

  TXMLRSAKeyValueType = class(TXMLNode, IXMLRSAKeyValueType)
  protected
    { IXMLRSAKeyValueType }
    function Get_Modulus: UnicodeString;
    function Get_Exponent: UnicodeString;
    procedure Set_Modulus(Value: UnicodeString);
    procedure Set_Exponent(Value: UnicodeString);
  end;

{ TXMLRetrievalMethodType }

  TXMLRetrievalMethodType = class(TXMLNode, IXMLRetrievalMethodType)
  protected
    { IXMLRetrievalMethodType }
    function Get_URI: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Transforms: IXMLTransformsType;
    procedure Set_URI(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRetrievalMethodTypeList }

  TXMLRetrievalMethodTypeList = class(TXMLNodeCollection, IXMLRetrievalMethodTypeList)
  protected
    { IXMLRetrievalMethodTypeList }
    function Add: IXMLRetrievalMethodType;
    function Insert(const Index: Integer): IXMLRetrievalMethodType;

    function Get_Item(Index: Integer): IXMLRetrievalMethodType;
  end;

{ TXMLX509DataType }

  TXMLX509DataType = class(TXMLNode, IXMLX509DataType)
  private
    FX509IssuerSerial: IXMLX509IssuerSerialTypeList;
    FX509SKI: IXMLBase64BinaryList;
    FX509SubjectName: IXMLString_List;
    FX509Certificate: IXMLBase64BinaryList;
    FX509CRL: IXMLBase64BinaryList;
  protected
    { IXMLX509DataType }
    function Get_X509IssuerSerial: IXMLX509IssuerSerialTypeList;
    function Get_X509SKI: IXMLBase64BinaryList;
    function Get_X509SubjectName: IXMLString_List;
    function Get_X509Certificate: IXMLBase64BinaryList;
    function Get_X509CRL: IXMLBase64BinaryList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLX509DataTypeList }

  TXMLX509DataTypeList = class(TXMLNodeCollection, IXMLX509DataTypeList)
  protected
    { IXMLX509DataTypeList }
    function Add: IXMLX509DataType;
    function Insert(const Index: Integer): IXMLX509DataType;

    function Get_Item(Index: Integer): IXMLX509DataType;
  end;

{ TXMLX509IssuerSerialType }

  TXMLX509IssuerSerialType = class(TXMLNode, IXMLX509IssuerSerialType)
  protected
    { IXMLX509IssuerSerialType }
    function Get_X509IssuerName: UnicodeString;
    function Get_X509SerialNumber: Integer;
    procedure Set_X509IssuerName(Value: UnicodeString);
    procedure Set_X509SerialNumber(Value: Integer);
  end;

{ TXMLX509IssuerSerialTypeList }

  TXMLX509IssuerSerialTypeList = class(TXMLNodeCollection, IXMLX509IssuerSerialTypeList)
  protected
    { IXMLX509IssuerSerialTypeList }
    function Add: IXMLX509IssuerSerialType;
    function Insert(const Index: Integer): IXMLX509IssuerSerialType;

    function Get_Item(Index: Integer): IXMLX509IssuerSerialType;
  end;

{ TXMLPGPDataType }

  TXMLPGPDataType = class(TXMLNode, IXMLPGPDataType)
  protected
    { IXMLPGPDataType }
    function Get_PGPKeyID: UnicodeString;
    function Get_PGPKeyPacket: UnicodeString;
    procedure Set_PGPKeyID(Value: UnicodeString);
    procedure Set_PGPKeyPacket(Value: UnicodeString);
  end;

{ TXMLPGPDataTypeList }

  TXMLPGPDataTypeList = class(TXMLNodeCollection, IXMLPGPDataTypeList)
  protected
    { IXMLPGPDataTypeList }
    function Add: IXMLPGPDataType;
    function Insert(const Index: Integer): IXMLPGPDataType;

    function Get_Item(Index: Integer): IXMLPGPDataType;
  end;

{ TXMLSPKIDataType }

  TXMLSPKIDataType = class(TXMLNodeCollection, IXMLSPKIDataType)
  protected
    { IXMLSPKIDataType }
    function Get_SPKISexp(Index: Integer): UnicodeString;
    function Add(const SPKISexp: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const SPKISexp: UnicodeString): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSPKIDataTypeList }

  TXMLSPKIDataTypeList = class(TXMLNodeCollection, IXMLSPKIDataTypeList)
  protected
    { IXMLSPKIDataTypeList }
    function Add: IXMLSPKIDataType;
    function Insert(const Index: Integer): IXMLSPKIDataType;

    function Get_Item(Index: Integer): IXMLSPKIDataType;
  end;

{ TXMLObjectType }

  TXMLObjectType = class(TXMLNode, IXMLObjectType)
  protected
    { IXMLObjectType }
    function Get_Id: UnicodeString;
    function Get_MimeType: UnicodeString;
    function Get_Encoding: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_MimeType(Value: UnicodeString);
    procedure Set_Encoding(Value: UnicodeString);
  end;

{ TXMLObjectTypeList }

  TXMLObjectTypeList = class(TXMLNodeCollection, IXMLObjectTypeList)
  protected
    { IXMLObjectTypeList }
    function Add: IXMLObjectType;
    function Insert(const Index: Integer): IXMLObjectType;

    function Get_Item(Index: Integer): IXMLObjectType;
  end;

{ TXMLManifestType }

  TXMLManifestType = class(TXMLNodeCollection, IXMLManifestType)
  protected
    { IXMLManifestType }
    function Get_Id: UnicodeString;
    function Get_Reference(Index: Integer): IXMLReferenceType;
    procedure Set_Id(Value: UnicodeString);
    function Add: IXMLReferenceType;
    function Insert(const Index: Integer): IXMLReferenceType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSignaturePropertiesType }

  TXMLSignaturePropertiesType = class(TXMLNodeCollection, IXMLSignaturePropertiesType)
  protected
    { IXMLSignaturePropertiesType }
    function Get_Id: UnicodeString;
    function Get_SignatureProperty(Index: Integer): IXMLSignaturePropertyType;
    procedure Set_Id(Value: UnicodeString);
    function Add: IXMLSignaturePropertyType;
    function Insert(const Index: Integer): IXMLSignaturePropertyType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSignaturePropertyType }

  TXMLSignaturePropertyType = class(TXMLNode, IXMLSignaturePropertyType)
  protected
    { IXMLSignaturePropertyType }
    function Get_Target: UnicodeString;
    function Get_Id: UnicodeString;
    procedure Set_Target(Value: UnicodeString);
    procedure Set_Id(Value: UnicodeString);
  end;

{ TXMLString_List }

  TXMLString_List = class(TXMLNodeCollection, IXMLString_List)
  protected
    { IXMLString_List }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ TXMLBase64BinaryList }

  TXMLBase64BinaryList = class(TXMLNodeCollection, IXMLBase64BinaryList)
  protected
    { IXMLBase64BinaryList }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ Global Functions }

function GetSignature(Doc: IXMLDocument): IXMLSignatureType;
function LoadSignature(const FileName: string): IXMLSignatureType;
function NewSignature: IXMLSignatureType;

const
  XMLDSigTargetNamespace = 'http://www.w3.org/2000/09/xmldsig#';

implementation

{ Global Functions }

function GetSignature(Doc: IXMLDocument): IXMLSignatureType;
begin
  Result := Doc.GetDocBinding('ds:Signature', TXMLSignatureType, XMLDSigTargetNamespace) as IXMLSignatureType;
end;

function LoadSignature(const FileName: string): IXMLSignatureType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ds:Signature', TXMLSignatureType, XMLDSigTargetNamespace) as IXMLSignatureType;
end;

function NewSignature: IXMLSignatureType;
begin
  Result := NewXMLDocument.GetDocBinding('ds:Signature', TXMLSignatureType, XMLDSigTargetNamespace) as IXMLSignatureType;
end;

{ TXMLSignatureType }

procedure TXMLSignatureType.AfterConstruction;
begin
  RegisterChildNode('SignedInfo', TXMLSignedInfoType);
  RegisterChildNode('SignatureValue', TXMLSignatureValueType);
  RegisterChildNode('KeyInfo', TXMLKeyInfoType);
  RegisterChildNode('Object', TXMLObjectType);
  FObject_ := CreateCollection(TXMLObjectTypeList, IXMLObjectType, 'Object') as IXMLObjectTypeList;
  inherited;
end;

function TXMLSignatureType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLSignatureType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLSignatureType.Get_SignedInfo: IXMLSignedInfoType;
begin
  Result := ChildNodes['SignedInfo'] as IXMLSignedInfoType;
end;

function TXMLSignatureType.Get_SignatureValue: IXMLSignatureValueType;
begin
  Result := ChildNodes['SignatureValue'] as IXMLSignatureValueType;
end;

function TXMLSignatureType.Get_KeyInfo: IXMLKeyInfoType;
begin
  Result := ChildNodes['KeyInfo'] as IXMLKeyInfoType;
end;

function TXMLSignatureType.Get_Object_: IXMLObjectTypeList;
begin
  Result := FObject_;
end;

{ TXMLSignedInfoType }

procedure TXMLSignedInfoType.AfterConstruction;
begin
  RegisterChildNode('CanonicalizationMethod', TXMLCanonicalizationMethodType);
  RegisterChildNode('SignatureMethod', TXMLSignatureMethodType);
  RegisterChildNode('Reference', TXMLReferenceType);
  FReference := CreateCollection(TXMLReferenceTypeList, IXMLReferenceType, 'ds:Reference') as IXMLReferenceTypeList;
  inherited;
end;

function TXMLSignedInfoType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLSignedInfoType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLSignedInfoType.Get_CanonicalizationMethod: IXMLCanonicalizationMethodType;
begin
  Result := ChildNodes['CanonicalizationMethod'] as IXMLCanonicalizationMethodType;
end;

function TXMLSignedInfoType.Get_SignatureMethod: IXMLSignatureMethodType;
begin
  Result := ChildNodes['SignatureMethod'] as IXMLSignatureMethodType;
end;

function TXMLSignedInfoType.Get_Reference: IXMLReferenceTypeList;
begin
  Result := FReference;
end;

{ TXMLCanonicalizationMethodType }

function TXMLCanonicalizationMethodType.Get_Algorithm: UnicodeString;
begin
  Result := AttributeNodes['Algorithm'].Text;
end;

procedure TXMLCanonicalizationMethodType.Set_Algorithm(Value: UnicodeString);
begin
  SetAttribute('Algorithm', Value);
end;

{ TXMLSignatureMethodType }

function TXMLSignatureMethodType.Get_Algorithm: UnicodeString;
begin
  Result := AttributeNodes['Algorithm'].Text;
end;

procedure TXMLSignatureMethodType.Set_Algorithm(Value: UnicodeString);
begin
  SetAttribute('Algorithm', Value);
end;

function TXMLSignatureMethodType.Get_HMACOutputLength: Integer;
begin
  Result := ChildNodes['HMACOutputLength'].NodeValue;
end;

procedure TXMLSignatureMethodType.Set_HMACOutputLength(Value: Integer);
begin
  ChildNodes['HMACOutputLength'].NodeValue := Value;
end;

{ TXMLReferenceType }

procedure TXMLReferenceType.AfterConstruction;
begin
  RegisterChildNode('Transforms', TXMLTransformsType);
  RegisterChildNode('DigestMethod', TXMLDigestMethodType);
  inherited;
end;

function TXMLReferenceType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLReferenceType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLReferenceType.Get_URI: UnicodeString;
begin
  Result := AttributeNodes['URI'].Text;
end;

procedure TXMLReferenceType.Set_URI(Value: UnicodeString);
begin
  SetAttribute('URI', Value);
end;

function TXMLReferenceType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLReferenceType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLReferenceType.Get_Transforms: IXMLTransformsType;
begin
  Result := ChildNodes['Transforms'] as IXMLTransformsType;
end;

function TXMLReferenceType.Get_DigestMethod: IXMLDigestMethodType;
begin
  Result := ChildNodes['DigestMethod'] as IXMLDigestMethodType;
end;

function TXMLReferenceType.Get_DigestValue: UnicodeString;
begin
  Result := ChildNodes['DigestValue'].Text;
end;

procedure TXMLReferenceType.Set_DigestValue(Value: UnicodeString);
begin
  ChildNodes['DigestValue'].NodeValue := Value;
end;

{ TXMLReferenceTypeList }

function TXMLReferenceTypeList.Add: IXMLReferenceType;
begin
  Result := AddItem(-1) as IXMLReferenceType;
end;

function TXMLReferenceTypeList.Insert(const Index: Integer): IXMLReferenceType;
begin
  Result := AddItem(Index) as IXMLReferenceType;
end;

function TXMLReferenceTypeList.Get_Item(Index: Integer): IXMLReferenceType;
begin
  Result := List[Index] as IXMLReferenceType;
end;

{ TXMLTransformsType }

procedure TXMLTransformsType.AfterConstruction;
begin
  RegisterChildNode('ds:Transform', TXMLTransformType);
  ItemTag := 'ds:Transform';
  ItemInterface := IXMLTransformType;
  inherited;
end;

function TXMLTransformsType.Get_Transform(Index: Integer): IXMLTransformType;
begin
  Result := List[Index] as IXMLTransformType;
end;

function TXMLTransformsType.Add: IXMLTransformType;
begin
  Result := AddItem(-1) as IXMLTransformType;
end;

function TXMLTransformsType.Insert(const Index: Integer): IXMLTransformType;
begin
  Result := AddItem(Index) as IXMLTransformType;
end;

{ TXMLTransformType }

procedure TXMLTransformType.AfterConstruction;
begin
  ItemTag := 'XPath';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLTransformType.Get_Algorithm: UnicodeString;
begin
  Result := AttributeNodes['Algorithm'].Text;
end;

procedure TXMLTransformType.Set_Algorithm(Value: UnicodeString);
begin
  SetAttribute('Algorithm', Value);
end;

function TXMLTransformType.Get_XPath(Index: Integer): UnicodeString;
begin
  Result := List[Index].Text;
end;

function TXMLTransformType.Add(const XPath: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := XPath;
end;

function TXMLTransformType.Insert(const Index: Integer; const XPath: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := XPath;
end;

{ TXMLDigestMethodType }

function TXMLDigestMethodType.Get_Algorithm: UnicodeString;
begin
  Result := AttributeNodes['Algorithm'].Text;
end;

procedure TXMLDigestMethodType.Set_Algorithm(Value: UnicodeString);
begin
  SetAttribute('Algorithm', Value);
end;

{ TXMLSignatureValueType }

function TXMLSignatureValueType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLSignatureValueType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

{ TXMLKeyInfoType }

procedure TXMLKeyInfoType.AfterConstruction;
begin
  RegisterChildNode('KeyValue', TXMLKeyValueType);
  RegisterChildNode('RetrievalMethod', TXMLRetrievalMethodType);
  RegisterChildNode('X509Data', TXMLX509DataType);
  RegisterChildNode('PGPData', TXMLPGPDataType);
  RegisterChildNode('SPKIData', TXMLSPKIDataType);
  FKeyName := CreateCollection(TXMLString_List, IXMLNode, 'KeyName') as IXMLString_List;
  FKeyValue := CreateCollection(TXMLKeyValueTypeList, IXMLKeyValueType, 'KeyValue') as IXMLKeyValueTypeList;
  FRetrievalMethod := CreateCollection(TXMLRetrievalMethodTypeList, IXMLRetrievalMethodType, 'RetrievalMethod') as IXMLRetrievalMethodTypeList;
  FX509Data := CreateCollection(TXMLX509DataTypeList, IXMLX509DataType, 'X509Data') as IXMLX509DataTypeList;
  FPGPData := CreateCollection(TXMLPGPDataTypeList, IXMLPGPDataType, 'PGPData') as IXMLPGPDataTypeList;
  FSPKIData := CreateCollection(TXMLSPKIDataTypeList, IXMLSPKIDataType, 'SPKIData') as IXMLSPKIDataTypeList;
  FMgmtData := CreateCollection(TXMLString_List, IXMLNode, 'MgmtData') as IXMLString_List;
  inherited;
end;

function TXMLKeyInfoType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLKeyInfoType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLKeyInfoType.Get_KeyName: IXMLString_List;
begin
  Result := FKeyName;
end;

function TXMLKeyInfoType.Get_KeyValue: IXMLKeyValueTypeList;
begin
  Result := FKeyValue;
end;

function TXMLKeyInfoType.Get_RetrievalMethod: IXMLRetrievalMethodTypeList;
begin
  Result := FRetrievalMethod;
end;

function TXMLKeyInfoType.Get_X509Data: IXMLX509DataTypeList;
begin
  Result := FX509Data;
end;

function TXMLKeyInfoType.Get_PGPData: IXMLPGPDataTypeList;
begin
  Result := FPGPData;
end;

function TXMLKeyInfoType.Get_SPKIData: IXMLSPKIDataTypeList;
begin
  Result := FSPKIData;
end;

function TXMLKeyInfoType.Get_MgmtData: IXMLString_List;
begin
  Result := FMgmtData;
end;

{ TXMLKeyValueType }

procedure TXMLKeyValueType.AfterConstruction;
begin
  RegisterChildNode('DSAKeyValue', TXMLDSAKeyValueType);
  RegisterChildNode('RSAKeyValue', TXMLRSAKeyValueType);
  inherited;
end;

function TXMLKeyValueType.Get_DSAKeyValue: IXMLDSAKeyValueType;
begin
  Result := ChildNodes['DSAKeyValue'] as IXMLDSAKeyValueType;
end;

function TXMLKeyValueType.Get_RSAKeyValue: IXMLRSAKeyValueType;
begin
  Result := ChildNodes['RSAKeyValue'] as IXMLRSAKeyValueType;
end;

{ TXMLKeyValueTypeList }

function TXMLKeyValueTypeList.Add: IXMLKeyValueType;
begin
  Result := AddItem(-1) as IXMLKeyValueType;
end;

function TXMLKeyValueTypeList.Insert(const Index: Integer): IXMLKeyValueType;
begin
  Result := AddItem(Index) as IXMLKeyValueType;
end;

function TXMLKeyValueTypeList.Get_Item(Index: Integer): IXMLKeyValueType;
begin
  Result := List[Index] as IXMLKeyValueType;
end;

{ TXMLDSAKeyValueType }

function TXMLDSAKeyValueType.Get_P: UnicodeString;
begin
  Result := ChildNodes[WideString('P')].Text;
end;

procedure TXMLDSAKeyValueType.Set_P(Value: UnicodeString);
begin
  ChildNodes[WideString('P')].NodeValue := Value;
end;

function TXMLDSAKeyValueType.Get_Q: UnicodeString;
begin
  Result := ChildNodes[WideString('Q')].Text;
end;

procedure TXMLDSAKeyValueType.Set_Q(Value: UnicodeString);
begin
  ChildNodes[WideString('Q')].NodeValue := Value;
end;

function TXMLDSAKeyValueType.Get_G: UnicodeString;
begin
  Result := ChildNodes[WideString('G')].Text;
end;

procedure TXMLDSAKeyValueType.Set_G(Value: UnicodeString);
begin
  ChildNodes[WideString('G')].NodeValue := Value;
end;

function TXMLDSAKeyValueType.Get_Y: UnicodeString;
begin
  Result := ChildNodes[WideString('Y')].Text;
end;

procedure TXMLDSAKeyValueType.Set_Y(Value: UnicodeString);
begin
  ChildNodes[WideString('Y')].NodeValue := Value;
end;

function TXMLDSAKeyValueType.Get_J: UnicodeString;
begin
  Result := ChildNodes[WideString('J')].Text;
end;

procedure TXMLDSAKeyValueType.Set_J(Value: UnicodeString);
begin
  ChildNodes[WideString('J')].NodeValue := Value;
end;

function TXMLDSAKeyValueType.Get_Seed: UnicodeString;
begin
  Result := ChildNodes['Seed'].Text;
end;

procedure TXMLDSAKeyValueType.Set_Seed(Value: UnicodeString);
begin
  ChildNodes['Seed'].NodeValue := Value;
end;

function TXMLDSAKeyValueType.Get_PgenCounter: UnicodeString;
begin
  Result := ChildNodes['PgenCounter'].Text;
end;

procedure TXMLDSAKeyValueType.Set_PgenCounter(Value: UnicodeString);
begin
  ChildNodes['PgenCounter'].NodeValue := Value;
end;

{ TXMLRSAKeyValueType }

function TXMLRSAKeyValueType.Get_Modulus: UnicodeString;
begin
  Result := ChildNodes['Modulus'].Text;
end;

procedure TXMLRSAKeyValueType.Set_Modulus(Value: UnicodeString);
begin
  ChildNodes['Modulus'].NodeValue := Value;
end;

function TXMLRSAKeyValueType.Get_Exponent: UnicodeString;
begin
  Result := ChildNodes['Exponent'].Text;
end;

procedure TXMLRSAKeyValueType.Set_Exponent(Value: UnicodeString);
begin
  ChildNodes['Exponent'].NodeValue := Value;
end;

{ TXMLRetrievalMethodType }

procedure TXMLRetrievalMethodType.AfterConstruction;
begin
  RegisterChildNode('Transforms', TXMLTransformsType);
  inherited;
end;

function TXMLRetrievalMethodType.Get_URI: UnicodeString;
begin
  Result := AttributeNodes['URI'].Text;
end;

procedure TXMLRetrievalMethodType.Set_URI(Value: UnicodeString);
begin
  SetAttribute('URI', Value);
end;

function TXMLRetrievalMethodType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLRetrievalMethodType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLRetrievalMethodType.Get_Transforms: IXMLTransformsType;
begin
  Result := ChildNodes['Transforms'] as IXMLTransformsType;
end;

{ TXMLRetrievalMethodTypeList }

function TXMLRetrievalMethodTypeList.Add: IXMLRetrievalMethodType;
begin
  Result := AddItem(-1) as IXMLRetrievalMethodType;
end;

function TXMLRetrievalMethodTypeList.Insert(const Index: Integer): IXMLRetrievalMethodType;
begin
  Result := AddItem(Index) as IXMLRetrievalMethodType;
end;

function TXMLRetrievalMethodTypeList.Get_Item(Index: Integer): IXMLRetrievalMethodType;
begin
  Result := List[Index] as IXMLRetrievalMethodType;
end;

{ TXMLX509DataType }

procedure TXMLX509DataType.AfterConstruction;
begin
  RegisterChildNode('X509IssuerSerial', TXMLX509IssuerSerialType);
  FX509IssuerSerial := CreateCollection(TXMLX509IssuerSerialTypeList, IXMLX509IssuerSerialType, 'X509IssuerSerial') as IXMLX509IssuerSerialTypeList;
  FX509SKI := CreateCollection(TXMLBase64BinaryList, IXMLNode, 'X509SKI') as IXMLBase64BinaryList;
  FX509SubjectName := CreateCollection(TXMLString_List, IXMLNode, 'X509SubjectName') as IXMLString_List;
  FX509Certificate := CreateCollection(TXMLBase64BinaryList, IXMLNode, 'X509Certificate') as IXMLBase64BinaryList;
  FX509CRL := CreateCollection(TXMLBase64BinaryList, IXMLNode, 'X509CRL') as IXMLBase64BinaryList;
  inherited;
end;

function TXMLX509DataType.Get_X509IssuerSerial: IXMLX509IssuerSerialTypeList;
begin
  Result := FX509IssuerSerial;
end;

function TXMLX509DataType.Get_X509SKI: IXMLBase64BinaryList;
begin
  Result := FX509SKI;
end;

function TXMLX509DataType.Get_X509SubjectName: IXMLString_List;
begin
  Result := FX509SubjectName;
end;

function TXMLX509DataType.Get_X509Certificate: IXMLBase64BinaryList;
begin
  Result := FX509Certificate;
end;

function TXMLX509DataType.Get_X509CRL: IXMLBase64BinaryList;
begin
  Result := FX509CRL;
end;

{ TXMLX509DataTypeList }

function TXMLX509DataTypeList.Add: IXMLX509DataType;
begin
  Result := AddItem(-1) as IXMLX509DataType;
end;

function TXMLX509DataTypeList.Insert(const Index: Integer): IXMLX509DataType;
begin
  Result := AddItem(Index) as IXMLX509DataType;
end;

function TXMLX509DataTypeList.Get_Item(Index: Integer): IXMLX509DataType;
begin
  Result := List[Index] as IXMLX509DataType;
end;

{ TXMLX509IssuerSerialType }

function TXMLX509IssuerSerialType.Get_X509IssuerName: UnicodeString;
begin
  Result := ChildNodes['X509IssuerName'].Text;
end;

procedure TXMLX509IssuerSerialType.Set_X509IssuerName(Value: UnicodeString);
begin
  ChildNodes['X509IssuerName'].NodeValue := Value;
end;

function TXMLX509IssuerSerialType.Get_X509SerialNumber: Integer;
begin
  Result := ChildNodes['X509SerialNumber'].NodeValue;
end;

procedure TXMLX509IssuerSerialType.Set_X509SerialNumber(Value: Integer);
begin
  ChildNodes['X509SerialNumber'].NodeValue := Value;
end;

{ TXMLX509IssuerSerialTypeList }

function TXMLX509IssuerSerialTypeList.Add: IXMLX509IssuerSerialType;
begin
  Result := AddItem(-1) as IXMLX509IssuerSerialType;
end;

function TXMLX509IssuerSerialTypeList.Insert(const Index: Integer): IXMLX509IssuerSerialType;
begin
  Result := AddItem(Index) as IXMLX509IssuerSerialType;
end;

function TXMLX509IssuerSerialTypeList.Get_Item(Index: Integer): IXMLX509IssuerSerialType;
begin
  Result := List[Index] as IXMLX509IssuerSerialType;
end;

{ TXMLPGPDataType }

function TXMLPGPDataType.Get_PGPKeyID: UnicodeString;
begin
  Result := ChildNodes['PGPKeyID'].Text;
end;

procedure TXMLPGPDataType.Set_PGPKeyID(Value: UnicodeString);
begin
  ChildNodes['PGPKeyID'].NodeValue := Value;
end;

function TXMLPGPDataType.Get_PGPKeyPacket: UnicodeString;
begin
  Result := ChildNodes['PGPKeyPacket'].Text;
end;

procedure TXMLPGPDataType.Set_PGPKeyPacket(Value: UnicodeString);
begin
  ChildNodes['PGPKeyPacket'].NodeValue := Value;
end;

{ TXMLPGPDataTypeList }

function TXMLPGPDataTypeList.Add: IXMLPGPDataType;
begin
  Result := AddItem(-1) as IXMLPGPDataType;
end;

function TXMLPGPDataTypeList.Insert(const Index: Integer): IXMLPGPDataType;
begin
  Result := AddItem(Index) as IXMLPGPDataType;
end;

function TXMLPGPDataTypeList.Get_Item(Index: Integer): IXMLPGPDataType;
begin
  Result := List[Index] as IXMLPGPDataType;
end;

{ TXMLSPKIDataType }

procedure TXMLSPKIDataType.AfterConstruction;
begin
  ItemTag := 'SPKISexp';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLSPKIDataType.Get_SPKISexp(Index: Integer): UnicodeString;
begin
  Result := List[Index].Text;
end;

function TXMLSPKIDataType.Add(const SPKISexp: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := SPKISexp;
end;

function TXMLSPKIDataType.Insert(const Index: Integer; const SPKISexp: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := SPKISexp;
end;

{ TXMLSPKIDataTypeList }

function TXMLSPKIDataTypeList.Add: IXMLSPKIDataType;
begin
  Result := AddItem(-1) as IXMLSPKIDataType;
end;

function TXMLSPKIDataTypeList.Insert(const Index: Integer): IXMLSPKIDataType;
begin
  Result := AddItem(Index) as IXMLSPKIDataType;
end;

function TXMLSPKIDataTypeList.Get_Item(Index: Integer): IXMLSPKIDataType;
begin
  Result := List[Index] as IXMLSPKIDataType;
end;

{ TXMLObjectType }

function TXMLObjectType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLObjectType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLObjectType.Get_MimeType: UnicodeString;
begin
  Result := AttributeNodes['MimeType'].Text;
end;

procedure TXMLObjectType.Set_MimeType(Value: UnicodeString);
begin
  SetAttribute('MimeType', Value);
end;

function TXMLObjectType.Get_Encoding: UnicodeString;
begin
  Result := AttributeNodes['Encoding'].Text;
end;

procedure TXMLObjectType.Set_Encoding(Value: UnicodeString);
begin
  SetAttribute('Encoding', Value);
end;

{ TXMLObjectTypeList }

function TXMLObjectTypeList.Add: IXMLObjectType;
begin
  Result := AddItem(-1) as IXMLObjectType;
end;

function TXMLObjectTypeList.Insert(const Index: Integer): IXMLObjectType;
begin
  Result := AddItem(Index) as IXMLObjectType;
end;

function TXMLObjectTypeList.Get_Item(Index: Integer): IXMLObjectType;
begin
  Result := List[Index] as IXMLObjectType;
end;

{ TXMLManifestType }

procedure TXMLManifestType.AfterConstruction;
begin
  RegisterChildNode('Reference', TXMLReferenceType);
  ItemTag := 'Reference';
  ItemInterface := IXMLReferenceType;
  inherited;
end;

function TXMLManifestType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLManifestType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLManifestType.Get_Reference(Index: Integer): IXMLReferenceType;
begin
  Result := List[Index] as IXMLReferenceType;
end;

function TXMLManifestType.Add: IXMLReferenceType;
begin
  Result := AddItem(-1) as IXMLReferenceType;
end;

function TXMLManifestType.Insert(const Index: Integer): IXMLReferenceType;
begin
  Result := AddItem(Index) as IXMLReferenceType;
end;

{ TXMLSignaturePropertiesType }

procedure TXMLSignaturePropertiesType.AfterConstruction;
begin
  RegisterChildNode('SignatureProperty', TXMLSignaturePropertyType);
  ItemTag := 'SignatureProperty';
  ItemInterface := IXMLSignaturePropertyType;
  inherited;
end;

function TXMLSignaturePropertiesType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLSignaturePropertiesType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

function TXMLSignaturePropertiesType.Get_SignatureProperty(Index: Integer): IXMLSignaturePropertyType;
begin
  Result := List[Index] as IXMLSignaturePropertyType;
end;

function TXMLSignaturePropertiesType.Add: IXMLSignaturePropertyType;
begin
  Result := AddItem(-1) as IXMLSignaturePropertyType;
end;

function TXMLSignaturePropertiesType.Insert(const Index: Integer): IXMLSignaturePropertyType;
begin
  Result := AddItem(Index) as IXMLSignaturePropertyType;
end;

{ TXMLSignaturePropertyType }

function TXMLSignaturePropertyType.Get_Target: UnicodeString;
begin
  Result := AttributeNodes['Target'].Text;
end;

procedure TXMLSignaturePropertyType.Set_Target(Value: UnicodeString);
begin
  SetAttribute('Target', Value);
end;

function TXMLSignaturePropertyType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['Id'].Text;
end;

procedure TXMLSignaturePropertyType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('Id', Value);
end;

{ TXMLString_List }

function TXMLString_List.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLString_List.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLString_List.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

{ TXMLBase64BinaryList }

function TXMLBase64BinaryList.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLBase64BinaryList.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLBase64BinaryList.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

end.