Unit libxmlsec_openssl;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses System.SysUtils, System.TimeSpan,  libxml2, libxmlsec, libeay32;

const
{$IFDEF WIN32}
  LIBXMLSECOPENSSL_SO = 'libxmlsec1-openssl.dll';
{$ELSE}
  LIBXMLSECOPENSSL_SO = 'libxmlsec1-openssl.so';
{$ENDIF}
  LIBMSVCRT = 'msvcrt.dll';

function xmlSecOpenSSLAppKeysMngrAddCertsFile(mngr: xmlSecKeysMngrPtr; const filename: PAnsiChar): Longint; cdecl;
  external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLAppKeysMngrCertLoadMemory(mngr: xmlSecKeysMngrPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize;
  format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType): Longint; cdecl; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLKeyDataX509GetKlass(): xmlSecKeyDataId; cdecl; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLKeyDataX509GetKeyCert(data: xmlSecKeyDataPtr): PX509; cdecl; external LIBXMLSECOPENSSL_SO;

function xmlSecKeyDataIsValid(data: xmlSecKeyDataPtr): Boolean;
function xmlSecKeyDataCheckId(data: xmlSecKeyDataPtr; dataId: xmlSecKeyDataId): Boolean;
function xmlSecOpenSSLKeyDataX509Id: xmlSecKeyDataId;
function xmlSecOpenSSLX509CertGetTime(asn1_time: PASN1_TIME; var res: TDateTime): Longint;

{$IFDEF DEBUG}
procedure _xmlSecKeyDebugDump(Key: xmlSecKeyPtr; filename: xmlCharPtr);
{$ENDIF}

implementation

uses u_EETSignerExceptions, System.DateUtils, System.AnsiStrings;

{$IFDEF DEBUG}
function fopen(const filename, mode: PAnsiChar): PFILE; cdecl; external LIBMSVCRT;
function fclose(stream: PFILE): Integer; cdecl; external LIBMSVCRT;
{$ENDIF}
{$IFDEF DEBUG}

procedure _xmlSecKeyDebugDump(Key: xmlSecKeyPtr; filename: xmlCharPtr);
var
  fOutput: PFILE;
begin
  fOutput := fopen(filename, PAnsiChar(string('w')));
  if fOutput <> nil then
  begin
    xmlSecKeyDebugDump(Key, fOutput);
    fclose(fOutput);
  end;
end;
{$ENDIF}

function xmlSecKeyDataIsValid(data: xmlSecKeyDataPtr): Boolean;
begin
  Result := false;
  if (data <> nil) then
    if (data.id <> nil) then
      Result := (data.id.klassSize >= sizeof(xmlSecKeyDataKlass)) and (data.id.objSize >= sizeof(xmlSecKeyData)) and
        (data.id.name <> nil);
end;

function xmlSecKeyDataCheckId(data: xmlSecKeyDataPtr; dataId: xmlSecKeyDataId): Boolean;
begin
  Result := false;
  if (data <> nil) then
    if (data.id <> nil) then
      Result := xmlSecKeyDataIsValid((data)) and ((data.id = dataId))
end;

function xmlSecOpenSSLKeyDataX509Id: xmlSecKeyDataId;
begin
  Result := xmlSecOpenSSLKeyDataX509GetKlass;
end;

function xmlSecOpenSSLX509CertGetTime(asn1_time: PASN1_TIME; var res: TDateTime): Longint;
var
  buffer: array [0 .. 31] of AnsiChar;
  tz, Y, M, D, h, n, s: Integer;

  function Char2Int(D, u: AnsiChar): Integer;
  begin
    if (D < '0') or (D > '9') or (u < '0') or (u > '9') then
      raise EEETSignerException.Create('Invalid ASN1 date format (invalid char).');
    Result := (Ord(D) - Ord('0')) * 10 + Ord(u) - Ord('0');
  end;

begin
  Result := 0;
  {
    i2d_ASN1_TIME(asn1_time, @buffer2);
    if buffer='' then
    result := time
    else
    result := 0;
  }
  if (asn1_time.asn1_type <> V_ASN1_UTCTIME) and (asn1_time.asn1_type <> V_ASN1_GENERALIZEDTIME) then
    raise EEETSignerException.Create('Invalid ASN1 date format.');
  tz := 0;
  s := 0;
  Y := 0; M := 0; D := 0; h := 0; n := 0;
  System.AnsiStrings.StrLCopy(@buffer, asn1_time.data, asn1_time.length);
  if asn1_time.asn1_type = V_ASN1_UTCTIME then
  begin
    if asn1_time.length < 10 then
      raise EEETSignerException.Create('Invalid ASN1 UTC date format (too short).');
    Y := Char2Int(buffer[0], buffer[1]);
    if Y < 50 then
      Y := Y + 100;
    Y := Y + 1900;
    M := Char2Int(buffer[2], buffer[3]);
    D := Char2Int(buffer[4], buffer[5]);
    h := Char2Int(buffer[6], buffer[7]);
    n := Char2Int(buffer[8], buffer[9]);
    if (buffer[10] >= '0') and (buffer[10] <= '9') and (buffer[11] >= '0') and (buffer[11] <= '9') then
      s := Char2Int(buffer[10], buffer[11]);
    if buffer[asn1_time.length - 1] = 'Z' then
      tz := System.DateUtils.TTimeZone.Local.UtcOffset.Hours;
  end
  else if asn1_time.asn1_type = V_ASN1_GENERALIZEDTIME then
  begin
    if asn1_time.length < 12 then
      raise EEETSignerException.Create('Invalid ASN1 generic date format (too short).');
    Y := Char2Int(buffer[0], buffer[1]) * 100 + Char2Int(buffer[2], buffer[3]);;
    M := Char2Int(buffer[4], buffer[5]);
    D := Char2Int(buffer[6], buffer[7]);
    h := Char2Int(buffer[8], buffer[9]);
    n := Char2Int(buffer[10], buffer[11]);
    if (buffer[12] >= '0') and (buffer[12] <= '9') and (buffer[13] >= '0') and (buffer[13] <= '9') then
      s := Char2Int(buffer[12], buffer[13]);
    if buffer[asn1_time.length - 1] = 'Z' then
      tz := System.DateUtils.TTimeZone.Local.UtcOffset.Hours;
  end;
  if tz > 0 then
    res := IncHour(EncodeDateTime(Y, M, D, h, n, s, 0), tz)
  else
    res := EncodeDateTime(Y, M, D, h, n, s, 0);
end;

end.
