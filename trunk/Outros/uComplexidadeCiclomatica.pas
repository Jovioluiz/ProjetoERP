unit uComplexidadeCiclomatica;

interface

uses
  System.RegularExpressions;

type
  TComplexidadeCiclomatica = class
  private

  public
    function CalculateCyclomaticComplexity(const code: string): Integer;
  end;

implementation

function TComplexidadeCiclomatica.CalculateCyclomaticComplexity(const code: string): Integer;
var
  cc: Integer;
begin
  cc := 1;
  // Expressão regular para detectar instruções IF
  if TRegEx.IsMatch(code, '\bif\b.*\bthen\b', [roIgnoreCase, roMultiline]) then
    cc := cc + TRegEx.Matches(code, '\bthen\b').Count;
  // Expressão regular para detectar loops FOR ou WHILE
  if TRegEx.IsMatch(code, '\b(for|while)\b.*\bdo\b', [roIgnoreCase, roMultiline]) then
    cc := cc + TRegEx.Matches(code, '\bdo\b').Count;
  // Outras estruturas de controle de fluxo podem ser adicionadas aqui
  Result := cc;
end;

end.
