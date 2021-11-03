unit uContato;

interface

  type TContato = class
  private
    FLogradouro: string;
    FBairro: string;
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FTipoPessoa: string;
    procedure SetBairro(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetCodigo(const Value: Integer);
    procedure SetLogradouro(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetTipoPessoa(const Value: string);
  public
    function TipoContato: String; virtual; abstract;
    function ValidaDocumento(Documento: string): Boolean; virtual; abstract;

    property Codigo: Integer read FCodigo write SetCodigo;
    property Nome: string read FNome write SetNome;
    property Logradouro: string read FLogradouro write SetLogradouro;
    property Bairro: string read FBairro write SetBairro;
    property Cidade: string read FCidade write SetCidade;
    property TipoPessoa: string read FTipoPessoa write SetTipoPessoa;
  end;

implementation

{ TContato }

procedure TContato.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TContato.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TContato.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TContato.SetLogradouro(const Value: string);
begin
  FLogradouro := Value;
end;

procedure TContato.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TContato.SetTipoPessoa(const Value: string);
begin
  FTipoPessoa := Value;
end;

end.
