unit fCadastroEnderecos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Datasnap.DBClient, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uEnderecoWMS;

type
  TfrmCadastroEnderecos = class(TForm)
    edtCodDeposito: TEdit;
    edtAla: TEdit;
    edtRua: TEdit;
    edtComplemento: TEdit;
    edtCodBarrasProduto: TEdit;
    edtNomeProduto: TEdit;
    dbgrdEndereco: TDBGrid;
    rgTipo: TRadioGroup;
    btnAdicionar: TButton;
    btn2: TButton;
    edtOrdem: TEdit;
    pnl1: TPanel;
    pgc1: TPageControl;
    tbsEndereco: TTabSheet;
    tbsProdutoEndereco: TTabSheet;
    edtComplementoProdEndereco: TEdit;
    edtRuaProdEndereco: TEdit;
    edtAlaProdEndereco: TEdit;
    edtCodDepositoProdEndereco: TEdit;
    btnAdd: TButton;
    dbgrdProdutoEndereco: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtNomeEndereco: TEdit;
    procedure edtCodBarrasProdutoExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure edtOrdemExit(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    FRegras: TEnderecoWMS;
    FNomeEndereco: String;
    procedure SetRegras(const Value: TEnderecoWMS);
    procedure MontaNomeEndereco;
    procedure Adicionar;
  public
    { Public declarations }
    procedure SalvaEnderecoProduto;
    procedure SalvarEndereco;
    procedure LimpaCampos;
    procedure LimpaDados;
    function Pesquisar(CdDeposito: Integer; Ala, Rua: string): Boolean; overload;
    function ValidaCampos: Boolean;

    property Regras: TEnderecoWMS read FRegras write SetRegras;
  end;

var
  frmCadastroEnderecos: TfrmCadastroEnderecos;

implementation

uses
  uDataModule, uGerador, uUtil, StrUtils;

{$R *.dfm}

procedure TfrmCadastroEnderecos.Adicionar;
begin
  if not ValidaCampos then
  begin
    ShowMessage('Os campos não podem ser vazios');
    Exit;
  end;

  try

    if not FRegras.Dados.cdsEnderecoProduto.Locate('cd_produto; cd_deposito; ala; rua',
                                                   VarArrayOf([edtCodBarrasProduto.Text,
                                                               StrToInt(edtCodDepositoProdEndereco.Text),
                                                               edtAlaProdEndereco.Text, edtRuaProdEndereco.Text]), []) then
    begin
      FRegras.Dados.cdsEnderecoProduto.Append;
      FRegras.Dados.cdsEnderecoProduto.FieldByName('cd_produto').AsString := edtCodBarrasProduto.Text;
      FRegras.Dados.cdsEnderecoProduto.FieldByName('nm_produto').AsString := edtNomeProduto.Text;
      FRegras.Dados.cdsEnderecoProduto.FieldByName('cd_deposito').AsInteger := StrToInt(edtCodDepositoProdEndereco.Text);
      FRegras.Dados.cdsEnderecoProduto.FieldByName('ala').AsString := edtAlaProdEndereco.Text;
      FRegras.Dados.cdsEnderecoProduto.FieldByName('rua').AsString := edtRuaProdEndereco.Text;
      FRegras.Dados.cdsEnderecoProduto.FieldByName('complemento').AsString := edtComplementoProdEndereco.Text;
      FRegras.Dados.cdsEnderecoProduto.FieldByName('nm_endereco').AsString := FNomeEndereco;

      FRegras.Dados.cdsEnderecoProduto.FieldByName('ordem').AsString := edtOrdem.Text;
      FRegras.Dados.cdsEnderecoProduto.Post;
    end
    else
      raise Exception.Create('O endereço já está cadastrado para este Produto');

    SalvaEnderecoProduto;
    LimpaCampos;
    ShowMessage('Salvo');
  except
    on E: Exception do
    begin
      ShowMessage(
        'Ocorreu um erro.' + #13 +
        'Mensagem de erro: ' + E.Message);
        FRegras.Dados.cdsEnderecoProduto.Cancel;
    end;
  end;
end;

procedure TfrmCadastroEnderecos.btn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadastroEnderecos.btnAddClick(Sender: TObject);
begin
  Adicionar;
end;

procedure TfrmCadastroEnderecos.btnAdicionarClick(Sender: TObject);
begin
  try
    if not ValidaCampos then
    begin
      ShowMessage('Os campos não podem ser vazios');
      Exit;
    end;

    if not FRegras.Dados.cdsEndereco.Locate('cd_deposito; ala; rua',
                                            VarArrayOf([StrToInt(edtCodDeposito.Text),
                                                                 edtAla.Text,
                                                                 edtRua.Text]), []) then
    begin
      FRegras.Dados.cdsEndereco.Append;
      FRegras.Dados.cdsEndereco.FieldByName('cd_deposito').AsInteger := StrToInt(edtCodDeposito.Text);
      FRegras.Dados.cdsEndereco.FieldByName('ala').AsString := edtAla.Text;
      FRegras.Dados.cdsEndereco.FieldByName('rua').AsString := edtRua.Text;
      FRegras.Dados.cdsEndereco.FieldByName('complemento').AsString := edtComplemento.Text;
      FRegras.Dados.cdsEndereco.FieldByName('nm_endereco').AsString := edtCodDeposito.Text
                                                                       + '-' + edtAla.Text
                                                                       + '-' + edtRua.Text
                                                                       + IfThen(edtComplemento.Text = '', '', '-' + edtComplemento.Text);
      FRegras.Dados.cdsEndereco.Post;
    end
    else
      raise Exception.Create('Endereço Já cadastrado');

    SalvarEndereco;
    LimpaCampos;
    ShowMessage('Salvo');

  except
    on E: Exception do
      ShowMessage(
        'Ocorreu um erro.' + #13 +
        'Mensagem de erro: ' + E.Message);
  end;
end;

procedure TfrmCadastroEnderecos.edtCodBarrasProdutoExit(Sender: TObject);
begin
  if not edtCodBarrasProduto.isEmpty then
  begin
    FRegras.CarregaEndereco(edtCodBarrasProduto.Text);
    edtNomeProduto.Text := FRegras.Dados.cdsEnderecoProduto.FieldByName('nm_produto').AsString;
  end;
end;

procedure TfrmCadastroEnderecos.edtOrdemExit(Sender: TObject);
begin
  MontaNomeEndereco;
end;

procedure TfrmCadastroEnderecos.FormCreate(Sender: TObject);
begin
  FRegras := TEnderecoWMS.Create;
  dbgrdEndereco.DataSource := FRegras.Dados.dsEndereco;
  dbgrdProdutoEndereco.DataSource := FRegras.Dados.dsEnderecoProduto;
  FNomeEndereco := '';
end;

procedure TfrmCadastroEnderecos.FormDestroy(Sender: TObject);
begin
  FRegras.Free;
end;

procedure TfrmCadastroEnderecos.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmCadastroEnderecos.LimpaCampos;
begin
  if tbsEndereco.Showing then
  begin
    edtAla.Clear;
    edtRua.Clear;
    edtCodDeposito.Clear;
    edtComplemento.Clear;
    //cdsEndereco.EmptyDataSet;
  end
  else
  begin
    edtAlaProdEndereco.Clear;
    edtRuaProdEndereco.Clear;
    edtCodDepositoProdEndereco.Clear;
    edtComplementoProdEndereco.Clear;
    edtOrdem.Clear;
  end;
  FNomeEndereco := '';
end;

procedure TfrmCadastroEnderecos.LimpaDados;
begin
  edtCodBarrasProduto.Clear;
  edtNomeProduto.Clear;
end;

procedure TfrmCadastroEnderecos.MontaNomeEndereco;
begin
  FNomeEndereco := edtCodDepositoProdEndereco.Text
                   + '-'
                   + edtAlaProdEndereco.Text
                   + '-'
                   + edtRuaProdEndereco.Text
                   + ifthen(edtComplementoProdEndereco.Text <> '', '-' + edtComplementoProdEndereco.Text, '');

  edtNomeEndereco.Text := FNomeEndereco;
end;

function TfrmCadastroEnderecos.Pesquisar(CdDeposito: Integer; Ala, Rua: string): Boolean;
const
  SQL = 'select cd_deposito, ala, rua from wms_endereco ' +
        'where cd_deposito = :cd_deposito and ' +
        'ala = :ala and ' +
        'rua = :rua';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('cd_deposito').AsInteger := CdDeposito;
    qry.ParamByName('ala').AsString := Ala;
    qry.ParamByName('rua').AsString := Rua;
    qry.Open(SQL);

    Result := not qry.IsEmpty;

  finally
    qry.Free;
  end;
end;

procedure TfrmCadastroEnderecos.SalvaEnderecoProduto;
var
  endereco: string;
begin

  try
    endereco := edtCodDepositoProdEndereco.Text + '-' + edtAlaProdEndereco.Text + '-'+ edtRuaProdEndereco.Text;
    FRegras.SalvaEnderecoProduto(endereco);
  except
    on E: Exception do
      raise Exception.Create('Erro ao gravar o endereço ' + FRegras.Dados.cdsEnderecoProduto.FieldByName('nm_endereco').AsString + E.Message);
  end;
end;

procedure TfrmCadastroEnderecos.SalvarEndereco;
const
  SQL_INSERT_ENDERECO = 'insert into wms_endereco(id_geral, cd_deposito, ala, rua, complemento) ' +
                        'values(:id_geral, :cd_deposito, :ala, :rua, :complemento)';
var
  qry: TFDQuery;
  idGeral: TGerador;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;
  idGeral := TGerador.Create;

  try
    try
      qry.SQL.Add(SQL_INSERT_ENDERECO);
      FRegras.Dados.cdsEndereco.Loop(
        procedure
        begin   //verifica se já possui um endereço cadastrado
          if not Pesquisar(FRegras.Dados.cdsEndereco.FieldByName('cd_deposito').AsInteger,
                           FRegras.Dados.cdsEndereco.FieldByName('ala').AsString,
                           FRegras.Dados.cdsEndereco.FieldByName('rua').AsString) then
          begin
            qry.ParamByName('id_geral').AsInteger := idGeral.GeraIdGeral;
            qry.ParamByName('cd_deposito').AsInteger := FRegras.Dados.cdsEndereco.FieldByName('cd_deposito').AsInteger;
            qry.ParamByName('ala').AsString := FRegras.Dados.cdsEndereco.FieldByName('ala').AsString;
            qry.ParamByName('rua').AsString := FRegras.Dados.cdsEndereco.FieldByName('rua').AsString;
            qry.ParamByName('complemento').AsString := FRegras.Dados.cdsEndereco.FieldByName('complemento').AsString;
            qry.ExecSQL;
          end;
        end
      );

      qry.Connection.Commit;
    except
      on E: Exception do
      begin
        qry.Connection.Rollback;
        ShowMessage('Erro ao gravar o endereço ' + E.Message);
        Exit;
      end;
    end;
  finally
    FreeAndNil(idGeral);
    LimpaCampos;
    qry.Free;
  end;
end;

procedure TfrmCadastroEnderecos.SetRegras(const Value: TEnderecoWMS);
begin
  FRegras := Value;
end;

function TfrmCadastroEnderecos.ValidaCampos: Boolean;
begin
  Result := True;

  if tbsEndereco.Showing then
  begin
    if edtCodDeposito.isEmpty then
      Exit(False);
    if edtAla.isEmpty then
      Exit(False);
    if edtRua.isEmpty then
      Exit(False);
  end
  else
  begin
    if edtCodDepositoProdEndereco.isEmpty then
      Exit(False);
    if edtAlaProdEndereco.isEmpty then
      Exit(False);
    if edtRuaProdEndereco.isEmpty then
      Exit(False);
    if edtOrdem.isEmpty then
      Exit(False);
  end;
end;

end.
