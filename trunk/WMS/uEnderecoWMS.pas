unit uEnderecoWMS;

interface

uses
  FireDAC.Stan.Param, dWMS, Data.DB;

type TEnderecoWMS = class
  private
    FDados: TdmWMS;
    procedure SetDados(const Value: TdmWMS);
    function Pesquisar(IdEndereco: Int64; Endereco: string): Boolean;
    function GetUnMedidaItem(IdItem: Integer): String;
  public
    function GetIdItem(CdItem: string): Int64;
    function GetIdEndereco(NomeEndereco: String): Int64;

    procedure SalvaEnderecoProduto(Endereco: string);
    procedure SalvarWmsEstoque(IdEndereco: Int64; IdItem: integer);
    procedure CarregaEndereco(CodProduto: string);
    constructor Create;
    destructor Destroy; override;

    property Dados: TdmWMS read FDados write SetDados;
end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, uGerador, uUtil, System.SysUtils,
  Vcl.Dialogs;

procedure TEnderecoWMS.CarregaEndereco(CodProduto: string);
const
  SQL_PROD = ' select ' +
             ' 	p.desc_produto ' +
             ' from ' +
             ' 	produto p ' +
             ' left join produto_cod_barras pcb on ' +
             ' 	pcb.id_item = p.id_item ' +
             ' where ' +
             ' 	pcb.codigo_barras = :codigo ' +
             ' 	or p.cd_produto = :codigo ';

  SQL_ENDERECO = ' select ' +
                 '    p.cd_produto, ' +
                 '    p.desc_produto, ' +
                 '    we.cd_deposito, ' +
                 '    we.ala, ' +
                 '    we.rua, ' +
                 '    we.complemento, ' +
                 '    wep.nm_endereco,  ' +
                 '    wep.ordem ' +
                 ' from wms_endereco we ' +
                 ' join wms_endereco_produto wep on ' +
                 '    wep.id_endereco = we.id_geral  ' +
                 ' join produto p on  ' +
                 '    p.id_item = wep.id_item  ' +
                 ' where wep.id_item = :id_item  ';
var
  qryProduto,
  qryEnderecos: TFDQuery;
  nmProduto: string;
begin
  qryProduto := TFDQuery.Create(nil);
  qryProduto.Connection := dm.conexaoBanco;
  qryEnderecos := TFDQuery.Create(nil);
  qryEnderecos.Connection := dm.conexaoBanco;

  try
    qryProduto.Open(SQL_PROD, [CodProduto]);

    if qryProduto.IsEmpty then
    begin
      ShowMessage('Produto não encontrado!');
      Exit;
    end;

    if not qryProduto.IsEmpty then
      nmProduto := qryProduto.FieldByName('desc_produto').AsString;

    qryEnderecos.Open(SQL_ENDERECO, [GetIdItem(CodProduto)]);

    qryEnderecos.Loop(
    procedure
    begin
      Dados.cdsEnderecoProduto.Append;
      Dados.cdsEnderecoProduto.FieldByName('cd_produto').AsString := qryEnderecos.FieldByName('cd_produto').AsString;
      Dados.cdsEnderecoProduto.FieldByName('nm_produto').AsString := qryEnderecos.FieldByName('desc_produto').AsString;
      Dados.cdsEnderecoProduto.FieldByName('cd_deposito').AsInteger := qryEnderecos.FieldByName('cd_deposito').AsInteger;
      Dados.cdsEnderecoProduto.FieldByName('ala').AsString := qryEnderecos.FieldByName('ala').AsString;
      Dados.cdsEnderecoProduto.FieldByName('rua').AsString := qryEnderecos.FieldByName('rua').AsString;
      Dados.cdsEnderecoProduto.FieldByName('complemento').AsString := qryEnderecos.FieldByName('complemento').AsString;
      Dados.cdsEnderecoProduto.FieldByName('nm_endereco').AsString := qryEnderecos.FieldByName('nm_endereco').AsString;
      Dados.cdsEnderecoProduto.FieldByName('ordem').AsString := qryEnderecos.FieldByName('ordem').AsString;
      Dados.cdsEnderecoProduto.Post;
    end
    );

    if qryEnderecos.IsEmpty then
    begin
      Dados.cdsEnderecoProduto.Append;
      Dados.cdsEnderecoProduto.FieldByName('nm_produto').AsString := nmProduto;
      Dados.cdsEnderecoProduto.Post;
    end;

  finally
    qryProduto.Free;
    qryEnderecos.Free;
  end;
end;

constructor TEnderecoWMS.Create;
begin
  inherited;
  FDados := TdmWMS.Create(nil);
end;

destructor TEnderecoWMS.Destroy;
begin
  FDados.Free;
  inherited;
end;

