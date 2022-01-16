unit uclPedidoVenda;

interface

uses
  uDataModule, Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.UITypes, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Data.DB, FireDAC.Stan.Param,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Generics.Collections, dPedidoVenda,
  Datasnap.DBClient, uUtil, uTributacaoGenerica;

type
  TInfProdutosCodBarras = record
    CodItem,
    DescProduto,
    UnMedida,
    DescTabelaPreco: string;
    CdTabelaPreco: Integer;
    Valor: Currency;
  end;

type TPedidoVenda = class

  private
    FDados: TdmPedidoVenda;
    procedure SetDados(const Value: TdmPedidoVenda);

  public
    function ValidaQtdadeItem(CdItem: String; QtdPedido: Double): Boolean;
    function CalculaValorTotalItem(valorUnitario, qtdadeItem: Double): Double;
    function ValidaFormaPgto(CdFormaPgto: Integer): Boolean;
    function ValidaCliente(CdCliente: Integer): Boolean;
    function ValidaCondPgto(CdCond, CdForma: Integer): Boolean;
    function BuscaProduto(CodProduto: String): TInfProdutosCodBarras;
    function ValidaProduto(CodProduto: String): Boolean;
    function BuscaTabelaPreco(CodTabela: Integer; CodProduto: String): TFDQuery;
    function ValidaTabelaPreco(CodTabela: Integer; CodProduto: String): Boolean;
    function BuscaFormaPgto(CodForma: Integer): string;
    function BuscaCondicaoPgto(CodCond, CodForma: Integer): string;
    function IsCodBarrasProduto(Cod: String): Boolean;
    function GetIdItem(CdItem: string): Int64;
    function GetCdItem(IdItem: Integer): TInfProdutosCodBarras;
    function LancaAutoPedidoVenda(CodItem: string): Boolean;
    function GetCodProduto(CodBarras: String): string;
    procedure PreencheDataSet(Info: TArray<TInfProdutosCodBarras>);
    function CarregaPedidoVenda(NroPedido: Integer): Boolean;
    function CalculaImposto(ValorBase, Aliquota: Currency; Tributacao: string): Currency;
    procedure EditarPedido(NrPedido: Integer);
    procedure CancelaPedidoVenda(IdPedido: Int64);
    procedure CalculaValoresRateados(Valor: Currency; TipoValor: string);
    procedure CalculaValorContabil;
    constructor Create;
    destructor Destroy; override;

    property Dados: TdmPedidoVenda read FDados write SetDados;

end;

implementation

uses
  uPedidoVenda, uManipuladorTributacao, uTributacaoICMS, uTributacaoIPI,
  uConexao, System.Math;


{ TPedidoVenda }

function TPedidoVenda.ValidaCliente(CdCliente: Integer): Boolean;
const
  sql_cliente = 'select '+
                '  1 '+
                'from '+
                '   cliente c '+
                'join endereco_cliente e on '+
                '   c.cd_cliente = e.cd_cliente '+
                'where '+
                '   c.cd_cliente = :cd_cliente '+
                '   and c.fl_ativo ';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql_cliente, [CdCliente]);

    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.CalculaImposto(ValorBase, Aliquota: Currency; Tributacao: string): Currency;
var
  manipulador: TManipuladorTributacao;
begin
  Result := 0;
  if Tributacao.Equals('ICMS') then
    manipulador := TManipuladorTributacao.Create(TTributacaoICMS.Create)
  else if Tributacao.Equals('IPI') then
    manipulador := TManipuladorTributacao.Create(TTributacaoIPI.Create)
  else
    manipulador := nil;

  if Assigned(manipulador) then
  begin
    try
      Result := manipulador.CalculaImposto(ValorBase, Aliquota);
    finally
      manipulador.Free;
    end;
  end;
end;

