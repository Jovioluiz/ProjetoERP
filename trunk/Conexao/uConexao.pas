unit uConexao;

interface

uses
  FireDAC.Comp.Client, System.Classes;

type TConexao = class(TFDQuery)
  private
    FConexao: TFDConnection;
    FQuery: TFDQuery;
  public

    //função que retorna a conexão com o banco de dados
    function GetConexao: TFDConnection;
    function TipoFQuery: TFDQuery;

    // construtor da classe
    constructor Create(Owner: TComponent); overload; override;
    destructor Destroy; override;
    property Conexao: TFDConnection read GetConexao write FConexao;
end;

implementation

uses
  System.IniFiles, System.SysUtils, Vcl.Dialogs;

{ TConexao }


constructor TConexao.Create(Owner: TComponent);
var
  conexaoIni: TIniFile;
begin
  inherited Create(Owner);

  conexaoIni := TIniFile.Create(GetCurrentDir + '\conexao\conexao.ini');
  FConexao := TFDConnection.Create(nil);
  try
    FConexao.DriverName := 'PG';

    FConexao.Params.Values['Server'] := conexaoIni.ReadString('configuracoes', 'servidor', FConexao.Params.Values['Server']);
    FConexao.Params.Database := conexaoIni.ReadString('configuracoes', 'banco', FConexao.Params.Database);
    FConexao.Params.UserName := conexaoIni.ReadString('configuracoes', 'usuario', FConexao.Params.UserName);
    FConexao.Params.Password := conexaoIni.ReadString('configuracoes', 'senha', FConexao.Params.Password);
    FConexao.Params.Values['Port'] := conexaoIni.ReadString('configuracoes', 'porta', FConexao.Params.Values['Port']);

    try
      FConexao.Open();
      FConexao.StartTransaction;
    except
      on e:Exception do
      begin
        ShowMessage('Não foi possível efetuar a conexão. Erro: ' + e.Message);
        FConexao := nil;
      end;
    end;
  finally
    conexaoIni.Free;
  end;
end;

destructor TConexao.Destroy;
begin
  FConexao.Free;
  inherited;
end;

function TConexao.GetConexao: TFDConnection;
begin
  Result := FConexao;
end;

function TConexao.TipoFQuery: TFDQuery;
begin
  Result := FQuery.Create(nil);
  Result.Connection := FConexao;
end;

end.
