unit TestuUsuario;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, Vcl.Mask, FireDAC.Comp.Client, FireDAC.Stan.Async, FireDAC.DatS,
  Vcl.Dialogs, Winapi.Windows, FireDAC.Stan.Error, FireDAC.Phys.Intf, uUsuario,
  System.SysUtils, FireDAC.DApt, Vcl.Graphics, System.Variants, FireDAC.Comp.DataSet,
  FireDAC.Stan.Option, Winapi.Messages, Vcl.StdCtrls, FireDAC.DApt.Intf, Vcl.Controls,
  Vcl.Forms, FireDAC.Stan.Param, FireDAC.Stan.Intf, Data.DB, System.Classes;

type
  // Test methods for class TfrmUsuario

  TestTfrmUsuario = class(TTestCase)
  strict private
    FfrmUsuario: TfrmUsuario;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestFormKeyDown;
    procedure TestFormKeyPress;
    procedure TestedtIdUsuarioExit;
    procedure TestedtIdUsuarioChange;
    procedure TestlimpaCampos;
    procedure TestvalidaCampos;
    procedure Testsalvar;
    procedure Testexcluir;
  end;

implementation

procedure TestTfrmUsuario.SetUp;
begin
  FfrmUsuario := TfrmUsuario.Create(nil);
end;

procedure TestTfrmUsuario.TearDown;
begin
  FfrmUsuario.Free;
  FfrmUsuario := nil;
end;

procedure TestTfrmUsuario.TestFormKeyDown;
var
  Shift: TShiftState;
  Key: Word;
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmUsuario.FormKeyDown(Sender, Key, Shift);
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.TestFormKeyPress;
var
  Key: Char;
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmUsuario.FormKeyPress(Sender, Key);
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.TestedtIdUsuarioExit;
var
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmUsuario.edtIdUsuarioExit(Sender);
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.TestedtIdUsuarioChange;
var
  Sender: TObject;
begin
  // TODO: Setup method call parameters
  FfrmUsuario.edtIdUsuarioChange(Sender);
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.TestlimpaCampos;
begin
  FfrmUsuario.limpaCampos;
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.TestvalidaCampos;
begin
  FfrmUsuario.validaCampos;
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.Testsalvar;
begin
  FfrmUsuario.salvar;
  // TODO: Validate method results
end;

procedure TestTfrmUsuario.Testexcluir;
begin
  FfrmUsuario.excluir;
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTfrmUsuario.Suite);
end.

