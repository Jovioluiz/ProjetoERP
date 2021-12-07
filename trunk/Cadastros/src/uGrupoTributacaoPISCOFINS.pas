unit uGrupoTributacaoPISCOFINS;

interface

uses
  uGrupoTributacao, Data.DB, Firedac.Stan.Param;

type
  TGrupoTributacaoPISCOFINS = class (TGrupoTributacao)

    public
      procedure Inserir; override;
      procedure Atualizar; override;
      function Pesquisar(CodTributacao: Integer): Boolean; override;
  end;

implementation

uses
  FireDAC.Comp.Client, uDataModule;

{ TGrupoTributacaoISS }

procedure TGrupoTributacaoPISCOFINS.Atualizar;
const
  SQL = ' update                                        '+
        '   grupo_tributacao_pis_cofins                 '+
        ' set                                           '+
        '   cd_tributacao = :cd_tributacao,             '+
        '   nm_tributacao_pis_cofins = :nm_tributacao_pis_cofins, '+
        '   aliquota_pis_cofins = :aliquota_pis_cofins  '+
        ' where                                         '+
        '   cd_tributacao = :cd_tributacao';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.ParamByName('cd_tributacao').AsInteger := CodTributacao;
    query.ParamByName('nm_tributacao_pis_cofins').AsString := NomeTributacao;
    query.ParamByName('aliquota_pis_cofins').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

procedure TGrupoTributacaoPISCOFINS.Inserir;
const
  SQL = ' insert                                     '+
        ' into                                       '+
        '   grupo_tributacao_pis_cofins (cd_tributacao,'+
        '   nm_tributacao_pis_cofins,                 '+
        '   aliquota_pis_cofins)                      '+
        ' values (:cd_tributacao,                     '+
        '   :nm_tributacao_pis_cofins,                '+
        '   :aliquota_pis_cofins)';
var
  query: TFDQuery;
begin
  inherited;
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.ParamByName('cd_tributacao').AsInteger := CodTributacao;
    query.ParamByName('nm_tributacao_pis_cofins').AsString := NomeTributacao;
    query.ParamByName('aliquota_pis_cofins').AsCurrency := Aliquota;
    query.ExecSQL;
  finally
    query.Free;
  end;
end;

function TGrupoTributacaoPISCOFINS.Pesquisar(CodTributacao: Integer): Boolean;
const
  SQL = 'select                         '+
        ' cd_tributacao                 '+
        'from                           '+
        ' grupo_tributacao_pis_cofins   '+
        'where                          '+
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
