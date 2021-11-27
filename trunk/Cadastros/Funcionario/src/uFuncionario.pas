unit uFuncionario;

interface

type
  IFuncionarioSalario = interface
    function CalculaSalario: Currency;
  end;

type
  IFuncionarioDecimoTerceiro = interface
    function CalculaDecimoTerceiro: currency;
  end;

implementation

end.
