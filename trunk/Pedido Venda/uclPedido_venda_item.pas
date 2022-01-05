unit uclPedido_venda_item;

interface

uses
 FireDAC.Stan.Intf, FireDAC.Stan.Option, 
 FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Phys.Intf,   
 FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.DApt,  
 FireDAC.Comp.DataSet, Data.DB;

type TPedido_venda_item = class 

  private 
    Fcd_tabela_preco: Integer;
    Fdt_atz: TDateTime;
    Ficms_pc_aliq: Currency;
    Ficms_valor: Currency;
    Ficms_vl_base: Currency;
    Fid_geral: Int64;
    Fid_item: Integer;
    Fid_pedido_venda: Int64;
    Fipi_pc_aliq: Currency;
    Fipi_valor: Currency;
    Fipi_vl_base: Currency;
    Fpis_cofins_pc_aliq: Currency;
    Fpis_cofins_valor: Currency;
    Fpis_cofins_vl_base: Currency;
    Fqtd_venda: Integer;
    Fseq_item: Integer;
    Fun_medida: String;
    Fvl_desconto: Currency;
    Fvl_total_item: Currency;
    Fvl_unitario: Currency;
    procedure Setcd_tabela_preco(const Value: Integer);
    procedure Setdt_atz(const Value: TDateTime);
    procedure Seticms_pc_aliq(const Value: Currency);
    procedure Seticms_valor(const Value: Currency);
    procedure Seticms_vl_base(const Value: Currency);
    procedure Setid_geral(const Value: Int64);
    procedure Setid_item(const Value: Integer);
    procedure Setid_pedido_venda(const Value: Int64);
    procedure Setipi_pc_aliq(const Value: Currency);
    procedure Setipi_valor(const Value: Currency);
    procedure Setipi_vl_base(const Value: Currency);
    procedure Setpis_cofins_pc_aliq(const Value: Currency);
    procedure Setpis_cofins_valor(const Value: Currency);
    procedure Setpis_cofins_vl_base(const Value: Currency);
    procedure Setqtd_venda(const Value: Integer);
    procedure Setseq_item(const Value: Integer);
    procedure Setun_medida(const Value: String);
    procedure Setvl_desconto(const Value: Currency);
    procedure Setvl_total_item(const Value: Currency);
    procedure Setvl_unitario(const Value: Currency);
  public 
   //Metodo Pesquisar pela chave primaria
    function Pesquisar(id_geral: Int64): Boolean; 
    procedure Inserir;
    procedure Atualizar;
    procedure Excluir;
    procedure Persistir(Novo: Boolean);

    property cd_tabela_preco: Integer read Fcd_tabela_preco write Setcd_tabela_preco;
    property dt_atz: TDateTime read Fdt_atz write Setdt_atz;
    property icms_pc_aliq: Currency read Ficms_pc_aliq write Seticms_pc_aliq;
    property icms_valor: Currency read Ficms_valor write Seticms_valor;
    property icms_vl_base: Currency read Ficms_vl_base write Seticms_vl_base;
    property id_geral: Int64 read Fid_geral write Setid_geral;
    property id_item: Integer read Fid_item write Setid_item;
    property id_pedido_venda: Int64 read Fid_pedido_venda write Setid_pedido_venda;
    property ipi_pc_aliq: Currency read Fipi_pc_aliq write Setipi_pc_aliq;
    property ipi_valor: Currency read Fipi_valor write Setipi_valor;
    property ipi_vl_base: Currency read Fipi_vl_base write Setipi_vl_base;
    property pis_cofins_pc_aliq: Currency read Fpis_cofins_pc_aliq write Setpis_cofins_pc_aliq;
    property pis_cofins_valor: Currency read Fpis_cofins_valor write Setpis_cofins_valor;
    property pis_cofins_vl_base: Currency read Fpis_cofins_vl_base write Setpis_cofins_vl_base;
    property qtd_venda: Integer read Fqtd_venda write Setqtd_venda;
    property seq_item: Integer read Fseq_item write Setseq_item;
    property un_medida: String read Fun_medida write Setun_medida;
    property vl_desconto: Currency read Fvl_desconto write Setvl_desconto;
    property vl_total_item: Currency read Fvl_total_item write Setvl_total_item;
    property vl_unitario: Currency read Fvl_unitario write Setvl_unitario;

end;

implementation

uses
    uDataModule, System.SysUtils, Vcl.Dialogs;

{ TPedido_venda_item }

