unit u_libeet;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}
{$M+}

{$IF CompilerVersion >= 24.0}
  {$LEGACYIFEND ON}
{$IFEND}

const
  LIBEET_SO : string = 'libeetsigner.dll';

type
  TlibeetLogEvent  = procedure(const file_: string; line: Longint; const func: string; const errorObject: string; const errorSubject: string; reason: Longint; const msg: string) of object;

  time_t = Int64;
  size_t = Longint;
  time_tPtr = ^time_t;

  xmlCharPtr = PAnsiChar;
  xmlCharPtrPtr = ^xmlCharPtr;

  libeetX509Ptr = ^Pointer;

{$IFDEF USE_LIBEET}
  xmlSecKeysMngr = Pointer;
  xmlSecKeysMngrPtr = ^xmlSecKeysMngr;

  eetSignerKeysMngrCreateFunc = function() : xmlSecKeysMngrPtr; cdecl;
  eetSignerKeysMngrCreateFuncPtr = ^eetSignerKeysMngrCreateFunc;

  eetSignerKeysMngrDestroyMethod = procedure(mngr : xmlSecKeysMngrPtr); cdecl;
  eetSignerKeysMngrDestroyMethodPtr = ^eetSignerKeysMngrDestroyMethod;

  eetSignerSetDefaultKeysMngrMethod = procedure(mngr : xmlSecKeysMngrPtr); cdecl;
  eetSignerSetDefaultKeysMngrMethodPtr = ^eetSignerSetDefaultKeysMngrMethod;
{$ENDIF}

  xmlSecPtr = Pointer;
  xmlSecPtrPtr = ^xmlSecPtr;

  xmlSecSize = Cardinal;
  xmlSecSizePtr = ^xmlSecSize;

  libeetErrorsCallbackMethod = procedure (const file_: PAnsiChar; line: Longint; const func: PAnsiChar; const errorObject: PChar; const errorSubject: PAnsiChar; reason: Longint; const msg: PAnsiChar); cdecl;
  libeetErrorsCallbackMethodPtr = ^libeetErrorsCallbackMethod;

  libeetErrorsSetCallbackMethod = procedure (Callback : libeetErrorsCallbackMethod); cdecl;
  libeetErrorsSetCallbackMethodPtr = ^libeetErrorsSetCallbackMethod;

  libeetErrorsDefaultCallbackMethod = procedure(const file_: PAnsiChar; line: Longint; const func: PAnsiChar; const errorObject: PAnsiChar; const errorSubject: PAnsiChar; reason: Longint; const msg: PAnsiChar); cdecl;
  libeetErrorsDefaultCallbackMethodPtr = ^libeetErrorsDefaultCallbackMethod;

  libeetErrorsDefaultCallbackEnableOutputMethod = procedure (enabled: Longint); cdecl;
  libeetErrorsDefaultCallbackEnableOutputMethodPtr = ^libeetErrorsDefaultCallbackEnableOutputMethod;

  libeetErrorsGetCodeFunc = function (pos: xmlSecSize) : Longint; cdecl;
  libeetErrorsGetCodeFuncPtr = ^libeetErrorsGetCodeFunc;

  libeetErrorsGetMsgFunc = function (pos: xmlSecSize) : PAnsiChar; cdecl;
  libeetErrorsGetMsgFuncPtr = ^libeetErrorsGetMsgFunc;

  eetMallocFunc = function(size: size_t) : Pointer; cdecl;
  eetMallocFuncPtr = ^eetMallocFunc;

  eetCallocFunc = function(size: size_t) : Pointer; cdecl;
  eetCallocFuncPtr = ^eetCallocFunc;

  eetFreeMethod = procedure(ptr: Pointer); cdecl;
  eetFreeMethodPtr = ^eetFreeMethod;

  eetSignerInitFunc = function:LongInt; cdecl;
  eetSignerInitFuncPtr = ^eetSignerInitFunc;

  eetSignerCleanUpMethod = procedure; cdecl;
  eetSignerCleanUpMethodPtr = ^eetSignerCleanUpMethod;

  eetSignerShutdownMethod = procedure(); cdecl;
  eetSignerShutdownMethodPtr = ^eetSignerShutdownMethod;

  eetSignerLoadPFXKeyFileFunc = function(mngr : xmlSecKeysMngrPtr; filename : xmlCharPtr; pwd : xmlCharPtr) : LongInt; cdecl;
  eetSignerLoadPFXKeyFileFuncPtr = ^eetSignerLoadPFXKeyFileFunc;

  eetSignerLoadPFXKeyMemoryFunc = function(mngr : xmlSecKeysMngrPtr; data : xmlCharPtr; dataSize : LongInt; pwd : xmlCharPtr) : LongInt; cdecl;
  eetSignerLoadPFXKeyMemoryFuncPtr = ^eetSignerLoadPFXKeyMemoryFunc;

  eetSignerAddTrustedCertFileFunc = function(mngr : xmlSecKeysMngrPtr; filename : xmlCharPtr) : LongInt; cdecl;
  eetSignerAddTrustedCertFileFuncPtr = ^eetSignerAddTrustedCertFileFunc;

  eetSignerAddTrustedCertMemoryFunc = function(mngr : xmlSecKeysMngrPtr; data : xmlCharPtr; dataSize : LongInt) : LongInt; cdecl;
  eetSignerAddTrustedCertMemoryFuncPtr = ^eetSignerAddTrustedCertMemoryFunc;

  eetSignerSignStringFunc = function(mngr : xmlSecKeysMngrPtr; data : xmlCharPtr) : xmlCharPtr; cdecl;
  eetSignerSignStringFuncPtr = ^eetSignerSignStringFunc;

  eetSignerMakePKPFunc = function(mngr : xmlSecKeysMngrPtr; data : xmlCharPtr) : xmlCharPtr; cdecl;
  eetSignerMakePKPFuncPtr = ^eetSignerMakePKPFunc;

  eetSignerMakeBKPFunc = function(mngr : xmlSecKeysMngrPtr; data : xmlCharPtr) : xmlCharPtr; cdecl;
  eetSignerMakeBKPFuncPtr = ^eetSignerMakeBKPFunc;

  eetSignerSignRequestFunc = function(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt; outbufp : xmlCharPtrPtr) : Longint cdecl;
  eetSignerSignRequestFuncPtr = ^eetSignerSignRequestFunc;

  eetSignerVerifyResponseFunc = function(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt) : LongInt; cdecl;
  eetSignerVerifyResponseFuncPtr = ^eetSignerVerifyResponseFunc;

  eetSignerGetRawCertDataAsBase64StringFunc = function(mngr : xmlSecKeysMngrPtr) : xmlCharPtr; cdecl;
  eetSignerGetRawCertDataAsBase64StringFuncPtr = ^eetSignerGetRawCertDataAsBase64StringFunc;

  eetSignerlibeetVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerlibeetVersionFuncPtr = ^eetSignerlibeetVersionFunc;

  eetSignerlibXmlVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerlibXmlVersionFuncdPtr = ^eetSignerlibXmlVersionFunc;

  eetSignerxmlSecVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerxmlSecVersionFuncPtr = ^eetSignerxmlSecVersionFunc;

  eetSignerCryptoVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerCryptoVersionFuncPtr = ^eetSignerCryptoVersionFunc;

  eetSignerGetX509KeyCertFunc = function(mngr : xmlSecKeysMngrPtr) : libeetX509Ptr; cdecl;
  eetSignerGetX509KeyCertFuncPtr = ^eetSignerGetX509KeyCertFunc;

  eetSignerX509GetSubjectFunc = function(pX509Cert : libeetX509Ptr; Subject : xmlCharPtrPtr) : LongInt; cdecl;
  eetSignerX509GetSubjectFuncPtr = ^eetSignerX509GetSubjectFunc;

  eetSignerX509GetSerialNumFunc = function(pX509Cert : libeetX509Ptr; SerialNum : xmlCharPtrPtr) : LongInt; cdecl;
  eetSignerX509GetSerialNumFuncPtr = ^eetSignerX509GetSerialNumFunc;

  eetSignerX509GetValidDateFunc = function(pX509Cert : libeetX509Ptr; notBefore : time_tPtr; notAfter : time_tPtr) : LongInt; cdecl;
  eetSignerX509GetValidDateFuncPtr = ^eetSignerX509GetValidDateFunc;

  eetSignerX509GetIssuerNameFunc = function(pX509Cert : libeetX509Ptr; IssuerName : xmlCharPtrPtr) : LongInt; cdecl;
  eetSignerX509GetIssuerNameFuncPtr = ^eetSignerX509GetIssuerNameFunc;

  eetSignerUTCToLocalTimeFunc = function(UTCTime : time_tPtr): time_tPtr; cdecl;
  eetSignerUTCToLocalTimeFuncPtr = ^eetSignerUTCToLocalTimeFunc;

  TlibeetLogHelper = class(TObject)
  private
    FOnError: TlibeetLogEvent;
  public
    procedure DoError(const file_: string; line: Longint; const func: string; const errorObject: string; const errorSubject: string; reason: Longint; const msg: string);
  published
    property OnError : TlibeetLogEvent read FOnError write FOnError;
  end;

  function InitLibEETSigner(const path: string = ''; libname : string = ''): Boolean;

  function FreeLibEETSigner: Boolean;

