unit uContatoFisica;

interface

uses
  uContato;
type
  TContatoFisica = class(TContato)
  private
    FCPF: string;
    procedure SetCPF(const Value: string);
  public
    function TipoContato: String; override;
    function ValidaDocumento(Documento: string): Boolean; override;

    property CPF: string read FCPF write SetCPF;
end;

implementation

{ TConatoFisica }

procedure TContatoFisica.SetCPF(const Value: string);
begin
  FCPF := Value;
end;

function TContatoFisica.TipoContato: String;
begin
  Result := 'F';
end;

function TContatoFisica.ValidaDocumento(Documento: string): Boolean;
begin
  Result := (Documento <> '') or (Length(Documento) = 11);
end;

end.
