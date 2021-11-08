unit uclContato;

interface

uses
 FireDAC.Stan.Intf, FireDAC.Stan.Option, 
 FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.Phys.Intf,   
 FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.DApt,  
 FireDAC.Comp.DataSet, Data.DB;

type TContatos = class

  private 
    Fbairro: String;
    Fcd_contato: Integer;
    Fcidade: String;
    Fdt_atz: TDateTime;
    Flogradouro: String;
    Fnm_contato: String;
    Ftp_pessoa: String;
    Fnr_documento: string;
    procedure Setbairro(const Value: String);
    procedure Setcd_contato(const Value: Integer);
    procedure Setcidade(const Value: String);
    procedure Setdt_atz(const Value: TDateTime);
    procedure Setlogradouro(const Value: String);
    procedure Setnm_contato(const Value: String);
    procedure Settp_pessoa(const Value: String);
    procedure Setnr_documento(const Value: string);
  public 
   //Metodo Pesquisar pela chave primaria
    function Pesquisar(cd_contato: Integer): Boolean; 
    procedure Inserir;
    procedure Atualizar;
    procedure Excluir;
    procedure Persistir(Novo: Boolean);

    property bairro: String read Fbairro write Setbairro;
    property cd_contato: Integer read Fcd_contato write Setcd_contato;
    property cidade: String read Fcidade write Setcidade;
    property dt_atz: TDateTime read Fdt_atz write Setdt_atz;
    property logradouro: String read Flogradouro write Setlogradouro;
    property nm_contato: String read Fnm_contato write Setnm_contato;
    property tp_pessoa: String read Ftp_pessoa write Settp_pessoa;
    property nr_documento: string read Fnr_documento write Setnr_documento;

end;

implementation

uses
    uDataModule, System.SysUtils, Vcl.Dialogs;

{ TContato }

procedure TContatos.Inserir;
const
   SQL = 
   'INSERT INTO ' +
   'contato(' +
   'bairro, ' +
   'cd_contato, ' +
   'cidade, ' +
   'dt_atz, ' +
   'logradouro, ' +
   'nm_contato, ' +
   'tp_pessoa, '+
   'nr_documento)' +
   'VALUES (' +
   ':bairro, ' +
   ':cd_contato, ' +
   ':cidade, ' +
   ':dt_atz, ' +
   ':logradouro, ' +
   ':nm_contato, ' +
   ':tp_pessoa, ' +
   ':nr_documento)';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('bairro').AsString := Fbairro;
      query.ParamByName('cd_contato').AsInteger := Fcd_contato;
      query.ParamByName('cidade').AsString := Fcidade;
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('logradouro').AsString := Flogradouro;
      query.ParamByName('nm_contato').AsString := Fnm_contato;
      query.ParamByName('tp_pessoa').AsString := Ftp_pessoa;
      query.ParamByName('nr_documento').AsString := Fnr_documento;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela contato' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TContatos.Atualizar;
const
   SQL = 
   'UPDATE ' +
   'contato ' +
'SET ' +
   'bairro = :bairro,' +
   'cd_contato = :cd_contato,' +
   'cidade = :cidade,' +
   'dt_atz = :dt_atz,' +
   'logradouro = :logradouro,' +
   'nm_contato = :nm_contato,' +
   'tp_pessoa = :tp_pessoa, ' +
   'nr_documento = :nr_documento ' +
'WHERE ' +
'cd_contato = :cd_contato';

var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('bairro').AsString := Fbairro;
      query.ParamByName('cd_contato').AsInteger := Fcd_contato;
      query.ParamByName('cidade').AsString := Fcidade;
      query.ParamByName('dt_atz').AsDateTime := Fdt_atz;
      query.ParamByName('logradouro').AsString := Flogradouro;
      query.ParamByName('nm_contato').AsString := Fnm_contato;
      query.ParamByName('tp_pessoa').AsString := Ftp_pessoa;
      query.ParamByName('nr_documento').AsString := Fnr_documento;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os dados na tabela contato ' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TContatos.Persistir(Novo: Boolean);
begin
  if Novo then
    Inserir
  else
    Atualizar;
end;

function TContatos.Pesquisar(cd_contato: Integer): Boolean;
const
    SQL = 
   'SELECT * ' +
   ' FROM ' +
   'contato' +
   ' WHERE ' +
   'cd_contato = :cd_contato';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [cd_contato]);

    Result := not query.IsEmpty;
  finally
    query.Free;
  end;
end;

procedure TContatos.Excluir;
const
   SQL = 
   'DELETE ' +
   ' FROM ' +
   'contato' +
   ' WHERE ' +
   'cd_contato = :cd_contato';
var
  query: TFDquery;
begin
  query := TFDquery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;
  query.SQL.Add(SQL);
  try
    try
      query.ParamByName('cd_contato').AsInteger := Fcd_contato;
      query.ExecSQL;
      query.Connection.Commit;
    except
    on E:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Erro ao excluir os dados na tabela contato' +  E.Message);
      end;
    end;
  finally
    query.Connection.Rollback;
    query.Free;
  end;
end;

procedure TContatos.Setbairro(const Value: String);
begin
  Fbairro := Value;
end;

procedure TContatos.Setcd_contato(const Value: Integer);
begin
  Fcd_contato := Value;
end;

procedure TContatos.Setcidade(const Value: String);
begin
  Fcidade := Value;
end;

procedure TContatos.Setdt_atz(const Value: TDateTime);
begin
  Fdt_atz := Value;
end;

procedure TContatos.Setlogradouro(const Value: String);
begin
  Flogradouro := Value;
end;

procedure TContatos.Setnm_contato(const Value: String);
begin
  Fnm_contato := Value;
end;

procedure TContatos.Setnr_documento(const Value: string);
begin
  Fnr_documento := Value;
end;

procedure TContatos.Settp_pessoa(const Value: String);
begin
  Ftp_pessoa := Value;
end;

end.