{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		            Since 01/01/2019                        }
{*******************************************************}

unit EF.QueryAble.Base;

interface

uses
  strUtils,SysUtils,Variants, System.Classes, Winapi.Windows,
  EF.Core.Consts,
  EF.Core.Types,
  EF.Mapping.Atributes,
  EF.Mapping.Base,
  EF.Core.Functions,
  EF.QueryAble.Interfaces;

type
  TFrom = class;
  TSelect = class;

  IQueryAble = Interface(IInterface)
    ['{554062C0-0BD3-4378-BFA2-DFA85CCC5938}']
    function Inner(E: string; _On: string): IQueryAble; overload;
    function Inner(E: TEntityBase; _On: TString): IQueryAble; overload;
    function Inner(E: TEntityBase): IQueryAble; overload;
    function Inner(E: TClass): IQueryAble; overload;
    function InnerLeft(E, _On: string): IQueryAble; overload;
    function InnerLeft(E: TEntityBase; _On: TString): IQueryAble; overload;
    function InnerRight(E, _On: string): IQueryAble; overload;
    function InnerRight(E: TEntityBase; _On: TString): IQueryAble; overload;
    function Where(condition: string): IQueryAble; overload;
    function Where(condition: TString): IQueryAble; overload;
    function GroupBy(Fields: string): IQueryAble; overload;
    function GroupBy(Fields: array of string): IQueryAble; overload;
    function OrderBy(Fields: string): IQueryAble; overload;
    function OrderBy(Fields: array of string): IQueryAble; overload;
    function OrderByDesc(Fields: string): IQueryAble; overload;
    function OrderByDesc(Fields: array of string): IQueryAble; overload;
    function Select(Fields: string = ''): TSelect; overload;
    function Select(Fields: array of string): TSelect; overload;
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

  TQueryAble = class(TInterfacedPersistent, IQueryAble)
  private
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
    function gSetSExcept: string;
    procedure SetSCount(value: string);
    function GetSCount: string;
    function GetSExcept: string;
  protected
    oFrom: TFrom;
    FEntity: TEntityBase;
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
  public
    function Inner(E, _On: string): IQueryAble; overload;
    function Inner(E: TEntityBase; _On: TString): IQueryAble; overload;
    function Inner(E: TEntityBase): IQueryAble; overload;
    function Inner(E: TClass): IQueryAble; overload;
    function InnerLeft(E, _On: string): IQueryAble; overload;
    function InnerLeft(E: TEntityBase; _On: TString): IQueryAble;
      overload;
    function InnerRight(E, _On: string): IQueryAble; overload;
    function InnerRight(E: TEntityBase; _On: TString): IQueryAble;
      overload;
    function Where(condition: string): IQueryAble; overload;
    function Where(condition: TString): IQueryAble; overload;
    function GroupBy(Fields: string): IQueryAble; overload;
    function GroupBy(Fields: array of string): IQueryAble; overload;
    function OrderBy(Fields: string): IQueryAble; overload;
    function OrderBy(Fields: array of string): IQueryAble; overload;
    function OrderByDesc(Fields: string): IQueryAble; overload;
    function OrderByDesc(Fields: array of string): IQueryAble;overload;
    function Select(Fields: string = ''): TSelect; overload;
    function Select(Fields: array of string): TSelect; overload;
    function GetQuery(Q: IQueryAble): string;
    property Entity : TEntityBase read GetEntity write SetEntity;

  end;

  TFrom = class(TQueryAble)
  protected
    constructor Create;
    destructor Destroy;
    procedure InitializeString;
  end;

  TJoin = class(TQueryAble);
  TWhere = class(TQueryAble);
  TGroupBy = class(TQueryAble);
  TOrder = class(TQueryAble);

  TSelect = class(TQueryAble)
  private
    FFields:String;
  public
    //function TopFirst(i: integer): IQueryAble;
    function Distinct(Field: String = ''): IQueryAble; overload;
    function Distinct(Field: TString): IQueryAble; overload;
    function Union(Q: IQueryAble): IQueryAble;
    function Concat(Q: IQueryAble): IQueryAble;
    function &Except(Q: IQueryAble): IQueryAble;
    function Intersect(Q: IQueryAble): IQueryAble;
    function Count: IQueryAble;
  end;

  Linq = class sealed
  private
    class var oFrom: TFrom;
    class function GetFromSigleton: TFrom;
    class function MakeCaseOf(Expression: string; _When, _then: array of variant): string; static;
  public
    class function From(E: String): TFrom; overload;
    class function From(E: TEntityBase): TFrom; overload;
    class function From(Entities: array of TEntityBase): TFrom; overload;
    class function From(E: TClass): TFrom; overload;
    class function From(E: IQueryAble): TFrom; overload;

    class function Caseof(Expression: TString; _When, _then: array of variant)
      : TString; overload;
    class function Caseof(Expression: TInteger; _When, _then: array of variant)
      : TString; overload;
  end;

