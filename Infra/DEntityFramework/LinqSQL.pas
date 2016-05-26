unit LinqSQL;

interface

uses
  strUtils,SysUtils,Variants,EntityConsts, EntityTypes, Atributies ,
  EntityBase,  EntityFunctions;

type
  TSelect = class;
  TFrom = class;

  TQueryAble = class abstract
  private

  protected
    oFrom: TFrom;
    FEntity: TEntityBase;
  public
    function Join(E: string; _On: string): TQueryAble; overload; virtual; abstract;
    function Join(E: TEntityBase; _On: TString): TQueryAble; overload; virtual; abstract;
    function Join(E: TEntityBase): TQueryAble; overload; virtual; abstract;
    function Join(E: TClass): TQueryAble; overload; virtual; abstract;
    function JoinLeft(E, _On: string): TQueryAble; overload; virtual; abstract;
    function JoinLeft(E: TEntityBase; _On: TString): TQueryAble; overload; virtual; abstract;
    function JoinRight(E, _On: string): TQueryAble; overload; virtual; abstract;
    function JoinRight(E: TEntityBase; _On: TString): TQueryAble; overload; virtual; abstract;
    function Where(condition: string): TQueryAble; overload; virtual; abstract;
    function Where(condition: TString): TQueryAble; overload; virtual; abstract;
    function GroupBy(Fields: string): TQueryAble; overload; virtual; abstract;
    function GroupBy(Fields: array of string): TQueryAble; overload;virtual; abstract;
    function Order(Fields: string): TQueryAble; overload; virtual; abstract;
    function Order(Fields: array of string): TQueryAble; overload; virtual; abstract;
    function OrderDesc(Fields: string): TQueryAble; overload; virtual; abstract;
    function OrderDesc(Fields: array of string): TQueryAble; overload; virtual; abstract;
    function Select(Fields: string = ''): TSelect; overload; virtual; abstract;
    function Select(Fields: array of string): TSelect; overload; virtual; abstract;
    //não estou achando seguro manter essa referencia aqui nessa classe!
    property Entity : TEntityBase read FEntity write FEntity;
  end;

  TCustomQueryAble = class(TQueryAble)
  private
   procedure SetEntity(const Value: TEntityBase);
  protected
    FSWhere: String;
    FSOrder: string;
    FSSelect: string;
    FSEntity: string;
    FSJoin: string;
    FSGroupBy: string;
    FSUnion: string;
    FSExcept: string;
    FSIntersect: string;
    FSConcat: string;
    FSCount: string;
    function Join(E, _On: string): TQueryAble; overload; override;
    function Join(E: TEntityBase; _On: TString): TQueryAble; overload; override;
    function Join(E: TEntityBase): TQueryAble; overload; override;
    function Join(E: TClass): TQueryAble; overload; override;
    function JoinLeft(E, _On: string): TQueryAble; overload; override;
    function JoinLeft(E: TEntityBase; _On: TString): TQueryAble;
      overload; override;
    function JoinRight(E, _On: string): TQueryAble; overload; override;
    function JoinRight(E: TEntityBase; _On: TString): TQueryAble;
      overload; override;
    function Where(condition: string): TQueryAble; overload; override;
    function Where(condition: TString): TQueryAble; overload; override;
    function GroupBy(Fields: string): TQueryAble; overload; override;
    function GroupBy(Fields: array of string): TQueryAble; overload; override;
    function Order(Fields: string): TQueryAble; overload; override;
    function Order(Fields: array of string): TQueryAble; overload; override;
    function OrderDesc(Fields: string): TQueryAble; overload; override;
    function OrderDesc(Fields: array of string): TQueryAble; overload; override;
    function Select(Fields: string = ''): TSelect; overload; override;
    function Select(Fields: array of string): TSelect; overload; override;
  public
    function GetQuery(QueryAble: TQueryAble): string;
    property SEntity: string read FSEntity write FSEntity;
    property SJoin: string read FSJoin write FSJoin;
    property SWhere: string read FSWhere write FSWhere;
    property SGroupBy: string read FSGroupBy write FSGroupBy;
    property SOrder: string read FSOrder write FSOrder;
    property SSelect: string read FSSelect write FSSelect;
    property SConcat: string read FSConcat write FSConcat;
    property SUnion: string read FSUnion write FSUnion;
    property SExcept: string read FSExcept write FSExcept;
    property SIntersect: string read FSIntersect write FSIntersect;
    property SCount: string read FSCount write FSCount;
  end;

  TFrom = class(TCustomQueryAble)
  protected
    constructor Create;
    destructor Destroy;
  end;

  TJoin = class(TCustomQueryAble);
  TWhere = class(TCustomQueryAble);
  TGroupBy = class(TCustomQueryAble);
  TOrder = class(TCustomQueryAble);

  TSelect = class(TCustomQueryAble)
  private
    FFields:String;
  public
    function TopFirst(i: integer): TQueryAble;
    function Distinct(Field: String = ''): TQueryAble; overload;
    function Distinct(Field: TString): TQueryAble; overload;
    function Union(QueryAble: TQueryAble): TQueryAble;
    function Concat(QueryAble: TQueryAble): TQueryAble;
    function &Except(QueryAble: TQueryAble): TQueryAble;
    function Intersect(QueryAble: TQueryAble): TQueryAble;
    function Count: TQueryAble;
  end;

  Linq = class sealed
  public
    class var oFrom: TFrom;
    class function From(E: String): TFrom; overload;
    class function From(E: TEntityBase): TFrom; overload;
    class function From(Entities: array of TEntityBase): TFrom; overload;
    class function From(E: TClass): TFrom; overload;
    class function From(E: TQueryAble): TFrom; overload;

    class function Caseof(Expression: TString; _When, _then: array of variant)
      : TString; overload;
    class function Caseof(Expression: TInteger; _When, _then: array of variant)
      : TString; overload;
  end;

