unit uclPedidoVendaItem;

interface

uses
  uclPedidoVenda, System.Generics.Collections, Firedac.Stan.Param,
  Datasnap.DBClient;

type TPedidoVendaItem = class(TPedidoVenda)

  public
//    function BuscaProdutoCodBarras(CodBarras: String): TArray<TPedidoVenda.TInfProdutosCodBarras>;
    procedure SalvarItens(DataSet: TClientDataSet; EhEdicao: Boolean);

end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, uclPedido_venda_item;



{ TPedidoVendaItem }

//function TPedidoVendaItem.BuscaProdutoCodBarras(CodBarras: String): TArray<TPedidoVenda.TInfProdutosCodBarras>;
//const
//  sql = 'select ' +
//        '    p.cd_produto, ' +
//        '    p.desc_produto, ' +
//        '    tpp.un_medida, ' +
//        '    tpp.cd_tabela, ' +
//        '    tp.nm_tabela, ' +
//        '    tpp.valor ' +
//        'from ' +
//        '    produto p ' +
//        'join tabela_preco_produto tpp on ' +
//        '    p.id_item = tpp.id_item ' +
//        'join tabela_preco tp on ' +
//        '    tpp.cd_tabela = tp.cd_tabela ' +
//        'join produto_cod_barras pcb on ' +
//        '    pcb.id_item = p.id_item ' +
//        'where ' +
//        '    pcb.codigo_barras = :codigo_barras ' +
//        '    and p.fl_ativo ' +
//        'limit 1 ';
//var
//  qry: TFDQuery;
//  j: Integer;
//begin
//  qry := TFDQuery.Create(nil);
//  qry.Connection := dm.conexaoBanco;
//
//  try
//    qry.SQL.Add(sql);
//    qry.ParamByName('codigo_barras').AsString := CodBarras;
//    qry.Open();
//
//    SetLength(Result, qry.RecordCount);
//
//    for j := 0 to Length(Result) - 1 do
//    begin
//      Result[j].CodItem := qry.FieldByName('cd_produto').AsString;
//      Result[j].DescProduto :=  qry.FieldByName('desc_produto').AsString;
//      Result[j].UnMedida := qry.FieldByName('un_medida').AsString;
//      Result[j].CdTabelaPreco := qry.FieldByName('cd_tabela').AsInteger;
//      Result[j].DescTabelaPreco := qry.FieldByName('nm_tabela').AsString;
//      Result[j].Valor := qry.FieldByName('valor').AsCurrency;
//    end;
//
//    PreencheDataSet(Result);
//
//  finally
//    qry.Free;
//  end;
//end;

procedure TPedidoVendaItem.SalvarItens(DataSet: TClientDataSet; EhEdicao: Boolean);
var
  pvi: TPedido_venda_item;
begin
  pvi := TPedido_venda_item.Create;

  try
    pvi.id_geral := DataSet.FieldByName('id_geral').AsLargeInt;
    pvi.id_pedido_venda := DataSet.FieldByName('id_pedido_venda').AsLargeInt;
    pvi.id_item := DataSet.FieldByName('id_item').AsLargeInt;
    pvi.vl_unitario := DataSet.FieldByName('vl_unitario').AsCurrency;
    pvi.vl_total_item := DataSet.FieldByName('vl_total_item').AsCurrency;
    pvi.qtd_venda := DataSet.FieldByName('qtd_venda').AsInteger;
    pvi.vl_desconto := DataSet.FieldByName('vl_desconto').AsCurrency;
    pvi.cd_tabela_preco := DataSet.FieldByName('cd_tabela_preco').AsInteger;
    pvi.icms_vl_base := DataSet.FieldByName('icms_vl_base').AsCurrency;
    pvi.icms_pc_aliq := DataSet.FieldByName('icms_pc_aliq').AsCurrency;
    pvi.icms_valor := DataSet.FieldByName('icms_valor').AsCurrency;
    pvi.ipi_vl_base := DataSet.FieldByName('ipi_vl_base').AsCurrency;
    pvi.ipi_pc_aliq := DataSet.FieldByName('ipi_pc_aliq').AsCurrency;
    pvi.ipi_valor := DataSet.FieldByName('ipi_valor').AsCurrency;
    pvi.pis_cofins_vl_base := DataSet.FieldByName('pis_cofins_vl_base').AsCurrency;
    pvi.pis_cofins_pc_aliq := DataSet.FieldByName('pis_cofins_pc_aliq').AsCurrency;
    pvi.pis_cofins_valor := DataSet.FieldByName('pis_cofins_valor').AsCurrency;
    pvi.un_medida := DataSet.FieldByName('un_medida').AsString;
    pvi.seq_item := DataSet.FieldByName('seq').AsInteger;
    pvi.Persistir(not EhEdicao);

  finally
    pvi.Free;
  end;
end;

end.
