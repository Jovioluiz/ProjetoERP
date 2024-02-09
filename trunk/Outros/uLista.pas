unit uLista;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uDataModule, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageBin, System.Generics.Collections, uSet, uJSONConvert,
  uclPedido_venda_item, uComplexidadeCiclomatica;



  type TTipo = record
    Nome: String;
    Codigo: Integer;
    Email: String;
  end;

type
  TfrmLista = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    btnAdd: TButton;
    DBGrid1: TDBGrid;
    ds: TDataSource;
    cds: TClientDataSet;
    cdscd_cliente: TIntegerField;
    cdsnome: TStringField;
    cdstp_pessoa: TStringField;
    cdstelefone: TStringField;
    cdscelular: TStringField;
    cdsemail: TStringField;
    cdscpf_cnpj: TStringField;
    Button1: TButton;
    edtCont: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    DBGrid2: TDBGrid;
    dsPedido: TDataSource;
    cdsPedido: TClientDataSet;
    Button3: TButton;
    edtBuscar: TEdit;
    Memo2: TMemo;
    Button4: TButton;
    dbgridtable: TDBGrid;
    cdstable: TFDMemTable;
    dstable: TDataSource;
    Button5: TButton;
    cdstablecd_cliente: TIntegerField;
    cdstablenr_pedido: TIntegerField;
    Memo3: TMemo;
    Button6: TButton;
    Button7: TButton;
    Memo4: TMemo;
    btnGerarJson: TButton;
    memoJson: TMemo;
    Button8: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure edtBuscarChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure btnGerarJsonClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    procedure GerarJson;
  public
    { Public declarations }
  end;

var
  frmLista: TfrmLista;

implementation

uses
  uUtil, uclPedido_venda, System.JSON;

{$R *.dfm}

procedure TfrmLista.btnAddClick(Sender: TObject);
const
  SQL = 'select * from cliente where cd_cliente in %s';
var
  qry: TFDQuery;
  lista: TList<String>;
  parametro: String;
  texto: TStringList;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  lista := TList<string>.Create;
  texto := TStringList.Create;

  lista.Add(Edit1.Text);
  lista.Add(Edit2.Text);

  for var j := 0 to Pred(lista.Count) do
    texto.Text := texto.Text + lista.Items[j];

  parametro := '(';

  for var i := 0 to Pred(texto.Count) do
    parametro := parametro + texto[i] + ',';

  parametro[Length(parametro)] := ')';

  try
    qry.SQL.Add(Format(SQL, [parametro]));

    qry.Open();
    qry.First;

    while not qry.Eof do
    begin
      cds.Append;
      cds.FieldByName('cd_cliente').AsInteger := qry.FieldByName('cd_cliente').AsInteger;
      cds.FieldByName('nome').AsString := qry.FieldByName('nome').AsString;
      cds.FieldByName('tp_pessoa').AsString := qry.FieldByName('tp_pessoa').AsString;
      cds.FieldByName('telefone').AsString := qry.FieldByName('telefone').AsString;
      cds.FieldByName('celular').AsString := qry.FieldByName('celular').AsString;
      cds.FieldByName('email').AsString := qry.FieldByName('email').AsString;
      cds.FieldByName('cpf_cnpj').AsString := qry.FieldByName('cpf_cnpj').AsString;
      cds.Post;
      qry.Next;
    end;

  finally
    qry.Free;
    texto.Free;
  end;

end;

procedure TfrmLista.edtBuscarChange(Sender: TObject);
begin
  cdsPedido.DisableControls;

  try
    cdsPedido.Filtered := False;
    cdsPedido.Filter := 'id_pedido_venda = ' + edtBuscar.Text;
    cdsPedido.Filtered := True;

  finally
    cdsPedido.EnableControls;
  end;
end;

procedure TfrmLista.btnGerarJsonClick(Sender: TObject);
begin
  GerarJson;
end;

procedure TfrmLista.Button1Click(Sender: TObject);
const
  SQL = 'select * from cliente';
