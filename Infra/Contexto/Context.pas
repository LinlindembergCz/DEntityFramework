unit Context;

interface

uses
  EntityFramework, FactoryEntity;


type
  TEntityState = (esInsert, esEdit, esBrowser);

  TContext = class(TDataContext)
  public
    constructor Create(E: TEnumEntities);reintroduce;
  end;


implementation

{ TContext }

uses  FactoryConnection;

constructor TContext.Create(E: TEnumEntities);
begin
  Connection:= TFactoryConnection.GetConnection;
  inherited Create( TFactoryEntity.GetEntity(E) );
end;

end.
