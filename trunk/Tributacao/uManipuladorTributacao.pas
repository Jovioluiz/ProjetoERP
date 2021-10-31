unit uManipuladorTributacao;

interface

uses
  uTributacaoGenerica;

type
  TManipuladorTributacao = class
  private
    FFTributacao: ITributacaoGenerica;
    procedure SetFTributacao(const Value: ITributacaoGenerica);

    public
      constructor Create(Tributacao: ITributacaoGenerica);

      property FTributacao: ITributacaoGenerica read FFTributacao write SetFTributacao;
  end;

implementation

{ TManipuladorTributacao }

constructor TManipuladorTributacao.Create(Tributacao: ITributacaoGenerica);
begin
  FFTributacao := Tributacao;
end;

procedure TManipuladorTributacao.SetFTributacao(const Value: ITributacaoGenerica);
begin
  FFTributacao := Value;
end;

end.
