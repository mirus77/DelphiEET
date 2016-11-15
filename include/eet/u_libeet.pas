unit u_libeet;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

const
  LIBEET_SO = 'libeetsigner.dll';
  LIBEET_SOd = 'libeetsignerd.dll';
  LIBEET_SO64 = 'libeetsigner64.dll';
  LIBEET_SO64d = 'libeetsigner64d.dll';

type
  time_t = Longint;
  size_t = Longint;

  xmlCharPtr = PAnsiChar;
  xmlCharPtrPtr = ^xmlCharPtr;

  xmlSecPtr = Pointer;
  xmlSecPtrPtr = ^xmlSecPtr;

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

  eetSignerLoadPFXKeyFileFunc = function(filename : xmlCharPtr; pwd : xmlCharPtr) : LongInt; cdecl;
  eetSignerLoadPFXKeyFileFuncPtr = ^eetSignerLoadPFXKeyFileFunc;

  eetSignerLoadPFXKeyMemoryFunc = function(data : xmlCharPtr; dataSize : LongInt; pwd : xmlCharPtr) : LongInt; cdecl;
  eetSignerLoadPFXKeyMemoryFuncPtr = ^eetSignerLoadPFXKeyMemoryFunc;

  eetSignerAddTrustedCertFileFunc = function(filename : xmlCharPtr) : LongInt; cdecl;
  eetSignerAddTrustedCertFileFuncPtr = ^eetSignerAddTrustedCertFileFunc;

  eetSignerAddTrustedCertMemoryFunc = function(data : xmlCharPtr; dataSize : LongInt) : LongInt; cdecl;
  eetSignerAddTrustedCertMemoryFuncPtr = ^eetSignerAddTrustedCertMemoryFunc;

  eetSignerSignStringFunc = function(data : xmlCharPtr) : xmlCharPtr; cdecl;
  eetSignerSignStringFuncPtr = ^eetSignerSignStringFunc;

  eetSignerMakePKPFunc = function(data : xmlCharPtr) : xmlCharPtr; cdecl;
  eetSignerMakePKPFuncPtr = ^eetSignerMakePKPFunc;

  eetSignerMakeBKPFunc = function(data : xmlCharPtr) : xmlCharPtr; cdecl;
  eetSignerMakeBKPFuncPtr = ^eetSignerMakeBKPFunc;

  eetSignerSignRequestFunc = function(Data : Pointer; dataSize : LongInt; outbufp : xmlCharPtrPtr) : Longint cdecl;
  eetSignerSignRequestFuncPtr = ^eetSignerSignRequestFunc;

  eetSignerVerifyResponseFunc = function(Data : Pointer; dataSize : LongInt) : LongInt; cdecl;
  eetSignerVerifyResponseFuncPtr = ^eetSignerVerifyResponseFunc;

  eetSignerGetRawCertDataAsBase64StringFunc = function() : xmlCharPtr; cdecl;
  eetSignerGetRawCertDataAsBase64StringFuncPtr = ^eetSignerGetRawCertDataAsBase64StringFunc;

  eetSignerlibeetVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerlibeetVersionFuncPtr = ^eetSignerlibeetVersionFunc;

  eetSignerlibXmlVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerlibXmlVersionFuncdPtr = ^eetSignerlibXmlVersionFunc;

  eetSignerxmlSecVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerxmlSecVersionFuncPtr = ^eetSignerxmlSecVersionFunc;

  eetSignerCryptoVersionFunc = function() : xmlCharPtr; cdecl;
  eetSignerCryptoVersionFuncPtr = ^eetSignerCryptoVersionFunc;

  function InitLibEETSigner(const path: string = ''; libname : string = ''): Boolean;

  function FreeLibEETSigner: Boolean;

  procedure eetFree(mem: Pointer); cdecl;
  function eetMalloc(size: size_t): Pointer; cdecl;
  function eetCalloc(size: size_t): Pointer; cdecl;
  function eetSignerInit: LongInt; cdecl;
  procedure eetSignerShutdown; cdecl;
  procedure eetSignerCleanUp; cdecl;
  function eetSignerLoadPFXKeyFile(filename : string; pwd : string): Longint; cdecl;
  function eetSignerLoadPFXKeyMemory(Data : Pointer; dataSize : LongInt; pwd : string): Longint; cdecl;
  function eetSignerAddTrustedCertFile(filename : string): Longint; cdecl;
  function eetSignerAddTrustedCertMemory(Data : Pointer; dataSize : LongInt): Longint; cdecl;
  function eetSignerSignString(data : string): ansistring; cdecl;
  function eetSignerMakePKP(data : string): string; cdecl;
  function eetSignerMakeBKP(data : string): string; cdecl;
  function eetSignerSignRequest(Data : Pointer; dataSize : LongInt; var output : ansistring): Longint; cdecl;
  function eetSignerVerifyResponse(Data : Pointer; dataSize : LongInt): Longint; cdecl;
  function eetSignerGetRawCertDataAsBase64String(): string; cdecl;
  function eetSignerlibeetVersion(): string; cdecl;
  function eetSignerlibXmlVersion(): string; cdecl;
  function eetSignerxmlSecVersion(): string; cdecl;
  function eetSignerCryptoVersion(): string; cdecl;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SyncObjs, SysUtils;

var
  FlibeetHandle: THandle;
  Lock: TCriticalSection;
  ReferenceCount: Integer = 0;
  curLibName : LPCWSTR = '';

procedure CheckForNil(ptr: Pointer; name:string);
begin
  if not Assigned(ptr) then
    raise Exception.Create('"' + name + '" could not be loaded from the dynamic library ' + curLibName);
end;

