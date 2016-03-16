unit Repository;

interface

uses
  System.Classes, Vcl.Controls, DBClient, Forms, Dialogs, Vcl.Grids, DB,
  Vcl.DBGrids, Variants, Vcl.StdCtrls, Vcl.DBCtrls,
  EntityFramework, EnumEntity, InterfaceRepository, EntityBase, Context;

type
  TRepository<T:TEntityBase> = class(TInterfacedObject, IRepository<T>)
  protected
    FEntity: T;
    FDbContext: TContext;
  private
    function GetEntity: T;
    function GetContext:TContext;
  public
    constructor Create(dbContext: TContext);
    destructor Destroy;override;
    procedure RefreshDataSet;virtual;
    function  LoadDataSet(iId:Integer = 0) : TDataSet;virtual;
    function  LoadEntity(iId: Integer = 0): T;virtual;
    procedure Delete;virtual;
    procedure AddOrUpdate( State:TEntityState);virtual;
    procedure Commit;virtual;
    property Entity: T read GetEntity;
    property Context: TContext Read GetContext;
  end;

implementation

{ TRepository }

constructor TRepository<T>.Create(dbContext: TContext);
begin
  FDbContext := dbContext;
  FEntity    := dbContext.Entity as T;
end;

function TRepository<T>.LoadDataSet(iId: Integer): TDataSet;
begin
  if iId = 0 then
     result := FDbContext.GetDataset(From(FEntity).Select) as TDataSet
  else
     result := FDbContext.GetDataset(From(FEntity).where( FEntity.id = iId ).Select) as TDataSet;
end;

function TRepository<T>.LoadEntity(iId: Integer): T;
begin
  if iId = 0 then
     result := FDbContext.GetEntity<TEntityBase>(From(FEntity).Select) as T
  else
     result := FDbContext.GetEntity<TEntityBase>(From(FEntity).where( FEntity.id = iId ).Select) as T;
end;

procedure TRepository<T>.Delete;
begin
  FDbContext.Delete;
end;

destructor TRepository<T>.Destroy;
begin
  inherited;
  FDbContext.Free;
end;

function TRepository<T>.GetContext: TContext;
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


end.