{$IFDEF USE_LIBEET}
  function eetSignerGetX509KeyCert(mngr : xmlSecKeysMngrPtr) : libeetX509Ptr; cdecl;
  function eetSignerX509GetSubject(pX509Cert : libeetX509Ptr) : string; cdecl;
  function eetSignerX509GetSerialNum(pX509Cert : libeetX509Ptr) : string; cdecl;
  function eetSignerX509GetValidDate(pX509Cert : libeetX509Ptr; var notBefore, notAfter : TDateTime) : LongInt; cdecl;
  function eetSignerX509GetIssuerName(pX509Cert : libeetX509Ptr) : string; cdecl;
{$ENDIF}

  procedure libeetErrorsSetCallback(Callback : libeetErrorsCallbackMethod); cdecl;
  procedure libeetErrorsDefaultCallback(const file_: PAnsiChar; line: Longint; const func: PAnsiChar; const errorObject: PAnsiChar; const errorSubject: PAnsiChar; reason: Longint; const msg: PAnsiChar); cdecl;
  procedure libeetErrorsDefaultCallbackEnableOutput(enabled: Longint); cdecl;
  function libeetErrorsGetCode(pos: xmlSecSize) : Longint; cdecl;
  function libeetErrorsGetMsg(pos: xmlSecSize) : string; cdecl;

  function eetSignerKeysMngrCreate : xmlSecKeysMngrPtr; cdecl;
  procedure eetSignerKeysMngrDestroy(mngr : xmlSecKeysMngrPtr); cdecl;
  procedure eetSignerSetDefaultKeysMngr(mngr : xmlSecKeysMngrPtr); cdecl;

  procedure eetFree(mem: Pointer); cdecl;
  function eetMalloc(size: size_t): Pointer; cdecl;
  function eetCalloc(size: size_t): Pointer; cdecl;
  function eetSignerInit: LongInt; cdecl;
  procedure eetSignerShutdown; cdecl;
  procedure eetSignerCleanUp; cdecl;
  function eetSignerLoadPFXKeyFile(mngr : xmlSecKeysMngrPtr; filename : string; pwd : string): Longint; cdecl;
  function eetSignerLoadPFXKeyMemory(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt; pwd : string): Longint; cdecl;
  function eetSignerAddTrustedCertFile(mngr : xmlSecKeysMngrPtr; filename : string): Longint; cdecl;
  function eetSignerAddTrustedCertMemory(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt): Longint; cdecl;
  function eetSignerSignString(mngr : xmlSecKeysMngrPtr; data : string): ansistring; cdecl;
  function eetSignerMakePKP(mngr : xmlSecKeysMngrPtr; data : string): string; cdecl;
  function eetSignerMakeBKP(mngr : xmlSecKeysMngrPtr; data : string): string; cdecl;
  function eetSignerSignRequest(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt; var output : ansistring): Longint; cdecl;
  function eetSignerVerifyResponse(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt): Longint; cdecl;
  function eetSignerGetRawCertDataAsBase64String(mngr : xmlSecKeysMngrPtr): string; cdecl;

  function eetSignerUTCToLocalTime(UTCTime : time_tPtr): time_t; cdecl;

  function eetSignerlibeetVersion(): string; cdecl;
  function eetSignerlibXmlVersion(): string; cdecl;
  function eetSignerxmlSecVersion(): string; cdecl;
  function eetSignerCryptoVersion(): string; cdecl;

