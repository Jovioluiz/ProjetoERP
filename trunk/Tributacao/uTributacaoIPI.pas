unit uTributacaoIPI;

interface

uses
  uTributacaoGenerica;

type
  TTributacaoIPI = class(TInterfacedObject, ITributacaoGenerica)
    public
    procedure RecalculaTributacao;
    function CalculaImposto(ValorBase, Aliquota: Currency): Currency;


  end;

implementation

uses
  System.Math;

{ TTributacaoIPI }

function TTributacaoIPI.CalculaImposto(ValorBase, Aliquota: Currency): Currency;
begin
  if Aliquota = 0 then
    Exit(0);
  Result := RoundTo(ValorBase * (Aliquota / 100), -2)
end;

procedure TTributacaoIPI.RecalculaTributacao;
begin

end;

end.
