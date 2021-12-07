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
    comandoSQL: TFDQuery;
    comandoselect: TFDQuery;
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
    procedure salvar;
    procedure desabilitaCampos;
  public
    { Public declarations }
  end;

var
  frmCadastraTributacaoItem: TfrmCadastraTributacaoItem;
  camposDesabilitados: Boolean;

implementation

uses
  uUtil, uDataModule, uLogin, uGrupoTributacao, uGrupoTributacaoICMS,
  uGrupoTributacaoIPI, uGrupoTributacaoISS, uGrupoTributacaoPISCOFINS;

{$R *.dfm}

procedure TfrmCadastraTributacaoItem.desabilitaCampos;
begin
  edtCdGrupoTributacaoICMS.Enabled := False;
  edtNomeGrupoTributacaoICMS.Enabled := False;
  edtAliqICMS.Enabled := False;
  camposDesabilitados := True;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoICMSExit(Sender: TObject);
var
  icms : TValidaDados;
begin
  icms := TValidaDados.Create;

  if edtCdGrupoTributacaoICMS.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoICMS.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end
  else
  begin
    comandoselect.Close;
    comandoselect.SQL.Text := 'select                             '+
                              '    cd_tributacao,                 '+
                              '    nm_tributacao_icms,            '+
                              '    aliquota_icms                  '+
                              'from                               '+
                              '    grupo_tributacao_icms          '+
                              'where                              '+
                                  'cd_tributacao = :cd_tributacao';
    comandoselect.ParamByName('cd_tributacao').AsInteger := StrToInt(edtCdGrupoTributacaoICMS.Text);
    comandoselect.Open();
    if not comandoselect.IsEmpty then
    begin
      //edtCdGrupoTributacaoICMS.Text := IntToStr(comandoselect.FieldByName('cd_tributacao').AsInteger);
      edtNomeGrupoTributacaoICMS.Text := comandoselect.FieldByName('nm_tributacao_icms').AsString;
      edtAliqICMS.Text := CurrToStr(comandoselect.FieldByName('aliquota_icms').AsCurrency);
    end;

    if (icms.ValidaEdicaoAcao(IdUsuario, 13).Equals('N')) and (comandoSQL.IsEmpty) then
    begin
      MessageDlg('Usuário não possui Permissão para realizar Cadastro/Edição', mtInformation, [mbOK], 0);
      desabilitaCampos;
    end;
  end;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoIPIExit(Sender: TObject);
begin
  if edtCdGrupoTributacaoIPI.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoIPI.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end
  else
  begin
    comandoselect.Close;
    comandoselect.SQL.Text := 'select                             '+
                              '    cd_tributacao,                 '+
                              '    nm_tributacao_ipi,             '+
                              '    aliquota_ipi                   '+
                              'from                               '+
                              '    grupo_tributacao_ipi           '+
                              'where                              '+
                                  'cd_tributacao = :cd_tributacao';
    comandoselect.ParamByName('cd_tributacao').AsInteger := StrToInt(edtCdGrupoTributacaoIPI.Text);
    comandoselect.Open();
    if not comandoselect.IsEmpty then
    begin
      //edtCdGrupoTributacaoIPI.Text := IntToStr(comandoselect.FieldByName('cd_tributacao').AsInteger);
      edtNomeGrupoTributacaoIPI.Text := comandoselect.FieldByName('nm_tributacao_ipi').AsString;
      edtAliqIPI.Text := CurrToStr(comandoselect.FieldByName('aliquota_ipi').AsCurrency);
    end;
  end;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoISSExit(Sender: TObject);
begin
  if edtCdGrupoTributacaoISS.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoISS.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end
  else
  begin
    comandoselect.Close;
    comandoselect.SQL.Text := 'select                             '+
                              '    cd_tributacao,                 '+
                              '    nm_tributacao_iss,             '+
                              '    aliquota_iss                   '+
                              'from                               '+
                              '    grupo_tributacao_iss           '+
                              'where                              '+
                                  'cd_tributacao = :cd_tributacao';
    comandoselect.ParamByName('cd_tributacao').AsInteger := StrToInt(edtCdGrupoTributacaoISS.Text);
    comandoselect.Open();

    if not comandoselect.IsEmpty then
    begin
      //edtCdGrupoTributacaoISS.Text := IntToStr(comandoselect.FieldByName('cd_tributacao').AsInteger);
      edtNomeGrupoTributacaoISS.Text := comandoselect.FieldByName('nm_tributacao_iss').AsString;
      edtAliqISS.Text := CurrToStr(comandoselect.FieldByName('aliquota_iss').AsCurrency);
    end;
  end;
end;

procedure TfrmCadastraTributacaoItem.edtCdGrupoTributacaoPISCOFINSExit(Sender: TObject);
begin
  if edtCdGrupoTributacaoPISCOFINS.Text = EmptyStr then
  begin
    edtCdGrupoTributacaoPISCOFINS.SetFocus;
    raise Exception.Create('Campo não pode ser vazio');
  end
  else
  begin
    comandoselect.Close;
    comandoselect.SQL.Text := 'select                             '+
                              '    cd_tributacao,                 '+
                              '    nm_tributacao_pis_cofins,                 '+
                              '    aliquota_pis_cofins            '+
                              'from                               '+
                              '    grupo_tributacao_pis_cofins    '+
                              'where                              '+
                                  'cd_tributacao = :cd_tributacao';
    comandoselect.ParamByName('cd_tributacao').AsInteger := StrToInt(edtCdGrupoTributacaoPISCOFINS.Text);
    comandoselect.Open();

    if not comandoselect.IsEmpty then
    begin
      //edtCdGrupoTributacaoPISCOFINS.Text := IntToStr(comandoselect.FieldByName('cd_tributacao').AsInteger);
      edtNomeGrupoTributacaoPISCOFINS.Text := comandoselect.FieldByName('nm_tributacao_pis_cofins').AsString;
      edtAliqPISCOFINS.Text := CurrToStr(comandoselect.FieldByName('aliquota_pis_cofins').AsCurrency);
    end;
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
  if camposDesabilitados then
  begin
    edtCdGrupoTributacaoICMS.Enabled := True;
    edtNomeGrupoTributacaoICMS.Enabled := True;
    edtAliqICMS.Enabled := True;
    camposDesabilitados := False;
  end;

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

procedure TfrmCadastraTributacaoItem.salvar;
var
  tributacao: TGrupoTributacao;
  novo: Boolean;
begin
  try
    if edtCdGrupoTributacaoICMS.Text <> '' then//ICMS
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

    if edtCdGrupoTributacaoIPI.Text <> '' then    //IPI
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

    if edtCdGrupoTributacaoISS.Text <> '' then      //ISS
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

    if edtCdGrupoTributacaoISS.Text <> '' then //PIS/COFINS
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
  except on E: exception do
    raise Exception.Create('Ocorreu o seguinte erro ao gravar os dados ' + E.Message);
  end;
end;

end.
