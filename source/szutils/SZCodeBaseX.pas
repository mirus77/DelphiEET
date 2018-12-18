unit SZCodeBaseX;

{ Version 1.1

 The contents of this file are subject to the Mozilla Public License
 Version 1.1 (the "License"); you may not use this file except in compliance
 with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

 Software distributed under the License is distributed on an "AS IS" basis,
 WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
 specific language governing rights and limitations under the License.

 The original code is SZCodeBaseX.pas, released 15. July, 2004.

 The initial developer of the original code is
 Sasa Zeman (public@szutils.net, www.szutils.net)

 Copyright(C) 2004 Sasa Zeman. All Rights Reserved.
}

{--------------------------------------------------------------------

Encode/Decode algorithms for Base16, Base32 and Base64
Reference: RFC 3548

- Universal Encode/Decode algorithms for Base16, Base32 and Base64

- Standard Base16, Base32 and Base64 encoding/decoding functions

- Reference: RFC 3548, full compatibility

- You may easily create your own Encode/Decode functions based on your own specific codes

Revision History:

Version 1.1.0, 21. August 2004
  - Optimized version, more than 35 times speed acceleration,
    the fastest and the simplest Base32 and Base64 encoder/decoder

Version 1.0.0, 15. July 2004
  - Initial version

  Author   : Sasa Zeman
  E-mail   : public@szutils.net or sasaz72@mail.ru
  Web site : www.szutils.net
}

interface

uses classes;

// Universal Encode/Decode algorithms for Base16, Base32 and Base64

function SZEncodeBaseX(const S: ansistring; const Codes: ansistring; BITS: integer; FullQuantum : integer = 0): ansistring;
function SZDecodeBaseX(const S: ansistring; const Codes: ansistring; BITS: integer): ansistring;


// Standard Base16, Base32 and Base64 encoding/decoding functions
// RFC 3548 incompatibility for encoding Base32 and Base64 - no padding keys

function SZEncodeBase16(const S: ansistring): ansistring;
function SZDecodeBase16(const S: ansistring): ansistring;

function SZEncodeBase32(const S: ansistring): ansistring;
function SZDecodeBase32(const S: ansistring): ansistring;

function SZEncodeBase64(const S: ansistring): ansistring;
function SZDecodeBase64(const S: ansistring): ansistring;

function SZEncodeBase64URL(const S: ansistring): ansistring;
function SZDecodeBase64URL(const S: ansistring): ansistring;

// Full RFC 3548 compatibility
function SZFullEncodeBase32(const S: ansistring): ansistring;
function SZFullEncodeBase64(const S: ansistring): ansistring;
function SZFullEncodeBase64URL(const S: ansistring): ansistring;

implementation

uses SysUtils;

function SZEncodeBaseX(const S: ansistring; const Codes: ansistring; BITS: integer; FullQuantum : integer = 0): ansistring;
{
 Universal Encode algorithm for Base16, Base32 and Base64
 Reference: RFC 3548
 RFC incompatibility: No padding keys
}

var
  i: integer;
  B8, I8: integer;
  pIN, pOUT: pByte;
  TotalIn, TotalOut: integer;

  IM: integer;
begin

  TotalIn  := length(s);
  TotalOut := TotalIn shl 3; // * 8

  if TotalOut mod BITS > 0 then
    TotalOut:= TotalOut div BITS +1
  else
    TotalOut:= TotalOut div BITS;

  if FullQuantum>0 then
  begin
    IM:=TotalOut mod FullQuantum;

    if IM>0 then
      TotalOut:= TotalOut + FullQuantum-IM;
  end
  else
    IM:=0;

  SetLength(Result,TotalOut);

  pIN :=@S[1];
  pOUT:=@Result[1];

  B8:=0;
  I8:=0;

  // Start coding

  for i := 1 to TotalIn do
  begin
    B8 := B8 shl 8;
    B8 := B8 or pIN^;
    I8 := I8 + 8;

    inc(pIN);

    while I8 >= BITS do
    begin

      I8 := (I8 - BITS);

      // Get first BITS of bits
      pansichar(pOUT)^ := Codes[(B8 shr I8)+1];
      inc(pOUT);

      // Return position back for BITS bits
      B8 := B8 - ((B8 shr I8) shl I8);
    end;
  end;

  // If something left
  if I8 > 0 then
  begin
    pansichar(pOUT)^ := Codes[ (B8 shl (BITS-I8)) + 1];
    inc(pOUT);
  end;

  if IM>0 then
    FillChar( pOUT^, FullQuantum - IM ,'=');

end;

function SZDecodeBaseX(const S: ansistring; const Codes: ansistring; BITS: integer): ansistring;
{
 Universal Decode algorithm for Base16, Base32 and Base64
 Reference: RFC 3548 - full compatibility
}

var
  i: Integer;
  B8, I8 : integer;
  pIN, pOUT: pByte;
  TotalIN, TotalOUT, Count: integer;

  EnabledCodes: array [0..255] of integer;

