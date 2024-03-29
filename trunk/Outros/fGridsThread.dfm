object fThreads: TfThreads
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form das Threads'
  ClientHeight = 651
  ClientWidth = 907
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTela: TPanel
    Left = 0
    Top = 49
    Width = 907
    Height = 602
    Align = alClient
    TabOrder = 0
    DesignSize = (
      907
      602)
    object DBGrid4: TDBGrid
      Left = 8
      Top = 288
      Width = 426
      Height = 275
      Anchors = [akLeft, akTop, akRight, akBottom]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object DBGrid3: TDBGrid
      Left = 448
      Top = 288
      Width = 427
      Height = 275
      Anchors = [akLeft, akTop, akRight, akBottom]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object DBGrid2: TDBGrid
      Left = 448
      Top = 6
      Width = 417
      Height = 256
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object pnlGrid1: TPanel
      Left = 8
      Top = 6
      Width = 416
      Height = 256
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = True
      TabOrder = 3
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 414
        Height = 254
        Align = alClient
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 907
    Height = 49
    Align = alTop
    TabOrder = 1
    object btnListar: TButton
      Left = 24
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Listar'
      TabOrder = 0
      OnClick = btnListarClick
    end
  end
  object ds1: TDataSource
    DataSet = cds1
    Left = 152
    Top = 120
  end
  object ds2: TDataSource
    DataSet = cds2
    Left = 568
    Top = 152
  end
  object ds3: TDataSource
    DataSet = cds3
    Left = 192
    Top = 408
  end
  object ds4: TDataSource
    DataSet = cds4
    Left = 648
    Top = 416
  end
  object cds1: TClientDataSet
    PersistDataPacket.Data = {
      5A0000009619E0BD0100000018000000020000000000030000005A000A63645F
      70726F6475746F01004900000001000557494454480200020014000C64657363
      5F70726F6475746F01004900000001000557494454480200020014000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'cd_produto'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'desc_produto'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 192
    Top = 120
  end
  object cds2: TClientDataSet
    PersistDataPacket.Data = {
      820000009619E0BD01000000180000000400000000000300000082000769645F
      6974656D040001000000000009756E5F6D656469646101004900000001000557
      494454480200020014000F7469706F5F636F645F626172726173040001000000
      00000D636F6469676F5F62617272617301004900000001000557494454480200
      020014000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'id_item'
        DataType = ftInteger
      end
      item
        Name = 'un_medida'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'tipo_cod_barras'
        DataType = ftInteger
      end
      item
        Name = 'codigo_barras'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 616
    Top = 152
  end
  object cds3: TClientDataSet
    PersistDataPacket.Data = {
      620000009619E0BD01000000180000000300000000000300000062000869645F
      676572616C0800010000000000096E725F70656469646F040001000000000008
      766C5F746F74616C080004000000010007535542545950450200490006004D6F
      6E6579000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'id_geral'
        DataType = ftLargeint
      end
      item
        Name = 'nr_pedido'
        DataType = ftInteger
      end
      item
        Name = 'vl_total'
        DataType = ftCurrency
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 232
    Top = 408
  end
  object cds4: TClientDataSet
    PersistDataPacket.Data = {
      B10000009619E0BD010000001800000006000000000003000000B1000869645F
      676572616C08000100000000000F69645F70656469646F5F76656E6461080001
      00000000000769645F6974656D04000100000000000B766C5F756E6974617269
      6F080004000000010007535542545950450200490006004D6F6E657900087174
      5F76656E6461080004000000000008766C5F746F74616C080004000000010007
      535542545950450200490006004D6F6E6579000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'id_geral'
        DataType = ftLargeint
      end
      item
        Name = 'id_pedido_venda'
        DataType = ftLargeint
      end
      item
        Name = 'id_item'
        DataType = ftInteger
      end
      item
        Name = 'vl_unitario'
        DataType = ftCurrency
      end
      item
        Name = 'qt_venda'
        DataType = ftFloat
      end
      item
        Name = 'vl_total'
        DataType = ftCurrency
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 688
    Top = 416
  end
end
