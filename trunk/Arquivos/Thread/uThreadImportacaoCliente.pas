unit uThreadImportacaoCliente;

interface

uses
  uThreadGenerica;

type
  TThreadImportacaoCliente = class(TThreadGenerica)
    private
      FCaminho: string;
      procedure SalvarCliente;
      function GetIdCliente: Integer;
    public
      procedure Execute; override;
      property Caminho: string read FCaminho write FCaminho;
  end;

implementation

uses
  FireDAC.Comp.Client, System.Classes, uDataModule, System.SysUtils,
  Vcl.Dialogs, uclCliente;

{ TThreadImportacaoCliente }

procedure TThreadImportacaoCliente.Execute;
begin
  inherited;
  SalvarCliente;
end;

function TThreadImportacaoCliente.GetIdCliente: Integer;
var
  cliente: TCliente;
begin
  cliente := TCliente.Create;

  try
    Result := cliente.GeraCodigoCliente;
  finally
    cliente.Free;
  end;
end;

procedure TThreadImportacaoCliente.SalvarCliente;
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
  consulta: TFDquery;
  stringListFile: TStringList;
  strinListLinha: TStringList;
  cont: Integer;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;
  consulta.Connection.StartTransaction;
  stringListFile := TStringList.Create;
  strinListLinha := TStringList.Create;

  try
    try
      consulta.SQL.Add(SQL);
      stringListFile.LoadFromFile(FCaminho);

      // Configura o tamanho do array de inserções
      consulta.Params.ArraySize := stringListFile.Count;

      for cont := 0 to Pred(stringListFile.Count) do
      begin
        strinListLinha.StrictDelimiter := True;

        // TStringList recebe o conteúdo da linha atual
        strinListLinha.CommaText := stringListFile[cont];

        consulta.ParamByName('cd_cliente').AsIntegers[cont] := GetIdCliente;
        consulta.ParamByName('nome').AsStrings[cont] := strinListLinha[0];
        consulta.ParamByName('tp_pessoa').AsStrings[cont] := strinListLinha[1];
        consulta.ParamByName('fl_ativo').AsBooleans[cont] := True;
        consulta.ParamByName('telefone').AsStrings[cont] := strinListLinha[2];
        consulta.ParamByName('celular').AsStrings[cont] := strinListLinha[3];
        consulta.ParamByName('email').AsStrings[cont] := strinListLinha[4];
        consulta.ParamByName('cpf_cnpj').AsStrings[cont] := strinListLinha[5];
        consulta.ParamByName('rg_ie').AsStrings[cont] := strinListLinha[6];
        consulta.ParamByName('dt_nasc_fundacao').AsDateTimes[cont] := StrToDateTime(strinListLinha[7]);
      end;

      // Executa as inserções em lote
      consulta.Execute(stringListFile.Count, 0);
      consulta.Connection.Commit;
      ShowMessage('Dados gravados com Sucesso');
    except
      on e:Exception do
      begin
        consulta.Connection.Rollback;
        raise Exception.Create('Erro ao gravar os Dados ' + #13 + e.Message);
      end;
    end;

  finally
    consulta.Connection.Rollback;
    stringListFile.Free;
    strinListLinha.Free;
    consulta.Free;
  end;
end;

end.
