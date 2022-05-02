unit uclNFI;

interface

uses
 FireDAC.Stan.Intf, FireDAC.Stan.Option, 
 FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Phys.Intf,   
 FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.DApt,  
 FireDAC.Comp.DataSet, Data.DB;

type TNFI = class 

  private 
    Fdt_atz: TDateTime;
    Ficms_pc_aliq: Double;
    Ficms_valor: Currency;
    Ficms_vl_base: Currency;
    Fid_geral: Integer;
    Fid_item: Integer;
    Fid_nfc: Integer;
    Fipi_pc_aliq: Double;
    Fipi_valor: Currency;
    Fipi_vl_base: Currency;
    Fiss_pc_aliq: Double;
    Fiss_valor: Currency;
    Fiss_vl_base: Currency;
    Fpis_cofins_pc_aliq: Double;
    Fpis_cofins_valor: Currency;
    Fpis_cofins_vl_base: Currency;
    Fqtd_estoque: Currency;
    Fseq_item_nfi: Integer;
    Fun_medida: String;
    Fvalor_total: Currency;
    Fvl_acrescimo_rateado: Currency;
    Fvl_desconto_rateado: Currency;
    Fvl_frete_rateado: Currency;
    Fvl_unitario: Currency;
    procedure Setdt_atz(const Value: TDateTime);
    procedure Seticms_pc_aliq(const Value: Double);
    procedure Seticms_valor(const Value: Currency);
    procedure Seticms_vl_base(const Value: Currency);
    procedure Setid_geral(const Value: Integer);
    procedure Setid_item(const Value: Integer);
    procedure Setid_nfc(const Value: Integer);
    procedure Setipi_pc_aliq(const Value: Double);
    procedure Setipi_valor(const Value: Currency);
    procedure Setipi_vl_base(const Value: Currency);
    procedure Setiss_pc_aliq(const Value: Double);
    procedure Setiss_valor(const Value: Currency);
    procedure Setiss_vl_base(const Value: Currency);
    procedure Setpis_cofins_pc_aliq(const Value: Double);
    procedure Setpis_cofins_valor(const Value: Currency);
    procedure Setpis_cofins_vl_base(const Value: Currency);
    procedure Setqtd_estoque(const Value: Currency);
    procedure Setseq_item_nfi(const Value: Integer);
    procedure Setun_medida(const Value: String);
    procedure Setvalor_total(const Value: Currency);
    procedure Setvl_acrescimo_rateado(const Value: Currency);
    procedure Setvl_desconto_rateado(const Value: Currency);
    procedure Setvl_frete_rateado(const Value: Currency);
    procedure Setvl_unitario(const Value: Currency);
    function GetIdGeral: Int64;
  public 
   //Metodo Pesquisar pela chave primaria
    function Pesquisar(id_geral: Integer): Boolean; 
    procedure Inserir;
    procedure Atualizar;
    procedure Excluir;
    procedure Persistir(Novo: Boolean);

    property dt_atz: TDateTime read Fdt_atz write Setdt_atz;
    property icms_pc_aliq: Double read Ficms_pc_aliq write Seticms_pc_aliq;
    property icms_valor: Currency read Ficms_valor write Seticms_valor;
    property icms_vl_base: Currency read Ficms_vl_base write Seticms_vl_base;
    property id_geral: Integer read Fid_geral write Setid_geral;
    property id_item: Integer read Fid_item write Setid_item;
    property id_nfc: Integer read Fid_nfc write Setid_nfc;
    property ipi_pc_aliq: Double read Fipi_pc_aliq write Setipi_pc_aliq;
    property ipi_valor: Currency read Fipi_valor write Setipi_valor;
    property ipi_vl_base: Currency read Fipi_vl_base write Setipi_vl_base;
    property iss_pc_aliq: Double read Fiss_pc_aliq write Setiss_pc_aliq;
    property iss_valor: Currency read Fiss_valor write Setiss_valor;
    property iss_vl_base: Currency read Fiss_vl_base write Setiss_vl_base;
    property pis_cofins_pc_aliq: Double read Fpis_cofins_pc_aliq write Setpis_cofins_pc_aliq;
    property pis_cofins_valor: Currency read Fpis_cofins_valor write Setpis_cofins_valor;
    property pis_cofins_vl_base: Currency read Fpis_cofins_vl_base write Setpis_cofins_vl_base;
    property qtd_estoque: Currency read Fqtd_estoque write Setqtd_estoque;
    property seq_item_nfi: Integer read Fseq_item_nfi write Setseq_item_nfi;
    property un_medida: String read Fun_medida write Setun_medida;
    property valor_total: Currency read Fvalor_total write Setvalor_total;
    property vl_acrescimo_rateado: Currency read Fvl_acrescimo_rateado write Setvl_acrescimo_rateado;
    property vl_desconto_rateado: Currency read Fvl_desconto_rateado write Setvl_desconto_rateado;
    property vl_frete_rateado: Currency read Fvl_frete_rateado write Setvl_frete_rateado;
    property vl_unitario: Currency read Fvl_unitario write Setvl_unitario;

