unit cCTA_FORMA_PAGAMENTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.UITypes, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Data.FMTBcd, Data.SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.ComCtrls, Vcl.Buttons, uDataModule;

type
  TfrmCadFormaPagamento = class(TForm)
    tpCadFormaPgto: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtCTA_FORMA_PGTOCODIGO: TEdit;
    edtCTA_FORMA_PGTODESCRICAO: TEdit;
    edtCTA_FORMA_PGTOFL_ATIVO: TCheckBox;
    edtCTA_FORMA_PGTOCLASSIFICACAO: TRadioGroup;
    procedure edtCTA_FORMA_PGTOCODIGOExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure LimpaCampos;
    procedure Salvar;
    procedure Excluir;
    procedure validaCampos;

  public
    { Public declarations }

  end;

var
  frmCadFormaPagamento: TfrmCadFormaPagamento;

implementation

uses
  uclCtaFormaPagamento;

{$R *.dfm}

procedure TfrmCadFormaPagamento.edtCTA_FORMA_PGTOCODIGOExit(Sender: TObject);
const
  SQL = 'select                          '+
         '  cd_forma_pag,                 '+
         '  nm_forma_pag,                 '+
         '  fl_ativo,                     '+
         '  tp_classificacao              '+
         'from                            '+
         '  cta_forma_pagamento           '+
         'where                           '+
         '  cd_forma_pag = :cd_forma_pag';
var
  qry: TFDQuery;
begin
  if edtCTA_FORMA_PGTOCODIGO.Text = EmptyStr then
  begin
    edtCTA_FORMA_PGTOCODIGO.SetFocus;
    raise Exception.Create('C�digo n�o pode ser vazio');
  end;

  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL, [StrToInt(edtCTA_FORMA_PGTOCODIGO.Text)]);

    if qry.IsEmpty then
      Exit;

    edtCTA_FORMA_PGTODESCRICAO.Text := qry.FieldByName('nm_forma_pag').AsString;
    edtCTA_FORMA_PGTOFL_ATIVO.Checked := qry.FieldByName('fl_ativo').AsBoolean;
    edtCTA_FORMA_PGTOCLASSIFICACAO.ItemIndex := qry.FieldByName('tp_classificacao').AsInteger;
  finally
    qry.Free;
  end;
end;

procedure TfrmCadFormaPagamento.Excluir;
var
  persistencia: TCtaFormaPagamento;
begin
  persistencia := TCtaFormaPagamento.Create;

  try
    if edtCTA_FORMA_PGTOCODIGO.Text <> '' then
    begin
      if (Application.MessageBox('Deseja Excluir a Forma de Pagamento?', 'Aviso', MB_YESNO) = IDYES) then
      begin
        persistencia.cd_forma_pgto := StrToInt(edtCTA_FORMA_PGTOCODIGO.Text);
        persistencia.Excluir;
        LimpaCampos;
      end;
    end;
  finally
    persistencia.Free;
  end;
end;

procedure TfrmCadFormaPagamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  frmCadFormaPagamento := nil;
end;

procedure TfrmCadFormaPagamento.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if key = VK_F3 then //F3
    LimpaCampos
  else if key = VK_F2 then //F2
    Salvar
  else if key = VK_F4 then //F4
    Excluir
  else if key = VK_ESCAPE then //ESC
  if (Application.MessageBox('Deseja Fechar?','Aten��o', MB_YESNO) = IDYES) then
    Close;
end;

//passa pelos campos pressionando enter
procedure TfrmCadFormaPagamento.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmCadFormaPagamento.LimpaCampos;
begin
  edtCTA_FORMA_PGTOCODIGO.Clear;
  edtCTA_FORMA_PGTODESCRICAO.Clear;
  edtCTA_FORMA_PGTOFL_ATIVO.Checked := false;
  edtCTA_FORMA_PGTOCLASSIFICACAO.ItemIndex := -1;
  edtCTA_FORMA_PGTOCODIGO.SetFocus;
end;

procedure TfrmCadFormaPagamento.Salvar;
var
  persistencia: TCtaFormaPagamento;
begin
  validaCampos;

  persistencia := TCtaFormaPagamento.Create;

  try
    persistencia.cd_forma_pgto := StrToInt(edtCTA_FORMA_PGTOCODIGO.Text);
    persistencia.nm_forma_pgto := edtCTA_FORMA_PGTODESCRICAO.Text;
    persistencia.fl_ativo := edtCTA_FORMA_PGTOFL_ATIVO.Checked;
    persistencia.tp_classificacao := edtCTA_FORMA_PGTOCLASSIFICACAO.ItemIndex;

    if not persistencia.Pesquisar(StrToInt(edtCTA_FORMA_PGTOCODIGO.Text)) then
    begin
      persistencia.Inserir;
      LimpaCampos;
    end
    else
    begin
      persistencia.Atualizar;
      LimpaCampos;
    end;
  finally
    persistencia.Free;
  end;
end;

procedure TfrmCadFormaPagamento.validaCampos;
begin
  //verifica se o c�digo est� vazio
  if (edtCTA_FORMA_PGTOCODIGO.Text = EmptyStr) or (edtCTA_FORMA_PGTODESCRICAO.Text = EmptyStr)
    or (edtCTA_FORMA_PGTOCLASSIFICACAO.ItemIndex = -1) then
    raise Exception.Create('C�digo, Descri��o e Classifica��o n�o podem ser vazios');
end;

end.
