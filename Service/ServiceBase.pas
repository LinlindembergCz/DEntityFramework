unit ServiceBase;

interface

uses
System.Classes, DB, EntityBase, InterfaceService, InterfaceRepository, Context;

type
  TServiceBase = class(TInterfacedObject, IService)
  protected
    Repository: IRepositoryBase;
  public
    procedure RefresData;virtual;
    function  Load(iId:Integer = 0): TDataSet;virtual;
    function  LoadEntity(iId: Integer = 0): TEntityBase;virtual;
    procedure Delete;virtual;
    procedure Post( State: TEntityState);virtual;
    procedure Persist;virtual;
    function GetEntity: TEntityBase;virtual;
    procedure InputEntity(Contener: TComponent);virtual;
    procedure InitEntity(Contener: TComponent); virtual;
    constructor Create( pRepository: IRepositoryBase);virtual;
    destructor Destroy;override;
    function FieldList:TFieldList;virtual;
    procedure ReadEntity(Contener: TComponent);virtual;
    function ChangeCount:Integer;virtual;
  end;

implementation

uses AutoMapper;

constructor TServiceBase.Create(pRepository: IRepositoryBase);
begin
  Repository:= pRepository;
end;

destructor TServiceBase.Destroy;
begin
  inherited;
  Repository._Release;
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

function TServiceBase.Load(iId:Integer = 0): TDataSet;
begin
  result := Repository.LoadDataSet(iID);
end;

function TServiceBase.LoadEntity(iId: Integer= 0): TEntityBase;
begin
  result := Repository.LoadEntity(iId);
end;

procedure TServiceBase.RefresData;
begin
  Repository.RefreshDataSet;
end;

end.
