object Form1: TForm1
  Left = 378
  Top = 277
  Width = 463
  Height = 469
  Caption = 'SpeedTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 13
    Caption = 'TCanvas'
  end
  object Label2: TLabel
    Left = 224
    Top = 8
    Width = 68
    Height = 13
    Caption = 'TGLEngine2D'
  end
  object PaintBox1: TPaintBox
    Left = 8
    Top = 24
    Width = 200
    Height = 200
  end
  object Label3: TLabel
    Left = 8
    Top = 288
    Width = 120
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1101#1083#1077#1084#1077#1085#1090#1086#1074':'
  end
  object Panel2: TPanel
    Left = 224
    Top = 24
    Width = 200
    Height = 200
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 240
    Width = 201
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1082' '#1090#1077#1089#1090#1072
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 240
    Width = 201
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1082' '#1090#1077#1089#1090#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object SpinEdit1: TSpinEdit
    Left = 136
    Top = 280
    Width = 89
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 10000
  end
  object RadioGroup1: TRadioGroup
    Left = 232
    Top = 280
    Width = 185
    Height = 105
    Caption = #1069#1083#1077#1084#1077#1085#1090#1099
    ItemIndex = 0
    Items.Strings = (
      #1051#1080#1085#1080#1080
      #1055#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082#1080
      #1069#1083#1083#1080#1087#1089#1099
      #1058#1077#1082#1089#1090)
    TabOrder = 4
  end
  object Button3: TButton
    Left = 56
    Top = 392
    Width = 169
    Height = 25
    Caption = 'DrawImage'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 240
    Top = 392
    Width = 169
    Height = 25
    Caption = 'DrawCurrentImage'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 48
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Button5'
    TabOrder = 7
    OnClick = Button5Click
  end
end