implementation

uses EF.Mapping.AutoMapper;

function TQueryAble.GetQuery(Q: IQueryAble): string;
begin
  with Q as TQueryAble do
  begin
    result := Concat(FSSelect + FSCount, ifthen(Pos('Select', FSEntity) > 0,
                     fStringReplace(FSEntity, 'From ', 'From (') + ')', FSEntity),

                     FSJoin + ifthen((FSJoin <> '') and (Pos('(', FSSelect) > 0), ')', ''),

                     FSWhere + ifthen((FSWhere <> '') and (FSJoin = '') and
                     (Pos('(', FSSelect) > 0), ')', ''),

                     ifthen(FSExcept <> '', ifthen(FSWhere = '', StrWhere, _And) +

                     StrNot + '(' + StrExist + '(' + FSExcept + ')' + ')', ''),

                     ifthen(FSIntersect <> '', ifthen(FSWhere = '', StrWhere, _And) + StrExist +
                     '(' + FSIntersect + ')', ''),

                     FSGroupBy, FSOrder, ifthen(FSUnion <> '', StrUnion + FSUnion, ''),
                     ifthen(FSConcat <> '', StrUnionAll + FSConcat, ''));
    //oFrom.Free;
  end;
end;

function TQueryAble.GetEntity: TEntityBase;
begin
  result:= FEntity;
end;

function TQueryAble.GetSConcat: string;
begin
 result:= FSConcat;
end;

function TQueryAble.GetSCount: string;
begin
  result:= FSCount;
end;

function TQueryAble.GetSEntity: string;
begin
  result:= FSEntity;
end;

function TQueryAble.GetSExcept: string;
begin
  result:= FSExcept;
end;

function TQueryAble.GetSGroupBy: string;
begin
  result:= FSGroupBy;
end;

function TQueryAble.GetSIntersect: string;
begin
  result:= FSIntersect;
end;

function TQueryAble.GetSJoin: string;
begin
  result:= FSJoin;
end;

function TQueryAble.GetSOrder: string;
begin
  result:= FSOrder;
end;

function TQueryAble.GetSSelect: string;
begin
  result:= FSSelect;
end;

function TQueryAble.GetSUnion: string;
begin
   result:= FSUnion;
end;

function TQueryAble.GetSWhere: string;
begin
   result:= FSWhere;
end;

class function Linq.From(E: String): TFrom;
begin
  oFrom := GetFromSigleton;
  oFrom.FSEntity := StrFrom + E;
  result := oFrom;
end;

class function Linq.From(E: TEntityBase): TFrom;
begin
  oFrom := GetFromSigleton;
  oFrom.FSEntity := StrFrom + TAutoMapper.GetTableAttribute(E.ClassType);
  oFrom.FEntity := E;
  result := oFrom;
end;

class function Linq.From(Entities: array of TEntityBase): TFrom;
var
  E: TEntityBase;
  sFrom: string;
  oFrom : TFrom;
begin
  oFrom := GetFromSigleton;
  for E in Entities do
    sFrom := sFrom + ifthen(sFrom <> '', ',', '') + TAutoMapper.GetTableAttribute
      (E.ClassType);
  oFrom.FSEntity := StrFrom + sFrom;
  oFrom.FEntity := Entities[0];
  result := oFrom;
end;

class function Linq.From(E: TClass): TFrom;
begin
  oFrom := GetFromSigleton;
  oFrom.FSEntity := StrFrom + TAutoMapper.GetTableAttribute(E);
  oFrom.FEntity := (E.Create as TEntityBase);
  result := oFrom;
