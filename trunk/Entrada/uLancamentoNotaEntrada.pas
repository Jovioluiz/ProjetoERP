unit uLancamentoNotaEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient, System.UITypes, uclNotaEntrada, uDataModule, uUtil,
  Vcl.NumberBox;

type
  TfrmLancamentoNotaEntrada = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtNroNota: TEdit;
    edtSerie: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtCdFornecedor: TEdit;
    edtOperacao: TEdit;
    edtModelo: TEdit;
    edtNomeOperacao: TEdit;
    edtNomeFornecedor: TEdit;
    edtNomeModelo: TEdit;
    Label6: TLabel;
    edtDataEmissao: TDateTimePicker;
    Label7: TLabel;
    edtDataRecebimento: TDateTimePicker;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    edtCodProduto: TEdit;
    edtDescricaoProduto: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    edtUnMedida: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    edtDataLancamento: TDateTimePicker;
    Label29: TLabel;
    btnAddItens: TButton;
    DBGridProdutos: TDBGrid;
    btnConfirmar: TButton;
    btnCancelar: TButton;
    edtVlServico: TNumberBox;
    edtVlProduto: TNumberBox;
    edtBaseIcms: TNumberBox;
    edtValorIcms: TNumberBox;
    edtValorFrete: TNumberBox;
    edtValorIPI: TNumberBox;
    edtValorISS: TNumberBox;
    edtValorDesconto: TNumberBox;
    edtValorAcrescimo: TNumberBox;
    edtValorOutrasDespesas: TNumberBox;
    edtValorTotalNota: TNumberBox;
    edtQuantidade: TNumberBox;
    edtFatorConversao: TNumberBox;
    edtQuantidadeTotalProduto: TNumberBox;
    edtValorUnitario: TNumberBox;
    edtValorTotalProduto: TNumberBox;
    procedure edtOperacaoExit(Sender: TObject);
    procedure edtModeloChange(Sender: TObject);
    procedure edtModeloExit(Sender: TObject);
    procedure edtCdFornecedorChange(Sender: TObject);
    procedure edtCdFornecedorExit(Sender: TObject);
    procedure edtSerieExit(Sender: TObject);
    procedure edtCodProdutoChange(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtVlProdutoExit(Sender: TObject);
    procedure edtNroNotaExit(Sender: TObject);
    procedure edtVlServicoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorFreteExit(Sender: TObject);
    procedure ValorTotalNota;
    procedure CalculaQuantidadeTotalItem();
    procedure edtValorIPIExit(Sender: TObject);
    procedure edtValorDescontoExit(Sender: TObject);
    procedure edtValorAcrescimoExit(Sender: TObject);
    procedure edtValorOutrasDespesasExit(Sender: TObject);
    procedure edtCodProdutoEnter(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtValorUnitarioChange(Sender: TObject);
    procedure CalculaValorTotalItem;
    procedure btnAddItensClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridProdutosDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  type
    TAliqProduto = record
     AliqIcms,
     AliqIPI,
     AliqPisCofins: Double;
  end;

  private
    FIdGeralNFC: Integer;
    FEdicaoItem: Boolean;
    FIdGeralNFI: Integer;
    FRegras: TNotaEntrada;
    FSeq: Integer;
    { Private declarations }
    procedure ValidaValoresNota;
    procedure limpaCampos;
    procedure LancaFinanceiro(Conexao: TFDConnection);
    procedure SetIdGeralNFC(const Value: Integer);
    procedure CarregaItensEdicao;
    procedure SetEdicaoItem(const Value: Boolean);
    procedure SetIdGeralNFI(const Value: Integer);
    procedure SetRegras(const Value: TNotaEntrada);
    procedure AdicionaItem;
    procedure LimpaOutrosCampos;
//    function GetInfoProduto(const CodItem: String): TInfoProdutos;
    function GetAliqProduto(IdItem: Integer): TAliqProduto;
    procedure PreencheDatasetNFC;
    procedure ConfirmarNota;
  public
    { Public declarations }
    destructor Destroy; override;
    property IdGeralNFC: Integer read FIdGeralNFC write SetIdGeralNFC;
    property EdicaoItem: Boolean read FEdicaoItem write SetEdicaoItem;
    property IdGeralNFI: Integer read FIdGeralNFI write SetIdGeralNFI;
    property Regras: TNotaEntrada read FRegras write SetRegras;
  end;

var
  frmLancamentoNotaEntrada: TfrmLancamentoNotaEntrada;

implementation

uses
  uGerador, uLogin, uMovimentacaoEstoque;

{$R *.dfm}


procedure TfrmLancamentoNotaEntrada.edtCdFornecedorChange(Sender: TObject);
const
  sql = 'select                       '+
          'cd_cliente,                '+
          'nome                       '+
        'from                         '+
           'cliente                   '+
        'where                        '+
            'cd_cliente = :cd_cliente';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    if edtCdFornecedor.Text = EmptyStr then
    begin
      edtNomeFornecedor.Clear;
      Exit;
    end;

    qry.Open(sql, [StrToInt(edtCdFornecedor.Text)]);
    edtNomeFornecedor.Text := qry.FieldByName('nome').AsString;
  finally
    qry.Free;
  end;
end;


procedure TfrmLancamentoNotaEntrada.edtCdFornecedorExit(Sender: TObject);
var
  nota: TNotaEntrada;
begin
  if edtCdFornecedor.Text = EmptyStr then
  begin
    ShowMessage('Informe um Fornecedor');
    edtCdFornecedor.SetFocus;
    Exit;
  end;

  nota := TNotaEntrada.Create;

  try
    if not nota.BuscaClienteFornecedor(StrToInt(edtCdFornecedor.Text)) then
    begin
      if (Application.MessageBox('Fornecedor/Cliente não Encontrado', 'Atenção', MB_OK) = IDOK) then
      begin
        edtCdFornecedor.SetFocus;
        edtNomeFornecedor.Clear;
      end;
    end;
  finally
    FreeAndNil(nota);
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtCodProdutoChange(Sender: TObject);
var
  produto: TInfoProdutos;
begin
  if edtCodProduto.Text = EmptyStr then
  begin
    edtDescricaoProduto.Clear;
    edtUnMedida.Clear;
    edtFatorConversao.Clear;
    edtValorUnitario.Clear;
    edtValorTotalProduto.Clear;
    Exit;
  end;

  produto := FRegras.GetInfoProduto(edtCodProduto.Text);

  if not produto.CodItem.IsEmpty then
  begin
    edtDescricaoProduto.Text := produto.DescProduto;
    edtUnMedida.Text := produto.UnMedida;
    edtFatorConversao.ValueInt := produto.FatorConversao;
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtCodProdutoEnter(Sender: TObject);
begin
  edtOperacao.Enabled := False;
  edtModelo.Enabled := False;
  edtCdFornecedor.Enabled := False;
  edtSerie.Enabled := False;
  edtNroNota.Enabled := False;
  edtDataEmissao.Enabled := False;
  edtDataRecebimento.Enabled := False;
  edtDataLancamento.Enabled := False;
end;

procedure TfrmLancamentoNotaEntrada.edtCodProdutoExit(Sender: TObject);
var
  aliq: TAliqProduto;
begin

  if (Trim(edtCodProduto.Text) = '') and (FRegras.DadosNota.cdsNfi.RecordCount > 0) then
  begin
    btnConfirmar.SetFocus;
    Exit;
  end;

  if (edtCodProduto.Text = '') and (FRegras.DadosNota.cdsNfi.IsEmpty) then
  begin
    ShowMessage('Informe um Produto.');
    edtCodProduto.SetFocus;
    Exit;
  end;

  if not Regras.Pesquisar(edtCodProduto.Text) then
  begin
    edtCodProduto.SetFocus;
    raise Exception.Create('Produto não Encontrado');
  end;

  aliq := GetAliqProduto(FRegras.GetIdItem(edtCodProduto.Text));

  if aliq.AliqIcms = 0 then
  begin
    ShowMessage('Produto sem tributação ICMS.');
    edtCodProduto.SetFocus;
    Exit;
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtModeloChange(Sender: TObject);
begin
  if edtModelo.Text = EmptyStr then
  begin
    edtNomeModelo.Clear;
    Exit;
  end;
  edtNomeModelo.Text := FRegras.GetNomeModeloNota(edtModelo.Text);
end;

procedure TfrmLancamentoNotaEntrada.edtModeloExit(Sender: TObject);
begin
  if edtModelo.isEmpty then
  begin
    edtNomeModelo.Clear;
    Exit;
  end;

  edtNomeModelo.Text := FRegras.GetNomeModeloNota(edtModelo.Text);
  if edtModelo.isEmpty then
  begin
    ShowMessage('Modelo não Encontrado');
    edtModelo.SetFocus;
    edtNomeModelo.Clear;
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtNroNotaExit(Sender: TObject);
begin
  if edtNroNota.Text = EmptyStr then
  begin
    ShowMessage('Número da nota não pode ser vazio.');
    edtNroNota.SetFocus;
    Exit;
  end;

  if Regras.PossuiNotaLancada(StrToInt(edtNroNota.Text), StrToInt(edtCdFornecedor.Text), edtSerie.Text) then
  begin
    ShowMessage('Número da nota já cadastrada no sistema.');
    edtNroNota.SetFocus;
    Exit;
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtOperacaoExit(Sender: TObject);
const
  SQL = ' select                          '+
        '   op.cd_operacao,            '+
        '   op.nm_operacao,            '+
        '   op.cd_modelo_nota_fiscal,  '+
        '   mnf.nm_modelo              '+
        ' from                             '+
        '   operacao op                '+
        '   left join modelo_nota_fiscal mnf on   '+
        '   op.cd_modelo_nota_fiscal = mnf.cd_modelo ' +
        ' where              '+
        '   (op.cd_operacao = :cd_operacao) '+
        '   and (op.fl_ent_sai = ''E'')';
var
  consulta: TFDQuery;
begin
  if btnCancelar.MouseInClient then
    Exit;

  if edtOperacao.isEmpty then
  begin
    edtNomeOperacao.Text := '';
    Exit;
  end;
  if ((edtOperacao.isEmpty) and (edtModelo.isEmpty)) then
  begin
    edtNomeOperacao.Clear;
    edtNomeModelo.Clear;
    Exit;
  end;

  consulta := TFDQuery.Create(Self);
  consulta.Connection := dm.conexaoBanco;

  try
    consulta.Open(SQL, [StrToInt(edtOperacao.Text)]);

    if consulta.IsEmpty then
    begin
      ShowMessage('Operação não encontrada');
      edtOperacao.SetFocus;
      edtNomeOperacao.Clear;
      edtModelo.Clear;
      edtNomeModelo.Clear;
      Exit;
    end;

    edtNomeOperacao.Text := consulta.FieldByName('nm_operacao').AsString;
    edtModelo.Text := consulta.FieldByName('cd_modelo_nota_fiscal').AsString;
    edtNomeModelo.Text := consulta.FieldByName('nm_modelo').AsString;
  finally
    consulta.Free;
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtQuantidadeChange(Sender: TObject);
begin
  if edtQuantidade.Text = EmptyStr then
   Exit;

  CalculaQuantidadeTotalItem;
  CalculaValorTotalItem;
end;

procedure TfrmLancamentoNotaEntrada.edtQuantidadeExit(Sender: TObject);
begin
  CalculaQuantidadeTotalItem;
end;

procedure TfrmLancamentoNotaEntrada.edtSerieExit(Sender: TObject);
begin
  if FRegras.GetSerieNfc(edtSerie.Text).IsEmpty then
  begin
    if (Application.MessageBox('Série não encontrado', 'Atenção', MB_OK) = idOK) then
      edtSerie.SetFocus;
  end;
end;

procedure TfrmLancamentoNotaEntrada.edtVlProdutoExit(Sender: TObject);
begin
  if (edtVlServico.ValueCurrency = 0) and (edtVlProduto.ValueCurrency = 0) then
  begin
    ShowMessage('Valor de Serviço ou Produto não pode ser igual a zero!');
    edtVlServico.SetFocus;
    Exit;
  end
  else if (edtVlServico.ValueCurrency > 0) and (edtVlProduto.ValueCurrency > 0) then
  begin
    ShowMessage('Não pode ser lançado valores de serviços e produtos na mesma nota!');
    edtVlServico.SetFocus;
    Exit;
  end;

  ValorTotalNota;
end;

procedure TfrmLancamentoNotaEntrada.edtVlServicoExit(Sender: TObject);
begin
  ValorTotalNota;
end;

procedure TfrmLancamentoNotaEntrada.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmLancamentoNotaEntrada := nil;
end;

procedure TfrmLancamentoNotaEntrada.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (edtNroNota.Text <> '') or (FRegras.DadosNota.cdsNfi.RecordCount > 0) then
  begin
    CanClose := False;
    if (Application.MessageBox('Deseja Cancelar o lançamento da Nota?','Atenção', MB_YESNO) = IDYES) then
      CanClose := True;
  end;
end;

procedure TfrmLancamentoNotaEntrada.FormCreate(Sender: TObject);
begin
  FRegras := TNotaEntrada.Create;
  DBGridProdutos.DataSource := FRegras.DadosNota.dsNfi;
  edtDataEmissao.Date := now;
  edtDataRecebimento.Date := now;
  edtDataLancamento.Date := now;
  FSeq := 1;
  FEdicaoItem := False;
  IdGeralNFC := 0;
  IdGeralNFI := 0;
end;

procedure TfrmLancamentoNotaEntrada.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

function TfrmLancamentoNotaEntrada.GetAliqProduto(IdItem: Integer): TAliqProduto;
const
  SQL = 'select                                               '+
        '    gti.aliquota_icms,                               '+
        '    ipi.aliquota_ipi,                                '+
        '    gtpc.aliquota_pis_cofins                         '+
        '    from produto_tributacao pt                       '+
        'join grupo_tributacao_icms gti on                    '+
        '    pt.cd_tributacao_icms = gti.cd_tributacao        '+
        'join grupo_tributacao_ipi ipi on                     '+
        '    pt.cd_tributacao_ipi = ipi.cd_tributacao         '+
        'join grupo_tributacao_pis_cofins gtpc on             '+
        '    pt.cd_tributacao_pis_cofins = gtpc.cd_tributacao '+
        'where                                                '+
        '    pt.id_item = :id_item';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(Self);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [IdItem]);

    Result.AliqIcms := query.FieldByName('aliquota_icms').AsFloat;
    Result.AliqIPI := query.FieldByName('aliquota_ipi').AsFloat;
    Result.AliqPisCofins := query.FieldByName('aliquota_pis_cofins').AsFloat;

  finally
    query.Free;
  end;
end;

procedure TfrmLancamentoNotaEntrada.limpaCampos;
begin
  edtOperacao.Clear;
  edtOperacao.Enabled := true;
  edtNomeOperacao.Clear;
  edtModelo.Clear;
  edtModelo.Enabled := true;
  edtNomeModelo.Clear;
  edtCdFornecedor.Clear;
  edtCdFornecedor.Enabled := true;
  edtNomeFornecedor.Clear;
  edtSerie.Clear;
  edtSerie.Enabled := true;
  edtNroNota.Clear;
  edtNroNota.Enabled := true;
  edtDataEmissao.Enabled := true;
  edtDataRecebimento.Enabled := true;
  edtDataLancamento.Enabled := true;
  edtVlServico.ValueCurrency := 0;
  edtVlProduto.ValueCurrency := 0;
  edtBaseIcms.ValueCurrency := 0;
  edtValorIcms.ValueCurrency := 0;
  edtValorFrete.ValueCurrency := 0;
  edtValorIPI.ValueCurrency := 0;
  edtValorISS.ValueCurrency := 0;
  edtValorDesconto.ValueCurrency := 0;
  edtValorAcrescimo.ValueCurrency := 0;
  edtValorOutrasDespesas.ValueCurrency := 0;
  edtValorTotalNota.ValueCurrency := 0;
  FRegras.DadosNota.cdsNfi.EmptyDataSet;
  FSeq := 1;
end;

procedure TfrmLancamentoNotaEntrada.LimpaOutrosCampos;
begin
  edtCodProduto.Clear;
  edtDescricaoProduto.Clear;
  edtQuantidade.Clear;
  edtUnMedida.Clear;
  edtFatorConversao.Clear;
  edtQuantidadeTotalProduto.Clear;
  edtValorUnitario.Clear;
  edtValorTotalProduto.Clear;
  edtCodProduto.SetFocus;
  FSeq := FSeq + 1;
end;

procedure TfrmLancamentoNotaEntrada.PreencheDatasetNFC;
var
  idGeral: TGerador;
begin
  idGeral := TGerador.Create;

  try
    FRegras.DadosNota.cdsNfc.Append;
    FRegras.DadosNota.cdsNfc.FieldByName('id_geral').AsLargeInt := idGeral.GeraIdGeral;
    FRegras.DadosNota.cdsNfc.FieldByName('dcto_numero').AsInteger := StrToInt(edtNroNota.Text);
    FRegras.DadosNota.cdsNfc.FieldByName('serie').AsString := edtSerie.Text;
    FRegras.DadosNota.cdsNfc.FieldByName('cd_fornecedor').AsInteger := StrToInt(edtCdFornecedor.Text);
    FRegras.DadosNota.cdsNfc.FieldByName('dt_emissao').AsDateTime := edtDataEmissao.DateTime;
    FRegras.DadosNota.cdsNfc.FieldByName('dt_recebimento').AsDateTime := edtDataRecebimento.DateTime;
    FRegras.DadosNota.cdsNfc.FieldByName('dt_lancamento').AsDateTime := edtDataLancamento.DateTime;
    FRegras.DadosNota.cdsNfc.FieldByName('cd_operacao').AsInteger := StrToInt(edtOperacao.Text);
    FRegras.DadosNota.cdsNfc.FieldByName('cd_modelo').AsString := edtModelo.Text;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_servico').AsCurrency := edtVlServico.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('vl_base_icms').AsCurrency := edtBaseIcms.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_icms').AsCurrency := edtValorIcms.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_frete').AsCurrency := edtValorFrete.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_ipi').AsCurrency := edtValorIPI.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_iss').AsCurrency := edtValorISS.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_desconto').AsCurrency := edtValorDesconto.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_acrescimo').AsCurrency := edtValorAcrescimo.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_outras_despesas').AsCurrency := edtValorOutrasDespesas.ValueCurrency;
    FRegras.DadosNota.cdsNfc.FieldByName('valor_total').AsCurrency := edtValorTotalNota.ValueCurrency;
    FRegras.DadosNota.cdsNfc.Post;

  finally
    idGeral.Free;
  end;