function TPedidoVenda.ValidaCondPgto(CdCond, CdForma: Integer): Boolean;
const
  sql_condPgto = 'select                                '+
                 '    1                                 '+
                 'from cta_cond_pagamento ccp           '+
                 '    join cta_forma_pagamento cfp on   '+
                 'ccp.cd_cta_forma_pagamento = cfp.cd_forma_pag  '+
                 '    where (ccp.cd_cond_pag = :cd_cond_pag) and '+
                 'cfp.cd_forma_pag = :cd_forma_pag and         '+
                 'ccp.fl_ativo';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql_condPgto, [CdCond, CdForma]);
    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.ValidaFormaPgto(CdFormaPgto: Integer): Boolean;
const
  sql_forma_pgto =  'select                                '+
                    '   1                                  '+
                    'from                                  '+
                    '   cta_forma_pagamento                '+
                    'where                                 '+
                    '   (cd_forma_pag = :cd_forma_pag) and '+
                    '   fl_ativo';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql_forma_pgto, [CdFormaPgto]);
    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.ValidaProduto(CodProduto: String): Boolean;
const
  SQL_COD = 'select '+
            '   p.cd_produto                  '+
            'from                             '+
            '   produto p                     '+
            'join tabela_preco_produto tpp on '+
            '   p.id_item = tpp.id_item       '+
            'join tabela_preco tp on          '+
            '   tpp.cd_tabela = tp.cd_tabela  '+
            'where (p.cd_produto = :cd_produto) '+
            '   and (p.fl_ativo = True)';

  SQL_BARRAS =
        'select ' +
        '    p.cd_produto ' +
        'from ' +
        '    produto p ' +
        'join tabela_preco_produto tpp on ' +
        '    p.id_item = tpp.id_item ' +
        'join tabela_preco tp on ' +
        '    tpp.cd_tabela = tp.cd_tabela ' +
        'join produto_cod_barras pcb on ' +
        '    pcb.id_item = p.id_item ' +
        'where ' +
        '    (pcb.codigo_barras = :codigo_barras) ' +
        '    and (p.fl_ativo = True) ' +
        'limit 1 ';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL_COD);
    qry.ParamByName('cd_produto').AsString := CodProduto;
    qry.Open(SQL_COD);

    if not qry.IsEmpty then
      Exit(True);

    Result := True;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add(SQL_BARRAS);
    qry.ParamByName('codigo_barras').AsString := CodProduto;
    qry.Open(SQL_BARRAS);

    if not qry.IsEmpty then
      Exit(True);

  finally
    qry.Free;
  end;
end;

function TPedidoVenda.BuscaCondicaoPgto(CodCond, CodForma: Integer): string;
const
  sql = 'select                                        '+
       '    ccp.nm_cond_pag                            '+
       'from cta_cond_pagamento ccp                    '+
       '    join cta_forma_pagamento cfp on            '+
       'ccp.cd_cta_forma_pagamento = cfp.cd_forma_pag  '+
       '    where (ccp.cd_cond_pag = :cd_cond_pag) and '+
       '(cfp.cd_forma_pag = :cd_forma_pag) and         '+
       '    (ccp.fl_ativo = true)';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql, [CodCond, CodForma]);

    Result := qry.FieldByName('nm_cond_pag').AsString;

  finally
    qry.Free;
  end;
end;

function TPedidoVenda.BuscaFormaPgto(CodForma: Integer): string;
const
  sql = 'select                                '+
        '   nm_forma_pag                       '+
        'from                                  '+
        '   cta_forma_pagamento                '+
        'where                                 '+
        '   cd_forma_pag = :cd_forma_pag and '+
        '   fl_ativo';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql, [CodForma]);

    Result := qry.FieldByName('nm_forma_pag').AsString;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.BuscaProduto(CodProduto: String): TInfProdutosCodBarras;
