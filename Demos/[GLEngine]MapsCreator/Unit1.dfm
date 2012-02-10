object Form1: TForm1
  Left = 370
  Top = 212
  Width = 817
  Height = 688
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 616
    Height = 650
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    OnMouseMove = Panel1MouseMove
    OnMouseUp = Panel1MouseUp
  end
  object Panel3: TPanel
    Left = 616
    Top = 0
    Width = 185
    Height = 650
    Align = alRight
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 32
      Top = 552
      Width = 121
      Height = 33
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1088#1090#1091
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 32
      Top = 592
      Width = 121
      Height = 33
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1072#1088#1090#1091
      OnClick = SpeedButton2Click
    end
    object Panel2: TPanel
      Left = 48
      Top = 8
      Width = 89
      Height = 17
      Caption = #1087#1088#1086#1083#1086#1078#1080#1090#1100' '#1087#1091#1090#1100
      TabOrder = 0
      OnClick = Panel2Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 16
    Top = 40
  end
  object SaveDialog1: TSaveDialog
    Left = 656
    Top = 520
  end
  object OpenDialog1: TOpenDialog
    Left = 688
    Top = 520
  end
end
