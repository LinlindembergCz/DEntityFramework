unit InterfaceQueryAble;

interface


uses
  strUtils,SysUtils,Variants,EntityConsts, EntityTypes, EntityAtributies, EntityBase,
  EntityFunctions, System.Classes;

type
  IQueryAble = Interface(IInterface)
    ['{554062C0-0BD3-4378-BFA2-DFA85CCC5938}']
    function Join(E: string; _On: string): IQueryAble; overload;
    function Join(E: TEntityBase; _On: TString): IQueryAble; overload;
    function Join(E: TEntityBase): IQueryAble; overload;
    function Join(E: TClass): IQueryAble; overload;
    function JoinLeft(E, _On: string): IQueryAble; overload;
    function JoinLeft(E: TEntityBase; _On: TString): IQueryAble; overload;
    function JoinRight(E, _On: string): IQueryAble; overload;
    function JoinRight(E: TEntityBase; _On: TString): IQueryAble; overload;
    function Where(condition: string): IQueryAble; overload;
    function Where(condition: TString): IQueryAble; overload;
    function GroupBy(Fields: string): IQueryAble; overload;
    function GroupBy(Fields: array of string): IQueryAble; overload;
    function Order(Fields: string): IQueryAble; overload;
    function Order(Fields: array of string): IQueryAble; overload;
    function OrderDesc(Fields: string): IQueryAble; overload;
    function OrderDesc(Fields: array of string): IQueryAble; overload;
    function Select(Fields: string = ''): IQueryAble; overload;
    function Select(Fields: array of string): IQueryAble; overload;
    //não estou achando seguro manter essa referencia aqui nessa classe!

    procedure SetEntity(value: TEntityBase);
    function GetEntity: TEntityBase;
    procedure SetSEntity(value: string);
    function GetSEntity: string;
    procedure SetSJoin(value: string);
    function GetSJoin: string;
    procedure SetSWhere(value: string);
    function GetSWhere: string;
    procedure SetSGroupBy(value: string);
    function GetSGroupBy: string;
    procedure SetSOrder(value: string);
    function GetSOrder: string;
    procedure SetSSelect(value: string);
    function GetSSelect: string;
    procedure SetSConcat(value: string);
    function GetSConcat: string;
    procedure SetSUnion(value: string);
    function GetSUnion: string;
    procedure SetSIntersect(value: string);
    function GetSIntersect: string;
    procedure SetSExcept(value: string);
    function GetSExcept: string;
    procedure SetSCount(value: string);
    function GetSCount: string;

    property Entity : TEntityBase read GetEntity write SetEntity;
    property SEntity: string read GetSEntity write SetSEntity;
    property SJoin: string read GetSJoin write SetSJoin;
    property SWhere: string read GetSWhere write SetSWhere;
    property SGroupBy: string read GetSGroupBy write SetSGroupBy;
    property SOrder: string read GetSOrder write SetSOrder;
    property SSelect: string read GetSSelect write SetSSelect;
    property SConcat: string read GetSConcat write SetSConcat;
    property SUnion: string read GetSUnion write SetSUnion;
    property SExcept: string read GetSExcept write SetSExcept;
    property SIntersect: string read GetSIntersect write SetSIntersect;
    property SCount: string read GetSCount write SetSCount;
  end;

implementation

end.
