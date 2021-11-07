object frmCadContato: TfrmCadContato
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Cadastro Contato'
  ClientHeight = 290
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 34
    Top = 19
    Width = 33
    Height = 13
    Caption = 'C'#243'digo'
  end
  object Label2: TLabel
    Left = 19
    Top = 130
    Width = 48
    Height = 13
    Caption = 'CPF/CNPJ'
  end
  object Label3: TLabel
    Left = 22
    Top = 166
    Width = 45
    Height = 13
    Caption = 'Endere'#231'o'
  end
  object Label4: TLabel
    Left = 39
    Top = 193
    Width = 28
    Height = 13
    Caption = 'Bairro'
  end
  object Label5: TLabel
    Left = 34
    Top = 224
    Width = 33
    Height = 13
    Caption = 'Cidade'
  end
  object Label6: TLabel
    Left = 40
    Top = 103
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object edtDocumento: TEdit
    Left = 80
    Top = 127
    Width = 257
    Height = 21
    TabOrder = 3
  end
  object edtCodigo: TEdit
    Left = 80
    Top = 16
    Width = 49
    Height = 21
    TabOrder = 0
    OnExit = edtCodigoExit
  end
  object edtLogradouro: TEdit
    Left = 80
    Top = 158
    Width = 257
    Height = 21
    TabOrder = 4
  end
  object edtBairro: TEdit
    Left = 80
    Top = 190
    Width = 257
    Height = 21
    TabOrder = 5
  end
  object edtCidade: TEdit
    Left = 80
    Top = 221
    Width = 257
    Height = 21
    TabOrder = 6
  end
  object rgTpPessoa: TRadioGroup
    Left = 152
    Top = 8
    Width = 185
    Height = 86
    Caption = 'Pessoa'
    Items.Strings = (
      'Fisica'
      'Juridica')
    TabOrder = 1
  end
  object edtNome: TEdit
    Left = 80
    Top = 100
    Width = 257
    Height = 21
    TabOrder = 2
  end
end
