unit uSenhaMD5;

interface

type TSenhaMD5 = class
  private


  public
    function GetSenhaMD5(Senha: string): string;
end;

implementation

uses
  IdHashMessageDigest;

function TSenhaMD5.GetSenhaMD5(Senha: string): string;
var
  md5: TIdHashMessageDigest5;
begin
  md5 := TIdHashMessageDigest5.Create;

  try
    Result := md5.HashStringAsHex(Senha);
  finally
    md5.Free;
  end;
end;

end.