implementation

uses AutoMapper;

procedure TCustomQueryAble.SetEntity(const Value: TEntityBase);
begin
  FEntity := Value;
end;

function TCustomQueryAble.GetQuery(QueryAble: TQueryAble): string;
begin
  with QueryAble as TCustomQueryAble do
  begin
    result := Concat(SSelect + SCount, ifthen(Pos('Select', SEntity) > 0,
              fStringReplace(SEntity, 'From ', 'From (') + ')', SEntity),

              SJoin + ifthen((SJoin <> '') and (Pos('(', SSelect) > 0), ')', ''),

              SWhere + ifthen((SWhere <> '') and (SJoin = '') and
              (Pos('(', SSelect) > 0), ')', ''),

              ifthen(SExcept <> '', ifthen(SWhere = '', StrWhere, _And) +

              StrNot + '(' + StrExist + '(' + SExcept + ')' + ')', ''),

              ifthen(SIntersect <> '', ifthen(SWhere = '', StrWhere, _And) + StrExist +
              '(' + SIntersect + ')', ''),

              SGroupBy, SOrder, ifthen(SUnion <> '', StrUnion + SUnion, ''),
              ifthen(SConcat <> '', StrUnionAll + SConcat, ''));
  end;
end;

class function Linq.From(E: String): TFrom;
begin
  oFrom := TFrom.Create;
  oFrom.SEntity := StrFrom + E;
  result := oFrom;
end;

class function Linq.From(E: TEntityBase): TFrom;
begin
  oFrom := TFrom.Create;
  oFrom.SEntity := StrFrom + TAutoMapper.GetTableAttribute(E.ClassType);
  oFrom.Entity := E;
  result := oFrom;
end;

class function Linq.From(Entities: array of TEntityBase): TFrom;
var
  E: TEntityBase;
  sFrom: string;
