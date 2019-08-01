unit Context;

interface

uses
  EF.Engine.DataContext, FactoryEntity, EF.Mapping.Base;


type
  TEntityState = (esInsert, esEdit, esBrowser);

  TContext<T:TEntityBase> = class(TDbSet<T>)
  public
    constructor Create;
  end;

implementation

{ TContext }

uses  FactoryConnection, EF.Schema.PostGres, EF.Mapping.AutoMapper;

constructor TContext<T>.Create;
var
  E:T;
begin
  DataBase:= TFactoryConnection.GetConnection;
  E:= T.Create;//TFactoryEntity<T>.GetEntity;
  if DataBase.CustomTypeDataBase is TPostGres then
     TAutoMapper.ToMapping(E, true, DataBase.CustomTypeDataBase is TPostGres );
  inherited Create( E );
end;

end.
