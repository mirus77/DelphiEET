Unit libxmlsec_openssl;
{.$DEFINE _DYNAMIC_LOAD_XMLSEC}
{$I EETDefines.inc}

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses SysUtils, Classes, libxml2, libxmlsec, libeay32;

const
{$IFDEF MSWINDOWS}
  LIBXMLSECOPENSSL_SO = {$IFNDEF USE_VS_LIBS}'libxmlsec1-openssl.dll'{$ELSE}'libxmlsec-openssl.dll'{$ENDIF};
{$ELSE}
  LIBXMLSECOPENSSL_SO = 'libxmlsec-openssl.so';
{$ENDIF}

// InitXMLSecOpenSSL always returns true if static linking - does nothing else.
function InitXMLSecOpenSSL(const path: string = ''): Boolean;
// FreeXMLSecOpenSSL does nothing for static linking. Otherwise it decrements a ref
// count and eventually unloads the libxmlsec-openssl.dll. Returns true if library is finally
// unloaded.
function FreeXMLSecOpenSSL: Boolean;

{$IFNDEF _DYNAMIC_LOAD_XMLSEC}
function xmlSecOpenSSLAppKeysMngrAddCertsFile(mngr: xmlSecKeysMngrPtr; const filename: PAnsiChar): Longint; cdecl;
function xmlSecOpenSSLAppKeysMngrCertLoadMemory(mngr: xmlSecKeysMngrPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize;
  format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType): Longint; cdecl;
function xmlSecOpenSSLKeyDataX509GetKlass(): xmlSecKeyDataId; cdecl;
function xmlSecOpenSSLKeyDataX509GetKeyCert(data: xmlSecKeyDataPtr): PX509; cdecl;
function xmlSecOpenSSLKeyDataX509GetCert(data: xmlSecKeyDataPtr; Idx : LongInt): PX509; cdecl;
function xmlSecOpenSSLKeyDataX509GetCertsSize(data: xmlSecKeyDataPtr): LongInt; cdecl;
{$ENDIF}  // static linking

// internal macros
function xmlSecKeyDataIsValid(data: xmlSecKeyDataPtr): Boolean;
function xmlSecKeyDataCheckId(data: xmlSecKeyDataPtr; dataId: xmlSecKeyDataId): Boolean;
function xmlSecOpenSSLKeyDataX509Id: xmlSecKeyDataId;
// internal macros

function xmlSecOpenSSLX509CertGetTime(asn1_time: PASN1_TIME; var res: TDateTime): Longint;
function xmlSecOpenSSLX509CertGetSerialNumber(SN: pASN1_INTEGER; var res: string): Longint;
function xmlSecOpenSSLX509CertGetX509Name(Subj: pX509_NAME; var res: string): Longint;
function xmlSecOpenSSLX509CertBase64DerWrite(cert : pX509; base64LineWrap : Integer): string;

{$IFDEF DEBUG}
procedure _xmlSecKeyDebugDump(Key: xmlSecKeyPtr; filename: xmlCharPtr);
procedure _xmlDocDump(Doc: xmlDocPtr; filename: xmlCharPtr);
procedure _xmlSecDSignDebugDump(DSignCtx: xmlSecDSigCtxPtr; filename: xmlCharPtr);
{$ENDIF}

{$IFDEF _DYNAMIC_LOAD_XMLSEC}
var
  xmlSecOpenSSLAppKeysMngrAddCertsFile : function (mngr: xmlSecKeysMngrPtr; const filename: PAnsiChar): Longint; cdecl;
  xmlSecOpenSSLAppKeysMngrCertLoadMemory : function (mngr: xmlSecKeysMngrPtr; const data: xmlSecBytePtr; dataSize: xmlSecSize; format: xmlSecKeyDataFormat; type_: xmlSecKeyDataType): Longint; cdecl;
  xmlSecOpenSSLKeyDataX509GetKlass : function (): xmlSecKeyDataId; cdecl;
  xmlSecOpenSSLKeyDataX509GetKeyCert : function (data: xmlSecKeyDataPtr): PX509; cdecl;
  xmlSecOpenSSLKeyDataX509GetCert : function(data: xmlSecKeyDataPtr; Idx : LongInt): PX509 cdecl;
  xmlSecOpenSSLKeyDataX509GetCertsSize : function(data: xmlSecKeyDataPtr): LongInt; cdecl;
{$ENDIF}

implementation

uses
{$IFDEF _DYNAMIC_LOAD_XMLSEC}
  SyncObjs,
{$ENDIF}
{$IFDEF DEBUG}
  vcruntime,
{$ENDIF}
  Windows, u_EETSignerExceptions, DateUtils{$IF RTLVersion >= 25}, AnsiStrings{$IFEND};