const
  SQL = ' SELECT' +
        ' 	p.cd_produto,' +
        ' 	p.desc_produto,' +
        ' 	tpp.un_medida,' +
        ' 	tp.cd_tabela,' +
        ' 	tp.nm_tabela,' +
        ' 	tpp.valor' +
        ' FROM' +
        ' 	produto p' +
        ' JOIN tabela_preco_produto tpp ON p.id_item = tpp.id_item' +
        ' JOIN tabela_preco tp ON tpp.cd_tabela = tp.cd_tabela' +
        ' WHERE' +
        ' 	p.cd_produto = :cd_produto' +
        ' 	AND p.fl_ativo' +
        ' UNION ' +
        ' SELECT' +
        ' 	p2.cd_produto,' +
        ' 	p2.desc_produto,' +
        ' 	tpp.un_medida,' +
        ' 	tp.cd_tabela,' +
        ' 	tp.nm_tabela,' +
        ' 	tpp.valor' +
        ' FROM' +
        ' 	produto_cod_barras pcb' +
        ' JOIN produto p2 ON p2.id_item = pcb.id_item' +
        ' JOIN tabela_preco_produto tpp ON p2.id_item = tpp.id_item' +
        ' JOIN tabela_preco tp ON	tpp.cd_tabela = tp.cd_tabela' +
        ' WHERE' +
        ' 	pcb.codigo_barras = :cd_produto' +
        ' 	AND p2.fl_ativo;';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;
  try
    consulta.Open(SQL, [CodProduto]);

    if consulta.IsEmpty then
      raise Exception.Create('Produto não encontrado');

    Result.CodItem := consulta.FieldByName('cd_produto').AsString;
    Result.DescProduto := consulta.FieldByName('desc_produto').AsString;
    Result.UnMedida := consulta.FieldByName('un_medida').AsString;
    Result.CdTabelaPreco := consulta.FieldByName('cd_tabela').AsInteger;
    Result.DescTabelaPreco := consulta.FieldByName('nm_tabela').AsString;
    Result.Valor := consulta.FieldByName('valor').AsCurrency;
  finally
    consulta.Free;
  end;
end;

function TPedidoVenda.BuscaTabelaPreco(CodTabela: Integer; CodProduto: String): TFDQuery;
const
  sql = 'select                           '+
        '   tp.nm_tabela,                 '+
        '   tpp.valor                     '+
        'from                             '+
        '   tabela_preco tp               '+
        'join tabela_preco_produto tpp on '+
        '   tp.cd_tabela = tpp.cd_tabela  '+
        'join produto p on                '+
        '   tpp.id_item = p.id_item '+
        'where tp.cd_tabela = :cd_tabela'+
        '   and p.cd_produto = :cd_produto';
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := dm.conexaoBanco;

  Result.Open(sql, [CodTabela, CodProduto]);

  if Result.RecordCount = 0 then
    raise Exception.Create('Preço não encontrado para a tabela de preço.');

end;

procedure TPedidoVenda.CalculaValorContabil;
begin

  FDados.cdsPedidoVendaItem.First;
  while not FDados.cdsPedidoVendaItem.Eof do
  begin
    FDados.cdsPedidoVendaItem.Edit;
    FDados.cdsPedidoVendaItem.FieldByName('vl_contabil').AsCurrency := FDados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency
                                                                       + FDados.cdsPedidoVendaItem.FieldByName('rateado_vl_acrescimo').AsCurrency
                                                                       - FDados.cdsPedidoVendaItem.FieldByName('rateado_vl_desconto').AsCurrency;
    FDados.cdsPedidoVendaItem.Post;
    FDados.cdsPedidoVendaItem.Next;
  end;
end;

procedure TPedidoVenda.CalculaValoresRateados(Valor: Currency; TipoValor: string);
var
  valorTotal,
  valorItem,
  pcItem: Currency;

  function GetValorPedido: Currency;
  begin
    Result := 0;
    FDados.cdsPedidoVendaItem.First;
    while not FDados.cdsPedidoVendaItem.Eof do
    begin
      Result := Result + FDados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency;
      FDados.cdsPedidoVendaItem.Next;
    end;
  end;
