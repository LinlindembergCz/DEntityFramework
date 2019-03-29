unit InterfaceService;

interface

uses
System.Classes, DB, EF.Mapping.Base, InterfaceRepository, Context;

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
    procedure InputEntity(Contener: TComponent);
    procedure InitEntity(Contener: TComponent);
    procedure ReadEntity(Contener: TComponent);
    function FieldList:TFieldList;
    function ChangeCount:Integer;
  end;

implementation

{ IService }
end.

