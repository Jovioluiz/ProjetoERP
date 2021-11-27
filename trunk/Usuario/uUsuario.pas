unit uUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uConexao, uclUsuario;

type
  TfrmUsuario = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtIdUsuario: TEdit;
    edtNomeUsuario: TEdit;
    edtSenhaUsuario: TMaskEdit;
    query: TFDQuery;
    sql: TFDQuery;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtIdUsuarioExit(Sender: TObject);
    procedure edtIdUsuarioChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FUsuario: TUsuario;
    procedure SetUsuario(const Value: TUsuario);
    procedure BuscarUsuario;

  public
    { Public declarations }
    procedure LimpaCampos;
    procedure ValidaCampos;
    procedure Salvar;
    procedure Excluir;

    property Usuario: TUsuario read FUsuario write SetUsuario;

  end;

var
  frmUsuario: TfrmUsuario;

implementation

{$R *.dfm}

uses uDataModule, uUtil;

procedure TfrmUsuario.BuscarUsuario;
var
  cripto: TValidaDados;
begin
  if edtIdUsuario.Text = EmptyStr then
  begin
    ValidaCampos;
    Exit;
  end;


  cripto := TValidaDados.Create;

  try
    FUsuario.CarregaUsuario(StrToInt(edtIdUsuario.Text));

    edtNomeUsuario.Text := FUsuario.Dados.cdsUsuario.FieldByName('login').AsString;
    edtSenhaUsuario.Text := cripto.GetSenhaMD5(FUsuario.Dados.cdsUsuario.FieldByName('senha').AsString);
    edtNomeUsuario.SetFocus;
  finally
    cripto.Free;
  end;
end;

procedure TfrmUsuario.edtIdUsuarioChange(Sender: TObject);
begin
  if edtIdUsuario.Text = '' then
    Exit;
end;

procedure TfrmUsuario.edtIdUsuarioExit(Sender: TObject);
begin
  BuscarUsuario;
end;

procedure TfrmUsuario.Excluir;
begin
  if (Application.MessageBox('Deseja Excluir o Usuário?','Atenção', MB_YESNO) = IDYES) then
  begin
    FUsuario.Dados.cdsUsuario.FieldByName('id_usuario').AsInteger := StrToInt(edtIdUsuario.Text);
    FUsuario.Excluir;
    ShowMessage('Usuário excluído com sucesso!');
    LimpaCampos;
  end;
end;

procedure TfrmUsuario.FormCreate(Sender: TObject);
begin
  FUsuario := TUsuario.Create;
end;

procedure TfrmUsuario.FormDestroy(Sender: TObject);
begin
  FUsuario.Free;
end;

procedure TfrmUsuario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if key = VK_F3 then //F3
    LimpaCampos
  else if key = VK_F2 then  //F2
    Salvar
  else if key = VK_F4 then    //F4
    Excluir
  else if key = VK_ESCAPE then //ESC
  begin
    if (Application.MessageBox('Deseja Fechar?','Atenção', MB_YESNO) = IDYES) then
      Close;
  end;
end;

procedure TfrmUsuario.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmUsuario.LimpaCampos;
begin
  edtIdUsuario.Clear;
  edtNomeUsuario.Clear;
  edtSenhaUsuario.Clear;
  //edtIdUsuario.SetFocus;
end;

procedure TfrmUsuario.Salvar;
var
  cripto: TValidaDados;
  novo: Boolean;
begin
  cripto := TValidaDados.Create;

  try
    ValidaCampos;

    novo := FUsuario.Pesquisar(StrToInt(edtIdUsuario.Text));

    FUsuario.Dados.cdsUsuario.Append;
    FUsuario.Dados.cdsUsuario.FieldByName('id_usuario').AsInteger := StrToInt(edtIdUsuario.Text);
    FUsuario.Dados.cdsUsuario.FieldByName('login').AsString := edtNomeUsuario.Text;
    FUsuario.Dados.cdsUsuario.FieldByName('senha').AsString := cripto.GetSenhaMD5(edtSenhaUsuario.Text);
    FUsuario.Dados.cdsUsuario.Post;

    if novo then
      FUsuario.Atualizar
    else
      FUsuario.Inserir;

    LimpaCampos;
  finally
    cripto.Free;
  end;
end;

procedure TfrmUsuario.SetUsuario(const Value: TUsuario);
begin
  FUsuario := Value;
end;

procedure TfrmUsuario.ValidaCampos;
var
  validacao: TValidaDados;
begin
  validacao := TValidaDados.Create;
  try
    try
      validacao.validaCodigo(StrToInt(edtIdUsuario.Text));
    except
      on E: Exception do
      ShowMessage(
        'Ocorreu um erro.' + #13 +
        'Mensagem de erro: ' + E.Message);
    end;
  finally
    FreeAndNil(usuario);
  end;
end;
end.
