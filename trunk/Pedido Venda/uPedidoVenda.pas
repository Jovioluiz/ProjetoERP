unit uPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.UITypes, Datasnap.DBClient, Vcl.Mask,
  Vcl.ComCtrls, System.Generics.Collections, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, uclPedidoVenda, uGerador,
  Vcl.NumberBox;

type
  TAliqItem = record
    AliqIcms,
    AliqIpi,
    AliqPisCofins: Currency
  end;

type
  TfrmPedidoVenda = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtNrPedido: TEdit;
    Label2: TLabel;
    edtCdCliente: TEdit;
    edtNomeCliente: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtCidadeCliente: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtCdFormaPgto: TEdit;
    edtCdCondPgto: TEdit;
    edtNomeFormaPgto: TEdit;
    edtNomeCondPgto: TEdit;
    Label7: TLabel;
    edtCdProduto: TEdit;
    edtDescProduto: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtUnMedida: TComboBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtCdtabelaPreco: TEdit;
    edtDescTabelaPreco: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    btnAdicionar: TButton;
    dbGridProdutos: TDBGrid;
    Label15: TLabel;
    edtVlDescontoItem: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    btnConfirmarPedido: TButton;
    btnCancelar: TButton;
    edtFl_orcamento: TCheckBox;
    Label19: TLabel;
    document: TXMLDocument;
    edtDataEmissao: TDateTimePicker;
    edtVlTotalPedido: TNumberBox;
    edtVlAcrescimoTotalPedido: TNumberBox;
    edtVlDescTotalPedido: TNumberBox;
    edtQtdade: TNumberBox;
    edtVlTotal: TNumberBox;
    edtVlUnitario: TNumberBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtCdClienteChange(Sender: TObject);
    procedure edtCdClienteExit(Sender: TObject);
    procedure edtCdFormaPgtoChange(Sender: TObject);
    procedure edtCdFormaPgtoExit(Sender: TObject);
    procedure edtCdCondPgtoChange(Sender: TObject);
    procedure edtCdCondPgtoExit(Sender: TObject);
    procedure edtCdtabelaPrecoChange(Sender: TObject);
    procedure edtCdtabelaPrecoExit(Sender: TObject);
    procedure edtQtdadeChange(Sender: TObject);
    procedure edtVlDescontoItemExit(Sender: TObject);
    procedure dbGridProdutosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure edtCdProdutoExit(Sender: TObject);
    procedure edtVlDescTotalPedidoExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarPedidoClick(Sender: TObject);
    procedure edtVlAcrescimoTotalPedidoExit(Sender: TObject);
    procedure dbGridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtQtdadeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbGridProdutosDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCdProdutoEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dbGridProdutosTitleClick(Column: TColumn);
    procedure btnAdicionarClick(Sender: TObject);
    procedure edtVlTotalPedidoExit(Sender: TObject);
    procedure edtNrPedidoChange(Sender: TObject);
  private
    FEdicaoItem: Boolean;
    FNumeroPedido: Integer;
    FRegras: TPedidoVenda;
    FGerador: TGerador;
    FEdicaoPedido: Boolean;
    FSeqItem: Integer;
    { Private declarations }
    function GetAliquotasItem(IDItem: Int64): TAliqItem;
    procedure AtualizaCabecalho;
    procedure SetRegras(const Value: TPedidoVenda);
    procedure LimpaCampos;
    procedure LimpaDados;
    procedure AtualizaEstoqueProduto;
    function ProdutoJaLancado(CodProduto: Integer): Boolean;
    function RetornaSequencia: Integer;
    procedure AlteraSequenciaItem;
    procedure SalvaCabecalho;

    procedure SalvaItens(EhEdicao: Boolean);
    procedure SetDadosNota;
    procedure CancelaPedidoVenda;
    procedure InsereWmsMvto;
    function GetNumeroParcelas(CdCondPgto: Integer): Integer;
    procedure CarregaItensEdicao;
    procedure PreencheCabecalhoPedido;
    procedure LancaItem;

    procedure GravaPedidoVenda;
    procedure SetEdicaoPedido(const Value: Boolean);
  public
    { Public declarations }

    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property Regras: TPedidoVenda read FRegras write SetRegras;
    property EdicaoPedido: Boolean read FEdicaoPedido write SetEdicaoPedido;
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

uses
  uDataModule, uConfiguracoes, uUtil, System.Math, uMovimentacaoEstoque,
  uclPedidoVendaItem;

{$R *.dfm}


procedure TfrmPedidoVenda.AlteraSequenciaItem;
//ajusta a sequencia do item no pedido de venda
var
  i: Integer;
begin
  FRegras.Dados.cdsPedidoVendaItem.First;
  
  for i := 1 to FRegras.Dados.cdsPedidoVendaItem.RecordCount do
  begin
    if FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger <> i then
    begin
      FRegras.Dados.cdsPedidoVendaItem.Edit;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger := i;
    end;
    FRegras.Dados.cdsPedidoVendaItem.Next;
  end;
end;

procedure TfrmPedidoVenda.AtualizaEstoqueProduto;
var
  estoque: TMovimentacaoEstoque;
begin
  estoque := TMovimentacaoEstoque.Create;

  try
    FRegras.Dados.cdsPedidoVendaItem.Loop(
    procedure
    begin
      estoque.AtualizaEstoque(FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt,
                              FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsInteger,
                              'S');
    end
    );

  finally
    estoque.Free;
  end;
end;

procedure TfrmPedidoVenda.btnAdicionarClick(Sender: TObject);
begin
  LancaItem;
end;

procedure TfrmPedidoVenda.btnCancelarClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja realmente Cancelar o pedido?','Aten��o', MB_YESNO) = IDYES) then
  begin
    CancelaPedidoVenda;
    LimpaDados;
  end;
end;

//grava os dados na pedido_venda e pedido_venda_item
procedure TfrmPedidoVenda.btnConfirmarPedidoClick(Sender: TObject);
begin
  GravaPedidoVenda;
  LimpaDados;
end;

