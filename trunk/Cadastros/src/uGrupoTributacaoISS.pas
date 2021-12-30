unit uGrupoTributacaoISS;

interface

uses
  uGrupoTributacao, Data.DB, Firedac.Stan.Param;

type
  TGrupoTributacaoISS = class (TGrupoTributacao)

    public
      procedure Inserir; override;
      procedure Atualizar; override;
      function Pesquisar(CodTributacao: Integer): Boolean; override;
      function GetDadosTributacao(CodTributacao: Integer): TDadosTributacao; override;
  end;

implementation

uses
  FireDAC.Comp.Client, uDataModule;

{ TGrupoTributacaoISS }

procedure TGrupoTributacaoISS.Atualizar;
const
  SQL = ' update                 '+
        '  grupo_tributacao_iss  '+
        ' set                    '+
        '  cd_tributacao = :cd_tributacao, '+
        '  nm_tributacao_iss = :nm_tributacao_iss, '+
        '  aliquota_iss = :aliquota_iss    '+
        ' where                               '+
        '  cd_tributacao = :cd_tributacao';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.ParamByName('cd_tributacao').AsInteger := CodTributacao;
    query.ParamByName('nm_tributacao_iss').AsString := NomeTributacao;
    query.ParamByName('aliquota_iss').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

function TGrupoTributacaoISS.GetDadosTributacao(CodTributacao: Integer): TDadosTributacao;
const
  SQL = ' select ' +
        '     nm_tributacao_iss, ' +
        '     aliquota_iss ' +
        ' from             ' +
        '     grupo_tributacao_iss ' +
        ' where ' +
        ' cd_tributacao = :cd_tributacao';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    consulta.Open(SQL, [CodTributacao]);
    Result.DescTributacao := consulta.FieldByName('nm_tributacao_iss').AsString;
    Result.Aliquota := consulta.FieldByName('aliquota_iss').AsCurrency;
  finally
    consulta.Free;
  end;
end;

procedure TGrupoTributacaoISS.Inserir;
const
  SQL = ' insert                               '+
        ' into                                 '+
        '  grupo_tributacao_iss (cd_tributacao,'+
        '  nm_tributacao_iss,                  '+
        '  aliquota_iss)                       '+
        ' values (:cd_tributacao,              '+
        '  :nm_tributacao_iss,                 '+
        '  :aliquota_iss)';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.ParamByName('cd_tributacao').AsInteger := CodTributacao;
    query.ParamByName('nm_tributacao_iss').AsString := NomeTributacao;
    query.ParamByName('aliquota_iss').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

function TGrupoTributacaoISS.Pesquisar(CodTributacao: Integer): Boolean;
const
  SQL = 'select                  '+
        '  cd_tributacao         '+
        'from                    '+
        '  grupo_tributacao_iss  '+
        'where                   '+
        ' cd_tributacao = :cd_tributacao';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [CodTributacao]);
    Result := not query.IsEmpty;

  finally
    query.Free;
  end;
end;

end.
