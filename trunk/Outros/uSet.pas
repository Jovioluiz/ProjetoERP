unit uSet;

interface

uses
  System.Generics.Collections;

type TSet<TKey, TValue> = class(TDictionary<TKey, TValue>)
  private
  public
    function ContainsKey(const Key: TKey): Boolean;
    procedure Add(const Key: TKey; const Value: TValue);
    procedure Remove(const Value: TKey);
  end;


implementation


function TSet<TKey, TValue>.ContainsKey(const Key: TKey): Boolean;
begin
  Result := inherited ContainsKey(Key);
end;

procedure TSet<TKey, TValue>.Add(const Key: TKey; const Value: TValue);
begin
  if not ContainsKey(Key) then
    inherited Add(Key, Value);
end;

procedure TSet<TKey, TValue>.Remove(const Value: TKey);
begin
  inherited Remove(Value);
end;

end.
