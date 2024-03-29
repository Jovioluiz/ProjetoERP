unit uVisualizaPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.UITypes, Datasnap.DBClient, uclPedidoVenda,
  Vcl.NumberBox;
  //JvExStdCtrls, JvBehaviorLabel, frxClass, frxDBSet;

type
  TfrmVisualizaPedidoVenda = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtNrPedido: TEdit;
    Label2: TLabel;
    edtCdCliente: TEdit;
    edtNomeCliente: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtCidadeCliente: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtCdFormaPgto: TEdit;
    edtCdCondPgto: TEdit;
    edtNomeFormaPgto: TEdit;
    edtNomeCondPgto: TEdit;
    dbGridProdutos: TDBGrid;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    btnCancelar: TButton;
    edtFl_orcamento: TCheckBox;
    btnEditarPedido: TButton;
    btnImprimir: TButton;
    btnSalvar: TButton;
    lblStatus: TLabel;
    edtVlTotalPedido: TNumberBox;
    edtVlAcrescimoTotalPedido: TNumberBox;
    edtVlDescTotalPedido: TNumberBox;

    procedure dbGridProdutosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEditarPedidoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCdCondPgtoChange(Sender: TObject);
    procedure edtNrPedidoExit(Sender: TObject);
    procedure dbGridProdutosTitleClick(Column: TColumn);
  private
    FPedidoVenda: TPedidoVenda;
    procedure SetPedidoVenda(const Value: TPedidoVenda);
    procedure CarregaPedidoVenda;
    { Private declarations }
  public
    { Public declarations }
    property PedidoVenda: TPedidoVenda read FPedidoVenda write SetPedidoVenda;
  end;

var
  frmVisualizaPedidoVenda: TfrmVisualizaPedidoVenda;

implementation

{$R *.dfm}

uses uDataModule, uUtil, uPedidoVenda;


procedure TfrmVisualizaPedidoVenda.btnCancelarClick(Sender: TObject);
begin
  if MessageDlg('Deseja realmente fechar?', mtConfirmation,[mbYes, mbNo], 0) = 6 then
    Close;
end;


procedure TfrmVisualizaPedidoVenda.btnEditarPedidoClick(Sender: TObject);
begin
  if not edtFl_orcamento.Checked then
  begin
    MessageDlg('O pedido n�o pode ser editado', mtWarning, [mbOK],0);
    Exit;
  end;

  PedidoVenda.EditarPedido(StrToInt(edtNrPedido.Text));
end;


procedure TfrmVisualizaPedidoVenda.btnImprimirClick(Sender: TObject);
begin
  ShowMessage('nada implementado');
//  qry.ParamByName('nr_pedido').AsInteger := StrToInt(edtNrPedido.Text);
//  qry.Open();
  //frxRelatorio.LoadFromFile(GetCurrentDir + '\rel\relPedidoVenda.fr3');
  //frxRelatorio.ShowReport();
end;

procedure TfrmVisualizaPedidoVenda.CarregaPedidoVenda;
begin
  if FPedidoVenda.CarregaPedidoVenda(StrToInt(edtNrPedido.Text)) then
  begin
    edtFl_orcamento.Checked := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('fl_orcamento').AsBoolean;
    edtCdCliente.Text := IntToStr(FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('cd_cliente').AsInteger);
    edtNomeCliente.Text := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('nm_cliente').AsString;
    edtCdFormaPgto.Text := IntToStr(FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('cd_forma_pag').AsInteger);
    edtNomeFormaPgto.Text := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('nm_forma_pgto').AsString;
    edtCdCondPgto.Text := IntToStr(FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('cd_cond_pag').AsInteger);
    edtNomeCondPgto.Text := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('nm_cond_pgto').AsString;
    edtVlDescTotalPedido.ValueCurrency := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('vl_desconto_pedido').AsCurrency;
    edtVlAcrescimoTotalPedido.ValueCurrency := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('vl_acrescimo').AsCurrency;
    edtVlTotalPedido.ValueCurrency := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('vl_total').AsCurrency;
    edtCidadeCliente.Text := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('cidade').AsString;
    lblStatus.Visible := FPedidoVenda.Dados.cdsPedidoVenda.FieldByName('fl_cancelado').AsString = 'S';
  end
  else
  begin
    ShowMessage('Pedido n�o Encontrado! Verifique');
    edtCdCliente.Clear;
    edtCidadeCliente.Clear;
    edtCdFormaPgto.Clear;
    edtCdCondPgto.Clear;
    edtNomeCliente.Clear;
    edtNomeFormaPgto.Clear;
    edtNomeCondPgto.Clear;
    edtNrPedido.SetFocus;
  end;
end;

//Faz a linha zebrada no grid dos itens
procedure TfrmVisualizaPedidoVenda.dbGridProdutosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with dbGridProdutos do
  begin
    if Odd(DataSource.DataSet.RecNo) then
      Canvas.Brush.Color := clSilver
    else
      Canvas.Brush.Color := clWindow;

    Canvas.FillRect(Rect);
    DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfrmVisualizaPedidoVenda.dbGridProdutosTitleClick(Column: TColumn);
begin
  if FPedidoVenda.Dados.cdsPedidoVendaItem.IndexFieldNames = Column.FieldName then
    FPedidoVenda.Dados.cdsPedidoVendaItem.IndexFieldNames := Column.FieldName + ':D'
  else
    FPedidoVenda.Dados.cdsPedidoVendaItem.IndexFieldNames := Column.FieldName;
end;

procedure TfrmVisualizaPedidoVenda.edtCdCondPgtoChange(Sender: TObject);
begin
  if edtCdCondPgto.Text <> '' then
    edtNomeCondPgto.Text := FPedidoVenda.BuscaCondicaoPgto(StrToInt(edtCdCondPgto.Text), StrToInt(edtCdFormaPgto.Text));
end;

procedure TfrmVisualizaPedidoVenda.edtNrPedidoExit(Sender: TObject);
begin
  CarregaPedidoVenda;
end;

procedure TfrmVisualizaPedidoVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FPedidoVenda.Free;
  frmVisualizaPedidoVenda := nil;
end;

procedure TfrmVisualizaPedidoVenda.FormCreate(Sender: TObject);
begin
  lblStatus.Visible := False;
  FPedidoVenda := TPedidoVenda.Create;
  dbGridProdutos.DataSource := FPedidoVenda.Dados.dsPedidoVendaItem;
end;

procedure TfrmVisualizaPedidoVenda.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmVisualizaPedidoVenda.SetPedidoVenda(const Value: TPedidoVenda);
begin
  FPedidoVenda := Value;
end;

end.
