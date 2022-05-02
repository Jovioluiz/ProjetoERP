unit fConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids;

type
  TformConsulta = class(TForm)
    dbGridConsulta: TDBGrid;
    ds: TDataSource;
    cds: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure dbGridConsultaDblClick(Sender: TObject);
  private
    FRegistroSelecionado: Integer;
    FCampoChave: string;
    { Private declarations }
    procedure MontaDataSet(Sql: string);
    procedure CriaDataset(Origem, Destino: TDataSet);
    procedure TransferirDados(Origem, Destino: TDataSet);
    procedure SetRegistroSelecionado(const Value: Integer);
    procedure SetCampoChave(const Value: string);
  public
    procedure CarregaConsulta(SQL: string);

    property CampoChave: string read FCampoChave write SetCampoChave;
    property RegistroSelecionado: Integer read FRegistroSelecionado write SetRegistroSelecionado;
  end;

var
  formConsulta: TformConsulta;

implementation

uses
  FireDAC.Comp.Client, uDataModule, System.SysUtils,
  System.Generics.Collections;

{$R *.dfm}

procedure TformConsulta.CarregaConsulta(SQL: string);
begin
  MontaDataSet(SQL);
end;

procedure TformConsulta.FormCreate(Sender: TObject);
begin
  dbGridConsulta.DataSource := ds;
end;

procedure TformConsulta.MontaDataSet(SQL: string);
var
  consulta: TFDQuery;
begin
  consulta := TFDQuery.Create(Self);
  consulta.Connection := dm.conexaoBanco;
  try
    consulta.Open(SQL);
    CriaDataset(consulta, cds);
  finally
    consulta.Free;
  end;
end;

procedure TformConsulta.SetCampoChave(const Value: string);
begin
  FCampoChave := Value;
end;

procedure TformConsulta.SetRegistroSelecionado(const Value: Integer);
begin
  FRegistroSelecionado := Value;
end;

procedure TformConsulta.TransferirDados(Origem, Destino: TDataSet);
var 
  I: Integer;
begin
  Origem.DisableControls;
  Destino.DisableControls;
  try
    Origem.First;
    while not Origem.Eof do
    begin
      Destino.Append;

      for I := 0 to Origem.Fields.Count - 1 do  
        Destino.Fields[I].Value := Origem.Fields[I].Value;

      Destino.Post;
      Origem.Next;
    end;
  finally
    Origem.First;
    Destino.First;
    Origem.EnableControls;
    Destino.EnableControls;
  end;
end;

procedure TformConsulta.CriaDataset(Origem, Destino: TDataSet);
begin
  if Destino.Active then
    Destino.Close;

  Destino.FieldDefs.Clear;
  for var field in Origem.Fields do
    Destino.FieldDefs.Add(field.FieldName, field.DataType, field.Size);

  if Destino is TClientDataSet then
    TClientDataSet(Destino).CreateDataSet;

  TransferirDados(Origem, Destino);
end;

procedure TformConsulta.dbGridConsultaDblClick(Sender: TObject);
begin
  FRegistroSelecionado := cds.FieldByName(FCampoChave).Value;
  Close;
end;

end.
