program TestEET;

{$APPTYPE CONSOLE} // for debuging libxml

{*

  Delphi project Options
  ----------------------
  {for using in Windows XP)
  Delphi Compiler Options -> Conditional Defines :
       USE_INDY - recompile SOAP comunications with Indy
       USE_LIBEET - use wrapper libeetsigner.dll - static compiled into one library (libxml2, xmlsec, openssl)
                    compiled with Visual Studio 2013 U5 Express - VC12 (VS Runtime 2013) needed MSVCR120.dll

  (for other)
  Delphi Compiler Options -> Output Directory: ..\bin
  Delphi Compiler Options -> Search Path: $(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\synapse;
                               ..\include\szutils;..\include\xmlsec;..\include\vcruntime
  Delphi Compiler Options -> Unit Output Directory: .\dcu

*}


uses
  Forms,
  u_main in 'u_main.pas' {TestEETForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTestEETForm, TestEETForm);
  Application.Run;
end.
