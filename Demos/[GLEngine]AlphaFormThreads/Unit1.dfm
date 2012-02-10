object Form1: TForm1
  Left = 434
  Top = 284
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 402
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 32
    Top = 64
    Width = 305
    Height = 273
    Caption = 'Panel1'
    TabOrder = 0
    Visible = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 25
    OnTimer = Timer1Timer
    Left = 48
    Top = 88
  end
end