begin
  valorTotal := GetValorPedido;

  if valorTotal = 0 then
    Exit;

  if Valor > 0 then
  begin
    FDados.cdsPedidoVendaItem.Loop(
    procedure
    begin
      valorItem := FDados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency;
      pcItem := valorItem / valorTotal;

      FDados.cdsPedidoVendaItem.Edit;
      if TipoValor.Equals('D') then
        FDados.cdsPedidoVendaItem.FieldByName('rateado_vl_desconto').AsCurrency := RoundTo(valor * pcItem, -2)
      else
        FDados.cdsPedidoVendaItem.FieldByName('rateado_vl_acrescimo').AsCurrency :=  RoundTo(valor * pcItem, -2);

      FDados.cdsPedidoVendaItem.Post;
    end
    );
  end;
end;

function TPedidoVenda.CalculaValorTotalItem(valorUnitario, qtdadeItem: Double): Double;
begin
  Result := valorUnitario * qtdadeItem;
end;

procedure TPedidoVenda.CancelaPedidoVenda(IdPedido: Int64);
const
  SQL = 'update pedido_venda set fl_cancelado = ''S'' where id_geral = :id_geral';
var
  qry: TConexao;
begin
  qry := TConexao.Create(nil);
  qry.Connection := qry.GetConexao;

  try
    try
      qry.SQL.Add(SQL);
      qry.ParamByName('id_geral').AsLargeInt := IdPedido;
      qry.ExecSQL;
      qry.Conexao.Commit;

    except on E:Exception do
      begin
        qry.Conexao.Rollback;
        raise Exception.Create('Erro ao cancelar o pedido'+ E.Message);
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

function TPedidoVenda.CarregaPedidoVenda(NroPedido: Integer): Boolean;
const
  SQL_PEDIDO = ' SELECT ' +
               ' 	pv.id_geral, ' +
               ' 	pvi.id_geral AS id_pvi, ' +
               ' 	pv.nr_pedido, ' +
               ' 	pv.fl_orcamento, ' +
               ' 	pv.cd_cliente, ' +
               ' 	c.nome, ' +
               ' 	e.cidade, ' +
               ' 	e.uf, ' +
               ' 	pv.cd_forma_pag, ' +
               ' 	cfp.nm_forma_pag, ' +
               ' 	pv.cd_cond_pag, ' +
               ' 	ccp.nm_cond_pag, ' +
               ' 	p.cd_produto, ' +
               ' 	p.desc_produto, ' +
               ' 	barras.codigo_barras, ' +
               ' 	pvi.qtd_venda, ' +
               ' 	pvi.cd_tabela_preco, ' +
               ' 	p.un_medida, ' +
               ' 	pvi.vl_unitario, ' +
               ' 	pvi.vl_desconto, ' +
               ' 	pvi.vl_total_item, ' +
               ' 	pvi.icms_vl_base, ' +
               ' 	pvi.icms_pc_aliq, ' +
               ' 	pvi.icms_valor, ' +
               ' 	pvi.ipi_vl_base, ' +
               ' 	pvi.ipi_pc_aliq, ' +
               ' 	pvi.ipi_valor, ' +
               ' 	pvi.pis_cofins_vl_base, ' +
               ' 	pvi.pis_cofins_pc_aliq, ' +
               ' 	pvi.pis_cofins_valor, ' +
               ' 	pvi.vl_total_item, ' +
               ' 	pv.vl_desconto_pedido, ' +
               ' 	pv.vl_acrescimo, ' +
               ' 	pv.vl_total, ' +
               ' 	pv.fl_cancelado, ' +
               ' 	pv.dt_emissao, ' +
               ' 	pvi.seq_item ' +
               ' FROM ' +
               ' 	pedido_venda pv ' +
               ' JOIN pedido_venda_item pvi ON pv.id_geral = pvi.id_pedido_venda ' +
               ' JOIN produto p ' +
               ' 		USING(id_item) ' +
               ' LEFT JOIN ( ' +
               ' 		SELECT ' +
               ' 			id_item, ' +
               ' 			codigo_barras ' +
               ' 		FROM ' +
               ' 			produto_cod_barras pcb ' +
               ' 		WHERE tipo_cod_barras = 1 ' +
               ' 	) AS barras ON barras.id_item = p.id_item  ' +
               ' JOIN cta_forma_pagamento cfp ON	pv.cd_forma_pag = cfp.cd_forma_pag ' +
               ' JOIN cta_cond_pagamento ccp ON cfp.cd_forma_pag = ccp.cd_cta_forma_pagamento ' +
               ' JOIN cliente c ON pv.cd_cliente = c.cd_cliente ' +
               ' JOIN endereco_cliente e ON c.cd_cliente = e.cd_cliente ' +
               ' WHERE pv.nr_pedido = :nr_pedido ';