end;

procedure TfrmLancamentoNotaEntrada.SetEdicaoItem(const Value: Boolean);
begin
  FEdicaoItem := Value;
end;

procedure TfrmLancamentoNotaEntrada.SetIdGeralNFC(const Value: Integer);
begin
  FidGeralNFC := Value;
end;

procedure TfrmLancamentoNotaEntrada.SetIdGeralNFI(const Value: Integer);
begin
  FIdGeralNFI := Value;
end;

procedure TfrmLancamentoNotaEntrada.SetRegras(const Value: TNotaEntrada);
begin
  FRegras := Value;
end;

procedure TfrmLancamentoNotaEntrada.LancaFinanceiro(Conexao: TFDConnection);
const
  SQL = 'insert into cxa_financeiro(' +
        '   id_geral,' +
        '   id_nota_entrada,' +
        '   cd_forma_pgto,' +
        '   cd_cond_pgto,' +
        '   valor,' +
        '   cd_usuario,' +
        '   fl_entrada_saida,' +
        '   dt_pgto)' +
        'values(:id_geral,' +
        '   :id_nota_entrada,' +
        '   :cd_forma_pgto,' +
        '   :cd_cond_pgto,' +
        '   :valor,' +
        '   :cd_usuario,' +
        '   :fl_entrada_saida,' +
        '   :dt_pgto)';
