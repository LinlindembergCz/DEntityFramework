unit ServiceBase;

interface

uses
System.Classes, DB, EF.Mapping.Base, InterfaceService, InterfaceRepository, Context,
Winapi.Windows;

type
  {$M+}
  TServiceBase = class(TInterfacedPersistent, IServiceBase)
  private
    FRefCount: Integer;
  protected
    Repository: IRepositoryBase;
  public
    constructor Create( pRepository: IRepositoryBase);virtual;

    procedure RefresData;virtual;
    function  Load(iId:Integer; Fields: string = ''): TDataSet;virtual;
    function  LoadEntity(iId: Integer = 0): TEntityBase;virtual;
    procedure Delete;virtual;
    procedure Post( State: TEntityState);virtual;
    procedure Persist;virtual;
    function GetEntity: TEntityBase;virtual;
    procedure InputEntity(Contener: TComponent);virtual;
    procedure InitEntity(Contener: TComponent); virtual;

    function FieldList:TFieldList;virtual;
    procedure ReadEntity(Contener: TComponent);virtual;
    function ChangeCount:Integer;virtual;

    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
  {$M-}
implementation

uses  EF.Mapping.AutoMapper;

constructor TServiceBase.Create(pRepository: IRepositoryBase);
begin
  Inherited Create;
  Repository:= pRepository;
end;

procedure TServiceBase.Post(State: TEntityState);
begin
   Repository.AddOrUpdate(State);
end;

procedure TServiceBase.Persist;
begin
  Repository.Commit;
end;

procedure TServiceBase.Delete;
begin
  Repository.Delete;
end;

function TServiceBase.FieldList: TFieldList;
begin
  result:= Repository.Context.GetFieldList;
end;

function TServiceBase.GetEntity: TEntityBase;
begin
  //result:= Repository.GetEntity;
end;

procedure TServiceBase.InitEntity(Contener: TComponent);
begin
  Repository.Context.InitEntity(Contener);
end;

procedure TServiceBase.ReadEntity(Contener: TComponent);
begin
  Repository.Context.ReadEntity(Contener);
end;

procedure TServiceBase.InputEntity(Contener: TComponent);
begin
  Repository.Context.InputEntity(Contener);
end;

function TServiceBase.ChangeCount: Integer;
begin
  result:= Repository.Context.ChangeCount;
end;

function TServiceBase.Load(iId:Integer; Fields: string = ''): TDataSet;
begin
  result := Repository.LoadDataSet(iID , Fields );
end;

function TServiceBase.LoadEntity(iId: Integer= 0): TEntityBase;
begin
  result := Repository.LoadEntity(iId);
end;

procedure TServiceBase.RefresData;
begin
  Repository.RefreshDataSet;
end;

function TServiceBase._AddRef: Integer;
begin
  Result := inherited _AddRef;
  InterlockedIncrement(FRefCount);
end;

function TServiceBase._Release: Integer;
begin
  Result := inherited _Release;
  InterlockedDecrement(FRefCount);
  if FRefCount <=0 then
    Free;
end;

end.
