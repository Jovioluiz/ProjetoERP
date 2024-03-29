unit uConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Comp.Client, FireDAC.DApt, FireDAC.Stan.Param,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Datasnap.DBClient, Vcl.StdCtrls, System.StrUtils,
  System.Classes;

type
  TfrmConsulta = class(TForm)
    pnl1: TPanel;
    dbgrd1: TDBGrid;
    cdsConsulta: TClientDataSet;
    dsConsulta: TDataSource;
    rgFiltros: TRadioGroup;
    cdsConsultacd_cliente: TIntegerField;
    cdsConsultanm_cliente: TStringField;
    cdsConsultacpf_cnpj: TStringField;
    edtBusca: TEdit;
    cds: TClientDataSet;
    ds: TDataSource;
    procedure edtBuscaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function MontaDataset(consulta: string): string;
  end;

var
  frmConsulta: TfrmConsulta;
  Matriz: array of array of Integer;

implementation

uses
  uDataModule, cCLIENTE, System.Math, System.UITypes,
  System.Generics.Collections;

{$R *.dfm}



procedure TfrmConsulta.edtBuscaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  sql = 'select    ' +
        '    cd_cliente, ' +
        '    nome,       ' +
        '    cpf_cnpj    ' +
        'from            ' +
        '    cliente ';
var
  qry: TFDQuery;
begin
  if (edtBusca.Text = EmptyStr) or (Key <> 13) then
    Exit;

  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;
  qry.SQL.Add(sql);

  try
    case rgFiltros.ItemIndex of
      0: qry.SQL.Add('where nome ilike '+ QuotedStr('%'+edtBusca.Text+'%'));
      1:
      begin
        qry.SQL.Add('where cd_cliente = :cd_cliente');
        qry.ParamByName('cd_cliente').AsInteger := StrToInt(edtBusca.Text);
      end;
      2: qry.SQL.Add('where cpf_cnpj ilike'+ QuotedStr('%'+edtBusca.Text+'%'));
    end;

    qry.Open();
    cdsConsulta.EmptyDataSet;
    qry.First;

    while not qry.Eof do
    begin
      cdsConsulta.Append;
      cdsConsulta.FieldByName('cd_cliente').AsInteger := qry.FieldByName('cd_cliente').AsInteger;
      cdsConsulta.FieldByName('nm_cliente').AsString := qry.FieldByName('nome').AsString;
      cdsConsulta.FieldByName('cpf_cnpj').AsString := qry.FieldByName('cpf_cnpj').AsString;
      cdsConsulta.Post;
      qry.Next;
    end;

  finally
    qry.Free;
  end;
end;

function TfrmConsulta.MontaDataset(consulta: string): string;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(Self);
  qry.Connection := dm.conexaoBanco;

  try
    qry.SQL.Add(consulta);
    qry.Open();

    Result := '';

//    CloneDatasets(qry, cds);

//    campo := TField.Create(cds);
//    for var i := 0 to Pred(qry.FieldCount) do
//    begin
//      //monta os fields de acordo com os campos da consulta
//      campo.FieldName := qry.Fields[i].FieldName;
//
//      case qry.Fields[i].DataType of
//        ftString: tamanhoCampo := 30;
//        ftInteger: tamanhoCampo := 0;
//        ftFloat: tamanhoCampo := 0;
//        ftCurrency: tamanhoCampo := 0;
//        ftWideString: tamanhoCampo := 30;
//        ftBCD: tamanhoCampo := 0;
//        ftWideMemo: tamanhoCampo := 100;
//      end;
//      campo.SetFieldType(qry.Fields[i].DataType);
//      cds.FieldDefs.Add(UpperCase(campo.FieldName), qry.Fields[i].DataType, tamanhoCampo, false);
//    end;
//
//    cds.CreateDataSet;

//  for i := 0 to Pred(cds.FieldCount) do
//  begin
//    qry.First;
//    while not qry.Eof do
//    begin
//      cds.Append;
//      cds.Fields[j].Value := qry.Fields[j].Value;
//      cds.Post;
//      qry.Next;
//    end;
//  end;

//    cds.First;
//    for linha := 0 to Pred(cds.Fields.Count) do
//    begin
//      cds.FieldDefs[linha].DataType := qry.Fields[linha].DataType;
//      cds.FieldDefs[linha].Name := qry.Fields[linha].FieldName;
//      cds.FieldDefs[linha].Size := qry.Fields[linha].Size;
//      cds.Next;
//    end;

//    qry.First;
//    for var j := 0 to Pred(cds.Fields.Count) do
//    begin
//      dbgrd1.Columns[j].Title.Caption := StringReplace(qry.FieldDefs[j].Name.ToUpper, '_', ' ', []);
//      dbgrd1.Columns[j].FieldName := qry.FieldDefs[j].Name;
//      qry.Next;
//    end;

  finally
    qry.Free;
  end;
end;

end.