var
  qry: TFDQuery;
  idGeral: TGerador;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := Conexao;
  idGeral := TGerador.Create;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('id_geral').AsInteger := idGeral.GeraIdGeral;
    qry.ParamByName('id_nota_entrada').AsInteger := FRegras.DadosNota.cdsNfc.FieldByName('id_geral').AsLargeInt;
    qry.ParamByName('cd_forma_pgto').AsInteger := 1;  //criar campos para informar forma e condição
    qry.ParamByName('cd_cond_pgto').AsInteger := 1;
    qry.ParamByName('valor').AsCurrency := edtValorTotalNota.ValueCurrency;
    qry.ParamByName('cd_usuario').AsInteger := idUsuario;
    qry.ParamByName('fl_entrada_saida').AsString := 'E';
    qry.ParamByName('dt_pgto').AsDateTime := Now;
    qry.ExecSQL;
    Conexao.Commit;
  finally
    qry.Free;
    idGeral.Free;
  end;
end;

procedure TfrmLancamentoNotaEntrada.AdicionaItem;
var
  aliquotas: TAliqProduto;
  idGeral: TGerador;
begin
  idGeral := TGerador.Create;

  try

    aliquotas := GetAliqProduto(FRegras.GetIdItem(edtCodProduto.Text));

    if FEdicaoItem then
      FRegras.DadosNota.cdsNfi.Edit
    else
      FRegras.DadosNota.cdsNfi.Append;

    FRegras.DadosNota.cdsNfi.FieldByName('id_geral').AsLargeInt := idGeral.GeraIdGeral;
    FRegras.DadosNota.cdsNfi.FieldByName('seq_item_nfi').AsInteger := FSeq;
    FRegras.DadosNota.cdsNfi.FieldByName('cd_produto').AsString := edtCodProduto.Text;
    FRegras.DadosNota.cdsNfi.FieldByName('descricao').AsString := edtDescricaoProduto.Text;
    FRegras.DadosNota.cdsNfi.FieldByName('un_medida').AsString := edtUnMedida.Text;
    FRegras.DadosNota.cdsNfi.FieldByName('qtd_estoque').AsFloat := edtQuantidade.ValueFloat;
    FRegras.DadosNota.cdsNfi.FieldByName('fator_conversao').AsInteger := edtFatorConversao.ValueInt;
    FRegras.DadosNota.cdsNfi.FieldByName('qtd_total').AsFloat := edtQuantidadeTotalProduto.ValueFloat;
    FRegras.DadosNota.cdsNfi.FieldByName('vl_unitario').AsCurrency := edtValorUnitario.ValueCurrency;
    FRegras.DadosNota.cdsNfi.FieldByName('valor_total').AsCurrency := edtValorTotalProduto.ValueCurrency;
    FRegras.DadosNota.cdsNfi.FieldByName('icms_vl_base').AsCurrency := edtValorTotalProduto.ValueCurrency;
    FRegras.DadosNota.cdsNfi.FieldByName('icms_pc_aliq').AsFloat := aliquotas.AliqIcms;
    FRegras.DadosNota.cdsNfi.FieldByName('icms_valor').AsCurrency := FRegras.CalculaImposto(edtValorTotalProduto.ValueCurrency,
                                                                                            aliquotas.AliqIcms, eICMS);
    FRegras.DadosNota.cdsNfi.FieldByName('ipi_vl_base').AsCurrency := edtValorTotalProduto.ValueCurrency;
    FRegras.DadosNota.cdsNfi.FieldByName('ipi_pc_aliq').AsFloat := aliquotas.AliqIPI;
    FRegras.DadosNota.cdsNfi.FieldByName('ipi_valor').AsCurrency := FRegras.CalculaImposto(edtValorTotalProduto.ValueCurrency,
                                                                                           aliquotas.AliqIPI, eIPI);
    FRegras.DadosNota.cdsNfi.FieldByName('pis_cofins_vl_base').AsCurrency := edtValorTotalProduto.ValueCurrency;
    FRegras.DadosNota.cdsNfi.FieldByName('pis_cofins_pc_aliq').AsFloat := aliquotas.AliqPisCofins;
    FRegras.DadosNota.cdsNfi.FieldByName('pis_cofins_valor').AsCurrency := FRegras.CalculaImposto(edtValorTotalProduto.ValueCurrency,
                                                                                                  aliquotas.AliqPisCofins, ePISCOFINS);
    FRegras.DadosNota.cdsNfi.FieldByName('id_item').AsLargeInt := FRegras.GetIdItem(edtCodProduto.Text);
    FRegras.DadosNota.cdsNfi.Post;
    FEdicaoItem := False;

  finally
    idGeral.Free;
    LimpaOutrosCampos;
  end;
