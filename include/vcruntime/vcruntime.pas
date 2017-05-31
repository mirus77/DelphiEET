unit vcruntime;

interface

const
{$IFDEF USE_LIBEET}
//  LIBMSVCRT   = 'ucrtbase.dll';  // Visual Studio 2015 and higher
  LIBMSVCRT   = 'msvcr120.dll'; // Visual Studio 2013
{$ELSE}
  {$IFDEF USE_VS_LIBS}
  LIBMSVCRT   = 'msvcr120.dll'; // Visual Studio 2013
//  LIBMSVCRT   = 'ucrtbase.dll';   // Visual Studio 2015 and higher
  {$ELSE}
  LIBMSVCRT   = 'msvcrt.dll'; // MinGW32 libs
  {$ENDIF}
{$ENDIF}

type
  PFILE = Pointer;

var
// crtuntime utils

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