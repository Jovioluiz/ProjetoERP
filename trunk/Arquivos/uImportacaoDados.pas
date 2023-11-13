unit uImportacaoDados;

interface

uses
  System.Classes, dImportaDados, System.Generics.Collections;

type TImportacaoDados = class

  private
    FDados: TdmImportaDados;
    FListaProdutos: TList<String>;
  public

  constructor Create;
  procedure ParseDelimited(const sl: TStrings; const value, delimiter: string);
  function SalvarProduto: Boolean;
  procedure ListaProdutos(Caminho: String);
  procedure SalvarCliente(Caminho: String);
  procedure ListaClientes(Caminho: String);
  procedure CarregaProdutos;
  destructor Destroy; override;
  procedure ImportarDadosTeste;

  property Dados: TdmImportaDados read FDados;
end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, uclProduto, System.SysUtils, Vcl.Dialogs,
  Vcl.Samples.Gauges, uUtil, Data.DB, FireDAC.Stan.Param, FireDAC.Phys.Intf,
  Vcl.ComCtrls, uThreadImportacaoArquivo, uThreadImportacaoCliente;

{ TImportacaoDados }

procedure TImportacaoDados.CarregaProdutos;
const
  SQL = 'select cd_produto from produto';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(SQL);
    qry.Open();

    if qry.IsEmpty then
      Exit;

    qry.Loop(
    procedure
    begin
      FListaProdutos.Add(qry.FieldByName('cd_produto').AsString);
    end
    );

  finally
    qry.Free;
  end;
end;

constructor TImportacaoDados.Create;
begin
  inherited;
  FDados := TdmImportaDados.Create(nil);
  FListaProdutos := TList<String>.Create;
end;

destructor TImportacaoDados.Destroy;
begin
  FDados.Free;
  FListaProdutos.Free;
  inherited;
end;

procedure TImportacaoDados.ImportarDadosTeste;
var
  threadImportacao: TThreadImportacaoArquivo;
begin
  threadImportacao := TThreadImportacaoArquivo.Create;
  threadImportacao.Start;
end;

procedure TImportacaoDados.ListaClientes(Caminho: String);
var
  linhas,
  temp: TStringList;
  I: integer;
begin
  linhas := TStringList.Create;
  temp := TStringList.Create;
  linhas.LoadFromFile(Caminho);
  Dados.cdsClientes.EmptyDataSet;
  Dados.cdsClientes.DisableControls;

  try
    for I := 0 to Pred(linhas.Count) do
    begin
      ParseDelimited(temp, linhas[I], ',');
      Dados.cdsClientes.Append;
      Dados.cdsClientes.FieldByName('seq').AsInteger := I + 1;
      Dados.cdsClientes.FieldByName('nm_cliente').AsString := temp[0];
      Dados.cdsClientes.FieldByName('tp_pessoa').AsString := temp[1];
      Dados.cdsClientes.FieldByName('celular').AsString := temp[2];
      Dados.cdsClientes.FieldByName('telefone').AsString := temp[3];
      Dados.cdsClientes.FieldByName('email').AsString := temp[4];
      Dados.cdsClientes.FieldByName('cpf_cnpj').AsString := temp[5];
      Dados.cdsClientes.FieldByName('rg_ie').AsString := temp[6];
      Dados.cdsClientes.FieldByName('dt_nasc_fundacao').AsDateTime := StrToDate(temp[7]);
      Dados.cdsClientes.Post;
    end;
  finally
    Dados.cdsClientes.EnableControls;
    linhas.Free;
    temp.Free;
  end;
end;

procedure TImportacaoDados.ListaProdutos(Caminho: String);
var
  linhas, temp: TStringList;
  I: integer;
  delimiter: TArray<string>;
begin
  linhas := TStringList.Create;
  temp := TStringList.Create;
  linhas.LoadFromFile(Caminho);
  Dados.cdsProdutos.EmptyDataSet;
  Dados.cdsProdutos.DisableControls;

  try
    CarregaProdutos;

    for I := 0 to Pred(linhas.Count) do
    begin
      ParseDelimited(temp, linhas[I], ';');

      delimiter := linhas.Strings[I].Split([';']);

      //se o código do produto já está no banco, não mostra no grid
      if FListaProdutos.Contains(temp[0]) then
        Continue;

      Dados.cdsProdutos.Append;
      Dados.cdsProdutos.FieldByName('seq').AsInteger := I + 1;
      Dados.cdsProdutos.FieldByName('cd_produto').AsInteger := StrToInt(delimiter[0]);
      Dados.cdsProdutos.FieldByName('desc_produto').AsString := delimiter[1];
      Dados.cdsProdutos.FieldByName('un_medida').AsString := delimiter[2];
      Dados.cdsProdutos.FieldByName('fator_conversao').AsInteger := StrToInt(delimiter[3]);
      Dados.cdsProdutos.FieldByName('peso_liquido').AsFloat := StrToFloat(delimiter[4]);
      Dados.cdsProdutos.FieldByName('peso_bruto').AsFloat := StrToFloat(delimiter[5]);
      Dados.cdsProdutos.Post;
    end;
  finally
    Dados.cdsProdutos.EnableControls;
    linhas.Free;
    temp.Free;
  end;
