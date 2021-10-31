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

{ TTributacaoICMS }

function TTributacaoICMS.CalculaImposto(ValorBase, Aliquota: Currency): Currency;
begin
  Result := (ValorBase * Aliquota) / 100;
end;

procedure TTributacaoICMS.RecalculaTributacao;
begin
  inherited;

end;

end.