var
  dicio: TDictionary<Integer, String>;
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  dicio := TDictionary<Integer, String>.Create;

  try
    qry.SQL.Add(SQL);
    qry.Open();

    qry.Loop(
    procedure
    begin
      if not dicio.ContainsKey(qry.FieldByName('cd_cliente').AsInteger) then
        dicio.Add(qry.FieldByName('cd_cliente').AsInteger, qry.FieldByName('nome').AsString);
    end
    );

    edtCont.Text := dicio.Count.ToString;

    for var i in dicio.Keys do
    begin
      cds.Append;
      cds.FieldByName('cd_cliente').AsInteger := i;
      cds.FieldByName('nome').AsString := dicio.Items[i];
      cds.Post;
    end;

  finally
    qry.Free;
    dicio.Free;
  end;
end;

procedure TfrmLista.Button2Click(Sender: TObject);
const
  sql = 'select id_geral, id_pedido_venda, un_medida from pedido_venda_item order by id_geral';
var
  dicionario: TObjectDictionary<Int64, TDictionary<Int64, String>>;
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  dicionario := TObjectDictionary<Int64, TDictionary<Int64, String>>.Create;

  try
    qry.Open(sql);

    qry.Loop(
    procedure
    begin
      if not dicionario.ContainsKey(qry.FieldByName('id_geral').AsLargeInt) then
        dicionario.Add(qry.FieldByName('id_geral').AsLargeInt, TDictionary<Int64, String>.Create);

      if not dicionario[qry.FieldByName('id_geral').AsLargeInt].ContainsKey(qry.FieldByName('id_pedido_venda').AsLargeInt) then
        dicionario[qry.FieldByName('id_geral').AsLargeInt].Add(qry.FieldByName('id_pedido_venda').AsLargeInt, qry.FieldByName('un_medida').AsString);

    end
    );

    for var i in dicionario.Keys do
    begin
      Memo1.Lines.Add('ID_GERAL: ' + i.ToString);
      for var j in dicionario[i].Keys do
      begin
//        Memo1.Lines.Add('ID_GERAL: ' + i.ToString + ' - ' + 'ID_PEDIDO_VENDA: ' + j.ToString);
        Memo1.Lines.Add('ID_PEDIDO_VENDA: ' + j.ToString + ' - ' + dicionario.Items[i].Items[j]);
      end;

    end;
  finally
    qry.Free;
    dicionario.Free;
  end;
end;

procedure TfrmLista.Button3Click(Sender: TObject);
const
  sql = 'select ' +
        '    id_geral, ' +
        '    id_pedido_venda, ' +
        '    p.cd_produto  ' +
        'from ' +
        '    pedido_venda_item pvi  ' +
        '    join produto p on p.id_item = pvi.id_item  ' +
        'order by ' +
        '    id_geral ';
var
  dicionario: TObjectDictionary<Int64, TDictionary<Int64, String>>;
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  dicionario := TObjectDictionary<Int64, TDictionary<Int64, String>>.Create;

  try
    qry.Open(sql);

    qry.Loop(
      procedure
      begin

        if not dicionario.ContainsKey(qry.FieldByName('id_pedido_venda').AsLargeInt) then
          dicionario.Add(qry.FieldByName('id_pedido_venda').AsLargeInt, TDictionary<Int64, String>.Create);

        if not dicionario[qry.FieldByName('id_pedido_venda').AsLargeInt].ContainsKey(qry.FieldByName('id_geral').AsLargeInt) then
          dicionario[qry.FieldByName('id_pedido_venda').AsLargeInt].Add(qry.FieldByName('id_geral').AsLargeInt, qry.FieldByName('cd_produto').AsString);

//        if not dicionario[qry.FieldByName('id_pedido_venda').AsLargeInt][qry.FieldByName('id_geral').AsLargeInt].Contains(qry.FieldByName('cd_produto').AsString) then
//          dicionario[qry.FieldByName('id_pedido_venda').AsLargeInt].Add(qry.FieldByName('id_geral').AsLargeInt, qry.FieldByName('cd_produto').AsString);
      end);

      //não está listando todos
      for var i in dicionario.Keys do
      begin
        cdsPedido.Append;
        cdsPedido.FieldByName('id_pedido_venda').AsLargeInt := i;

        for var j in dicionario[i].Keys do
        begin
          cdsPedido.FieldByName('id_geral').AsLargeInt := j;
          cdsPedido.FieldByName('cd_item').AsString := dicionario.Items[i].Items[j];
        end;

        cdsPedido.Post;
      end;

  finally
    qry.Free;
    dicionario.Free;
  end;
