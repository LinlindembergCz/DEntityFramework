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
  E:= TFactoryEntity<T>.GetEntity( Connection.CustomTypeDataBase is TPostGres );

  E.Mapped := TAutoMapper.ToMapping(E, true, true);

  inherited Create( E );
end;

end.