begin
  oFrom := TFrom.Create;
  for E in Entities do
    sFrom := sFrom + ifthen(sFrom <> '', ',', '') + TAutoMapper.GetTableAttribute
      (E.ClassType);
  oFrom.SEntity := StrFrom + sFrom;
  oFrom.Entity := Entities[0];
  result := oFrom;
end;

class function Linq.From(E: TClass): TFrom;
begin
  oFrom := TFrom.Create;
  oFrom.SEntity := StrFrom + TAutoMapper.GetTableAttribute(E);
  oFrom.Entity := (E.Create as TEntityBase);
  result := oFrom;
end;

class function Linq.From(E: TQueryAble): TFrom;
begin
  result := oFrom;
end;

class function Linq.Caseof(Expression: TString;
  _When, _then: array of variant): TString;
var
  s: string;
  i: integer;
begin
  s := '(case ' + Expression.&As;
  for i := 0 to length(_When) - 1 do
  begin
    s := s + fCaseof(_When[i], _then[i]);
  end;
  s := s + ' end)';
  result.SetAs( s);
end;

class function Linq.Caseof(Expression: TInteger;
  _When, _then: array of variant): TString;
var
  s: string;
  i: integer;
begin
  s := '(case ' + Expression.&As;
  for i := 0 to length(_When) - 1 do
  begin
    s := s + fCaseof(_When[i], _then[i]);
  end;
  s := s + ' end)';
  result.SetAs( s);
end;

{ TFrom }

constructor TFrom.Create;
begin

end;

destructor TFrom.Destroy;
begin

end;

{ TCustomLinqQueryAble }

function TCustomQueryAble.Join(E, _On: string): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + E + StrOn + _On;
  result := self;
end;

function TCustomQueryAble.Join(E: TEntityBase; _On: TString): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TCustomQueryAble.Join(E: TEntityBase): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + TAutoMapper.GetReferenceAtribute(self.Entity, E);
  result := self;
end;

function TCustomQueryAble.Join(E: TClass): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E) + StrOn + TAutoMapper.GetReferenceAtribute(self.Entity, E);
  result := self;
end;

function TCustomQueryAble.JoinLeft(E, _On: string): TQueryAble;
begin
  self.SJoin := self.SJoin + StrLeftJoin + E + StrOn + _On;
  result := self;
end;

function TCustomQueryAble.JoinLeft(E: TEntityBase; _On: TString): TQueryAble;
begin
  self.SJoin := self.SJoin + StrLeftJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TCustomQueryAble.JoinRight(E, _On: string): TQueryAble;
begin
  self.SJoin := self.SJoin + StrRightJoin + E + StrOn + _On;
  result := self;
end;

function TCustomQueryAble.JoinRight(E: TEntityBase; _On: TString): TQueryAble;
begin
  self.SJoin := self.SJoin + StrRightJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TCustomQueryAble.Where(condition: string): TQueryAble;
begin
  self.SWhere := StrWhere + condition;
  result := self;
end;

function TCustomQueryAble.Where(condition: TString): TQueryAble;
begin
  self.SWhere := Concat(StrWhere, condition);
  result := self;
end;

function TCustomQueryAble.GroupBy(Fields: string): TQueryAble;
begin
  self.SGroupBy := Concat(StrGroupBy, Fields);
  result := self;
end;

function TCustomQueryAble.GroupBy(Fields: array of string): TQueryAble;
var
  values: string;
  Value: string;
begin
  for Value in Fields do
  begin
    values := values + ifthen(values <> '', ', ', '') + Value;
  end;
  self.SGroupBy := Concat(StrGroupBy, values);
  result := self;
end;

function TCustomQueryAble.Order(Fields: string): TQueryAble;
begin
  self.SOrder := Concat(StrOrderBy, Fields);
  result := self;
end;

function TCustomQueryAble.Order(Fields: array of string): TQueryAble;
var
  values: string;
  Value: string;
