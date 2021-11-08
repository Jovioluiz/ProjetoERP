object frmFiredacETL: TfrmFiredacETL
  Left = 0
  Top = 0
  Caption = 'frmFiredacETL'
  ClientHeight = 527
  ClientWidth = 731
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 168
    Width = 731
    Height = 359
    Align = alBottom
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnListar: TButton
    Left = 32
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Carregar'
    TabOrder = 1
    OnClick = btnListarClick
  end
  object edtCaminho: TEdit
    Left = 32
    Top = 96
    Width = 265
    Height = 21
    TabOrder = 2
  end
  object btnSel: TButton
    Left = 303
    Top = 94
    Width = 42
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = btnSelClick
  end
  object BathMove: TFDBatchMove
    Reader = textReader
    Writer = DataSetWrite
    Mappings = <
      item
        SourceFieldName = 'codigo'
        DestinationFieldName = 'codigo'
      end
      item
        SourceFieldName = 'nome'
        DestinationFieldName = 'nome'
      end
      item
        SourceFieldName = 'unidade'
        DestinationFieldName = 'unidade'
      end
      item
        SourceFieldName = 'fator'
        DestinationFieldName = 'fator'
      end
      item
        SourceFieldName = 'pesoliq'
        DestinationFieldName = 'pesoliq'
      end
      item
        SourceFieldName = 'pesobruto'
        DestinationFieldName = 'pesobruto'
      end>
    LogFileName = 'Data.log'
    Left = 416
    Top = 72
  end
  object DataSetWrite: TFDBatchMoveDataSetWriter
    DataSet = FDMemTable1
    Left = 472
    Top = 96
  end
  object textReader: TFDBatchMoveTextReader
    FileName = 'C:\Users\jovio\Documents\GitHub\ProjetoERP\trunk\produtos_2.csv'
    DataDef.Fields = <
      item
        FieldName = 'codigo'
        DataType = atLongInt
        FieldSize = 5
      end
      item
        FieldName = 'nome'
        DataType = atString
        FieldSize = 13
      end
      item
        FieldName = 'unidade'
        DataType = atString
        FieldSize = 2
      end
      item
        FieldName = 'fator'
        DataType = atLongInt
        FieldSize = 1
      end
      item
        FieldName = 'pesoliq'
        DataType = atFloat
        FieldSize = 3
      end
      item
        FieldName = 'pesobruto'
        DataType = atFloat
        FieldSize = 3
      end>
    DataDef.Delimiter = '"'
    DataDef.Separator = ';'
    DataDef.RecordFormat = rfCustom
    DataDef.WithFieldNames = True
    Left = 368
    Top = 112
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'codigo'
        DataType = ftLargeint
      end
      item
        Name = 'nome'
        DataType = ftString
        Size = 13
      end
      item
        Name = 'unidade'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'fator'
        DataType = ftLargeint
      end
      item
        Name = 'pesoliq'
        DataType = ftFloat
      end
      item
        Name = 'pesobruto'
        DataType = ftFloat
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 560
    Top = 96
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 560
    Top = 184
  end
  object dialog: TOpenDialog
    Left = 672
    Top = 16
  end
end
