object frmSplash: TfrmSplash
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSplash'
  ClientHeight = 82
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 8
    Top = 49
    Width = 364
    Height = 25
    Color = clBtnFace
    ParentColor = False
    Progress = 0
  end
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 46
    Height = 19
    Caption = 'Label1'
    Color = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Timer1: TTimer
    Interval = 5
    OnTimer = Timer1Timer
    Left = 344
    Top = 16
  end
end
