object dmUsuario: TdmUsuario
  OldCreateOrder = False
  Height = 150
  Width = 215
  object dsUsuario: TDataSource
    DataSet = cdsUsuario
    Left = 32
    Top = 24
  end
  object cdsUsuario: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 112
    Top = 24
    object cdsUsuarioid_usuario: TIntegerField
      FieldName = 'id_usuario'
    end
    object cdsUsuariologin: TStringField
      FieldName = 'login'
      Size = 50
    end
    object cdsUsuariosenha: TStringField
      FieldName = 'senha'
      Size = 50
    end
  end
end