procedure TPedido_venda_item.Inserir;
const
   SQL = 
   'INSERT INTO ' +
   'pedido_venda_item(' +
   'cd_tabela_preco, ' +
   'dt_atz, ' +
   'icms_pc_aliq, ' +
   'icms_valor, ' +
   'icms_vl_base, ' +
   'id_geral, ' +
   'id_item, ' +
   'id_pedido_venda, ' +
   'ipi_pc_aliq, ' +
   'ipi_valor, ' +
   'ipi_vl_base, ' +
   'pis_cofins_pc_aliq, ' +
   'pis_cofins_valor, ' +
   'pis_cofins_vl_base, ' +
   'qtd_venda, ' +
   'seq_item, ' +
   'un_medida, ' +
   'vl_desconto, ' +
   'vl_total_item, ' +
   'vl_unitario)' +
   'VALUES (' +
   ':cd_tabela_preco, ' +
   ':dt_atz, ' +
   ':icms_pc_aliq, ' +
   ':icms_valor, ' +
   ':icms_vl_base, ' +
   ':id_geral, ' +
   ':id_item, ' +
   ':id_pedido_venda, ' +
   ':ipi_pc_aliq, ' +
   ':ipi_valor, ' +
   ':ipi_vl_base, ' +
   ':pis_cofins_pc_aliq, ' +
   ':pis_cofins_valor, ' +
   ':pis_cofins_vl_base, ' +
   ':qtd_venda, ' +
   ':seq_item, ' +
   ':un_medida, ' +
   ':vl_desconto, ' +
   ':vl_total_item, ' +
   ':vl_unitario)';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('cd_tabela_preco').AsInteger := Fcd_tabela_preco;
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('icms_pc_aliq').AsCurrency := Ficms_pc_aliq;
      query.ParamByName('icms_valor').AsCurrency := Ficms_valor;
      query.ParamByName('icms_vl_base').AsCurrency := Ficms_vl_base;
      query.ParamByName('id_geral').AsLargeInt := Fid_geral;
      query.ParamByName('id_item').AsInteger := Fid_item;
      query.ParamByName('id_pedido_venda').AsLargeInt := Fid_pedido_venda;
      query.ParamByName('ipi_pc_aliq').AsCurrency := Fipi_pc_aliq;
      query.ParamByName('ipi_valor').AsCurrency := Fipi_valor;
      query.ParamByName('ipi_vl_base').AsCurrency := Fipi_vl_base;
      query.ParamByName('pis_cofins_pc_aliq').AsCurrency := Fpis_cofins_pc_aliq;
      query.ParamByName('pis_cofins_valor').AsCurrency := Fpis_cofins_valor;
      query.ParamByName('pis_cofins_vl_base').AsCurrency := Fpis_cofins_vl_base;
      query.ParamByName('qtd_venda').AsInteger := Fqtd_venda;
      query.ParamByName('seq_item').AsInteger := Fseq_item;
      query.ParamByName('un_medida').AsString := Fun_medida;
      query.ParamByName('vl_desconto').AsCurrency := Fvl_desconto;
      query.ParamByName('vl_total_item').AsCurrency := Fvl_total_item;
      query.ParamByName('vl_unitario').AsCurrency := Fvl_unitario;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela pedido_venda_item' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TPedido_venda_item.Atualizar;
const
   SQL = 
   'UPDATE ' +
   'pedido_venda_item ' +
'SET ' +
   'cd_tabela_preco = :cd_tabela_preco, ' +
   'dt_atz = :dt_atz, ' +
   'icms_pc_aliq = :icms_pc_aliq, ' +
   'icms_valor = :icms_valor, ' +
   'icms_vl_base = :icms_vl_base, ' +
   'id_geral = :id_geral, ' +
   'id_item = :id_item, ' +
   'id_pedido_venda = :id_pedido_venda, ' +
   'ipi_pc_aliq = :ipi_pc_aliq, ' +
   'ipi_valor = :ipi_valor, ' +
   'ipi_vl_base = :ipi_vl_base, ' +
   'pis_cofins_pc_aliq = :pis_cofins_pc_aliq, ' +
   'pis_cofins_valor = :pis_cofins_valor, ' +
   'pis_cofins_vl_base = :pis_cofins_vl_base, ' +
   'qtd_venda = :qtd_venda, ' +
   'seq_item = :seq_item, ' +
   'un_medida = :un_medida, ' +
   'vl_desconto = :vl_desconto, ' +
   'vl_total_item = :vl_total_item, ' +
   'vl_unitario = :vl_unitario ' +
'WHERE ' +
'id_geral = :id_geral';

