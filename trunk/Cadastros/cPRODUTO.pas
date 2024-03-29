unit cPRODUTO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, Vcl.StdCtrls,
  Data.FMTBcd, Data.DB, Data.SqlExpr, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.Comp.Client,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, Vcl.Buttons, Vcl.DBCtrls, Jpeg, dProdutoCodBarras,
  uclProduto;

type
  TfrmCadProduto = class(TForm)
    PageControl1: TPageControl;
    TabSheetCadastroProduto: TTabSheet;
    Label1: TLabel;
    edtPRODUTOCD_PRODUTO: TEdit;
    Label2: TLabel;
    edtPRODUTODESCRICAO: TEdit;
    ckPRODUTOATIVO: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtPRODUTOUN_MEDIDA: TEdit;
    edtPRODUTOFATOR_CONVERSAO: TEdit;
    edtPRODUTOPESO_BRUTO: TEdit;
    edtPRODUTOPESO_LIQUIDO: TEdit;
    memoObservacao: TMemo;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DBGridCodigoBarras: TDBGrid;
    edtCodigoBarras: TEdit;
    btnAddCodBarras: TButton;
    TabSheet1: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtProdutoGrupoTributacaoICMS: TEdit;
    edtProdutoGrupoTributacaoIPI: TEdit;
    edtProdutoGrupoTributacaoPISCOFINS: TEdit;
    edtProdutoNomeGrupoTributacaoICMS: TEdit;
    edtProdutoNomeGrupoTributacaoIPI: TEdit;
    edtProdutoNomeGrupoTributacaoPISCOFINS: TEdit;
    tImagem: TImage;
    Label13: TLabel;
    Button1: TButton;
    btnCarregarImagem: TButton;
    dlgImagem: TOpenDialog;
    cbTipoCodBarras: TComboBox;
    edtUnCodBarras: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    cbLancaAutoPedidoVenda: TCheckBox;
    procedure btnPRODUTOCANCELARClick(Sender: TObject);
    procedure edtPRODUTOCD_PRODUTOExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtProdutoGrupoTributacaoICMSChange(Sender: TObject);
    procedure edtProdutoGrupoTributacaoIPIChange(Sender: TObject);
    procedure edtProdutoGrupoTributacaoPISCOFINSChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCarregarImagemClick(Sender: TObject);
    procedure tImagemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAddCodBarrasClick(Sender: TObject);
    procedure DBGridCodigoBarrasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edtPRODUTOCD_PRODUTOKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPRODUTOCD_PRODUTOEnter(Sender: TObject);
  private
    FRegra: TProdutoCodigoBarras;
    FIdItem: Int64;
    { Private declarations }
    procedure LimpaCampos;
    procedure Salvar;
    procedure Excluir;
    procedure validaCampos;
    procedure listarCodBarras;
    procedure desabilitaCampos;
    procedure validaCamposCodBarra;
    procedure SalvarCodBarras;
    procedure SalvarFoto;
    procedure SalvarTributacao;
    function carregaImagem(Aimagem: TImage; ABlobField: TBlobField): Boolean;
    function GetIdItem(const CdItem: string): Int64;
    procedure CarregaProduto(const CodItem: String);
  public
    { Public declarations }

    var NomeImg : string;

    property Regra: TProdutoCodigoBarras read FRegra;
  end;

var
  frmCadProduto: TfrmCadProduto;
  camposDesabilitados : Boolean;
  img: TPicture;

implementation

{$R *.dfm}

uses uDataModule, uUtil, uLogin, uConsulta, uclProdutoTributacao;

procedure TfrmCadProduto.btnAddCodBarrasClick(Sender: TObject);
var
  tipo: string;
