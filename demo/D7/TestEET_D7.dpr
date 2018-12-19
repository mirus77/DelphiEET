program TestEET_D7;

{$APPTYPE CONSOLE} // for debuging libxml

{*

  Delphi project Options
  ----------------------
  Select EETHttpClient for DEMO
  Delphi Compiler Options -> Conditional Defines :
       USE_SYNAPSE_CLIENT - use Synapse library for HTTP Post (WinXP and higher)
       or USE_RIO_CLIENT - Native SOAP HTTPRio for HTTP Post (default choice) Win Vista and higher
       or USE_SBRIDGE_CLIENT - use SecureBridge components from www.devart.com for HTTP Post (WinXP and higher)
       or USE_NETHTTP_CLIENT - use Net.HttpClient with Delphi XE8 and higher for HTTP Post (uniplatform)

  {for using in Windows XP)
       USE_SYNAPSE_CLIENT - use Synapse library for HTTP Post (need openssl libs)
       or USE_SBRIDGE_CLIENT - use SecureBridge components from www.devart.com for HTTP Post

  (for other OS)
       USE_LIBEET - use wrapper libeetsigner.dll - static compiled into one library (libxml2, xmlsec, openssl)
                    compiled with Visual Studio 2013 U5 Express - VC12 (VS Runtime 2013) needed MSVCR120.dll
       USE_VS_LIBS - use libxml2 and xmlsec compiled with Visual Studio
                  solution for time_t compatibility
                  VS 2013 and lower using MSVCRxxx.dll
                  VS 2015 and higher VCRUNTIME140.dll (ucrtbase.dll)

  Delphi Compiler Options -> Conditional Defines :
  Delphi Compiler Options -> Output Directory: ..\..\bin
  Delphi Compiler Options -> Search Path: ..\..\source\databinding;..\..\source\eet;
                               ..\..\source\xmlsec;..\..\source\vcruntime;..\..\source\httpclient
  Delphi Compiler Options -> Unit Output Directory: .\dcu

*}


uses
  Forms,
  u_main in '..\u_main.pas' {TestEETForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTestEETForm, TestEETForm);
  Application.Run;
end.