end;

procedure TfrmLancamentoNotaEntrada.btnAddItensClick(Sender: TObject);
begin
  AdicionaItem;
end;

procedure TfrmLancamentoNotaEntrada.btnCancelarClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja Cancelar o Lançamento?','Atenção', MB_YESNO) = IDYES) then
    Close;
end;

procedure TfrmLancamentoNotaEntrada.btnConfirmarClick(Sender: TObject);
begin
  ValidaValoresNota;
  ConfirmarNota;
end;

procedure TfrmLancamentoNotaEntrada.CalculaQuantidadeTotalItem;
begin
  if edtQuantidade.ValueFloat = 0 then
    Exit;

  edtQuantidadeTotalProduto.ValueFloat := edtQuantidade.ValueFloat * edtFatorConversao.ValueInt;
end;

procedure TfrmLancamentoNotaEntrada.CalculaValorTotalItem;
begin
  if edtValorUnitario.ValueCurrency = 0 then
    Exit;

  edtValorTotalProduto.ValueCurrency := edtQuantidade.ValueFloat * edtValorUnitario.ValueCurrency;
end;

procedure TfrmLancamentoNotaEntrada.CarregaItensEdicao;
begin
  edtCodProduto.Text := FRegras.DadosNota.cdsNfi.FieldByName('cd_produto').AsString;
  edtDescricaoProduto.Text := FRegras.DadosNota.cdsNfi.FieldByName('descricao').AsString;
  edtUnMedida.Text := FRegras.DadosNota.cdsNfi.FieldByName('un_medida').AsString;
  edtQuantidade.ValueFloat := FRegras.DadosNota.cdsNfi.FieldByName('qtd_estoque').AsFloat;
  edtFatorConversao.ValueInt := FRegras.DadosNota.cdsNfi.FieldByName('fator_conversao').AsInteger;
  edtQuantidadeTotalProduto.ValueFloat := FRegras.DadosNota.cdsNfi.FieldByName('qtd_total').AsFloat;
  edtValorUnitario.ValueCurrency := FRegras.DadosNota.cdsNfi.FieldByName('vl_unitario').AsCurrency;
  edtValorTotalProduto.ValueCurrency := FRegras.DadosNota.cdsNfi.FieldByName('valor_total').AsCurrency;
  FEdicaoItem := True;