procedure TfrmPedidoVenda.CancelaPedidoVenda;
const
  SQL = 'update pedido_venda set fl_cancelado = ''S'' where nr_pedido = :nr_pedido';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  try
    try
      qry.SQL.Add(SQL);
      qry.ParamByName('nr_pedido').AsInteger := NumeroPedido;
      qry.ExecSQL;
      qry.Connection.Commit;

    except on E:Exception do
      begin
        qry.Connection.Rollback;
        ShowMessage('Erro ao cancelar o pedido ' + NumeroPedido.ToString + E.Message);
        Exit;
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.CarregaItensEdicao;
begin
  FEdicaoItem := True;
  edtCdProduto.Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString;
  edtDescProduto.Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('descricao').AsString;
  edtQtdade.ValueFloat := FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsFloat;
  edtCdtabelaPreco.Text := IntToStr(FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_tabela_preco').AsInteger);
  edtUnMedida.Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString;
  edtVlUnitario.ValueCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsCurrency;
  edtVlDescontoItem.Text := CurrToStr(FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency);
  edtVlTotal.ValueCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency;
  edtCdProduto.SetFocus;
end;

procedure TfrmPedidoVenda.dbGridProdutosDblClick(Sender: TObject);
begin
  CarregaItensEdicao;
end;

//Faz a linha zebrada no grid dos itens
procedure TfrmPedidoVenda.dbGridProdutosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with dbGridProdutos do
  begin
    if Odd(DataSource.DataSet.RecNo) then
      Canvas.Brush.Color := clSilver
    else
      Canvas.Brush.Color := clWindow;

    Canvas.FillRect(Rect);
    DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfrmPedidoVenda.dbGridProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  SQL_DELETE = 'delete from pedido_venda_item where id_item = :id_item';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  try
    if Key = VK_DELETE then
    begin
      if MessageDlg('Deseja excluir o item do pedido?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
      begin
        try
          qry.SQL.Add(SQL_DELETE);
          qry.ParamByName('id_item').AsLargeInt := FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt;
          qry.ExecSQL;
          qry.Connection.Commit;

          FRegras.Dados.cdsPedidoVendaItem.Delete;
          edtCdProduto.SetFocus;
          FSeqItem := FSeqItem - 1;

        except
        on E : exception do
          begin
            qry.Connection.Rollback;
            ShowMessage('Erro ao excluir o item do pedido ' + FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString + E.Message);
            Exit;
          end;
        end;
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.dbGridProdutosTitleClick(Column: TColumn);
var
  sIndexName: string;
  oOrdenacao: TIndexOptions;
  i: smallint;
begin
  // retira a formata��o em negrito de todas as colunas
  for i := 0 to dbGridProdutos.Columns.Count - 1 do
    dbGridProdutos.Columns[i].Title.Font.Style := [];

  // configura a ordena��o ascendente ou descendente
  if FRegras.Dados.cdsPedidoVendaItem.IndexName = Column.FieldName + '_ASC' then
  begin
    sIndexName := Column.FieldName + '_DESC';
    oOrdenacao := [ixDescending];
  end
  else
  begin
    sIndexName := Column.FieldName + '_ASC';
    oOrdenacao := [];
  end;

  // adiciona a ordena��o no DataSet, caso n�o exista
  if FRegras.Dados.cdsPedidoVendaItem.IndexDefs.IndexOf(sIndexName) < 0 then
    FRegras.Dados.cdsPedidoVendaItem.AddIndex(sIndexName, Column.FieldName, oOrdenacao);

  FRegras.Dados.cdsPedidoVendaItem.IndexDefs.Update;

  // formata o t�tulo da coluna em negrito
  Column.Title.Font.Style := [fsBold];

  // atribui a ordena��o selecionada
  FRegras.Dados.cdsPedidoVendaItem.IndexName := sIndexName;

  FRegras.Dados.cdsPedidoVendaItem.First;
end;

//busca o cliente
procedure TfrmPedidoVenda.edtCdClienteChange(Sender: TObject);
const
  sql_cliente = 'select '+
                '   c.cd_cliente, '+
                '   c.nome, '+
                '   e.cidade, '+
                '   e.uf '+
                'from '+
                '   cliente c '+
                'join endereco_cliente e on '+
                '   c.cd_cliente = e.cd_cliente '+
                'where '+
                '   (c.cd_cliente = :cd_cliente) and '+
                '   (c.fl_ativo = true)';
var
  tempC, tempU: String;
  qry: TFDQuery;
begin
  if edtCdCliente.Text = EmptyStr then
  begin
    edtNomeCliente.Text := '';
    edtCidadeCliente.Text := '';
    Exit;
  end;

  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add(sql_cliente);
    qry.ParamByName('cd_cliente').AsInteger := StrToInt(edtCdCliente.Text);
    qry.Open();

    edtNomeCliente.Text := qry.FieldByName('nome').AsString;
    tempC := qry.FieldByName('cidade').Text;
    tempU := qry.FieldByName('uf').Text;
    edtCidadeCliente.Text := Concat(tempC + '/' + tempU);
  finally
    qry.Free;
  end;
end;

//valida se n�o foi encontrado nenhum cliente
procedure TfrmPedidoVenda.edtCdClienteExit(Sender: TObject);
var
  resposta : Boolean;
begin
  if not edtCdCliente.isEmpty then
  begin
    resposta := FRegras.ValidaCliente(StrToInt(edtCdCliente.Text));

    if not resposta then
    begin
      if (Application.MessageBox('Cliente n�o encontrado ou Inativo','Aten��o', MB_OK) = idOK) then
        edtCdCliente.SetFocus;
    end;
  end;
end;

//busca a condi��o de pgto
procedure TfrmPedidoVenda.edtCdCondPgtoChange(Sender: TObject);
begin
  if edtCdCondPgto.Text = EmptyStr then
  begin
    edtNomeCondPgto.Text := '';
    Exit;
  end;

  edtNomeCondPgto.Text := FRegras.BuscaCondicaoPgto(StrToInt(edtCdCondPgto.Text), StrToInt(edtCdFormaPgto.Text));
end;

//valida se n�o foi encontrado nenhuma condi��o de pagamento
procedure TfrmPedidoVenda.edtCdCondPgtoExit(Sender: TObject);
var
  resposta : Boolean;
begin
  if not edtCdCondPgto.isEmpty then
  begin
    resposta := FRegras.ValidaCondPgto(StrToInt(edtCdCondPgto.Text), StrToInt(edtCdFormaPgto.Text));

    if resposta then
    begin
      if (Application.MessageBox('Condi��o de pagamento n�o encontrada', 'Aten��o', MB_OK) = idOK) then
        edtCdCondPgto.SetFocus;
    end;
  end;
end;

//busca a forma pgto
procedure TfrmPedidoVenda.edtCdFormaPgtoChange(Sender: TObject);
begin

  if edtCdFormaPgto.Text = EmptyStr then
  begin
    edtNomeFormaPgto.Text := '';
    Exit;
  end;

  edtNomeFormaPgto.Text := FRegras.BuscaFormaPgto(StrToInt(edtCdFormaPgto.Text));

end;

//valida se n�o foi encontrado nenhuma forma de pagamento
procedure TfrmPedidoVenda.edtCdFormaPgtoExit(Sender: TObject);
var
  resposta : Boolean;
begin
  if not edtCdFormaPgto.isEmpty then
  begin
    resposta := FRegras.ValidaFormaPgto(StrToInt(edtCdFormaPgto.Text));

    if resposta then
    begin
      if (Application.MessageBox('Forma de Pagamento n�o encontrada', 'Aten��o', MB_OK) = idOK) then
        edtCdFormaPgto.SetFocus;
    end;
  end;
end;

procedure TfrmPedidoVenda.edtCdProdutoEnter(Sender: TObject);
const
  SQL = 'select nr_pedido from pedido_venda where nr_pedido = :nr_pedido';
var
  qry:TFDQuery;
begin
  inherited;
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    if edtNrPedido.Text = '' then
    begin
      NumeroPedido := FGerador.GeraNumeroPedido;
      edtNrPedido.Text := NumeroPedido.ToString;
    end;

    qry.SQL.Add(SQL);
    qry.ParamByName('nr_pedido').AsInteger := NumeroPedido;
    qry.Open();

    PreencheCabecalhoPedido;

    if qry.FieldByName('nr_pedido').AsInteger <> NumeroPedido then
      SalvaCabecalho
    else
      AtualizaCabecalho;

  finally
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.AtualizaCabecalho;
const
  SQL_UPDATE_CABECALHO = 'update pedido_venda set cd_cliente = :cd_cliente,  '+
                         ' cd_forma_pag = :cd_forma_pag, cd_cond_pag = :cd_cond_pag, vl_desconto_pedido = :vl_desconto_pedido,   '+
                         ' vl_acrescimo = :vl_acrescimo, vl_total = :vl_total, fl_orcamento = :fl_orcamento, dt_emissao = :dt_emissao,'+
                         ' fl_cancelado = :fl_cancelado where nr_pedido = :nr_pedido';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  try
    try
      qry.SQL.Add(SQL_UPDATE_CABECALHO);
      qry.ParamByName('nr_pedido').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger;
      qry.ParamByName('cd_cliente').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger;
      qry.ParamByName('cd_forma_pag').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger;
      qry.ParamByName('cd_cond_pag').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger;
      qry.ParamByName('vl_desconto_pedido').AsCurrency :=  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency;
      qry.ParamByName('vl_acrescimo').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency;
      qry.ParamByName('vl_total').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency;
      qry.ParamByName('fl_orcamento').AsBoolean := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean;
      qry.ParamByName('dt_emissao').AsDate := FRegras.Dados.cdsPedidoVenda.FieldByName('dt_emissao').AsDateTime;
      qry.ParamByName('fl_cancelado').AsString := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_cancelado').AsString;
      qry.ExecSQL;

      qry.Connection.Commit;

    except
      on E : exception do
        begin
          qry.Connection.Rollback;
          ShowMessage('Erro ao gravar os dados do pedido ' + edtNrPedido.Text + E.Message);
          Exit;
        end;
    end;

  finally
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.edtCdProdutoExit(Sender: TObject);
var
  resposta: Boolean;
  lista: TFDQuery;
  pvItem: TPedidoVendaItem;
begin
  resposta := False;
  lista := nil;
  pvItem := TPedidoVendaItem.Create;

  try
    if (Trim(edtCdProduto.Text) = '') and (FRegras.Dados.cdsPedidoVendaItem.RecordCount > 0) then
    begin
      edtVlDescTotalPedido.SetFocus;
      Exit;
    end;

    if edtCdProduto.Text <> '' then
      resposta := FRegras.ValidaProduto(edtCdProduto.Text);

    if not resposta then
    begin
      if (Application.MessageBox('Produto sem pre�o Cadastrado ou Inativo!', 'Verifique', MB_OK) = idOK) then
      begin
        edtCdtabelaPreco.Text := '';
        edtCdProduto.SetFocus;
        Exit;
      end;
    end;

    //preenche os dados da lista nos campos
    if FRegras.isCodBarrasProduto(edtCdProduto.Text) then
    begin
      pvItem.BuscaProdutoCodBarras(edtCdProduto.Text);

      lista := FRegras.BuscaProduto(edtCdProduto.Text);
      edtCdProduto.Text := lista.FieldByName('cd_produto').AsString;
      edtDescProduto.Text := lista.FieldByName('desc_produto').AsString;
      edtUnMedida.Text := lista.FieldByName('un_medida').AsString;
      edtCdtabelaPreco.Text := IntToStr(lista.FieldByName('cd_tabela').AsInteger);
      edtDescTabelaPreco.Text := lista.FieldByName('nm_tabela').AsString;
      edtVlUnitario.ValueCurrency := lista.FieldByName('valor').AsCurrency;
    end
    else
    begin
      lista := FRegras.BuscaProduto(edtCdProduto.Text);
      edtDescProduto.Text := lista.FieldByName('desc_produto').AsString;
      edtUnMedida.Text := lista.FieldByName('un_medida').AsString;
      edtCdtabelaPreco.Text := IntToStr(lista.FieldByName('cd_tabela').AsInteger);
      edtDescTabelaPreco.Text := lista.FieldByName('nm_tabela').AsString;
      edtVlUnitario.ValueCurrency := lista.FieldByName('valor').AsCurrency;
    end;

  finally
    lista.Free;
    pvItem.Free;
  end;
end;

//busca a tabela de pre�o
procedure TfrmPedidoVenda.edtCdtabelaPrecoChange(Sender: TObject);
var
  lista: TFDQuery;
begin

  if edtCdtabelaPreco.Text = EmptyStr then
  begin
    edtDescTabelaPreco.Text := '';
    edtVlUnitario.ValueCurrency := 0;
    Exit;
  end;

  try
    lista := FRegras.BuscaTabelaPreco(StrToInt(edtCdtabelaPreco.Text), edtCdProduto.Text);

    edtDescTabelaPreco.Text := lista.FieldByName('nm_tabela').AsString;
    edtVlUnitario.ValueCurrency := lista.FieldByName('valor').AsCurrency;
  finally
    lista.Free;
  end;
end;

procedure TfrmPedidoVenda.edtCdtabelaPrecoExit(Sender: TObject);
var
  resposta : Boolean;
begin
  if not edtCdtabelaPreco.isEmpty then
  begin
    resposta := FRegras.ValidaTabelaPreco(StrToInt(edtCdtabelaPreco.Text), edtCdProduto.Text);

    if resposta then
    begin
      if (Application.MessageBox('Tabela de Pre�o n�o encontrada', 'Aten��o', MB_OK) = idOK) then
        edtCdtabelaPreco.SetFocus;
    end
    else
    begin
      //recalcula o valor total do item ao alterar a tabela de pre�o

      edtVlTotal.ValueCurrency := FRegras.CalculaValorTotalItem(edtVlUnitario.ValueCurrency, edtQtdade.ValueFloat);
      edtVlDescontoItem.Enabled := True;
    end;
  end;
end;

procedure TfrmPedidoVenda.edtNrPedidoChange(Sender: TObject);
begin
  if edtNrPedido.Text <> '' then
  begin
    if FRegras.CarregaPedidoVenda(strToInt(edtNrPedido.Text)) then
    begin
      edtFl_orcamento.Checked := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean;
      edtCdCliente.Text := IntToStr(FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger);
      edtCdFormaPgto.Text := IntToStr(FRegras.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger);
      edtCdCondPgto.Text := IntToStr(FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger);
      edtVlDescTotalPedido.ValueCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency;
      edtVlAcrescimoTotalPedido.ValueCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency;
      edtVlTotalPedido.ValueCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency;
      NumeroPedido := FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger;
    end;
  end;
end;

//calcula o valor total do item ao alterar a quantidade
procedure TfrmPedidoVenda.edtQtdadeChange(Sender: TObject);
begin
  if edtQtdade.ValueFloat = 0 then
  begin
    edtVlTotal.ValueCurrency := 0;
    Exit;
  end
  else
  begin
    if edtVlUnitario.ValueCurrency <> 0 then
      edtVlTotal.ValueCurrency := FRegras.CalculaValorTotalItem(edtVlUnitario.ValueCurrency, edtQtdade.ValueFloat);
    edtVlDescontoItem.Enabled := True;
  end;
end;

procedure TfrmPedidoVenda.edtQtdadeExit(Sender: TObject);
begin
  if (edtQtdade.ValueFloat = 0) and (FRegras.Dados.cdsPedidoVendaItem.RecordCount = 0) then
  begin
    ShowMessage('Informe uma quantidade maior que 0');
    edtCdProduto.SetFocus;
  end;

  if edtQtdade.ValueFloat > 0 then
    if not FRegras.ValidaQtdadeItem(edtCdProduto.Text, edtQtdade.ValueFloat) then
    begin
      edtCdProduto.SetFocus;
      Exit;
    end;
end;

procedure TfrmPedidoVenda.edtVlAcrescimoTotalPedidoExit(Sender: TObject);
//recalcula o valor total se informado um valor de acrescimo no total do pedido
begin
  edtVlTotalPedido.ValueCurrency := edtVlTotalPedido.ValueCurrency + edtVlAcrescimoTotalPedido.ValueCurrency;
end;

//altera o valor total ao sair do campo de desconto
procedure TfrmPedidoVenda.edtVlDescontoItemExit(Sender: TObject);
var
  vlDesconto, vlUnitario,
  vlTotalComDesc: Currency;
begin
  if edtVlDescontoItem.Text = EmptyStr then
    edtVlDescontoItem.Text := '0,00'
  else
  begin
    vlDesconto := StrToCurr(edtVlDescontoItem.Text);
    vlUnitario := edtVlUnitario.ValueCurrency;
    vlTotalComDesc := (vlUnitario * edtQtdade.ValueFloat) - vlDesconto;
    edtVlTotal.ValueCurrency := vlTotalComDesc;
  end;
end;

//recalcula o valor total se informado um valor de desconto no total do pedido
procedure TfrmPedidoVenda.edtVlDescTotalPedidoExit(Sender: TObject);
var
  valorDesconto, vlTotalPedido, valorTotalItens: Currency;
begin
  if edtVlDescTotalPedido.ValueCurrency = 0 then
  begin
    valorTotalItens := 0;

    //soma os valores totais dos itens
    FRegras.Dados.cdsPedidoVendaItem.Loop(
      procedure
      begin
        valorTotalItens := (valorTotalItens
                            + FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency);
      end
    );

    edtVlTotalPedido.ValueCurrency := valorTotalItens;
  end
  else
  begin
    vlTotalPedido := 0;

    valorDesconto := edtVlDescTotalPedido.ValueCurrency;

    FRegras.Dados.cdsPedidoVendaItem.Loop(
      procedure
      begin
        vlTotalPedido := (vlTotalPedido + FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency);
      end
    );

    edtVlTotalPedido.ValueCurrency := vlTotalPedido - valorDesconto;
  end;
end;

procedure TfrmPedidoVenda.edtVlTotalPedidoExit(Sender: TObject);
begin
  btnConfirmarPedido.SetFocus;
end;

procedure TfrmPedidoVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frmPedidoVenda := nil;
  FRegras.Free;
  FGerador.Free;
end;

procedure TfrmPedidoVenda.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if FEdicaoPedido then
  begin
    CanClose := False;
    if (Application.MessageBox('Deseja Cancelar a edi��o do Pedido?', 'Aten��o', MB_YESNO) = IDYES) then
    begin
      CanClose := True;
      Exit;
    end;
  end;

  if (edtNrPedido.Text <> '') or (FRegras.Dados.cdsPedidoVendaItem.RecordCount > 0) then
  begin
    CanClose := False;
    if (Application.MessageBox('Deseja Cancelar o Pedido?','Aten��o', MB_YESNO) = IDYES) then
    begin
      CancelaPedidoVenda;
      CanClose := True;
    end;
  end;
end;

procedure TfrmPedidoVenda.FormCreate(Sender: TObject);
begin
//seta a data atual na data de emiss�o
  edtDataEmissao.Date := Date();
  edtDataEmissao.Enabled := False;
  FSeqItem := 1;
  FRegras := TPedidoVenda.Create;
  dbGridProdutos.DataSource := FRegras.Dados.dsPedidoVendaItem;
  FGerador := TGerador.Create;
end;

procedure TfrmPedidoVenda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then //ESC
  begin
    if (edtNrPedido.Text = '') and (FRegras.Dados.cdsPedidoVendaItem.RecordCount = 0) then
    begin
      if (Application.MessageBox('Deseja Fechar?','Aten��o', MB_YESNO) = IDYES) then
        Close;
    end;
  end;
end;

procedure TfrmPedidoVenda.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;


function TfrmPedidoVenda.GetAliquotasItem(IDItem: Int64): TAliqItem;
const
  SQL_ALIQ = 'select '+
        '    pt.cd_tributacao_icms,'+
        '    gti.aliquota_icms,'+
        '    gtipi.aliquota_ipi,'+
        '    gtpc.aliquota_pis_cofins '+
        'from '+
        '    produto_tributacao pt '+
        'join grupo_tributacao_icms gti on '+
        '    pt.cd_tributacao_icms = gti.cd_tributacao '+
        'join grupo_tributacao_ipi gtipi on '+
        '    pt.cd_tributacao_ipi = gtipi.cd_tributacao '+
        'join grupo_tributacao_pis_cofins gtpc on '+
        '    pt.cd_tributacao_pis_cofins = gtpc.cd_tributacao '+
        'where '+
        '    pt.id_item = :id_item';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(Self);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL_ALIQ, [IDItem]);

    if not query.IsEmpty then
    begin
      Result.AliqIcms := query.FieldByName('aliquota_icms').AsCurrency;
      Result.AliqIpi := query.FieldByName('aliquota_ipi').AsCurrency;
      Result.AliqPisCofins := query.FieldByName('aliquota_pis_cofins').AsCurrency;
    end
    else
    begin
      Result.AliqIcms := 0;
      Result.AliqIpi := 0;
      Result.AliqPisCofins := 0;
    end;

  finally
    query.Free;
  end;
end;

function TfrmPedidoVenda.GetNumeroParcelas(CdCondPgto: Integer): Integer;
const
  SQL = 'select ' +
        ' nr_parcelas ' +
        'from              ' +
        '    cta_cond_pagamento ' +
        'where cd_cond_pag = :cd_cond_pag';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('cd_cond_pag').AsInteger := CdCondPgto;
    qry.Open();
    Result := qry.FieldByName('nr_parcelas').AsInteger;
  finally
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.GravaPedidoVenda;
const
  SQL_UPDATE_CABECALHO = 'update pedido_venda set cd_cliente = :cd_cliente,  '+
                         ' cd_forma_pag = :cd_forma_pag, cd_cond_pag = :cd_cond_pag, vl_desconto_pedido = :vl_desconto_pedido,   '+
                         ' vl_acrescimo = :vl_acrescimo, vl_total = :vl_total, fl_orcamento = :fl_orcamento, dt_emissao = :dt_emissao,'+
                         ' fl_cancelado = :fl_cancelado where nr_pedido = :nr_pedido';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  try
    try
      qry.SQL.Add(SQL_UPDATE_CABECALHO);
      qry.ParamByName('nr_pedido').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger;
      qry.ParamByName('cd_cliente').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger;
      qry.ParamByName('cd_forma_pag').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger;
      qry.ParamByName('cd_cond_pag').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger;
      qry.ParamByName('vl_desconto_pedido').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency;
      qry.ParamByName('vl_acrescimo').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency;
      qry.ParamByName('vl_total').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency;
      qry.ParamByName('fl_orcamento').AsBoolean := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean;
      qry.ParamByName('dt_emissao').AsDate := FRegras.Dados.cdsPedidoVenda.FieldByName('dt_emissao').AsDateTime;
      qry.ParamByName('fl_cancelado').AsString := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_cancelado').AsString;
      qry.ExecSQL;

      AlteraSequenciaItem;

      //insert na pedido_venda_item

      FRegras.Dados.cdsPedidoVendaItem.Loop(
      procedure
      begin
        SalvaItens(True);
      end);

      //fazer o insert na wms_mvto_estoque
      InsereWmsMvto;
      AtualizaEstoqueProduto;

      //setDadosNota;

      qry.Connection.Commit;

      ShowMessage('Pedido ' + FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsString + ' Gravado Com Sucesso');
    except
      on E : exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados do pedido ' + edtNrPedido.Text + E.Message);
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.InsereWmsMvto;
var
  estoque: TMovimentacaoEstoque;
begin
  estoque := TMovimentacaoEstoque.Create;
  try
    try
      FRegras.Dados.cdsPedidoVendaItem.Loop(
        procedure
        begin
          estoque.InsereWmsMvto(FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt,
                                FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString,
                                FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsFloat,
                                'S');
        end
      );

    except
      on e:Exception do
      begin
        ShowMessage('Erro ao gravar os dados do movimento do produto ' + FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString + E.Message);
        Exit;
      end;
    end;
  finally
    estoque.Free;
  end;
end;

procedure TfrmPedidoVenda.SetDadosNota;
const
  SQL = 'select * from vcliente where cd_cliente = :cd_cliente';
var
  i, j, nrParcelas: Integer;
  venda, cabecalho,
  cliente, endCliente,
  itens, pagamento,
  impostoItem, parcelas: IXMLNode;
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  document.Active := True;
  i := 1;
  try
    qry.SQL.Add(SQL);
    qry.ParamByName('cd_cliente').AsInteger := StrToInt(edtCdCliente.Text);
    qry.Open(SQL);
    document.Version := '1.0';
    document.Encoding := 'UTF-8';

    venda := document.AddChild('venda');

    cabecalho := venda.AddChild('cabecalho');
    cabecalho.AddChild('nNota').Text := edtNrPedido.Text;
    cabecalho.AddChild('dtEmissao').Text := DateToStr(now);

    cliente := cabecalho.AddChild('cliente');
    cliente.AddChild('nome').Text := qry.FieldByName('nome').AsString;
    cliente.AddChild('CPF_CNPJ').Text := qry.FieldByName('cpf_cnpj').AsString;
    cliente.AddChild('RG_IE').Text := qry.FieldByName('rg_ie').AsString;

    endCliente := cliente.AddChild('enderCliente');
    endCliente.AddChild('rua').Text := qry.FieldByName('logradouro').AsString;
    endCliente.AddChild('bairro').Text := qry.FieldByName('bairro').AsString;
    endCliente.AddChild('cidade').Text := qry.FieldByName('cidade').AsString;
    endCliente.AddChild('cep').Text := qry.FieldByName('cep').AsString;
    endCliente.AddChild('email').Text := qry.FieldByName('email').AsString;
    endCliente.AddChild('fone').Text := qry.FieldByName('fone').AsString;

    FRegras.Dados.cdsPedidoVendaItem.DisableControls;
    FRegras.Dados.cdsPedidoVendaItem.First;
    while not FRegras.Dados.cdsPedidoVendaItem.Eof do
    begin
      itens := venda.AddChild('item');
      itens.Attributes['numero'] := i;
      itens.AddChild('cProd').Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString;
      itens.AddChild('descricao').Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('descricao').AsString;
      itens.AddChild('uUN').Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString;
      itens.AddChild('qtVenda').Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsString;
      itens.AddChild('vlUni').Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsString;
      if FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency > 0 then
      begin
        impostoItem := itens.AddChild('impostoItem');
        impostoItem.AddChild('vBaseIcms').Text := FormatCurr('#,##0.00', FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency);
        impostoItem.AddChild('icmsAliq').Text := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsString;
        impostoItem.AddChild('vIcms').Text := FormatCurr('#,##0.00', FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency);
      end;
      FRegras.Dados.cdsPedidoVendaItem.Next;
      Inc(i);
    end;

    nrParcelas := GetNumeroParcelas(StrToInt(edtCdCondPgto.Text));
    pagamento := venda.AddChild('pagamento');
    pagamento.AddChild('fPag').Text := edtNomeFormaPgto.Text;
    pagamento.AddChild('cPag').Text := edtNomeCondPgto.Text;
    pagamento.AddChild('vTotal').Text := FormatCurr('#,##0.00', edtVlTotalPedido.ValueCurrency);

    if nrParcelas > 0 then
    begin
      parcelas := pagamento.AddChild('parcelas');
      for j := 1 to nrParcelas do
      begin
        parcelas.AddChild('nParcela').Text := j.ToString;
        parcelas.AddChild('vlrParcela').Text := FormatCurr('#,##0.00', (edtVlTotalPedido.ValueCurrency / nrParcelas));
      end;
    end;

    document.SaveToFile('C:\Users\jovio\Documents\xml\notafiscal' + edtNrPedido.Text + '.xml');
  finally
    qry.Free;
    FRegras.Dados.cdsPedidoVendaItem.EnableControls;
  end;
end;

procedure TfrmPedidoVenda.SetEdicaoPedido(const Value: Boolean);
begin
  FEdicaoPedido := Value;
end;

procedure TfrmPedidoVenda.LancaItem;
//adiciona os produtos no grid
 var
  vl_total_itens: Currency;
  lancaProduto: TfrmConfiguracoes;
  aliq: TAliqItem;
begin
  lancaProduto := TfrmConfiguracoes.Create(Self);

  try
     aliq := GetAliquotasItem(FRegras.GetIdItem(edtCdProduto.Text));

    if ProdutoJaLancado(StrToInt(edtCdProduto.Text)) and (not FEdicaoItem) then
      raise Exception.Create('O produto j� est� lan�ado');

    if FEdicaoItem then
    begin
      FRegras.Dados.cdsPedidoVendaItem.Edit;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString := edtCdProduto.Text;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsFloat := edtQtdade.ValueFloat;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString := edtUnMedida.Text;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsCurrency := edtVlUnitario.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency := StrToCurr(edtVlDescontoItem.Text);
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency := edtVlTotal.ValueCurrency;
    end
    else
    begin
      RetornaSequencia;
      FRegras.Dados.cdsPedidoVendaItem.Append;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_geral').AsLargeInt := FGerador.GeraIdGeral;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_pedido_venda').AsLargeInt := FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger := FSeqItem;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString := edtCdProduto.Text;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('descricao').AsString := edtDescProduto.Text;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsFloat := edtQtdade.ValueFloat;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_tabela_preco').AsInteger := StrToInt(edtCdtabelaPreco.Text);
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString := edtUnMedida.Text;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsCurrency := edtVlUnitario.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency := StrToCurr(edtVlDescontoItem.Text);
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency := edtVlTotal.ValueCurrency;
    end;

    if aliq.AliqIcms = 0 then
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency := 0;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsFloat := 0;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency := 0;
    end
    else
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency := edtVlTotal.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsFloat := aliq.AliqIcms;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency := FRegras.CalculaImposto(edtVlTotal.ValueCurrency,
                                                                                                      aliq.AliqIcms);
    end;
    if aliq.AliqIpi = 0 then
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_vl_base').AsCurrency := 0;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_pc_aliq').AsFloat := 0;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_valor').AsCurrency := 0;
    end
    else
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_vl_base').AsCurrency := edtVlTotal.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_pc_aliq').AsFloat := aliq.AliqIpi;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_valor').AsCurrency := FRegras.CalculaImposto(edtVlTotal.ValueCurrency, aliq.AliqIpi);
    end;
    if aliq.AliqPisCofins = 0 then
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_vl_base').AsCurrency := 0;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_pc_aliq').AsFloat := 0;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_valor').AsCurrency := 0;
    end
    else
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_vl_base').AsCurrency := edtVlTotal.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_pc_aliq').AsFloat := aliq.AliqPisCofins;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_valor').AsCurrency := FRegras.CalculaImposto(edtVlTotal.ValueCurrency, aliq.AliqPisCofins);
    end;

    FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt := FRegras.GetIdItem(edtCdProduto.Text);
    FRegras.Dados.cdsPedidoVendaItem.Post;

    SalvaItens(FEdicaoItem);

    //soma os valores totais dos itens e preenche o valor total do pedido
    vl_total_itens := 0;

    FRegras.Dados.cdsPedidoVendaItem.Loop(
    procedure
    begin
      vl_total_itens := (vl_total_itens + FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency);
    end);

    edtVlTotalPedido.ValueCurrency := vl_total_itens;

    FSeqItem := FSeqItem + 1;

    edtQtdade.ValueFloat := 0;
    FEdicaoItem := False;
  finally
    LimpaCampos;
    lancaProduto.Free;
  end;
