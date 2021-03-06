object frmVisualizaPedidoVenda: TfrmVisualizaPedidoVenda
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Visualiza'#231#227'o de Pedido de Venda'
  ClientHeight = 673
  ClientWidth = 1026
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010100001000400280100001600000028000000100000002000
    000001000400000000008000000000000000000000001000000000000000B1B1
    B100FFFFFF003434340044444400F5F5F500B0B0B000FEFEFE002F2F2F003131
    310033333300EBEBEB0000000000000000000000000000000000000000001111
    1111111111111111111111111111111111119111111111111111991111111111
    1111991111111111111191111111119996119991111119999999999111117991
    9999999411111111118999991111111115912999991111119999113999991111
    A111111109991111111111111111111111111111111111111111111111110000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1026
    Height = 673
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 2
    object Label1: TLabel
      Left = 131
      Top = 32
      Width = 72
      Height = 13
      Caption = 'N'#250'mero Pedido'
    end
    object Label2: TLabel
      Left = 131
      Top = 66
      Width = 33
      Height = 13
      Caption = 'Cliente'
    end
    object Label3: TLabel
      Left = 231
      Top = 66
      Width = 75
      Height = 13
      Caption = 'Nome Completo'
    end
    object Label4: TLabel
      Left = 575
      Top = 66
      Width = 50
      Height = 13
      Caption = 'Cidade/UF'
    end
    object Label5: TLabel
      Left = 131
      Top = 136
      Width = 87
      Height = 13
      Caption = 'Forma Pagamento'
    end
    object Label6: TLabel
      Left = 575
      Top = 136
      Width = 86
      Height = 13
      Caption = 'Cond. Pagamento'
    end
    object Label16: TLabel
      Left = 131
      Top = 560
      Width = 61
      Height = 13
      Caption = 'Desconto R$'
    end
    object Label17: TLabel
      Left = 213
      Top = 562
      Width = 64
      Height = 13
      Caption = 'Acr'#233'scimo R$'
    end
    object Label18: TLabel
      Left = 301
      Top = 562
      Width = 51
      Height = 13
      Caption = 'Valor Total'
    end
    object lblStatus: TLabel
      Left = 128
      Top = 621
      Width = 110
      Height = 24
      Caption = 'CANCELADO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtCdFormaPgto: TEdit
      Left = 131
      Top = 155
      Width = 87
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 1
    end
    object edtCdCondPgto: TEdit
      Left = 574
      Top = 155
      Width = 87
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 2
      OnChange = edtCdCondPgtoChange
    end
    object edtNomeCondPgto: TEdit
      Left = 672
      Top = 155
      Width = 236
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object dbGridProdutos: TDBGrid
      Left = 128
      Top = 216
      Width = 873
      Height = 321
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 4
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = dbGridProdutosDrawColumnCell
      OnTitleClick = dbGridProdutosTitleClick
    end
    object btnCancelar: TButton
      Left = 906
      Top = 622
      Width = 95
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
    object btnImprimir: TButton
      Left = 22
      Top = 129
      Width = 81
      Height = 36
      Caption = 'Imprimir'
      TabOrder = 5
      OnClick = btnImprimirClick
    end
    object btnSalvar: TButton
      Left = 22
      Top = 171
      Width = 81
      Height = 34
      Caption = 'Salvar'
      TabOrder = 6
    end
    object edtVlTotalPedido: TNumberBox
      Left = 301
      Top = 581
      Width = 76
      Height = 21
      Enabled = False
      Mode = nbmCurrency
      TabOrder = 7
    end
    object edtVlAcrescimoTotalPedido: TNumberBox
      Left = 213
      Top = 581
      Width = 64
      Height = 21
      Enabled = False
      Mode = nbmCurrency
      TabOrder = 8
    end
    object edtVlDescTotalPedido: TNumberBox
      Left = 128
      Top = 581
      Width = 64
      Height = 21
      Enabled = False
      Mode = nbmCurrency
      TabOrder = 9
    end
  end
  object edtNrPedido: TEdit
    Left = 233
    Top = 31
    Width = 105
    Height = 21
    TabOrder = 0
    OnExit = edtNrPedidoExit
  end
  object edtCdCliente: TEdit
    Left = 133
    Top = 87
    Width = 87
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 1
  end
  object edtNomeCliente: TEdit
    Left = 233
    Top = 87
    Width = 329
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 3
  end
  object edtCidadeCliente: TEdit
    Left = 577
    Top = 87
    Width = 329
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 4
  end
  object edtNomeFormaPgto: TEdit
    Left = 233
    Top = 157
    Width = 329
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 5
  end
  object edtFl_orcamento: TCheckBox
    Left = 384
    Top = 33
    Width = 73
    Height = 17
    Caption = 'Or'#231'amento'
    Enabled = False
    TabOrder = 6
  end
  object btnEditarPedido: TButton
    Left = 24
    Top = 33
    Width = 81
    Height = 36
    Caption = 'Editar Pedido'
    TabOrder = 7
    OnClick = btnEditarPedidoClick
  end
end
