object formConsulta: TformConsulta
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Consulta'
  ClientHeight = 305
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dbGridConsulta: TDBGrid
    Left = 0
    Top = 0
    Width = 584
    Height = 265
    Align = alTop
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = dbGridConsultaDblClick
  end
  object ds: TDataSource
    DataSet = cds
    Left = 496
    Top = 32
  end
  object cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 536
    Top = 32
  end
end
