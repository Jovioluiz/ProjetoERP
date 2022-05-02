{$REGION
  Autor: 'J�vio Luiz Giacomolli'}
{$ENDREGION}
program Projeto;

uses
  Vcl.Forms,
  SysUtils,
  Controls,
  uValidaDcto in 'Validacao\uValidaDcto.pas',
  uTelaInicial in 'Inicio\uTelaInicial.pas' {frmPrincipal},
  cCTA_FORMA_PAGAMENTO in 'Cadastros\cCTA_FORMA_PAGAMENTO.pas' {frmCadFormaPagamento},
  uCadTABELAPRECO in 'Cadastros\uCadTABELAPRECO.pas' {frmcadTabelaPreco},
  uCadTabelaPrecoProduto in 'Cadastros\uCadTabelaPrecoProduto.pas' {frmCadTabelaPrecoProduto},
  cPRODUTO in 'Cadastros\cPRODUTO.pas' {frmCadProduto},
  cCTA_COND_PGTO in 'Cadastros\cCTA_COND_PGTO.pas' {frmCadCondPgto},
  cCLIENTE in 'Cadastros\cCLIENTE.pas' {frmCadCliente},
  uVisualizaPedidoVenda in 'Pedido Venda\uVisualizaPedidoVenda.pas' {frmVisualizaPedidoVenda},
  uPedidoVenda in 'Pedido Venda\uPedidoVenda.pas' {frmPedidoVenda},
  uLogin in 'Login\uLogin.pas' {frmLogin},
  uCadastroTributacaoItem in 'Cadastros\uCadastroTributacaoItem.pas' {frmCadastraTributacaoItem},
  uLancamentoNotaEntrada in 'Entrada\uLancamentoNotaEntrada.pas' {frmLancamentoNotaEntrada},
  Vcl.Themes,
  Vcl.Styles,
  uDataModule in 'Conexao\uDataModule.pas' {dm: TDataModule},
  uConfiguracoes in 'Configuracoes\uConfiguracoes.pas' {frmConfiguracoes},
  FConsultaProduto in 'Consulta\FConsultaProduto.pas' {frmConsultaProdutos},
  uUsuario in 'Usuario\uUsuario.pas' {frmUsuario},
  UfrmRelVendaDiaria in 'Arquivos\UfrmRelVendaDiaria.pas' {frmRelVendaDiaria},
  fControleAcesso in 'Acesso\fControleAcesso.pas' {frmControleAcesso},
  uUtil in 'Validacao\uUtil.pas',
  dtmConsultaProduto in 'Consulta\dtmConsultaProduto.pas' {dmConsultaProduto: TDataModule},
  uclPedidoVenda in 'Pedido Venda\uclPedidoVenda.pas',
  uGravaArquivo in 'Arquivos\uGravaArquivo.pas' {frmGravaArquivo},
  uVersao in 'Validacao\uVersao.pas',
  uConsulta in 'Consulta\uConsulta.pas' {frmConsulta},
  uclNotaEntrada in 'Entrada\uclNotaEntrada.pas',
  uGerador in 'Outros\uGerador.pas' {$R *.res},
  fCadastroEnderecos in 'WMS\fCadastroEnderecos.pas' {frmCadastroEnderecos},
  uCadastrarSenha in 'Cadastros\uCadastrarSenha.pas' {frmCadastraSenha},
  uSplash in 'Inicio\uSplash.pas' {frmSplash},
  uLista in 'Outros\uLista.pas' {frmLista},
  uclCliente in 'Cadastros\Persistencia\uclCliente.pas',
  uclCta_Cond_Pgto in 'Cadastros\Persistencia\uclCta_Cond_Pgto.pas',
  uInterface in 'Outros\uInterface.pas',
  uclCtaFormaPagamento in 'Cadastros\Persistencia\uclCtaFormaPagamento.pas',
  fConexao in 'Conexao\fConexao.pas' {frmConexao},
  uclPadrao in 'Outros\uclPadrao.pas',
  uclProduto in 'Cadastros\Persistencia\uclProduto.pas',
  uclProdutoTributacao in 'Cadastros\Persistencia\uclProdutoTributacao.pas',
  dProdutoCodBarras in 'Cadastros\dProdutoCodBarras.pas' {dmProdutoCodBarras: TDataModule},
  uclTabelaPreco in 'Cadastros\Persistencia\uclTabelaPreco.pas',
  uclTabelaPrecoProduto in 'Cadastros\Persistencia\uclTabelaPrecoProduto.pas',
  uConexao in 'Conexao\uConexao.pas',
  uEnderecoWMS in 'WMS\uEnderecoWMS.pas',
  uValidacoesLogin in 'Login\uValidacoesLogin.pas',
  dImportaDados in 'Arquivos\dImportaDados.pas' {dmImportaDados: TDataModule},
  fImportaDados in 'Arquivos\fImportaDados.pas' {frmImportaDados},
  uImportacaoDados in 'Arquivos\uImportacaoDados.pas',
  uControleAcessoSistema in 'Acesso\uControleAcessoSistema.pas',
  dControleAcesso in 'Acesso\dControleAcesso.pas' {dmControleAcesso: TDataModule},
  uConsultaProdutos in 'Consulta\uConsultaProdutos.pas',
  uThread in 'Outros\uThread.pas',
  dTabelaPreco in 'Cadastros\dTabelaPreco.pas' {dmProdutosTabelaPreco: TDataModule},
  fGridsThread in 'Outros\fGridsThread.pas' {fThreads},
  fVisualizaCodigoBarras in 'Outros\fVisualizaCodigoBarras.pas' {fVisualizaCodBarras},
  dWMS in 'WMS\dWMS.pas' {dmWMS: TDataModule},
  dPedidoVenda in 'Pedido Venda\dPedidoVenda.pas' {dmPedidoVenda: TDataModule},
  dNotaEntrada in 'Entrada\dNotaEntrada.pas' {dmNotaEntrada: TDataModule},
  uMovimentacaoEstoque in 'Estoque\uMovimentacaoEstoque.pas',
  fCadastroPadrao in 'Outros\fCadastroPadrao.pas' {frmCadastroPadrao},
  uclPedidoVendaItem in 'Pedido Venda\uclPedidoVendaItem.pas',
  uSet in 'Outros\uSet.pas',
  uclLogin in 'Login\uclLogin.pas',
  uclUsuario in 'Usuario\uclUsuario.pas',
  dUsuario in 'Usuario\dUsuario.pas' {dmUsuario: TDataModule},
  fFiredacETL in 'Outros\fFiredacETL.pas' {frmFiredacETL},
  uTributacaoGenerica in 'Tributacao\uTributacaoGenerica.pas',
  uTributacao in 'Tributacao\uTributacao.pas',
  uTributacaoICMS in 'Tributacao\uTributacaoICMS.pas',
  uManipuladorTributacao in 'Tributacao\uManipuladorTributacao.pas',
  uTributacaoIPI in 'Tributacao\uTributacaoIPI.pas',
  uContato in 'Cadastros\Contato\src\uContato.pas',
  uContatoFisica in 'Cadastros\Contato\src\uContatoFisica.pas',
  uContatoJuridica in 'Cadastros\Contato\src\uContatoJuridica.pas',
  uManipuladorContato in 'Cadastros\Contato\src\uManipuladorContato.pas',
  uclContato in 'Cadastros\Contato\src\uclContato.pas',
  cContato in 'Cadastros\Contato\view\cContato.pas' {frmCadContato},
  fConsultaContatos in 'Cadastros\Contato\view\fConsultaContatos.pas' {frmConsultaContatos},
  dtmContatos in 'Cadastros\Contato\datamodule\dtmContatos.pas' {dmContatos: TDataModule},
  uFuncionario in 'Cadastros\Funcionario\src\uFuncionario.pas',
  uGerente in 'Cadastros\Funcionario\src\uGerente.pas',
  uEstagiario in 'Cadastros\Funcionario\src\uEstagiario.pas',
  uclTabelaPrecoRegras in 'Cadastros\src\uclTabelaPrecoRegras.pas',
  uGrupoTributacao in 'Cadastros\src\uGrupoTributacao.pas',
  uGrupoTributacaoICMS in 'Cadastros\src\uGrupoTributacaoICMS.pas',
  uGrupoTributacaoIPI in 'Cadastros\src\uGrupoTributacaoIPI.pas',
  uGrupoTributacaoISS in 'Cadastros\src\uGrupoTributacaoISS.pas',
  uGrupoTributacaoPISCOFINS in 'Cadastros\src\uGrupoTributacaoPISCOFINS.pas',
  uclPedido_venda_item in 'Pedido Venda\uclPedido_venda_item.pas',
  uParametrosImpostos in 'Tributacao\uParametrosImpostos.pas',
  uParametrosImpostosAbstract in 'Tributacao\uParametrosImpostosAbstract.pas',
  uclPedido_venda in 'Pedido Venda\Persistencia\uclPedido_venda.pas',
  fConsulta in 'Consulta\fConsulta.pas' {formConsulta},
  uclNFI in 'Entrada\Persistencia\uclNFI.pas',
  uSenhaMD5 in 'Outros\uSenhaMD5.pas',
  uThreadGrids in 'Outros\uThreadGrids.pas',
  uThreadImportacaoArquivo in 'Arquivos\Thread\uThreadImportacaoArquivo.pas';

{$R *.res}

begin
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TdmUsuario, dmUsuario);
  frmLogin := TfrmLogin.Create(nil);

  if frmLogin.ShowModal = mrOK then
  begin
    FreeAndNil(frmLogin);
    Application.Initialize;
    ReportMemoryLeaksOnShutdown := True;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmPrincipal, frmPrincipal);
    Application.Run;
  end;
end.