end;

procedure TfrmPedidoVenda.LimpaCampos;
begin
  edtCdProduto.Clear;
  edtDescProduto.Clear;
  edtQtdade.Clear;
  edtCdtabelaPreco.Clear;
  edtUnMedida.Clear;
  edtVlUnitario.Clear;
  edtVlDescontoItem.Clear;
  edtVlTotal.Clear;
  edtCdProduto.SetFocus;
  edtVlDescTotalPedido.ValueCurrency := 0;
  edtVlAcrescimoTotalPedido.ValueCurrency := 0;
end;

procedure TfrmPedidoVenda.LimpaDados;
begin
  edtNrPedido.Clear;
  edtCdCliente.Clear;
  edtNomeCliente.Clear;
  edtCidadeCliente.Clear;
  edtCdFormaPgto.Clear;
  edtNomeFormaPgto.Clear;
  edtCdCondPgto.Clear;
  edtNomeCondPgto.Clear;
  edtVlDescTotalPedido.Clear;
  edtVlAcrescimoTotalPedido.Clear;
  edtVlTotalPedido.Clear;
  FRegras.Dados.cdsPedidoVendaItem.EmptyDataSet;
end;

procedure TfrmPedidoVenda.PreencheCabecalhoPedido;
begin

  if FRegras.Dados.cdsPedidoVenda.State in [dsEdit, dsBrowse] then
    FRegras.Dados.cdsPedidoVenda.Edit
  else
    FRegras.Dados.cdsPedidoVenda.Append;

  FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt := ifthen(FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt > 0,
                                                                            FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt, FGerador.GeraIdGeral);
  FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger := NumeroPedido;
  FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger := StrToInt(edtCdCliente.Text);
  FRegras.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger := StrToInt(edtCdFormaPgto.Text);
  FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger := StrToInt(edtCdCondPgto.Text);
  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency := edtVlDescTotalPedido.ValueCurrency;
  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency := edtVlAcrescimoTotalPedido.ValueCurrency;
  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency := edtVlTotalPedido.ValueCurrency;
  FRegras.Dados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean := edtFl_orcamento.Checked;
  FRegras.Dados.cdsPedidoVenda.FieldByName('dt_emissao').AsDateTime := edtDataEmissao.Date;
  FRegras.Dados.cdsPedidoVenda.FieldByName('fl_cancelado').AsString := 'N';
  FRegras.Dados.cdsPedidoVenda.Post;