function _GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR) : FARPROC;
begin
  Result := GetProcAddress(hModule, lpProcName);
end;

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
function eetSignerLoadPFXKeyFile(filename : string; pwd : string): Longint;
begin
  CheckForNil(@peetSignerLoadPFXKeyFile, 'eetSignerLoadPFXKeyFile');
  result := peetSignerLoadPFXKeyFile(xmlCharPtr(AnsiString(filename)),xmlCharPtr(AnsiString(pwd)));
end;

var
  peetSignerLoadPFXKeyMemory : eetSignerLoadPFXKeyMemoryFunc;
function eetSignerLoadPFXKeyMemory(Data : Pointer; dataSize : LongInt; pwd : string): Longint;
begin
  CheckForNil(@peetSignerLoadPFXKeyMemory, 'eetSignerLoadPFXKeyMemory');
  result := peetSignerLoadPFXKeyMemory(data, dataSize, xmlCharPtr(ansistring(pwd)));
end;

var
  peetSignerAddTrustedCertFile : eetSignerAddTrustedCertFileFunc;
function eetSignerAddTrustedCertFile(filename : string): Longint;
begin
  CheckForNil(@peetSignerAddTrustedCertFile, 'eetSignerAddTrustedCertFile');
  result := peetSignerAddTrustedCertFile(xmlCharPtr(AnsiString(filename)));
end;

var
  peetSignerAddTrustedCertMemory : eetSignerAddTrustedCertMemoryFunc;
function eetSignerAddTrustedCertMemory(Data : Pointer; dataSize : LongInt): Longint;
begin
  CheckForNil(@peetSignerAddTrustedCertMemory, 'eetSignerAddTrustedCertMemory');
  result := peetSignerAddTrustedCertMemory(data, dataSize);
end;

var
  peetSignerSignString : eetSignerSignStringFunc;
function eetSignerSignString(data : string): ansistring;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerSignString, 'eetSignerSignString');
  buf := peetSignerSignString(xmlCharPtr(AnsiString(data)));
  if buf <> nil then
    begin
      Result := buf^;
      eetFree(buf);
    end;
end;

var
  peetSignerMakePKP : eetSignerMakePKPFunc;
function eetSignerMakePKP(data : string): string;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerMakePKP, 'eetSignerMakePKP');
  buf := peetSignerMakePKP(xmlCharPtr(AnsiString(data)));
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
end;

var
  peetSignerMakeBKP : eetSignerMakeBKPFunc;
function eetSignerMakeBKP(data : string): string;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerMakeBKP, 'eetSignerMakeBKP');
  buf := peetSignerMakeBKP(xmlCharPtr(ansistring(data)));
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
end;

var
  peetSignerSignRequest : eetSignerSignRequestFunc;
function eetSignerSignRequest(Data : Pointer; dataSize : LongInt; var output : ansistring): Longint;
var
  outbufp : xmlCharPtrPtr;
  S : AnsiString;
begin
  CheckForNil(@peetSignerSignRequest, 'eetSignerSignRequest');
  outbufp := eetMalloc(SizeOf(outbufp));
  try
    S := '';
    outbufp^ := @S;
    result := peetSignerSignRequest(xmlCharPtr(Data), dataSize, outbufp);
    output := outbufp^;
  finally
    eetFree(outbufp);
  end;
end;

var
  peetSignerVerifyResponse : eetSignerVerifyResponseFunc;
function eetSignerVerifyResponse(Data : Pointer; dataSize : LongInt): Longint;
begin
  CheckForNil(@peetSignerVerifyResponse, 'eetSignerVerifyResponse');
  result := peetSignerVerifyResponse(xmlCharPtr(data), dataSize);
end;

var
  peetSignerGetRawCertDataAsBase64String : eetSignerGetRawCertDataAsBase64StringFunc;
function eetSignerGetRawCertDataAsBase64String(): string;
var
  buf : xmlCharPtr;
begin
  CheckForNil(@peetSignerGetRawCertDataAsBase64String, 'eetSignerGetRawCertDataAsBase64String');
  buf := peetSignerGetRawCertDataAsBase64String();
  if buf <> nil then
    begin
      Result := string(buf);
      eetFree(buf);
    end;
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
        if path <> '' then
          SetDllDirectory(PChar(path));
        if libname <> '' then
          curLibName := LPCWSTR(libname)
        else
          begin
            curLibName := LIBEET_SO;
            {$IFDEF DEBUG}
            if IsConsole then
              curLibName := LIBEET_SOd;
            {$ENDIF}
            {$IFDEF WIN64}
            curLibName := LIBEET_SO64;
            {$IFDEF DEBUG}
            if IsConsole then
              curLibName := LIBEET_SO64d;
            {$ENDIF}
            {$ENDIF}
          end;
        FlibeetHandle := LoadLibrary(curLibName);
        if FlibeetHandle <> 0 then
          begin
            peetFree := _GetProcAddress(FlibeetHandle, 'eetFree');
            peetMalloc := _GetProcAddress(FlibeetHandle, 'eetMalloc');
            peetCalloc := _GetProcAddress(FlibeetHandle, 'eetCalloc');

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

      peetFree := nil;
      peetMalloc := nil;
      peetCalloc := nil;

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

      peetSignerlibeetVersion := nil;
      peetSignerlibXmlVersion := nil;
      peetSignerxmlSecVersion := nil;
      peetSignerCryptoVersion := nil;
    end;
    Result := FlibeetHandle = 0;
  finally
    Lock.Leave;
  end;
end;

initialization
  Lock := TCriticalSection.Create;

finalization
  while ReferenceCount > 0 do
    FreeLibEETSigner;
  Lock.Free;
end.
