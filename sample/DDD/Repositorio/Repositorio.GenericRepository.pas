unit Repositorio.GenericRepository;

interface

uses
  System.Classes, Vcl.Controls, DBClient, Forms, Dialogs, Vcl.Grids, DB,
  Vcl.DBGrids, Variants, Vcl.StdCtrls, Vcl.DBCtrls,
  EF.Engine.DataContext, FactoryEntity, Repositorio.Interfaces.Base, EF.Mapping.Base, Context;

type
   {$M+}
  TRepository<T:TEntityBase> = class(TInterfacedPersistent, IRepository<T>)
  private
    FRefCount: integer;
  protected
    FEntity: T;
    FDbContext: TdbContext<T>;
  private
    function GetEntity: T;
    function GetContext:TdbContext<T>;
  public
    constructor Create(dbContext: TdbContext<T>);virtual;
    destructor Destroy;override;

    procedure RefreshDataSet;virtual;
    function  LoadDataSet(iId:Integer ; Fields: string = '') : TDataSet;virtual;
    function  Load(iId: Integer = 0): T;virtual;
    procedure Delete;virtual;
    procedure AddOrUpdate( State:TEntityState);virtual;
    procedure Commit;virtual;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
  {$M-}

implementation

uses Winapi.Windows, System.SysUtils, FireDAC.Comp.Client;
{ TRepository }

constructor TRepository<T>.Create(dbContext: TdbContext<T>);
begin
    Inherited Create;
  FDbContext := dbContext;
  FEntity    := dbContext.Entity as T;
end;

function TRepository<T>.LoadDataSet(iId: Integer; Fields: string = ''): TDataSet;
var
  DataSet:TDataSet;
begin
  if iId = 0 then
     DataSet := FDbContext.ToDataSet( From(FEntity).Select( Fields) ) as TDataSet
  else
     DataSet := FDbContext.ToDataSet( From(FEntity).where( FEntity.Id = iId ).Select( Fields) ) as TDataSet;

   FDbContext.DBSet:= DataSet as TFDQuery;

   result:= FDbContext.DBSet;
end;

function TRepository<T>.Load(iId: Integer): T;
begin
  if iId = 0 then
     result := FDbContext.Find<TEntityBase>(From(FEntity).Select) as T
  else
     result := FDbContext.Find<TEntityBase>(From(FEntity).where( FEntity.Id = iId  ).Select) as T;
end;

procedure TRepository<T>.Delete;
begin
  FDbContext.Remove;
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

function TRepository<T>.GetContext: TdbContext<T>;
begin
  result := FDbContext;
end;

function TRepository<T>.GetEntity: T;
begin
  result:= FEntity;
end;

procedure TRepository<T>.AddOrUpdate(State:TEntityState);
begin
  case State of
    esInsert: FDbContext.Add(FEntity);
    esEdit  : FDbContext.Update;
  else
    FDbContext.RefreshDataSet;
  end;
end;

procedure TRepository<T>.Commit;
begin
   FDbContext.SaveChanges;
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