end;

procedure TfrmLista.Button4Click(Sender: TObject);
const
  sql = 'select id_geral, id_item from pedido_venda_item';
var
  dicionario: TDictionary<Int64, Integer>;
  qry: TFDQuery;
  j: Integer;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  dicionario := TDictionary<Int64, Integer>.Create;
  j := 0;

  try
    Memo2.Lines.Clear;

    qry.Open(sql);

    qry.Loop(
    procedure
    begin
      if not dicionario.ContainsKey(qry.FieldByName('id_geral').AsLargeInt) then
        dicionario.Add(qry.FieldByName('id_geral').AsLargeInt, qry.FieldByName('id_item').AsInteger);
    end
    );

    for var i in dicionario.Keys do
    begin
      Inc(j);
      Memo2.Lines.Add(j.ToString + '-' + i.ToString + ' - ' + dicionario.Items[i].ToString)
    end;

  finally
    qry.Free;
    dicionario.Free;
  end;
end;

procedure TfrmLista.Button5Click(Sender: TObject);
const
  SQL = 'select nr_pedido, cd_cliente from pedido_venda';
var
  query: TFDQuery;
begin

  cdstable.EmptyDataSet;
  query := TFDQuery.Create(Self);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL);

    query.Loop(
    procedure
    begin
      cdstable.Append;
      cdstable.FieldByName('cd_cliente').AsInteger := query.FieldByName('cd_cliente').AsInteger;
      cdstable.FieldByName('nr_pedido').AsInteger := query.FieldByName('nr_pedido').AsInteger;
      cdstable.Post;
    end
    );

  finally
    query.Free;
  end;
end;

procedure TfrmLista.Button6Click(Sender: TObject);
const
  SQL = 'SELECT cd_cliente, nome, email FROM cliente';
var
  dicio: TObjectDictionary<Integer, TList<TTipo>>;
  query: TFDQuery;
  tipos: TTipo;
  lista: TList<TTipo>;
begin
  dicio := TObjectDictionary<Integer, TList<TTipo>>.Create;
  query := TFDQuery.Create(Self);
  lista := TList<TTipo>.Create;

  try
    query.Connection := dm.conexaoBanco;
    query.SQL.Add(SQL);
    query.Open();

    query.First;
    TList<TTipo>.Create;
    for var I := 0 to Pred(query.RecordCount) do
    begin
      tipos.Nome := query.FieldByName('nome').AsString;
      tipos.Codigo := query.FieldByName('cd_cliente').AsInteger;
      tipos.Email := query.FieldByName('email').AsString;

      if not dicio.ContainsKey(query.FieldByName('cd_cliente').AsInteger) then
        lista.Add(tipos);
      dicio.Add(I, lista);
      query.Next;
    end;

    for var teste in dicio.Keys do
    begin
      for var t in dicio.Items[teste] do
      begin
        Memo3.Lines.Add(t.Nome);
      end;
//      var testes := dicio.Items[teste];
//      Memo3.Lines.Add(testes.Items[teste].Nome);
    end;

  finally
    dicio.Free;
    query.Free;
    lista.Free;
  end;
end;

procedure TfrmLista.Button7Click(Sender: TObject);
const
  SQL = 'SELECT cd_cliente, nome, email FROM cliente';
var
  dicio: TSet<Integer, String>;
  consulta: TFDQuery;
begin
  dicio := TSet<Integer, String>.Create;
  consulta := TFDQuery.Create(Self);
  consulta.Connection := dm.conexaoBanco;

  try
    consulta.SQL.Add(SQL);
    consulta.Open(SQL);
    consulta.First;
    while not consulta.Eof do
    begin
      if not dicio.ContainsKey(consulta.FieldByName('cd_cliente').AsInteger) then
        dicio.Add(consulta.FieldByName('cd_cliente').AsInteger, consulta.FieldByName('nome').AsString);
      consulta.Next;
    end;

    Memo4.Lines.Clear;
    for var teste in dicio.Keys do
    begin
      Memo4.Lines.Add(teste.ToString + ' - ' + dicio.Items[teste]);
    end;


  finally
    consulta.Free;
    dicio.Free;
  end;
