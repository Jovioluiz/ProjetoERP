unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Phys.PG, IniFiles, Datasnap.DBClient;

type
  Tdm = class(TDataModule)
    conexaoBanco: TFDConnection;
    driver: TFDPhysPgDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    dsControleAcesso: TDataSource;
    cdsControleAcesso: TClientDataSet;
    cdsControleAcessocd_usuario: TIntegerField;
    cdsControleAcessocd_acao: TIntegerField;
    cdsControleAcessonm_acao: TStringField;
    cdsControleAcessofl_permite_acesso: TBooleanField;
    cdsControleAcessofl_permite_edicao: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    function FGetConexao: TFDConnection;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
var
  conexaoIni: TIniFile;
  msg: string;
begin
  conexaoIni := TIniFile.Create(GetCurrentDir + '\conexao\conexao.ini');

  try
    try
      conexaoBanco.Params.Values['Server'] := conexaoIni.ReadString('configuracoes', 'servidor', conexaoBanco.Params.Values['Server']);
      conexaoBanco.Params.Database := conexaoIni.ReadString('configuracoes', 'banco', conexaoBanco.Params.Database);
      conexaoBanco.Params.UserName := conexaoIni.ReadString('configuracoes', 'usuario', conexaoBanco.Params.UserName);
      conexaoBanco.Params.Password := conexaoIni.ReadString('configuracoes', 'senha', conexaoBanco.Params.Password);
      conexaoBanco.Params.Values['Port'] := conexaoIni.ReadString('configuracoes', 'porta', conexaoBanco.Params.Values['Port']);
      driver.VendorLib := GetCurrentDir + '\lib\libpq.dll';
      conexaoBanco.Connected := True;

    except
      on e:Exception do
      begin
        msg := 'Erro ao conectar no banco de dados ' + conexaoBanco.Params.Database
               + #13 + ' Verifique o arquivo de conexao.' + #13;
        raise Exception.Create(msg + e.Message);
      end;
    end;
  finally
    conexaoIni.Free;
  end;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FDGUIxWaitCursor1.Free;
  if Assigned(cdsControleAcesso) then
    if cdsControleAcesso.Active then
      dsControleAcesso.Destroy;

  conexaoBanco.Free;

  inherited;
end;


function Tdm.FGetConexao: TFDConnection;
begin
  Result := conexaoBanco;
end;

end.