end;

procedure TfrmLancamentoNotaEntrada.ConfirmarNota;
var
  estoque: TMovimentacaoEstoque;
begin
  estoque := TMovimentacaoEstoque.Create;
  dm.conexaoBanco.StartTransaction;
  estoque.Conexao := dm.conexaoBanco;

  try
    try
      if FRegras.GravaCabecalho(dm.conexaoBanco) then
      begin
        if FRegras.GravaItens(dm.conexaoBanco) then
        begin
          estoque.InsereWmsMvto(FRegras.DadosNota.cdsNfi.FieldByName('id_item').AsInteger,
                                FRegras.DadosNota.cdsNfi.FieldByName('un_medida').AsString,
                                FRegras.DadosNota.cdsNfi.FieldByName('qtd_estoque').AsFloat,
                                'E');

          estoque.AtualizaEstoque(FRegras.DadosNota.cdsNfi.FieldByName('id_item').AsInteger,
                                  FRegras.DadosNota.cdsNfi.FieldByName('qtd_estoque').AsFloat,
                                  'E');
        end;
      end;

      dm.conexaoBanco.Commit;
      LancaFinanceiro(dm.conexaoBanco);

      ShowMessage('Nota gravada com sucesso!');
      limpaCampos;

    except
      on E : exception do
      begin
        dm.conexaoBanco.Rollback;
        ShowMessage('Erro ao gravar os dados da nota ' + edtNroNota.Text + E.Message);
        Exit;
      end;
    end;
  finally
    estoque.Free;
    dm.conexaoBanco.Rollback;
  end;
