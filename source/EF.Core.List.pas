unit EF.Core.List;

interface

uses
   EF.Mapping.Base, SysUtils, strUtils, RTTI, EF.Core.Functions, System.Generics.Collections;

type
  ClassEntity = TEntityBase;

  Collection<T:ClassEntity> = class( TObjectList<T> )
  public
    function List: T;
    constructor Create;
  end;

  Collection = class( Collection<ClassEntity> )
  public
  end;

implementation


{ Collection<T> }

constructor Collection<T>.Create;
begin
  inherited Create(true);
  if (count = 0 ) then
     Add( T.Create );
end;

function Collection<T>.List: T;
begin
   result:= first;
end;


end.
