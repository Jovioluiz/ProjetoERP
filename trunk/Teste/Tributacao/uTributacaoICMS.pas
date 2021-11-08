unit uTributacaoICMS;

interface

uses
  uTributacaoGenerica;

type
  TTributacaoICMS = class(TInterfacedObject, ITributacaoGenerica)

  public
    procedure RecalculaTributacao;
    function CalculaImposto(ValorBase, Aliquota: Currency): Currency;

  end;

implementation

uses
  System.Math;

{ TTributacaoICMS }

function TTributacaoICMS.CalculaImposto(ValorBase, Aliquota: Currency): Currency;
begin
  if Aliquota = 0 then
    Exit(0);
  Result := RoundTo(ValorBase * (Aliquota / 100), -2);
end;

procedure TTributacaoICMS.RecalculaTributacao;
begin
  inherited;

end;

end.