end;

function TfrmPedidoVenda.ProdutoJaLancado(CodProduto: Integer): Boolean;
begin
  Result := FRegras.Dados.cdsPedidoVendaItem.Locate('cd_produto', VarArrayOf([CodProduto]), []);
end;

function TfrmPedidoVenda.RetornaSequencia: Integer;
begin

  FRegras.Dados.cdsPedidoVendaItem.Loop(
    procedure
    begin
      if FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger = FSeqItem then
        FSeqItem := FSeqItem + 1;
    end
  );

  Result := FSeqItem;
end;

procedure TfrmPedidoVenda.SalvaCabecalho;
const
  sql_Insert_pedido =
  'insert ' +
  '    into ' +
  'pedido_venda (id_geral, nr_pedido, cd_cliente, cd_forma_pag, cd_cond_pag, vl_desconto_pedido, '+
  '              vl_acrescimo, vl_total, fl_orcamento, dt_emissao, fl_cancelado) ' +
  'values (:id_geral, :nr_pedido, :cd_cliente, :cd_forma_pag, :cd_cond_pag, :vl_desconto_pedido, '+
  '        :vl_acrescimo, :vl_total, :fl_orcamento, :dt_emissao, :fl_cancelado)';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  try

    try
      //insert na pedido_venda
      qry.SQL.Add(sql_Insert_pedido);
      qry.ParamByName('id_geral').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt;
      qry.ParamByName('nr_pedido').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger;
      qry.ParamByName('cd_cliente').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger;
      qry.ParamByName('cd_forma_pag').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger;
      qry.ParamByName('cd_cond_pag').AsInteger := FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger;
      qry.ParamByName('vl_desconto_pedido').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency;
      qry.ParamByName('vl_acrescimo').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency;
      qry.ParamByName('vl_total').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency;
      qry.ParamByName('fl_orcamento').AsBoolean := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean;
      qry.ParamByName('dt_emissao').AsDate := FRegras.Dados.cdsPedidoVenda.FieldByName('dt_emissao').AsDateTime;
      qry.ParamByName('fl_cancelado').AsString := FRegras.Dados.cdsPedidoVenda.FieldByName('fl_cancelado').AsString;
      qry.ExecSQL;
      qry.Connection.Commit;
    except
    on E : exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar o cabe�alho do pedido ' + FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsString + E.Message);
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.SalvaItens(EhEdicao: Boolean);
const
  SQL_INSERT = 'insert '+
               '    into '+
               'pedido_venda_item (id_geral, id_pedido_venda, id_item, vl_unitario, vl_total_item, qtd_venda, ' +
               'vl_desconto, cd_tabela_preco, icms_vl_base, icms_pc_aliq, icms_valor, ipi_vl_base, ipi_pc_aliq, ' +
               'ipi_valor, pis_cofins_vl_base, pis_cofins_pc_aliq, pis_cofins_valor, un_medida, seq_item) ' +
               'values (:id_geral, :id_pedido_venda, :id_item, :vl_unitario, :vl_total_item, ' +
               ':qtd_venda, :vl_desconto, :cd_tabela_preco, :icms_vl_base, :icms_pc_aliq, :icms_valor, ' +
               ':ipi_vl_base, :ipi_pc_aliq, :ipi_valor, :pis_cofins_vl_base, :pis_cofins_pc_aliq, ' +
               ':pis_cofins_valor, :un_medida, :seq_item)';

  SQL_UPDATE = 'update    ' +
               'pedido_venda_item set id_item = :id_item, vl_unitario = :vl_unitario,   ' +
               'vl_total_item = :vl_total_item, qtd_venda = :qtd_venda, vl_desconto = :vl_desconto, cd_tabela_preco = :cd_tabela_preco, icms_vl_base = :icms_vl_base,  ' +
               'icms_pc_aliq = :icms_pc_aliq, icms_valor = :icms_valor, ipi_vl_base = :ipi_vl_base, ipi_pc_aliq = :ipi_pc_aliq, ipi_valor = :ipi_valor,              ' +
               'pis_cofins_vl_base = :pis_cofins_vl_base, pis_cofins_pc_aliq = :pis_cofins_pc_aliq, pis_cofins_valor = :pis_cofins_valor, un_medida = :un_medida, ' +
               'seq_item = :seq_item '+
               'where id_geral = :id_geral';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  try
    try
      if not EhEdicao then
      begin
        qry.SQL.Add(SQL_INSERT);
        qry.ParamByName('id_geral').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_geral').AsLargeInt;
        qry.ParamByName('id_pedido_venda').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_pedido_venda').AsLargeInt;
        qry.ParamByName('id_item').AsLargeInt := FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt;
        qry.ParamByName('vl_unitario').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsCurrency;
        qry.ParamByName('vl_total_item').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency;
        qry.ParamByName('qtd_venda').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsInteger;
        qry.ParamByName('vl_desconto').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency;
        qry.ParamByName('cd_tabela_preco').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_tabela_preco').AsInteger;
        qry.ParamByName('icms_vl_base').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency;
        qry.ParamByName('icms_pc_aliq').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsCurrency;
        qry.ParamByName('icms_valor').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency;
        qry.ParamByName('ipi_vl_base').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_vl_base').AsCurrency;
        qry.ParamByName('ipi_pc_aliq').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_pc_aliq').AsCurrency;
        qry.ParamByName('ipi_valor').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_valor').AsCurrency;
        qry.ParamByName('pis_cofins_vl_base').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_vl_base').AsCurrency;
        qry.ParamByName('pis_cofins_pc_aliq').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_pc_aliq').AsCurrency;
        qry.ParamByName('pis_cofins_valor').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_valor').AsCurrency;
        qry.ParamByName('un_medida').AsString := FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString;
        qry.ParamByName('seq_item').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger;
        qry.ExecSQL;
      end
      else
      begin
        qry.SQL.Clear;
        qry.SQL.Add(SQL_UPDATE);
        qry.ParamByName('id_geral').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_geral').AsLargeInt;
        qry.ParamByName('id_item').AsLargeInt := FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt;
        qry.ParamByName('vl_unitario').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsCurrency;
        qry.ParamByName('vl_total_item').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency;
        qry.ParamByName('qtd_venda').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsInteger;
        qry.ParamByName('vl_desconto').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency;
        qry.ParamByName('cd_tabela_preco').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_tabela_preco').AsInteger;
        qry.ParamByName('icms_vl_base').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency;
        qry.ParamByName('icms_pc_aliq').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsCurrency;
        qry.ParamByName('icms_valor').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency;
        qry.ParamByName('ipi_vl_base').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_vl_base').AsCurrency;
        qry.ParamByName('ipi_pc_aliq').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_pc_aliq').AsCurrency;
        qry.ParamByName('ipi_valor').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_valor').AsCurrency;
        qry.ParamByName('pis_cofins_vl_base').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_vl_base').AsCurrency;
        qry.ParamByName('pis_cofins_pc_aliq').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_pc_aliq').AsCurrency;
        qry.ParamByName('pis_cofins_valor').AsCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_valor').AsCurrency;
        qry.ParamByName('un_medida').AsString := FRegras.Dados.cdsPedidoVendaItem.FieldByName('un_medida').AsString;
        qry.ParamByName('seq_item').AsInteger := FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger;
        qry.ExecSQL;
      end;
      qry.Connection.Commit;

    except
    on E : exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os itens do pedido ' + E.Message);
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.SetRegras(const Value: TPedidoVenda);
begin
  FRegras := Value;
end;

end.
