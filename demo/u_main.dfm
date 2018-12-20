object TestEETForm: TTestEETForm
  Left = 283
  Top = 151
  Caption = 'Test EET'
  ClientHeight = 410
  ClientWidth = 932
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
    932
    410)
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
    Width = 932
    Height = 330
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'pnlDebug'
    TabOrder = 1
    object pgcDebug: TPageControl
      Left = 1
      Top = 1
      Width = 930
      Height = 328
      ActivePage = tsRequest
      Align = alClient
      TabOrder = 0
      object tsRequest: TTabSheet
        Caption = 'Po'#382'adavek'
        object grpTrzba: TGroupBox
          Left = 0
          Top = 0
          Width = 922
          Height = 300
          Align = alClient
          Caption = ' Tr'#382'ba '
          TabOrder = 0
          object synmRequest: TSynMemo
            Left = 2
            Top = 15
            Width = 918
            Height = 283
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            TabOrder = 0
            CodeFolding.CollapsedLineColor = clGrayText
            CodeFolding.FolderBarLinesColor = clGrayText
            CodeFolding.ShowCollapsedLine = True
            CodeFolding.IndentGuidesColor = clGray
            CodeFolding.IndentGuides = True
            UseCodeFolding = False
            Gutter.AutoSize = True
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.ShowLineNumbers = True
            Highlighter = synxmlsyn2
            ReadOnly = True
            FontSmoothing = fsmNone
          end
        end
      end
      object tsResponse: TTabSheet
        Caption = 'Odpov'#283#271
        ImageIndex = 1
        object grpResponse: TGroupBox
          Left = 0
          Top = 0
          Width = 888
          Height = 300
          Align = alClient
          Caption = ' Odpoved '
          TabOrder = 0
          object synmResponse: TSynMemo
            Left = 2
            Top = 15
            Width = 884
            Height = 283
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            TabOrder = 0
            CodeFolding.CollapsedLineColor = clGrayText
            CodeFolding.FolderBarLinesColor = clGrayText
            CodeFolding.ShowCollapsedLine = True
            CodeFolding.IndentGuidesColor = clGray
            CodeFolding.IndentGuides = True
            UseCodeFolding = False
            Gutter.AutoSize = True
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.ShowLineNumbers = True
            Highlighter = synxmlsyn2
            ReadOnly = True
            FontSmoothing = fsmNone
          end
        end
      end
      object tsLog: TTabSheet
        Caption = 'Log'
        ImageIndex = 2
        object grpLog: TGroupBox
          Left = 0
          Top = 0
          Width = 888
          Height = 300
          Align = alClient
          Caption = ' Log '
          TabOrder = 0
          object pnlLog: TPanel
            Left = 2
            Top = 15
            Width = 884
            Height = 283
            Align = alClient
            Caption = 'pnlLog'
            TabOrder = 0
            object mmoLog: TMemo
              Left = 1
              Top = 1
              Width = 882
              Height = 281
              Align = alClient
              ScrollBars = ssBoth
              TabOrder = 0
              WordWrap = False
            end
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
    TabOrder = 5
    object lblKeyValidFrom: TLabel
      Left = 1
      Top = 1
      Width = 74
      Height = 23
      Align = alLeft
      Caption = 'lblKeyValidFrom'
      Layout = tlCenter
    end
    object lblKeyValidTo: TLabel
      Left = 89
      Top = 1
      Width = 62
      Height = 23
      Align = alLeft
      Caption = 'lblKeyValidTo'
      Layout = tlCenter
    end
    object lblSpace1: TLabel
      Left = 75
      Top = 1
      Width = 14
      Height = 23
      Align = alLeft
      AutoSize = False
      Caption = ' '
    end
  end
  object pnlKeySubject: TPanel
    Left = 447
    Top = 9
    Width = 443
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '
    TabOrder = 6
    object lblKeySubject: TLabel
      Left = 1
      Top = 1
      Width = 64
      Height = 23
      Align = alLeft
      Caption = 'lblKeySubject'
      Layout = tlCenter
    end
  end
  object synxmlsyn2: TSynXMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    WantBracesParsed = False
    Left = 752
    Top = 208
  end
end
