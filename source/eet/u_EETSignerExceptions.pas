{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

unit u_EETSignerExceptions;

interface
uses SysUtils;

resourcestring

sXMLNotXML = 'Pøijmutá odpovìï není XML';
sXMLEmpty = 'XML zpráva je prázdná';
sXMLURIEmpty = 'URI pro hlášení EET není vyplnìna';
sXMLInvalidSignature = 'Neplatný digitalní podpis';
sSignerUnassigned = 'EETSigner neni definován';
sSignerInactive   = 'EETSigner neni aktivován';
sSignerActive   = 'EETSigner je již aktivován';
sSignerNoPassword = 'Není zadáno heslo k certifikátu';
//sSignerNoCert = 'Uložištì cerfikátù neobsahuje certifikáty';
sSignerInvalidVerifyCert = 'Certifikát ovìøení není platný';
//aSignerNoPFXCert = 'Privátní klíè není naèten';
sSignerInvalidPFXCert = 'Neplatný soukromý certifikát nebo heslo.';
sSignerXmlSecInitError = 'Neúšpìšná inicializace xmlsec';
sSignerLibEETInitLibError = 'Neúšpìšná inicializace libeet';
sSignerLibEETSignerInitError = 'Neúšpìšná inicializace eetSignerInit';
sSignerInitWrongDll = 'Neplatná verze knihovny xmlsec.dll.';
sSignerInitNoXmlsecOpensslDll = 'EETSigner: Nenalezena potøebná crypto knihovna openssl.';
sSignerInitNoXmlsecMSCryptoDll = 'EETSigner: Nenalezena potøebná crypto knihovna mscrypto.';
sSignerKeyMngrCreateFail = 'Nepodaøilo se vytvoøit uložištì klíèù, funkce: xmlSecKeysMngrCreate()';
sSignerTransformCtxFail  = 'Nepodaøilo se inicializovat transformaci kontextu';
sSignerSignFail = 'Chyba pøi podepisování, funkce: %s';
sSignerVerifyFail = 'Chyba pøi ovìøování XML, funkce: %s';
sSignerUnexpectedSignature = 'Chyba pøihlášení - neoèekáváná velikost podpisu od %d B';
sSignerNoCertificateFile = 'Centifikát v uložišti nenalezen';
sSignerEmptyXML  = 'XML data jsou prázdná';
sSignerGetRawData = 'Chyba pøi získávání dat certikátu, funkce : %s';

type
  {: @abstract(XML dokument nije ispravan)}
  EEETXMLException = class(Exception);

  {: @abstract(Pogreška potpisivanja)}
  EEETSignerException = class (Exception);

implementation

end.
