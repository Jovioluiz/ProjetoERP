program ProjetoTestes;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Vcl.Forms,
  TestuUsuario in 'TestuUsuario.pas',
  TestuPedidoVenda in 'TestuPedidoVenda.pas',
  TestfCadastroEnderecos in 'TestfCadastroEnderecos.pas',
  TestcCLIENTE in 'TestcCLIENTE.pas',
  TestuclPedidoVenda in 'TestuclPedidoVenda.pas',
  uUsuario in '..\trunk\Usuario\uUsuario.pas',
  uDataModule in '..\trunk\Conexao\uDataModule.pas' {dm: TDataModule},
  uUtil in '..\trunk\Validacao\uUtil.pas',
  uValidaDcto in '..\trunk\Validacao\uValidaDcto.pas',
  uTelaInicial in '..\trunk\Inicio\uTelaInicial.pas' {frmPrincipal},
  cCTA_FORMA_PAGAMENTO in '..\trunk\Cadastros\cCTA_FORMA_PAGAMENTO.pas' {frmCadFormaPagamento},
  uCadTABELAPRECO in '..\trunk\Cadastros\uCadTABELAPRECO.pas' {frmcadTabelaPreco},
  uCadTabelaPrecoProduto in '..\trunk\Cadastros\uCadTabelaPrecoProduto.pas' {frmCadTabelaPrecoProduto},
  cPRODUTO in '..\trunk\Cadastros\cPRODUTO.pas' {frmCadProduto},
  cCTA_COND_PGTO in '..\trunk\Cadastros\cCTA_COND_PGTO.pas' {frmCadCondPgto},
  cCLIENTE in '..\trunk\Cadastros\cCLIENTE.pas' {frmCadCliente},
  uVisualizaPedidoVenda in '..\trunk\Pedido Venda\uVisualizaPedidoVenda.pas' {frmVisualizaPedidoVenda},
  uPedidoVenda in '..\trunk\Pedido Venda\uPedidoVenda.pas' {frmPedidoVenda},
  uLogin in '..\trunk\Login\uLogin.pas' {frmLogin},
  uCadastroTributacaoItem in '..\trunk\Cadastros\uCadastroTributacaoItem.pas' {frmCadastraTributacaoItem},
  uLancamentoNotaEntrada in '..\trunk\Entrada\uLancamentoNotaEntrada.pas' {frmLancamentoNotaEntrada},
  Vcl.Themes,
  Vcl.Styles,
  uConfiguracoes in '..\trunk\Configuracoes\uConfiguracoes.pas' {frmConfiguracoes},
  FConsultaProduto in '..\trunk\Consulta\FConsultaProduto.pas' {frmConsultaProdutos},
  UfrmRelVendaDiaria in '..\trunk\Arquivos\UfrmRelVendaDiaria.pas' {frmRelVendaDiaria},
  fControleAcesso in '..\trunk\Acesso\fControleAcesso.pas' {frmControleAcesso},
  dtmConsultaProduto in '..\trunk\Consulta\dtmConsultaProduto.pas' {dmConsultaProduto: TDataModule},
  uclPedidoVenda in '..\trunk\Pedido Venda\uclPedidoVenda.pas',
  uGravaArquivo in '..\trunk\Arquivos\uGravaArquivo.pas' {frmGravaArquivo},
  uVersao in '..\trunk\Validacao\uVersao.pas',
  uConsulta in '..\trunk\Consulta\uConsulta.pas' {frmConsulta},
  uclNotaEntrada in '..\trunk\Entrada\uclNotaEntrada.pas',
  fCadastroEnderecos in '..\trunk\WMS\fCadastroEnderecos.pas' {frmCadastroEnderecos},
  uCadastrarSenha in '..\trunk\Cadastros\uCadastrarSenha.pas' {frmCadastraSenha},
  uSplash in '..\trunk\Inicio\uSplash.pas' {frmSplash},
  uLista in '..\trunk\Outros\uLista.pas' {frmLista},
  uclCliente in '..\trunk\Cadastros\Persistencia\uclCliente.pas',
  uclCta_Cond_Pgto in '..\trunk\Cadastros\Persistencia\uclCta_Cond_Pgto.pas',
  uInterface in '..\trunk\Outros\uInterface.pas',
  uclCtaFormaPagamento in '..\trunk\Cadastros\Persistencia\uclCtaFormaPagamento.pas',
  fConexao in '..\trunk\Conexao\fConexao.pas' {frmConexao},
  uclPadrao in '..\trunk\Outros\uclPadrao.pas',
  uclProduto in '..\trunk\Cadastros\Persistencia\uclProduto.pas',
  uclProdutoTributacao in '..\trunk\Cadastros\Persistencia\uclProdutoTributacao.pas',
  dProdutoCodBarras in '..\trunk\Cadastros\dProdutoCodBarras.pas' {dmProdutoCodBarras: TDataModule},
  uclTabelaPreco in '..\trunk\Cadastros\Persistencia\uclTabelaPreco.pas',
  uclTabelaPrecoProduto in '..\trunk\Cadastros\Persistencia\uclTabelaPrecoProduto.pas',
  uConexao in '..\trunk\Conexao\uConexao.pas',
  uEnderecoWMS in '..\trunk\WMS\uEnderecoWMS.pas',
  uValidacoesLogin in '..\trunk\Login\uValidacoesLogin.pas',
  dImportaDados in '..\trunk\Arquivos\dImportaDados.pas' {dmImportaDados: TDataModule},
  fImportaDados in '..\trunk\Arquivos\fImportaDados.pas' {frmImportaDados},
  uImportacaoDados in '..\trunk\Arquivos\uImportacaoDados.pas',
  uControleAcessoSistema in '..\trunk\Acesso\uControleAcessoSistema.pas',
  dControleAcesso in '..\trunk\Acesso\dControleAcesso.pas' {dmControleAcesso: TDataModule},
  uConsultaProdutos in '..\trunk\Consulta\uConsultaProdutos.pas',
  dTabelaPreco in '..\trunk\Cadastros\dTabelaPreco.pas' {dmProdutosTabelaPreco: TDataModule},
  fGridsThread in '..\trunk\Outros\fGridsThread.pas' {fThreads},
  dWMS in '..\trunk\WMS\dWMS.pas' {dmWMS: TDataModule},
  dPedidoVenda in '..\trunk\Pedido Venda\dPedidoVenda.pas' {dmPedidoVenda: TDataModule},
  dNotaEntrada in '..\trunk\Entrada\dNotaEntrada.pas' {dmNotaEntrada: TDataModule},
  uMovimentacaoEstoque in '..\trunk\Estoque\uMovimentacaoEstoque.pas',
  fCadastroPadrao in '..\trunk\Outros\fCadastroPadrao.pas' {frmCadastroPadrao},
  uclPedidoVendaItem in '..\trunk\Pedido Venda\uclPedidoVendaItem.pas',
  uSet in '..\trunk\Outros\uSet.pas',
  uclLogin in '..\trunk\Login\uclLogin.pas',
  uclUsuario in '..\trunk\Usuario\uclUsuario.pas',
  dUsuario in '..\trunk\Usuario\dUsuario.pas' {dmUsuario: TDataModule},
  fFiredacETL in '..\trunk\Outros\fFiredacETL.pas' {frmFiredacETL},
  uTributacaoGenerica in '..\trunk\Tributacao\uTributacaoGenerica.pas',
  uTributacao in '..\trunk\Tributacao\uTributacao.pas',
  uTributacaoICMS in '..\trunk\Tributacao\uTributacaoICMS.pas',
  uManipuladorTributacao in '..\trunk\Tributacao\uManipuladorTributacao.pas',
  uTributacaoIPI in '..\trunk\Tributacao\uTributacaoIPI.pas',
  uContato in '..\trunk\Cadastros\Contato\src\uContato.pas',
  uContatoFisica in '..\trunk\Cadastros\Contato\src\uContatoFisica.pas',
  uContatoJuridica in '..\trunk\Cadastros\Contato\src\uContatoJuridica.pas',
  uclContato in '..\trunk\Cadastros\Contato\src\uclContato.pas',
  TestuManipuladorContato in 'TestuManipuladorContato.pas',
  fConsulta in '..\trunk\Consulta\fConsulta.pas',
  uclPedido_venda_item in '..\trunk\Pedido Venda\uclPedido_venda_item.pas',
  uclPedido_venda in '..\trunk\Pedido Venda\Persistencia\uclPedido_venda.pas',
  uclTabelaPrecoRegras in '..\trunk\Cadastros\src\uclTabelaPrecoRegras.pas',
  uGrupoTributacao in '..\trunk\Cadastros\src\uGrupoTributacao.pas',
  uGrupoTributacaoICMS in '..\trunk\Cadastros\src\uGrupoTributacaoICMS.pas',
  uGrupoTributacaoIPI in '..\trunk\Cadastros\src\uGrupoTributacaoIPI.pas',
  uGrupoTributacaoISS in '..\trunk\Cadastros\src\uGrupoTributacaoISS.pas',
  uGrupoTributacaoPISCOFINS in '..\trunk\Cadastros\src\uGrupoTributacaoPISCOFINS.pas',
  dtmContatos in '..\trunk\Cadastros\Contato\datamodule\dtmContatos.pas' {dmContatos: TDataModule},
  uManipuladorContato in '..\trunk\Cadastros\Contato\src\uManipuladorContato.pas',
  cContato in '..\trunk\Cadastros\Contato\view\cContato.pas' {frmCadContato},
  fConsultaContatos in '..\trunk\Cadastros\Contato\view\fConsultaContatos.pas' {frmConsultaContatos},
  fVisualizaCodigoBarras in '..\trunk\Outros\fVisualizaCodigoBarras.pas' {fVisualizaCodBarras},
  uSenhaMD5 in '..\trunk\Outros\uSenhaMD5.pas',
  uGerador in '..\trunk\Outros\uGerador.pas',
  uclNFI in '..\trunk\Entrada\Persistencia\uclNFI.pas',
  uJSONConvert in '..\trunk\Outros\uJSONConvert.pas',
  uComplexidadeCiclomatica in '..\trunk\Outros\uComplexidadeCiclomatica.pas',
  uThreadImportacaoArquivo in '..\trunk\Arquivos\Thread\uThreadImportacaoArquivo.pas',
  uThreadImportacaoCliente in '..\trunk\Arquivos\Thread\uThreadImportacaoCliente.pas',
  uThreadGenerica in '..\trunk\Utils\uThreadGenerica.pas',
  uThread in '..\trunk\Outros\uThread.pas',
  uThreadGrids in '..\trunk\Outros\uThreadGrids.pas';

{$R *.RES}

begin
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TdmContatos, dmContatos);
  Application.CreateForm(TfrmCadContato, frmCadContato);
  Application.CreateForm(TfrmConsultaContatos, frmConsultaContatos);
  Application.CreateForm(TfVisualizaCodBarras, fVisualizaCodBarras);
  DUnitTestRunner.RunRegisteredTests;
end.