end;

procedure TfrmLista.Button8Click(Sender: TObject);
var
  complexidade: TComplexidadeCiclomatica;
  code: string;
begin
  complexidade := TComplexidadeCiclomatica.Create;
  code := 'procedure TPedidoVenda.CalculaValoresRateados(Valor: Currency; TipoValor: string); ' +
          '  var                                                                             ' +
          '    valorTotal,                                                                   ' +
          '    valorItem,                                                                    ' +
          '    pcItem,                                                                       ' +
          '    valorDesconto,                                                               ' +
          '    valorAcrescimo: Currency;                                                    ' +
          '  begin                                                                      ' +
          '    valorTotal := GetValorPedido;                                            ' +
          '                                                                             ' +
          '    if valorTotal = 0 then                                                   ' +
          '      Exit;                                                                  ' +
          '                                                                             ' +
          '    if Valor > 0 then                                                        ' +
          '    begin                                                                    ' +
          '      FDados.cdsPedidoVendaItem.Loop(                                        ' +
          '      procedure                                                              ' +
          '      begin                                                                  ' +
          '        valorItem := FDados.cdsPedidoVendaItem.FieldByName(''vl_total_item'').AsCurrency; ' +
          '        pcItem := valorItem / valorTotal;                                              ' +
          '                                                                                       ' +
          '        FDados.cdsPedidoVendaItem.Edit;                                                ' +
          '        if TipoValor.Equals(''D'') then                                                  ' +
          '          FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_desconto'').AsCurrency := RoundTo(valor * pcItem, -2) ' +
          '        else                                                                                                     ' +
          '          FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_acrescimo'').AsCurrency := RoundTo(valor * pcItem, -2); ' +
          '                                                                                                                 ' +
          '        FDados.cdsPedidoVendaItem.Post;                                                                          ' +
          '      end                                                                                               ' +
          '      );                                                                                              ' +
          '                                                                                                   ' +
          '      if TipoValor.Equals(''D'') then                                                            ' +
          '      begin                                                                                 ' +
          '        valorDesconto := 0;                                                              ' +
          '        FDados.cdsPedidoVendaItem.Loop(                                                   ' +
          '        procedure                                                                        ' +
          '        begin                                                                             ' +
          '          valorDesconto := valorDesconto + FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_desconto'').AsCurrency; ' +
          '        end);                                                         ' +
          '                                                                      ' +
          '        //se sobrou algum centavo joga no ultimo                      ' +
          '        if Abs(Valor - valorDesconto) > 0 then                        ' +
          '        begin                                                         ' +
          '          FDados.cdsPedidoVendaItem.Last;                              ' +
          '          FDados.cdsPedidoVendaItem.Edit;                              ' +
          '          FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_desconto'').AsCurrency := FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_desconto'').AsCurrency   ' +
          '                                                                                     + Abs(Valor - valorDesconto);  ' +
          '          FDados.cdsPedidoVendaItem.Post;                            ' +
          '        end;                                                         ' +
          '      end;                                                           ' +
          '                                                                     ' +
          '      if TipoValor.Equals(''A'') then                                  ' +
          '      begin                                                          ' +
          '        valorAcrescimo := 0;                                         ' +
          '        FDados.cdsPedidoVendaItem.Loop(                              ' +
          '        procedure                                                    ' +
          '        begin                                                        ' +
          '          valorAcrescimo := valorAcrescimo + FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_acrescimo'').AsCurrency;  ' +
          '        end);                                                      ' +
          '                                                                   ' +
          '        //se sobrou algum centavo joga no ultimo                   ' +
          '        if Abs(Valor - valorAcrescimo) > 0 then                    ' +
          '        begin                                                       ' +
          '          FDados.cdsPedidoVendaItem.Last;                          ' +
          '          FDados.cdsPedidoVendaItem.Edit;                          ' +
          '          FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_acrescimo'').AsCurrency := FDados.cdsPedidoVendaItem.FieldByName(''rateado_vl_acrescimo'').AsCurrency  ' +
          '                                                                                     + Abs(Valor - valorAcrescimo); ' +
          '          FDados.cdsPedidoVendaItem.Post;                           ' +
          '        end;                                                       ' +
          '      end;                                                        ' +
          '    end;                                                          ' +
          '  end;                                                          ' ;
  try
    complexidade.CalculateCyclomaticComplexity(code);
  finally
    complexidade.Free;
  end;
