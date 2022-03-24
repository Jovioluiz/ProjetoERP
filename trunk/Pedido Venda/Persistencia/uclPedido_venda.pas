unit uclPedido_venda;

interface

uses
 FireDAC.Stan.Intf, FireDAC.Stan.Option, 
 FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Phys.Intf,   
 FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.DApt,  
 FireDAC.Comp.DataSet, Data.DB;

type TPedido_venda = class 

  private 
    Fcd_cliente: Integer;
    Fcd_cond_pag: Integer;
    Fcd_forma_pag: Integer;
    Fdt_atz: TDateTime;
    Fdt_emissao: TDate;
    Fdt_parcela: TDate;
    Ffl_cancelado: String;
    Ffl_orcamento: Boolean;
    Fid_geral: Int64;
    Fnr_pedido: Integer;
    Fparcela: Integer;
    Fvl_acrescimo: Currency;
    Fvl_desconto_pedido: Currency;
    Fvl_total: Currency;
    procedure Setcd_cliente(const Value: Integer);
    procedure Setcd_cond_pag(const Value: Integer);
    procedure Setcd_forma_pag(const Value: Integer);
    procedure Setdt_atz(const Value: TDateTime);
    procedure Setdt_emissao(const Value: TDate);
    procedure Setdt_parcela(const Value: TDate);
    procedure Setfl_cancelado(const Value: String);
    procedure Setfl_orcamento(const Value: Boolean);
    procedure Setid_geral(const Value: Int64);
    procedure Setnr_pedido(const Value: Integer);
    procedure Setparcela(const Value: Integer);
    procedure Setvl_acrescimo(const Value: Currency);
    procedure Setvl_desconto_pedido(const Value: Currency);
    procedure Setvl_total(const Value: Currency);
  public 
   //Metodo Pesquisar pela chave primaria
    function Pesquisar(id_geral: Int64): Boolean; 
    procedure Inserir;
    procedure Atualizar;
    procedure Excluir;
    procedure Persistir(Novo: Boolean);

    property cd_cliente: Integer read Fcd_cliente write Setcd_cliente;
    property cd_cond_pag: Integer read Fcd_cond_pag write Setcd_cond_pag;
    property cd_forma_pag: Integer read Fcd_forma_pag write Setcd_forma_pag;
    property dt_atz: TDateTime read Fdt_atz write Setdt_atz;
    property dt_emissao: TDate read Fdt_emissao write Setdt_emissao;
    property dt_parcela: TDate read Fdt_parcela write Setdt_parcela;
    property fl_cancelado: String read Ffl_cancelado write Setfl_cancelado;
    property fl_orcamento: Boolean read Ffl_orcamento write Setfl_orcamento;
    property id_geral: Int64 read Fid_geral write Setid_geral;
    property nr_pedido: Integer read Fnr_pedido write Setnr_pedido;
    property parcela: Integer read Fparcela write Setparcela;
    property vl_acrescimo: Currency read Fvl_acrescimo write Setvl_acrescimo;
    property vl_desconto_pedido: Currency read Fvl_desconto_pedido write Setvl_desconto_pedido;
    property vl_total: Currency read Fvl_total write Setvl_total;

end;

implementation

uses
    uDataModule, System.SysUtils, Vcl.Dialogs;

{ TPedido_venda }

procedure TPedido_venda.Inserir;
const
   SQL = 
   'INSERT INTO ' +
   'pedido_venda(' +
   'cd_cliente, ' +
   'cd_cond_pag, ' +
   'cd_forma_pag, ' +
   'dt_atz, ' +
   'dt_emissao, ' +
   'dt_parcela, ' +
   'fl_cancelado, ' +
   'fl_orcamento, ' +
   'id_geral, ' +
   'nr_pedido, ' +
   'parcela, ' +
   'vl_acrescimo, ' +
   'vl_desconto_pedido, ' +
   'vl_total)' +
   'VALUES (' +
   ':cd_cliente, ' +
   ':cd_cond_pag, ' +
   ':cd_forma_pag, ' +
   ':dt_atz, ' +
   ':dt_emissao, ' +
   ':dt_parcela, ' +
   ':fl_cancelado, ' +
   ':fl_orcamento, ' +
   ':id_geral, ' +
   ':nr_pedido, ' +
   ':parcela, ' +
   ':vl_acrescimo, ' +
   ':vl_desconto_pedido, ' +
   ':vl_total)';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('cd_cliente').AsInteger := Fcd_cliente;
      query.ParamByName('cd_cond_pag').AsInteger := Fcd_cond_pag;
      query.ParamByName('cd_forma_pag').AsInteger := Fcd_forma_pag;
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('dt_emissao').AsDate := Fdt_emissao;
      query.ParamByName('dt_parcela').AsDate := Fdt_parcela;
      query.ParamByName('fl_cancelado').AsString := Ffl_cancelado;
      query.ParamByName('fl_orcamento').AsBoolean := Ffl_orcamento;
      query.ParamByName('id_geral').AsLargeInt := Fid_geral;
      query.ParamByName('nr_pedido').AsInteger := Fnr_pedido;
      query.ParamByName('parcela').AsInteger := Fparcela;
      query.ParamByName('vl_acrescimo').AsCurrency := Fvl_acrescimo;
      query.ParamByName('vl_desconto_pedido').AsCurrency := Fvl_desconto_pedido;
      query.ParamByName('vl_total').AsCurrency := Fvl_total;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela pedido_venda' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TPedido_venda.Atualizar;
