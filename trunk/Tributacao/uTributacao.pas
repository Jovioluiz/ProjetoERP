unit uTributacao;

interface

uses
  FireDAC.Comp.Client, Datasnap.DBClient;

type TTributacao = class

type
  TAliqItem = record
    AliqIcms,
    AliqIpi,
    AliqPisCofins: Currency
end;
  private
    function CalculaImposto(ValorBase, Aliquota: Currency): Currency;

  public
    procedure RecalculaTributacao(DataSet: TClientDataset);
end;

implementation

uses
  uDataModule, uUtil;

{ TTributacao }

procedure TTributacao.RecalculaTributacao(DataSet: TClientDataset);
begin

  DataSet.Loop(
  procedure
  begin
    DataSet.Edit;
    DataSet.FieldByName('icms_vl_base').AsCurrency := DataSet.FieldByName('vl_total_item').AsCurrency;
    DataSet.FieldByName('icms_valor').AsCurrency := CalculaImposto(DataSet.FieldByName('icms_vl_base').AsCurrency, DataSet.FieldByName('icms_pc_aliq').AsCurrency);
    DataSet.FieldByName('ipi_vl_base').AsCurrency := DataSet.FieldByName('vl_total_item').AsCurrency;
    DataSet.FieldByName('ipi_valor').AsCurrency := CalculaImposto(DataSet.FieldByName('ipi_vl_base').AsCurrency, DataSet.FieldByName('ipi_pc_aliq').AsCurrency);
    DataSet.FieldByName('pis_cofins_vl_base').AsCurrency := DataSet.FieldByName('vl_total_item').AsCurrency;
    DataSet.FieldByName('pis_cofins_valor').AsCurrency := CalculaImposto(DataSet.FieldByName('pis_cofins_vl_base').AsCurrency, DataSet.FieldByName('pis_cofins_pc_aliq').AsCurrency);
    DataSet.Post;
  end
  );
end;

function TTributacao.CalculaImposto(ValorBase, Aliquota: Currency): Currency;
begin
  Result := (ValorBase * Aliquota) / 100;
end;

end.
