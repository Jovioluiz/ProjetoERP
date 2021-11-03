unit uContatoJuridica;

interface
uses
  uContato;

type
  TContatoJuridica = class(TContato)
  private
    FCNPJ: string;
    procedure SetCNPJ(const Value: string);
  public
    function TipoContato: String; override;
    function ValidaDocumento(Documento: string): Boolean; override;

    property CNPJ: string read FCNPJ write SetCNPJ;
end;

implementation

{ TConatoJuridica }

procedure TContatoJuridica.SetCNPJ(const Value: string);
begin
  FCNPJ := Value;
end;

function TContatoJuridica.TipoContato: String;
begin
  Result := 'J';
end;

function TContatoJuridica.ValidaDocumento(Documento: string): Boolean;
begin
  Result := (Documento <> '') or (Length(Documento) = 14);
end;

end.
