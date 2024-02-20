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
  Vcl.NumberBox, uTributacaoGenerica, FireDAC.VCLUI.Controls;

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
    edtVlDescontoItem: TNumberBox;
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
    procedure edtVlDescTotalPedidoExit(Sender: TObject);
    procedure edtCdProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FEdicaoItem: Boolean;
    FNumeroPedido: Integer;
    FRegras: TPedidoVenda;
    FGerador: TGerador;
    FEdicaoPedido: Boolean;
    FSeqItem: Integer;
    function GetAliquotasItem(IDItem: Int64): TAliqItem;
    procedure SetRegras(const Value: TPedidoVenda);
    procedure LimpaCampos;
    procedure LimpaDados;
    procedure AtualizaEstoqueProduto;
    function ProdutoJaLancado(CodProduto: Integer): Boolean;
    function RetornaSequencia: Integer;
    procedure AlteraSequenciaItem;
    procedure SalvaCabecalho;

    procedure SalvaItens(EhEdicao: Boolean);

    procedure CancelaPedidoVenda;
    procedure InsereWmsMvto;
    function GetNumeroParcelas(CdCondPgto: Integer): Integer;
    procedure CarregaItensEdicao;
    procedure PreencheCabecalhoPedido;
    procedure LancaItem;

    procedure ConfirmaPedidoVenda;
    procedure SetEdicaoPedido(const Value: Boolean);
    procedure BuscarProduto;
    procedure CalculaValorTotalPedido;
    function GetValorTotal(Data: TDataSet): Currency; overload;
    function ValidaProdutoDigitado: Boolean;
  public
    procedure SetDadosNota;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property Regras: TPedidoVenda read FRegras write SetRegras;
    property EdicaoPedido: Boolean read FEdicaoPedido write SetEdicaoPedido;
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

uses
  uDataModule, uConfiguracoes, uUtil, System.Math, uMovimentacaoEstoque,
  uclPedidoVendaItem, uclPedido_venda_item, uclProduto, fConsulta;

{$R *.dfm}


procedure TfrmPedidoVenda.AlteraSequenciaItem;
var
  I: Integer;
begin
  FRegras.Dados.cdsPedidoVendaItem.First;
  
  for I := 1 to FRegras.Dados.cdsPedidoVendaItem.RecordCount do
  begin
    if FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger <> I then
    begin
      FRegras.Dados.cdsPedidoVendaItem.Edit;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('seq').AsInteger := I;
      FRegras.Dados.cdsPedidoVendaItem.Post;
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
    FRegras.CancelaPedidoVenda(FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt);
    LimpaDados;
  end;
end;

procedure TfrmPedidoVenda.btnConfirmarPedidoClick(Sender: TObject);
begin
  if edtVlTotalPedido.ValueCurrency < 0  then
    raise Exception.Create('Valor total do pedido n�o pode ser negativo');

  ConfirmaPedidoVenda;
  LimpaDados;
end;

procedure TfrmPedidoVenda.BuscarProduto;
var
  dados: TInfProdutosCodBarras;
  pvItem: TPedidoVendaItem;
  codProduto: string;
begin
  if not ValidaProdutoDigitado then
    Exit;
  pvItem := TPedidoVendaItem.Create;
  try

    codProduto := FRegras.GetCodProduto(edtCdProduto.Text);
    dados := FRegras.BuscaProduto(codProduto);
    edtDescProduto.Text := dados.DescProduto;
    edtUnMedida.Text := dados.UnMedida;
    edtCdtabelaPreco.Text := IntToStr(dados.CdTabelaPreco);
    edtDescTabelaPreco.Text := dados.DescTabelaPreco;
    edtVlUnitario.ValueCurrency := dados.Valor;
    if (FRegras.IsCodBarrasProduto(edtCdProduto.Text))
      and (FRegras.LancaAutoPedidoVenda(codProduto)) then
    begin
      edtCdProduto.Text := dados.CodItem;
      edtQtdade.ValueFloat := 1;
      edtVlTotal.ValueCurrency := FRegras.CalculaValorTotalItem(edtVlUnitario.ValueCurrency,
                                                                edtQtdade.ValueFloat);
      LancaItem;
    end;
  finally
    pvItem.Free;
  end;
