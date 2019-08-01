unit Repositorio.Base;

interface

uses
 Classes, Repositorio.GenericRepository, Repositorio.Interfaces.Base,
 DB, Context, EF.Engine.DbSet, EF.Mapping.Base;

type
   {$M+}
   TRepositoryBase<T:TEntitybase> = Class(TInterfacedPersistent, IRepositoryBase<T>)
   private
     FRefCount: integer;
   protected
     _RepositoryBase: IRepository<T>;
      function dbContext: TContext<T>;virtual;
   public
     Constructor Create(dbContext:TContext<T>);virtual;
     procedure RefreshDataSet; virtual;
     function  LoadDataSet(iId:Integer; Fields: string = ''): TDataSet;virtual;
     function  Load(iId: Integer = 0): T;virtual;
     procedure Delete;virtual;
     procedure AddOrUpdate( State: TEntityState);virtual;
     procedure Commit;virtual;
     function GetEntity: T;
     function _AddRef: Integer; stdcall;
     function _Release: Integer; stdcall;
   End;
   {$M-}

implementation

uses Winapi.Windows;

procedure TRepositoryBase<T>.AddOrUpdate(State: TEntityState);
begin
 _RepositoryBase.AddOrUpdate(State);
end;

procedure TRepositoryBase<T>.Commit;
begin
 _RepositoryBase.Commit;
end;

procedure TRepositoryBase<T>.Delete;
begin
  _RepositoryBase.Delete;
end;

function TRepositoryBase<T>.GetEntity: T;
begin
  result:= dbContext.Entity as T;
end;

function TRepositoryBase<T>.dbContext: TContext<T>;
begin
  result:= _RepositoryBase.dbContext;
end;

constructor TRepositoryBase<T>.Create(dbContext: TContext<T>);
begin
   inherited Create;
end;

function TRepositoryBase<T>.LoadDataSet(iId: Integer; Fields: string = ''): TDataSet;
begin
  result := _RepositoryBase.LoadDataSet(iId, Fields)
end;

function TRepositoryBase<T>.Load(iId: Integer): T;
begin
 result := _RepositoryBase.Load(iId)
end;

procedure TRepositoryBase<T>.RefreshDataSet;
begin
 _RepositoryBase.RefreshDataSet;
end;

function TRepositoryBase<T>._AddRef: Integer;
begin
  Result := inherited _AddRef;
  InterlockedIncrement(FRefCount);
end;

function TRepositoryBase<T>._Release: Integer;
begin
  Result := inherited _Release;
  InterlockedDecrement(FRefCount);
  if FRefCount <=0 then
    Free;
end;

end.

