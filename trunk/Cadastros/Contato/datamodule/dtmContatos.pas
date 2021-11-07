unit dtmContatos;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  TdmContatos = class(TDataModule)
    dsContatos: TDataSource;
    cdsContatos: TClientDataSet;
    cdsContatoscd_contato: TIntegerField;
    cdsContatostp_pessoa: TStringField;
    cdsContatosnm_contato: TStringField;
    cdsContatoslogradouro: TStringField;
    cdsContatosbairro: TStringField;
    cdsContatoscidade: TStringField;
    cdsContatosnr_documento: TStringField;
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
