object frmCadProduto: TfrmCadProduto
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Produto'
  ClientHeight = 644
  ClientWidth = 723
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  TextHeight = 13
  object Label1: TLabel
    Left = 43
    Top = 16
    Width = 33
    Height = 13
    Caption = 'C'#243'digo'
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 68
    Height = 13
    Caption = 'Nome Produto'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 96
    Width = 721
    Height = 540
    ActivePage = TabSheetCadastroProduto
    TabOrder = 3
    object TabSheetCadastroProduto: TTabSheet
      Caption = 'Produto'
      object Label3: TLabel
        Left = 3
        Top = 17
        Width = 76
        Height = 13
        Caption = 'Unidade Medida'
      end
      object Label4: TLabel
        Left = 172
        Top = 17
        Width = 81
        Height = 13
        Caption = 'Fator Convers'#227'o'
      end
      object Label5: TLabel
        Left = 358
        Top = 17
        Width = 52
        Height = 13
        Caption = 'Peso Bruto'
      end
      object Label6: TLabel
        Left = 510
        Top = 17
        Width = 59
        Height = 13
        Caption = 'Peso Liquido'
      end
      object Label7: TLabel
        Left = 3
        Top = 69
        Width = 58
        Height = 13
        Caption = 'Observa'#231#227'o'
      end
      object Label8: TLabel
        Left = 3
        Top = 174
        Width = 104
        Height = 14
        Caption = 'C'#243'digo de Barras'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 3
        Top = 206
        Width = 105
        Height = 13
        Caption = 'Tipo C'#243'digo de Barras'
      end
      object tImagem: TImage
        Left = 424
        Top = 232
        Width = 286
        Height = 219
        OnMouseDown = tImagemMouseDown
      end
      object Label13: TLabel
        Left = 424
        Top = 200
        Width = 38
        Height = 13
        Caption = 'Imagem'
      end
      object Label14: TLabel
        Left = 129
        Top = 206
        Width = 39
        Height = 13
        Caption = 'Unidade'
      end
      object Label15: TLabel
        Left = 200
        Top = 206
        Width = 82
        Height = 13
        Caption = 'C'#243'digo de Barras'
      end
      object edtPRODUTOUN_MEDIDA: TEdit
        Left = 85
        Top = 14
        Width = 65
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 0
      end
      object edtPRODUTOFATOR_CONVERSAO: TEdit
        Left = 272
        Top = 14
        Width = 65
        Height = 21
        TabOrder = 1
      end
      object edtPRODUTOPESO_BRUTO: TEdit
        Left = 424
        Top = 14
        Width = 65
        Height = 21
        TabOrder = 2
      end
      object edtPRODUTOPESO_LIQUIDO: TEdit
        Left = 584
        Top = 14
        Width = 65
        Height = 21
        TabOrder = 3
      end
      object memoObservacao: TMemo
        Left = 3
        Top = 88
        Width = 486
        Height = 80
        CharCase = ecUpperCase
        TabOrder = 4
      end
      object DBGridCodigoBarras: TDBGrid
        Left = 3
        Top = 272
        Width = 407
        Height = 179
        DataSource = dmProdutoCodBarras.dsBarras
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 9
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnKeyDown = DBGridCodigoBarrasKeyDown
      end
      object edtCodigoBarras: TEdit
        Left = 200
        Top = 233
        Width = 165
        Height = 21
        TabOrder = 7
      end
      object btnAddCodBarras: TButton
        Left = 376
        Top = 233
        Width = 34
        Height = 25
        Caption = '+'
        TabOrder = 8
        OnClick = btnAddCodBarrasClick
      end
      object Button1: TButton
        Left = 480
        Top = 232
        Width = 1
        Height = 17
        Caption = 'Button1'
        TabOrder = 10
      end
      object btnCarregarImagem: TButton
        Left = 614
        Top = 188
        Width = 96
        Height = 25
        Caption = 'Carregar Imagem'
        TabOrder = 11
        OnClick = btnCarregarImagemClick
      end
      object cbTipoCodBarras: TComboBox
        Left = 3
        Top = 233
        Width = 105
        Height = 21
        TabOrder = 5
        Items.Strings = (
          'Interno'
          'GTIN'
          'Outro')
      end
      object edtUnCodBarras: TEdit
        Left = 129
        Top = 233
        Width = 65
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 6
      end
      object cbLancaAutoPedidoVenda: TCheckBox
        Left = 3
        Top = 41
        Width = 200
        Height = 17
        Caption = 'Lan'#231'a Automaticamente Pedido Venda'
        TabOrder = 12
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Tributa'#231#227'o'
      ImageIndex = 1
      object Label10: TLabel
        Left = 49
        Top = 24
        Width = 111
        Height = 13
        Caption = 'Grupo Tributa'#231#227'o ICMS'
      end
      object Label11: TLabel
        Left = 60
        Top = 64
        Width = 100
        Height = 13
        Caption = 'Grupo Tributa'#231#227'o IPI'
      end
      object Label12: TLabel
        Left = 16
        Top = 104
        Width = 144
        Height = 13
        Caption = 'Grupo Tributa'#231#227'o PIS/COFINS'
      end
      object edtProdutoGrupoTributacaoICMS: TEdit
        Left = 176
        Top = 21
        Width = 49
        Height = 21
        TabOrder = 0
        OnChange = edtProdutoGrupoTributacaoICMSChange
      end
      object edtProdutoGrupoTributacaoIPI: TEdit
        Left = 176
        Top = 61
        Width = 49
        Height = 21
        TabOrder = 1
        OnChange = edtProdutoGrupoTributacaoIPIChange
      end
      object edtProdutoGrupoTributacaoPISCOFINS: TEdit
        Left = 176
        Top = 101
        Width = 49
        Height = 21
        TabOrder = 2
        OnChange = edtProdutoGrupoTributacaoPISCOFINSChange
      end
      object edtProdutoNomeGrupoTributacaoICMS: TEdit
        Left = 248
        Top = 21
        Width = 305
        Height = 21
        TabOrder = 3
      end
      object edtProdutoNomeGrupoTributacaoIPI: TEdit
        Left = 248
        Top = 61
        Width = 305
        Height = 21
        TabOrder = 4
      end
      object edtProdutoNomeGrupoTributacaoPISCOFINS: TEdit
        Left = 248
        Top = 101
        Width = 305
        Height = 21
        TabOrder = 5
      end
    end
  end
  object edtPRODUTOCD_PRODUTO: TEdit
    Left = 82
    Top = 8
    Width = 66
    Height = 21
    Hint = 'C'#243'digo do Produto'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnEnter = edtPRODUTOCD_PRODUTOEnter
    OnExit = edtPRODUTOCD_PRODUTOExit
    OnKeyDown = edtPRODUTOCD_PRODUTOKeyDown
  end
  object edtPRODUTODESCRICAO: TEdit
    Left = 82
    Top = 35
    Width = 586
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 2
  end
  object ckPRODUTOATIVO: TCheckBox
    Left = 176
    Top = 8
    Width = 97
    Height = 17
    Hint = 'Define se o item est'#225' ativo'
    Caption = 'Ativo'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object dlgImagem: TOpenDialog
    Left = 684
    Top = 304
  end
end
