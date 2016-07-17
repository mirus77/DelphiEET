{*******************************************************}
{                                                       }
{                Delphi Runtime Library                 }
{                  SOAP Support                         }
{                                                       }
{ Copyright(c) 1995-2015 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}

unit Soap.SOAPEnv;

interface

uses
  Soap.OPConvert, Xml.XMLIntf;

const
  MySSoapNameSpacePre : string = 'soap';

type
  TSoapEnvelope = class
  public
    function MakeEnvelope(Doc: IXMLDocument; Options: TSOAPConvertOptions): IXMLNode;
    function MakeHeader(ParentNode: IXMLNode; Options: TSOAPConvertOptions): IXMLNode;
    function MakeBody(ParentNode: IXMLNode; Options: TSOAPConvertOptions): IXMLNode;
    function MakeFault(ParentNode: IXMLNode; Options: TSOAPConvertOptions): IXMLNode;
  end;

implementation

uses
  Soap.SOAPConst, Soap.OpConvertOptions;

function TSoapEnvelope.MakeEnvelope(Doc: IXMLDocument; Options: TSOAPConvertOptions): IXMLNode;
begin
  Doc.AddChild(MySSoapNameSpacePre + ':' + SSoapEnvelope, SoapEnvelopeNamespaces[soSOAP12 in Options]);
  Result := Doc.DocumentElement;
  Result.DeclareNamespace(SXMLSchemaNameSpacePre, XMLSchemaNameSpace);
  Result.DeclareNamespace(SXMLSchemaInstNameSpace99Pre, XMLSchemaInstNameSpace);
  if not (soDocument in Options) then
    Result.DeclareNamespace(SSoapEncodingPre, SoapEncodingNamespaces[soSOAP12 in Options]);
end;


function TSoapEnvelope.MakeBody(ParentNode: IXMLNode; Options: TSOAPConvertOptions): IXMLNode;
begin
   Result := ParentNode.AddChild(MySSoapNameSpacePre + ':' + SSoapBody, SoapEnvelopeNamespaces[soSOAP12 in Options]);
end;

function TSoapEnvelope.MakeHeader(ParentNode: IXMLNode; Options: TSOAPConvertOptions): IXMLNode;
begin
  Result := ParentNode.AddChild(SSoapNameSpacePre + ':' + SSoapHeader, SoapEnvelopeNamespaces[soSOAP12 in Options]);
end;

function TSoapEnvelope.MakeFault(ParentNode: IXMLNode; Options: TSOAPConvertOptions): IXMLNode;
begin
   Result := ParentNode.AddChild(MySSoapNameSpacePre + ':' + SSoapFault, SoapEnvelopeNamespaces[soSOAP12 in Options]);
end;

end.