end;

function TfrmPedidoVenda.ValidaProdutoDigitado: Boolean;
begin
  Result := True;
  if (Trim(edtCdProduto.Text) = '') and (FRegras.Dados.cdsPedidoVendaItem.RecordCount > 0) then
  begin
    edtVlDescTotalPedido.SetFocus;
    Exit(False);
  end;
  if (Trim(edtCdProduto.Text).Equals('')) and (FRegras.Dados.cdsPedidoVendaItem.RecordCount = 0) then
  begin
    ShowMessage('Informe um produto!');
    Exit(False);
  end;
  if not FRegras.ValidaProduto(edtCdProduto.Text) then
  begin
    if (Application.MessageBox('Produto sem pre�o Cadastrado ou Inativo!', 'Verifique', MB_OK) = idOK) then
    begin
      edtCdtabelaPreco.Text := '';
      edtCdProduto.SetFocus;
      Exit(False);
    end;
  end;
end;


function TfrmPedidoVenda.GetValorTotal(Data: TDataSet): Currency;
var
  util: TUtil;
begin
  util := TUtil.Create;
  var func:= util.RetornaSoma;

  try
    Result := func(Data, 'vl_total_item');
  finally
    util.Free;
  end;
end;

procedure TfrmPedidoVenda.CalculaValorTotalPedido;
begin
  edtVlTotalPedido.ValueCurrency := GetValorTotal(FRegras.Dados.cdsPedidoVendaItem)
                                    + edtVlAcrescimoTotalPedido.ValueCurrency
                                    - edtVlDescTotalPedido.ValueCurrency;
end;

procedure TfrmPedidoVenda.CancelaPedidoVenda;
begin
  FRegras.CancelaPedidoVenda(FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt);
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
  edtVlDescontoItem.ValueCurrency := FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency;
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

  if FRegras.Dados.cdsPedidoVendaItem.IndexDefs.IndexOf(sIndexName) < 0 then
    FRegras.Dados.cdsPedidoVendaItem.AddIndex(sIndexName, Column.FieldName, oOrdenacao);
  FRegras.Dados.cdsPedidoVendaItem.IndexDefs.Update;
  Column.Title.Font.Style := [fsBold];
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
begin
  if not edtCdCliente.isEmpty then
  begin
    if not Regras.ValidaCliente(StrToInt(edtCdCliente.Text)) then
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
begin
  if edtCdCondPgto.isEmpty then
    raise Exception.Create('Informe uma condi��o de pagamento');

  if not edtCdCondPgto.isEmpty then
  begin
    if not FRegras.ValidaCondPgto(StrToInt(edtCdCondPgto.Text), StrToInt(edtCdFormaPgto.Text)) then
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
begin
  if edtCdFormaPgto.isEmpty then
    raise Exception.Create('Informe uma forma de pagamento');

  if not edtCdFormaPgto.isEmpty then
  begin
    if not FRegras.ValidaFormaPgto(StrToInt(edtCdFormaPgto.Text)) then
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
      SalvaCabecalho;

  finally
    qry.Free;
  end;
end;

procedure TfrmPedidoVenda.edtCdProdutoExit(Sender: TObject);
begin
  BuscarProduto;
end;

procedure TfrmPedidoVenda.edtCdProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  SQL = ' SELECT ' +
        ' 	cd_produto, ' +
        ' 	desc_produto, ' +
        ' 	un_medida ' +
        ' FROM ' +
        ' 	produto ';
var
  consulta: TformConsulta;
begin

  if key = VK_F9 then
  begin
    consulta := TformConsulta.Create(Self);

    try
      consulta.CampoChave := 'cd_produto';
      consulta.CarregaConsulta(SQl);
      consulta.ShowModal;
      edtCdProduto.Text := consulta.RegistroSelecionado.ToString;
      edtCdProdutoExit(Self);
    finally
      consulta.Free;
    end;
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

  lista := TFDQuery.Create(Self);

  try
    lista := FRegras.BuscaTabelaPreco(StrToInt(edtCdtabelaPreco.Text), edtCdProduto.Text);

    edtDescTabelaPreco.Text := lista.FieldByName('nm_tabela').AsString;
    edtVlUnitario.ValueCurrency := lista.FieldByName('valor').AsCurrency;
  finally
    lista.Free;
  end;