begin
  validaCamposCodBarra;

  Regra.Dados.dsBarras.DataSet.Active := True;

  case cbTipoCodBarras.ItemIndex of
    0: tipo := 'Interno';
    1: tipo := 'GTIN';
    2: tipo := 'Outro';
  end;

  Regra.Dados.cdsBarras.AppendRecord([edtUnCodBarras.Text, tipo, edtCodigoBarras.Text]);

  cbTipoCodBarras.ItemIndex := -1;
  edtUnCodBarras.Clear;
  edtCodigoBarras.Clear;
end;

procedure TfrmCadProduto.btnCarregarImagemClick(Sender: TObject);
begin
  if dlgImagem.Execute then
    tImagem.Picture.LoadFromFile(dlgImagem.FileName);
end;

procedure TfrmCadProduto.btnPRODUTOCANCELARClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja realmente fechar?','Aten��o', MB_YESNO) = IDYES) then
    Close;
end;

function TfrmCadProduto.carregaImagem(Aimagem: TImage; ABlobField: TBlobField): Boolean;
var
  JpgImg: TJPEGImage;
  memoryStream: TMemoryStream;
begin
  Result := True;
  if ABlobField.DataSet.IsEmpty then
    Exit(False);

  Aimagem.Picture.Assign(nil);

  if not (ABlobField.IsNull) and not (ABlobField.AsString = '') then
  begin
    jpgImg := TJPEGImage.Create;
    memoryStream := TMemoryStream.Create;
    try
      ABlobField.SaveToStream(memoryStream);
      memoryStream.Position := 0;
      memoryStream.Seek(0,0);
      JpgImg.LoadFromStream(memoryStream);
      Aimagem.Picture.Assign(JpgImg);
    finally
      memoryStream.Free;
      JpgImg.Free;
    end;
  end;
end;

procedure TfrmCadProduto.CarregaProduto(const CodItem: String);
const
  sql = 'select                                             '+
        '    fl_ativo,                                      '+
        '    desc_produto,                                  '+
        '    un_medida,                                     '+
        '    fator_conversao,                               '+
        '    peso_liquido,                                  '+
        '    peso_bruto,                                    '+
        '    observacao,                                    '+
        '    imagem,                                        '+
        '    pt.cd_tributacao_icms,                         '+
        '    gti.nm_tributacao_icms,                        '+
        '    pt.cd_tributacao_ipi,                          '+
        '    gtipi.nm_tributacao_ipi,                       '+
        '    pt.cd_tributacao_pis_cofins,                   '+
        '    gtpc.nm_tributacao_pis_cofins,                 '+
        '    lanca_auto_pedido_venda                        '+
        'from                                               '+
        '    produto p                                      '+
        'left join produto_tributacao pt on                 '+
        '    p.id_item = pt.id_item                         '+
        'left join grupo_tributacao_icms gti on             '+
        '    pt.cd_tributacao_icms = gti.cd_tributacao      '+
        'left join grupo_tributacao_ipi gtipi on            '+
        '    pt.cd_tributacao_ipi = gtipi.cd_tributacao     '+
        'left join grupo_tributacao_pis_cofins gtpc on      '+
        '    pt.cd_tributacao_pis_cofins = gtpc.cd_tributacao '+
        'where                                              '+
        '    p.cd_produto = :cd_produto';
var
  produto: TUtil;
  qry: TFDQuery;