{$IFNDEF _DYNAMIC_LOAD_XMLSEC}
function xmlSecOpenSSLAppKeysMngrAddCertsFile; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLAppKeysMngrCertLoadMemory; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLKeyDataX509GetKlass; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLKeyDataX509GetKeyCert; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLKeyDataX509GetCert; external LIBXMLSECOPENSSL_SO;
function xmlSecOpenSSLKeyDataX509GetCertsSize; external LIBXMLSECOPENSSL_SO;
{$ENDIF}

{$IFDEF _DYNAMIC_LOAD_XMLSEC}
var
  FXmlSecLibHandle: THandle = 0;
  Lock: TCriticalSection;
  ReferenceCount: Integer = 0;
{$ENDIF}

{$IFNDEF _DYNAMIC_LOAD_XMLSEC}
function InitXMLSecOpenSSL(const path: string): Boolean;
begin
  Result := true;
end;

function FreeXMLSecOpenSSL: Boolean;
begin
  Result := true;  // static linked is never unloaded as such
end;
{$ENDIF}

function BytesToHexString(APtr: Pointer; ALen: Integer): String;
{$IFDEF USE_INLINE} inline; {$ENDIF}
var
  i: Integer;
  LPtr: PByte;
begin
  Result := '';
  LPtr := PByte(APtr);
  for i := 0 to (ALen - 1) do begin
    if i <> 0 then begin
      Result := Result + ':'; { Do not Localize }
    end;
    Result := Result + Format('%.2x', [LPtr^]);
    Inc(LPtr);
  end;
end;

function ASN1String_To_UTF8(aText : String) : string;
var
  buff: String;
  I : Integer;
  iLen : Integer;
  Ch : AnsiChar;
begin
  Result := '';
  iLen := Length(aText);
  setLength(buff, 2);
  I := 1;
  while I <= iLen do
    begin
      if aText[I] = '\' then
        begin
          if (I + 3) < iLen then
            begin
              if aText[I+1] = 'x' then
                begin
                  Inc(I);
                  Inc(I);
                  buff[1] := aText[I];
                  Inc(I);
                  buff[2] := aText[I];
                  Ch := #0;
                  HexToBin(PChar(LowerCase(buff)), @ch, 1);
                  Result := Result + string(ch);
                end
              else
                Result := Result + aText[I];
            end
          else
            Result := Result + aText[I];
        end
      else
        Result := Result + aText[I];
      Inc(I);
    end;
end;

{$IFDEF DEBUG}
procedure _xmlSecKeyDebugDump(Key: xmlSecKeyPtr; filename: xmlCharPtr);
var
  fOutput: PFILE;
begin
  fOutput := crt_fopen(filename, PAnsiChar(string('w')));
  if fOutput <> nil then
  begin
    xmlSecKeyDebugDump(Key, fOutput);
    crt_fclose(fOutput);
  end;
end;

procedure _xmlDocDump(Doc: xmlDocPtr; filename: xmlCharPtr);
var
  fOutput: PFILE;
begin
  fOutput := crt_fopen(filename, PAnsiChar(string('w')));
  if fOutput <> nil then
  begin
    xmlDocDump(fOutput, Doc);
    crt_fclose(fOutput);
  end;
end;

procedure _xmlSecDSignDebugDump(DSignCtx: xmlSecDSigCtxPtr; filename: xmlCharPtr);
var
  fOutput: PFILE;
begin
  fOutput := crt_fopen(filename, PAnsiChar(string('w')));
  if fOutput <> nil then
  begin
    xmlSecDSigCtxDebugDump(DSignCtx, fOutput);
    crt_fclose(fOutput);
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
  TimeZone: TTimeZoneInformation;

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
  {$IF RTLVersion >= 25}AnsiStrings.{$IFEND}StrLCopy(@buffer, asn1_time.data, asn1_time.length);
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
      begin
        GetTimeZoneInformation(TimeZone);
        tz := TimeZone.Bias div -60;  //pro ÈR buï 1 nebo 2
//        tz := DateUtils.TTimeZone.Local.UtcOffset.Hours;
      end;
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
      begin
        GetTimeZoneInformation(TimeZone);
        tz := TimeZone.Bias div -60;  //pro ÈR buï 1 nebo 2
//        tz := DateUtils.TTimeZone.Local.UtcOffset.Hours;
      end;
  end;
  if tz > 0 then
    res := IncHour(EncodeDateTime(Y, M, D, h, n, s, 0), tz)
  else
    res := EncodeDateTime(Y, M, D, h, n, s, 0);
