unit fConsultaContatos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, uManipuladorContato, Vcl.Menus;

type
  TfrmConsultaContatos = class(TForm)
    gridContatos: TDBGrid;
    pnlFundo: TPanel;
    edtPesquisa: TEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    btnPesquisar: TButton;
    pmOpcoes: TPopupMenu;
    EditarContato1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure EditarContato1Click(Sender: TObject);
  private
    FManipulador: TManipuladorContato;
    procedure SetManipulador(const Value: TManipuladorContato);
    procedure EditarContato;
    { Private declarations }
  public
    { Public declarations }
    property Manipulador: TManipuladorContato read FManipulador write SetManipulador;
  end;

var
  frmConsultaContatos: TfrmConsultaContatos;

implementation

uses
  cContato, uContato, System.StrUtils, System.Math;

{$R *.dfm}

procedure TfrmConsultaContatos.btnPesquisarClick(Sender: TObject);
begin
  FManipulador.ListarTodosContatos;
end;

procedure TfrmConsultaContatos.EditarContato;
var
  formContato: TfrmCadContato;
  contato: tpDadosContato;
begin
  formContato := TfrmCadContato.Create(Self);

  try
    contato := FManipulador.EditarContato(FManipulador.Dados.cdsContatos.FieldByName('cd_contato').AsInteger);

    formContato.edtNome.Text := contato.Nome;
    formContato.edtCodigo.Text := IntToStr(contato.Codigo);
    formContato.edtLogradouro.Text := contato.Logradouro;
    formContato.edtBairro.Text := contato.Bairro;
    formContato.edtCidade.Text := contato.Cidade;
    formContato.edtDocumento.Text := contato.NrDocumento;
    formContato.rgTpPessoa.ItemIndex := ifthen(contato.TipoPessoa = 'F', 0, 1);
    formContato.ShowModal;
    
  finally
    formContato.Free;
  end;
end;

procedure TfrmConsultaContatos.EditarContato1Click(Sender: TObject);
begin
  EditarContato;
end;

procedure TfrmConsultaContatos.FormCreate(Sender: TObject);
begin
  FManipulador := TManipuladorContato.Create;
  gridContatos.DataSource := FManipulador.Dados.dsContatos;
end;

procedure TfrmConsultaContatos.FormDestroy(Sender: TObject);
begin
  FManipulador.Free;
end;

procedure TfrmConsultaContatos.SetManipulador(const Value: TManipuladorContato);
begin
  FManipulador := Value;
end;

end.
