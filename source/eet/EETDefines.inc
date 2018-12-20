{* ----------------------------------------------------------- *}
{* DelphiEET library at https://github.com/mirus77/DelphiEET   *}
{* License info at file LICENSE                                *}
{* ----------------------------------------------------------- *}

{* For Delphi XE3 and up: *}
{$IF CompilerVersion >= 24.0 }
{$LEGACYIFEND ON}
{$IFEND}

{*
 USE_LIBEET - use wrapper libeetsigner.dll - static compiled into one library (libxml2, xmlsec, openssl)
               compiled with Visual Studio 2013 U5 Express - VC12 (VS Runtime 2013) needed MSVCR120.dll
*}
{$DEFINE USE_LIBEET}

{*
      USE_VS_LIBS - use libxml2 and xmlsec compiled with Visual Studio
                 solution for time_t compatibility
                 VS 2013 and lower using MSVCRxxx.dll
                 VS 2015 and higher VCRUNTIME140.dll (ucrtbase.dll)
      without USE_VS_LIBS use MinGW library and libxmlsec at https://www.aleksey.com/xmlsec/download.html
*}
{$DEFINE USE_VS_LIBS}

{* ----------------------------------------------------------- *}
{* Select HTTP Post Client, choice only one !!!                *}
{* ----------------------------------------------------------- *}
{* -- Indy Components version 10 *}
{.$DEFINE USE_INDY_CLIENT}
{* -- Synapse library *}
{$DEFINE USE_SYNAPSE_CLIENT}
{* -- SecureBridge Components *}
{.$DEFINE USE_SBRIDGE_CLIENT}
{* -- Delphi Net.HttpClient *}
{.$DEFINE USE_NETHTTP_CLIENT}

{* ----------------------------------------------------------- *}
{* EETSigner                                                   *}
{* ----------------------------------------------------------- *}
{* functions SHA1 is independent on libeay32.dll               *}
{* when use synacode.pas unit, do uncomment this               *}
{.$DEFINE USE_SYNACODE}


{* ----------------------------------------------------------- *}
{* Compatibility for non-Unicode Delphi                        *}
{* ----------------------------------------------------------- *}

{$IFNDEF UNICODE}
{$DEFINE LEGACY_RIO}
{$ENDIF}