end;

procedure TfrmLancamentoNotaEntrada.DBGridProdutosDblClick(Sender: TObject);
begin
  CarregaItensEdicao;
end;

procedure TfrmLancamentoNotaEntrada.DBGridProdutosKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if (Application.MessageBox('Deseja realmente Excluir?','Atenção', MB_YESNO) = IDYES) then
    begin
      FRegras.DadosNota.cdsNfi.Delete;
      edtCodProduto.SetFocus;
      FSeq := FSeq - 1;
    end;
  end;
end;

destructor TfrmLancamentoNotaEntrada.Destroy;
begin
  FRegras.Free;
  inherited;
end;

procedure TfrmLancamentoNotaEntrada.edtValorAcrescimoExit(Sender: TObject);
begin
  ValorTotalNota;
end;

procedure TfrmLancamentoNotaEntrada.edtValorDescontoExit(Sender: TObject);
begin
  ValorTotalNota;
end;

procedure TfrmLancamentoNotaEntrada.edtValorFreteExit(Sender: TObject);
begin
  ValorTotalNota;
end;

procedure TfrmLancamentoNotaEntrada.edtValorIPIExit(Sender: TObject);
begin
  ValorTotalNota;
end;

procedure TfrmLancamentoNotaEntrada.edtValorOutrasDespesasExit(Sender: TObject);
begin
  ValorTotalNota;
  PreencheDatasetNFC;
