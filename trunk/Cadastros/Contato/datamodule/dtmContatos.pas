unit dtmContatos;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  TdmContatos = class(TDataModule)
    dsContatos: TDataSource;
    cdsContatos: TClientDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmContatos: TdmContatos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
