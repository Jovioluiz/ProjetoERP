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

  property Dados: TdmImportaDados read FDados;
end;

implementation

uses
  FireDAC.Comp.Client, uDataModule, uclProduto, System.SysUtils, Vcl.Dialogs,
  Vcl.Samples.Gauges, uUtil, Data.DB, FireDAC.Stan.Param;

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

procedure TImportacaoDados.ListaClientes(Caminho: String);
var
  linhas, temp: TStringList;
  i: integer;
begin
  linhas := TStringList.Create;
  temp := TStringList.Create;
  linhas.LoadFromFile(Caminho);
  Dados.cdsClientes.EmptyDataSet;
  Dados.cdsClientes.DisableControls;

  try
    for i := 0 to Pred(linhas.Count) do
    begin
      ParseDelimited(temp, linhas[i], ';');
      Dados.cdsClientes.Append;
      Dados.cdsClientes.FieldByName('seq').AsInteger := i + 1;
      Dados.cdsClientes.FieldByName('cd_cliente').AsInteger := StrToInt(temp[0]);
      Dados.cdsClientes.FieldByName('nm_cliente').AsString := temp[1];
      Dados.cdsClientes.FieldByName('tp_pessoa').AsString := temp[2];
      Dados.cdsClientes.FieldByName('celular').AsString := temp[3];
      Dados.cdsClientes.FieldByName('email').AsString := temp[4];
      Dados.cdsClientes.FieldByName('telefone').AsString := temp[5];
      Dados.cdsClientes.FieldByName('cpf_cnpj').AsString := temp[6];
      Dados.cdsClientes.FieldByName('rg_ie').AsString := temp[7];
      Dados.cdsClientes.FieldByName('dt_nasc_fundacao').AsDateTime := StrToDate(temp[8]);
      Dados.cdsClientes.Post;
    end;
  finally
    Dados.cdsClientes.EnableControls;
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
  end;
end;

procedure TImportacaoDados.SalvarCliente(Caminho: String);
const
  SQL = 'insert ' +
        '   into         ' +
        '     cliente    ' +
        '   (cd_cliente, ' +
        '    nome,       ' +
        '   tp_pessoa,   ' +
        '   fl_ativo,    ' +
        '   telefone,    ' +
        '   celular,     ' +
        '   email,       ' +
            'cpf_cnpj,   ' +
        '   rg_ie,       ' +
        '   dt_nasc_fundacao)' +
        'values (:cd_cliente,' +
        '   :nome,           ' +
        '   :tp_pessoa,      ' +
        '   :fl_ativo,       ' +
        '   :telefone,       ' +
        '   :celular,        ' +
        '   :email,          ' +
        '   :cpf_cnpj,       ' +
        '   :rg_ie,          ' +
        '   :dt_nasc_fundacao)';
