unit uGrupoTributacaoIPI;

interface


uses
  uGrupoTributacao, Data.DB, Firedac.Stan.Param;

type
  TGrupoTributacaoIPI = class (TGrupoTributacao)

    public
      procedure Inserir; override;
      procedure Atualizar; override;
      function Pesquisar(CodTributacao: Integer): Boolean; override;
  end;

implementation

uses
  FireDAC.Comp.Client, uDataModule;

{ TGrupoTributacaoIPI }

procedure TGrupoTributacaoIPI.Atualizar;
const
  SQL = ' update                           '+
        '  grupo_tributacao_ipi            '+
        ' set                              '+
        '  cd_tributacao = :cd_tributacao, '+
        '  nm_tributacao_ipi = :nm_tributacao_ipi, '+
        '  aliquota_ipi = :aliquota_ipi    '+
        'where                             '+
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
    query.ParamByName('nm_tributacao_ipi').AsString := NomeTributacao;
    query.ParamByName('aliquota_ipi').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

procedure TGrupoTributacaoIPI.Inserir;
const
  SQL = ' insert                               '+
        ' into                                 '+
        '  grupo_tributacao_ipi (cd_tributacao,'+
        '  nm_tributacao_ipi,                  '+
        '  aliquota_ipi)                       '+
        ' values (:cd_tributacao,              '+
        '  :nm_tributacao_ipi,                 '+
        '  :aliquota_ipi)';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.ParamByName('cd_tributacao').AsInteger := CodTributacao;
    query.ParamByName('nm_tributacao_ipi').AsString := NomeTributacao;
    query.ParamByName('aliquota_ipi').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

function TGrupoTributacaoIPI.Pesquisar(CodTributacao: Integer): Boolean;
const
  SQL = ' select                   '+
        '  cd_tributacao        '+
        ' from                     '+
        '  grupo_tributacao_ipi '+
        ' where                    '+
        '  cd_tributacao = :cd_tributacao';
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
