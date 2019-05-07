unit Service.Base;

interface

uses
System.Classes, DB, EF.Mapping.Base,
Service.Interfaces.ServiceBase,
Repositorio.Interfaces.Base, Context,
Winapi.Windows, System.JSON, Service.Utils.DataBind;

type
  {$M+}
  TServiceBase<T:TEntityBase> = class(TInterfacedPersistent, IServiceBase<T>)
  private
    FRefCount: Integer;
    FDataBind: IDataBind;
    procedure InitEntity(Contener: TComponent);
  protected
    Repository: IRepositoryBase<T>;
  public

    constructor Create( pRepository: IRepositoryBase<T>);virtual;
    procedure RefresData;virtual;
    function  Load(iId:Integer; Fields: string = ''): TDataSet;virtual;
    function  LoadEntity(iId: Integer = 0): T;virtual;
    procedure Delete;virtual;
    procedure Post( State: TEntityState);virtual;
    procedure Persist;virtual;
    function GetEntity: T;virtual;
    procedure Add(JSOnObject: TJSOnObject);overload; virtual;
    procedure Read(Contener: TComponent);virtual;
    function FieldList:TFieldList;virtual;

    function ChangeCount:Integer;virtual;

    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function DataBind: IDataBind;
  end;
  {$M-}
implementation

uses  EF.Mapping.AutoMapper;

constructor TServiceBase<T>.Create(pRepository: IRepositoryBase<T>);
begin
  Inherited Create;
  Repository := pRepository;
  FDataBind  := TVLCDataBind.Create;
end;

procedure TServiceBase<T>.Post(State: TEntityState);
begin
   Repository.AddOrUpdate(State);
end;

procedure TServiceBase<T>.Persist;
begin
  Repository.Commit;
end;

function TServiceBase<T>.DataBind: IDataBind;
begin
  result:= FDataBind;
end;

procedure TServiceBase<T>.Delete;
begin
  Repository.Delete;
end;

function TServiceBase<T>.FieldList: TFieldList;
begin
  result:= Repository.dbContext.GetFieldList;
end;

function TServiceBase<T>.GetEntity: T;
begin
  //result:= Repository.GetEntity;
end;

procedure TServiceBase<T>.InitEntity(Contener: TComponent);
begin
  Repository.Entity.Id := 0;
  DataBind.Read(Contener, Repository.dbContext, true);
end;

procedure TServiceBase<T>.Read(Contener: TComponent);
begin
  //Refatorar! Passar apenas o contexto
  DataBind.Read(Contener, Repository.dbContext, false);
end;

procedure TServiceBase<T>.Add(JSOnObject: TJSOnObject);
begin
  TAutoMapper.JsonObjectToObject<T>( JSOnObject, Repository.Entity );
end;

function TServiceBase<T>.ChangeCount: Integer;
begin
  result:= Repository.dbContext.ChangeCount;
end;

function TServiceBase<T>.Load(iId:Integer; Fields: string = ''): TDataSet;
begin
  result := Repository.LoadDataSet(iID , Fields );
end;

function TServiceBase<T>.LoadEntity(iId: Integer= 0): T;
begin
  result := Repository.Load(iId);
end;

procedure TServiceBase<T>.RefresData;
begin
  Repository.RefreshDataSet;
end;

function TServiceBase<T>._AddRef: Integer;
begin
  Result := inherited _AddRef;
  InterlockedIncrement(FRefCount);
end;

function TServiceBase<T>._Release: Integer;
begin
  Result := inherited _Release;
  InterlockedDecrement(FRefCount);
  if FRefCount <=0 then
    Free;
end;

end.