begin
  //implementar para gerar o id_item do produto caso esteja cadastrando um novo produto
  if edtPRODUTOCD_PRODUTO.isEmpty then
  begin
    edtPRODUTOCD_PRODUTO.SetFocus;
    raise Exception.Create('C�digo n�o pode ser vazio');
  end;

  qry := TFDQuery.Create(Self);
  produto := TUtil.Create;
  
  try
    FIdItem := GetIdItem(edtPRODUTOCD_PRODUTO.Text);
    qry.Connection := dm.conexaoBanco;
    qry.Open(sql, [CodItem]);

    if (produto.ValidaEdicaoAcao(idUsuario, 2).Equals('N')) and (qry.IsEmpty) then
    begin
      edtPRODUTOCD_PRODUTO.SetFocus;
      raise Exception.Create('Usu�rio n�o possui Permiss�o para realizar Cadastro');
    end;

    ckPRODUTOATIVO.Checked := qry.FieldByName('fl_ativo').AsBoolean;
    edtPRODUTODESCRICAO.Text := qry.FieldByName('desc_produto').AsString;
    edtPRODUTOUN_MEDIDA.Text := qry.FieldByName('un_medida').AsString;
    edtPRODUTOFATOR_CONVERSAO.Text := CurrToStr(qry.FieldByName('fator_conversao').AsCurrency);
    edtPRODUTOPESO_LIQUIDO.Text := CurrToStr(qry.FieldByName('peso_liquido').AsCurrency);
    edtPRODUTOPESO_BRUTO.Text := CurrToStr(qry.FieldByName('peso_bruto').AsCurrency);
    memoObservacao.Text := qry.FieldByName('observacao').AsString;
    cbLancaAutoPedidoVenda.Checked := qry.FieldByName('lanca_auto_pedido_venda').AsBoolean;
    if qry.FieldByName('cd_tributacao_icms').AsInteger > 0 then
      edtProdutoGrupoTributacaoICMS.Text := qry.FieldByName('cd_tributacao_icms').Value;
    edtProdutoNomeGrupoTributacaoICMS.Text := qry.FieldByName('nm_tributacao_icms').AsString;
    if qry.FieldByName('cd_tributacao_ipi').AsInteger > 0 then
      edtProdutoGrupoTributacaoIPI.Text := qry.FieldByName('cd_tributacao_ipi').Value;
    edtProdutoNomeGrupoTributacaoIPI.Text := qry.FieldByName('nm_tributacao_ipi').AsString;
    if qry.FieldByName('cd_tributacao_pis_cofins').AsInteger > 0 then
      edtProdutoGrupoTributacaoPISCOFINS.Text := qry.FieldByName('cd_tributacao_pis_cofins').Value;
    edtProdutoNomeGrupoTributacaoPISCOFINS.Text := qry.FieldByName('nm_tributacao_pis_cofins').AsString;

    carregaImagem(tImagem, TBlobField(qry.FieldByName('imagem')));
    listarCodBarras;
    if produto.ValidaEdicaoAcao(idUsuario, 2).Equals('N') then
      desabilitaCampos;
  finally
    qry.Free;
    produto.Free;
  end;
end;

procedure TfrmCadProduto.DBGridCodigoBarrasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if Key = VK_DELETE then
   begin
     if MessageDlg('Deseja excluir o c�digo de barras?', mtConfirmation,[mbYes,mbNo], 0) = mrYes then
     begin
      FRegra.id_item := GetIdItem(edtPRODUTOCD_PRODUTO.Text);
      FRegra.codigo_barras := FRegra.Dados.cdsBarras.FieldByName('codigo_barras').AsString;
      FRegra.un_medida := FRegra.Dados.cdsBarras.FieldByName('un_medida').AsString;
      FRegra.Excluir;
      FRegra.Dados.cdsBarras.Delete;

      edtPRODUTOCD_PRODUTO.SetFocus;
     end;
   end;
   listarCodBarras;
end;

procedure TfrmCadProduto.desabilitaCampos;
begin
  edtPRODUTOCD_PRODUTO.Enabled := false;
  edtPRODUTODESCRICAO.Enabled := false;
  edtPRODUTOUN_MEDIDA.Enabled := false;
  edtPRODUTOFATOR_CONVERSAO.Enabled := false;
  edtPRODUTOPESO_BRUTO.Enabled := false;
  edtPRODUTOPESO_LIQUIDO.Enabled := false;
  edtCodigoBarras.Enabled := false;
  edtProdutoGrupoTributacaoICMS.Enabled := false;
  edtProdutoGrupoTributacaoIPI.Enabled := false;
  edtProdutoGrupoTributacaoPISCOFINS.Enabled := false;
  edtProdutoNomeGrupoTributacaoICMS.Enabled := false;
  edtProdutoNomeGrupoTributacaoIPI.Enabled := false;
  edtProdutoNomeGrupoTributacaoPISCOFINS.Enabled := false;
  cbTipoCodBarras.Enabled := false;
  ckPRODUTOATIVO.Enabled := false;
  btnAddCodBarras.Enabled := false;
  btnCarregarImagem.Enabled := false;
  memoObservacao.Enabled := false;
  edtUnCodBarras.Enabled := false;
  DBGridCodigoBarras.Enabled := False;
  camposDesabilitados := True;
