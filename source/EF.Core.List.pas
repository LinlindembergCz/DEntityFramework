unit EF.Core.List;

interface

uses
   EF.Mapping.Base, SysUtils, strUtils, RTTI, EF.Core.Functions, System.Generics.Collections;

type
  ClassEntity = TEntityBase;



  Collection<T:ClassEntity> = class( TObjectList<T> )
  private
     type
       TMethod = reference to procedure (C: T);
  public
    function List: T;
    constructor Create(Initialize:boolean = true);
    procedure ForEach( M: TMethod );
  end;

  Collection = class( Collection<ClassEntity> )
  public
  end;

implementation


{ Collection<T> }

constructor Collection<T>.Create(Initialize:boolean = true);
begin
  inherited Create(true);
  if (count = 0 ) and Initialize then
     Add( T.Create );
end;

procedure Collection<T>.ForEach( M: TMethod);
var
  E:T;
begin
  for E in Self do
  begin
    M(E);
  end;
end;

function Collection<T>.List: T;
begin
   result:= first;
end;


end.
