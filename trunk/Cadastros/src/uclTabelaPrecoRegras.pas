unit uclTabelaPrecoRegras;

interface

uses
  dTabelaPreco;

type
  TTabelaPrecoRegras = class
  private
    FDados: TdmProdutosTabelaPreco;
    procedure SetDados(const Value: TdmProdutosTabelaPreco);

    public
      procedure CarregaProdutosTabela(CodTabela: Integer);
      function GetIdItem(const CdItem: string): Int64;
      constructor Create;
      destructor Destroy; override;
      property Dados: TdmProdutosTabelaPreco read FDados write SetDados;
  end;

implementation

uses
  FireDAC.Comp.Client, Data.DB, uDataModule, uUtil;

{ TTabelaPrecoRegras }

procedure TTabelaPrecoRegras.CarregaProdutosTabela(CodTabela: Integer);
const
  SQL = 'select                           '+
        '   p.cd_produto,                 '+
        '   p.desc_produto,               '+
        '   valor,                        '+
        '   p.un_medida                   '+
        'from                             '+
        '   produto p                     '+
        'join tabela_preco_produto tpp on '+
        '   p.id_item = tpp.id_item       '+
        'where                            '+
        '   tpp.cd_tabela = :cd_tabela';
var
  query: TFDQuery;
  book: TBookmark;
begin

  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    FDados.cdsProdutos.EmptyDataSet;
    query.Open(SQL, [CodTabela]);

    query.Loop(
    procedure
    begin
      if FDados.cdsProdutos.RecordCount = 1 then
        book := FDados.cdsProdutos.GetBookmark;

      FDados.cdsProdutos.Append;
      FDados.cdsProdutos.FieldByName('cd_produto').AsString := query.FieldByName('cd_produto').AsString;
      FDados.cdsProdutos.FieldByName('nm_produto').AsString := query.FieldByName('desc_produto').AsString;
      FDados.cdsProdutos.FieldByName('valor').AsCurrency := query.FieldByName('valor').AsCurrency;
      FDados.cdsProdutos.FieldByName('un_medida').AsString := query.FieldByName('un_medida').AsString;
      FDados.cdsProdutos.Post;
    end);

  finally
    if FDados.cdsProdutos.BookmarkValid(book) then
      FDados.cdsProdutos.GotoBookmark(book);

    FDados.cdsProdutos.FreeBookmark(book);
    query.Free;
  end;
end;

constructor TTabelaPrecoRegras.Create;
begin
  FDados := TdmProdutosTabelaPreco.Create(nil);
end;

destructor TTabelaPrecoRegras.Destroy;
begin
  FDados.Free;
  inherited;
end;

function TTabelaPrecoRegras.GetIdItem(const CdItem: string): Int64;
const
  SQL = 'select id_item from produto where cd_produto = :cd_produto';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL, [CdItem]);

    Result := qry.FieldByName('id_item').AsLargeInt;

  finally
    qry.Free;
  end;
end;

procedure TTabelaPrecoRegras.SetDados(const Value: TdmProdutosTabelaPreco);
begin
  FDados := Value;
end;

end.
