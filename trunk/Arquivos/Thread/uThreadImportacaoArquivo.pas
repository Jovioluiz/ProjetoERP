unit uThreadImportacaoArquivo;

interface

uses
  System.Classes, FireDAC.Comp.Client, Firedac.Stan.Param, System.SysUtils, Vcl.Dialogs;

type TThreadImportacaoArquivo = class(TThread)
  private
    procedure SalvarDados;
  public
    constructor Create;
    procedure Execute; override;

end;

implementation

uses
   uDataModule;

{ TThreadImportacaoArquivo }

constructor TThreadImportacaoArquivo.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
end;

procedure TThreadImportacaoArquivo.Execute;
begin
  inherited;
  SalvarDados;
end;

procedure TThreadImportacaoArquivo.SalvarDados;
const
  SQL = 'insert into teste (codigo, descricao) values (:codigo, :descricao)';
var
  query: TFDQuery;
  I: Integer;
  inicio: TDateTime;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;
  query.Connection.StartTransaction;

  try
    query.SQL.Add(SQL);
    inicio := Now;

    for I := 0 to 1000000 do
    begin
      query.ParamByName('codigo').AsInteger := I;
      query.ParamByName('descricao').AsString := 'Teste';
      query.ExecSQL;
    end;

    query.Connection.Commit;

    ShowMessage(FormatDateTime('hh:mm:ss:zzz', Now - inicio))
  finally
    query.Free;
  end;
end;

end.
