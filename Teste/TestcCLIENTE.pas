unit TestcCLIENTE;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, FireDAC.Stan.Option, FireDAC.DApt.Intf,
  System.Generics.Collections, System.UITypes, FireDAC.Stan.Param, System.Classes,
  Vcl.ExtCtrls, StrUtils, Vcl.StdCtrls, FireDAC.DatS, FireDAC.Stan.Intf,
  FireDAC.Stan.Error, FireDAC.DApt, Data.FMTBcd, Vcl.Graphics, FireDAC.Phys.Intf,
  FireDAC.Comp.Client, Vcl.DBCtrls, Winapi.Windows, System.Variants, uValidaDcto,
  Winapi.Messages, Vcl.Dialogs, FireDAC.Stan.Async, Vcl.Mask, Vcl.Forms,
  System.SysUtils, Vcl.Buttons, Data.DB, Vcl.Controls, cCLIENTE, Data.SqlExpr,
  FireDAC.Comp.DataSet;

type
  // Test methods for class TfrmCadCliente

  TestTfrmCadCliente = class(TTestCase)
  strict private
    FfrmCadCliente: TfrmCadCliente;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestpFormarCamposPessoa;
    procedure TestedtCLIENTETP_PESSOAClick;
    procedure TestedtCLIENTEcd_clienteExit;
    procedure TestFormKeyPress;
    procedure TestFormClose;
    procedure TestedtCepExit;
    procedure TestFormKeyDown;
    procedure TestedtCLIENTEcd_clienteKeyDown;
    procedure TestFormActivate;
    procedure TestlimpaCampos;
    procedure Testsalvar;
    procedure Testexcluir;
    procedure TestdesabilitaCampos;
  end;

implementation

procedure TestTfrmCadCliente.SetUp;
begin
  FfrmCadCliente := TfrmCadCliente.Create(nil);
end;

procedure TestTfrmCadCliente.TearDown;
begin
  FfrmCadCliente.Free;
  FfrmCadCliente := nil;
end;

procedure TestTfrmCadCliente.TestpFormarCamposPessoa;
begin
  FfrmCadCliente.pFormarCamposPessoa;
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestedtCLIENTETP_PESSOAClick;
var
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.edtCLIENTETP_PESSOAClick(Sender);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestedtCLIENTEcd_clienteExit;
var
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.edtCLIENTEcd_clienteExit(Sender);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestFormKeyPress;
var
  Key: Char;
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.FormKeyPress(Sender, Key);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestFormClose;
var
  Action: TCloseAction;
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.FormClose(Sender, Action);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestedtCepExit;
var
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.edtCepExit(Sender);
  // TODO: Validate method results
end;


procedure TestTfrmCadCliente.TestFormKeyDown;
var
  Shift: TShiftState;
  Key: Word;
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.FormKeyDown(Sender, Key, Shift);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestedtCLIENTEcd_clienteKeyDown;
var
  Shift: TShiftState;
  Key: Word;
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.edtCLIENTEcd_clienteKeyDown(Sender, Key, Shift);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestFormActivate;
var
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmCadCliente.FormActivate(Sender);
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestlimpaCampos;
begin
  FfrmCadCliente.limpaCampos;
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.Testsalvar;
begin
  FfrmCadCliente.salvar;
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.Testexcluir;
begin
  FfrmCadCliente.excluir;
  // TODO: Validate method results
end;

procedure TestTfrmCadCliente.TestdesabilitaCampos;
begin
  FfrmCadCliente.desabilitaCampos;
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTfrmCadCliente.Suite);
end.

