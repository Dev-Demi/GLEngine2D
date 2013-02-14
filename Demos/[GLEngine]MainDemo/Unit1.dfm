object Form1: TForm1
  Left = 624
  Top = 208
  Width = 775
  Height = 556
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    759
    518)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 484
    Width = 12
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '50'
  end
  object Button1: TButton
    Left = 8
    Top = 476
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1089#1090#1072#1088#1090
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 751
    Height = 461
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 1
    OnResize = Panel1Resize
  end
  object Button2: TButton
    Left = 88
    Top = 476
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1089#1090#1086#1087
    TabOrder = 2
    OnClick = Button2Click
  end
  object TrackBar1: TTrackBar
    Left = 168
    Top = 476
    Width = 209
    Height = 33
    Anchors = [akLeft, akBottom]
    Max = 500
    Min = 1
    Position = 50
    TabOrder = 3
    OnChange = TrackBar1Change
  end
  object ComboBox1: TComboBox
    Left = 424
    Top = 484
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 4
    Text = '4'
    Items.Strings = (
      '0'
      '2'
      '4'
      '8'
      '16'
      '32')
  end
  object CheckBox1: TCheckBox
    Left = 576
    Top = 488
    Width = 73
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'AntiAlias'
    TabOrder = 5
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Top = 16
  end
end
