object dmImportaDados: TdmImportaDados
  OldCreateOrder = False
  Height = 231
  Width = 267
  object dsProdutos: TDataSource
    DataSet = cdsProdutos
    Left = 32
    Top = 24
  end
  object dsClientes: TDataSource
    DataSet = cdsClientes
    Left = 32
    Top = 88
  end
  object cdsProdutos: TClientDataSet
    PersistDataPacket.Data = {
      C40000009619E0BD010000001800000007000000000003000000C40003736571
      04000100000000000A63645F70726F6475746F01004900000001000557494454
      480200020014000C646573635F70726F6475746F010049000000010005574944
      544802000200140009756E5F6D65646964610100490000000100055749445448
      0200020014000F6661746F725F636F6E76657273616F04000100000000000C70
      65736F5F6C69717569646F08000400000000000A7065736F5F627275746F0800
      0400000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'seq'
        DataType = ftInteger
      end
      item
        Name = 'cd_produto'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'desc_produto'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'un_medida'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'fator_conversao'
        DataType = ftInteger
      end
      item
        Name = 'peso_liquido'
        DataType = ftFloat
      end
      item
        Name = 'peso_bruto'
        DataType = ftFloat
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 96
    Top = 24
    object cdsProdutosseq: TIntegerField
      DisplayLabel = 'Seq'
      FieldName = 'seq'
    end
    object cdsProdutoscd_produto: TStringField
      DisplayLabel = 'C'#243'd Produto'
      FieldName = 'cd_produto'
    end
    object cdsProdutosdesc_produto: TStringField
      DisplayLabel = 'Nome Produto'
      FieldName = 'desc_produto'
    end
    object cdsProdutosun_medida: TStringField
      DisplayLabel = 'UN Medida'
      FieldName = 'un_medida'
    end
    object cdsProdutosfator_conversao: TIntegerField
      DisplayLabel = 'Fator Convers'#227'o'
      FieldName = 'fator_conversao'
    end
    object cdsProdutospeso_liquido: TFloatField
      DisplayLabel = 'Peso Liquido'
      FieldName = 'peso_liquido'
    end
    object cdsProdutospeso_bruto: TFloatField
      DisplayLabel = 'Peso Bruto'
      FieldName = 'peso_bruto'
    end
  end
  object cdsClientes: TClientDataSet
    PersistDataPacket.Data = {
      190100009619E0BD01000000180000000A000000000003000000190103736571
      04000100000000000A63645F636C69656E746504000100000000000A6E6D5F63
      6C69656E746501004900000001000557494454480200020014000763656C756C
      6172010049000000010005574944544802000200140005656D61696C01004900
      000001000557494454480200020014000874656C65666F6E6501004900000001
      00055749445448020002001400086370665F636E706A01004900000001000557
      494454480200020014000572675F696501004900000001000557494454480200
      020014001064745F6E6173635F66756E646163616F0400060000000000097470
      5F706573736F6101004900000001000557494454480200020002000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'seq'
        DataType = ftInteger
      end
      item
        Name = 'cd_cliente'
        DataType = ftInteger
      end
      item
        Name = 'nm_cliente'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'celular'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'email'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'telefone'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'cpf_cnpj'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'rg_ie'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'dt_nasc_fundacao'
        DataType = ftDate
      end
      item
        Name = 'tp_pessoa'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 96
    Top = 88
    object cdsClientesseq: TIntegerField
      DisplayLabel = 'Seq'
      FieldName = 'seq'
    end
    object cdsClientescd_cliente: TIntegerField
      DisplayLabel = 'C'#243'd Cliente'
      FieldName = 'cd_cliente'
    end
    object cdsClientesnm_cliente: TStringField
      DisplayLabel = 'Nome Cliente'
      FieldName = 'nm_cliente'
    end
    object cdsClientestp_pessoa: TStringField
      FieldName = 'tp_pessoa'
      Size = 2
    end
    object cdsClientescelular: TStringField
      DisplayLabel = 'Celular'
      FieldName = 'celular'
    end
    object cdsClientesemail: TStringField
      DisplayLabel = 'Email'
      FieldName = 'email'
    end
    object cdsClientestelefone: TStringField
      DisplayLabel = 'Telefone'
      FieldName = 'telefone'
    end
    object cdsClientescpf_cnpj: TStringField
      DisplayLabel = 'CPF/CNPJ'
      FieldName = 'cpf_cnpj'
    end
    object cdsClientesrg_ie: TStringField
      DisplayLabel = 'RG/IE'
      FieldName = 'rg_ie'
    end
    object cdsClientesdt_nasc_fundacao: TDateField
      DisplayLabel = 'Data Nasc. Funda'#231#227'o'
      FieldName = 'dt_nasc_fundacao'
    end
  end
end
