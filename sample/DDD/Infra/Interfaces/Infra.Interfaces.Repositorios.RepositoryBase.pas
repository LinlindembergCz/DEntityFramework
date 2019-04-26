unit Infra.Interfaces.Repositorios.RepositoryBase;

interface

uses
  EF.Mapping.Base, Context, FactoryEntity,DB;

type
  IRepositoryBase<T:TEntitybase> = interface(IInterface)
    ['{5E02D175-02F4-4DA3-9201-AC1DEC6CA3C1}']
    procedure RefreshDataSet;
    function  LoadDataSet(iId:Integer; Fields: string = ''): TDataSet;
    function  Load(iId: Integer = 0): T;
    procedure Delete;
    procedure AddOrUpdate( State: TEntityState);
    procedure Commit;
    function GetEntity: T;
    property Entity: T read GetEntity;
    function dbContext: TdbContext;
  end;


 IRepository<T:TEntityBase> = interface(IInterface)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    procedure RefreshDataSet;
    function  LoadDataSet(iId:Integer; Fields: string = ''): TDataSet;
    function  Load(iId: Integer = 0): T;
    procedure Delete;
    procedure AddOrUpdate( State: TEntityState);
    procedure Commit;
    function GetEntity: T;
    function GetContext:TdbContext;
    property Entity: T read GetEntity;
    property dbContext: TdbContext read GetContext;
  end;

implementation

end.
