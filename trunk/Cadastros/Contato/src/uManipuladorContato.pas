unit uManipuladorContato;

interface

uses
  uContato, dtmContatos;

type
  tpDadosContato = record
      Codigo: Integer;
      Nome,
      Logradouro,
      Bairro,
      Cidade,
      NrDocumento,
      TipoPessoa: string;
  end;
type
  TManipuladorContato = class
  private
    FContato: TContato;
    FDados: TdmContatos;
    procedure SetContato(const Value: TContato);
    procedure SetDados(const Value: TdmContatos);
  public
    constructor Create(TipoContato: TContato); overload;
    constructor Create; overload;
    destructor Destroy; override;
    procedure SalvarContato;
    procedure ExcluirContato(CdContato: Integer);
    procedure ListarTodosContatos;
    function EditarContato(CodContato: Integer): tpDadosContato;

  property Contato: TContato read FContato write SetContato;
  property Dados: TdmContatos read FDados write SetDados;
end;

implementation

uses
  uclContato, FireDAC.Comp.Client, uUtil, uDataModule;

{ TManipuladorContato }

constructor TManipuladorContato.Create(TipoContato: TContato);
begin
  FContato := TipoContato;
end;

constructor TManipuladorContato.Create;
begin
  inherited;
  FDados := TdmContatos.Create(nil);
end;

destructor TManipuladorContato.Destroy;
begin
  FDados.Free;
  inherited;
end;

function TManipuladorContato.EditarContato(CodContato: Integer): tpDadosContato;
var
  persistencia: TContatos;
begin
  persistencia := TContatos.Create;

  try
    persistencia.Pesquisar(CodContato);
    Result.Codigo := persistencia.cd_contato;
    Result.Nome := persistencia.nm_contato;
    Result.Logradouro := persistencia.logradouro;
    Result.Bairro := persistencia.bairro;
    Result.Cidade := persistencia.cidade;
    Result.NrDocumento := persistencia.nr_documento;
    Result.TipoPessoa := persistencia.tp_pessoa;
  finally
    persistencia.Free;
  end;
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

procedure TManipuladorContato.ListarTodosContatos;
const
  SQL = ' SELECT ' +
        ' 	cd_contato, ' +
        ' 	tp_pessoa, ' +
        ' 	nm_contato, ' +
        ' 	logradouro, ' +
        ' 	bairro, ' +
        ' 	cidade, ' +
        ' 	nr_documento ' +
        ' FROM ' +
        ' 	contato ';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    FDados.cdsContatos.EmptyDataSet;
    query.Open(SQL);

    query.Loop(
      procedure
      begin
        FDados.cdsContatos.Append;
        FDados.cdsContatos.FieldByName('cd_contato').AsInteger := query.FieldByName('cd_contato').AsInteger;
        FDados.cdsContatos.FieldByName('tp_pessoa').AsString := query.FieldByName('tp_pessoa').AsString;
        FDados.cdsContatos.FieldByName('nm_contato').AsString := query.FieldByName('nm_contato').AsString;
        FDados.cdsContatos.FieldByName('logradouro').AsString := query.FieldByName('logradouro').AsString;
        FDados.cdsContatos.FieldByName('bairro').AsString := query.FieldByName('bairro').AsString;
        FDados.cdsContatos.FieldByName('cidade').AsString := query.FieldByName('cidade').AsString;
        FDados.cdsContatos.FieldByName('nr_documento').AsString := query.FieldByName('nr_documento').AsString;
        FDados.cdsContatos.Post;
      end
      );

  finally
    query.Free;
  end;
end;

procedure TManipuladorContato.SalvarContato;
var
  persistencia: TContatos;
  novo: Boolean;
begin
  persistencia := TContatos.Create;

  try
    novo := not persistencia.Pesquisar(FContato.Codigo);

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

procedure TManipuladorContato.SetDados(const Value: TdmContatos);
begin
  FDados := Value;
end;

end.