end;

procedure TfrmLista.FormCreate(Sender: TObject);
begin
  DBGrid2.DataSource := dsPedido;
end;

procedure TfrmLista.GerarJson;
const
  SQL = ' SELECT ' +
        ' 	cd_cliente, ' +
        ' 	cd_cond_pag, ' +
        ' 	cd_forma_pag, ' +
        ' 	dt_atz, ' +
        ' 	dt_emissao, ' +
        ' 	dt_parcela, ' +
        ' 	fl_cancelado, ' +
        ' 	fl_orcamento, ' +
        ' 	id_geral, ' +
        ' 	nr_pedido, ' +
        ' 	parcela, ' +
        ' 	vl_acrescimo, ' +
        ' 	vl_desconto_pedido, ' +
        ' 	vl_total  ' +
        ' 	FROM pedido_venda pv ' +
        ' WHERE ' +
        ' 	nr_pedido = 60 ';

  SQL_ITENS = ' SELECT ' +
              ' 	cd_tabela_preco, ' +
              ' 	dt_atz, ' +
              ' 	icms_pc_aliq, ' +
              ' 	icms_valor, ' +
              ' 	icms_vl_base, ' +
              ' 	id_geral, ' +
              ' 	id_item, ' +
              ' 	id_pedido_venda, ' +
              ' 	ipi_pc_aliq, ' +
              ' 	ipi_valor, ' +
              ' 	ipi_vl_base, ' +
              ' 	pis_cofins_pc_aliq, ' +
              ' 	pis_cofins_valor, ' +
              ' 	pis_cofins_vl_base, ' +
              ' 	qtd_venda, ' +
              ' 	seq_item, ' +
              ' 	un_medida, ' +
              ' 	vl_desconto, ' +
              ' 	vl_total_item, ' +
              ' 	vl_unitario, ' +
              ' 	rateado_vl_desconto, ' +
              ' 	rateado_vl_acrescimo, ' +
              ' 	vl_contabil  ' +
              ' 	FROM pedido_venda_item pvi ' +
              ' WHERE ' +
              ' 	id_pedido_venda = :nr_pedido ';
var
  pedidoVenda: TPedido_venda;
  pedidoVendaItem: TPedido_venda_item;
  consulta: TFDQuery;
  idPedido: Int64;
  listaPedidoItem: TList<TPedido_venda_item>;
