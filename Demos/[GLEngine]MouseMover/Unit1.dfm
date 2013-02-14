object Form1: TForm1
  Left = 295
  Top = 159
  Width = 1036
  Height = 727
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
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 1020
    Height = 689
    Align = alClient
    Caption = 'Panel'
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    OnMouseMove = Panel1MouseMove
    OnMouseUp = Panel1MouseUp
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 952
    Top = 8
  end
end
