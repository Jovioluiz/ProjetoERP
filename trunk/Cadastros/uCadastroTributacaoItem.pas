unit uCadastroTributacaoItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.UITypes;

type
  TfrmCadastraTributacaoItem = class(TForm)
    PageControl1: TPageControl;
    TabSheetICMS: TTabSheet;
    Label1: TLabel;
    edtCdGrupoTributacaoICMS: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtNomeGrupoTributacaoICMS: TEdit;
    edtAliqICMS: TEdit;
    StatusBar1: TStatusBar;
    TabSheetIPI: TTabSheet;
    edtAliqIPI: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtNomeGrupoTributacaoIPI: TEdit;
    edtCdGrupoTributacaoIPI: TEdit;
    Label8: TLabel;
    TabSheetISS: TTabSheet;
    Label9: TLabel;
    edtCdGrupoTributacaoISS: TEdit;
    edtNomeGrupoTributacaoISS: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    edtAliqISS: TEdit;
    TabSheetPISCOFINS: TTabSheet;
    Label4: TLabel;
    edtCdGrupoTributacaoPISCOFINS: TEdit;
    Label5: TLabel;
    edtNomeGrupoTributacaoPISCOFINS: TEdit;
    edtAliqPISCOFINS: TEdit;
    Label12: TLabel;
    procedure edtCdGrupoTributacaoICMSExit(Sender: TObject);
    procedure edtCdGrupoTributacaoIPIExit(Sender: TObject);
    procedure edtCdGrupoTributacaoISSExit(Sender: TObject);
    procedure edtCdGrupoTributacaoPISCOFINSExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    { Private declarations }
    procedure limpaCampos;
    procedure Salvar;
    procedure SalvarTributacaoICMS;
    procedure SalvarTributacaoIPI;
    procedure SalvarTributacaoISS;
    procedure SalvarTributacaoPisCofins;
  public
    { Public declarations }
  end;

var
  frmCadastraTributacaoItem: TfrmCadastraTributacaoItem;

implementation

uses
  uUtil, uDataModule, uLogin, uGrupoTributacao, uGrupoTributacaoICMS,
  uGrupoTributacaoIPI, uGrupoTributacaoISS, uGrupoTributacaoPISCOFINS;

{$R *.dfm}


procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoICMSExit(Sender: TObject);
var
  tributacao: TGrupoTributacao;
  dados: TDadosTributacao;
begin
  if edtCdGrupoTributacaoICMS.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoICMS.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end;

  tributacao := TGrupoTributacaoICMS.Create;

  try
    dados := tributacao.GetDadosTributacao(StrToInt(edtCdGrupoTributacaoICMS.Text));
    edtNomeGrupoTributacaoICMS.Text := dados.DescTributacao;
    edtAliqICMS.Text := CurrToStr(dados.Aliquota);
  finally
    tributacao.Free;
  end;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoIPIExit(Sender: TObject);
var
  tributacao: TGrupoTributacao;
  dados: TDadosTributacao;
begin
  if edtCdGrupoTributacaoIPI.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoIPI.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end;

  tributacao := TGrupoTributacaoIPI.Create;

  try
    dados := tributacao.GetDadosTributacao(StrToInt(edtCdGrupoTributacaoIPI.Text));
    edtNomeGrupoTributacaoIPI.Text := dados.DescTributacao;
    edtAliqIPI.Text := CurrToStr(dados.Aliquota);
  finally
    tributacao.Free;
  end;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoISSExit(Sender: TObject);
var
  tributacao: TGrupoTributacao;
  dados: TDadosTributacao;
begin
  if edtCdGrupoTributacaoISS.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoISS.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end;

  tributacao := TGrupoTributacaoISS.Create;

  try
    dados := tributacao.GetDadosTributacao(StrToInt(edtCdGrupoTributacaoISS.Text));
    edtNomeGrupoTributacaoISS.Text := dados.DescTributacao;
    edtAliqISS.Text := CurrToStr(dados.Aliquota);
  finally
    tributacao.Free;
  end;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoPISCOFINSExit(Sender: TObject);
var
  tributacao: TGrupoTributacao;
  dados: TDadosTributacao;
begin
  if edtCdGrupoTributacaoPISCOFINS.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoPISCOFINS.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end;

  tributacao := TGrupoTributacaoPISCOFINS.Create;

  try
    dados := tributacao.GetDadosTributacao(StrToInt(edtCdGrupoTributacaoPISCOFINS.Text));
    edtNomeGrupoTributacaoPISCOFINS.Text := dados.DescTributacao;
    edtAliqPISCOFINS.Text := CurrToStr(dados.Aliquota);
  finally
    tributacao.Free;
  end;
end;

procedure TfrmCadastraTributacaoItem.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmCadastraTributacaoItem := nil;
end;

procedure TfrmCadastraTributacaoItem.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_F3 then //F3
    limpaCampos
  else if key = VK_F2 then  //F2
    salvar
  else if key = VK_ESCAPE then //ESC
    if (Application.MessageBox('Deseja Fechar?','Atenção', MB_YESNO) = IDYES) then
      Close;
