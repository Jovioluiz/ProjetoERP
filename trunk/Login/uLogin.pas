unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Mask, Vcl.XPMan,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtUsuario: TEdit;
    edtSenha: TMaskEdit;
    btnEntrar: TButton;
    btnCancelar: TButton;
    Image1: TImage;
    lblInfo: TLabel;
    lblVersao: TLabel;
    btnConexao: TBitBtn;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edtUsuarioExit(Sender: TObject);
    procedure btnConexaoClick(Sender: TObject);
  private
    { Private declarations }
    procedure Entrar;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  idUsuario: Integer;

implementation

{$R *.dfm}

uses uTelaInicial, uDataModule, uVersao, uUtil, Vcl.Dialogs,
  uCadastrarSenha, fConexao, uclLogin;

procedure TfrmLogin.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogin.btnConexaoClick(Sender: TObject);
begin
  frmConexao := TfrmConexao.Create(Self);
  try
    frmConexao.ShowModal;
  finally
    frmConexao.Free;
  end;
end;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  Entrar;
end;

procedure TfrmLogin.edtUsuarioExit(Sender: TObject);
var
  login: TLogin;
begin
  if edtUsuario.Text = '' then
    Exit;

  login := TLogin.Create;

  try
    login.VerificaSeUsuarioEstaCadastrado(edtUsuario.Text);
  finally
    login.Free;
  end;
end;

procedure TfrmLogin.Entrar;
var
  dados: TDadosLogin;
  login: TLogin;
  verificaSenha: TUtil;
begin
  verificaSenha := TUtil.Create;
  login := TLogin.Create;

  try
    dados := login.Login(edtUsuario.Text);

    if (Trim(edtUsuario.Text) = EmptyStr) or (Trim(edtSenha.Text) = EmptyStr) then
    begin
      lblInfo.Font.Color := clRed;
      lblInfo.Caption := 'Usuário ou Senha Inválidos! Verifique!';
      edtUsuario.Clear;
      edtSenha.Clear;
      edtUsuario.SetFocus;
      Exit;
    end;

    if (Trim(edtUsuario.Text) = dados.usuario)
        and (Trim(dados.senha) = verificaSenha.GetSenhaMD5(edtSenha.Text)) then
      ModalResult := mrOk
    else
    begin
      lblInfo.Font.Color := clRed;
      lblInfo.Caption := 'Usuário ou Senha Inválidos! Verifique!';
      edtUsuario.Clear;
      edtSenha.Clear;
      edtUsuario.SetFocus;
      Exit;
    end;

    idUsuario := dados.idUsuario;
  finally
    login.Free;
    verificaSenha.Free;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
var
  versao: TVersao;
begin
  versao := TVersao.Create;

  try
    lblVersao.Caption := versao.GetBuildInfo(Application.ExeName);
  finally
    versao.Free;
  end;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0)
  end;
end;

end.
