unit Service.Interfaces.Services.Servicebase;

interface

uses
System.Classes, DB, EF.Mapping.Base, Infra.Interfaces.Repositorios.Repositorybase, Context, System.JSON;

type
  IServiceBase<T:TEntityBase> = interface(IInterface)
    ['{A357A937-D549-41B1-89C9-A80FCDB1C05A}']
    procedure RefresData;
    function  Load(iId:Integer; Fields: string = ''): TDataSet;
    function  LoadEntity(iId: Integer = 0): T;
    procedure Delete;
    procedure Post( State: TEntityState);
    procedure Persist;
    function GetEntity: T;
    //procedure InputEntity(Contener: TComponent);overload;
    procedure InputEntity(JSOnObject: TJSOnObject);overload;
    procedure InitEntity(Contener: TComponent);
    procedure ReadEntity(Contener: TComponent);
    function FieldList:TFieldList;
    function ChangeCount:Integer;
  end;

implementation

{ IService }
end.
