unit uConsultaProdutos;

interface

uses
  dtmConsultaProduto, uUtil, FireDAC.Stan.Param, Data.DB;

type
  TParametrosConsulta = record
    DescricaoProduto: string;
    Codigo,
    Descricao,
    Ativo,
    Estoque: Boolean;
  end;

  TConsultaProdutos = class

  private
    FDados: TdmConsultaProduto;
    procedure SetDados(const Value: TdmConsultaProduto);
    procedure PreencheDataset(Dataset: TDataSet);
  public
    constructor Create;
    procedure CarregaUltimaEntrada;
    procedure CarregaProdutos(Parametros: TParametrosConsulta);
    procedure CarregaPrecos(IDItem: Int64);
    procedure CarregaEstoques(IDItem: Int64);
    destructor Destroy; override;

    property Dados: TdmConsultaProduto read FDados write SetDados;
end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, System.SysUtils, Vcl.Dialogs;

{ TConsultaProdutos }

procedure TConsultaProdutos.CarregaEstoques(IDItem: Int64);
const
  SQL = 'select ' +
        '    wep.nm_endereco, ' +
        '    wep.ordem, ' +
        '    we.qt_estoque ' +
        'from ' +
        '    wms_endereco_produto wep ' +
        'join wms_estoque we on ' +
        '    we.id_wms_endereco_produto = wep.id_geral ' +
        'where wep.id_item = :id_item ';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  FDados.cdsEstoque.EmptyDataSet;

  try
    qry.Open(SQL, [IDItem]);

    if qry.IsEmpty then
      FDados.cdsEstoque.EmptyDataSet
    else
    begin
      qry.Loop(
      procedure
      begin
        FDados.cdsEstoque.Append;
        FDados.cdsEstoque.FieldByName('nm_endereco').AsString := qry.FieldByName('nm_endereco').AsString;
        FDados.cdsEstoque.FieldByName('ordem').AsInteger := qry.FieldByName('ordem').AsInteger;
        FDados.cdsEstoque.FieldByName('qt_estoque').AsFloat := qry.FieldByName('qt_estoque').AsFloat;
        FDados.cdsEstoque.Post;
      end
      );
    end;
  finally
    qry.Free;
  end;
end;

procedure TConsultaProdutos.CarregaPrecos(IDItem: Int64);
const
  sql = 'select                            '+
        '    tpp.cd_tabela,                '+
        '    tp.nm_tabela,                 '+
        '    tpp.valor,                    '+
        '    tpp.un_medida                 '+
        '    from tabela_preco_produto tpp '+
        'join tabela_preco tp on           '+
        '    tpp.cd_tabela = tp.cd_tabela  '+
        'where tpp.id_item = :id_item';
var
  qry: TFDQuery;
begin
  FDados.cdsPrecos.EmptyDataSet;

  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql, [IDItem]);

    if qry.IsEmpty then
      FDados.cdsPrecos.EmptyDataSet
    else
    begin
      qry.Loop(
      procedure
      begin
        FDados.cdsPrecos.Append;
        FDados.cdsPrecos.FieldByName('cd_tabela').AsInteger := qry.FieldByName('cd_tabela').AsInteger;
        FDados.cdsPrecos.FieldByName('nm_tabela').AsString := qry.FieldByName('nm_tabela').AsString;
        FDados.cdsPrecos.FieldByName('valor').AsCurrency := qry.FieldByName('valor').AsCurrency;
        FDados.cdsPrecos.FieldByName('un_medida').AsString := qry.FieldByName('un_medida').AsString;
        FDados.cdsPrecos.Post;
        qry.Next;
      end
      );
    end;

  finally
    qry.Free;
  end;
end;

procedure TConsultaProdutos.CarregaProdutos(Parametros: TParametrosConsulta);
const
  sql_produto =  'select ' +
                 '  cd_produto,  ' +
                 '  p.id_item,   ' +
                 '  desc_produto,' +
                 '  un_medida,   ' +
                 '  fator_conversao  ' +
                 'from               ' +
                 '  produto p        ' +
                 ' join wms_estoque we ON we.id_item = p.id_item ';
var
  qry: TFDQuery;
begin
  FDados.cdsConsultaProduto.EmptyDataSet;

  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  qry.SQL.Add(sql_produto);

  FDados.cdsConsultaProduto.DisableControls;

  try
    if Trim(Parametros.DescricaoProduto).Equals('') then
    begin
      ShowMessage('Informe algo para pesquisar');
      Exit;
    end;

    if Parametros.DescricaoProduto.Equals('*') then
      qry.Open(sql_produto)
    else
    begin
      if Parametros.Codigo then
        qry.SQL.Add(' where cd_produto ilike ' + QuotedStr('%'+Parametros.DescricaoProduto+'%'));
      if Parametros.Descricao then
        qry.SQL.Add(' or desc_produto ilike ' + QuotedStr('%'+Parametros.DescricaoProduto+'%'));
      if Parametros.Ativo then
        qry.SQL.Add(' and fl_ativo ');
      if Parametros.Estoque then
        qry.SQL.Add(' and qt_estoque > 0');
      qry.SQL.Add(' order by cd_produto');
      qry.Open();
    end;
    PreencheDataset(qry);
  finally
    qry.Free;
  end;
