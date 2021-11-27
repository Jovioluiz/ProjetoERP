unit uThread;

interface

uses
  System.Classes, Datasnap.DBClient, FireDAC.Comp.Client, Data.DB;

type
  TThreadTeste = class(TThread)
  private
    FArquivo: TStringList;
    FQuery: TFDQuery;
    FCaminho: string;
    procedure Salvar(campos: array of string; QtCampos: Integer);
  protected
    procedure Execute; override;

  public

    procedure GravaArquivo;
    constructor Create(const Query: TFDQuery; Caminho: String);
  end;

implementation

uses
  Vcl.Dialogs, System.SysUtils;

{ TThread }

constructor TThreadTeste.Create(const Query: TFDQuery; Caminho: String);
begin
  inherited Create(False);
  FQuery := Query;
  FCaminho := Caminho;
end;

procedure TThreadTeste.Execute;
begin
  NameThreadForDebugging('uThread');
  GravaArquivo;
end;

procedure TThreadTeste.GravaArquivo;
var
  campos: array[1 .. 22] of string;
begin

  FArquivo := TStringList.Create;

  try

    FArquivo.Add('Pedido|Cliente|Valor Total|Acrescimo|Desconto Pedido|Data Emissão|Cód. Produto|Qtdade Venda|Un. Medida|Valor Unitário|Desconto '+
                              '|Valor Total Item|ICMS Base|ICMS Aliq|ICMS Valor|IPI Base|IPI Aliq|IPI Valor|PIS/Cofins Base|PIS/Cofins Aliq|PIS/Cofins Valor');

    FQuery.First;

    if not FQuery.IsEmpty then
    begin
      while not FQuery.Eof do
      begin
        campos[1] := FQuery.FieldByName('nr_pedido').AsString;
        campos[2] := FQuery.FieldByName('nome').AsString;
        campos[3] := FQuery.FieldByName('vl_total').AsString;
        campos[4] := FQuery.FieldByName('vl_acrescimo').AsString;
        campos[5] := FQuery.FieldByName('vl_desconto_pedido').AsString;
        campos[6] := FQuery.FieldByName('dt_emissao').AsString;
        campos[7] := FQuery.FieldByName('cd_produto').AsString;
        campos[8] := FQuery.FieldByName('desc_produto').AsString;
        campos[9] := FQuery.FieldByName('qtd_venda').AsString;
        campos[10] := FQuery.FieldByName('un_medida').AsString;
        campos[11] := FQuery.FieldByName('vl_unitario').AsString;
        campos[12] := FQuery.FieldByName('vl_desconto').AsString;
        campos[13] := FQuery.FieldByName('vl_total_item').AsString;
        campos[14] := FQuery.FieldByName('icms_vl_base').AsString;
        campos[15] := FQuery.FieldByName('icms_pc_aliq').AsString;
        campos[16] := FQuery.FieldByName('icms_valor').AsString;
        campos[17] := FQuery.FieldByName('ipi_vl_base').AsString;
        campos[18] := FQuery.FieldByName('ipi_pc_aliq').AsString;
        campos[19] := FQuery.FieldByName('ipi_valor').AsString;
        campos[20] := FQuery.FieldByName('pis_cofins_vl_base').AsString;
        campos[21] := FQuery.FieldByName('pis_cofins_pc_aliq').AsString;
        campos[22] := FQuery.FieldByName('pis_cofins_valor').AsString;


//        FArquivo.Add(FQuery.FieldByName('nr_pedido').AsString +
//                    '|' + FQuery.FieldByName('nome').AsString +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('vl_total').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('vl_acrescimo').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('vl_desconto_pedido').AsCurrency) +
//                    '|'+ FormatDateTime('dd/MM/yyyy', FQuery.FieldByName('dt_emissao').AsDateTime) +
//                    '|'+ FQuery.FieldByName('cd_produto').AsString +
//                    '|'+ FQuery.FieldByName('desc_produto').AsString +
//                    '|'+ FormatFloat('#,##0.00', FQuery.FieldByName('qtd_venda').AsFloat) +
//                    '|'+ FQuery.FieldByName('un_medida').AsString +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('vl_unitario').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('vl_desconto').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('vl_total_item').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('icms_vl_base').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('icms_pc_aliq').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('icms_valor').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('ipi_vl_base').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('ipi_pc_aliq').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('ipi_valor').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('pis_cofins_vl_base').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('pis_cofins_pc_aliq').AsCurrency) +
//                    '|'+ FormatCurr('#,##0.00', FQuery.FieldByName('pis_cofins_valor').AsCurrency));
        Salvar(campos, 22);
        FQuery.Next;
      end;
      FArquivo.SaveToFile(FCaminho);
    end;
  finally
    FArquivo.Free;
  end
end;

procedure TThreadTeste.Salvar(campos: array of string; QtCampos: Integer);
var
  linha: string;
  I: Integer;
begin
  linha := '';
  for I := 0 to Pred(QtCampos) do
  begin
    linha := linha + campos[I];
  end;
  linha := linha + sLineBreak;
  FArquivo.Append(linha);
end;

end.
