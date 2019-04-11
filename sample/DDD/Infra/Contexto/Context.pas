unit Context;

interface

uses
  EF.Engine.DataContext, FactoryEntity;


type
  TEntityState = (esInsert, esEdit, esBrowser);

  TdbContext = class(TDataContext)
  public
    constructor Create(E: string);reintroduce;
  end;


implementation

{ TContext }

uses  FactoryConnection;

constructor TdbContext.Create(E: string);
begin
  Connection:= TFactoryConnection.GetConnection;
  inherited Create( TFactoryEntity.GetEntity(E) );
end;

end.
