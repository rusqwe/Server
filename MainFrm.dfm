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
  PixelsPerInch = 96
  TextHeight = 13
  object grdServer: TStringGrid
    Left = 0
    Top = 0
    Width = 645
    Height = 181
    Align = alClient
    BorderStyle = bsNone
    RowCount = 1
    FixedRows = 0
    TabOrder = 0
    ExplicitTop = -6
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
end
