# DelphiEET
Delphi component for registered sale data messages. http://www.etrzby.cz 

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
  Delphi Compiler Options -> Conditional Defines : USE_INDY - for using in Windows XP required
  Delphi Compiler Options -> Output Directory: ..\bin
  Delphi Compiler Options -> Search Path: $(BDS)\source\soap;..\include\databinding;..\include\eet;..\include\synapse;..\include\szutils;..\include\xmlsec
  Delphi Compiler Options -> Unit Output Directory: .\dcu
```
