unit dUsuario;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmUsuario = class(TDataModule)
    dsUsuario: TDataSource;
    cdsUsuario: TFDMemTable;
    cdsUsuarioid_usuario: TIntegerField;
    cdsUsuariologin: TStringField;
    cdsUsuariosenha: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmUsuario: TdmUsuario;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
