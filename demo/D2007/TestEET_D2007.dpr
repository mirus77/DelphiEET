// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program TestEET_D2007;

{$APPTYPE CONSOLE} // for debuging libxml

{*

  Delphi project Options
  ----------------------
  {for using in Windows XP)
  Delphi Compiler Options -> Conditional Defines :
       USE_INDY - recompile SOAP comunications with Indy
       USE_LIBEET - use wrapper libeetsigner.dll - static compiled into one library (libxml2, xmlsec, openssl)
                    compiled with Visual Studio 2013 U5 Express - VC12 (VS Runtime 2013) needed MSVCR120.dll
       USE_VS_LIBS - use libxml2 and xmlsec compiled with Visual Studio
                  solution for time_t compatibility
                  VS 2013 and lower using MSVCRxxx.dll
                  VS 2015 and higher VCRUNTIME140.dll (ucrtbase.dll)
       Default c-rutntime msvcrt.dll for MinGW xmlsec1.

  For x64 binaries of demo use directive USE_LIBEET

  (for other)
  Delphi Compiler Options -> Output Directory: ..\bin
  Delphi Compiler Options -> Search Path: $(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\synapse;
                               ..\include\szutils;..\include\xmlsec;..\include\vcruntime
  Delphi Compiler Options -> Unit Output Directory: .\dcu

*}


uses
  SimpleShareMem,
  Forms,
  u_main in '..\u_main.pas' {TestEETForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTestEETForm, TestEETForm);
  Application.Run;
end.
