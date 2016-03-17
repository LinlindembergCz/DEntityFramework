unit InterfaceRepository;

interface

uses
  EntityBase, Context, EnumEntity,DB;


type
  IRepositoryBase = interface(IInterface)
    ['{5E02D175-02F4-4DA3-9201-AC1DEC6CA3C1}']
    procedure RefreshDataSet;
    function  LoadDataSet(iId:Integer = 0): TDataSet;
    function  LoadEntity(iId: Integer = 0): TEntityBase;
    procedure Delete;
    procedure AddOrUpdate( State: TEntityState);
    procedure Commit;
    function Context: TContext;
  end;


 IRepository<T:TEntityBase> = interface(IInterface)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    procedure RefreshDataSet;
    function  LoadDataSet(iId:Integer = 0): TDataSet;
    function  LoadEntity(iId: Integer = 0): T;
    procedure Delete;
    procedure AddOrUpdate( State: TEntityState);
    procedure Commit;
    function GetEntity: T;
    function GetContext:TContext;
    property Entity: T read GetEntity;
    property Context: TContext read GetContext;
  end;

implementation

end.
