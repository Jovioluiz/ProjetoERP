unit cContato;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

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
  private
    { Private declarations }
    procedure Salvar;
    procedure LimparCampos;
    procedure Excluir;
  public
    { Public declarations }
  end;

var
  frmCadContato: TfrmCadContato;

implementation

uses
  uManipuladorContato, uContatoFisica, uContatoJuridica;

{$R *.dfm}

procedure TfrmCadContato.Excluir;
begin

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

    manipulador.SalvarContato(manipulador.Contato);
  finally
    manipulador.Free;
  end;
end;

end.
