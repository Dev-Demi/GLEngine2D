object Form1: TForm1
  Left = 192
  Top = 127
  Width = 749
  Height = 560
  Caption = 'Form1'
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
  object Panel1: TPanel
    Left = 8
    Top = 16
    Width = 713
    Height = 465
    Caption = 'Panel1'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 488
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 96
    Top = 488
  end
end
