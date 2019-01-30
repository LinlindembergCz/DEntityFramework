unit RepositoryBase;

interface

uses
 Classes, Repository, Entities, InterfaceRepositoryCliente, InterfaceRepository,
 DB, Context, EF.Engine.DataContext, EF.Mapping.Base;

type
   {$M+}
   TRepositoryBase = Class(TInterfacedPersistent, IRepositoryBase)
   private
     FRefCount: integer;
   protected
     _RepositoryBase: IRepository<TEntityBase>;
   public
     Constructor Create(dbContext:Context.TContext);virtual;

     procedure RefreshDataSet; virtual;
     function  LoadDataSet(iId:Integer; Fields: string = ''): TDataSet;virtual;
     function  Load(iId: Integer = 0): TEntityBase;virtual;
     procedure Delete;virtual;
     procedure AddOrUpdate( State: TEntityState);virtual;
     procedure Commit;virtual;
     function Context: Context.TContext;virtual;


    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
   End;
   {$M-}

implementation

uses Winapi.Windows;

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

function TRepositoryBase.Context: Context.TContext;
begin
  result:= _RepositoryBase.Context;
end;

constructor TRepositoryBase.Create(dbContext: Context.TContext);
begin
   inherited Create;
end;

function TRepositoryBase.LoadDataSet(iId: Integer; Fields: string = ''): TDataSet;
begin
  result := _RepositoryBase.LoadDataSet(iId, Fields)
end;

function TRepositoryBase.Load(iId: Integer): TEntityBase;
begin
 result := _RepositoryBase.Load(iId)
end;

procedure TRepositoryBase.RefreshDataSet;
begin
 _RepositoryBase.RefreshDataSet;
end;

function TRepositoryBase._AddRef: Integer;
begin
  Result := inherited _AddRef;
  InterlockedIncrement(FRefCount);
end;

function TRepositoryBase._Release: Integer;
begin
  Result := inherited _Release;
  InterlockedDecrement(FRefCount);
  if FRefCount <=0 then
    Free;
end;

end.
