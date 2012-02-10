object Form1: TForm1
  Left = 609
  Top = 300
  Width = 655
  Height = 252
  Caption = 'MultiView'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 224
    Top = 7
    Width = 200
    Height = 200
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 16
    Top = 7
    Width = 200
    Height = 200
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 432
    Top = 7
    Width = 200
    Height = 200
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
end
