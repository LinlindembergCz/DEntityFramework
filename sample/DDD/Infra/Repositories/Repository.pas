unit Repository;

interface

uses
  System.Classes, Vcl.Controls, DBClient, Forms, Dialogs, Vcl.Grids, DB,
  Vcl.DBGrids, Variants, Vcl.StdCtrls, Vcl.DBCtrls,
  EF.Engine.DataContext, FactoryEntity, InterfaceRepository, EF.Mapping.Base, Context;

type
   {$M+}
  TRepository<T:TEntityBase> = class(TInterfacedPersistent, IRepository<T>)
  private
    FRefCount: integer;
  protected
    FEntity: T;
    FDbContext: Context.TContext;
  private
    function GetEntity: T;
    function GetContext:Context.TContext;
  public
    constructor Create(dbContext: Context.TContext);virtual;
    destructor Destroy;override;

    procedure RefreshDataSet;virtual;
    function  LoadDataSet(iId:Integer ; Fields: string = '') : TDataSet;virtual;
    function  LoadEntity(iId: Integer = 0): T;virtual;
    procedure Delete;virtual;
    procedure AddOrUpdate( State:TEntityState);virtual;
    procedure Commit;virtual;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
  {$M-}

implementation

uses Winapi.Windows, System.SysUtils;
{ TRepository }

constructor TRepository<T>.Create(dbContext: Context.TContext);
begin
    Inherited Create;
  FDbContext := dbContext;
  FEntity    := dbContext.Entity as T;
end;

function TRepository<T>.LoadDataSet(iId: Integer; Fields: string = ''): TDataSet;
begin
  if iId = 0 then
     result := FDbContext.GetDataset( From(FEntity).Select( Fields) ) as TDataSet
  else
     result := FDbContext.GetDataset( From(FEntity).where( FEntity.Id = iId {Format('ID = %s ', [inttostr(iId)] )} ).Select( Fields) ) as TDataSet;
end;

function TRepository<T>.LoadEntity(iId: Integer): T;
begin
  if iId = 0 then
     result := FDbContext.GetEntity<TEntityBase>(From(FEntity).Select) as T
  else
     result := FDbContext.GetEntity<TEntityBase>(From(FEntity).where( FEntity.Id = iId {Format('ID = %s ', [inttostr(iId)] )}  ).Select) as T;
end;

procedure TRepository<T>.Delete;
begin
  FDbContext.Delete;
end;

destructor TRepository<T>.Destroy;
begin
  inherited;
 if FDbContext <> nil then
  begin
    FDbContext.Free;
    FDbContext:= nil;

  end;
end;

function TRepository<T>.GetContext: Context.TContext;
begin
  result := FDbContext;
end;

function TRepository<T>.GetEntity: T;
begin
  result:= FEntity;
end;

procedure TRepository<T>.AddOrUpdate(State:TEntityState);
begin
  FEntity.Validation;
//FDbContext.SaveChanges(State);
  case State of
    esInsert: FDbContext.Insert;
    esEdit  : FDbContext.Update;
  else
    FDbContext.RefreshDataSet;
  end;
end;

procedure TRepository<T>.Commit;
begin
   FDbContext.ApplyUpdates;
end;

procedure TRepository<T>.RefreshDataSet;
begin
   FDbContext.RefreshDataSet;
end;

function TRepository<T>._AddRef: Integer;
begin
  Result := inherited _AddRef;
  InterlockedIncrement(FRefCount);
end;

function TRepository<T>._Release: Integer;
begin
  Result := inherited _Release;
  InterlockedDecrement(FRefCount);
  if FRefCount <=0 then
    Free;
end;

end.
