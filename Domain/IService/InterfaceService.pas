unit InterfaceService;

interface

uses
System.Classes, DB, EntityBase, InterfaceRepository, Context;

type
  IServiceBase = interface(IInterface)
    ['{A357A937-D549-41B1-89C9-A80FCDB1C05A}']
    procedure RefresData;
    function  Load(iId:Integer; Fields: string = ''): TDataSet;
    function  LoadEntity(iId: Integer = 0): TEntityBase;
    procedure Delete;
    procedure Post( State: TEntityState);
    procedure Persist;
    function GetEntity: TEntityBase;
    procedure InputEntity(Contener: TComponent);
    procedure InitEntity(Contener: TComponent);
    procedure ReadEntity(Contener: TComponent);
    function FieldList:TFieldList;
    function ChangeCount:Integer;
  end;

implementation

{ IService }
end.