end;

procedure TImportacaoDados.SalvarCliente(Caminho: String);
var
  threadCliente: TThreadImportacaoCliente;
begin
  threadCliente := TThreadImportacaoCliente.Create;
  threadCliente.Caminho := Caminho;
  threadCliente.Start;
end;

function TImportacaoDados.SalvarProduto: Boolean;
const
  SQL_INSERT =  'insert ' +
                ' into  ' +
                '   produto ' +
                '(cd_produto, ' +
                '   fl_ativo,    ' +
                '   desc_produto, ' +
                '   un_medida,    ' +
                '   fator_conversao, ' +
                '   peso_liquido,    ' +
                '   peso_bruto,      ' +
                '   id_item)' +
                'values (:cd_produto, ' +
                '   :fl_ativo,        ' +
                '   :desc_produto,    ' +
                '   :un_medida,       ' +
                '   :fator_conversao, ' +
                '   :peso_liquido,    ' +
                '   :peso_bruto,      ' +
                '   :id_item)';
var
  qry: TFDquery;
  produto: TProduto;
  inicio: TDateTime;
  barraProgresso: TProgressBar;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;
  produto := TProduto.Create;
  barraProgresso := TProgressBar.Create(nil);
  FDados.cdsProdutos.DisableControls;
  try
    try
      barraProgresso.Visible := True;
      qry.SQL.Add(SQL_INSERT);
      inicio := Now;
      //se FDados.cdsProdutos.RecordCount * 8(numero de parametros) > 65535 da erro (postgres), mas mesmo assim insere os registros
      qry.Params.ArraySize := FDados.cdsProdutos.RecordCount;
      barraProgresso.Min := 0;
      barraProgresso.Max := FDados.cdsProdutos.RecordCount;
      barraProgresso.State := pbsNormal;
      FDados.cdsProdutos.First;
      for var I := 0 to Pred(FDados.cdsProdutos.RecordCount) do
      begin
        barraProgresso.Position := I;
        barraProgresso.Repaint;
        qry.ParamByName('cd_produto').AsStrings[I] := FDados.cdsProdutos.FieldByName('cd_produto').AsString;
        qry.ParamByName('fl_ativo').AsBooleans[I] := True;
        qry.ParamByName('desc_produto').AsStrings[I] := FDados.cdsProdutos.FieldByName('desc_produto').AsString;
        qry.ParamByName('un_medida').AsStrings[I] := FDados.cdsProdutos.FieldByName('un_medida').AsString;
        qry.ParamByName('fator_conversao').AsIntegers[I] := FDados.cdsProdutos.FieldByName('fator_conversao').AsInteger;
        qry.ParamByName('peso_liquido').AsFloats[I] := FDados.cdsProdutos.FieldByName('peso_liquido').AsFloat;
        qry.ParamByName('peso_bruto').AsFloats[I] := FDados.cdsProdutos.FieldByName('peso_bruto').AsFloat;
        qry.ParamByName('id_item').AsLargeInts[I] := produto.GeraIdItem;
        FDados.cdsProdutos.Next;
      end;
      qry.Execute(qry.Params.ArraySize, 0);
      qry.Connection.Commit;

      ShowMessage('Dados gravados com Sucesso - ' + FormatDateTime('hh:mm:ss:zzz', Now - inicio) + ' ' + qry.RowsAffected.ToString);
      Result := True;

    except
      on e:Exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os Dados ' + #13 + e.Message);
      end;
    end;

  finally
    FDados.cdsProdutos.EnableControls;
    qry.Connection.Rollback;
    qry.Free;
    produto.Free;
    barraProgresso.Free;
  end;
end;

procedure TImportacaoDados.ParseDelimited(const sl: TStrings; const value: string; const delimiter: string);
var
  dx : integer;
  ns : string;
  txt : string;
  delta : integer;
begin
  delta := Length(delimiter) ;
  txt := value + delimiter;
  sl.BeginUpdate;
  sl.Clear;
  try
    while Length(txt) > 0 do
    begin
      dx := Pos(delimiter, txt) ;
      ns := Copy(txt, 0, dx-1) ;
      sl.Add(ns) ;
      txt := Copy(txt, dx+delta, MaxInt);
    end;
  finally
    sl.EndUpdate;
  end;
end;

end.
