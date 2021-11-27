unit uConexao;

interface

uses
  FireDAC.Comp.Client;

type TConexao = class
  private
    FConexao: TFDConnection;
    FQuery: TFDQuery;
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
  FConexao := TFDConnection.Create(nil);

  FConexao.DriverName := 'PG';

  FConexao.Params.Values['Server'] := conexaoIni.ReadString('configuracoes', 'servidor', FConexao.Params.Values['Server']);
  FConexao.Params.Database := conexaoIni.ReadString('configuracoes', 'banco', FConexao.Params.Database);
  FConexao.Params.UserName := conexaoIni.ReadString('configuracoes', 'usuario', FConexao.Params.UserName);
  FConexao.Params.Password := conexaoIni.ReadString('configuracoes', 'senha', FConexao.Params.Password);
  FConexao.Params.Values['Port'] := conexaoIni.ReadString('configuracoes', 'porta', FConexao.Params.Values['Port']);

  try
    FConexao.Open();
  except
    on e:Exception do
    begin
      ShowMessage('Não foi possível efetuar a conexão. Erro: ' + e.Message);
      FConexao := nil;
    end;
  end;
end;

function TConexao.GetConexao: TFDConnection;
begin
  Result := FConexao;
end;

function TConexao.TipoFQuery: TFDQuery;
begin
  Result := FQuery.Create(nil);
end;

end.
