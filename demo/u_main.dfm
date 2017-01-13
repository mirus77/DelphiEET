object TestEETForm: TTestEETForm
  Left = 0
  Top = 0
  Caption = 'Test EET'
  ClientHeight = 551
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    898
    551)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOdeslat: TButton
    Left = 8
    Top = 8
    Width = 208
    Height = 25
    Caption = 'Odeslat tr'#382'bu'
    TabOrder = 0
    OnClick = btnOdeslatClick
  end
  object pnlDebug: TPanel
    Left = 0
    Top = 80
    Width = 898
    Height = 471
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'pnlDebug'
    TabOrder = 1
    object pgcDebug: TPageControl
      Left = 1
      Top = 1
      Width = 896
      Height = 469
      ActivePage = tsRequest
      Align = alClient
      TabOrder = 0
      object tsRequest: TTabSheet
        Caption = 'Po'#382'adavek'
        object grpTrzba: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 882
          Height = 435
          Align = alClient
          Caption = ' Tr'#382'ba '
          TabOrder = 0
          object synmRequest: TSynMemo
            Left = 2
            Top = 15
            Width = 878
            Height = 418
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            TabOrder = 0
            Gutter.AutoSize = True
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.ShowLineNumbers = True
            Highlighter = synxmlsyn2
            ReadOnly = True
          end
        end
      end
      object tsResponse: TTabSheet
        Caption = 'Odpov'#283#271
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object grpResponse: TGroupBox
          Left = 0
          Top = 0
          Width = 888
          Height = 441
          Align = alClient
          Caption = ' Odpoved '
          TabOrder = 0
          object synmResponse: TSynMemo
            Left = 2
            Top = 15
            Width = 884
            Height = 424
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            TabOrder = 0
            Gutter.AutoSize = True
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.ShowLineNumbers = True
            Highlighter = synxmlsyn2
            ReadOnly = True
          end
        end
      end
    end
  end
  object btnVerifyResponse: TButton
    Left = 233
    Top = 8
    Width = 208
    Height = 25
    Caption = 'Ov'#283#345'it podpis odpov'#283'di'
    TabOrder = 2
    OnClick = btnVerifyResponseClick
  end
  object btnFormatOdpoved: TButton
    Left = 233
    Top = 39
    Width = 208
    Height = 25
    Caption = 'Form'#225'tovat XML odpov'#283#271
    TabOrder = 3
    OnClick = btnFormatOdpovedClick
  end
  object btnFormatRequest: TButton
    Left = 8
    Top = 39
    Width = 208
    Height = 25
    Caption = 'Form'#225'tovat XML po'#382'adavek'
    TabOrder = 4
    OnClick = btnFormatRequestClick
  end
  object pnlCertInfo: TPanel
    Left = 447
    Top = 39
    Width = 443
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '
    Padding.Left = 5
    TabOrder = 5
    object lblKeyValidFrom: TLabel
      Left = 6
      Top = 1
      Width = 74
      Height = 23
      Align = alLeft
      Caption = 'lblKeyValidFrom'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object lblKeyValidTo: TLabel
      Left = 94
      Top = 1
      Width = 62
      Height = 23
      Align = alLeft
      Caption = 'lblKeyValidTo'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object lblSpace1: TLabel
      Left = 80
      Top = 1
      Width = 14
      Height = 23
      Align = alLeft
      AutoSize = False
      Caption = ' '
    end
  end
  object pnl1: TPanel
    Left = 447
    Top = 9
    Width = 443
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '
    Padding.Left = 5
    TabOrder = 6
    object lblKeySubject: TLabel
      Left = 6
      Top = 1
      Width = 64
      Height = 23
      Align = alLeft
      Caption = 'lblKeySubject'
      Layout = tlCenter
      ExplicitHeight = 13
    end
  end
  object synxmlsyn2: TSynXMLSyn
    WantBracesParsed = False
    Left = 752
    Top = 208
  end
end
