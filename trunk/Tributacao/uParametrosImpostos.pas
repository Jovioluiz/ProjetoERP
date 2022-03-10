unit uParametrosImpostos;

interface

type TParametros = record
  aliquota: Currency;
end;

type TICMS = class
  parametros: TParametros;
  public
    function GetParametros(Id: Integer): TParametros;
end;

type
  TParametrosImpostos = class

  end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, Data.DB, Firedac.Stan.Param;

{ TICMS }

//tem que pegar todos os grupos de tributaçao e depois ir buscando as aliquotas
function TICMS.GetParametros(Id: Integer): TParametros;
const
  SQL = ' SELECT' +
        ' 	aliquota_icms' +
        ' FROM' +
        ' 	grupo_tributacao_icms gti' +
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

end.
