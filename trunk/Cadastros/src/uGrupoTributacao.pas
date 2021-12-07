unit uGrupoTributacao;

interface
  type
    TGrupoTributacao = class
  private
    FCodTributacao: Integer;
    FNomeTributacao: string;
    FAliquota: Currency;
    procedure SetAliquota(const Value: Currency);
    procedure SetCodTributacao(const Value: Integer);
    procedure SetNomeTributacao(const Value: string);

    public
      procedure Persistir(Novo: Boolean); virtual;
      procedure Inserir; virtual; abstract;
      procedure Atualizar; virtual; abstract;
      function Pesquisar(CodTributacao: Integer): Boolean; virtual; abstract;

      property CodTributacao: Integer read FCodTributacao write SetCodTributacao;
      property NomeTributacao: string read FNomeTributacao write SetNomeTributacao;
      property Aliquota: Currency read FAliquota write SetAliquota;

    end;

implementation

{ TGrupoTributacao }

procedure TGrupoTributacao.Persistir(Novo: Boolean);
begin
  if Novo then
    Inserir
  else
    Atualizar;
end;

procedure TGrupoTributacao.SetAliquota(const Value: Currency);
begin
  FAliquota := Value;
end;

procedure TGrupoTributacao.SetCodTributacao(const Value: Integer);
begin
  FCodTributacao := Value;
end;

procedure TGrupoTributacao.SetNomeTributacao(const Value: string);
begin
  FNomeTributacao := Value;
end;

end.
