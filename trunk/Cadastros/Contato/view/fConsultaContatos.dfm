object frmConsultaContatos: TfrmConsultaContatos
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Consulta de Contatos'
  ClientHeight = 391
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 391
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 596
    object Label1: TLabel
      Left = 1
      Top = 39
      Width = 46
      Height = 13
      Caption = 'Pesquisar'
    end
    object gridContatos: TDBGrid
      Left = 1
      Top = 87
      Width = 812
      Height = 303
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      PopupMenu = pmOpcoes
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object edtPesquisa: TEdit
      Left = 53
      Top = 36
      Width = 308
      Height = 21
      TabOrder = 1
    end
    object ComboBox1: TComboBox
      Left = 376
      Top = 36
      Width = 145
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = 'Nome'
      Items.Strings = (
        'Nome'
        'Nro Documento')
    end
    object btnPesquisar: TButton
      Left = 527
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Pesquisar'
      TabOrder = 3
      OnClick = btnPesquisarClick
    end
  end
  object pmOpcoes: TPopupMenu
    Left = 768
    Top = 40
    object EditarContato1: TMenuItem
      Caption = 'Editar Contato'
      OnClick = EditarContato1Click
    end
  end
end
