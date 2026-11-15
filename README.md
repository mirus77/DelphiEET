# DelphiEET
Delphi component for sending sales records to the Czech **EET 2.0** service (https://eet.gov.cz).

> **EET 2.0 basic client.** The library signs the message (WS-Security, RSA-SHA256, Exclusive C14N),
> sends it directly to the EET server, verifies the response signature, and returns the **POK** confirmation code.
> It has no offline queue or automatic resending. It comes with no warranty.
>
> The EET 1.0 version (schema v3, FIK/PKP/BKP) is available in the git history (commit `0dd2c81` and older).

## EET 2.0 at a glance

| | |
|---|---|
| Playground | `https://pg.trzbyeet.gov.cz/eet/services/EETServiceSOAP/v4` |
| Production | `https://trzbyeet.gov.cz/eet/services/EETServiceSOAP/v4` (from 1 Nov 2026 in transitional mode, mandatory from 1 Jan 2027) |
| Schema | `http://fs.gov.cz/eet/schema/v4` (`source/eet/EETXMLSchema.xsd`) |
| Response | `Potvrzeni/@pok` (POK, 39 chars, ends with `-ff` on playground), errors in `Chyba/@kod`, warnings in `Varovani` |
| Changes from 1.0 | `dic_popl` → `eic_popl`, `id_provoz` → `id_jednotky`, no PKP/BKP, no `rezim`/VAT items, amounts are `Double` |

### Certificates (folder `cert`)

| File | Purpose |
|---|---|
| `CA_EET-Playground-*.p12` | Playground test certificates of the taxpayer (password in `password_pokladni_cert_playground.txt`) |
| `ca_eet-root_cert-playground.crt`, `ca_eet-sub_cert-playground.crt` | CA EET playground chain |
| `ica_root_rsa_05-2022.der`, `ica_public_rsa_06-2022.der` | I.CA chain. **The EET 2.0 response is signed by a GFŘ certificate issued by I.CA**, so these must be added via `AddTrustedCertFromFileName`, otherwise response verification fails |
| `DigiCertGlobalRootG2.cer` | Root of the HTTPS server certificate (`RootCertFile` of the HTTP client) |

Set `HttpsTrustName` of the HTTP client to the CN of the server certificate (`pg.trzbyeet.gov.cz` for playground), or leave it empty to skip the CN check.

### Minimal example

```pascal
EET.URL := 'https://pg.trzbyeet.gov.cz/eet/services/EETServiceSOAP/v4';
EET.Signer.LoadPFXCertFromFile('..\cert\CA_EET-Playground-CZ00000019.p12', 'aaaa1111');
EET.Signer.AddTrustedCertFromFileName('..\cert\ca_eet-root_cert-playground.crt');
EET.Signer.AddTrustedCertFromFileName('..\cert\ca_eet-sub_cert-playground.crt');
EET.Signer.AddTrustedCertFromFileName('..\cert\ica_root_rsa_05-2022.der');
EET.Signer.AddTrustedCertFromFileName('..\cert\ica_public_rsa_06-2022.der');
EET.Initialize;

Trzba := EET.NewRevenue;                 // new uuid_zpravy, dat_odesl, prvni_zaslani = true
Trzba.Data.Eic_popl    := 'CZ00000019';
Trzba.Data.Id_jednotky := 273;
Trzba.Data.Id_pokl     := '/5546/RO24';
Trzba.Data.Porad_cis   := '0/6460/ZQ42';
Trzba.Data.Dat_trzby   := EET.DateTimeToXMLTime(Now);
Trzba.Data.Celk_trzba  := 34113;

Odp := EET.SendRevenue(HttpClient, Trzba);
if (EET.ErrorCode = 0) and EET.ValidResponse and (Odp.Potvrzeni.Pok <> '') then
  ShowMessage('POK: ' + Odp.Potvrzeni.Pok);
```

When resending, keep `Data` unchanged and give the header a **new** `uuid_zpravy`, a new `dat_odesl` and `prvni_zaslani = false`.

## Compilers

- Tested for EET 2.0 with Delphi 13 (demo `demo/D13`, Synapse, `USE_LIBEET`).
- The older demos (D7, D2007, DX2, DX3) are kept from EET 1.0 and have not been tested with EET 2.0.

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

| PayPal button | Revolut Me | Buy Me a Coffee | GitHub Sponsors |
| --------------- | --------------- | ----------------- | ----------------- |
| [![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/mirus77) | <img src="https://raw.githubusercontent.com/mirus77/DelphiEET/master/img/revolut.png" alt="Revolut.me"> [Revolut.me](https://revolut.me/mirus77) | [![buymeacoffe](https://raw.githubusercontent.com/mirus77/DelphiEET/master/img/bmc-brand-logo.svg")](https://buymeacoffee.com/mirus77) | [GitHub Sponsors](https://github.com/sponsors/mirus77) |
