var
  libeetLogHelper : TlibeetLogHelper = nil;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SyncObjs, DateUtils, SysUtils;

var
  FlibeetHandle: THandle;
  Lock: TCriticalSection;
  ReferenceCount: Integer = 0;
  curLibName : string = '';

const

  {* X509 begin const *}
  SHA_DIGEST_LENGTH = 20;
  {* X509 end const *}

  XMLSEC_ERRORS_MAX_NUMBER = 256;

type
  {* X509 begin types *}
  pASN1_STRING = ^ASN1_STRING;
  ASN1_STRING = record
    length: integer;
    asn1_type: integer;
    data: pointer;
    flags: longint;
	end;

  pASN1_TIME = pASN1_STRING;

  CRYPTO_EX_DATA = record
    sk: pointer;
    dummy: integer;
    end;

  pX509_VAL = ^X509_VAL;
  X509_VAL = record
	notBefore: pASN1_TIME;
    notAfter: pASN1_TIME;
	end;

  pX509_CINF = ^X509_CINF;
  X509_CINF = record
    version: pointer;
    serialNumber: pointer;
    signature: pointer;
    issuer: pointer;
    validity: pX509_VAL;
    subject: pointer;
    key: pointer;
    issuerUID: pointer;
    subjectUID: pointer;
    extensions: pointer;
    end;

  libeetX509 = record
    cert_info: pX509_CINF;
    sig_alg: pointer;  // ^X509_ALGOR
    signature: pointer;  // ^ASN1_BIT_STRING
    valid: integer;
    references: integer;
    name: PAnsiChar;
    ex_data: CRYPTO_EX_DATA;
    ex_pathlen: integer;
    ex_flags: integer;
    ex_kusage: integer;
    ex_xkusage: integer;
    ex_nscert: integer;
    skid: pointer;  // ^ASN1_OCTET_STRING
    akid: pointer;  // ?
    sha1_hash: array [0..SHA_DIGEST_LENGTH-1] of AnsiChar;
    aux: pointer;  // ^X509_CERT_AUX
    end;
 {* X509 end types *}

