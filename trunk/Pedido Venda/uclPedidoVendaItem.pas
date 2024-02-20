unit uclPedidoVendaItem;

interface

uses
  uclPedidoVenda, System.Generics.Collections, Firedac.Stan.Param,
  Datasnap.DBClient;

type TPedidoVendaItem = class(TPedidoVenda)

  public
    procedure SalvarItens(DataSet: TClientDataSet; EhEdicao: Boolean);

end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, uclPedido_venda_item;



{ TPedidoVendaItem }

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
    pvi.qtd_venda := DataSet.FieldByName('qtd_venda').AsFloat;
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
    pvi.rateado_vl_desconto := DataSet.FieldByName('rateado_vl_desconto').AsCurrency;
    pvi.rateado_vl_acrescimo := DataSet.FieldByName('rateado_vl_acrescimo').AsCurrency;
    pvi.vl_contabil := DataSet.FieldByName('vl_contabil').AsCurrency;
    pvi.Persistir(not EhEdicao);

  finally
    pvi.Free;
  end;
end;

end.