end;

procedure TfrmCadProduto.edtPRODUTOCD_PRODUTOEnter(Sender: TObject);
begin
  if edtPRODUTOCD_PRODUTO.Text <> '' then
    edtPRODUTOCD_PRODUTOExit(nil);
end;

procedure TfrmCadProduto.edtPRODUTOCD_PRODUTOExit(Sender: TObject);
begin
  CarregaProduto(edtPRODUTOCD_PRODUTO.Text);
end;

procedure TfrmCadProduto.edtPRODUTOCD_PRODUTOKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
const
  sql = 'select cd_produto, desc_produto, un_medida, fator_conversao, peso_bruto, peso_liquido, observacao from produto';
var
  consulta: TfrmConsulta;
begin
  consulta := TfrmConsulta.Create(Self);
  if key = VK_F9 then
  begin
    //chamada := 'cntProduto';
    consulta.MontaDataset(sql);
    consulta.Show;
  end;
end;

procedure TfrmCadProduto.edtProdutoGrupoTributacaoICMSChange(Sender: TObject);
const
  sql = 'select '+
        ' cd_tributacao, '+
        ' nm_tributacao_icms '+
        'from '+
        ' grupo_tributacao_icms '+
        'where '+
        ' cd_tributacao = :cd_tributacao';
var
  qry: TFDQuery;
begin
  inherited;
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Close;
  qry.SQL.Clear;

  if edtProdutoGrupoTributacaoICMS.isEmpty then
  begin
    edtProdutoGrupoTributacaoICMS.Text := '';
    edtProdutoNomeGrupoTributacaoICMS.Text := '';
    Exit;
  end;

  qry.SQL.Add(sql);
  qry.ParamByName('cd_tributacao').AsInteger := StrToInt(edtProdutoGrupoTributacaoICMS.Text);
  qry.Open(sql);
  edtProdutoNomeGrupoTributacaoICMS.Text := qry.FieldByName('nm_tributacao_icms').AsString;
end;

procedure TfrmCadProduto.edtProdutoGrupoTributacaoIPIChange(Sender: TObject);
const
  sql = 'select '+
        ' cd_tributacao, '+
        ' nm_tributacao_ipi '+
        'from '+
        ' grupo_tributacao_ipi '+
        'where '+
        ' cd_tributacao = :cd_tributacao';
var
  qry: TFDQuery;
begin
  inherited;
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Close;
  qry.SQL.Clear;

  if edtProdutoGrupoTributacaoIPI.isEmpty then
  begin
    edtProdutoGrupoTributacaoIPI.Text := '';
    edtProdutoNomeGrupoTributacaoIPI.Text := '';
    Exit;
  end;

  qry.SQL.Add(sql);
  qry.ParamByName('cd_tributacao').AsInteger := StrToInt(edtProdutoGrupoTributacaoIPI.Text);
  qry.Open(sql);
  edtProdutoNomeGrupoTributacaoIPI.Text := qry.FieldByName('nm_tributacao_ipi').AsString;
end;

procedure TfrmCadProduto.edtProdutoGrupoTributacaoPISCOFINSChange(Sender: TObject);
const
  sql = 'select '+
        ' cd_tributacao, '+
        ' nm_tributacao_pis_cofins '+
        'from '+
        ' grupo_tributacao_pis_cofins '+
        'where '+
        ' cd_tributacao = :cd_tributacao';