var
  qry: TFDquery;
  stringListFile: TStringList;
  strinListLinha: TStringList;
  cont: Integer;
  gauge: TGauge;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;

  gauge := TGauge.Create(nil);
  // TStringList que carrega todo o conteúdo do arquivo
  stringListFile := TStringList.Create;

  // TStringList que carrega o conteúdo da linha
  strinListLinha := TStringList.Create;

  if not caminho.EndsWith('.csv') then
    raise Exception.Create('Formato de Arquivo Incorreto. Verifique');

  try
    try
      qry.SQL.Add(SQL);
      stringListFile.LoadFromFile(Caminho);

      // Configura o tamanho do array de inserções
      qry.Params.ArraySize := stringListFile.Count;

      gauge.MaxValue := stringListFile.Count;

      for cont := 0 to Pred(stringListFile.Count) do
      begin
        strinListLinha.StrictDelimiter := True;

        gauge.Visible := True;
        gauge.Progress := gauge.Progress + 1;

        // TStringList recebe o conteúdo da linha atual
        strinListLinha.CommaText := stringListFile[cont];

        qry.ParamByName('cd_cliente').AsIntegers[cont] := StrToInt(strinListLinha[0]);
        qry.ParamByName('nome').AsStrings[cont] := strinListLinha[1];
        qry.ParamByName('tp_pessoa').AsStrings[cont] := strinListLinha[2];
        qry.ParamByName('fl_ativo').AsBooleans[cont] := True;
        qry.ParamByName('telefone').AsStrings[cont] := strinListLinha[3];
        qry.ParamByName('celular').AsStrings[cont] := strinListLinha[4];
        qry.ParamByName('email').AsStrings[cont] := strinListLinha[5];
        qry.ParamByName('cpf_cnpj').AsStrings[cont] := strinListLinha[6];
        qry.ParamByName('rg_ie').AsStrings[cont] := strinListLinha[7];
        qry.ParamByName('dt_nasc_fundacao').AsDateTimes[cont] := StrToDateTime(strinListLinha[8]);
      end;

      // Executa as inserções em lote
      qry.Execute(stringListFile.Count, 0);
      qry.Connection.Commit;
      ShowMessage('Dados gravados com Sucesso');
    except
      on e:Exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os Dados ' + #13 + e.Message);
      end;
    end;

  finally
    gauge.Visible := False;
    qry.Connection.Rollback;
    stringListFile.Free;
    strinListLinha.Free;
    qry.Free;
  end;
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
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;
  qry.Connection.StartTransaction;
  produto := TProduto.Create;

  try
    try
      qry.SQL.Add(SQL_INSERT);
      inicio := Now;
        //se FDados.cdsProdutos.RecordCount * 8(numero de parametros) > 65535 da erro (postgres), mas mesmo assim insere os registros
      qry.Params.ArraySize := FDados.cdsProdutos.RecordCount;
      for var I := 0 to Pred(FDados.cdsProdutos.RecordCount) do
      begin
        qry.ParamByName('cd_produto').AsStrings[I] := FDados.cdsProdutos.FieldByName('cd_produto').AsString;
        qry.ParamByName('fl_ativo').AsBooleans[I] := True;
        qry.ParamByName('desc_produto').AsStrings[I] := FDados.cdsProdutos.FieldByName('desc_produto').AsString;
        qry.ParamByName('un_medida').AsStrings[I] := FDados.cdsProdutos.FieldByName('un_medida').AsString;
        qry.ParamByName('fator_conversao').AsIntegers[I] := FDados.cdsProdutos.FieldByName('fator_conversao').AsInteger;
        qry.ParamByName('peso_liquido').AsFloats[I] := FDados.cdsProdutos.FieldByName('peso_liquido').AsFloat;
        qry.ParamByName('peso_bruto').AsFloats[I] := FDados.cdsProdutos.FieldByName('peso_bruto').AsFloat;
        qry.ParamByName('id_item').AsLargeInts[I] := produto.GeraIdItem;
      end;
      qry.Execute(qry.Params.ArraySize, 0);


//      FDados.cdsProdutos.Loop(
//      procedure
//      begin
//        qry.ParamByName('cd_produto').AsString := FDados.cdsProdutos.FieldByName('cd_produto').AsString;
//        qry.ParamByName('fl_ativo').AsBoolean := True;
//        qry.ParamByName('desc_produto').AsString := FDados.cdsProdutos.FieldByName('desc_produto').AsString;
//        qry.ParamByName('un_medida').AsString := FDados.cdsProdutos.FieldByName('un_medida').AsString;
//        qry.ParamByName('fator_conversao').AsInteger := FDados.cdsProdutos.FieldByName('fator_conversao').AsInteger;
//        qry.ParamByName('peso_liquido').AsFloat := FDados.cdsProdutos.FieldByName('peso_liquido').AsFloat;
//        qry.ParamByName('peso_bruto').AsFloat := FDados.cdsProdutos.FieldByName('peso_bruto').AsFloat;
//        qry.ParamByName('id_item').AsLargeInt := produto.GeraIdItem;
//        qry.ExecSQL;
//      end
//      );

      qry.Connection.Commit;
      ShowMessage('Dados gravados com Sucesso - ' + FormatDateTime('hh:mm:ss:zzz', Now - inicio));
      Result := True;

    except
      on e:Exception do
      begin
        qry.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os Dados ' + #13 + e.Message);
      end;
    end;

  finally
    qry.Connection.Rollback;
    qry.Free;
    produto.Free;
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
