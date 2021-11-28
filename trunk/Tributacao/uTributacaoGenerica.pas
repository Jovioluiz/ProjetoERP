unit uTributacaoGenerica;

interface

type
  ITributacaoGenerica = interface
  ['{4D7541DF-F5E4-404F-83A2-6928BCA5FAA1}']
    procedure RecalculaTributacao;
    function CalculaImposto(ValorBase, Aliquota: Currency): Currency;

  end;

implementation

end.