end;

procedure TConsultaProdutos.CarregaUltimaEntrada;
const
  sql = 'select                                  '+
        '    nfc.dcto_numero,                    '+
        '    c.nome as fornecedor,               '+
        '    nfc.dt_lancamento,                  '+
        '    nfi.un_medida,                      '+
        '    nfi.vl_unitario,                    '+
        '    nfi.qtd_estoque as quantidade       '+
        'from                                    '+
        '    produto p                           '+
        'join nfi on                             '+
        '    p.id_item = nfi.id_item             '+
        'join nfc on                             '+
        '    nfc.id_geral = nfi.id_nfc           '+
        'join cliente c on                       '+
        '    nfc.cd_fornecedor = c.cd_cliente    '+
        'where                                   '+
        '    p.id_item in (                      '+
        '    select                              '+
        '        nfi.id_item                     '+
        '    from                                '+
        '        nfc                             '+
        '    join nfi on                         '+
        '        nfc.id_geral = nfi.id_nfc       '+
        '    where                               '+
        '        nfc.dcto_numero > 0             '+
        '        and p.id_item = :id_item)';
var
  qry: TFDQuery;
  book: TBookmark;
begin
  FDados.cdsUltimasEntradas.EmptyDataSet;

  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  FDados.cdsUltimasEntradas.DisableControls;

  try
    qry.Open(sql, [FDados.cdsConsultaProduto.FieldByName('id_item').AsLargeInt]);
    if qry.IsEmpty then
      FDados.cdsUltimasEntradas.EmptyDataSet
    else
    begin
      qry.Loop(
      procedure
      begin
        if (FDados.cdsUltimasEntradas.Active) and (FDados.cdsUltimasEntradas.RecordCount = 1) then
          book := FDados.cdsConsultaProduto.GetBookmark;
        FDados.cdsUltimasEntradas.Append;
        FDados.cdsUltimasEntradas.FieldByName('dcto_numero').AsInteger := qry.FieldByName('dcto_numero').AsInteger;
        FDados.cdsUltimasEntradas.FieldByName('fornecedor').AsString := qry.FieldByName('fornecedor').AsString;
        FDados.cdsUltimasEntradas.FieldByName('dt_lancamento').AsDateTime := qry.FieldByName('dt_lancamento').AsDateTime;
        FDados.cdsUltimasEntradas.FieldByName('un_medida').AsString := qry.FieldByName('un_medida').AsString;
        FDados.cdsUltimasEntradas.FieldByName('vl_unitario').AsCurrency := qry.FieldByName('vl_unitario').AsCurrency;
        FDados.cdsUltimasEntradas.FieldByName('quantidade').AsFloat := qry.FieldByName('quantidade').AsFloat;
        FDados.cdsUltimasEntradas.Post;
      end
      );
    end;
  finally
    if FDados.cdsUltimasEntradas.BookmarkValid(book) then
      FDados.cdsUltimasEntradas.GotoBookmark(book);
    FDados.cdsUltimasEntradas.EnableControls;
    FDados.cdsUltimasEntradas.FreeBookmark(book);
    qry.Free;
  end;
end;

constructor TConsultaProdutos.Create;
begin
  FDados := TdmConsultaProduto.Create(nil);
end;

destructor TConsultaProdutos.Destroy;
begin
  FDados.Free;
  inherited;
end;

procedure TConsultaProdutos.PreencheDataset(Dataset: TDataSet);
var
  book: TBookmark;
begin
  try
    Dataset.Loop(
    procedure
    begin
      if (FDados.cdsConsultaProduto.Active) and (FDados.cdsConsultaProduto.RecordCount = 1) then
        book := FDados.cdsConsultaProduto.GetBookmark;
      FDados.cdsConsultaProduto.Append;
      FDados.cdsConsultaProduto.FieldByName('cd_produto').AsString := Dataset.FieldByName('cd_produto').AsString;
      FDados.cdsConsultaProduto.FieldByName('desc_produto').AsString := Dataset.FieldByName('desc_produto').AsString;
      FDados.cdsConsultaProduto.FieldByName('un_medida').AsString := Dataset.FieldByName('un_medida').AsString;
      FDados.cdsConsultaProduto.FieldByName('fator_conversao').AsInteger := Dataset.FieldByName('fator_conversao').AsInteger;
      FDados.cdsConsultaProduto.FieldByName('id_item').AsLargeInt := Dataset.FieldByName('id_item').AsLargeInt;
      FDados.cdsConsultaProduto.Post;
    end );
  finally
    if FDados.cdsConsultaProduto.BookmarkValid(book) then
      FDados.cdsConsultaProduto.GotoBookmark(book);
    FDados.cdsConsultaProduto.EnableControls;
    FDados.cdsConsultaProduto.FreeBookmark(book);
  end;
end;

procedure TConsultaProdutos.SetDados(const Value: TdmConsultaProduto);
begin
  FDados := Value;
end;

end.
