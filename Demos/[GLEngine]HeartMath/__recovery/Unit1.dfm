object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 426
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 692
    Height = 426
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitLeft = -56
    ExplicitTop = -32
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 464
    Top = 320
  end
end
