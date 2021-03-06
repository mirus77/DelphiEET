﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿# DelphiEET
Delphi component for registered sale data messages. http://www.etrzby.cz

- this library may be compiled with 
  * Delphi 7 (Indy10, SecureBridge, Synapse) 
  * Delphi 2007 (Indy10, SecureBridge, Synapse)
  * Delphi 10.2 Tokio (Indy10, WinInet, SecureBridge, Synapse)
  * Delphi 10.3 Rio (Indy10, Net.HttpClient, SecureBridge, Synapse)


## Use  with USE_LIBEET
Demo need library.

```
libeetsigner.dll # source at : https://github.com/mirus77/libeet
 - needed installed Visual C++ Redistributable Packages for Visual Studio 2013
openssl 1.0.x (libeay32.dll, ssleay32.dll) libs for Indy, Synapse Https communication
 - can be used openssl lib from https://indy.fulgan.com/SSL/ or from project bin directory
```
Delphi project Options for demo TestEET.dpr with USE_LIBEET

```
  Delphi Compiler Options -> Conditional Defines :
      USE_LIBEET - use wrapper libeetsigner.dll - static compiled into one library (libxml2, xmlsec, openssl)
                   compiled with Visual Studio 2013 U5 Express - VC12 (VS Runtime 2013) needed MSVCR120.dll
      USE_VS_LIBS - use libxml2 and xmlsec compiled with Visual Studio
                 solution for time_t compatibility
                 VS 2013 and lower using MSVCRxxx.dll
                 VS 2015 and higher VCRUNTIME140.dll (ucrtbase.dll)
  
  Select EETHttpClient directives :
      USE_SYNAPSE_CLIENT - use Synapse library for HTTP Post (WinXP and higher)
      or USE_SBRIDGE_CLIENT - use SecureBridge components from www.devart.com for HTTP Post (WinXP and higher)
      or USE_INDY_CLIENT - use Indy 10 components for HTTP Post (WinXP and higher)
      or USE_NETHTTP_CLIENT - use Net.HttpClient with Delphi XE8 and higher for HTTP Post (multiplatform)  

  Delphi Compiler Options -> Output Directory: ..\..\bin
  Delphi Compiler Options -> Search Path:
      ..\..\source\databinding;..\..\source\eet;
      ..\..\source\xmlsec;..\..\source\vcruntime;..\..\source\httpclient
  Delphi Compiler Options -> Unit Output Directory: .\dcu
```


## Use without USE_LIBEET
Demo need library.
```
Self compiled libXML, XMLSEC with Visual Studio (build scripts at https://github.com/mirus77/build_xmlsoft).
```

```
libeay32.dll
libexslt.dll
libiconv.dll
libxml2.dll
libxmlsec-openssl.dll
libxmlsec.dll
libxslt.dll
openssl.exe (for testing)
ssleay32.dll
xmlsec.exe (for testing)
```

Delphi project Options for demo TestEET.dpr

```
  Delphi Compiler Options -> Conditional Defines :  
      USE_VS_LIBS - use libeetsigner.dll in debug mode
	  
  Select EETHttpClient directives :
      USE_SYNAPSE_CLIENT - use Synapse library for HTTP Post (WinXP and higher)
      or USE_SBRIDGE_CLIENT - use SecureBridge components from www.devart.com for HTTP Post (WinXP and higher)
      or USE_INDY_CLIENT - use Indy 10 components for HTTP Post (WinXP and higher)
      or USE_NETHTTP_CLIENT - use Net.HttpClient with Delphi XE8 and higher for HTTP Post (multiplatform)  
	  
  Delphi Compiler Options -> Output Directory: ..\..\bin
  Delphi Compiler Options -> Search Path:
      ..\..\source\databinding;..\..\source\eet;
      ..\..\source\vcruntime;..\..\source\httpclient
  Delphi Compiler Options -> Unit Output Directory: .\dcu
```

## Donation

If this project helps you shorten development time, you can give me a donation :)

| PayPal button | PayPal QR Code |
| --------------- | ----------------- |
| [![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=V8LPMXJDTCUCE&currency_code=CZK&source=url) | <img src="https://raw.githubusercontent.com/mirus77/DelphiEET/master/img/QR_paypal.png" alt="QR Code for PayPal" height="100" width="100"> |