end;

class function Linq.From(E: IQueryAble): TFrom;
begin
  result := oFrom;
end;

class function Linq.GetFromSigleton: TFrom;
begin
  if oFrom = nil  then
     oFrom:= TFrom.Create;
  oFrom.InitializeString;
  result := oFrom;
end;

class function Linq.MakeCaseOf(Expression: string; _When, _then: array of variant): string;
var
  s: string;
  i: integer;
begin
  s := '(case ' + Expression;
  for i := 0 to length(_When) - 1 do
  begin
    s := s + fCaseof(_When[i], _then[i]);
  end;
  s := s + ' end)';
  result:= s;
end;

class function Linq.Caseof(Expression: TString;
  _When, _then: array of variant): TString;
begin
  result.SetAs( MakeCaseOf( Expression.&As,_When , _then) );
end;

class function Linq.Caseof(Expression: TInteger;
  _When, _then: array of variant): TString;
begin
  result.SetAs( MakeCaseOf( Expression.&As,_When , _then) );
end;

{ TFrom }

constructor TFrom.Create;
begin

end;

destructor TFrom.Destroy;
begin

end;

procedure TFrom.InitializeString;
begin
    FSWhere:= '';
    FSOrder:= '';
    FSSelect:= '';
    FSEntity:= '';
    FSJoin:= '';
    FSGroupBy:= '';
    FSUnion:= '';
    FSExcept:= '';
    FSIntersect:= '';
    FSConcat:= '';
    FSCount:= '';
end;

{ TCustomLinqQueryAble }

function TQueryAble.Inner(E, _On: string): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrInnerJoin + E + StrOn + _On;
  result := self;
end;

function TQueryAble.Inner(E: TEntityBase; _On: TString): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TQueryAble.Inner(E: TEntityBase): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + TAutoMapper.GetReferenceAtribute(self.FEntity, E);
  result := self;
end;

function TQueryAble.Inner(E: TClass): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E) + StrOn + TAutoMapper.GetReferenceAtribute(self.FEntity, E);
  result := self;
end;

function TQueryAble.InnerLeft(E, _On: string): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrLeftJoin + E + StrOn + _On;
  result := self;
end;

function TQueryAble.InnerLeft(E: TEntityBase; _On: TString): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrLeftJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TQueryAble.InnerRight(E, _On: string): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrRightJoin + E + StrOn + _On;
  result := self;
end;

function TQueryAble.InnerRight(E: TEntityBase; _On: TString): IQueryAble;
begin
  self.FSJoin := self.FSJoin + StrRightJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TQueryAble.Where(condition: string): IQueryAble;
begin
  self.FSWhere := StrWhere + condition;
  result := self;
end;

function TQueryAble.Where(condition: TString): IQueryAble;
begin
  self.FSWhere := Concat(StrWhere, condition);
  result := self;
end;

function TQueryAble.GroupBy(Fields: string): IQueryAble;
begin
  self.FSGroupBy := Concat(StrGroupBy, Fields);
  result := self;
end;

function TQueryAble.GroupBy(Fields: array of string): IQueryAble;
var
  values: string;
  Value: string;
begin
  for Value in Fields do
  begin
    values := values + ifthen(values <> '', ', ', '') + Value;
  end;
  self.FSGroupBy := Concat(StrGroupBy, values);
  result := self;
end;

function TQueryAble.gSetSExcept: string;
begin

end;

function TQueryAble.OrderBy(Fields: string): IQueryAble;
begin
  self.FSOrder := Concat(StrOrderBy, Fields);
  result := self;
end;

function TQueryAble.OrderBy(Fields: array of string): IQueryAble;
var
  values: string;
  Value: string;
begin
  for Value in Fields do
  begin
    values := values + ifthen(values <> '', ', ', '') + Value;
  end;
  self.FSOrder := StrOrderBy + values;
  result := self;
end;

function TQueryAble.OrderByDesc(Fields: string): IQueryAble;
begin
  self.FSOrder := Concat(StrOrderBy, Fields, StrDesc);
  result := self;
end;

function TQueryAble.OrderByDesc(Fields: array of string): IQueryAble;
var
  values: string;
  Value: string;