end;

procedure TfrmPedidoVenda.edtCdtabelaPrecoExit(Sender: TObject);
begin
  if not edtCdtabelaPreco.isEmpty then
  begin
    if not FRegras.ValidaTabelaPreco(StrToInt(edtCdtabelaPreco.Text), edtCdProduto.Text) then
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
  if ((edtQtdade.ValueFloat = 0) and (edtCdProduto.Text <> '')) then
  begin
    ShowMessage('Informe uma quantidade maior que 0.');
    edtQtdade.SelectAll;
    edtQtdade.SetFocus;
  end;

  if edtQtdade.ValueFloat > 0 then
    if not FRegras.ValidaQtdadeItem(FRegras.GetIdItem(edtCdProduto.Text), edtQtdade.ValueFloat) then
    begin
      ShowMessage('Estoque n�o encontrado para o item.');
      edtCdProduto.SetFocus;
      Exit;
    end;
end;

procedure TfrmPedidoVenda.edtVlAcrescimoTotalPedidoExit(Sender: TObject);
begin
  if edtVlAcrescimoTotalPedido.ValueCurrency <> FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency then
  begin
    FRegras.Dados.cdsPedidoVenda.Edit;
    FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency := edtVlAcrescimoTotalPedido.ValueCurrency;
    FRegras.Dados.cdsPedidoVenda.Post;
    CalculaValorTotalPedido;

    FRegras.CalculaValoresRateados(edtVlAcrescimoTotalPedido.ValueCurrency, 'A');
    FRegras.CalculaValorContabil;
  end;
end;

//altera o valor total ao sair do campo de desconto
procedure TfrmPedidoVenda.edtVlDescontoItemExit(Sender: TObject);
begin
  edtVlTotal.ValueCurrency := (edtVlUnitario.ValueCurrency * edtQtdade.ValueFloat) - edtVlDescontoItem.ValueCurrency;
end;

procedure TfrmPedidoVenda.edtVlDescTotalPedidoExit(Sender: TObject);
begin
  if edtVlDescTotalPedido.ValueCurrency > edtVlTotalPedido.ValueCurrency then
    raise Exception.Create('Valor do desconto maior que o total do pedido');

  if edtVlDescTotalPedido.ValueCurrency <> FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency then
  begin
    FRegras.Dados.cdsPedidoVenda.Edit;
    FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency := edtVlDescTotalPedido.ValueCurrency;
    FRegras.Dados.cdsPedidoVenda.Post;
    CalculaValorTotalPedido;

    FRegras.CalculaValoresRateados(edtVlDescTotalPedido.ValueCurrency, 'D');
    FRegras.CalculaValorContabil;
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

    if query.IsEmpty then
      Exit(Default(TAliqItem));

    Result.AliqIcms := query.FieldByName('aliquota_icms').AsCurrency;
    Result.AliqIpi := query.FieldByName('aliquota_ipi').AsCurrency;
    Result.AliqPisCofins := query.FieldByName('aliquota_pis_cofins').AsCurrency;

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

procedure TfrmPedidoVenda.ConfirmaPedidoVenda;
begin
  try
    FRegras.GravaCabecalho;
    FRegras.CalculaValorContabil;
    AlteraSequenciaItem;

    FRegras.Dados.cdsPedidoVendaItem.Loop(
    procedure
    begin
      SalvaItens(True);
    end);

    InsereWmsMvto;
    AtualizaEstoqueProduto;
    ShowMessage('Pedido ' + FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsString + ' Gravado Com Sucesso');
  except
    on E : exception do
    begin
      raise Exception.Create('Erro ao gravar os dados do pedido ' + edtNrPedido.Text + E.Message);
    end;
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
        ShowMessage('Erro ao gravar os dados do movimento do produto '
                    + FRegras.Dados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString
                    + E.Message);
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
 var
  aliq: TAliqItem;
