unit uRegistrosArquivoBosch;

interface

uses
  System.Classes;

type
  TRegistros = record
    Tipo: string;
    CNPJOrigem: string;
    CNPJDestino: string;
    RazaoSocialDestino: string;
    NumeroNF: Integer;
    DataVenda: TDate;
    Prazo: Integer;
    CodigoProduto: string;
    QuantidadeTotal: Double;
    ValorTotal: Currency;
  end;

type
  TRegistrosArquivoBosch = class
  private
    FRegistros: TArray<TRegistros>;
    FArquivo: TStringList;
    procedure SetRegistros(const Value: TArray<TRegistros>);
    procedure SetArquivo(const Value: TStringList);
    procedure Salvar;
  public
    function GetCabecalho: string;
    procedure GeraRegistroKB1VAR;
    procedure GeraRegistroVDA;
    procedure GeraRegistroEST;

    property Registros: TArray<TRegistros> read FRegistros write SetRegistros;
    property Arquivo: TStringList read FArquivo write SetArquivo;
  end;

implementation


{ TRegistrosArquivoBosch }


procedure TRegistrosArquivoBosch.GeraRegistroEST;
var
  I: integer;
begin
  for I := 0 to 10 do
  begin
    Registros[I].Tipo := 'EST';
    Registros[I].CNPJOrigem := '0000000000000';
  end;

end;

procedure TRegistrosArquivoBosch.GeraRegistroKB1VAR;
var
  I: integer;
  campos: array[1..9] of string;
begin
  for I := 0 to 10 do
  begin
    Registros[I].Tipo := 'KB1 ou VAR';
    Registros[I].CNPJOrigem := '465456465454';
  end;
//  campos[0] := Registros[I].Tipo;
//  Arquivo.Add(campos);
end;

procedure TRegistrosArquivoBosch.GeraRegistroVDA;
var
  I: integer;
begin
  for I := 0 to 10 do
  begin
    Registros[I].Tipo := 'VDA';
    Registros[I].CNPJOrigem := '465456465454';
  end;

end;

function TRegistrosArquivoBosch.GetCabecalho: string;
begin
  Result := 'dados do cabeçalho';
end;

procedure TRegistrosArquivoBosch.Salvar;
begin
  GetCabecalho;
  GeraRegistroKB1VAR;
  GeraRegistroVDA;
  GeraRegistroEST;
  Arquivo.SaveToFile('caminhodestino');
end;

procedure TRegistrosArquivoBosch.SetArquivo(const Value: TStringList);
begin
  FArquivo := Value;
end;

procedure TRegistrosArquivoBosch.SetRegistros(const Value: TArray<TRegistros>);
begin
  FRegistros := Value;
end;

end.