var
  qry: TFDQuery;
  produto: TInfProdutosCodBarras;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    FDados.cdsPedidoVendaItem.EmptyDataSet;

    qry.Open(SQL_PEDIDO, [NroPedido]);

    if qry.IsEmpty then
      Exit(False);

    FDados.cdsPedidoVenda.Append;
    FDados.cdsPedidoVenda.FieldByName('id_geral').AsLargeInt := qry.FieldByName('id_geral').AsLargeInt;
    FDados.cdsPedidoVenda.FieldByName('nr_pedido').AsInteger := qry.FieldByName('nr_pedido').AsInteger;
    FDados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean := qry.FieldByName('fl_orcamento').AsBoolean;
    FDados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger := qry.FieldByName('cd_cliente').AsInteger;
    FDados.cdsPedidoVenda.FieldByName('nm_cliente').AsString := qry.FieldByName('nome').AsString;
    FDados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger := qry.FieldByName('cd_forma_pag').AsInteger;
    FDados.cdsPedidoVenda.FieldByName('nm_forma_pgto').AsString := qry.FieldByName('nm_forma_pag').AsString;
    FDados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger := qry.FieldByName('cd_cond_pag').AsInteger;
    FDados.cdsPedidoVenda.FieldByName('nm_cond_pgto').AsString := qry.FieldByName('nm_cond_pag').AsString;
    FDados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency := qry.FieldByName('vl_desconto_pedido').AsCurrency;
    FDados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency := qry.FieldByName('vl_acrescimo').AsCurrency;
    FDados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency := qry.FieldByName('vl_total').AsCurrency;
    FDados.cdsPedidoVenda.FieldByName('dt_emissao').AsDateTime := qry.FieldByName('dt_emissao').AsDateTime;
    FDados.cdsPedidoVenda.FieldByName('fl_cancelado').AsString := qry.FieldByName('fl_cancelado').AsString;
    FDados.cdsPedidoVenda.FieldByName('cidade').AsString := qry.FieldByName('cidade').AsString + '/' + qry.FieldByName('uf').AsString;
    FDados.cdsPedidoVenda.Post;

    qry.Loop(
    procedure
    begin
      produto := GetCdItem(GetIdItem(qry.FieldByName('cd_produto').AsString));
      FDados.cdsPedidoVendaItem.Append;
      FDados.cdsPedidoVendaItem.FieldByName('id_geral').AsLargeInt := qry.FieldByName('id_pvi').AsLargeInt;
      FDados.cdsPedidoVendaItem.FieldByName('id_pedido_venda').AsLargeInt := qry.FieldByName('id_geral').AsLargeInt;
      FDados.cdsPedidoVendaItem.FieldByName('id_item').AsLargeInt := GetIdItem(qry.FieldByName('cd_produto').AsString);
      FDados.cdsPedidoVendaItem.FieldByName('cd_produto').AsString := produto.CodItem;
      FDados.cdsPedidoVendaItem.FieldByName('descricao').AsString := produto.DescProduto;
      FDados.cdsPedidoVendaItem.FieldByName('qtd_venda').AsFloat := qry.FieldByName('qtd_venda').AsFloat;
      FDados.cdsPedidoVendaItem.FieldByName('cd_tabela_preco').AsInteger := qry.FieldByName('cd_tabela_preco').AsInteger;
      FDados.cdsPedidoVendaItem.FieldByName('un_medida').AsString := qry.FieldByName('un_medida').AsString;
      FDados.cdsPedidoVendaItem.FieldByName('vl_unitario').AsCurrency := qry.FieldByName('vl_unitario').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('vl_desconto').AsCurrency := qry.FieldByName('vl_desconto').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('vl_total_item').AsCurrency := qry.FieldByName('vl_total_item').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('icms_vl_base').AsCurrency := qry.FieldByName('icms_vl_base').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('icms_pc_aliq').AsCurrency := qry.FieldByName('icms_pc_aliq').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('icms_valor').AsCurrency := qry.FieldByName('icms_valor').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('ipi_vl_base').AsCurrency := qry.FieldByName('ipi_vl_base').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('ipi_pc_aliq').AsCurrency := qry.FieldByName('ipi_pc_aliq').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('ipi_valor').AsCurrency := qry.FieldByName('ipi_valor').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('pis_cofins_vl_base').AsCurrency := qry.FieldByName('pis_cofins_vl_base').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('pis_cofins_pc_aliq').AsCurrency := qry.FieldByName('pis_cofins_pc_aliq').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('pis_cofins_valor').AsCurrency := qry.FieldByName('pis_cofins_valor').AsCurrency;
      FDados.cdsPedidoVendaItem.FieldByName('seq').AsInteger := qry.FieldByName('seq_item').AsInteger;
      FDados.cdsPedidoVendaItem.Post;
    end
    );
    Result := True;

  finally
    qry.Free;
  end;
