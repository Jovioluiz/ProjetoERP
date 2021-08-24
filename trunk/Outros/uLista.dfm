object frmLista: TfrmLista
  Left = 0
  Top = 0
  Caption = 'frmLista'
  ClientHeight = 798
  ClientWidth = 1423
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
  object Edit1: TEdit
    Left = 32
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 32
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object btnAdd: TButton
    Left = 32
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = btnAddClick
  end
  object DBGrid1: TDBGrid
    Left = 32
    Top = 143
    Width = 441
    Height = 201
    DataSource = ds
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 136
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
  object edtCont: TEdit
    Left = 32
    Top = 347
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object Button2: TButton
    Left = 504
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 504
    Top = 143
    Width = 273
    Height = 201
    TabOrder = 7
  end
  object DBGrid2: TDBGrid
    Left = 32
    Top = 424
    Width = 202
    Height = 225
    TabOrder = 8
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button3: TButton
    Left = 32
    Top = 393
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 9
    OnClick = Button3Click
  end
  object edtBuscar: TEdit
    Left = 113
    Top = 393
    Width = 121
    Height = 21
    TabOrder = 10
    OnChange = edtBuscarChange
  end
  object Memo2: TMemo
    Left = 248
    Top = 424
    Width = 273
    Height = 225
    Lines.Strings = (
      '')
    TabOrder = 11
  end
  object Button4: TButton
    Left = 248
    Top = 393
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 12
    OnClick = Button4Click
  end
  object dbgridtable: TDBGrid
    Left = 784
    Top = 143
    Width = 473
    Height = 201
    DataSource = dstable
    TabOrder = 13
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button5: TButton
    Left = 784
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 14
    OnClick = Button5Click
  end
  object Memo3: TMemo
    Left = 544
    Top = 424
    Width = 233
    Height = 225
    Lines.Strings = (
      '')
    TabOrder = 15
  end
  object Button6: TButton
    Left = 544
    Top = 393
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 16
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 783
    Top = 391
    Width = 106
    Height = 25
    Caption = 'Listar THashSet'
    TabOrder = 17
    OnClick = Button7Click
  end
  object Memo4: TMemo
    Left = 783
    Top = 422
    Width = 330
    Height = 227
    Lines.Strings = (
      '')
    TabOrder = 18
  end
  object ds: TDataSource
    DataSet = cds
    Left = 168
    Top = 224
  end
  object cds: TClientDataSet
    PersistDataPacket.Data = {
      D40000009619E0BD010000001800000007000000000003000000D4000A63645F
      636C69656E74650400010000000000046E6F6D65010049000000010005574944
      54480200020014000974705F706573736F610100490000000100055749445448
      0200020014000874656C65666F6E650100490000000100055749445448020002
      0014000763656C756C6172010049000000010005574944544802000200140005
      656D61696C0100490000000100055749445448020002001400086370665F636E
      706A01004900000001000557494454480200020014000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 216
    Top = 224
    object cdscd_cliente: TIntegerField
      DisplayWidth = 9
      FieldName = 'cd_cliente'
    end
    object cdsnome: TStringField
      DisplayWidth = 14
      FieldName = 'nome'
    end
    object cdstp_pessoa: TStringField
      DisplayWidth = 14
      FieldName = 'tp_pessoa'
    end
    object cdstelefone: TStringField
      DisplayWidth = 12
      FieldName = 'telefone'
    end
    object cdscelular: TStringField
      DisplayWidth = 11
      FieldName = 'celular'
    end
    object cdsemail: TStringField
      DisplayWidth = 14
      FieldName = 'email'
    end
    object cdscpf_cnpj: TStringField
      DisplayWidth = 12
      FieldName = 'cpf_cnpj'
    end
  end
  object dsPedido: TDataSource
    DataSet = cdsPedido
    Left = 112
    Top = 480
  end
  object cdsPedido: TClientDataSet
    PersistDataPacket.Data = {
      5F0000009619E0BD0100000018000000030000000000030000005F000F69645F
      70656469646F5F76656E646108000100000000000869645F676572616C080001
      00000000000763645F6974656D01004900000001000557494454480200020014
      000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'id_pedido_venda'
        DataType = ftLargeint
      end
      item
        Name = 'id_geral'
        DataType = ftLargeint
      end
      item
        Name = 'cd_item'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 176
    Top = 480
  end
  object cdstable: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'cd_cliente'
        DataType = ftInteger
      end
      item
        Name = 'nr_pedido'
        DataType = ftInteger
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 1073741823
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 1152
    Top = 248
    Content = {
      414442530F00000039010000FF00010001FF02FF030400100000006300640073
      007400610062006C00650005000A0000005400610062006C0065000600000000
      00070000080032000000090000FF0AFF0B040014000000630064005F0063006C
      00690065006E0074006500050014000000630064005F0063006C00690065006E
      00740065000C00010000000E000D000F00011000011100011200011300011400
      01150014000000630064005F0063006C00690065006E0074006500FEFF0B0400
      120000006E0072005F00700065006400690064006F000500120000006E007200
      5F00700065006400690064006F000C00020000000E000D000F00011000011100
      011200011300011400011500120000006E0072005F0070006500640069006400
      6F00FEFEFF16FEFF17FEFF18FEFEFEFF19FEFF1AFF1BFEFEFE0E004D0061006E
      0061006700650072001E00550070006400610074006500730052006500670069
      00730074007200790012005400610062006C0065004C006900730074000A0054
      00610062006C00650008004E0061006D006500140053006F0075007200630065
      004E0061006D0065000A0054006100620049004400240045006E0066006F0072
      006300650043006F006E00730074007200610069006E00740073001E004D0069
      006E0069006D0075006D00430061007000610063006900740079001800430068
      00650063006B004E006F0074004E0075006C006C00140043006F006C0075006D
      006E004C006900730074000C0043006F006C0075006D006E00100053006F0075
      00720063006500490044000E006400740049006E007400330032001000440061
      007400610054007900700065001400530065006100720063006800610062006C
      006500120041006C006C006F0077004E0075006C006C00080042006100730065
      0014004F0041006C006C006F0077004E0075006C006C0012004F0049006E0055
      007000640061007400650010004F0049006E00570068006500720065001A004F
      0072006900670069006E0043006F006C004E0061006D0065001C0043006F006E
      00730074007200610069006E0074004C00690073007400100056006900650077
      004C006900730074000E0052006F0077004C006900730074001800520065006C
      006100740069006F006E004C006900730074001C005500700064006100740065
      0073004A006F00750072006E0061006C000E004300680061006E006700650073
      00}
    object cdstablecd_cliente: TIntegerField
      FieldName = 'cd_cliente'
    end
    object cdstablenr_pedido: TIntegerField
      FieldName = 'nr_pedido'
    end
  end
  object dstable: TDataSource
    DataSet = cdstable
    Left = 1080
    Top = 248
  end
end
