unit TestuclPedidoVenda;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, FireDAC.Stan.Option, FireDAC.DApt.Intf, uPedidoVenda,
  System.Generics.Collections, System.UITypes, FireDAC.Stan.Param, uclPedidoVenda,
  System.Classes, Vcl.ExtCtrls, Vcl.StdCtrls, FireDAC.DatS, FireDAC.Stan.Intf,
  FireDAC.Stan.Error, Vcl.Graphics, FireDAC.Phys.Intf, FireDAC.Comp.Client,
  Winapi.Windows, System.Variants, uDataModule, Vcl.Dialogs, FireDAC.Stan.Async,
  FireDAC.DApt, Vcl.Forms, System.SysUtils, Data.DB, Vcl.Controls, Vcl.Mask,
  FireDAC.Comp.DataSet, Winapi.Messages;

type
  // Test methods for class TPedidoVenda

  TestTPedidoVenda = class(TTestCase)
  strict private
    FPedidoVenda: TPedidoVenda;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestValidaQtdadeItem;
    procedure TestCalculaValorTotalItem;
    procedure TestValidaFormaPgto;
    procedure TestValidaCliente;
    procedure TestValidaCondPgto;
    procedure TestBuscaProduto;
    procedure TestBuscaProdutoCodBarras;
    procedure TestValidaProduto;
    procedure TestBuscaTabelaPreco;
    procedure TestValidaTabelaPreco;
    procedure TestBuscaFormaPgto;
    procedure TestBuscaCondicaoPgto;
    procedure TestisCodBarrasProduto;
    procedure TestGetIdItem;
  end;

implementation

procedure TestTPedidoVenda.SetUp;
begin
  FPedidoVenda := TPedidoVenda.Create;
end;

procedure TestTPedidoVenda.TearDown;
begin
  FPedidoVenda.Free;
  FPedidoVenda := nil;
end;

procedure TestTPedidoVenda.TestValidaQtdadeItem;
var
  ReturnValue: Boolean;
  QtdPedido: Double;
  CdItem: string;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.ValidaQtdadeItem(CdItem, QtdPedido);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestCalculaValorTotalItem;
var
  ReturnValue: Double;
  qtdadeItem: Double;
  valorUnitario: Double;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.CalculaValorTotalItem(valorUnitario, qtdadeItem);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestValidaFormaPgto;
var
  ReturnValue: Boolean;
  CdFormaPgto: Integer;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.ValidaFormaPgto(CdFormaPgto);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestValidaCliente;
var
  ReturnValue: Boolean;
  CdCliente: Integer;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.ValidaCliente(CdCliente);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestValidaCondPgto;
var
  ReturnValue: Boolean;
  CdForma: Integer;
  CdCond: Integer;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.ValidaCondPgto(CdCond, CdForma);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestBuscaProduto;
var
  ReturnValue: TFDQuery;
  CodProduto: string;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.BuscaProduto(CodProduto);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestBuscaProdutoCodBarras;
var
  ReturnValue: TList<String>;
  CodBarras: string;
begin
  // TODO: Setup method call parameters
//  ReturnValue := FPedidoVenda.BuscaProdutoCodBarras(CodBarras);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestValidaProduto;
var
  ReturnValue: Boolean;
  CodProduto: string;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.ValidaProduto(CodProduto);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestBuscaTabelaPreco;
var
  ReturnValue: TList<String>;
  CodProduto: string;
  CodTabela: Integer;
begin
  // TODO: Setup method call parameters
//  ReturnValue := FPedidoVenda.BuscaTabelaPreco(CodTabela, CodProduto);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestValidaTabelaPreco;
var
  ReturnValue: Boolean;
  CodProduto: string;
  CodTabela: Integer;
begin
  // TODO: Setup method call parameters
  ReturnValue := FPedidoVenda.ValidaTabelaPreco(CodTabela, CodProduto);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestBuscaFormaPgto;
var
  ReturnValue: TList<String>;
  CodForma: Integer;
begin
  // TODO: Setup method call parameters
//  ReturnValue := FPedidoVenda.BuscaFormaPgto(CodForma);
  // TODO: Validate method results
end;

procedure TestTPedidoVenda.TestBuscaCondicaoPgto;
var
  ReturnValue: TList<String>;
  CodForma: Integer;
  CodCond: Integer;
begin
  // TODO: Setup method call parameters
  CodForma := 1;
  CodCond := 2;
//  ReturnValue := FPedidoVenda.BuscaCondicaoPgto(CodCond, CodForma);
  // TODO: Validate method results
  CheckNotNull(ReturnValue, 'condi��o n�o encontrada');
end;

procedure TestTPedidoVenda.TestisCodBarrasProduto;
var
  ReturnValue: Boolean;
  Cod: string;
begin
  // TODO: Setup method call parameters
  Cod := '12344';

  ReturnValue := FPedidoVenda.isCodBarrasProduto(Cod);

  // TODO: Validate method results
  CheckTrue(ReturnValue, ' n�o � c�digo de barras');
end;

procedure TestTPedidoVenda.TestGetIdItem;
var
  ReturnValue: Int64;
  CdItem: string;
begin
  // TODO: Setup method call parameters
  CdItem := '9999';

  ReturnValue := FPedidoVenda.GetIdItem(CdItem);

  CheckEquals(10, ReturnValue, 'produto n�o encontrado');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTPedidoVenda.Suite);
end.

