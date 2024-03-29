unit uTelaInicial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, cCLIENTE,
  cPRODUTO,
  cCTA_FORMA_PAGAMENTO, Vcl.ExtCtrls, cCTA_COND_PGTO, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage, uCadTABELAPRECO, uPedidoVenda, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uVisualizaPedidoVenda, UfrmRelVendaDiaria,
  uLancamentoNotaEntrada, uCadastroTributacaoItem, Vcl.ComCtrls, uLogin, FConsultaProduto,
  uConfiguracoes, uUtil, uLista, Vcl.AppEvnts;

type
  TfrmPrincipal = class(TForm)
    MenuCadastro: TMainMenu;
    MenuItemCad: TMenuItem;
    Cadastro1: TMenuItem;
    Cliente1: TMenuItem;
    Produto1: TMenuItem;
    FormaPagamento1: TMenuItem;
    CondicaoPagamento1: TMenuItem;
    Sistem1: TMenuItem;
    Sair1: TMenuItem;
    Consulta1: TMenuItem;
    TabeladePreo1: TMenuItem;
    PedidoVenda1: TMenuItem;
    PedidodeVenda1: TMenuItem;
    VisualizarPedidoVenda1: TMenuItem;
    Relatrios1: TMenuItem;
    VendaDiria1: TMenuItem;
    LanamentoNotas1: TMenuItem;
    NotaEntrada1: TMenuItem;
    ipoTributao1: TMenuItem;
    Cadastro2: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Produtos1: TMenuItem;
    Configuraes1: TMenuItem;
    Usurios1: TMenuItem;
    ControleAcesso1: TMenuItem;
    GravarVendas1: TMenuItem;
    Estoque1: TMenuItem;
    CadastroEndereo1: TMenuItem;
    Importao1: TMenuItem;
    ImportarProdutos1: TMenuItem;
    este1: TMenuItem;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    Outros1: TMenuItem;
    hreads1: TMenuItem;
    FiredacETL1: TMenuItem;
    Contato1: TMenuItem;
    Contatos1: TMenuItem;
    procedure Cliente1Click(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure FormaPagamento1Click(Sender: TObject);
    procedure CondicaoPagamento1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure TabeladePreo1Click(Sender: TObject);
    procedure PedidodeVenda1Click(Sender: TObject);
    procedure VisualizarPedidoVenda1Click(Sender: TObject);
    procedure VendaDiria1Click(Sender: TObject);
    procedure NotaEntrada1Click(Sender: TObject);
    procedure Cadastro2Click(Sender: TObject);
    procedure Produtos1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Configuraes1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Usurios1Click(Sender: TObject);
    procedure ControleAcesso1Click(Sender: TObject);
    procedure GravarVendas1Click(Sender: TObject);
    procedure CadastroEndereo1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ImportarProdutos1Click(Sender: TObject);
    procedure este1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure hreads1Click(Sender: TObject);
    procedure FiredacETL1Click(Sender: TObject);
    procedure Contato1Click(Sender: TObject);
    procedure Contatos1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  temPermissao : Boolean;
  acesso : TUtil;

  //a��es
  const
    cdAcaoCadCliente = 1;
    cdAcaoCadProduto = 2;
    cdAcaoCadFormaPagamento = 3;
    cdAcaoCadCondPgto = 4;
    cdAcaocadTabelaPreco = 5;
    cdAcaoCadTabelaPrecoProduto = 6;
    cdAcaoConsultaProdutos = 7;
    cdAcaoPedidoVenda = 8;
    cdAcaoVisualizaPedidoVenda = 9;
    cdAcaoEdicaoPedidoVenda = 10;
    cdAcaoRelVendaDiaria = 11;
    cdAcaoLancamentoNotaEntrada = 12;
    cdAcaoCadastraTributacaoItem = 13;
    cdAcaoConfiguracoes = 14;
    cdAcaoUsuario = 15;
    cdAcaoControleAcesso = 16;
    cdAcaoCadastroEndereco = 17;

implementation

{$R *.dfm}

uses uUsuario, fControleAcesso, uDataModule, uGravaArquivo, fCadastroEnderecos,
  uSplash, fImportaDados, fGridsThread, fFiredacETL, cContato,
  fConsultaContatos;


procedure TfrmPrincipal.ApplicationEvents1Minimize(Sender: TObject);
begin
  Self.Hide;
  Self.WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TfrmPrincipal.Cadastro2Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;
  frmCadastraTributacaoItem := TfrmCadastraTributacaoItem.Create(Self);
  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoCadastraTributacaoItem);
    if temPermissao then
      frmCadastraTributacaoItem.ShowModal;
  finally
    FreeAndNil(acesso);
    frmCadastraTributacaoItem.Free;
  end;
end;

procedure TfrmPrincipal.CadastroEndereo1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;
  frmCadastroEnderecos := TfrmCadastroEnderecos.Create(Self);

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoCadastroEndereco);

    if temPermissao then
    begin

      frmCadastroEnderecos.ShowModal;

    end;
  finally
    frmCadastroEnderecos.Free;
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.Cliente1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoCadCliente);
    if temPermissao then
    begin
      frmCadCliente := TfrmCadCliente.Create(Self);
      frmCadCliente.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.CondicaoPagamento1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoCadCondPgto);
    if temPermissao then
    begin
      frmCadCondPgto := TfrmCadCondPgto.Create(Self);
      frmCadCondPgto.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.Configuraes1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoConfiguracoes);
    if temPermissao then
    begin
      frmConfiguracoes := TfrmConfiguracoes.Create(Self);
      frmConfiguracoes.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.Contato1Click(Sender: TObject);
