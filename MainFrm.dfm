object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 231
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grdServer: TStringGrid
    Left = 0
    Top = 0
    Width = 645
    Height = 131
    Align = alClient
    BorderStyle = bsNone
    RowCount = 1
    FixedRows = 0
    TabOrder = 0
    ExplicitHeight = 181
    ColWidths = (
      64
      64
      64
      64
      64)
    RowHeights = (
      24)
  end
  object Button1: TButton
    Left = 0
    Top = 181
    Width = 645
    Height = 25
    Align = alBottom
    Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 0
    Top = 206
    Width = 645
    Height = 25
    Align = alBottom
    Caption = #1056#1077#1092#1088#1077#1096#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 0
    Top = 156
    Width = 645
    Height = 25
    Align = alBottom
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
    ExplicitLeft = 280
    ExplicitTop = 128
    ExplicitWidth = 75
  end
  object Button4: TButton
    Left = 0
    Top = 131
    Width = 645
    Height = 25
    Align = alBottom
    Caption = 'Button4'
    TabOrder = 4
    OnClick = Button4Click
    ExplicitLeft = 280
    ExplicitTop = 150
    ExplicitWidth = 75
  end
end
