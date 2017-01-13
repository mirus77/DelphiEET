# DelphiEET
Delphi component for registered sale data messages. http://www.etrzby.cz 


## Use  with USE_LIBEET
Demo need library.

```
libeetsigner.dll # source at : https://github.com/mirus77/libeet
 - needed installed Visual C++ Redistributable Packages for Visual Studio 2013
```
Delphi project Options for demo TestEET.dpr with USE_LIBEET

```
  Delphi Compiler Options -> Conditional Defines : 
      USE_INDY - for using in Windows XP required
      USE_LIBEET - for using with libeetsigner
  Delphi Compiler Options -> Output Directory: ..\bin
  Delphi Compiler Options -> Search Path: $(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\vcruntime
  Delphi Compiler Options -> Unit Output Directory: .\dcu
```


## Use without USE_LIBEET
Demo need libxml2 and libxmlsec library from : ftp://ftp.zlatkovic.com/libxml/64bit/
```
libcharset-1.dll
libeay32.dll
libexslt-0.dll
libgcc_s_dw2-1.dll
libiconv-2.dll
libintl-8.dll
libltdl-7.dll
libwinpthread-1.dll
libxml2-2.dll
libxmlsec1-openssl.dll
libxmlsec1.dll
libxslt-1.dll
openssl.exe (for testing)
ssleay32.dll
xmlsec1.exe (for testing)
zlib1.dll
```

Delphi project Options for demo TestEET.dpr

```
  Delphi Compiler Options -> Conditional Defines : USE_INDY - for using in Windows XP required and existing  sources $(BDS)\source\soap. This is not usable for Delphi Starter Edition.
  Delphi Compiler Options -> Output Directory: ..\bin
  Delphi Compiler Options -> Search Path: $(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\synapse;..\include\szutils;..\include\xmlsec;..\include\vcruntime
  Delphi Compiler Options -> Unit Output Directory: .\dcu
```
