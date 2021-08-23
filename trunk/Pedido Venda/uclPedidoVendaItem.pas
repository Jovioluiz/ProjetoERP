unit uclPedidoVendaItem;

interface

uses
  uclPedidoVenda, System.Generics.Collections;

type TPedidoVendaItem = class(TPedidoVenda)

  public
    function BuscaProdutoCodBarras(CodBarras: String): TArray<TPedidoVenda.TInfProdutosCodBarras>;

end;

implementation

uses
  FireDAC.Comp.Client, uDataModule;



{ TPedidoVendaItem }

function TPedidoVendaItem.BuscaProdutoCodBarras(CodBarras: String): TArray<TPedidoVenda.TInfProdutosCodBarras>;
const
  sql = 'select ' +
        '    p.cd_produto, ' +
        '    p.desc_produto, ' +
        '    tpp.un_medida, ' +
        '    tpp.cd_tabela, ' +
        '    tp.nm_tabela, ' +
        '    tpp.valor ' +
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
  j: Integer;
  infoProdutos: TArray<TInfProdutosCodBarras>;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(sql);
    qry.ParamByName('codigo_barras').AsString := CodBarras;
    qry.Open();

    SetLength(Result, qry.RecordCount);

    for j := 0 to Length(Result) - 1 do
    begin
      Result[j].CodItem := qry.FieldByName('cd_produto').AsString;
      Result[j].DescProduto :=  qry.FieldByName('desc_produto').AsString;
      Result[j].UnMedida := qry.FieldByName('un_medida').AsString;
      Result[j].CdTabelaPreco := qry.FieldByName('cd_tabela').AsInteger;
      Result[j].DescTabelaPreco := qry.FieldByName('nm_tabela').AsString;
      Result[j].Valor := qry.FieldByName('valor').AsCurrency;
    end;

    PreencheDataSet(Result);

  finally
    qry.Free;
  end;

end;

end.
