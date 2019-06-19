unit FactoryEntity;

interface

uses
  EF.Mapping.Base;

type
  TFactoryEntity<T:TEntityBase> = class
  private

  public
    class function GetEntity: T;
  end;

implementation

{ TFactoryEntity }

class function TFactoryEntity<T>.GetEntity:T;
begin
  result := T.Create;
end;

end.