end;

implementation

uses
    uDataModule, System.SysUtils, Vcl.Dialogs;

{ TNFI }

function TNFI.GetIdGeral: Int64; 
const 
  SQL = 'select ' +           
        '* '+                  
        'from func_id_geral();' ;  
var                                    
  qry: TFDQuery;                       
begin                                  
  qry := TFDQuery.Create(nil);        
  qry.Connection := dm.conexaoBanco;  
                                     
  try                                
    qry.Open(SQL);                   
    Result := qry.FieldByName('func_id_geral').AsLargeInt; 
  finally          
    qry.Free;  
  end;         
end; 


procedure TNFI.Inserir;
const
   SQL = 
   'INSERT INTO ' +
   'nfi(' +
   'dt_atz, ' +
   'icms_pc_aliq, ' +
   'icms_valor, ' +
   'icms_vl_base, ' +
   'id_geral, ' +
   'id_item, ' +
   'id_nfc, ' +
   'ipi_pc_aliq, ' +
   'ipi_valor, ' +
   'ipi_vl_base, ' +
   'iss_pc_aliq, ' +
   'iss_valor, ' +
   'iss_vl_base, ' +
   'pis_cofins_pc_aliq, ' +
   'pis_cofins_valor, ' +
   'pis_cofins_vl_base, ' +
   'qtd_estoque, ' +
   'seq_item_nfi, ' +
   'un_medida, ' +
   'valor_total, ' +
   'vl_acrescimo_rateado, ' +
   'vl_desconto_rateado, ' +
   'vl_frete_rateado, ' +
   'vl_unitario)' +
   'VALUES (' +
   ':dt_atz, ' +
   ':icms_pc_aliq, ' +
   ':icms_valor, ' +
   ':icms_vl_base, ' +
   ':id_geral, ' +
   ':id_item, ' +
   ':id_nfc, ' +
   ':ipi_pc_aliq, ' +
   ':ipi_valor, ' +
   ':ipi_vl_base, ' +
   ':iss_pc_aliq, ' +
   ':iss_valor, ' +
   ':iss_vl_base, ' +
   ':pis_cofins_pc_aliq, ' +
   ':pis_cofins_valor, ' +
   ':pis_cofins_vl_base, ' +
   ':qtd_estoque, ' +
   ':seq_item_nfi, ' +
   ':un_medida, ' +
   ':valor_total, ' +
   ':vl_acrescimo_rateado, ' +
   ':vl_desconto_rateado, ' +
   ':vl_frete_rateado, ' +
   ':vl_unitario)';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
