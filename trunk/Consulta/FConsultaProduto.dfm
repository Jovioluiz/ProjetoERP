object frmConsultaProdutos: TfrmConsultaProdutos
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsSingle
  Caption = 'Consulta de Produtos'
  ClientHeight = 746
  ClientWidth = 1198
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1198
    Height = 746
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 1194
    ExplicitHeight = 745
    DesignSize = (
      1198
      746)
    object Label1: TLabel
      Left = 16
      Top = 594
      Width = 96
      Height = 16
      Caption = #218'ltimas Entradas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 426
      Width = 45
      Height = 16
      HelpType = htKeyword
      HelpKeyword = 'spli'
      Caption = 'Estoque'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnPesquisar: TButton
      Left = 1092
      Top = 58
      Width = 89
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Pesquisar'
      TabOrder = 1
      OnClick = btnPesquisarClick
    end
    object cbAtivo: TCheckBox
      Left = 199
      Top = 35
      Width = 67
      Height = 17
      Caption = 'Ativo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object cbEstoque: TCheckBox
      Left = 272
      Top = 32
      Width = 97
      Height = 17
      Hint = 'Filtra produtos com estoque'
      Caption = 'Com Estoque'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object dbGridProduto: TDBGrid
      Left = 16
      Top = 94
      Width = 709
      Height = 315
      Anchors = [akLeft, akTop, akRight]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      PopupMenu = popProduto
      TabOrder = 4
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbGridProdutoCellClick
    end
    object cbCodigo: TCheckBox
      Left = 15
      Top = 35
      Width = 75
      Height = 17
      Caption = 'C'#243'digo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object cbDescricao: TCheckBox
      Left = 96
      Top = 35
      Width = 97
      Height = 17
      Caption = 'Descri'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 726
      Width = 1196
      Height = 19
      AutoHint = True
      Panels = <>
      ExplicitTop = 725
      ExplicitWidth = 1192
    end
    object edtPesquisa: TEdit
      Left = 16
      Top = 58
      Width = 1070
      Height = 26
      Anchors = [akLeft, akTop, akRight]
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 1066
    end
    object dbGridUltimasEntradas: TDBGrid
      Left = 16
      Top = 616
      Width = 1165
      Height = 104
      Anchors = [akLeft, akTop, akRight, akBottom]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 8
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object dbgriPrecos: TDBGrid
      Left = 739
      Top = 94
      Width = 442
      Height = 315
      Anchors = [akTop, akRight]
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 9
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object dbGridEstoque: TDBGrid
      Left = 16
      Top = 448
      Width = 1165
      Height = 127
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 10
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object popProduto: TPopupMenu
    Left = 608
    Top = 16
    object VisualizarProduto1: TMenuItem
      Caption = 'Visualizar Produto'
      OnClick = VisualizarProduto1Click
    end
    object VisualizarCdigodeBarras1: TMenuItem
      Caption = 'Visualizar C'#243'digos de Barras'
      OnClick = VisualizarCdigodeBarras1Click
    end
  end
end
