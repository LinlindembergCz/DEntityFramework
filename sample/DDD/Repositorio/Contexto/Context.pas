unit Context;

interface

uses
  EF.Engine.DataContext, FactoryEntity, EF.Mapping.Base;


type
  TEntityState = (esInsert, esEdit, esBrowser);

  TdbContext<T:TEntityBase> = class(TDataContext<T>)
  public
    constructor Create;
  end;

implementation

{ TContext }

uses  FactoryConnection;

constructor TdbContext<T>.Create;
begin
  Connection:= TFactoryConnection.GetConnection;
  inherited Create( TFactoryEntity<T>.GetEntity );
end;

end.