begin
  for Value in Fields do
  begin
    values := values + ifthen(values <> '', ', ', '') + Value;
  end;
  self.SOrder := StrOrderBy + values;
  result := self;
end;

function TCustomQueryAble.OrderDesc(Fields: string): TQueryAble;
begin
  self.SOrder := Concat(StrOrderBy, Fields, StrDesc);
  result := self;
end;

function TCustomQueryAble.OrderDesc(Fields: array of string): TQueryAble;
var
  values: string;
  Value: string;
begin
  for Value in Fields do
  begin
    values := values + ifthen(values <> '', ', ', '') + Value;
  end;
  self.SOrder := StrOrderBy + values + StrDesc;
  result := self;
end;

function TCustomQueryAble.Select(Fields: string = ''): TSelect;
var
  _Atribs:string;
begin
  _Atribs:= TAutoMapper.GetAttributies(FEntity, true);
  if Pos('Select', Fields) > 0 then
    Fields := '(' + Fields + ')';
  if self.SSelect <> '' then
    self.SSelect := StrSelect + ifthen(Fields <> '', Fields, ifthen(_Atribs <> '',_Atribs,'*' ) ) + ' From (' +
      self.SSelect
  else
    self.SSelect := StrSelect + ifthen(Fields <> '', Fields, ifthen(_Atribs <> '',_Atribs,'*' ) );

  TSelect(self).FFields:= Fields;

  result := TSelect(self);
end;

function TCustomQueryAble.Select(Fields: array of string): TSelect;
var
  _Fields: string;
  Field: string;
  _Atribs:string;
begin
  _Fields := '';
  _Atribs:= TAutoMapper.GetAttributies(FEntity, true);
  for Field in Fields do
  begin
    _Fields := _Fields + ifthen(_Fields <> '', ', ', '') + Field;
  end;
  TSelect(self).FFields:= _Fields;
  self.SSelect := StrSelect + ifthen(_Fields <> '', _Fields,ifthen(_Atribs <> '',_Atribs,'*' ) );
  result := TSelect(self);
end;

{ TSelect }

function TSelect.&Except(QueryAble: TQueryAble): TQueryAble;
begin
  SExcept := GetQuery(QueryAble);
  result := self;
end;

function TSelect.Intersect(QueryAble: TQueryAble): TQueryAble;
begin
  SIntersect := GetQuery(QueryAble);
  result := self;
end;

function TSelect.Concat(QueryAble: TQueryAble): TQueryAble;
begin
  SConcat := GetQuery(QueryAble);
  result := self;
end;

function TSelect.Count: TQueryAble;
begin
  SSelect := trim(fStringReplace(SSelect, '*', ''));
  if FFields <> '' then
     SSelect := fStringReplace(SSelect,
                            StrSelect,
                            StrSelect +
                            StrCount + '(*)' +
                            ifthen(SSelect <> 'Select', ', ', ''))
  else
     SSelect := StrSelect + StrCount + '(*)';
  result := self;
end;

function TSelect.Distinct(Field: TString): TQueryAble;
begin
  SSelect := fStringReplace(SSelect, StrSelect, StrSelect + StrDistinct +
    ifthen(assigned(@Field), '(' + Field.&As + '),', '') + ' ');
  result := self;
end;

function TSelect.Distinct(Field: String): TQueryAble;
begin
  SSelect := fStringReplace(SSelect, StrSelect, StrSelect + StrDistinct +
    ifthen(Field <> '', '(' + Field + '),', '') + ' ');
  result := self;
end;

function TSelect.TopFirst(i: integer): TQueryAble;
begin
  SSelect := fStringReplace(SSelect, StrSelect, StrSelect + StrTop + inttostr(i)
    + ' ');
end;

function TSelect.Union(QueryAble: TQueryAble): TQueryAble;
begin
  SUnion := GetQuery(QueryAble);
  result := self;
end;



end.
