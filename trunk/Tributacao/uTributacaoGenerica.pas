unit uTributacaoGenerica;

interface

type
  ITributacaoGenerica = interface
    procedure RecalculaTributacao;
    function CalculaImposto(ValorBase, Aliquota: Currency): Currency;

  end;

implementation

end.
