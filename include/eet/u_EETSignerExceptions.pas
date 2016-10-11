unit u_EETSignerExceptions;

interface
uses SysUtils;

resourcestring

sXMLNeispravanOIB = 'Neispravan OIB';
sXMLZaglavljeNejednako = 'Zaprimljeno i poslano zaglavlje se ne podudaraju';
sXMLNotXML = 'Pøijmutá odpoveï není XML';
sXMLNoJIR = 'Nema JIR elemnta';
sXMLMissingZKData = 'Nisu poznati svi podaci za generiranje zaštitnog koda';
sXMLEmpty = 'XML zpráva je prazdná';
sXMLURIEmpty = 'URI pro hlášení EET není vyplnìna';
sXMLInvalidValue = 'Nedozvoljena vrijednost za %s';
sXMLInvalidSignature = 'Neispravan digitalni potpis';
sXMLInvalidSignatureZK = 'Neispravan digitalni potpis ZK';
sSignerUnassigned = 'Signer neni definován';
sSignerInactive   = 'Signer neni aktivován';
sSignerActive   = 'Signer je jiz aktivován';
sSignerNoPassword = 'Není zadáno heslo k certifikátu';
sSignerNoCert = 'Uložištì cerfikátnu neobsahuje certifikáty';
sSignerInvalidVerifyCert = 'Verifikacijski certifikat nije valjan';
aSignerNoPFXCert = 'Privátní klíè není naèten';
sSignerInvalidPFXCert = 'Neispravan privatni certifikat ili lozinka.';
sSignerXmlSecInitError = 'Neuspjela xmlsec inicijalizacija';
sSignerInitWrongDll = 'Neplatná verze knihovny xmlsec.dll.';
sSignerInitNoXmlsecOpensslDll = 'EETSigner: Nenalezena potøebná crypto knihovna openssl.';
sSignerInitNoXmlsecMSCryptoDll = 'EETSigner: Nenalezena potøebná crypto knihovna mscrypto.';
sSignerKeyMngrCreateFail = 'Nepodaøilo se vytvoøit uložištì klíèù, funkce: xmlSecKeysMngrCreate()';
sSignerDSigCtxCreateFail = 'Nepodaøiro se vytvoøit podpis DSign v kontextu';
sSignerTransformCtxFail  = 'Nepodarilo se inicializovat trasformaci kontextu';
sSignerSignFail = 'Chyba pøi podepisování, funkce: %s';
sSignerVerifyFail = 'Chyba pøi ovìøování XML, funkce: %s';
sSignerUnexpectedSignature = 'Greška potpisivanja - neoèekivana velièina potpisa od %d B';
sSignerNoCertificateFile = 'Nije navedena datoteka s certifikatom';
sSignerEmptyXML  = 'XML data jsou prázdná';
sSignerGetRawData = 'Chyba pøi získávání dat certikátu, funkce : %s';
sNedozvoljenNacinPlacanja = 'Nedozvoljen naèin plaæanja';
sNedozvoljenaOznakaSlijednosti = 'Nedozvoljena oznaka slijednosti';

sLudiServer = 'Ovo se NIKAKO nije smjelo dogoditi. Server je podivljao - vratio je http kod %d i poruku greške: %s';
sNotSOAPXML = 'Zaprimljeni dokument nije XML SOAP. server je vratio http kod %d i poruku greške: %s';

type
  {: @abstract(XML dokument nije ispravan)}
  EEETXMLException = class(Exception);

  {: @abstract(Pogreška potpisivanja)}
  EEETSignerException = class (Exception);

implementation

end.
