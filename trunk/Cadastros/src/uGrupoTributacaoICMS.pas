unit uGrupoTributacaoICMS;

interface

uses
  uGrupoTributacao, Data.DB, Firedac.Stan.Param;

type
  TGrupoTributacaoICMS = class (TGrupoTributacao)

    public
      procedure Inserir; override;
      procedure Atualizar; override;
      function Pesquisar(CodTributacao: Integer): Boolean; override;
  end;

implementation

uses
  FireDAC.Comp.Client, uDataModule;

{ TGrupoTributacaoICMS }


procedure TGrupoTributacaoICMS.Atualizar;
const
  SQL = ' update                           '+
        '  grupo_tributacao_icms           '+
        ' set                              '+
        '  cd_tributacao = :cd_tributacao, '+
        '  nm_tributacao_icms = :nm_tributacao_icms, '+
        '  aliquota_icms = :aliquota_icms  '+
        ' where                            '+
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
    query.ParamByName('nm_tributacao_icms').AsString := NomeTributacao;
    query.ParamByName('aliquota_icms').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

procedure TGrupoTributacaoICMS.Inserir;
const
  SQL = ' insert                               '+
        ' into                                 '+
        ' grupo_tributacao_icms (cd_tributacao,'+
        ' nm_tributacao_icms,                  '+
        ' aliquota_icms)                       '+
        ' values (:cd_tributacao,              '+
        ' :nm_tributacao_icms,                 '+
        ' :aliquota_icms)';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.ParamByName('cd_tributacao').AsInteger := CodTributacao;
    query.ParamByName('nm_tributacao_icms').AsString := NomeTributacao;
    query.ParamByName('aliquota_icms').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

function TGrupoTributacaoICMS.Pesquisar(CodTributacao: Integer): Boolean;
const
  SQL = 'select                             '+
        '    cd_tributacao                  '+
        'from                               '+
        '    grupo_tributacao_icms          '+
        'where                              '+
            'cd_tributacao = :cd_tributacao';
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
