object Form1: TForm1
  Left = 378
  Top = 277
  Width = 887
  Height = 442
  Caption = 'Sound'
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
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 849
    Height = 321
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 352
    Width = 209
    Height = 41
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' mp3'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 240
    Top = 336
  end
  object OpenDialog1: TOpenDialog
    Filter = 'mp3|*.mp3'
    Title = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' mp3'
    Left = 280
    Top = 336
  end
end
