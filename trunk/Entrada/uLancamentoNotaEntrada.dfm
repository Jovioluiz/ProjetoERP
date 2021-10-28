object frmLancamentoNotaEntrada: TfrmLancamentoNotaEntrada
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Lan'#231'amento Nota Entrada'
  ClientHeight = 720
  ClientWidth = 857
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 857
    Height = 720
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 216
      Top = 85
      Width = 38
      Height = 13
      Caption = 'N'#186' Nota'
    end
    object Label2: TLabel
      Left = 47
      Top = 90
      Width = 24
      Height = 13
      Caption = 'S'#233'rie'
    end
    object Label3: TLabel
      Left = 24
      Top = 16
      Width = 47
      Height = 13
      Caption = 'Opera'#231#227'o'
    end
    object Label4: TLabel
      Left = 456
      Top = 16
      Width = 34
      Height = 13
      Caption = 'Modelo'
    end
    object Label5: TLabel
      Left = 16
      Top = 53
      Width = 55
      Height = 13
      Caption = 'Fornecedor'
    end
    object Label6: TLabel
      Left = 426
      Top = 53
      Width = 64
      Height = 13
      Caption = 'Data Emiss'#227'o'
    end
    object Label7: TLabel
      Left = 402
      Top = 85
      Width = 88
      Height = 13
      Caption = 'Data Recebimento'
    end
    object Label8: TLabel
      Left = 24
      Top = 160
      Width = 40
      Height = 13
      Caption = 'Servi'#231'os'
    end
    object Label9: TLabel
      Left = 120
      Top = 160
      Width = 43
      Height = 13
      Caption = 'Produtos'
    end
    object Label10: TLabel
      Left = 208
      Top = 160
      Width = 51
      Height = 13
      Caption = 'Base ICMS'
    end
    object Label12: TLabel
      Left = 316
      Top = 160
      Width = 52
      Height = 13
      Caption = 'Valor ICMS'
    end
    object Label13: TLabel
      Left = 412
      Top = 160
      Width = 26
      Height = 13
      Caption = 'Frete'
    end
    object Label14: TLabel
      Left = 508
      Top = 160
      Width = 14
      Height = 13
      Caption = 'IPI'
    end
    object Label15: TLabel
      Left = 606
      Top = 160
      Width = 16
      Height = 13
      Caption = 'ISS'
    end
    object Label16: TLabel
      Left = 24
      Top = 232
      Width = 45
      Height = 13
      Caption = 'Desconto'
    end
    object Label17: TLabel
      Left = 120
      Top = 232
      Width = 48
      Height = 13
      Caption = 'Acr'#233'scimo'
    end
    object Label18: TLabel
      Left = 316
      Top = 232
      Width = 29
      Height = 13
      Caption = 'Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 619
      Top = 53
      Width = 84
      Height = 13
      Caption = 'Data Lan'#231'amento'
    end
    object Label20: TLabel
      Left = 24
      Top = 320
      Width = 38
      Height = 13
      Caption = 'Produto'
    end
    object Label21: TLabel
      Left = 103
      Top = 320
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object Label22: TLabel
      Left = 392
      Top = 312
      Width = 54
      Height = 13
      Caption = 'Un. Medida'
    end
    object Label23: TLabel
      Left = 456
      Top = 312
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object Label24: TLabel
      Left = 532
      Top = 312
      Width = 26
      Height = 13
      Caption = 'Fator'
    end
    object Label25: TLabel
      Left = 644
      Top = 312
      Width = 64
      Height = 13
      Caption = 'Valor Unit'#225'rio'
    end
    object Label26: TLabel
      Left = 720
      Top = 312
      Width = 51
      Height = 13
      Caption = 'Valor Total'
    end
    object Label27: TLabel
      Left = 520
      Top = 342
      Width = 6
      Height = 13
      Caption = 'X'
    end
    object Label28: TLabel
      Left = 575
      Top = 312
      Width = 49
      Height = 13
      Caption = 'Qtd. Total'
    end
    object Label29: TLabel
      Left = 208
      Top = 232
      Width = 82
      Height = 13
      Caption = 'Outras Despesas'
    end
    object edtNroNota: TEdit
      Left = 260
      Top = 82
      Width = 129
      Height = 21
      TabOrder = 4
      OnExit = edtNroNotaExit
    end
    object edtSerie: TEdit
      Left = 77
      Top = 82
      Width = 52
      Height = 21
      TabOrder = 3
      OnExit = edtSerieExit
    end
    object edtCdFornecedor: TEdit
      Left = 77
      Top = 50
      Width = 52
      Height = 21
      TabOrder = 2
      OnChange = edtCdFornecedorChange
      OnExit = edtCdFornecedorExit
    end
    object edtOperacao: TEdit
      Left = 77
      Top = 13
      Width = 52
      Height = 21
      TabOrder = 0
      OnChange = edtOperacaoChange
      OnExit = edtOperacaoExit
    end
    object edtModelo: TEdit
      Left = 510
      Top = 13
      Width = 44
      Height = 21
      TabOrder = 1
      OnChange = edtModeloChange
      OnExit = edtModeloExit
    end
    object edtNomeOperacao: TEdit
      Left = 144
      Top = 13
      Width = 245
      Height = 21
      Enabled = False
      TabOrder = 28
    end
    object edtNomeFornecedor: TEdit
      Left = 144
      Top = 50
      Width = 245
      Height = 21
      Enabled = False
      TabOrder = 29
    end
    object edtNomeModelo: TEdit
      Left = 560
      Top = 13
      Width = 249
      Height = 21
      Enabled = False
      TabOrder = 30
    end
    object edtDataEmissao: TDateTimePicker
      Left = 510
      Top = 50
      Width = 100
      Height = 21
      Date = 43905.000000000000000000
      Time = 0.811114513890061100
      TabOrder = 5
    end
    object edtDataRecebimento: TDateTimePicker
      Left = 510
      Top = 77
      Width = 100
      Height = 21
      Date = 43905.000000000000000000
      Time = 0.811114641204767400
      TabOrder = 6
    end
    object edtCodProduto: TEdit
      Left = 24
      Top = 339
      Width = 73
      Height = 21
      TabOrder = 18
      OnChange = edtCodProdutoChange
      OnEnter = edtCodProdutoEnter
      OnExit = edtCodProdutoExit
    end
    object edtDescricaoProduto: TEdit
      Left = 103
      Top = 339
      Width = 269
      Height = 21
      Enabled = False
      TabOrder = 31
    end
    object edtUnMedida: TEdit
      Left = 395
      Top = 339
      Width = 51
      Height = 21
      TabOrder = 19
    end
    object edtDataLancamento: TDateTimePicker
      Left = 709
      Top = 53
      Width = 100
      Height = 21
      Date = 43907.000000000000000000
      Time = 0.811114780095522300
      TabOrder = 7
    end
    object btnAddItens: TButton
      Left = 799
      Top = 337
      Width = 42
      Height = 26
      Caption = '+'
      TabOrder = 25
      OnClick = btnAddItensClick
    end
    object DBGridProdutos: TDBGrid
      Left = 24
      Top = 409
      Width = 817
      Height = 265
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 32
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGridProdutosDblClick
      OnKeyDown = DBGridProdutosKeyDown
    end
    object btnConfirmar: TButton
      Left = 632
      Top = 680
      Width = 75
      Height = 25
      Caption = 'Confirmar'
      TabOrder = 26
      OnClick = btnConfirmarClick
    end
    object btnCancelar: TButton
      Left = 726
      Top = 680
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 27
      OnClick = btnCancelarClick
    end
    object edtVlServico: TNumberBox
      Left = 24
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 8
      OnExit = edtVlServicoExit
    end
    object edtVlProduto: TNumberBox
      Left = 120
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 9
      OnExit = edtVlProdutoExit
    end
    object edtBaseIcms: TNumberBox
      Left = 208
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 10
    end
    object edtValorIcms: TNumberBox
      Left = 316
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 11
    end
    object edtValorFrete: TNumberBox
      Left = 412
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 12
      OnExit = edtValorFreteExit
    end
    object edtValorIPI: TNumberBox
      Left = 508
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 13
      OnExit = edtValorIPIExit
    end
    object edtValorISS: TNumberBox
      Left = 606
      Top = 179
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 14
    end
    object edtValorDesconto: TNumberBox
      Left = 24
      Top = 251
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 15
      OnExit = edtValorDescontoExit
    end
    object edtValorAcrescimo: TNumberBox
      Left = 120
      Top = 251
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 16
      OnExit = edtValorAcrescimoExit
    end
    object edtValorOutrasDespesas: TNumberBox
      Left = 208
      Top = 251
      Width = 73
      Height = 21
      Mode = nbmCurrency
      TabOrder = 17
      OnExit = edtValorOutrasDespesasExit
    end
    object edtValorTotalNota: TNumberBox
      Left = 316
      Top = 251
      Width = 73
      Height = 21
      Enabled = False
      Mode = nbmCurrency
      TabOrder = 33
    end
    object edtQuantidade: TNumberBox
      Left = 452
      Top = 339
      Width = 62
      Height = 21
      Mode = nbmFloat
      TabOrder = 20
      OnChange = edtQuantidadeChange
      OnExit = edtQuantidadeExit
    end
    object edtFatorConversao: TNumberBox
      Left = 529
      Top = 339
      Width = 40
      Height = 21
      TabOrder = 21
    end
    object edtQuantidadeTotalProduto: TNumberBox
      Left = 579
      Top = 339
      Width = 50
      Height = 21
      Mode = nbmFloat
      TabOrder = 22
    end
    object edtValorUnitario: TNumberBox
      Left = 644
      Top = 339
      Width = 59
      Height = 21
      Mode = nbmCurrency
      TabOrder = 23
      OnChange = edtValorUnitarioChange
    end
    object edtValorTotalProduto: TNumberBox
      Left = 720
      Top = 339
      Width = 51
      Height = 21
      Mode = nbmCurrency
      TabOrder = 24
    end
  end
  object sqlCabecalho: TFDQuery
    Connection = dm.conexaoBanco
    Left = 112
    Top = 8
  end
end
