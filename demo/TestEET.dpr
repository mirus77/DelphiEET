program TestEET;

{$APPTYPE CONSOLE} // for debuging libxml

{*

  Delphi project Options
  ----------------------
  {for using in Windows XP)
  Delphi Compiler Options -> Conditional Defines :
       USE_INDY - recompile SOAP comunications with Indy
       USE_UCRT_LIBS - libxml,libmlsec use library's compiled with Visual Studio 2015 (Visual C++ Build platform 14)

  (for other)
  Delphi Compiler Options -> Output Directory: ..\bin
  Delphi Compiler Options -> Search Path: $(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\synapse;..\include\szutils;..\include\xmlsec
  Delphi Compiler Options -> Unit Output Directory: .\dcu

*}


uses
  Vcl.Forms,
  u_main in 'u_main.pas' {TestEETForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTestEETForm, TestEETForm);
  Application.Run;
end.