{$IF CompilerVersion <= 24.0}
  function SetDLLDirectory(lpPathName:PWideChar):Bool; stdcall;
     external kernel32 name 'SetDllDirectoryW';
{$IFEND}

procedure CheckForNil(ptr: Pointer; name:string);
begin
  if not Assigned(ptr) then
    raise Exception.Create('"' + name + '" could not be loaded from the dynamic library ' + curLibName);
end;

function _GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR) : FARPROC;
begin
  Result := GetProcAddress(hModule, lpProcName);
end;

function LocalDateTimeFromUTCDateTime(const UTCDateTime: TDateTime): TDateTime;
{$if CompilerVersion < 21) // before Delphi XE}
var
  LocalSystemTime: TSystemTime;
  UTCSystemTime: TSystemTime;
  LocalFileTime: TFileTime;
  UTCFileTime: TFileTime;
{$ifend}
begin
{$if CompilerVersion >= 21) // Delphi XE and above}
  Result := TTimeZone.Local.ToLocalTime(UTCDateTime);
{$else}
  DateTimeToSystemTime(UTCDateTime, UTCSystemTime);
  SystemTimeToFileTime(UTCSystemTime, UTCFileTime);
  if FileTimeToLocalFileTime(UTCFileTime, LocalFileTime)
  and FileTimeToSystemTime(LocalFileTime, LocalSystemTime) then begin
    Result := SystemTimeToDateTime(LocalSystemTime);
  end else begin
    Result := UTCDateTime;  // Default to UTC if any conversion function fails.
  end;
{$ifend}
end;

procedure libeetErrorHandler(const file_: PAnsiChar; line: Longint; const func: PAnsiChar; const errorObject: PChar; const errorSubject: PAnsiChar; reason: Longint; const msg: PAnsiChar); cdecl;
var
  sFile, sfunc, serrorObject, serrorSubject, smsg, errorMsg: string;
  i : Integer;
begin

  sFile:=string(file_);
  sfunc:=string(func);
  serrorObject:=string(errorObject);
  serrorSubject:=string(errorSubject);
  smsg:=string(msg);

  for i := 0 to XMLSEC_ERRORS_MAX_NUMBER - 1 do
    begin
      if (libeetErrorsGetMsg(i) <> '') then
        if(libeetErrorsGetCode(i) = reason) then
          begin
            errorMsg := libeetErrorsGetMsg(i);
            break;
          end;
    end;
  if libeetLogHelper <> nil then
    libeetLogHelper.DoError(sFile, line, sfunc, serrorObject, serrorSubject, reason, errorMsg);

  if IsConsole then
    Writeln(Format('func=%s:file=%s:line=%d:obj=%s:subj=%s:error=%d:%s:%s', [sfunc,sFile,line,serrorObject,serrorSubject,reason,msg, errorMsg]));
end;

var plibeetErrorsSetCallback : libeetErrorsSetCallbackMethod;
procedure libeetErrorsSetCallback(Callback: libeetErrorsCallbackMethod);
begin
  CheckForNil(@plibeetErrorsSetCallback, 'libeetErrorsSetCallback');
  plibeetErrorsSetCallback(Callback);
end;

var plibeetErrorsDefaultCallback : libeetErrorsDefaultCallbackMethod;
procedure libeetErrorsDefaultCallback(const file_: PAnsiChar; line: Longint; const func: PAnsiChar; const errorObject: PAnsiChar; const errorSubject: PAnsiChar; reason: Longint; const msg: PAnsiChar);
begin
  CheckForNil(@plibeetErrorsDefaultCallback, 'libeetErrorsDefaultCallback');
  plibeetErrorsDefaultCallback(file_, line, func, errorObject, errorSubject, reason, msg);
end;

var plibeetErrorsDefaultCallbackEnableOutput : libeetErrorsDefaultCallbackEnableOutputMethod;
procedure libeetErrorsDefaultCallbackEnableOutput(enabled: LongInt);
begin
  CheckForNil(@plibeetErrorsDefaultCallbackEnableOutput, 'libeetErrorsDefaultCallbackEnableOutput');
  plibeetErrorsDefaultCallbackEnableOutput(enabled);
end;

var plibeetErrorsGetCode : libeetErrorsGetCodeFunc;
function libeetErrorsGetCode(pos: xmlSecSize) : Longint;
begin
  CheckForNil(@plibeetErrorsGetCode, 'plibeetErrorsGetCode');
  Result := plibeetErrorsGetCode(pos);
end;

var plibeetErrorsGetMsg :libeetErrorsGetMsgFunc;
function libeetErrorsGetMsg(pos: xmlSecSize) : string;
var
  buf : PAnsiChar;
