unit uclNotaEntrada;

interface

uses uDataModule, Data.DB, FireDAC.Stan.Param, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, dNotaEntrada;


type
  TInfoProdutos = record
    CodItem,
    DescProduto,
    UnMedida: string;
    FatorConversao: Integer;
end;

type TNotaEntrada = class

type
  TTipoTributacao = (eICMS, eIPI, ePISCOFINS);

  private
    FDadosNota: TdmNotaEntrada;
    procedure SetDadosNota(const Value: TdmNotaEntrada);

  public
    function BuscaClienteFornecedor(CodCliente: Integer): Boolean;
    function GetIdItem(CdItem: string): Int64;
    function Pesquisar(CodItem: string): Boolean;
    function GravaCabecalho(Conexao: TFDConnection): Boolean;
    function GravaItens(Conexao: TFDConnection): Boolean;
    function PossuiNotaLancada(Numero, CodFornecedor: Integer; Serie: string): Boolean;
    function GetSerieNfc(Serie: string): string;
    function CalculaImposto(ValorBase, Aliquota: Currency; Tributacao: TTipoTributacao): Currency;
    function GetNomeModeloNota(CodModelo: string): String;
    function GetInfoProduto(const CodItem: String): TInfoProdutos;
    constructor Create;
    destructor Destroy; override;

    property DadosNota: TdmNotaEntrada read FDadosNota write SetDadosNota;
end;

implementation

uses
  System.SysUtils, Vcl.Dialogs, uUtil, uConexao, uManipuladorTributacao,
  uTributacaoICMS, uTributacaoIPI, uclNFI;

{ TValidacoesEntrada }

function TNotaEntrada.BuscaClienteFornecedor(CodCliente: Integer): Boolean;
const
  sql = ' select            '+
        '    cd_cliente,    '+
        '    nome           '+
        ' from              '+
        '   cliente         '+
        ' where             '+
        '   cd_cliente = :cd_cliente';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conexaoBanco;

  try
    qry.Open(sql, [CodCliente]);

    Result := not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function TNotaEntrada.CalculaImposto(ValorBase, Aliquota: Currency; Tributacao: TTipoTributacao): Currency;
var
  manipulador: TManipuladorTributacao;
begin
  Result := 0;
  manipulador := nil;
  if Tributacao = eICMS then
    manipulador := TManipuladorTributacao.Create(TTributacaoICMS.Create)
  else if Tributacao = eIPI then
    manipulador := TManipuladorTributacao.Create(TTributacaoIPI.Create);

  if Assigned(manipulador) then
  begin
    try
      Result := manipulador.CalculaImposto(ValorBase, Aliquota);
    finally
      manipulador.Free;
    end;
  end;
end;

constructor TNotaEntrada.Create;
begin
  FDadosNota := TdmNotaEntrada.Create(nil);
end;

destructor TNotaEntrada.Destroy;
begin
  FDadosNota.Free;
  inherited;
end;

function TNotaEntrada.GetIdItem(CdItem: string): Int64;
const
  SQL = 'select id_item from produto where cd_produto = :cd_produto';
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
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

function TNotaEntrada.GetSerieNfc(Serie: string): string;
const
  SQL = 'select nr_serie from serie_nf where nr_serie = :nr_serie';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [Serie]);

    if query.IsEmpty then
      Exit('');

    Result := query.FieldByName('nr_serie').AsString;
  finally
    query.Free;
  end;
end;

function TNotaEntrada.GetNomeModeloNota(CodModelo: string): String;
const
  SQL = 'select '                    +
        '    cd_modelo, '            +
        '    nm_modelo '             +
        'from '                      +
        '    modelo_nota_fiscal mfn '+
        'where '                     +
        '    cd_modelo = :cd_modelo';
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(nil);
  consulta.Connection := dm.conexaoBanco;

  try
    consulta.Open(SQL, [CodModelo]);
    Result := consulta.FieldByName('nm_modelo').AsString;
  finally
    consulta.Free;
  end;
end;

function TNotaEntrada.GetInfoProduto(const CodItem: String): TInfoProdutos;
const
  SQL = 'select                 '+
        '    cd_produto,        '+
        '    desc_produto,      '+
        '    un_medida,         '+
        '    fator_conversao    '+
        'from                   '+
        '    produto            '+
        'where                  '+
        'cd_produto = :cd_produto';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [CodItem]);

    Result.CodItem := query.FieldByName('cd_produto').AsString;
    Result.DescProduto := query.FieldByName('desc_produto').AsString;
    Result.UnMedida := query.FieldByName('un_medida').AsString;
    Result.FatorConversao := query.FieldByName('fator_conversao').AsInteger;
  finally
    query.Free;
  end;
