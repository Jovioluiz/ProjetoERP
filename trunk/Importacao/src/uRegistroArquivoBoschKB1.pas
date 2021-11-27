unit uRegistroArquivoBoschKB1;

interface

uses
  uRegistrosArquivoBosch;

type
  TRegistroArquivoBoschKB1 = class(TRegistrosArquivoBosch)

  public
    procedure GeraRegistroKB1VAR;

  end;

implementation

{ TRegistroArquivoBoschKB1 }

procedure TRegistroArquivoBoschKB1.GeraRegistroKB1VAR;
var
  I: integer;
begin
  inherited;
  for I := 0 to 10 do
  begin
    Registros[I].Tipo := 'KB1';
    Registros[I].CNPJOrigem := '465456465454';
  end;


end;

end.