begin
  CheckForNil(@plibeetErrorsGetMsg, 'libeetErrorsGetMsg');
  buf := plibeetErrorsGetMsg(pos);
  Result := '';
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
end;


{$IFDEF USE_LIBEET}
var
  peetSignerKeysMngrCreate : eetSignerKeysMngrCreateFunc;
function eetSignerKeysMngrCreate() : xmlSecKeysMngrPtr;
begin
  CheckForNil(@peetSignerKeysMngrCreate, 'eetSignerKeysMngrCreate');
  Result := peetSignerKeysMngrCreate();
end;

var
  peetSignerKeysMngrDestroy :  eetSignerKeysMngrDestroyMethod;
procedure eetSignerKeysMngrDestroy(mngr: xmlSecKeysMngrPtr);
begin
  CheckForNil(@peetSignerKeysMngrDestroy, 'eetSignerKeysMngrDestroy');
  peetSignerKeysMngrDestroy(mngr);
end;

var
  peetSignerSetDefaultKeysMngr : eetSignerSetDefaultKeysMngrMethod;
procedure eetSignerSetDefaultKeysMngr(mngr: xmlSecKeysMngrPtr);
begin
  CheckForNil(@peetSignerSetDefaultKeysMngr, 'eetSignerSetDefaultKeysMngr');
  peetSignerSetDefaultKeysMngr(mngr);
end;

{$ENDIF}

var
   peetFree: eetFreeMethod;
procedure eetFree(mem: Pointer);
begin
  CheckForNil(@peetFree, 'eetFree');
  peetFree(mem);
end;

var
   peetMalloc : eetMallocFunc;
function eetMalloc(size: size_t): Pointer;
begin
  CheckForNil(@peetMalloc, 'eetMalloc');
  Result := peetMalloc(size);
end;

var
   peetCalloc : eetCallocFunc;
function eetCalloc(size: size_t): Pointer;
begin
  CheckForNil(@peetCalloc, 'eetCalloc');
  Result := peetCalloc(size);
end;

var
   peetSignerInit: eetSignerInitFunc;
function eetSignerInit: LongInt;
begin
  CheckForNil(@peetSignerInit, 'eetSignerInit');
  Result := peetSignerInit;
  libeetErrorsSetCallback(libeetErrorHandler);
  libeetErrorsDefaultCallbackEnableOutput(0);
end;

var
   peetSignerShutdown: eetSignerShutdownMethod;
procedure eetSignerShutdown;
begin
  CheckForNil(@peetSignerShutdown, 'eetSignerShutdown');
  peetSignerShutdown;
end;

var
   peetSignerCleanUp: eetSignerCleanUpMethod;
procedure eetSignerCleanUp;
begin
  CheckForNil(@peetSignerCleanUp, 'eetSignerCleanUp');
  peetSignerCleanUp;
end;

var
  peetSignerLoadPFXKeyFile : eetSignerLoadPFXKeyFileFunc;
function eetSignerLoadPFXKeyFile(mngr : xmlSecKeysMngrPtr; filename : string; pwd : string): Longint;
begin
  CheckForNil(@peetSignerLoadPFXKeyFile, 'eetSignerLoadPFXKeyFile');
  result := peetSignerLoadPFXKeyFile(mngr, xmlCharPtr(AnsiString(filename)),xmlCharPtr(AnsiString(pwd)));
end;

var
  peetSignerLoadPFXKeyMemory : eetSignerLoadPFXKeyMemoryFunc;
function eetSignerLoadPFXKeyMemory(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt; pwd : string): Longint;
begin
  CheckForNil(@peetSignerLoadPFXKeyMemory, 'eetSignerLoadPFXKeyMemory');
  result := peetSignerLoadPFXKeyMemory(mngr, data, dataSize, xmlCharPtr(ansistring(pwd)));
end;

var
  peetSignerAddTrustedCertFile : eetSignerAddTrustedCertFileFunc;
function eetSignerAddTrustedCertFile(mngr : xmlSecKeysMngrPtr; filename : string): Longint;
begin
  CheckForNil(@peetSignerAddTrustedCertFile, 'eetSignerAddTrustedCertFile');
  result := peetSignerAddTrustedCertFile(mngr, xmlCharPtr(AnsiString(filename)));
end;

var
  peetSignerAddTrustedCertMemory : eetSignerAddTrustedCertMemoryFunc;
function eetSignerAddTrustedCertMemory(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt): Longint;
begin
  CheckForNil(@peetSignerAddTrustedCertMemory, 'eetSignerAddTrustedCertMemory');
  result := peetSignerAddTrustedCertMemory(mngr, data, dataSize);
end;

var
  peetSignerSignString : eetSignerSignStringFunc;
function eetSignerSignString(mngr : xmlSecKeysMngrPtr; data : string): ansistring;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerSignString, 'eetSignerSignString');
  buf := peetSignerSignString(mngr, xmlCharPtr(AnsiString(data)));
  if buf <> nil then
    begin
      Result := buf^;
      eetFree(buf);
    end;
