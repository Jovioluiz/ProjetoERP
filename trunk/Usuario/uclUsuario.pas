unit uclUsuario;

interface

uses
  dUsuario, System.SysUtils;

type TUsuario = class
  private
    FDados: TdmUsuario;
    procedure SetDados(const Value: TdmUsuario);

  public
    procedure CarregaUsuario(IdUsuario: Integer);
    procedure Inserir;
    procedure Excluir;
    procedure Atualizar;
    function Pesquisar(IdUsuario: Integer): Boolean;

    property Dados: TdmUsuario read FDados write SetDados;
    constructor Create;
    destructor Destroy; override;
end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, Data.DB;

{ TUsuario }

constructor TUsuario.Create;
begin
  FDados := TdmUsuario.Create(nil);
end;

destructor TUsuario.Destroy;
begin
  FDados.Free;
  inherited;
end;

procedure TUsuario.Excluir;
const
  SQL = ' DELETE                  '+
        ' FROM                    '+
        '   login_usuario         '+
        ' WHERE                   '+
        '   id_usuario = :id_usuario';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;

  try
    try
      query.ParamByName('id_usuario').AsInteger := FDados.cdsUsuario.FieldByName('id_usuario').AsInteger;
      query.ExecSQL;
      query.Connection.Commit;
    except
      on e:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Ocorreu o seguinte erro ao excluir o usuário ' + e.Message);
      end;
    end;

  finally
    query.Free;
  end;
end;

procedure TUsuario.Inserir;
const
  SQL = ' insert '+
        '  into '+
        ' login_usuario ' +
        ' (id_usuario, '+
        '  login,      '+
        '  senha) '+
        ' values '+
        '  (:id_usuario, '+
        '  :login, '+
        '  :senha)';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;

  try
    try
      query.SQL.Add(SQL);
      query.ParamByName('id_usuario').AsInteger := FDados.cdsUsuario.FieldByName('id_usuario').AsInteger;
      query.ParamByName('login').AsString := FDados.cdsUsuario.FieldByName('login').AsString;
      query.ParamByName('senha').AsString := FDados.cdsUsuario.FieldByName('senha').AsString;
      query.ExecSQL;
      query.Connection.Commit;
    except
      on e:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Ocorreu o seguinte erro ao inserir o usuário ' + e.Message);
      end;
    end;
  finally
    query.Free;
  end;
end;

function TUsuario.Pesquisar(IdUsuario: Integer): Boolean;
const
  SQL =  ' select ' +
         '   login, ' +
         '   senha  ' +
         ' from login_usuario ' +
         ' where ' +
         ' id_usuario = :id_usuario';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL, [IdUsuario]);
    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

procedure TUsuario.Atualizar;
const
  SQL = 'UPDATE '+
        '   login_usuario SET '+
        '   login = :login, '+
        '   senha = :senha ' +
        'WHERE '+
        '   id_usuario = :id_usuario';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;

  try
    try
      query.SQL.Add(SQL);
      query.ParamByName('id_usuario').AsInteger := FDados.cdsUsuario.FieldByName('id_usuario').AsInteger;
      query.ParamByName('login').AsString := FDados.cdsUsuario.FieldByName('login').AsString;
      query.ParamByName('senha').AsString := FDados.cdsUsuario.FieldByName('senha').AsString;
      query.ExecSQL;
      query.Connection.Commit;
    except
      on e:exception do
      begin
        query.Connection.Rollback;
        raise Exception.Create('Ocorreu o seguinte erro ao atualizar o usuário ' + e.Message);
      end;
    end;
  finally
    query.Free;
  end;
end;

procedure TUsuario.CarregaUsuario(IdUsuario: Integer);
const
  SQL =  ' select ' +
         '   login, ' +
         '   senha  ' +
         ' from login_usuario ' +
         ' where ' +
         ' id_usuario = :id_usuario';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL, [IdUsuario]);

    if not FDados.cdsUsuario.Active then
      FDados.cdsUsuario.CreateDataSet;

    if not qry.IsEmpty then
    begin
      FDados.cdsUsuario.Append;
      FDados.cdsUsuario.FieldByName('login').AsString := qry.FieldByName('login').AsString;
      FDados.cdsUsuario.FieldByName('senha').AsString := qry.FieldByName('senha').AsString;
      FDados.cdsUsuario.Post;
    end;
  finally
    qry.Free;
  end;
end;

procedure TUsuario.SetDados(const Value: TdmUsuario);
begin
  FDados := Value;
end;

end.
