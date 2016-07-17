program TestEET;

{$APPTYPE CONSOLE} // for debuging libxml

{*

  Delphi project Options
  ----------------------
  Delphi Compiler Options -> Search Path: ..\include\soap;$(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\synapse;..\include\szutils;..\include\wsse;..\include\xmlsec

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
