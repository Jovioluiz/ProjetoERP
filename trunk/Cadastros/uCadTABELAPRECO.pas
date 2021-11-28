unit uCadTABELAPRECO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, uCadTabelaPrecoProduto, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.UITypes, Datasnap.DBClient, uUtil,
  uDataModule, dTabelaPreco, uclTabelaPrecoRegras;

type
  TfrmcadTabelaPreco = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtFl_ativo: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    edtCodTabela: TEdit;
    edtNomeTabela: TEdit;
    edtDtInicial: TMaskEdit;
    edtDtFinal: TMaskEdit;
    DBGridProduto: TDBGrid;
    btnAdicionarProduto: TButton;
    btnEditar: TButton;
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure edtCodTabelaExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
    FAdicionar: Boolean;
    FTabelaPrecoRegras: TTabelaPrecoRegras;
    procedure limpaCampos;
    procedure Salvar;
    procedure Excluir;
    procedure SetTabelaPrecoRegras(const Value: TTabelaPrecoRegras);
  public
    { Public declarations }

    property TabelaPrecoRegras: TTabelaPrecoRegras read FTabelaPrecoRegras write SetTabelaPrecoRegras;

  end;

var
  frmcadTabelaPreco: TfrmcadTabelaPreco;


implementation

{$R *.dfm}

uses uLogin, uclTabelaPreco, uclTabelaPrecoProduto;

procedure TfrmcadTabelaPreco.btnAdicionarProdutoClick(Sender: TObject);
var
  validaAcesso: TValidaDados;

begin
  FAdicionar := True;
  validaAcesso := TValidaDados.Create;
  frmCadTabelaPrecoProduto := TfrmCadTabelaPrecoProduto.Create(Self);

  try

    if validaAcesso.ValidaAcessoAcao(idUsuario, 6) then
    begin
      frmCadTabelaPrecoProduto.edtCodTabela.Text := edtCodTabela.Text;
      frmCadTabelaPrecoProduto.ShowModal;
    end;

  finally
    validaAcesso.Free;
    frmCadTabelaPrecoProduto.Free;
  end;
end;

procedure TfrmcadTabelaPreco.btnEditarClick(Sender: TObject);
var
  cadTabelaPrecoProduto: TfrmCadTabelaPrecoProduto;
begin
  cadTabelaPrecoProduto := TfrmCadTabelaPrecoProduto.Create(Self);
  cadTabelaPrecoProduto.edtCodTabela.Text := edtCodTabela.Text;
  cadTabelaPrecoProduto.edtCodProduto.Text := FTabelaPrecoRegras.Dados.cdsProdutos.FieldByName('cd_produto').AsString;
  cadTabelaPrecoProduto.edtUNMedida.Text := FTabelaPrecoRegras.Dados.cdsProdutos.FieldByName('un_medida').AsString;
  cadTabelaPrecoProduto.edtValor.Text := CurrToStr(FTabelaPrecoRegras.Dados.cdsProdutos.FieldByName('valor').AsCurrency);
  cadTabelaPrecoProduto.ShowModal;
end;

procedure TfrmcadTabelaPreco.DBGridProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  produto: TTabelaPrecoProduto;
begin
  if KEY = VK_DELETE then
  begin
    if (Application.MessageBox('Deseja Excluir o produto da Tabela?', 'Atenção', MB_YESNO) = IDYES) then
    begin
      produto := TTabelaPrecoProduto.Create;

      try
        produto.cd_tabela := StrToInt(edtCodTabela.Text);
        produto.id_item := TabelaPrecoRegras.GetIdItem(TabelaPrecoRegras.Dados.cdsProdutos.FieldByName('cd_produto').AsString);
        produto.Excluir;
      finally
        produto.Free;
      end;
    end;
    FTabelaPrecoRegras.Dados.cdsProdutos.Delete;
  end;
end;

