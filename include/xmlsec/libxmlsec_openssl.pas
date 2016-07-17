Unit libxmlsec_openssl;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses libxmlsec;

const
{$IFDEF WIN32}
  LIBXMLSECOPENSSL_SO = 'libxmlsec1-openssl.dll';
{$ELSE}
  LIBXMLSECOPENSSL_SO = 'libxmlsec1-openssl.so';
{$ENDIF}


function xmlSecOpenSSLAppKeysMngrAddCertsFile(mngr : xmlSecKeysMngrPtr; const filename : PAnsiChar) : Longint; cdecl; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLAppKeysMngrCertLoadMemory(mngr: xmlSecKeysMngrPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType) : LongInt;  cdecl; external LIBXMLSECOPENSSL_SO;

implementation

end.