var
  qry: TFDQuery;
begin
  inherited;
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.Close;
  qry.SQL.Clear;

  if edtProdutoGrupoTributacaoPISCOFINS.isEmpty then
  begin
    edtProdutoGrupoTributacaoPISCOFINS.Text := '';
    edtProdutoNomeGrupoTributacaoPISCOFINS.Text := '';
    Exit;
  end;

  qry.SQL.Add(sql);
  qry.ParamByName('cd_tributacao').AsInteger := StrToInt(edtProdutoGrupoTributacaoPISCOFINS.Text);
  qry.Open(sql);
  edtProdutoNomeGrupoTributacaoPISCOFINS.Text := qry.FieldByName('nm_tributacao_pis_cofins').AsString;
end;


procedure TfrmCadProduto.Excluir;
var
  persistencia: TProduto;
begin
  persistencia := TProduto.Create;

  try
    if edtPRODUTOCD_PRODUTO.Text <> '' then
    begin
      if (Application.MessageBox('Deseja Excluir o Produto?','Aten��o', MB_YESNO) = IDYES) then
      begin
        persistencia.id_item := FIdItem;
        persistencia.Excluir;
        LimpaCampos;
      end;
    end;
  finally
    persistencia.Free;
  end;
end;

procedure TfrmCadProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frmCadProduto := nil;
  FRegra.Free;
end;

procedure TfrmCadProduto.FormCreate(Sender: TObject);
begin
  TabSheetCadastroProduto.Show;
  FRegra := TProdutoCodigoBarras.Create;
end;

procedure TfrmCadProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_F3 then //F3
    LimpaCampos
  else if key = VK_F2 then  //F2
    Salvar
  else if key = VK_F4 then    //F4
    Excluir
  else if key = VK_ESCAPE then //ESC
    if (Application.MessageBox('Deseja Fechar?','Aten��o', MB_YESNO) = IDYES) then
      Close;
end;

procedure TfrmCadProduto.FormKeyPress(Sender: TObject; var Key: Char);
begin
//passa pelos campos pressionando enter
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

function TfrmCadProduto.GetIdItem(const CdItem: string): Int64;
const
  SQL = 'select id_item from produto where cd_produto = :cd_produto';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.ParamByName('cd_produto').AsString := CdItem;
    qry.Open();

    Result := qry.FieldByName('id_item').AsLargeInt;

  finally
    qry.Free;
  end;
end;

procedure TfrmCadProduto.tImagemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbRight then
  begin
    if (Application.MessageBox('Deseja Excluir a Imagem do Produto?', 'Aviso', MB_YESNO) = IDYES) then
    begin
      tImagem.Picture := nil;
      dm.conexaoBanco.ExecSQL('update produto set imagem = NULL where cd_produto = :cd_produto',
                                                      [StrToInt(edtPRODUTOCD_PRODUTO.Text)]);
    end;
  end;
end;

