unit vcruntime;

interface

const
{$IFDEF USE_LIBEET}
  {$IFDEF USE_UCRT_LIBS}
  LIBMSVCRT   = 'ucrtbase.dll';
  {$ELSE}
  LIBMSVCRT   = 'msvcr120.dll'; // Visual Studio 2013
  {$ENDIF}
{$ELSE}
  {$IFDEF USE_UCRT_LIBS}
  LIBMSVCRT   = 'ucrtbase.dll';
  {$ELSE}
  LIBMSVCRT   = 'msvcrt.dll';
  {$ENDIF}
{$ENDIF}

type
  PFILE = Pointer;

var
// msvcrt.dll utils

  crt_fopen : function (const filename, mode: PAnsiChar): PFILE; cdecl;

  crt_fclose : function (stream: PFILE): Integer; cdecl;

implementation

uses SyncObjs, Windows;

var
  vcruntimeInitialized: Boolean = false;
  FMscvrtHandle: THandle = 0;
  ReferenceCount : Integer = 0;
  Lock : TCriticalSection;

function InitVCRuntime : boolean;
begin
  Lock.Enter;
  try
    Inc(ReferenceCount);
    if FMscvrtHandle = 0 then
      begin
        crt_fopen :=  nil;
        crt_fclose :=  nil;
        FMscvrtHandle := LoadLibrary(LIBMSVCRT);
        if FMscvrtHandle > 0 then
          begin
            crt_fopen :=  GetProcAddress(FMscvrtHandle, 'fopen');
            crt_fclose :=  GetProcAddress(FMscvrtHandle, 'fclose');
          end;
      end;
    Result := FMscvrtHandle > 0;
  finally
    Lock.Leave;
  end;
end;

procedure DoneVCRuntime;
begin
  Lock.Enter;
  try
    if ReferenceCount > 0 then
      Dec(ReferenceCount);

   if (FMscvrtHandle <> 0) and (ReferenceCount = 0) then
    begin
      FMscvrtHandle := 0;
      crt_fopen :=  nil;
      crt_fclose :=  nil;
    end;
  finally
    Lock.Leave;
  end;
end;

initialization
  Lock := TCriticalSection.Create;
  InitVCRuntime;

finalization
  DoneVCRuntime;
  Lock.Free;
end.