unit uEstagiario;

interface

uses
  uFuncionario;

type
  TEstagiario = class(TInterfacedObject, IFuncionarioSalario)
  public
    function CalculaSalario: Currency;

  end;

implementation

{ TEstagiario }

function TEstagiario.CalculaSalario: Currency;
begin
  Result := 0;
end;

end.