//  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('icms_pc_aliq').AsFloat := Ficms_pc_aliq;
      query.ParamByName('icms_valor').AsCurrency := Ficms_valor;
      query.ParamByName('icms_vl_base').AsCurrency := Ficms_vl_base;
      query.ParamByName('id_geral').AsInteger := Fid_geral;
      query.ParamByName('id_item').AsInteger := Fid_item;
      query.ParamByName('id_nfc').AsInteger := Fid_nfc;
      query.ParamByName('ipi_pc_aliq').AsFloat := Fipi_pc_aliq;
      query.ParamByName('ipi_valor').AsCurrency := Fipi_valor;
      query.ParamByName('ipi_vl_base').AsCurrency := Fipi_vl_base;
      query.ParamByName('iss_pc_aliq').AsFloat := Fiss_pc_aliq;
      query.ParamByName('iss_valor').AsCurrency := Fiss_valor;
      query.ParamByName('iss_vl_base').AsCurrency := Fiss_vl_base;
      query.ParamByName('pis_cofins_pc_aliq').AsFloat := Fpis_cofins_pc_aliq;
      query.ParamByName('pis_cofins_valor').AsCurrency := Fpis_cofins_valor;
      query.ParamByName('pis_cofins_vl_base').AsCurrency := Fpis_cofins_vl_base;
      query.ParamByName('qtd_estoque').AsCurrency := Fqtd_estoque;
      query.ParamByName('seq_item_nfi').AsInteger := Fseq_item_nfi;
      query.ParamByName('un_medida').AsString := Fun_medida;
      query.ParamByName('valor_total').AsCurrency := Fvalor_total;
      query.ParamByName('vl_acrescimo_rateado').AsCurrency := Fvl_acrescimo_rateado;
      query.ParamByName('vl_desconto_rateado').AsCurrency := Fvl_desconto_rateado;
      query.ParamByName('vl_frete_rateado').AsCurrency := Fvl_frete_rateado;
      query.ParamByName('vl_unitario').AsCurrency := Fvl_unitario;
      query.ExecSQL;
//      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela nfi' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TNFI.Atualizar;
const
   SQL = 
   'UPDATE ' +
   'nfi ' +
'SET ' +
   'dt_atz = :dt_atz, ' +
   'icms_pc_aliq = :icms_pc_aliq, ' +
   'icms_valor = :icms_valor, ' +
   'icms_vl_base = :icms_vl_base, ' +
   'id_geral = :id_geral, ' +
   'id_item = :id_item, ' +
   'id_nfc = :id_nfc, ' +
   'ipi_pc_aliq = :ipi_pc_aliq, ' +
   'ipi_valor = :ipi_valor, ' +
   'ipi_vl_base = :ipi_vl_base, ' +
   'iss_pc_aliq = :iss_pc_aliq, ' +
   'iss_valor = :iss_valor, ' +
   'iss_vl_base = :iss_vl_base, ' +
   'pis_cofins_pc_aliq = :pis_cofins_pc_aliq, ' +
   'pis_cofins_valor = :pis_cofins_valor, ' +
   'pis_cofins_vl_base = :pis_cofins_vl_base, ' +
   'qtd_estoque = :qtd_estoque, ' +
   'seq_item_nfi = :seq_item_nfi, ' +
   'un_medida = :un_medida, ' +
   'valor_total = :valor_total, ' +
   'vl_acrescimo_rateado = :vl_acrescimo_rateado, ' +
   'vl_desconto_rateado = :vl_desconto_rateado, ' +
   'vl_frete_rateado = :vl_frete_rateado, ' +
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
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('icms_pc_aliq').AsFloat := Ficms_pc_aliq;
      query.ParamByName('icms_valor').AsCurrency := Ficms_valor;
      query.ParamByName('icms_vl_base').AsCurrency := Ficms_vl_base;
      query.ParamByName('id_geral').AsInteger := Fid_geral;
      query.ParamByName('id_item').AsInteger := Fid_item;
      query.ParamByName('id_nfc').AsInteger := Fid_nfc;
      query.ParamByName('ipi_pc_aliq').AsFloat := Fipi_pc_aliq;
      query.ParamByName('ipi_valor').AsCurrency := Fipi_valor;
      query.ParamByName('ipi_vl_base').AsCurrency := Fipi_vl_base;
      query.ParamByName('iss_pc_aliq').AsFloat := Fiss_pc_aliq;
      query.ParamByName('iss_valor').AsCurrency := Fiss_valor;
      query.ParamByName('iss_vl_base').AsCurrency := Fiss_vl_base;
      query.ParamByName('pis_cofins_pc_aliq').AsFloat := Fpis_cofins_pc_aliq;
      query.ParamByName('pis_cofins_valor').AsCurrency := Fpis_cofins_valor;
      query.ParamByName('pis_cofins_vl_base').AsCurrency := Fpis_cofins_vl_base;
      query.ParamByName('qtd_estoque').AsCurrency := Fqtd_estoque;
      query.ParamByName('seq_item_nfi').AsInteger := Fseq_item_nfi;
      query.ParamByName('un_medida').AsString := Fun_medida;
      query.ParamByName('valor_total').AsCurrency := Fvalor_total;
      query.ParamByName('vl_acrescimo_rateado').AsCurrency := Fvl_acrescimo_rateado;
      query.ParamByName('vl_desconto_rateado').AsCurrency := Fvl_desconto_rateado;
      query.ParamByName('vl_frete_rateado').AsCurrency := Fvl_frete_rateado;
      query.ParamByName('vl_unitario').AsCurrency := Fvl_unitario;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela nfi' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