//  jsonValue: TJsonValue;
begin

  consulta := TFDQuery.Create(Self);
  pedidoVenda := TPedido_venda.Create;
  pedidoVendaItem := TPedido_venda_item.Create;
  listaPedidoItem := TList<TPedido_venda_item>.Create;

  try
    consulta.Connection := dm.conexaoBanco;
    consulta.Open(SQL);
    idPedido := consulta.FieldByName('id_geral').AsLargeInt;
    pedidoVenda.cd_cliente := consulta.FieldByName('cd_cliente').AsInteger;
    pedidoVenda.cd_cond_pag := consulta.FieldByName('cd_cond_pag').AsInteger;
    pedidoVenda.cd_forma_pag := consulta.FieldByName('cd_forma_pag').AsInteger;
    pedidoVenda.dt_atz := consulta.FieldByName('dt_atz').AsDateTime;
    pedidoVenda.dt_emissao := consulta.FieldByName('dt_emissao').AsDateTime;
    pedidoVenda.dt_parcela := consulta.FieldByName('dt_parcela').AsDateTime;
    pedidoVenda.fl_cancelado := consulta.FieldByName('fl_cancelado').AsString;
    pedidoVenda.fl_orcamento := consulta.FieldByName('fl_orcamento').AsBoolean;
    pedidoVenda.id_geral := consulta.FieldByName('id_geral').AsLargeInt;
    pedidoVenda.nr_pedido := consulta.FieldByName('nr_pedido').AsInteger;
    pedidoVenda.parcela := consulta.FieldByName('parcela').AsInteger;
    pedidoVenda.vl_acrescimo := consulta.FieldByName('vl_acrescimo').AsCurrency;
    pedidoVenda.vl_desconto_pedido := consulta.FieldByName('vl_desconto_pedido').AsCurrency;
    pedidoVenda.vl_total := consulta.FieldByName('vl_total').AsCurrency;

    consulta.Close;
    consulta.SQL.Clear;
    consulta.SQL.Add(SQL_ITENS);
    consulta.ParamByName('nr_pedido').AsInteger := idPedido;
    consulta.Open();
    consulta.First;
    while not consulta.Eof do
    begin
      pedidoVendaItem.cd_tabela_preco := consulta.FieldByName('cd_tabela_preco').AsInteger;
      pedidoVendaItem.dt_atz := consulta.FieldByName('dt_atz').AsDateTime;
      pedidoVendaItem.icms_pc_aliq := consulta.FieldByName('icms_pc_aliq').AsCurrency;
      pedidoVendaItem.icms_valor := consulta.FieldByName('icms_valor').AsCurrency;
      pedidoVendaItem.icms_vl_base := consulta.FieldByName('icms_vl_base').AsCurrency;
      pedidoVendaItem.id_geral := consulta.FieldByName('id_geral').AsLargeInt;
      pedidoVendaItem.id_item := consulta.FieldByName('id_item').AsInteger;
      pedidoVendaItem.id_pedido_venda := consulta.FieldByName('id_pedido_venda').AsLargeInt;
      pedidoVendaItem.ipi_pc_aliq := consulta.FieldByName('ipi_pc_aliq').AsCurrency;
      pedidoVendaItem.ipi_valor := consulta.FieldByName('ipi_valor').AsCurrency;
      pedidoVendaItem.ipi_vl_base := consulta.FieldByName('ipi_vl_base').AsCurrency;
      pedidoVendaItem.pis_cofins_pc_aliq := consulta.FieldByName('pis_cofins_pc_aliq').AsCurrency;
      pedidoVendaItem.pis_cofins_valor := consulta.FieldByName('pis_cofins_valor').AsCurrency;
      pedidoVendaItem.pis_cofins_vl_base := consulta.FieldByName('pis_cofins_vl_base').AsCurrency;
      pedidoVendaItem.qtd_venda := consulta.FieldByName('qtd_venda').AsFloat;
      pedidoVendaItem.seq_item := consulta.FieldByName('seq_item').AsInteger;
      pedidoVendaItem.un_medida := consulta.FieldByName('un_medida').AsString;
      pedidoVendaItem.vl_desconto := consulta.FieldByName('vl_desconto').AsCurrency;
      pedidoVendaItem.vl_total_item := consulta.FieldByName('vl_total_item').AsCurrency;
      pedidoVendaItem.vl_unitario := consulta.FieldByName('vl_unitario').AsCurrency;
      pedidoVendaItem.rateado_vl_desconto := consulta.FieldByName('rateado_vl_desconto').AsCurrency;
      pedidoVendaItem.rateado_vl_acrescimo := consulta.FieldByName('rateado_vl_acrescimo').AsCurrency;
      pedidoVendaItem.vl_contabil := consulta.FieldByName('vl_contabil').AsCurrency;
      listaPedidoItem.Add(pedidoVendaItem);
      consulta.Next;
    end;

    pedidoVenda.PedidoVendaItem := listaPedidoItem;
    var json := TJSONConvert.ObjectToJsonString(pedidoVenda);
//    jsonValue := TJSONObject.ParseJSONValue(json);
    memoJson.Lines.Add(json);

//    var classe := TJSONConvert.JsonToObject<TPedido_venda>(json);
  finally
    consulta.Free;
    pedidoVenda.PedidoVendaItem.Free;
    pedidoVenda.Free;
    pedidoVendaItem.Free;
  end;
end;

end.