procedure TfrmCadProduto.LimpaCampos;
begin
  if camposDesabilitados then
  begin
    edtPRODUTOCD_PRODUTO.Enabled := true;
    edtPRODUTODESCRICAO.Enabled := true;
    edtPRODUTOUN_MEDIDA.Enabled := true;
    edtPRODUTOFATOR_CONVERSAO.Enabled := true;
    edtPRODUTOPESO_BRUTO.Enabled := true;
    edtPRODUTOPESO_LIQUIDO.Enabled := true;
    edtCodigoBarras.Enabled := true;
    edtProdutoGrupoTributacaoICMS.Enabled := true;
    edtProdutoGrupoTributacaoIPI.Enabled := true;
    edtProdutoGrupoTributacaoPISCOFINS.Enabled := true;
    edtProdutoNomeGrupoTributacaoICMS.Enabled := true;
    edtProdutoNomeGrupoTributacaoIPI.Enabled := true;
    edtProdutoNomeGrupoTributacaoPISCOFINS.Enabled := true;
    cbTipoCodBarras.Enabled := true;
    ckPRODUTOATIVO.Enabled := true;
    btnAddCodBarras.Enabled := true;
    btnCarregarImagem.Enabled := true;
    memoObservacao.Enabled := true;
    edtUnCodBarras.Enabled := true;
    camposDesabilitados := false;
  end;

  edtPRODUTOCD_PRODUTO.Clear;
  edtPRODUTODESCRICAO.Clear;
  edtPRODUTOUN_MEDIDA.Clear;
  edtPRODUTOFATOR_CONVERSAO.Clear;
  edtPRODUTOPESO_BRUTO.Clear;
  edtPRODUTOPESO_LIQUIDO.Clear;
  edtCodigoBarras.Clear;
  edtProdutoGrupoTributacaoICMS.Clear;
  edtProdutoGrupoTributacaoIPI.Clear;
  edtProdutoGrupoTributacaoPISCOFINS.Clear;
  edtProdutoNomeGrupoTributacaoICMS.Clear;
  edtProdutoNomeGrupoTributacaoIPI.Clear;
  edtProdutoNomeGrupoTributacaoPISCOFINS.Clear;
  memoObservacao.Clear;
  edtUnCodBarras.Clear;
  edtPRODUTOCD_PRODUTO.SetFocus;
  tImagem.Picture := nil;
  TabSheetCadastroProduto.Show;//se estiver em outra aba, sempre volta para a primeira aba
  cbLancaAutoPedidoVenda.Checked := False;
  FRegra.Dados.cdsBarras.EmptyDataSet;
end;

procedure TfrmCadProduto.listarCodBarras;
const
  sql = 'select ' +
        '   un_medida, ' +
        'case          ' +
        '   when tipo_cod_barras = 0 then ''Interno'' ' +
        '   when tipo_cod_barras = 1 then ''GTIN''    ' +
        '   else ''Outro''       ' +
        'end tipo_cod_barras, ' +
        '   codigo_barras '+
        'from '+
        '	  produto_cod_barras '+
        'where '+
        '	  id_item = :id_item ';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    FRegra.Dados.cdsBarras.EmptyDataSet;

    qry.Open(sql, [FIdItem]);

    qry.Loop(
    procedure
    begin
      FRegra.Dados.cdsBarras.AppendRecord([qry.FieldByName('un_medida').AsString,
                                           qry.FieldByName('tipo_cod_barras').AsString,
                                           qry.FieldByName('codigo_barras').AsString]);
    end);

  finally
    qry.Free;
  end;
end;

procedure TfrmCadProduto.SalvarFoto;
const
  sql = 'update produto set imagem = :imagem where cd_produto = :cd_produto';
var
  qry: TFDQuery;
  Imagem: TFileStream;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    try
      if dlgImagem.FileName <> '' then
      begin
        Imagem := TFileStream.Create(dlgImagem.FileName, fmOpenRead or fmShareDenyWrite);
        qry.SQL.Add(sql);
        qry.ParamByName('imagem').LoadFromStream(Imagem, ftBlob);
        qry.ParamByName('cd_produto').AsString := edtPRODUTOCD_PRODUTO.Text;
        qry.ExecSQL;

        qry.Connection.Commit;
      end;
    except
    on E:Exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar a foto do produto ' + E.Message);
      end;
    end;
  finally
    qry.Connection.Rollback;
    qry.Free;
  end;
end;

procedure TfrmCadProduto.SalvarTributacao;
var
  persistencia: TProdutoTributacao;
