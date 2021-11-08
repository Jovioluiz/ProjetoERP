unit uConexao;

interface

uses
  FireDAC.Comp.Client;

type TConexao = class
  private
    Conexao: TFDConnection;
    Query: TFDQuery;
  public
    // construtor da classe
    constructor Create;

    //função que retorna a conexão com o banco de dados
    function GetConexao: TFDConnection;
    function TipoFQuery: TFDQuery;
end;

implementation

uses
  System.IniFiles, System.SysUtils, Vcl.Dialogs;

{ TConexao }

constructor TConexao.Create;
var
  conexaoIni: TIniFile;
begin
  conexaoIni := TIniFile.Create(GetCurrentDir + '\conexao\conexao.ini');
  Conexao := TFDConnection.Create(nil);

  Conexao.DriverName := 'PG';

  Conexao.Params.Values['Server'] := conexaoIni.ReadString('configuracoes', 'servidor', Conexao.Params.Values['Server']);
  Conexao.Params.Database := conexaoIni.ReadString('configuracoes', 'banco', Conexao.Params.Database);
  Conexao.Params.UserName := conexaoIni.ReadString('configuracoes', 'usuario', Conexao.Params.UserName);
  Conexao.Params.Password := conexaoIni.ReadString('configuracoes', 'senha', Conexao.Params.Password);
  Conexao.Params.Values['Port'] := conexaoIni.ReadString('configuracoes', 'porta', Conexao.Params.Values['Port']);

  try
    Conexao.Open();
  except
    on e:Exception do
    begin
      ShowMessage('Não foi possível efetuar a conexão. Erro: ' + e.Message);
      Conexao := nil;
    end;
  end;
end;

function TConexao.GetConexao: TFDConnection;
begin
  Result := Conexao;
end;

function TConexao.TipoFQuery: TFDQuery;
begin
  Result := Query.Create(nil);
end;

end.