function TEnderecoWMS.GetIdEndereco(NomeEndereco: String): Int64;
const
  SQL = 'select ' +
        '   id_geral    ' +
        'from            ' +
        '   wms_endereco we ' +
        'where               ' +
        '   concat(cd_deposito, ''-'', ala, ''-'', rua) = :nm_endereco ' +
        'limit 1';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('nm_endereco').AsString := NomeEndereco;
    qry.Open(SQL);

    Result := qry.FieldByName('id_geral').AsInteger;
  finally
    qry.Free;
  end;
end;

function TEnderecoWMS.GetIdItem(CdItem: string): Int64;
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

function TEnderecoWMS.GetUnMedidaItem(IdItem: Integer): String;
const
  SQL = 'select un_medida from produto where id_item = :id_item';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL, [IdItem]);

    Result := qry.FieldByName('un_medida').AsString;

  finally
    qry.Free;
  end;
end;

function TEnderecoWMS.Pesquisar(IdEndereco: Int64; Endereco: string): Boolean;
const
  SQL = 'select nm_endereco from wms_endereco_produto ' +
        ' where id_endereco = :id_endereco ' +
        ' AND id_item = :id_item' ;
var
  qry: TFDQuery;
  idItem: Integer;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    idItem := GetIdItem(Dados.cdsEnderecoProduto.FieldByName('cd_produto').AsString);
    qry.Open(SQL, [IdEndereco, idItem]);

    Result := qry.FieldByName('nm_endereco').AsString = Endereco;
  finally
    qry.Free;
  end;
end;

procedure TEnderecoWMS.SalvaEnderecoProduto(Endereco: string);
const
  SQL_INSERT = 'insert into wms_endereco_produto (id_geral, id_endereco, nm_endereco, id_item, ordem) ' +
               'values(:id_geral, :id_endereco, :nm_endereco, :id_item, :ordem)';
var
  qry: TFDQuery;
  idGeral: TGerador;
  idEndereco: Int64;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  idGeral := TGerador.Create;
  idEndereco := 0;

  try
    qry.SQL.Add(SQL_INSERT);
     //verifica se já possui um endereço cadastrado para o produto
    if not Pesquisar(GetIdEndereco(Dados.cdsEnderecoProduto.FieldByName('nm_endereco').AsString), endereco) then
    begin
      idEndereco := idGeral.GeraIdGeral;
      qry.ParamByName('id_geral').AsInteger := idEndereco;
      qry.ParamByName('id_endereco').AsInteger := GetIdEndereco(Dados.cdsEnderecoProduto.FieldByName('nm_endereco').AsString);
      qry.ParamByName('nm_endereco').AsString := Dados.cdsEnderecoProduto.FieldByName('nm_endereco').AsString;
      qry.ParamByName('id_item').AsLargeInt := GetIdItem(Dados.cdsEnderecoProduto.FieldByName('cd_produto').AsString);
      qry.ParamByName('ordem').AsInteger := Dados.cdsEnderecoProduto.FieldByName('ordem').AsInteger;
      qry.ExecSQL;
      qry.Connection.Commit;
    end;
    SalvarWmsEstoque(idEndereco, GetIdItem(Dados.cdsEnderecoProduto.FieldByName('cd_produto').AsString));
  finally
    idGeral.Free;
    qry.Free;
  end;
end;

procedure TEnderecoWMS.SalvarWmsEstoque(IdEndereco: Int64; IdItem: Integer);
const
  SQL_ITEM = 'select 1 from wms_estoque where id_item = :id_item';
  SQL_INSERT = ' INSERT INTO wms_estoque ' +
               ' (id_geral, id_wms_endereco_produto, id_item, qt_estoque, un_estoque) ' +
               ' VALUES(:id_geral, :id_wms_endereco_produto, :id_item, :qt_estoque, :un_estoque)';
var
  query: TFDQuery;
  idGeral: TGerador;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;
  idGeral := TGerador.Create;

  try
    query.Open(SQL_ITEM, [IdItem]);

    if query.IsEmpty then
    begin
      query.SQL.Clear;
      query.SQL.Add(SQL_INSERT);
      query.ParamByName('id_geral').AsLargeInt := idGeral.GeraIdGeral;
      query.ParamByName('id_wms_endereco_produto').AsLargeInt := IdEndereco;
      query.ParamByName('id_item').AsInteger := IdItem;
      query.ParamByName('qt_estoque').AsFloat := 0;
      query.ParamByName('un_estoque').AsString := GetUnMedidaItem(IdItem);
      query.ExecSQL;
    end;
    
  finally
    query.Free;
    idGeral.Free;
  end;
end;

procedure TEnderecoWMS.SetDados(const Value: TdmWMS);
begin
  FDados := Value;
end;

end.
