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
    constructor Create(TipoContato: TContato); overload;
    constructor Create; overload;
    procedure SalvarContato;
    procedure ExcluirContato(CdContato: Integer);

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

constructor TManipuladorContato.Create;
begin
  inherited;
end;

procedure TManipuladorContato.ExcluirContato(CdContato: Integer);
var
  persistencia: TContatos;
begin
  persistencia := TContatos.Create;

  try
    if persistencia.Pesquisar(CdContato) then
    begin
      persistencia.cd_contato := CdContato;
      persistencia.Excluir;
    end;
  finally
    persistencia.Free;
  end;
end;

procedure TManipuladorContato.SalvarContato;
var
  persistencia: TContatos;
  novo: Boolean;
begin
  persistencia := TContatos.Create;

  try
    novo := persistencia.Pesquisar(FContato.Codigo);

    persistencia.cd_contato := FContato.Codigo;
    persistencia.nm_contato := FContato.Nome;
    persistencia.tp_pessoa := FContato.TipoPessoa;
    persistencia.logradouro := FContato.Logradouro;
    persistencia.bairro := FContato.Bairro;
    persistencia.cidade := FContato.Cidade;
    persistencia.nr_documento := FContato.NrDocumento;
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
