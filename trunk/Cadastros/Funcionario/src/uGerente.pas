unit uGerente;

interface

uses
  uFuncionario;

type
  TGerente = class(TInterfacedObject, IFuncionarioSalario, IFuncionarioDecimoTerceiro)
    public
      function CalculaSalario: Currency;
      function CalculaDecimoTerceiro: currency;
end;

implementation

{ TGerente }

function TGerente.CalculaDecimoTerceiro: currency;
begin
  Result := 0;
end;

function TGerente.CalculaSalario: Currency;
begin
  Result := 0;
end;

end.
