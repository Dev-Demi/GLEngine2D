object Form1: TForm1
  Left = 192
  Top = 127
  Caption = 'Form1'
  ClientHeight = 522
  ClientWidth = 733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 733
    Height = 481
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitWidth = 729
    ExplicitHeight = 480
  end
  object Panel2: TPanel
    Left = 0
    Top = 481
    Width = 733
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 480
    ExplicitWidth = 729
    object Button1: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 96
    Top = 488
  end
end
