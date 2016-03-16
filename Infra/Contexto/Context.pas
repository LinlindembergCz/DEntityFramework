unit Context;

interface

uses
  EntityFramework, EnumEntity;


type
  TEntityState = (esInsert, esEdit, esBrowser);

  TContext = class(TDataContext)
  public
    constructor Create(E: TEnumEntities);
  end;


implementation

{ TContext }

uses FactoryEntity, FactoryConnection;

constructor TContext.Create(E: TEnumEntities);
begin
  inherited Create(TFactoryConnection.GetConnection);
  Entity:= TFactoryEntity.GetEntity(E);
end;

end.
