unit uControleAcessoSistema;

interface

uses
  dControleAcesso, uUtil, FireDAC.Stan.Param, Data.DB;

type TControleAcessoSistema = class
  private
    FDados: TdmControleAcesso;
    procedure SetDados(const Value: TdmControleAcesso);


  public

  procedure Listar(CdUsuario: Integer);
  procedure Excluir(CdAcao, CdUsuario: Integer);
  procedure AddAcaoGrid(CodAcao, CdUsuario: Integer; NomeAcao: String; ehEdicao, PermiteEdicao: Boolean);
  constructor Create;
  destructor Destroy; override;
  property Dados: TdmControleAcesso read FDados write SetDados;

end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, System.SysUtils, Vcl.Dialogs, System.Math,
  System.Variants;

{ TControleAcessoSistema }

procedure TControleAcessoSistema.AddAcaoGrid(CodAcao, CdUsuario: Integer; NomeAcao: String; EhEdicao, PermiteEdicao: Boolean);
begin
  if Dados.cds.Locate('cd_acao', VarArrayOf([CodAcao]), [])
       and (not EhEdicao) then
      raise Exception.Create('Usu�rio j� possui a a��o cadastrada');

  if EhEdicao then
    Dados.cds.Edit
  else
  begin
    Dados.cds.Append;
    Dados.cds.FieldByName('cd_acao').AsInteger := CodAcao;
    Dados.cds.FieldByName('nm_acao').AsString := NomeAcao;
  end;

  Dados.cds.FieldByName('cd_usuario').AsInteger := CdUsuario;
  if PermiteEdicao then
    Dados.cds.FieldByName('fl_permite_edicao').AsString := 'S'
  else
    Dados.cds.FieldByName('fl_permite_edicao').AsString := 'N';

  Dados.cds.Post;
end;

constructor TControleAcessoSistema.Create;
begin
  FDados := TdmControleAcesso.Create(nil);
end;

destructor TControleAcessoSistema.Destroy;
begin
  FDados.Free;
  inherited;
end;

procedure TControleAcessoSistema.Excluir(CdAcao, CdUsuario: Integer);
const
  SQL_DELETE = 'delete '+
               '  from '+
               'usuario_acao '+
               '  where '+
               'cd_acao = :cd_acao and '+
               'cd_usuario = :cd_usuario';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    try
      qry.SQL.Add(SQL_DELETE);
      qry.ParamByName('cd_acao').AsInteger := CdAcao;
      qry.ParamByName('cd_usuario').AsInteger := CdUsuario;
      qry.ExecSQL;

    except
      on E: exception do
        raise Exception.Create('Erro ' + E.Message);
    end;
  finally
    qry.Free;
  end;
end;

procedure TControleAcessoSistema.Listar(CdUsuario: Integer);
const
    SQL =  'select '+
           '  ua.cd_usuario, '+
           '  acs.cd_acao, '+
           '  acs.nm_acao, '+
           '  fl_permite_edicao '+
           'from '+
           '  usuario_acao ua '+
           'join acoes_sistema acs on '+
           '  ua.cd_acao = acs.cd_acao '+
           'where cd_usuario = :cd_usuario'+
           '  order by ua.cd_acao ';
var
  qry: TFDQuery;
  book: TBookmark;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    Dados.cds.EmptyDataSet;
    qry.Open(SQL, [CdUsuario]);

    qry.loop(
    procedure
    begin
      if (FDados.cds.Active) and (FDados.cds.RecordCount = 1) then
        book := FDados.cds.GetBookmark;

      FDados.cds.Append;
      FDados.cds.FieldByName('cd_acao').AsInteger := qry.FieldByName('cd_acao').AsInteger;
      FDados.cds.FieldByName('cd_usuario').AsInteger := qry.FieldByName('cd_usuario').AsInteger;
      FDados.cds.FieldByName('nm_acao').AsString := qry.FieldByName('nm_acao').AsString;
      FDados.cds.FieldByName('fl_permite_edicao').AsString := qry.FieldByName('fl_permite_edicao').AsString;
      FDados.cds.Post;
    end
    );

  finally
    if FDados.cds.BookmarkValid(book) then
      FDados.cds.GotoBookmark(book);
    FDados.cds.FreeBookmark(book);
    qry.Free;
  end;
end;

procedure TControleAcessoSistema.SetDados(const Value: TdmControleAcesso);
begin
  FDados := Value;
end;

end.
