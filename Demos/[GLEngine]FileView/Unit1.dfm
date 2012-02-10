object Form1: TForm1
  Left = 192
  Top = 127
  Width = 844
  Height = 640
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
  DesignSize = (
    828
    602)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 602
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnClick = Panel1Click
    OnMouseMove = Panel1MouseMove
    OnResize = Panel1Resize
  end
  object Button1: TButton
    Left = 755
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1055#1091#1089#1082
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 696
    Top = 64
    Width = 121
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 2
    Text = 'c:\'
  end
  object Button2: TButton
    Left = 752
    Top = 96
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1055#1077#1088#1077#1081#1090#1080
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 696
    Top = 96
    Width = 51
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1085#1072#1079#1072#1076
    TabOrder = 4
    OnClick = Button3Click
  end
  object TrackBar1: TTrackBar
    Left = 776
    Top = 128
    Width = 45
    Height = 150
    Anchors = [akTop, akRight]
    Max = 200
    Min = 10
    Orientation = trVertical
    Position = 10
    TabOrder = 5
    OnChange = TrackBar1Change
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 720
    Top = 8
  end
end