begin

  TotalIN  := length(s);
  TotalOUT := (TotalIN * BITS) shr 3; //div 8;

  SetLength(Result, TotalOut);

  pIN  := @S[1];
  pOUT := @Result[1];

  B8:=0;
  I8:=0;

  // Create table to acces to code emideatelly
  FillChar(EnabledCodes,255,#0);

  for i := 1 to length(Codes) do
    EnabledCodes[ byte( Codes[i] ) ] := i;

  // Start decoding
  count := 0;
  for i := 1 to TotalIN do
  begin

    if EnabledCodes[pIN^] > 0 then
    begin

      B8 := B8 shl BITS;
      B8 := B8 or (EnabledCodes[pIN^]-1);

      I8 := I8 + BITS;

      while I8 >= 8 do
      begin
        I8 := I8 - 8;

        pOUT^ := B8 shr I8;
        inc( pOUT );

        inc(count)
      end;

      inc(pIN);
    end
    else
      break
  end;

  if count <> TotalOUT then
    SetLength(Result, count);

end;

////////////////////////
/// ADD Padding Keys ///
////////////////////////
function AddPaddingKeys(const s: ansistring; FullQuantum: integer):ansistring;
{
 Adding necessary padding keys to create a full
 RFC 3548 compatibility string
}
var
  IM: integer;
begin
  IM:=length(s) mod FullQuantum;

  if IM>0 then
    Result:=s+ansistring(StringOfChar('=',FullQuantum-IM))
  else
    Result:=s
end;

////////////////////
///    Base16    ///
////////////////////

function SZEncodeBase16(const S: ansistring): ansistring;
{
 Encode algorithm for Base16
 Reference: RFC 3548 - full compatibility
}
const
  Codes = '0123456789ABCDEF';
  BITS = 4;
begin
  Result:=SZEncodeBaseX(S, Codes, BITS)
end;

function SZDecodeBase16(const S: ansistring): ansistring;
{
 Decode algorithm for Base16
 Reference: RFC 3548 - full compatibility
}
const
  Codes = '0123456789ABCDEF';
  BITS = 4;
begin
  Result:=SZDecodeBaseX(S, Codes, BITS)
end;


////////////////////
///    Base32    ///
////////////////////

function SZDecodeBase32(const S: ansistring): ansistring;
{
 Decode algorithm for Base32
 Reference: RFC 3548 - full compatibility
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  BITS = 5;
begin
  Result:=SZDecodeBaseX(S, Codes, BITS)
end;

function SZEncodeBase32(const S: ansistring): ansistring;
{
 Encode algorithm for Base32
 Reference: RFC 3548
 RFC incompatibility: No padding keys
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  BITS = 5;
begin
  Result:=SZEncodeBaseX(S, Codes, BITS)
end;

function SZFullEncodeBase32(const S: ansistring): ansistring;
{
 Encode algorithm for Base32
 Reference: RFC 3548 - full compatibility
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  BITS = 5;

  // Result number of chars must be integral multiple of
  // 40 input bits div 5 output group bits
  FullQuantum = 40 div 5;
begin
  // Slow
  // Result:=AddPaddingKeys(SZEncodeBase32(S),FullQuantum);

  Result:=SZEncodeBaseX(S, Codes, BITS, FullQuantum)
end;


////////////////////
///    Base64    ///
////////////////////

function SZDecodeBase64(const S: ansistring): ansistring;
{
  Decode algorithm for Base64
  Reference: RFC 3548 - full compatibility
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  BITS = 6;
begin
  Result:=SZDecodeBaseX(S, Codes, BITS)
end;

function SZEncodeBase64(const S: ansistring): ansistring;
{
  Encode algorithm for Base64
  Reference: RFC 3548
  RFC incompatibility: No padding keys
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  BITS = 6;
begin
  Result:=SZEncodeBaseX(S, Codes, BITS)
end;

function SZFullEncodeBase64(const S: ansistring): ansistring;
{
  Encode algorithm for Base64
  Reference: RFC 3548 - full compatibility
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  BITS = 6;

  // Result number of chars must be integral multiple of
  // 24 input bits div 6 output group bits
  FullQuantum = 24 div 6;
begin
  // Slow
  // Result:=AddPaddingKeys(SZEncodeBase64(S),FullQuantum);

  Result:=SZEncodeBaseX(S, Codes, BITS,FullQuantum)
end;

////////////////////
///  Base64URL   ///
////////////////////

function SZDecodeBase64URL(const S: ansistring): ansistring;
{
  Decode algorithm for Base64, URL tabale
  Reference: RFC 3548 - full compatibility
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  BITS = 6;
begin
  Result:=SZDecodeBaseX(S, Codes, BITS)
end;

function SZEncodeBase64URL(const S: ansistring): ansistring;
{
  Encode algorithm for Base64, URL tabale
  Reference: RFC 3548
  RFC incompatibility: No padding keys
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  BITS = 6;
begin
  Result:=SZEncodeBaseX(S, Codes, BITS)
end;

function SZFullEncodeBase64URL(const S: ansistring): ansistring;
{
  Encode algorithm for Base64, URL tabale
  Reference: RFC 3548 - full compatibility
}
const
  Codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  BITS = 6;

  // Result number of chars must be integral multiple of
  // 24 input bits div 6 output group bits
  FullQuantum = 24 div 6;
begin
  // Slow
  // Result:=AddPaddingKeys(SZEncodeBase64URL(S),FullQuantum);

  Result:=SZEncodeBaseX(S, Codes, BITS, FullQuantum)
end;

////////////////////
///      End     ///
////////////////////

end.
