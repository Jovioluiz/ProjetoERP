unit uManipuladorContato;

interface

uses
  uContato;
type
  TManipuladorContato = class
  private
    FContato: TContato;
    procedure SetContato(const Value: TContato);
  public
    constructor Create(TipoContato: TContato);
    procedure SalvarContato(Contato: TContato);

  property Contato: TContato read FContato write SetContato;
end;

implementation

uses
  uclContato;

{ TManipuladorContato }

constructor TManipuladorContato.Create(TipoContato: TContato);
begin
  FContato := TipoContato;
end;

procedure TManipuladorContato.SalvarContato(Contato: TContato);
var
  persistencia: TContatos;
  novo: Boolean;
begin
  persistencia := TContatos.Create;

  try
    novo := persistencia.Pesquisar(Contato.Codigo);

    persistencia.cd_contato := Contato.Codigo;
    persistencia.nm_contato := Contato.Nome;
    persistencia.tp_pessoa := Contato.TipoPessoa;
    persistencia.logradouro := Contato.Logradouro;
    persistencia.bairro := Contato.Bairro;
    persistencia.cidade := Contato.Cidade;
    persistencia.Persistir(novo);
  finally
    persistencia.Free;
  end;
end;

procedure TManipuladorContato.SetContato(const Value: TContato);
begin
  FContato := Value;
end;

end.