var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('cd_tabela_preco').AsInteger := Fcd_tabela_preco;
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('icms_pc_aliq').AsCurrency := Ficms_pc_aliq;
      query.ParamByName('icms_valor').AsCurrency := Ficms_valor;
      query.ParamByName('icms_vl_base').AsCurrency := Ficms_vl_base;
      query.ParamByName('id_geral').AsLargeInt := Fid_geral;
      query.ParamByName('id_item').AsInteger := Fid_item;
      query.ParamByName('id_pedido_venda').AsLargeInt := Fid_pedido_venda;
      query.ParamByName('ipi_pc_aliq').AsCurrency := Fipi_pc_aliq;
      query.ParamByName('ipi_valor').AsCurrency := Fipi_valor;
      query.ParamByName('ipi_vl_base').AsCurrency := Fipi_vl_base;
      query.ParamByName('pis_cofins_pc_aliq').AsCurrency := Fpis_cofins_pc_aliq;
      query.ParamByName('pis_cofins_valor').AsCurrency := Fpis_cofins_valor;
      query.ParamByName('pis_cofins_vl_base').AsCurrency := Fpis_cofins_vl_base;
      query.ParamByName('qtd_venda').AsInteger := Fqtd_venda;
      query.ParamByName('seq_item').AsInteger := Fseq_item;
      query.ParamByName('un_medida').AsString := Fun_medida;
      query.ParamByName('vl_desconto').AsCurrency := Fvl_desconto;
      query.ParamByName('vl_total_item').AsCurrency := Fvl_total_item;
      query.ParamByName('vl_unitario').AsCurrency := Fvl_unitario;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela pedido_venda_item' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

function TPedido_venda_item.Pesquisar(id_geral: Int64): Boolean;
const
    SQL = 
   'SELECT * ' +
   ' FROM ' +
   'pedido_venda_item' +
   ' WHERE ' +
   'id_geral = :id_geral';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [id_geral]);

    Result := query.IsEmpty;
  finally
    query.Free;
  end;
end;

procedure TPedido_venda_item.Persistir(Novo: Boolean);
begin
  if Novo then
    Inserir
  else 
    Atualizar;
end;

procedure TPedido_venda_item.Excluir;
const
   SQL = 
   'DELETE ' +
   ' FROM ' +
   'pedido_venda_item' +
   ' WHERE ' +
   'id_geral = :id_geral';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('id_geral').AsLargeInt := Fid_geral;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao excluir os dados na tabela pedido_venda_item' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TPedido_venda_item.Setcd_tabela_preco(const Value: Integer);
begin
  Fcd_tabela_preco := Value;
end;

procedure TPedido_venda_item.Setdt_atz(const Value: TDateTime);
begin
  Fdt_atz := Value;
end;

procedure TPedido_venda_item.Seticms_pc_aliq(const Value: Currency);
begin
  Ficms_pc_aliq := Value;
end;

procedure TPedido_venda_item.Seticms_valor(const Value: Currency);
begin
  Ficms_valor := Value;
end;

procedure TPedido_venda_item.Seticms_vl_base(const Value: Currency);
begin
  Ficms_vl_base := Value;
end;

procedure TPedido_venda_item.Setid_geral(const Value: Int64);
begin
  Fid_geral := Value;
end;

procedure TPedido_venda_item.Setid_item(const Value: Integer);
begin
  Fid_item := Value;
end;

procedure TPedido_venda_item.Setid_pedido_venda(const Value: Int64);
begin
  Fid_pedido_venda := Value;
end;

procedure TPedido_venda_item.Setipi_pc_aliq(const Value: Currency);
begin
  Fipi_pc_aliq := Value;
end;

procedure TPedido_venda_item.Setipi_valor(const Value: Currency);
begin
  Fipi_valor := Value;
end;

procedure TPedido_venda_item.Setipi_vl_base(const Value: Currency);
begin
  Fipi_vl_base := Value;
end;

procedure TPedido_venda_item.Setpis_cofins_pc_aliq(const Value: Currency);
begin
  Fpis_cofins_pc_aliq := Value;
end;

procedure TPedido_venda_item.Setpis_cofins_valor(const Value: Currency);
begin
  Fpis_cofins_valor := Value;
end;

procedure TPedido_venda_item.Setpis_cofins_vl_base(const Value: Currency);
begin
  Fpis_cofins_vl_base := Value;
end;

procedure TPedido_venda_item.Setqtd_venda(const Value: Integer);
begin
  Fqtd_venda := Value;
end;

procedure TPedido_venda_item.Setseq_item(const Value: Integer);
begin
  Fseq_item := Value;
end;

procedure TPedido_venda_item.Setun_medida(const Value: String);
begin
  Fun_medida := Value;
end;

procedure TPedido_venda_item.Setvl_desconto(const Value: Currency);
begin
  Fvl_desconto := Value;
end;

procedure TPedido_venda_item.Setvl_total_item(const Value: Currency);
begin
  Fvl_total_item := Value;
end;

procedure TPedido_venda_item.Setvl_unitario(const Value: Currency);
begin
  Fvl_unitario := Value;
end;

end.