unit fGridsThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, Vcl.StdCtrls, FireDAC.Comp.Client, Vcl.ExtCtrls, uThreadGrids;

type
  TfThreads = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    ds1: TDataSource;
    ds2: TDataSource;
    ds3: TDataSource;
    ds4: TDataSource;
    cds1: TClientDataSet;
    cds2: TClientDataSet;
    cds3: TClientDataSet;
    cds4: TClientDataSet;
    btnListar: TButton;
    pnlTela: TPanel;
    pnlTopo: TPanel;
    pnlGrid1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FThreadProdutos: TThreadGrids;
    procedure IniciaThread;
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;

implementation

uses
  uDataModule, uUtil;

{$R *.dfm}

procedure TfThreads.btnListarClick(Sender: TObject);
begin
  IniciaThread;
end;

procedure TfThreads.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  FThreadProdutos.Free;
end;

procedure TfThreads.FormCreate(Sender: TObject);
begin
  DBGrid1.DataSource := ds1;
  DBGrid2.DataSource := ds2;
  DBGrid3.DataSource := ds3;
  DBGrid4.DataSource := ds4;
end;

procedure TfThreads.IniciaThread;
begin
  FThreadProdutos := TThreadGrids.Create;
  FThreadProdutos.DatasetProdutos := cds1;
  FThreadProdutos.DataSetPedidos := cds3;
  FThreadProdutos.DataSetPedidosItem := cds4;
  FThreadProdutos.DataSetProdutosBarras := cds2;
  FThreadProdutos.Start;
end;

end.
