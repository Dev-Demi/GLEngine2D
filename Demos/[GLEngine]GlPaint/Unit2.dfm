object Form2: TForm2
  Left = 193
  Top = 130
  BorderStyle = bsToolWindow
  Caption = 'Form2'
  ClientHeight = 607
  ClientWidth = 204
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 39
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088
  end
  object BrushSize: TTrackBar
    Left = 8
    Top = 24
    Width = 185
    Height = 45
    Max = 300
    Min = 1
    Position = 40
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 185
    Height = 249
    Caption = #1062#1074#1077#1090
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 8
      Height = 13
      Caption = 'R'
    end
    object Label3: TLabel
      Left = 56
      Top = 16
      Width = 8
      Height = 13
      Caption = 'G'
    end
    object Label4: TLabel
      Left = 104
      Top = 16
      Width = 7
      Height = 13
      Caption = 'B'
    end
    object Label5: TLabel
      Left = 144
      Top = 16
      Width = 7
      Height = 13
      Caption = 'A'
    end
    object GColor: TTrackBar
      Left = 48
      Top = 32
      Width = 45
      Height = 169
      Max = 255
      Min = 1
      Orientation = trVertical
      Position = 1
      TabOrder = 0
      TickMarks = tmBoth
      OnChange = ColorChange
    end
    object RColor: TTrackBar
      Left = 8
      Top = 32
      Width = 45
      Height = 169
      Max = 255
      Min = 1
      Orientation = trVertical
      Position = 100
      TabOrder = 1
      TickMarks = tmBoth
      OnChange = ColorChange
    end
    object AColor: TTrackBar
      Left = 128
      Top = 32
      Width = 45
      Height = 169
      Max = 255
      Min = 1
      Orientation = trVertical
      Position = 100
      TabOrder = 2
      TickMarks = tmBoth
      OnChange = ColorChange
    end
    object BColor: TTrackBar
      Left = 88
      Top = 32
      Width = 45
      Height = 169
      Max = 255
      Min = 1
      Orientation = trVertical
      Position = 1
      TabOrder = 3
      TickMarks = tmBoth
      OnChange = ColorChange
    end
    object Panel1: TPanel
      Left = 16
      Top = 200
      Width = 153
      Height = 25
      TabOrder = 4
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 344
    Width = 185
    Height = 225
    Caption = #1056#1077#1078#1080#1084' '#1088#1080#1089#1086#1074#1072#1085#1080#1103
    ItemIndex = 4
    Items.Strings = (
      'bmAdd2'
      'bmSrc2Dst'
      'bmMultiply'
      'bmAddMul  '
      'bmAdd '
      'bmNormal'
      'test')
    TabOrder = 2
  end
  object Button1: TButton
    Left = 8
    Top = 576
    Width = 185
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
    TabOrder = 3
    OnClick = Button1Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 104
    Top = 512
  end
end
