unit fFiredacETL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.BatchMove.SQL, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Stan.Intf, Datasnap.DBClient, uDataModule,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Comp.BatchMove.Text, Vcl.StdCtrls;

type
  TfrmFiredacETL = class(TForm)
    DBGrid1: TDBGrid;
    BathMove: TFDBatchMove;
    DataSetWrite: TFDBatchMoveDataSetWriter;
    textReader: TFDBatchMoveTextReader;
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    btnListar: TButton;
    dialog: TOpenDialog;
    edtCaminho: TEdit;
    btnSel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnSelClick(Sender: TObject);
  private
    { Private declarations }
    procedure Listar;
  public
    { Public declarations }
  end;

var
  frmFiredacETL: TfrmFiredacETL;

implementation

{$R *.dfm}

procedure TfrmFiredacETL.btnListarClick(Sender: TObject);
begin
  Listar;
end;

procedure TfrmFiredacETL.btnSelClick(Sender: TObject);
begin
  if dialog.Execute then
  begin
    edtCaminho.Text := dialog.FileName;
    textReader.FileName := edtCaminho.Text;
  end;
end;

procedure TfrmFiredacETL.FormCreate(Sender: TObject);
begin
  DBGrid1.DataSource := DataSource1;
end;

procedure TfrmFiredacETL.Listar;
begin
  BathMove.Execute;
end;

end.