end;

var
  peetSignerMakePKP : eetSignerMakePKPFunc;
function eetSignerMakePKP(mngr : xmlSecKeysMngrPtr; data : string): string;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerMakePKP, 'eetSignerMakePKP');
  buf := peetSignerMakePKP(mngr, xmlCharPtr(AnsiString(data)));
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
end;

var
  peetSignerMakeBKP : eetSignerMakeBKPFunc;
function eetSignerMakeBKP(mngr : xmlSecKeysMngrPtr; data : string): string;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerMakeBKP, 'eetSignerMakeBKP');
  buf := peetSignerMakeBKP(mngr, xmlCharPtr(ansistring(data)));
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
end;

var
  peetSignerSignRequest : eetSignerSignRequestFunc;
function eetSignerSignRequest(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt; var output : ansistring): Longint;
var
  outbufp : xmlCharPtrPtr;
  S : AnsiString;
begin
  CheckForNil(@peetSignerSignRequest, 'eetSignerSignRequest');
  outbufp := eetMalloc(SizeOf(outbufp));
  try
    S := '';
    outbufp^ := @S;
    result := peetSignerSignRequest(mngr, xmlCharPtr(Data), dataSize, outbufp);
    output := outbufp^;
  finally
    eetFree(outbufp);
  end;
end;

var
  peetSignerVerifyResponse : eetSignerVerifyResponseFunc;
function eetSignerVerifyResponse(mngr : xmlSecKeysMngrPtr; Data : Pointer; dataSize : LongInt): Longint;
begin
  CheckForNil(@peetSignerVerifyResponse, 'eetSignerVerifyResponse');
  result := peetSignerVerifyResponse(mngr, xmlCharPtr(data), dataSize);
end;

var
  peetSignerGetRawCertDataAsBase64String : eetSignerGetRawCertDataAsBase64StringFunc;
function eetSignerGetRawCertDataAsBase64String(mngr : xmlSecKeysMngrPtr): string;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerGetRawCertDataAsBase64String, 'eetSignerGetRawCertDataAsBase64String');
  buf := peetSignerGetRawCertDataAsBase64String(mngr);
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
end;

var
  peetSignerGetX509KeyCert  : eetSignerGetX509KeyCertFunc;
function eetSignerGetX509KeyCert(mngr : xmlSecKeysMngrPtr): libeetX509Ptr;
begin
  CheckForNil(@peetSignerGetX509KeyCert, 'eetSignerGetX509KeyCert');
  Result := peetSignerGetX509KeyCert(mngr);
end;

var
  peetSignerX509GetSubject  : eetSignerX509GetSubjectFunc;
function eetSignerX509GetSubject(pX509Cert : libeetX509Ptr): string;
var
  buf : xmlCharPtrPtr;
begin
  CheckForNil(@peetSignerX509GetSubject, 'eetSignerX509GetSubject');
  Result := '';
  New(buf);
  try
    if (peetSignerX509GetSubject(pX509Cert, buf) = 0) then
      begin
        Result := string(buf^);
        eetFree(buf^);
      end;
  finally
    Dispose(buf);
  end;
end;

var
  peetSignerX509GetSerialNum   : eetSignerX509GetSerialNumFunc;
function eetSignerX509GetSerialNum(pX509Cert : libeetX509Ptr): string;
var
  buf : xmlCharPtrPtr;
begin
  CheckForNil(@peetSignerX509GetSerialNum, 'eetSignerX509GetSerialNum');
  Result := '';
  New(buf);
  try
    if (peetSignerX509GetSerialNum(pX509Cert, buf) = 0) then
      begin
        Result := string(buf^);
        eetFree(buf^);
      end;
  finally
    Dispose(buf);
  end;
end;

var
  peetSignerX509GetValidDate   : eetSignerX509GetValidDatefunc;
function eetSignerX509GetValidDate(pX509Cert : libeetX509Ptr; var notBefore, notAfter : TDateTime): Longint;
var
  t1 : time_t;
  t2 : time_t;
begin
  CheckForNil(@peetSignerX509GetValidDate, 'eetSignerX509GetValidDate');
  t1 := 0;
  t2 := 0;
  Result := peetSignerX509GetValidDate(pX509Cert, @t1, @t2);
  if (Result = 0) then
    begin
//      notBefore := LocalDateTimeFromUTCDateTime(UnixToDateTime(t1));
//      notAfter := LocalDateTimeFromUTCDateTime(UnixToDateTime(t2));
      notBefore := LocalDateTimeFromUTCDateTime(UnixToDateTime(eetSignerUTCToLocaltime(@t1)));
      notAfter := LocalDateTimeFromUTCDateTime(UnixToDateTime(eetSignerUTCToLocaltime(@t2)));
    end;
end;

