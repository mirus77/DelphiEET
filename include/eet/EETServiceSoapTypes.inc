  OdpovedChybaType = class(TRemotable)   { "http://fs.mfcr.cz/eet/schema/v3"[GblCplxMxd] }
  private
    Ftest: boolean;
    FText: string;
    Fkod: integer;
  published
    property kod:   integer  Index (IS_ATTR) read Fkod write Fkod;
    property test:   boolean  Index (IS_ATTR) read Ftest write Ftest;
    property Text:   string  Index (IS_TEXT) read FText write FText;
  end;

  OdpovedVarovaniType = class(TRemotable)   { "http://fs.mfcr.cz/eet/schema/v3"[GblCplxMxd] }
  private
    Fkod_varov: integer;
    FText: string;
  published
    property kod_varov:  integer  Index (IS_ATTR) read Fkod_varov write Fkod_varov;
    property Text:   string  Index (IS_TEXT) read Ftext write Ftext;
  end;

  BkpElementType  = class(TRemotable)       { "http://fs.mfcr.cz/eet/schema/v3"[GblCplxMxd] }
  private
    Fencoding: BkpEncodingType;
    Fdigest: BkpDigestType;
    FText: string;
  published
    property digest:   BkpDigestType  Index (IS_ATTR) read Fdigest write Fdigest;
    property encoding:   BkpEncodingType  Index (IS_ATTR) read Fencoding write Fencoding;
    property Text:   string  Index (IS_TEXT) read FText write FText;
  end;

  PkpElementType  = class(TRemotable)       { "http://fs.mfcr.cz/eet/schema/v3"[GblCplxMxd] }
  private
    Fencoding: PkpEncodingType;
    Fdigest: PkpDigestType;
    Fcipher: PkpCipherType;
    FText: string;
  published
    property cipher:   PkpCipherType  Index (IS_ATTR) read Fcipher write Fcipher;
    property digest:   PkpDigestType  Index (IS_ATTR) read Fdigest write Fdigest;
    property encoding:   PkpEncodingType  Index (IS_ATTR) read Fencoding write Fencoding;
    property Text:   string  Index (IS_TEXT) read FText write FText;
  end;