end;

constructor TPedidoVenda.Create;
begin
  FDados := TdmPedidoVenda.Create(nil);
end;

destructor TPedidoVenda.Destroy;
begin
  FDados.Free;
  inherited;
end;

procedure TPedidoVenda.EditarPedido(NrPedido: Integer);
const
  SQL = 'select fl_cancelado from pedido_venda where nr_pedido = :nr_pedido';
var
  qry: TFDQuery;
  frmPedidoVenda: TfrmPedidoVenda;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  frmPedidoVenda := nil;

  try
    qry.Open(SQL, [NrPedido]);

    if qry.FieldByName('fl_cancelado').AsString.Equals('S') then
    begin
      MessageDlg('O pedido não pode ser editado, pois está cancelado.', mtWarning, [mbOK],0);
      Exit;
    end;

    if not qry.IsEmpty then
    begin
      frmPedidoVenda := TfrmPedidoVenda.Create(nil);
      frmPedidoVenda.edtNrPedido.Text := NrPedido.ToString;
      frmPedidoVenda.EdicaoPedido := True;
      frmPedidoVenda.Visible := False;
      frmPedidoVenda.ShowModal;
    end;
  finally
    qry.Free;
    frmPedidoVenda.Free;
  end;
end;

function TPedidoVenda.GetCdItem(IdItem: Integer): TInfProdutosCodBarras;
const
  SQL = 'select ' +
        '    cd_produto,  ' +
        '    desc_produto ' +
        'from ' +
        '    produto p ' +
        'where ' +
        '    id_item = :id_item ';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [IdItem]);

    Result.CodItem := query.FieldByName('cd_produto').AsString;
    Result.DescProduto := query.FieldByName('desc_produto').AsString;

  finally
    query.Free;
  end;
end;

function TPedidoVenda.GetCodProduto(CodBarras: String): string;
const
  SQL = ' SELECT ' +
        ' 	p.cd_produto' +
        ' FROM ' +
        ' 	produto_cod_barras pcb ' +
        ' JOIN produto p ON p.id_item = pcb.id_item ' +
        ' WHERE pcb.codigo_barras = :codigo ' +
        ' UNION ' +
        ' SELECT ' +
        ' 	pr.cd_produto ' +
        ' FROM ' +
        ' 	produto pr ' +
        ' WHERE pr.cd_produto = :codigo ';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL, [CodBarras]);

    Result := qry.FieldByName('cd_produto').AsString;

  finally
    qry.Free;
  end;
end;

function TPedidoVenda.GetIdItem(CdItem: string): Int64;
const
  SQL = 'select id_item from produto where cd_produto = :cd_produto';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('cd_produto').AsString := CdItem;
    qry.Open();

    Result := qry.FieldByName('id_item').AsLargeInt;

  finally
    qry.Free;
  end;
