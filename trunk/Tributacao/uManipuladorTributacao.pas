unit uManipuladorTributacao;

interface

uses
  uTributacaoGenerica;

type
  TManipuladorTributacao = class
  private
    FTributacao: ITributacaoGenerica;
    procedure SetFTributacao(const Value: ITributacaoGenerica);

  public
    function CalculaImposto(ValorBase, Aliquota: Currency): Currency;
    constructor Create(Tributacao: ITributacaoGenerica);

    property Tributacao: ITributacaoGenerica read FTributacao write SetFTributacao;
  end;

implementation

{ TManipuladorTributacao }

constructor TManipuladorTributacao.Create(Tributacao: ITributacaoGenerica);
begin
  FTributacao := Tributacao;
end;

procedure TManipuladorTributacao.SetFTributacao(const Value: ITributacaoGenerica);
begin
  FTributacao := Value;
end;

function TManipuladorTributacao.CalculaImposto(ValorBase, Aliquota: Currency): Currency;
begin
  Result := FTributacao.CalculaImposto(ValorBase, Aliquota);
end;

end.
