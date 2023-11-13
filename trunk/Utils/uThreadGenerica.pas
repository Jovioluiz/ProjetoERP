unit uThreadGenerica;

interface

uses
  System.Classes;

type
  TThreadGenerica = class(TThread)
    public
      constructor Create;
      procedure Execute; override;
  end;

implementation

{ TThreadGenerica }

constructor TThreadGenerica.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
end;

procedure TThreadGenerica.Execute;
begin
  inherited;

end;

end.