function TNFI.Pesquisar(id_geral: Integer): Boolean;
const
    SQL = 
   'SELECT * ' +
   ' FROM ' +
   'nfi' +
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

procedure TNFI.Persistir(Novo: Boolean);
begin
  if Novo then
  begin 
  if id_geral = 0 then
    id_geral := GetIdGeral;
   Inserir;
  end
  else 
    Atualizar;
end;

procedure TNFI.Excluir;
const
   SQL = 
   'DELETE ' +
   ' FROM ' +
   'nfi' +
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
      query.ParamByName('id_geral').AsInteger := Fid_geral;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao excluir os dados na tabela nfi' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TNFI.Setdt_atz(const Value: TDateTime);
begin
  Fdt_atz := Value;
end;

procedure TNFI.Seticms_pc_aliq(const Value: Double);
begin
  Ficms_pc_aliq := Value;
end;

procedure TNFI.Seticms_valor(const Value: Currency);
begin
  Ficms_valor := Value;
end;

procedure TNFI.Seticms_vl_base(const Value: Currency);
begin
  Ficms_vl_base := Value;
end;

procedure TNFI.Setid_geral(const Value: Integer);
begin
  Fid_geral := Value;
end;

procedure TNFI.Setid_item(const Value: Integer);
begin
  Fid_item := Value;
end;

procedure TNFI.Setid_nfc(const Value: Integer);
begin
  Fid_nfc := Value;
end;

procedure TNFI.Setipi_pc_aliq(const Value: Double);
begin
  Fipi_pc_aliq := Value;
end;

procedure TNFI.Setipi_valor(const Value: Currency);
begin
  Fipi_valor := Value;
end;

procedure TNFI.Setipi_vl_base(const Value: Currency);
begin
  Fipi_vl_base := Value;
end;

procedure TNFI.Setiss_pc_aliq(const Value: Double);
begin
  Fiss_pc_aliq := Value;
end;

procedure TNFI.Setiss_valor(const Value: Currency);
begin
  Fiss_valor := Value;
end;

procedure TNFI.Setiss_vl_base(const Value: Currency);
begin
  Fiss_vl_base := Value;
end;

procedure TNFI.Setpis_cofins_pc_aliq(const Value: Double);
begin
  Fpis_cofins_pc_aliq := Value;
end;

procedure TNFI.Setpis_cofins_valor(const Value: Currency);
begin
  Fpis_cofins_valor := Value;
end;

procedure TNFI.Setpis_cofins_vl_base(const Value: Currency);
begin
  Fpis_cofins_vl_base := Value;
end;

procedure TNFI.Setqtd_estoque(const Value: Currency);
begin
  Fqtd_estoque := Value;
end;

procedure TNFI.Setseq_item_nfi(const Value: Integer);
begin
  Fseq_item_nfi := Value;
end;

procedure TNFI.Setun_medida(const Value: String);
begin
  Fun_medida := Value;
end;

procedure TNFI.Setvalor_total(const Value: Currency);
begin
  Fvalor_total := Value;
end;

procedure TNFI.Setvl_acrescimo_rateado(const Value: Currency);
begin
  Fvl_acrescimo_rateado := Value;
end;

procedure TNFI.Setvl_desconto_rateado(const Value: Currency);
begin
  Fvl_desconto_rateado := Value;
end;

procedure TNFI.Setvl_frete_rateado(const Value: Currency);
begin
  Fvl_frete_rateado := Value;
end;

procedure TNFI.Setvl_unitario(const Value: Currency);
begin
  Fvl_unitario := Value;
end;

end.