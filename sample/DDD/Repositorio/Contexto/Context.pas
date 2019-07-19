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

uses  FactoryConnection, EF.Schema.PostGres, EF.Mapping.AutoMapper;

constructor TdbContext<T>.Create;
var
  E:T;
begin
  Connection:= TFactoryConnection.GetConnection;
  E:= T.Create;//TFactoryEntity<T>.GetEntity;
  if Connection.CustomTypeDataBase is TPostGres then
     TAutoMapper.ToMapping(E, true, Connection.CustomTypeDataBase is TPostGres );
  inherited Create( E );
end;

end.
