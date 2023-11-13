unit uJSONConvert;

interface

uses
  REST.Json;

type
  TJSONConvert = class(TJson)

  public
    class function ObjectToJsonString(Classe: TObject): string;
    class function JsonToObject<T: class, constructor>(const Json: string): T;
  end;
implementation

{ TJSONConvert }

class function TJSONConvert.JsonToObject<T>(const Json: string): T;
begin
  if Json = '' then
    Exit;
  Result := TJson.JsonToObject<T>(Json);
end;

class function TJSONConvert.ObjectToJsonString(Classe: TObject): string;
begin
  if not Assigned(Classe) then
    Exit;
  Result := TJson.ObjectToJsonString(Classe);
end;

end.