begin
  persistencia := TProdutoTributacao.Create;

  try
    persistencia.id_item := FIdItem;
    persistencia.cd_tributacao_icms := StrToInt(edtProdutoGrupoTributacaoICMS.Text);
    persistencia.cd_tributacao_ipi := StrToInt(edtProdutoGrupoTributacaoIPI.Text);
    persistencia.cd_tributacao_pis_cofins := StrToInt(edtProdutoGrupoTributacaoPISCOFINS.Text);

    if not persistencia.Pesquisar(FIdItem) then
      persistencia.Inserir
    else
      persistencia.Atualizar;

  finally
    persistencia.Free;
  end;
end;

procedure TfrmCadProduto.Salvar;
var
  persistencia: TProduto;
begin
  validaCampos;

  persistencia := TProduto.Create;

  try
    persistencia.cd_produto := edtPRODUTOCD_PRODUTO.Text;
    persistencia.fl_ativo := ckPRODUTOATIVO.Checked;
    persistencia.desc_produto := edtPRODUTODESCRICAO.Text;
    persistencia.un_medida := edtPRODUTOUN_MEDIDA.Text;
    persistencia.fator_conversao := StrToInt(edtPRODUTOFATOR_CONVERSAO.Text);
    persistencia.peso_liquido := StrToFloat(edtPRODUTOPESO_LIQUIDO.Text);
    persistencia.peso_bruto := StrToFloat(edtPRODUTOPESO_BRUTO.Text);
    persistencia.observacao := memoObservacao.Text;
    persistencia.lanca_auto_pedido_venda := cbLancaAutoPedidoVenda.Checked;

    if not persistencia.Pesquisar(FIdItem) then
    begin
      FIdItem := persistencia.GeraIdItem;
      persistencia.id_item := FIdItem;
      persistencia.Inserir;
    end
    else
    begin
      persistencia.id_item := FIdItem;
      persistencia.Atualizar;
    end;

    SalvarTributacao;
    SalvarCodBarras;
    SalvarFoto;
    LimpaCampos;

  finally
    persistencia.Free;
  end;
end;

procedure TfrmCadProduto.SalvarCodBarras;
begin
  try
    FRegra.id_item := FIdItem;

    FRegra.Dados.cdsBarras.Loop(
    procedure
    begin
      FRegra.codigo_barras := FRegra.Dados.cdsBarras.FieldByName('codigo_barras').AsString;
      FRegra.un_medida := FRegra.Dados.cdsBarras.FieldByName('un_medida').AsString;

      if not FRegra.Pesquisar(FIdItem, FRegra.Dados.cdsBarras.FieldByName('codigo_barras').AsString) then
        FRegra.Inserir;
    end);

  except
    on E:exception do
        raise Exception.Create('Erro ao gravar os dados do c�digo de barras do produto ' + E.Message);
  end;
end;

procedure TfrmCadProduto.validaCampos;
begin
  if (edtPRODUTOCD_PRODUTO.Text = EmptyStr) or (edtPRODUTODESCRICAO.Text = EmptyStr)
    or (edtPRODUTOUN_MEDIDA.Text = EmptyStr) then
  begin
    raise Exception.Create('C�digo, Descri��o e Unidade de Medida n�o podem ser vazios');
  end
  else if (edtProdutoGrupoTributacaoICMS.Text = EmptyStr) or (edtProdutoGrupoTributacaoIPI.Text = EmptyStr) 
        or (edtProdutoGrupoTributacaoPISCOFINS.Text = EmptyStr) then
  begin
    raise Exception.Create('Preencha os tipos de Tributa��o do produto!');
  end;
end;

procedure TfrmCadProduto.validaCamposCodBarra;
begin
  if (Trim(edtCodigoBarras.Text) = EmptyStr)
      or (Trim(edtUnCodBarras.Text) = EmptyStr)
      or (cbTipoCodBarras.ItemIndex = -1) then
    raise Exception.Create('Campos n�o podem ser vazios');

  if FRegra.Dados.cdsBarras.Locate('un_medida', VarArrayOf([edtUnCodBarras.Text]), []) then
    raise Exception.Create('O produto j� possui c�digo de barras cadastrado para a unidade de medida informada');

end;

end.