end;

function TPedidoVenda.IsCodBarrasProduto(Cod: String): Boolean;
const
  SQL =
    'select ' +
    '    1 ' +
    'from ' +
    '    produto_cod_barras pcb ' +
    'where ' +
    '    codigo_barras = :codigo_barras ';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('codigo_barras').AsString := Cod;
    qry.Open();

    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function TPedidoVenda.LancaAutoPedidoVenda(CodItem: string): Boolean;
const
  SQL = 'select lanca_auto_pedido_venda FROM produto WHERE cd_produto = :cd_produto';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    consulta.Open(SQL, [CodItem]);
    Result := (not consulta.IsEmpty) and (consulta.FieldByName('lanca_auto_pedido_venda').AsBoolean);
  finally
    consulta.Free;
  end;
end;

procedure TPedidoVenda.PreencheDataSet(Info: TArray<TInfProdutosCodBarras>);
var
  dataset: TClientDataSet;
  dataSource: TDataSource;
begin
  dataset := TClientDataSet.Create(nil);
  dataSource := TDataSource.Create(nil);

  //fiz isso somente para praticar
  try
    dataSource.DataSet := dataset;

    dataset.FieldDefs.Clear;
    dataset.FieldDefs.Add('cd_produto', ftString, 50);
    dataset.FieldDefs.Add('desc_produto', ftString, 50);
    dataset.FieldDefs.Add('un_medida', ftString, 5);
    dataset.FieldDefs.Add('cd_tabela', ftInteger);
    dataset.FieldDefs.Add('nm_tabela', ftString, 50);
    dataset.FieldDefs.Add('valor', ftCurrency);
    dataset.CreateDataSet;

    for var i := 0 to Length(Info) - 1 do
    begin
      dataset.Append;
      dataset.FieldByName('cd_produto').AsString := Info[i].CodItem;
      dataset.FieldByName('desc_produto').AsString := Info[i].DescProduto;
      dataset.FieldByName('un_medida').AsString := Info[i].UnMedida;
      dataset.FieldByName('cd_tabela').AsInteger := Info[i].CdTabelaPreco;
      dataset.FieldByName('nm_tabela').AsString := Info[i].DescTabelaPreco;
      dataset.FieldByName('valor').AsCurrency := Info[i].Valor;
      dataset.Post;
    end;

  finally
    dataset.Free;
    dataSource.Free;
  end;
end;

procedure TPedidoVenda.SetDados(const Value: TdmPedidoVenda);
begin
  FDados := Value;
end;

function TPedidoVenda.ValidaQtdadeItem(CdItem: String; QtdPedido: Double): Boolean;
const
  SQL = 'select               '+
        '  qt_estoque         '+
        'from                 '+
        '  wms_estoque        '+
        'where                '+
        '  id_item = :id_item';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  Result := True;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('id_item').AsLargeInt := GetIdItem(CdItem);
    qry.Open(SQL);

    if qry.IsEmpty then
      Exit(False);

    if QtdPedido > qry.FieldByName('qt_estoque').AsFloat then
    begin
      ShowMessage('Quantidade informada maior que a disponível.'
                  + #13 + 'Quantidade disponível: ' + FloatToStr(qry.FieldByName('qt_estoque').AsFloat));
      Result := False;
    end;

  finally
    qry.Free;
  end;
end;

function TPedidoVenda.ValidaTabelaPreco(CodTabela: Integer; CodProduto: String): Boolean;
const
  sql = ' select                          '+
        '  1                              '+
        '  from                           '+
        '  tabela_preco tp                '+
        '  join tabela_preco_produto tpp on   '+
        '  tp.cd_tabela = tpp.cd_tabela   '+
        '  join produto p on              '+
        '  tpp.id_item = p.id_item        '+
        '  where tp.cd_tabela = :cd_tabela  '+
        '  and p.cd_produto = :cd_produto::text';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql, [CodTabela, CodProduto]);
    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

end.