end;

function TNotaEntrada.GravaCabecalho(Conexao: TFDConnection): Boolean;
{$REGION 'SQL'}
const
    SQL_INSERT_NFC =  'insert               '+
                '    into                   '+
                '    nfc (id_geral,         '+
                '    dcto_numero,           '+
                '    serie,                 '+
                '    cd_fornecedor,         '+
                '    dt_emissao,            '+
                '    dt_recebimento,        '+
                '    dt_lancamento,         '+
                '    cd_operacao,           '+
                '    cd_modelo,             '+
                '    valor_servico,         '+
                '    vl_base_icms,          '+
                '    valor_icms,            '+
                '    valor_frete,           '+
                '    valor_ipi,             '+
                '    valor_iss,             '+
                '    valor_desconto,        '+
                '    valor_acrescimo,       '+
                '    valor_outras_despesas, '+
                '    valor_total)           '+
                'values(:id_geral,          '+
                '    :dcto_numero,          '+
                '    :serie,                '+
                '    :cd_fornecedor,        '+
                '    :dt_emissao,           '+
                '    :dt_recebimento,       '+
                '    :dt_lancamento,        '+
                '    :cd_operacao,          '+
                '    :cd_modelo,            '+
                '    :valor_servico,        '+
                '    :vl_base_icms,         '+
                '    :valor_icms,           '+
                '    :valor_frete,          '+
                '    :valor_ipi,            '+
                '    :valor_iss,            '+
                '    :valor_desconto,       '+
                '    :valor_acrescimo,      '+
                '    :valor_outras_despesas,'+
                '    :valor_total)' ;
{$ENDREGION}
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := Conexao;

  try
    query.SQL.Add(SQL_INSERT_NFC);
    query.ParamByName('id_geral').AsLargeInt := DadosNota.cdsNfc.FieldByName('id_geral').AsLargeInt;
    query.ParamByName('dcto_numero').AsInteger := DadosNota.cdsNfc.FieldByName('dcto_numero').AsInteger;
    query.ParamByName('serie').AsString := DadosNota.cdsNfc.FieldByName('serie').AsString;
    query.ParamByName('cd_fornecedor').AsInteger := DadosNota.cdsNfc.FieldByName('cd_fornecedor').AsInteger;
    query.ParamByName('dt_emissao').AsDateTime := DadosNota.cdsNfc.FieldByName('dt_emissao').AsDateTime;
    query.ParamByName('dt_recebimento').AsDateTime := DadosNota.cdsNfc.FieldByName('dt_recebimento').AsDateTime;
    query.ParamByName('dt_lancamento').AsDateTime := DadosNota.cdsNfc.FieldByName('dt_lancamento').AsDateTime;
    query.ParamByName('cd_operacao').AsInteger := DadosNota.cdsNfc.FieldByName('cd_operacao').AsInteger;
    query.ParamByName('cd_modelo').AsString := DadosNota.cdsNfc.FieldByName('cd_modelo').AsString;
    query.ParamByName('valor_servico').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_servico').AsCurrency;
    query.ParamByName('vl_base_icms').AsCurrency := DadosNota.cdsNfc.FieldByName('vl_base_icms').AsCurrency;
    query.ParamByName('valor_icms').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_icms').AsCurrency;
    query.ParamByName('valor_frete').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_frete').AsCurrency;
    query.ParamByName('valor_ipi').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_ipi').AsCurrency;
    query.ParamByName('valor_iss').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_iss').AsCurrency;
    query.ParamByName('valor_desconto').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_desconto').AsCurrency;
    query.ParamByName('valor_acrescimo').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_acrescimo').AsCurrency;
    query.ParamByName('valor_outras_despesas').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_outras_despesas').AsCurrency;
    query.ParamByName('valor_total').AsCurrency := DadosNota.cdsNfc.FieldByName('valor_total').AsCurrency;

    query.ExecSQL;
    Conexao.Commit;
    Result := True;
  finally
    query.Free;
  end;
end;