procedure TfrmcadTabelaPreco.edtCodTabelaExit(Sender: TObject);
var
  tabela: TTabelaPreco;
begin
  if edtCodTabela.Text = EmptyStr then
  begin
    btnAdicionarProduto.Enabled := False;
    Exit;
  end;

  tabela := TTabelaPreco.Create;

  try
    tabela.Buscar(StrToInt(edtCodTabela.Text));

    edtNomeTabela.Text := tabela.nm_tabela;
    edtFl_ativo.Checked := tabela.fl_ativo;
    edtDtInicial.Text := DateToStr(tabela.dt_inicio);
    edtDtFinal.Text := DateToStr(tabela.dt_fim);

    FTabelaPrecoRegras.CarregaProdutosTabela(StrToInt(edtCodTabela.Text));
  finally
    tabela.Free;
  end;
  btnAdicionarProduto.Enabled := True;
end;

procedure TfrmcadTabelaPreco.Excluir;
var
  tabelaPreco: TTabelaPreco;
begin
  if (Application.MessageBox('Deseja Excluir a Tabela de Preço?', 'Atenção', MB_YESNO) <> IDYES) then
    Exit;

  tabelaPreco := TTabelaPreco.Create;

  try
    tabelaPreco.cd_tabela := StrToInt(edtCodTabela.Text);
    tabelaPreco.Excluir;
    limpaCampos;
  finally
    tabelaPreco.Free;
  end;
end;

procedure TfrmcadTabelaPreco.FormActivate(Sender: TObject);
begin
  inherited;
  if edtCodTabela.Text <> '' then
  begin
    FTabelaPrecoRegras.CarregaProdutosTabela(StrToInt(edtCodTabela.Text));
  end;
end;

procedure TfrmcadTabelaPreco.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmcadTabelaPreco := nil;
  FTabelaPrecoRegras.Free;
end;

procedure TfrmcadTabelaPreco.FormCreate(Sender: TObject);
begin
  FTabelaPrecoRegras := TTabelaPrecoRegras.Create;
  DBGridProduto.DataSource := FTabelaPrecoRegras.Dados.dsProdutos;
end;

procedure TfrmcadTabelaPreco.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_F3 then //F3
    limpaCampos
  else if key = VK_F2 then  //F2
    Salvar
  else if key = VK_F4 then    //F4
    Excluir
  else if key = VK_ESCAPE then //ESC
  if (Application.MessageBox('Deseja Fechar?','Atenção', MB_YESNO) = IDYES) then
    Close;
end;

procedure TfrmcadTabelaPreco.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmcadTabelaPreco.limpaCampos;
begin
  edtFl_ativo.Checked := false;
  edtCodTabela.Clear;
  edtNomeTabela.Clear;
  edtDtInicial.Clear;
  edtDtFinal.Clear;
  FTabelaPrecoRegras.Dados.cdsProdutos.EmptyDataSet;
  edtCodTabela.SetFocus;
end;

procedure TfrmcadTabelaPreco.Salvar;
var
  tabelaPreco: TTabelaPreco;
begin
  tabelaPreco := TTabelaPreco.Create;

  tabelaPreco.cd_tabela := StrToInt(edtCodTabela.Text);
  tabelaPreco.nm_tabela := edtNomeTabela.Text;
  tabelaPreco.fl_ativo := edtFl_ativo.Checked;
  tabelaPreco.dt_inicio := StrToDate(edtDtInicial.Text);
  tabelaPreco.dt_fim := StrToDate(edtDtFinal.Text);

  try
    if not tabelaPreco.Pesquisar(StrToInt(edtCodTabela.Text)) then
      tabelaPreco.Inserir
    else
      tabelaPreco.Atualizar;

    limpaCampos;
  finally
    tabelaPreco.Free;
  end
end;

procedure TfrmcadTabelaPreco.SetTabelaPrecoRegras(const Value: TTabelaPrecoRegras);
begin
  FTabelaPrecoRegras := Value;
end;

end.
