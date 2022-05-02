unit uParametrosImpostos;

interface

type TParametros = record
  aliquota: Currency;
end;

TImposto = class
  public
end;

type TICMS = class(TImposto)
  parametros: TParametros;
  public
    function GetParametrosICMS(Id: Integer): TParametros;
end;

type TIPI = class(TImposto)
  parametros: TParametros;
  public
    function GetParametrosIPI(Id: Integer): TParametros;
end;

type
  TParametrosImpostos = class

    function GetAliquotas: TArray<TImposto>;

end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, Data.DB, Firedac.Stan.Param;

{ TICMS }

//tem que pegar todos os grupos de tributaçao e depois ir buscando as aliquotas
function TICMS.GetParametrosICMS(Id: Integer): TParametros;
const
  SQL = ' SELECT' +
        ' 	aliquota_icms' +
        ' FROM' +
        ' 	grupo_tributacao_icms ' +
        ' WHERE' +
        ' 	cd_tributacao = :cd_tributacao';
var
  consulta: TFDquery;
begin
  consulta := TFDquery.Create(nil);
  consulta.Connection := dm.conexaoBanco;
  try
    consulta.Open(SQL, [Id]);
    if not consulta.IsEmpty then
      Result.aliquota := consulta.ParamByName('aliquota_icms').AsCurrency;
  finally
    consulta.Free;
  end;
end;

{ TIPI }

function TIPI.GetParametrosIPI(Id: Integer): TParametros;
const
  SQL = ' SELECT' +
        ' 	aliquota_ipi' +
        ' FROM' +
        ' 	grupo_tributacao_ipi ' +
        ' WHERE' +
        ' 	cd_tributacao = :cd_tributacao';
var
  consulta: TFDquery;
begin
  consulta := TFDquery.Create(nil);
  consulta.Connection := dm.conexaoBanco;
  try
    consulta.Open(SQL, [Id]);
    if not consulta.IsEmpty then
      Result.aliquota := consulta.ParamByName('aliquota_icms').AsCurrency;
  finally
    consulta.Free;
  end;
end;

{ TParametrosImpostos }

function TParametrosImpostos.GetAliquotas: TArray<TImposto>;
begin

end;
end.