begin
  for Value in Fields do
  begin
    values := values + ifthen(values <> '', ', ', '') + Value;
  end;
  self.FSOrder := StrOrderBy + values + StrDesc;
  result := self;
end;

function TQueryAble.Select(Fields: string = ''): TSelect;
var
  _Atribs:string;
begin
  _Atribs:= TAutoMapper.GetAttributies(FEntity, true);
  if Pos('Select', Fields) > 0 then
    Fields := '(' + Fields + ')';

  self.FSSelect := StrSelect + ifthen( self.FSSelect <> '' ,
                                    ifthen( Fields  <> '', Fields,
                                          ifthen( _Atribs <> '', _Atribs,'*')) + ' From (' + self.FSSelect ,
                                                ifthen( Fields  <> '', Fields,
                                                      ifthen(_Atribs  <> '', _Atribs,'*')));
  TSelect(self).FFields := Fields;
  result := TSelect(self);
end;

function TQueryAble.Select(Fields: array of string): TSelect;
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
  self.FSSelect := StrSelect + ifthen(_Fields <> '', _Fields,ifthen(_Atribs <> '',_Atribs,'*' ) );
  result := TSelect(self);
end;

procedure TQueryAble.SetEntity(value: TEntityBase);
begin
  FEntity := Value;
end;

procedure TQueryAble.SetSConcat(value: string);
begin
   FSConcat:= Value;
end;

procedure TQueryAble.SetSCount(value: string);
begin
   FSCount:= Value;
end;

procedure TQueryAble.SetSEntity(value: string);
begin
   FSEntity:= Value;
end;

procedure TQueryAble.SetSExcept(value: string);
begin
   FSExcept:= Value;
end;

procedure TQueryAble.SetSGroupBy(value: string);
begin
   FSGroupBy:= Value;
end;

procedure TQueryAble.SetSIntersect(value: string);
begin
  FSIntersect:= Value;
end;

procedure TQueryAble.SetSJoin(value: string);
begin
   FSJoin:= Value;
end;

procedure TQueryAble.SetSOrder(value: string);
begin
  FSOrder:= Value;
end;

procedure TQueryAble.SetSSelect(value: string);
begin
  FSSelect:= Value;
end;

procedure TQueryAble.SetSUnion(value: string);
begin
  FSUnion:= Value;
end;

procedure TQueryAble.SetSWhere(value: string);
begin
  FSWhere:= Value;
end;

{ TSelect }

function TSelect.&Except(Q: IQueryAble): IQueryAble;
begin
  FSExcept := GetQuery(Q);
  result := self;
end;

function TSelect.Intersect(Q: IQueryAble): IQueryAble;
begin
  FSIntersect := GetQuery(Q);
  result := self;
end;

function TSelect.Concat(Q: IQueryAble): IQueryAble;
begin
  FSConcat := GetQuery(Q);
  result := self;
end;

function TSelect.Count: IQueryAble;
begin
  FSSelect := trim(fStringReplace(FSSelect, '*', ''));
  if FFields <> '' then
     FSSelect := fStringReplace(FSSelect,
                            StrSelect,
                            StrSelect +
                            StrCount + '(*)' +
                            ifthen(FSSelect <> 'Select', ', ', ''))
  else
     FSSelect := StrSelect + StrCount + '(*)';
  result := self;
end;

function TSelect.Distinct(Field: TString): IQueryAble;
begin
  FSSelect := fStringReplace(FSSelect, StrSelect, StrSelect + StrDistinct +
    ifthen(assigned(@Field), '(' + Field.&As + '),', '') + ' ');
  result := self;
end;

function TSelect.Distinct(Field: String): IQueryAble;
begin
  FSSelect := fStringReplace(FSSelect, StrSelect, StrSelect + StrDistinct +
    ifthen(Field <> '', '(' + Field + '),', '') + ' ');
  result := self;
end;

{function TSelect.TopFirst(i: integer): IQueryAble;
begin
  FSSelect := fStringReplace(FSSelect, StrSelect, StrSelect + StrTop + inttostr(i)
    + ' ');
end;}

function TSelect.Union(Q: IQueryAble): IQueryAble;
begin
  FSUnion := GetQuery(Q);
  result := self;
end;



end.
