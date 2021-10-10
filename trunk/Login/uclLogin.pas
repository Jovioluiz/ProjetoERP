unit uclLogin;

interface

type TDadosLogin = record
  idUsuario: Integer;
  usuario,
  senha: String
end;

type TLogin = class
  public
    function Login(Usuario: string): TDadosLogin;
    procedure VerificaSeUsuarioEstaCadastrado(Usuario: string);
end;

implementation

uses
  FireDAC.Comp.Client, uUtil, uDataModule, uCadastrarSenha, Vcl.Dialogs;

{ TLogin }

function TLogin.Login(Usuario: string): TDadosLogin;
const
  SQL_LOGIN = 'select '+
              '  id_usuario, '+
              '  login, '+
              '  senha '+
              'from '+
              '  login_usuario '+
              'where '+
              '  login = :login';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(SQL_LOGIN, [Usuario]);

    Result.idUsuario := qry.FieldByName('id_usuario').AsInteger;
    Result.usuario := qry.FieldByName('login').Text;
    Result.senha := qry.FieldByName('senha').Text;
  finally
    qry.Free;
  end;
end;

procedure TLogin.VerificaSeUsuarioEstaCadastrado(Usuario: string);
const
  SQL_LOGIN = 'select '+
              '  senha '+
              'from '+
              '  login_usuario '+
              'where '+
              '  login = :login';
var
  qry: TFDQuery;
  frmCadastraSenha: TfrmCadastraSenha;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  frmCadastraSenha := TfrmCadastraSenha.Create(nil);

  try
    if Usuario <> '' then
    begin
      qry.Open(SQL_LOGIN, [Usuario]);

      if qry.FieldByName('senha').Text = '' then
      begin
        ShowMessage('Usuário sem senha cadastrada');

        frmCadastraSenha.ShowModal;
      end;
    end;
  finally
    qry.Free;
    frmCadastraSenha.Free;
  end;
end;

end.