end;

function xmlSecOpenSSLX509CertGetSerialNumber(SN: pASN1_INTEGER; var res: string): Longint;
begin
  Result := 0;
  res := BytesToHexString(SN.data, SN.length);
end;

function xmlSecOpenSSLX509CertGetX509Name(Subj: pX509_NAME; var res: string): Longint;
var
  LOneLine: array[0..2048] of AnsiChar;
begin
  Result := 0;
  if Subj = nil then
    res := ''
  else
  {$IFDEF UNICODE}
    res := UTF8ToWideString(AnsiString(ASN1String_To_UTF8(string(X509_NAME_oneline(Subj, @LOneLine[0], SizeOf(LOneLine))))));
  {$ELSE}
    res := UTF8Decode(AnsiString(ASN1String_To_UTF8(string(X509_NAME_oneline(Subj, @LOneLine[0], SizeOf(LOneLine))))));
  {$ENDIF}
end;

function xmlSecOpenSSLX509CertBase64DerWrite(cert : pX509; base64LineWrap : Integer): string;
var
  mem : pBIO;
  p : xmlSecBytePtr;
  size : LongInt;
begin
  Result := '';
  if cert <> nil then
    begin
      mem := BIO_new(BIO_s_mem());
      try
        if mem <> nil then
          begin
            i2d_X509_bio(mem, cert);
            BIO_flush(mem);
            size := BIO_get_mem_data(mem, PAnsiChar(p));
            if (size > 0) and (p <> nil) then
              begin
                Result := string(xmlSecBase64Encode(p, size, base64LineWrap));
              end;
          end;
      finally
        BIO_free_all(mem);
      end;
    end;
end;

{$IFDEF _DYNAMIC_LOAD_XMLSEC}
function InitXMLSecOpenSSL(const path: string): Boolean;
begin
  Lock.Enter;
  try
    Inc(ReferenceCount);
    if FXmlSecLibHandle = 0 then
      begin
        if path <> '' then
          SetDllDirectory(PChar(path));
        FXmlSecLibHandle := LoadLibrary(LIBXMLSECOPENSSL_SO);
        if FXmlSecLibHandle > 0 then
          begin
            xmlSecOpenSSLAppKeysMngrAddCertsFile :=  GetProcAddress(FXmlSecLibHandle, 'xmlSecOpenSSLAppKeysMngrAddCertsFile');
            xmlSecOpenSSLAppKeysMngrCertLoadMemory :=  GetProcAddress(FXmlSecLibHandle, 'xmlSecOpenSSLAppKeysMngrCertLoadMemory');
            xmlSecOpenSSLKeyDataX509GetKlass :=  GetProcAddress(FXmlSecLibHandle, 'xmlSecOpenSSLKeyDataX509GetKlass');
            xmlSecOpenSSLKeyDataX509GetKeyCert :=  GetProcAddress(FXmlSecLibHandle, 'xmlSecOpenSSLKeyDataX509GetKeyCert');
            xmlSecOpenSSLKeyDataX509GetCert := GetProcAddress(FXmlSecLibHandle, 'xmlSecOpenSSLKeyDataX509GetCertsSize');
            xmlSecOpenSSLKeyDataX509GetCertsSize :=  GetProcAddress(FXmlSecLibHandle, 'xmlSecOpenSSLKeyDataX509GetCertsSize');
          end;
      end;

    Result := FXmlSecLibHandle > 0;
  finally
    Lock.Leave;
  end;
end;

function FreeXMLSecOpenSSL: Boolean;
begin
  Lock.Enter;
  try
    if ReferenceCount > 0 then
      Dec(ReferenceCount);

    if (FXmlSecLibHandle <> 0) and (ReferenceCount = 0) then
    begin
      FXmlSecLibHandle := 0;

      xmlSecOpenSSLAppKeysMngrAddCertsFile    := nil;
      xmlSecOpenSSLAppKeysMngrCertLoadMemory  := nil;
      xmlSecOpenSSLKeyDataX509GetKlass        := nil;
      xmlSecOpenSSLKeyDataX509GetKeyCert      := nil;
      xmlSecOpenSSLKeyDataX509GetCert         := nil;
      xmlSecOpenSSLKeyDataX509GetCertsSize    := nil;
    end;
    Result := FXmlSecLibHandle = 0;
  finally
    Lock.Leave;
  end;
end;

initialization
  Lock := TCriticalSection.Create;
  InitXMLSecOpenSSL('');

finalization
  while ReferenceCount > 0 do
    FreeXMLSecOpenSSL;
  Lock.Free;
{$ENDIF}
end.
