unit RepositoryBase;

interface

uses
Repository, Entities, InterfaceRepositoryCliente, InterfaceRepository,DB, Context, EntityFramework, EntityBase;

type
   TRepositoryBase = Class(TInterfacedObject, IRepositoryBase)
   protected
     _RepositoryBase: IRepository<TEntityBase>;
   public
     procedure RefreshDataSet; virtual;
     function  LoadDataSet(iId:Integer = 0): TDataSet;virtual;
     function  LoadEntity(iId: Integer = 0): TEntityBase;virtual;
     procedure Delete;virtual;
     procedure AddOrUpdate( State: TEntityState);virtual;
     procedure Commit;virtual;
     function Context: TContext;virtual;
     destructor Destroy;override;
   End;

implementation


procedure TRepositoryBase.AddOrUpdate(State: TEntityState);
begin
 _RepositoryBase.AddOrUpdate(State);
end;

procedure TRepositoryBase.Commit;
begin
 _RepositoryBase.Commit;
end;

procedure TRepositoryBase.Delete;
begin
  _RepositoryBase.Delete;
end;

destructor TRepositoryBase.Destroy;
begin
  inherited;
  _RepositoryBase._Release;
end;

function TRepositoryBase.Context: TContext;
begin
  result:= _RepositoryBase.Context;
end;

function TRepositoryBase.LoadDataSet(iId: Integer): TDataSet;
begin
  result := _RepositoryBase.LoadDataSet(iId)
end;

function TRepositoryBase.LoadEntity(iId: Integer): TEntityBase;
begin
 result := _RepositoryBase.LoadEntity(iId)
end;

procedure TRepositoryBase.RefreshDataSet;
begin
 _RepositoryBase.RefreshDataSet;
end;

end.
