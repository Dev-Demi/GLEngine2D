object Form1: TForm1
  Left = 351
  Top = 357
  Width = 670
  Height = 547
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
    Left = 89
    Top = 0
    Width = 565
    Height = 509
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 509
    Align = alLeft
    TabOrder = 1
    object RadioGroup1: TRadioGroup
      Left = 1
      Top = 1
      Width = 87
      Height = 80
      Align = alTop
      Caption = #1042#1080#1076
      ItemIndex = 0
      Items.Strings = (
        '1'
        '2')
      TabOrder = 0
      OnClick = RadioGroup1Click
    end
    object Button1: TButton
      Left = 8
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 136
      Width = 97
      Height = 17
      Caption = 'VSynh'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object TrackBar1: TTrackBar
      Left = 16
      Top = 176
      Width = 45
      Height = 150
      Max = 100
      Min = 1
      Orientation = trVertical
      Position = 1
      TabOrder = 3
    end
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 632
  end
end