end;

procedure TfrmLancamentoNotaEntrada.edtValorUnitarioChange(Sender: TObject);
begin
  CalculaValorTotalItem;
end;

procedure TfrmLancamentoNotaEntrada.ValidaValoresNota;
var
  vlTotalItens : Double;
begin
  vlTotalItens := 0;

  FRegras.DadosNota.cdsNfi.Loop(
  procedure
  begin
    vlTotalItens := vlTotalItens + FRegras.DadosNota.cdsNfi.FieldByName('valor_total').AsCurrency;
  end);

  if vlTotalItens <> (edtVlProduto.ValueCurrency
                      - edtValorDesconto.ValueCurrency
                      + edtValorAcrescimo.ValueCurrency
                      + edtValorOutrasDespesas.ValueCurrency) then
    raise Exception.Create(' O valor total dos itens não fecha com o valor total da nota! Verifique.');
end;

procedure TfrmLancamentoNotaEntrada.ValorTotalNota;
var
  vlTotal: Currency;
begin
  vlTotal := 0;

  if edtVlServico.ValueCurrency > 0 then
    vlTotal := vlTotal + edtVlServico.ValueCurrency
  else if edtVlProduto.ValueCurrency > 0 then
    vlTotal := vlTotal + edtVlProduto.ValueCurrency
                       + edtValorFrete.ValueCurrency
                       + edtValorIPI.ValueCurrency
                       + edtValorAcrescimo.ValueCurrency
                       + edtValorOutrasDespesas.ValueCurrency
                       - edtValorDesconto.ValueCurrency;

  edtValorTotalNota.ValueCurrency := vlTotal;
end;

end.
