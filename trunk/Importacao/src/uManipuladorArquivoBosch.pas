unit uManipuladorArquivoBosch;

interface

uses
  uRegistrosArquivoBosch;

type
  TManipuladorArquivoBosch = class
  private
    FRegistroArquivoBosch: TRegistrosArquivoBosch;
    procedure SetRegistroArquivoBosch(const Value: TRegistrosArquivoBosch);

  public
    procedure GravaArquivo;
    constructor Create;
    destructor Destroy; override;

    property RegistroArquivoBosch: TRegistrosArquivoBosch read FRegistroArquivoBosch write SetRegistroArquivoBosch;
  end;

implementation

{ TManipuladorArquivoBosch }

constructor TManipuladorArquivoBosch.Create;
begin
  FRegistroArquivoBosch := TRegistrosArquivoBosch.Create;
end;

destructor TManipuladorArquivoBosch.Destroy;
begin
  FRegistroArquivoBosch.Free;
  inherited;
end;

procedure TManipuladorArquivoBosch.GravaArquivo;
begin
//  FRegistroArquivoBosch.Arquivo.Add(FRegistroArquivoBosch.GetCabecalho);
end;

procedure TManipuladorArquivoBosch.SetRegistroArquivoBosch(const Value: TRegistrosArquivoBosch);
begin
  FRegistroArquivoBosch := Value;
end;

end.
