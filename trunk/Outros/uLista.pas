unit uLista;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uDataModule, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageBin, System.Generics.Collections, uSet;



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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLista: TfrmLista;

implementation

uses
  uUtil;

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

      //n?o est? listando todos
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
  query: TFDQuery;
begin
  dicio := TSet<Integer, String>.Create;
  query := TFDQuery.Create(Self);
  query.Connection := dm.conexaoBanco;

  try
    query.SQL.Add(SQL);
    query.Open(SQL);

    query.Loop(
    procedure
    begin
      if not dicio.ContainsKey(query.FieldByName('cd_cliente').AsInteger) then
        dicio.Add(query.FieldByName('cd_cliente').AsInteger, query.FieldByName('nome').AsString);
    end
    );

    Memo4.Lines.Clear;
    for var teste in dicio.Keys do
    begin
      Memo4.Lines.Add(teste.ToString + ' - ' + dicio.Items[teste]);
    end;


  finally
    query.Free;
    dicio.Free;
  end;
end;

procedure TfrmLista.FormCreate(Sender: TObject);
begin
  DBGrid2.DataSource := dsPedido;
end;

end.