var
  cadContato: TfrmCadContato;
begin
  cadContato := TfrmCadContato.Create(Self);

  try
    cadContato.ShowModal;
  finally
    cadContato.Free;
  end;
end;

procedure TfrmPrincipal.Contatos1Click(Sender: TObject);
var
  consultaContato: TfrmConsultaContatos;
begin
  consultaContato := TfrmConsultaContatos.Create(Self);

  try
    consultaContato.ShowModal;
  finally
    consultaContato.Free;
  end;
end;

procedure TfrmPrincipal.ControleAcesso1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoControleAcesso);
    if temPermissao then
    begin
      frmControleAcesso := TfrmControleAcesso.Create(Self);
      frmControleAcesso.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.este1Click(Sender: TObject);
begin
  frmlista := Tfrmlista.Create(Self);

  try
    frmLista.ShowModal;
  finally
    frmlista.Free;
  end;
end;

procedure TfrmPrincipal.FiredacETL1Click(Sender: TObject);
var
  firedac: TfrmFiredacETL;
begin
  firedac := TfrmFiredacETL.Create(Self);

  try
    firedac.ShowModal;
  finally
    firedac.Free;
  end;
end;

procedure TfrmPrincipal.FormaPagamento1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoCadFormaPagamento);
    if temPermissao then
    begin
      frmCadFormaPagamento := TfrmCadFormaPagamento.Create(Self);
      frmCadFormaPagamento.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TrayIcon1.Visible := False;
  Action := caFree;
end;

procedure TfrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if (Application.MessageBox('Deseja Sair do Sistema?','Aten��o', MB_YESNO) = IDYES) then
    CanClose := True;
end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then //ESC
  begin
    if (Application.MessageBox('Deseja Sair do Sistema?','Aten��o', MB_YESNO) = IDYES) then
      Close;
  end;
end;

procedure TfrmPrincipal.GravarVendas1Click(Sender: TObject);
begin
  frmGravaArquivo := TfrmGravaArquivo.Create(Self);
  try
    frmGravaArquivo.ShowModal;
  finally
    frmGravaArquivo.Free;
  end;
end;


procedure TfrmPrincipal.hreads1Click(Sender: TObject);
begin
  fThreads := TfThreads.Create(Self);
  try
    fThreads.ShowModal;
  finally
    fThreads.Free;
  end;
end;

procedure TfrmPrincipal.ImportarProdutos1Click(Sender: TObject);
begin
  frmImportaDados := TfrmImportaDados.Create(Self);
  try
    frmImportaDados.ShowModal;
  finally
    frmImportaDados.Free;
  end;
end;

procedure TfrmPrincipal.NotaEntrada1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoLancamentoNotaEntrada);
    if temPermissao then
    begin
      frmLancamentoNotaEntrada := TfrmLancamentoNotaEntrada.Create(Self);
      frmLancamentoNotaEntrada.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.PedidodeVenda1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoPedidoVenda);
    if temPermissao then
    begin
      frmPedidoVenda := TfrmPedidoVenda.Create(Self);
      frmPedidoVenda.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.Produto1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoCadProduto);
    if temPermissao then
    begin
      frmCadProduto := TfrmCadProduto.Create(Self);
      frmCadProduto.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.Produtos1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoConsultaProdutos);
    if temPermissao then
    begin
      frmConsultaProdutos := TfrmConsultaProdutos.Create(Self);
      frmConsultaProdutos.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.Sair1Click(Sender: TObject);
begin
//  if (Application.MessageBox('Deseja realmente sair do Sistema?','Aten��o', MB_YESNO) = IDYES) then

  //limpa a conex�o do banco
  if Assigned(dm) then
    FreeAndNil(dm);

  Close;
end;

procedure TfrmPrincipal.TabeladePreo1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaocadTabelaPreco);
    if temPermissao then
    begin
      frmcadTabelaPreco := TfrmcadTabelaPreco.Create(Self);
      frmcadTabelaPreco.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show;
  WindowState := wsMaximized;
  Application.BringToFront;
end;

procedure TfrmPrincipal.Usurios1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoUsuario);
    if temPermissao then
    begin
      frmUsuario := TfrmUsuario.Create(Self);
      frmUsuario.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.VendaDiria1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoRelVendaDiaria);
    if temPermissao then
    begin
      frmRelVendaDiaria := TfrmRelVendaDiaria.Create(Self);
      frmRelVendaDiaria.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

procedure TfrmPrincipal.VisualizarPedidoVenda1Click(Sender: TObject);
begin
  temPermissao := False;
  acesso := TUtil.Create;

  try
    temPermissao := acesso.ValidaAcessoAcao(idUsuario, cdAcaoVisualizaPedidoVenda);
    if temPermissao then
    begin
      frmVisualizaPedidoVenda := TfrmVisualizaPedidoVenda.Create(Self);
      frmVisualizaPedidoVenda.Show;
    end;
  finally
    FreeAndNil(acesso);
  end;
end;

end.