begin

  try
    aliq := Default(TAliqItem);
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
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency := edtVlDescontoItem.ValueCurrency;
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
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency := edtVlDescontoItem.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency := edtVlTotal.ValueCurrency;
    end;

    if aliq.AliqIcms > 0 then
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency := edtVlTotal.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsFloat := aliq.AliqIcms;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency := FRegras.CalculaImposto(edtVlTotal.ValueCurrency,
                                                                                                      aliq.AliqIcms, 'ICMS');
    end;
    if aliq.AliqIpi > 0 then
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_vl_base').AsCurrency := edtVlTotal.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_pc_aliq').AsFloat := aliq.AliqIpi;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('ipi_valor').AsCurrency := FRegras.CalculaImposto(edtVlTotal.ValueCurrency,
                                                                                                     aliq.AliqIpi, 'IPI');
    end;
    if aliq.AliqPisCofins > 0 then
    begin
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_vl_base').AsCurrency := edtVlTotal.ValueCurrency;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_pc_aliq').AsFloat := aliq.AliqPisCofins;
      FRegras.Dados.cdsPedidoVendaItem.FieldByName('pis_cofins_valor').AsCurrency := FRegras.CalculaImposto(edtVlTotal.ValueCurrency,
                                                                                                            aliq.AliqPisCofins, 'PISCOFINS');
    end;

    FRegras.Dados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt := FRegras.GetIdItem(edtCdProduto.Text);
    FRegras.Dados.cdsPedidoVendaItem.Post;

    SalvaItens(FEdicaoItem);

    //soma os valores totais dos itens e preenche o valor total do pedido
    FRegras.Dados.cdsPedidoVenda.Edit;
    FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency := 0;

    FRegras.Dados.cdsPedidoVendaItem.Loop(
    procedure
    begin
      FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency
                                                                         + FRegras.Dados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency;
    end);
    FRegras.Dados.cdsPedidoVenda.Post;
    edtVlTotalPedido.ValueCurrency := FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency;

    FSeqItem := FSeqItem + 1;
    edtQtdade.ValueFloat := 0;
    FEdicaoItem := False;
  finally
    LimpaCampos;
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
  edtVlDescontoItem.ValueCurrency := 0;
  edtVlTotal.Clear;
  edtCdProduto.SetFocus;
  edtVlDescTotalPedido.ValueCurrency := 0;
  edtVlAcrescimoTotalPedido.ValueCurrency := 0;
  FSeqItem := 1;
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
  FRegras.Dados.cdsPedidoVenda.EmptyDataSet;
end;

procedure TfrmPedidoVenda.PreencheCabecalhoPedido;
begin

  if FRegras.Dados.cdsPedidoVenda.State in [dsEdit, dsBrowse] then
    FRegras.Dados.cdsPedidoVenda.Edit
  else
    FRegras.Dados.cdsPedidoVenda.Append;

  if FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt = 0 then
    FRegras.Dados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt := FGerador.GeraIdGeral;
  FRegras.Dados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger := NumeroPedido;
  FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger := StrToInt(edtCdCliente.Text);
  FRegras.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger := StrToInt(edtCdFormaPgto.Text);
  FRegras.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger := StrToInt(edtCdCondPgto.Text);
  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency := edtVlDescTotalPedido.ValueCurrency;
  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency := edtVlAcrescimoTotalPedido.ValueCurrency;
  FRegras.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency := edtVlTotalPedido.ValueCurrency
                                                                     + edtVlAcrescimoTotalPedido.ValueCurrency
                                                                     - edtVlDescTotalPedido.ValueCurrency;
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
begin
  FRegras.GravaCabecalho;
end;

procedure TfrmPedidoVenda.SalvaItens(EhEdicao: Boolean);
var
  pvi: TPedidoVendaItem;
begin
  pvi := TPedidoVendaItem.Create;

  try
    pvi.SalvarItens(FRegras.Dados.cdsPedidoVendaItem, EhEdicao);
  finally
    pvi.Free;
  end;
end;

procedure TfrmPedidoVenda.SetRegras(const Value: TPedidoVenda);
begin
  FRegras := Value;
end;

end.