function TNotaEntrada.GravaItens(Conexao: TFDConnection): Boolean;
var
  totalItem,
  total,
  pcItem: Double;
  nfi: TNFI;
begin
  nfi := TNFI.Create;

  try
    DadosNota.cdsNfi.Loop(
    procedure
    begin
      //soma a quantidade dos itens de todos os produtos lançados
      totalItem := DadosNota.cdsNfi.FieldByName('valor_total').AsCurrency;
      total := DadosNota.cdsNfc.FieldByName('valor_total').AsCurrency
               + DadosNota.cdsNfc.FieldByName('valor_acrescimo').AsCurrency
               - DadosNota.cdsNfc.FieldByName('valor_desconto').AsCurrency;

      pcItem := totalItem / total;

      nfi.id_geral := DadosNota.cdsNfi.FieldByName('id_geral').AsLargeInt;
      nfi.id_nfc := DadosNota.cdsNfc.FieldByName('id_geral').AsLargeInt;
      nfi.id_item := DadosNota.cdsNfi.FieldByName('id_item').AsLargeInt;
      nfi.qtd_estoque := DadosNota.cdsNfi.FieldByName('qtd_estoque').AsFloat;
      nfi.un_medida := DadosNota.cdsNfi.FieldByName('un_medida').AsString;
      nfi.vl_unitario := DadosNota.cdsNfi.FieldByName('vl_unitario').AsCurrency;
      nfi.vl_frete_rateado := DadosNota.cdsNfc.FieldByName('valor_frete').AsCurrency * pcItem;
      nfi.vl_desconto_rateado := DadosNota.cdsNfc.FieldByName('valor_desconto').AsCurrency * pcItem;
      nfi.vl_acrescimo_rateado := DadosNota.cdsNfc.FieldByName('valor_acrescimo').AsCurrency * pcItem;

      nfi.seq_item_nfi := DadosNota.cdsNfi.FieldByName('seq_item_nfi').AsInteger;
      nfi.icms_vl_base := DadosNota.cdsNfi.FieldByName('icms_vl_base').AsCurrency;
      nfi.icms_pc_aliq := DadosNota.cdsNfi.FieldByName('icms_pc_aliq').AsFloat;
      nfi.icms_valor := DadosNota.cdsNfi.FieldByName('icms_valor').AsCurrency;
      nfi.ipi_vl_base := DadosNota.cdsNfi.FieldByName('ipi_vl_base').AsCurrency;
      nfi.ipi_pc_aliq := DadosNota.cdsNfi.FieldByName('ipi_pc_aliq').AsFloat;
      nfi.ipi_valor := DadosNota.cdsNfi.FieldByName('ipi_valor').AsCurrency;
      nfi.pis_cofins_vl_base := DadosNota.cdsNfi.FieldByName('pis_cofins_vl_base').AsCurrency;
      nfi.pis_cofins_pc_aliq := DadosNota.cdsNfi.FieldByName('pis_cofins_pc_aliq').AsFloat;
      nfi.pis_cofins_valor := DadosNota.cdsNfi.FieldByName('pis_cofins_valor').AsCurrency;
      nfi.valor_total := DadosNota.cdsNfi.FieldByName('valor_total').AsCurrency;
      nfi.Persistir(True);
    end
    );
//    Conexao.Commit;
    Result := True;
  finally
    nfi.Free;
  end;
end;

function TNotaEntrada.Pesquisar(CodItem: string): Boolean;
const
  SQL = 'select 1 from produto where cd_produto = :cd_produto';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [CodItem]);
    Result := not query.IsEmpty;
  finally
    query.Free;
  end;
end;

function TNotaEntrada.PossuiNotaLancada(Numero, CodFornecedor: Integer; Serie: string): Boolean;
const
  SQL = 'select          '+
        ' dcto_numero,   '+
        ' cd_fornecedor, '+
        ' serie          '+
        'from            '+
        ' nfc            '+
        'where           '+
        ' dcto_numero = :dcto_numero '+
        ' and cd_fornecedor = :cd_fornecedor '+
        ' and serie = :serie';
var
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  query.Connection := dm.conexaoBanco;

  try
    query.Open(SQL, [Numero, CodFornecedor, Serie]);
    Result := not query.IsEmpty;

  finally
    query.Free;
  end;
end;

procedure TNotaEntrada.SetDadosNota(const Value: TdmNotaEntrada);
begin
  FDadosNota := Value;
end;

end.