end;

procedure TfrmCadastraTributacaoItem.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmCadastraTributacaoItem.limpaCampos;
begin
  edtCdGrupoTributacaoICMS.Clear;
  edtNomeGrupoTributacaoICMS.Clear;
  edtAliqICMS.Clear;
  edtCdGrupoTributacaoIPI.Clear;
  edtNomeGrupoTributacaoIPI.Clear;
  edtAliqIPI.Clear;
  edtCdGrupoTributacaoISS.Clear;
  edtNomeGrupoTributacaoISS.Clear;
  edtAliqISS.Clear;
  edtCdGrupoTributacaoPISCOFINS.Clear;
  edtNomeGrupoTributacaoPISCOFINS.Clear;
  edtAliqPISCOFINS.Clear;
end;

procedure TfrmCadastraTributacaoItem.Salvar;
begin
  try
    SalvarTributacaoICMS;
    SalvarTributacaoIPI;
    SalvarTributacaoISS;
    SalvarTributacaoPisCofins;
  except on E: exception do
    raise Exception.Create('Ocorreu o seguinte erro ao gravar os dados ' + E.Message);
  end;
end;

procedure TfrmCadastraTributacaoItem.SalvarTributacaoICMS;
var
  tributacao: TGrupoTributacao;
  novo: Boolean;
begin
  if edtCdGrupoTributacaoICMS.Text <> '' then
  begin
    tributacao := TGrupoTributacaoICMS.Create;
    try
      novo := not tributacao.Pesquisar(StrToInt(edtCdGrupoTributacaoICMS.Text));
      tributacao.CodTributacao := StrToInt(edtCdGrupoTributacaoICMS.Text);
      tributacao.NomeTributacao := edtNomeGrupoTributacaoICMS.Text;
      tributacao.Aliquota := StrToCurr(edtAliqICMS.Text);
      tributacao.Persistir(novo);
      edtCdGrupoTributacaoICMS.Clear;
      edtNomeGrupoTributacaoICMS.Clear;
      edtAliqICMS.Clear;
    finally
      tributacao.Free;
    end;
  end;
end;

procedure TfrmCadastraTributacaoItem.SalvarTributacaoIPI;
var
  tributacao: TGrupoTributacao;
  novo: Boolean;
begin
  if edtCdGrupoTributacaoIPI.Text <> '' then
  begin
    tributacao := TGrupoTributacaoIPI.Create;
    try
      novo := not tributacao.Pesquisar(StrToInt(edtCdGrupoTributacaoIPI.Text));
      tributacao.CodTributacao := StrToInt(edtCdGrupoTributacaoIPI.Text);
      tributacao.NomeTributacao := edtNomeGrupoTributacaoIPI.Text;
      tributacao.Aliquota := StrToCurr(edtAliqIPI.Text);
      tributacao.Persistir(novo);
      edtCdGrupoTributacaoIPI.Clear;
      edtNomeGrupoTributacaoIPI.Clear;
      edtAliqIPI.Clear;
    finally
      tributacao.Free;
    end;
  end;
end;

procedure TfrmCadastraTributacaoItem.SalvarTributacaoISS;
var
  tributacao: TGrupoTributacao;
  novo: Boolean;
begin
  if edtCdGrupoTributacaoISS.Text <> '' then
  begin
    tributacao := TGrupoTributacaoISS.Create;
    try
      novo := not tributacao.Pesquisar(StrToInt(edtCdGrupoTributacaoISS.Text));
      tributacao.CodTributacao := StrToInt(edtCdGrupoTributacaoISS.Text);
      tributacao.NomeTributacao := edtNomeGrupoTributacaoISS.Text;
      tributacao.Aliquota := StrToCurr(edtAliqISS.Text);
      tributacao.Persistir(novo);
      edtCdGrupoTributacaoISS.Clear;
      edtNomeGrupoTributacaoISS.Clear;
      edtAliqISS.Clear;
    finally
      tributacao.Free;
    end;
  end;
end;

procedure TfrmCadastraTributacaoItem.SalvarTributacaoPisCofins;
var
  tributacao: TGrupoTributacao;
  novo: Boolean;
begin
  if edtCdGrupoTributacaoISS.Text <> '' then
  begin
    tributacao := TGrupoTributacaoPISCOFINS.Create;
    try
      novo := not tributacao.Pesquisar(StrToInt(edtCdGrupoTributacaoPISCOFINS.Text));
      tributacao.CodTributacao := StrToInt(edtCdGrupoTributacaoPISCOFINS.Text);
      tributacao.NomeTributacao := edtNomeGrupoTributacaoPISCOFINS.Text;
      tributacao.Aliquota := StrToCurr(edtAliqPISCOFINS.Text);
      tributacao.Persistir(novo);
      edtCdGrupoTributacaoPISCOFINS.Clear;
      edtNomeGrupoTributacaoPISCOFINS.Clear;
      edtAliqPISCOFINS.Clear;
    finally
      tributacao.Free;
    end;
  end;
end;

end.
