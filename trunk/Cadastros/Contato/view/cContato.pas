unit cContato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, StrUtils,
  Vcl.Menus;

type
  TfrmCadContato = class(TForm)
    edtDocumento: TEdit;
    edtCodigo: TEdit;
    edtLogradouro: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    rgTpPessoa: TRadioGroup;
    edtNome: TEdit;
    Label6: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodigoExit(Sender: TObject);
  private
    { Private declarations }
    procedure Salvar;
    procedure LimparCampos;
    procedure Excluir;
    procedure CarregaContato;
  public
    { Public declarations }
  end;

var
  frmCadContato: TfrmCadContato;

implementation

uses
  uManipuladorContato, uContatoFisica, uContatoJuridica, FireDAC.Comp.Client,
  uDataModule;

{$R *.dfm}

procedure TfrmCadContato.CarregaContato;
const
  SQL = ' SELECT ' +
        ' 	tp_pessoa, ' +
        ' 	nm_contato, ' +
        ' 	logradouro, ' +
        ' 	bairro, ' +
        ' 	cidade, ' +
        '   nr_documento ' +
        ' FROM ' +
        ' 	contato ' +
        ' WHERE cd_contato = :cd_contato';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(Self);
  query.Connection := dm.ConexaoBanco;

  try
    query.Open(SQL, [StrToInt(edtCodigo.Text)]);
    if not query.IsEmpty then
    begin
      edtNome.Text := query.FieldByName('nm_contato').AsString;
      edtDocumento.Text := query.FieldByName('nr_documento').AsString;
      edtLogradouro.Text := query.FieldByName('logradouro').AsString;
      edtBairro.Text := query.FieldByName('bairro').AsString;
      edtCidade.Text := query.FieldByName('cidade').AsString;
      case AnsiIndexStr(query.FieldByName('tp_pessoa').AsString.ToUpper, ['F', 'J']) of
        0: rgTpPessoa.ItemIndex := 0;
        1: rgTpPessoa.ItemIndex := 1;
      end;
    end;
  finally
    query.Free;
  end;
end;

procedure TfrmCadContato.edtCodigoExit(Sender: TObject);
begin
  CarregaContato;
end;

procedure TfrmCadContato.Excluir;
var
  manipulador: TManipuladorContato;
begin
  manipulador := TManipuladorContato.Create;

  try
    manipulador.ExcluirContato(StrToInt(edtCodigo.Text));
    LimparCampos;
  finally
    manipulador.Free;
  end;
end;

procedure TfrmCadContato.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_F3 then //F3
    LimparCampos
  else if key = VK_F2 then  //F2
    Salvar
  else if key = VK_F4 then    //F4
    Excluir
  else if key = VK_ESCAPE then //ESC
    if (Application.MessageBox('Deseja Fechar?','Atenção', MB_YESNO) = IDYES) then
      Close;
end;

procedure TfrmCadContato.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmCadContato.LimparCampos;
begin
  edtDocumento.Clear;
  edtCodigo.Clear;
  edtLogradouro.Clear;
  edtBairro.Clear;
  edtCidade.Clear;
  edtNome.Clear;
end;

procedure TfrmCadContato.Salvar;
var
  manipulador: TManipuladorContato;
begin
  manipulador := nil;

  case rgTpPessoa.ItemIndex of
    0: manipulador := TManipuladorContato.Create(TContatoFisica.Create);
    1: manipulador := TManipuladorContato.Create(TContatoJuridica.Create);
  end;

  try
    manipulador.Contato.Codigo := StrToInt(edtCodigo.Text);
    manipulador.Contato.Nome := edtNome.Text;
    manipulador.Contato.Logradouro := edtLogradouro.Text;
    manipulador.Contato.Bairro := edtBairro.Text;
    manipulador.Contato.Cidade := edtCidade.Text;
    if (manipulador.Contato is TContatoFisica) then
      (manipulador.Contato as TContatoFisica).CPF := edtDocumento.Text
    else if (manipulador.Contato is TContatoJuridica) then
      (manipulador.Contato as TContatoJuridica).CNPJ := edtDocumento.Text;
    manipulador.Contato.TipoPessoa := manipulador.Contato.TipoContato;
    manipulador.Contato.NrDocumento := edtDocumento.Text;

    manipulador.SalvarContato;
    LimparCampos;
  finally
    manipulador.Contato.Free;
    manipulador.Free;
  end;
end;

end.
