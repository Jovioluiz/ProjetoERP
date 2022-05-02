unit uThreadGrids;

interface

uses
  System.Classes, Data.DB, uUtil;

type
  TThreadGrids = class(TThread)
  private
    FDataSetProdutos,
    FDataSetPedidos,
    FDataSetPedidosItem,
    FDataSetProdutosBarras: TDataSet;
    procedure CarregaProdutos;
    procedure CarregaPedidoVenda;
    procedure CarregaPedidoVendaItem;
    procedure CarregaProdutosCodBarras;

  public
    constructor Create;
    procedure Execute; override;
    procedure CarregarDados;

    property DataSetProdutos: TDataSet read FDataSetProdutos write FDataSetProdutos;
    property DataSetPedidos: TDataSet read FDataSetPedidos write FDataSetPedidos;
    property DataSetPedidosItem: TDataSet read FDataSetPedidosItem write FDataSetPedidosItem;
    property DataSetProdutosBarras: TDataSet read FDataSetProdutosBarras write FDataSetProdutosBarras;
  end;

implementation

uses
  FireDAC.Comp.Client, uDataModule;

{ TThreadGrids }

procedure TThreadGrids.CarregarDados;
begin
  CarregaProdutos;
  CarregaPedidoVenda;
  CarregaPedidoVendaItem;
  CarregaProdutosCodBarras;
end;

constructor TThreadGrids.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
end;

procedure TThreadGrids.Execute;
begin
  inherited;
  CarregarDados;
end;

procedure TThreadGrids.CarregaProdutos;
const
  SQL = 'select cd_produto, desc_produto from produto';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    DataSetProdutos.DisableControls;
    consulta.Open(SQL);
    consulta.Loop(
    procedure
    begin
      DataSetProdutos.Append;
      DataSetProdutos.FieldByName('cd_produto').AsString := consulta.FieldByName('cd_produto').AsString;
      DataSetProdutos.FieldByName('desc_produto').AsString := consulta.FieldByName('desc_produto').AsString;
      DataSetProdutos.Post;
    end
    );

  finally
    DataSetProdutos.EnableControls;
    consulta.Free;
  end;
end;

procedure TThreadGrids.CarregaPedidoVenda;
const
  SQL = 'select id_geral, nr_pedido, vl_total from pedido_venda';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    DataSetPedidos.DisableControls;
    consulta.Open(SQL);
    consulta.Loop(
    procedure
    begin
      DataSetPedidos.Append;
      DataSetPedidos.FieldByName('id_geral').AsLargeInt := consulta.FieldByName('id_geral').AsLargeInt;
      DataSetPedidos.FieldByName('nr_pedido').AsInteger := consulta.FieldByName('nr_pedido').AsInteger;
      DataSetPedidos.FieldByName('vl_total').AsCurrency := consulta.FieldByName('vl_total').AsCurrency;
      DataSetPedidos.Post;
    end
    );

  finally
    DataSetPedidos.EnableControls;
    consulta.Free;
  end;
end;

procedure TThreadGrids.CarregaPedidoVendaItem;
const
  SQL = 'select id_geral, id_pedido_venda, id_item, qtd_venda, vl_unitario, vl_total_item from pedido_venda_item';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    DataSetPedidosItem.DisableControls;
    consulta.Open(SQL);
    consulta.Loop(
    procedure
    begin
      DataSetPedidosItem.Append;
      DataSetPedidosItem.FieldByName('id_geral').AsLargeInt := consulta.FieldByName('id_geral').AsLargeInt;
      DataSetPedidosItem.FieldByName('id_pedido_venda').AsLargeInt := consulta.FieldByName('id_pedido_venda').AsLargeInt;
      DataSetPedidosItem.FieldByName('id_item').AsInteger := consulta.FieldByName('id_item').AsInteger;
      DataSetPedidosItem.FieldByName('qt_venda').AsFloat := consulta.FieldByName('qtd_venda').AsFloat;
      DataSetPedidosItem.FieldByName('vl_unitario').AsCurrency := consulta.FieldByName('vl_unitario').AsCurrency;
      DataSetPedidosItem.FieldByName('vl_total').AsCurrency := consulta.FieldByName('vl_total_item').AsCurrency;
      DataSetPedidosItem.Post;
    end
    );

  finally
    DataSetPedidosItem.EnableControls;
    consulta.Free;
  end;
end;

procedure TThreadGrids.CarregaProdutosCodBarras;
const
  SQL = 'select id_item, un_medida, tipo_cod_barras, codigo_barras from produto_cod_barras';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    DataSetProdutosBarras.DisableControls;
    consulta.Open(SQL);
    consulta.Loop(
    procedure
    begin
      DataSetProdutosBarras.Append;
      DataSetProdutosBarras.FieldByName('id_item').AsInteger := consulta.FieldByName('id_item').AsInteger;
      DataSetProdutosBarras.FieldByName('un_medida').AsString := consulta.FieldByName('un_medida').AsString;
      DataSetProdutosBarras.FieldByName('tipo_cod_barras').AsInteger := consulta.FieldByName('tipo_cod_barras').AsInteger;
      DataSetProdutosBarras.FieldByName('codigo_barras').AsString := consulta.FieldByName('codigo_barras').AsString;
      DataSetProdutosBarras.Post;
    end
    );

  finally
    DataSetProdutosBarras.EnableControls;
    consulta.Free;
  end;
end;

end.
