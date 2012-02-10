object Form1: TForm1
  Left = 192
  Top = 126
  Width = 875
  Height = 713
  Caption = 'Form1'
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
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 833
    Height = 609
    Caption = 'Panel1'
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
  end
  object Button1: TButton
    Left = 24
    Top = 640
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Interval = 25
    OnTimer = Timer1Timer
    Left = 96
    Top = 488
  end
end