var
  peetSignerX509GetIssuerName  : eetSignerX509GetIssuerNameFunc;
function eetSignerX509GetIssuerName(pX509Cert : libeetX509Ptr): string;
var
  buf : xmlCharPtrPtr;
begin
  CheckForNil(@peetSignerX509GetIssuerName, 'eetSignerX509GetIssuerName');
  Result := '';
  New(buf);
  try
    if (peetSignerX509GetIssuerName(pX509Cert, buf) = 0) then
      begin
        Result := string(buf^);
        eetFree(buf^);
      end;
  finally
    Dispose(buf);
  end;
end;

var
  peetSignerUTCToLocalTime : eetSignerUTCToLocalTimeFunc;
function eetSignerUTCToLocalTime(UTCTime : time_tPtr): time_t;
var
  buf : time_tPtr;
begin
  CheckForNil(@peetSignerUTCToLocalTime, 'eetSignerUTCToLocalTime');
  buf := peetSignerUTCToLocalTime(UTCTime);
  Result := buf^;
  eetFree(buf);
end;

var
  peetSignerlibeetVersion : eetSignerlibeetVersionFunc;
function eetSignerlibeetVersion(): string;
begin
  CheckForNil(@peetSignerlibeetVersion, 'eetSignerlibeetVersion');
  Result := string(peetSignerlibeetVersion);
end;

var
  peetSignerlibXmlVersion : eetSignerlibXmlVersionFunc;
function eetSignerlibXmlVersion(): string;
begin
  CheckForNil(@peetSignerlibXmlVersion, 'eetSignerlibXmlVersion');
  Result := string(peetSignerlibXmlVersion());
end;

var
  peetSignerxmlSecVersion : eetSignerxmlSecVersionFunc;
function eetSignerxmlSecVersion(): string;
begin
  CheckForNil(@peetSignerxmlSecVersion, 'eetSignerxmlSecVersion');
  Result := string(peetSignerxmlSecVersion());
end;

var
  peetSignerCryptoVersion : eetSignerCryptoVersionFunc;
function eetSignerCryptoVersion(): string;
begin
  CheckForNil(@peetSignerCryptoVersion, 'peetSignerCryptoVersion');
  Result := string(peetSignerCryptoVersion());
end;

function InitLibEETSigner(const path : string; libname : string ): Boolean;
begin
  Lock.Enter;
  try
    Inc(ReferenceCount);
    if FlibeetHandle = 0 then
      begin
        libeetLogHelper := TlibeetLogHelper.Create;
        if path <> '' then
          SetDllDirectory(PWideChar(WideString(path)));
        if libname <> '' then
          curLibName := libname
        else
          begin
            curLibName := LIBEET_SO;
          end;
        FlibeetHandle := LoadLibrary(PChar(curLibName));
        if FlibeetHandle <> 0 then
          begin
            {$IFDEF USE_LIBEET}
            peetSignerKeysMngrCreate := _GetProcAddress(FlibeetHandle, 'eetSignerKeysMngrCreate');
            peetSignerKeysMngrDestroy := _GetProcAddress(FlibeetHandle, 'eetSignerKeysMngrDestroy');
            peetSignerSetDefaultKeysMngr := _GetProcAddress(FlibeetHandle, 'eetSignerSetDefaultKeysMngr');
            {$ENDIF}

            peetFree := _GetProcAddress(FlibeetHandle, 'eetFree');
            peetMalloc := _GetProcAddress(FlibeetHandle, 'eetMalloc');
            peetCalloc := _GetProcAddress(FlibeetHandle, 'eetCalloc');

            plibeetErrorsSetCallback := _GetProcAddress(FlibeetHandle, 'libeetErrorsSetCallback');
            plibeetErrorsDefaultCallback := _GetProcAddress(FlibeetHandle, 'libeetErrorsDefaultCallback');
            plibeetErrorsDefaultCallbackEnableOutput := _GetProcAddress(FlibeetHandle, 'libeetErrorsDefaultCallbackEnableOutput');
            plibeetErrorsGetCode := _GetProcAddress(FlibeetHandle, 'libeetErrorsGetCode');
            plibeetErrorsGetMsg := _GetProcAddress(FlibeetHandle, 'libeetErrorsGetMsg');

            peetSignerInit := _GetProcAddress(FlibeetHandle, 'eetSignerInit');
            peetSignerCleanUp := _GetProcAddress(FlibeetHandle, 'eetSignerCleanUp');
            peetSignerShutdown := _GetProcAddress(FlibeetHandle, 'eetSignerShutdown');

            peetSignerLoadPFXKeyFile := _GetProcAddress(FlibeetHandle, 'eetSignerLoadPFXKeyFile');
            peetSignerLoadPFXKeyMemory := _GetProcAddress(FlibeetHandle, 'eetSignerLoadPFXKeyMemory');
            peetSignerAddTrustedCertFile := _GetProcAddress(FlibeetHandle, 'eetSignerAddTrustedCertFile');
            peetSignerAddTrustedCertMemory := _GetProcAddress(FlibeetHandle, 'eetSignerAddTrustedCertMemory');
            peetSignerSignString := _GetProcAddress(FlibeetHandle, 'eetSignerSignString');
            peetSignerMakePKP := _GetProcAddress(FlibeetHandle, 'eetSignerMakePKP');
            peetSignerMakeBKP := _GetProcAddress(FlibeetHandle, 'eetSignerMakeBKP');
            peetSignerSignRequest := _GetProcAddress(FlibeetHandle, 'eetSignerSignRequest');
            peetSignerVerifyResponse := _GetProcAddress(FlibeetHandle, 'eetSignerVerifyResponse');
            peetSignerGetRawCertDataAsBase64String := _GetProcAddress(FlibeetHandle, 'eetSignerGetRawCertDataAsBase64String');

            peetSignerGetX509KeyCert     := _GetProcAddress(FlibeetHandle, 'eetSignerGetX509KeyCert');
            peetSignerX509GetSubject     := _GetProcAddress(FlibeetHandle, 'eetSignerX509GetSubject');
            peetSignerX509GetSerialNum   := _GetProcAddress(FlibeetHandle, 'eetSignerX509GetSerialNum');
            peetSignerX509GetValidDate   := _GetProcAddress(FlibeetHandle, 'eetSignerX509GetValidDate');
            peetSignerX509GetIssuerName  := _GetProcAddress(FlibeetHandle, 'eetSignerX509GetIssuerName');

            peetSignerUTCToLocalTime := _GetProcAddress(FlibeetHandle, 'eetSignerUTCToLocalTime');

            peetSignerlibeetVersion := _GetProcAddress(FlibeetHandle, 'eetSignerlibeetVersion');
            peetSignerlibXmlVersion := _GetProcAddress(FlibeetHandle, 'eetSignerlibXmlVersion');
            peetSignerxmlSecVersion := _GetProcAddress(FlibeetHandle, 'eetSignerxmlSecVersion');
            peetSignerCryptoVersion := _GetProcAddress(FlibeetHandle, 'eetSignerCryptoVersion');
          end;
      end;
    Result := FlibeetHandle > 0;
  finally
    Lock.Leave;
  end;