const
   SQL = 
   'UPDATE ' +
   'pedido_venda ' +
'SET ' +
   'cd_cliente = :cd_cliente, ' +
   'cd_cond_pag = :cd_cond_pag, ' +
   'cd_forma_pag = :cd_forma_pag, ' +
   'dt_atz = :dt_atz, ' +
   'dt_emissao = :dt_emissao, ' +
   'dt_parcela = :dt_parcela, ' +
   'fl_cancelado = :fl_cancelado, ' +
   'fl_orcamento = :fl_orcamento, ' +
   'id_geral = :id_geral, ' +
   'nr_pedido = :nr_pedido, ' +
   'parcela = :parcela, ' +
   'vl_acrescimo = :vl_acrescimo, ' +
   'vl_desconto_pedido = :vl_desconto_pedido, ' +
   'vl_total = :vl_total ' +
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
      query.ParamByName('cd_cliente').AsInteger := Fcd_cliente;
      query.ParamByName('cd_cond_pag').AsInteger := Fcd_cond_pag;
      query.ParamByName('cd_forma_pag').AsInteger := Fcd_forma_pag;
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('dt_emissao').AsDate := Fdt_emissao;
      query.ParamByName('dt_parcela').AsDate := Fdt_parcela;
      query.ParamByName('fl_cancelado').AsString := Ffl_cancelado;
      query.ParamByName('fl_orcamento').AsBoolean := Ffl_orcamento;
      query.ParamByName('id_geral').AsLargeInt := Fid_geral;
      query.ParamByName('nr_pedido').AsInteger := Fnr_pedido;
      query.ParamByName('parcela').AsInteger := Fparcela;
      query.ParamByName('vl_acrescimo').AsCurrency := Fvl_acrescimo;
      query.ParamByName('vl_desconto_pedido').AsCurrency := Fvl_desconto_pedido;
      query.ParamByName('vl_total').AsCurrency := Fvl_total;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela pedido_venda' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

function TPedido_venda.Pesquisar(id_geral: Int64): Boolean;
const
    SQL = 
   'SELECT * ' +
   ' FROM ' +
   'pedido_venda' +
   ' WHERE ' +
   'id_geral = :id_geral';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [id_geral]);

    Result := not query.IsEmpty;
  finally
    query.Free;
  end;
end;

procedure TPedido_venda.Persistir(Novo: Boolean);
begin
  if Novo then
    Inserir
  else 
    Atualizar;
end;

procedure TPedido_venda.Excluir;
const
   SQL = 
   'DELETE ' +
   ' FROM ' +
   'pedido_venda' +
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
        raise Exception.Create('Erro ao excluir os dados na tabela pedido_venda' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TPedido_venda.Setcd_cliente(const Value: Integer);
begin
  Fcd_cliente := Value;
end;

procedure TPedido_venda.Setcd_cond_pag(const Value: Integer);
begin
  Fcd_cond_pag := Value;
end;

procedure TPedido_venda.Setcd_forma_pag(const Value: Integer);
begin
  Fcd_forma_pag := Value;
end;

procedure TPedido_venda.Setdt_atz(const Value: TDateTime);
begin
  Fdt_atz := Value;
end;

procedure TPedido_venda.Setdt_emissao(const Value: TDate);
begin
  Fdt_emissao := Value;
end;

procedure TPedido_venda.Setdt_parcela(const Value: TDate);
begin
  Fdt_parcela := Value;
end;

procedure TPedido_venda.Setfl_cancelado(const Value: String);
begin
  Ffl_cancelado := Value;
end;

procedure TPedido_venda.Setfl_orcamento(const Value: Boolean);
begin
  Ffl_orcamento := Value;
end;

procedure TPedido_venda.Setid_geral(const Value: Int64);
begin
  Fid_geral := Value;
end;

procedure TPedido_venda.Setnr_pedido(const Value: Integer);
begin
  Fnr_pedido := Value;
end;

procedure TPedido_venda.Setparcela(const Value: Integer);
begin
  Fparcela := Value;
end;

procedure TPedido_venda.Setvl_acrescimo(const Value: Currency);
begin
  Fvl_acrescimo := Value;
end;

procedure TPedido_venda.Setvl_desconto_pedido(const Value: Currency);
begin
  Fvl_desconto_pedido := Value;
end;

procedure TPedido_venda.Setvl_total(const Value: Currency);
begin
  Fvl_total := Value;
end;

end.