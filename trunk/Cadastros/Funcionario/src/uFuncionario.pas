unit uFuncionario;

interface

type
  IFuncionarioSalario = interface
  ['{0EBE6CF6-72A6-4998-9ABC-F2A5D484C75B}']
    function CalculaSalario: Currency;
  end;

type
  IFuncionarioDecimoTerceiro = interface
  ['{930E559C-70EB-4B50-A594-905AF597BC12}']
    function CalculaDecimoTerceiro: currency;
  end;

implementation

end.
