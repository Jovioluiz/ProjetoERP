unit uSet;

interface

uses
  System.Generics.Collections;

type TSet<TKey, TValue> = class(TDictionary<TKey, TValue>)
  private
    FDict: TDictionary<TKey, TValue>;
  public
    constructor Create;
    destructor Destroy; override;
    function ContainsKey(const Key: TKey): Boolean;
    procedure Add(const Key: TKey; const Value: TValue);
    procedure Remove(const Value: TKey);
  end;


implementation


constructor TSet<TKey, TValue>.Create;
begin
  inherited;
  FDict := TDictionary<TKey, TValue>.Create;
end;

destructor TSet<TKey, TValue>.Destroy;
begin
  FDict.Free;
  inherited;
end;

function TSet<TKey, TValue>.ContainsKey(const Key: TKey): Boolean;
begin
  Result := FDict.ContainsKey(Key);
end;

procedure TSet<TKey, TValue>.Add(const Key: TKey; const Value: TValue);
begin
  FDict.AddOrSetValue(Key, Value);
end;

procedure TSet<TKey, TValue>.Remove(const Value: TKey);
begin
  FDict.Remove(Value);
end;

end.
