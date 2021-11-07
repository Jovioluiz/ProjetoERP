object dmContatos: TdmContatos
  OldCreateOrder = False
  Height = 154
  Width = 219
  object dsContatos: TDataSource
    DataSet = cdsContatos
    Left = 48
    Top = 24
  end
  object cdsContatos: TClientDataSet
    PersistDataPacket.Data = {
      E00000009619E0BD010000001800000007000000000003000000E0000A63645F
      636F6E7461746F04000100000000000974705F706573736F6101004900000001
      000557494454480200020001000A6E6D5F636F6E7461746F0100490000000100
      0557494454480200020032000A6C6F677261646F75726F010049000000010005
      57494454480200020032000662616972726F0100490000000100055749445448
      020002001E00066369646164650100490000000100055749445448020002001E
      000C6E725F646F63756D656E746F010049000000010005574944544802000200
      0F000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'cd_contato'
        DataType = ftInteger
      end
      item
        Name = 'tp_pessoa'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'nm_contato'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'logradouro'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'bairro'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'cidade'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'nr_documento'
        DataType = ftString
        Size = 15
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 128
    Top = 24
  end
end