end;

function FreeLibEETSigner: Boolean;
begin
  Lock.Enter;
  try
    if ReferenceCount > 0 then
      Dec(ReferenceCount);

    if (FlibeetHandle <> 0) and (ReferenceCount = 0) then
    begin
      FlibeetHandle := 0;

      {$IFDEF USE_LIBEET}
      peetSignerKeysMngrCreate := nil;
      peetSignerKeysMngrDestroy := nil;
      peetSignerSetDefaultKeysMngr := nil;
      {$ENDIF}

      peetFree := nil;
      peetMalloc := nil;
      peetCalloc := nil;

      plibeetErrorsSetCallback := nil;
      plibeetErrorsDefaultCallback := nil;
      plibeetErrorsDefaultCallbackEnableOutput := nil;
      plibeetErrorsGetCode := nil;
      plibeetErrorsGetMsg := nil;

      peetSignerInit := nil;
      peetSignerCleanUp := nil;
      peetSignerShutdown := nil;

      peetSignerLoadPFXKeyFile := nil;
      peetSignerLoadPFXKeyMemory := nil;
      peetSignerAddTrustedCertFile := nil;
      peetSignerAddTrustedCertMemory := nil;
      peetSignerSignString := nil;
      peetSignerMakePKP := nil;
      peetSignerMakeBKP := nil;
      peetSignerSignRequest := nil;
      peetSignerVerifyResponse := nil;
      peetSignerGetRawCertDataAsBase64String := nil;

      peetSignerGetX509KeyCert := nil;
      peetSignerX509GetSubject := nil;
      peetSignerX509GetSerialNum := nil;
      peetSignerX509GetValidDate := nil;
      peetSignerX509GetIssuerName := nil;

      peetSignerUTCToLocalTime := nil;

      peetSignerlibeetVersion := nil;
      peetSignerlibXmlVersion := nil;
      peetSignerxmlSecVersion := nil;
      peetSignerCryptoVersion := nil;

      libeetLogHelper.Free;
      libeetLogHelper := nil;
    end;
    Result := FlibeetHandle = 0;
  finally
    Lock.Leave;
  end;
end;

{ TlibeetLogHelper }

procedure TlibeetLogHelper.DoError(const file_: string; line: Integer; const func, errorObject, errorSubject: string;
  reason: Integer; const msg: string);
begin
  if Assigned(FOnError) then
    FOnError(file_, line, func, errorObject, errorSubject, reason, msg);
end;

initialization
  Lock := TCriticalSection.Create;

finalization
  while ReferenceCount > 0 do
    FreeLibEETSigner;
  Lock.Free;
end.
