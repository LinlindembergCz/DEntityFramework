unit EntityFramework;

interface

uses
  MidasLib, System.Classes, strUtils, RTTI, SysUtils, Variants,  Dialogs,  DateUtils,
  Datasnap.Provider, Forms, Datasnap.DBClient, System.Contnrs, Data.DB,
  System.Generics.Collections, Vcl.DBCtrls, StdCtrls, Controls,
  //Essas units darão suporte ao nosso framework
  EntityConsts, EntityConnection, EntityTypes, Atributies , EntityBase, EntityFunctions;

Type
  TSelect = class;
  TFrom = class;

  TQueryAble = class abstract
  private
    procedure SetEntity(const Value: TEntityBase);
  protected
    oFrom: TFrom;
    qryQuery: TDataSet;
    drpProvider: TDataSetProvider;
    FConnection: TEntityConn;
    FProviderName: string;
    FEntity: TEntityBase;
  public
    function Join(E: string; _On: string): TQueryAble; overload;
      virtual; abstract;
    function Join(E: TEntityBase; _On: TString): TQueryAble; overload;
      virtual; abstract;
    function Join(E: TEntityBase): TQueryAble; overload; virtual; abstract;
    function Join(E: TClass): TQueryAble; overload; virtual; abstract;
    function JoinLeft(E, _On: string): TQueryAble; overload; virtual; abstract;
    function JoinLeft(E: TEntityBase; _On: TString): TQueryAble; overload;
      virtual; abstract;
    function JoinRight(E, _On: string): TQueryAble; overload; virtual; abstract;
    function JoinRight(E: TEntityBase; _On: TString): TQueryAble; overload;
      virtual; abstract;
    function Where(condition: string): TQueryAble; overload; virtual; abstract;
    function Where(condition: TString): TQueryAble; overload; virtual; abstract;
    function GroupBy(Fields: string): TQueryAble; overload; virtual; abstract;
    function GroupBy(Fields: array of string): TQueryAble; overload;
      virtual; abstract;
    function Order(Fields: string): TQueryAble; overload; virtual; abstract;
    function Order(Fields: array of string): TQueryAble; overload;
      virtual; abstract;
    function OrderDesc(Fields: string): TQueryAble; overload; virtual; abstract;
    function OrderDesc(Fields: array of string): TQueryAble; overload;
      virtual; abstract;
    function Select(Fields: string = ''): TSelect; overload; virtual; abstract;
    function Select(Fields: array of string): TSelect; overload;
      virtual; abstract;
    property Entity : TEntityBase read FEntity write FEntity;
  end;

  TCustomDataContext = class(TQueryAble)
  private
    FTypeConnetion: TTypeConnection;
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

    procedure DataSetProviderGetTableName(Sender: TObject; DataSet: TDataSet;
      var TableName: string); virtual;
    procedure ReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
      UpdateKind: TUpdateKind; var Action: TReconcileAction); virtual;
    procedure CreateClientDataSet( proDataSetProvider: TDataSetProvider;
      SQL: string = '');
    procedure CreateProvider(var proSQLQuery: TDataSet;
      prsNomeProvider: string);

  public
    ClientDataSet: TClientDataSet;
    function GetQuery(QueryAble: TQueryAble): string;
    constructor Create(proConnection: TEntityConn = nil );virtual;
    destructor Destroy; override;
    property Connection: TEntityConn read FConnection write FConnection;
    property ProviderName: string read FProviderName write FProviderName;
    property TypeConnetion: TTypeConnection read FTypeConnetion write FTypeConnetion;
  end;

  TDataContext = class(TCustomDataContext)
  private
    procedure CreateTables(aClass: array of TClass);
    procedure AlterTables(aClass: array of TClass);
    procedure FreeObjects;
  public
    procedure InputEntity(Contener: TComponent);
    procedure ReadEntity(Contener: TComponent; DataSet: TDataSet = nil);
    procedure InitEntity(Contener: TComponent);
    procedure UpdateDataBase(aClass: array of TClass);
    function GetEntity(QueryAble: TQueryAble): TEntityBase; overload;
    function GetEntity<T: Class>(QueryAble: TQueryAble): T; overload;
    function GetData(QueryAble: TQueryAble): OleVariant;
    function GetDataSet(QueryAble: TQueryAble): TClientDataSet;
    function GetList(QueryAble: TQueryAble): TList<TEntityBase>; overload;
    function GetList<T: class>(QueryAble: TQueryAble): TList<T>; overload;
    procedure InsertDirect;
    procedure UpdateDirect;
    procedure DeleteDirect;
    procedure ApplyUpdates;
    procedure RefreshDataSet;
    procedure Delete;
    procedure Insert;
    procedure Update;
    function ChangeCount:Integer;
    function GetFieldList: Data.DB.TFieldList;
  end;

  TFrom = class(TCustomDataContext)
  protected
    constructor Create;
    destructor Destroy;
  end;


  TJoin = class(TCustomDataContext);
  TWhere = class(TCustomDataContext);
  TGroupBy = class(TCustomDataContext);
  TOrder = class(TCustomDataContext);

  TSelect = class(TCustomDataContext)
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
  private
    class var oFrom: TFrom;
    class function From(E: String): TFrom; overload;
    class function From(E: TEntityBase): TFrom; overload;
    class function From(Entities: array of TEntityBase): TFrom; overload;
    class function From(E: TClass): TFrom; overload;
    class function From(E: TQueryAble): TFrom; overload;
  public
    class function Caseof(Expression: TString; _When, _then: array of variant)
      : TString; overload;
    class function Caseof(Expression: TInteger; _When, _then: array of variant)
      : TString; overload;
  end;


  function From(E: String): TFrom; overload;
  function From(E: TEntityBase): TFrom; overload;
  function From(E: array of TEntityBase): TFrom; overload;
  function From(E: TClass): TFrom; overload;
  function From(E: TQueryAble): TFrom; overload;

implementation

uses
  Vcl.ExtCtrls, Data.SqlExpr, FireDAC.Comp.Client, {Data.Win.ADODB,}
  EntityFirebird, EntityMSSQL,  AutoMapper;

function TDataContext.GetData(QueryAble: TQueryAble): OleVariant;
begin
  qryQuery := Connection.CreateDataSet( GetQuery(QueryAble) );

  CreateProvider(qryQuery, trim(fStringReplace(TCustomDataContext(QueryAble).SEntity,
    trim(StrFrom), '')));
  CreateClientDataSet(drpProvider);

  result := ClientDataSet.Data;

  ClientDataSet.Free;
  drpProvider.Free;
  qryQuery.Free;
end;

procedure TDataContext.FreeObjects;
begin
  if ClientDataSet <> nil then
    ClientDataSet.free;
  if drpProvider <> nil then
    drpProvider.free;
  if qryQuery <> nil then
    qryQuery.free;
end;

function TDataContext.GetDataSet(QueryAble: TQueryAble): TClientDataSet;
var
   Keys:TStringList;
begin
  try
    try
      FreeObjects;
      if FProviderName = '' then
      begin
        Keys := TAutoMapper.GetAttributiesPrimaryKeyList( FEntity  );
        FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);
        qryQuery := Connection.CreateDataSet(GetQuery(QueryAble), Keys );
        CreateProvider(qryQuery,
                        trim(fStringReplace(TCustomDataContext(QueryAble).SEntity,
                        trim(StrFrom), '')));

        CreateClientDataSet(drpProvider);
      end
      else
      begin
        CreateClientDataSet( nil, GetQuery(QueryAble));
      end;

      TAutoMapper.DataToEntity( ClientDataSet, FEntity );
      result := ClientDataSet;
    except
    on E:Exception do
      begin
        showmessage(E.message);
      end;
    end;
  finally
    Keys.free;
  end;
end;

function TDataContext.GetList(QueryAble: TQueryAble): TList<TEntityBase>;
var
  List: TList<TEntityBase>;
  DataSet: TClientDataSet;
begin
  try
    FEntity := TCustomDataContext(QueryAble).Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    List := TList<TEntityBase>.Create;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    while not DataSet.Eof do
    begin
      TAutoMapper.DataToEntity(DataSet, TQueryAble(QueryAble).Entity);
      List.Add(TQueryAble(QueryAble).Entity);
      DataSet.Next;
    end;
    result := List;
  finally
    FreeAndNil(DataSet);
  end;
end;

function TDataContext.GetList<T>(QueryAble: TQueryAble): TList<T>;
var
  List: TList<T>;
  DataSet: TClientDataSet;
begin
  try
    FEntity := TCustomDataContext(QueryAble).Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    List := TList<T>.Create;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    while not DataSet.Eof do
    begin
      TAutoMapper.DataToEntity(DataSet, TQueryAble(QueryAble).Entity);
      List.Add(TQueryAble(QueryAble).Entity as T);
      DataSet.Next;
    end;
    result := List;
  finally
    FreeAndNil(DataSet);
  end;
end;

function TDataContext.GetEntity(QueryAble: TQueryAble): TEntityBase;
var
  DataSet: TClientDataSet;
begin
  try
    FEntity := TCustomDataContext(QueryAble).Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    TAutoMapper.DataToEntity(DataSet, TQueryAble(QueryAble).Entity);
    result := TQueryAble(QueryAble).Entity;
  finally
    FreeAndNil(DataSet);
  end;
end;

function TDataContext.GetEntity<T>(QueryAble: TQueryAble): T;
var
  DataSet: TClientDataSet;
begin
  try
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    TAutoMapper.DataToEntity(DataSet, TQueryAble(QueryAble).Entity);
    result := TQueryAble(QueryAble).Entity as T;
  finally
    FreeAndNil(DataSet);
  end;
end;

procedure TDataContext.CreateTables(aClass: array of TClass);
var
  i: integer;
  Table: string;
  ListAtributes: TList;
  TableList: TStringList;
begin
  TableList := TStringList.Create(true);
  FConnection.GetTableNames(TableList);
  for i := 0 to length(aClass) - 1 do
  begin
      ListAtributes  := nil;
      ListAtributes  := TAutoMapper.GetListAtributes(aClass[i]);

      Table := TAutoMapper.GetTableAttribute(aClass[i]);
      if TableList.IndexOf(Table) = -1 then
      begin
         if FConnection.Driver = 'MSSQL' then
            TMSSQL.CreateTable(FConnection, ListAtributes, Table)
         else
         if (FConnection.Driver = 'Firebird') or (FConnection.Driver = 'FB') then
            TFirebird.CreateTable(FConnection, ListAtributes, Table);
      end;
  end;
  TableList.Free;
  //ListAtributes.clear;
end;

procedure TDataContext.AlterTables(aClass: array of TClass);
var
  i, K: integer;
  Table: string;
  List: TList;
  TableList: TStringList;
  FieldList: TStringList;

  procedure AlterTable(Table, Field, Tipo: string; IsNull: boolean);
  begin
    FConnection.ExecutarSQL('Alter table ' + Table + ' Add ' + Field + ' ' +
      Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL'));
  end;

begin
  try
    TableList := TStringList.Create(true);
    FieldList := TStringList.Create(true);
    FConnection.GetTableNames(TableList);
    for i := 0 to length(aClass) - 1 do
    begin
      Table := TAutoMapper.GetTableAttribute(aClass[i]);
      if TableList.IndexOf(Table) <> -1 then
      begin
        FConnection.GetFieldNames(FieldList, Table);
        List := TAutoMapper.GetListAtributes(aClass[i]);
        for K := 0 to List.Count - 1 do
        begin
          if FieldList.IndexOf( PParamAtributies(List.Items[K]).Name ) = -1 then
          begin
            if PParamAtributies(List.Items[K]).Tipo <>'' then
            begin
              AlterTable(Table, PParamAtributies(List.Items[K]).Name,
              PParamAtributies(List.Items[K]).Tipo,
              PParamAtributies(List.Items[K]).IsNull);
            end;
          end;
        end;
      end;
    end;
  finally
    TableList.free;
    FieldList.free;
  end;

end;

procedure TDataContext.InsertDirect;
var
  SQLInsert: string;
begin
  SQLInsert := 'Insert into ' + TAutoMapper.GetTableAttribute(FEntity.ClassType) +
    ' (' + TAutoMapper.GetAttributies(FEntity) + ') values ( ' +
    TAutoMapper.GetValuesFields(FEntity) + ' )';
  Connection.ExecutarSQL(SQLInsert);
end;

procedure TDataContext.Insert;
var
  ListField, ListValues: TStringList;
begin
  FEntity.Validation;
  if ClientDataSet <> nil then
  begin
    ListField := TAutoMapper.GetAttributiesList(FEntity);
    ListValues := TAutoMapper.GetValuesFieldsList(FEntity);
    ClientDataSet.append;
    pParserDataSet(ListField, ListValues, ClientDataSet);
    ClientDataSet.Post;
  end
  else
  InsertDirect;
end;

procedure TDataContext.UpdateDataBase(aClass: array of TClass);
begin
  CreateTables(aClass);
  AlterTables(aClass);
end;

procedure TDataContext.UpdateDirect;
var
  SQL: string;
begin
  SQL := 'Update ' + TAutoMapper.GetTableAttribute(FEntity.ClassType) + ' Set ' +
    fParserUpdate(TAutoMapper.GetAttributiesList(FEntity),
    TAutoMapper.GetValuesFieldsList(FEntity)) + ' Where ' +
    fParserWhere(TAutoMapper.GetAttributiesPrimaryKeyList(FEntity),
    TAutoMapper.GetValuesFieldsPrimaryKeyList(FEntity));
  Connection.ExecutarSQL(SQL);
end;

procedure TDataContext.InputEntity(Contener: TComponent);
begin
  //refatorar
  if Contener is TForm then
     TAutoMapper.Puts(Contener, FEntity)
  else
     TAutoMapper.PutsFromControl(Contener as TCustomControl, FEntity);
end;

procedure TDataContext.ReadEntity(Contener: TComponent;
  DataSet: TDataSet = nil);
begin
  //Refatorar
  if DataSet <> nil then
    TAutoMapper.Read(Contener, FEntity, false, DataSet)
  else if not ClientDataSet.IsEmpty then
    TAutoMapper.Read(Contener, FEntity, false, ClientDataSet)
  else
    TAutoMapper.Read(Contener, FEntity, false);
end;

procedure TDataContext.InitEntity(Contener: TComponent);
begin
  //FEntity:= TEntityBase.create;
  Entity.Id:= 0;
  TAutoMapper.Read(Contener, FEntity, true);
end;

procedure TCustomDataContext.ReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  ShowMessage(E.Message);
end;

procedure TDataContext.Update;
var
  ListField, ListValues: TStringList;
begin
  if ClientDataSet <> nil then
  begin
    ListField := TAutoMapper.GetAttributiesList(FEntity);
    ListValues := TAutoMapper.GetValuesFieldsList(FEntity);
    ClientDataSet.Edit;
    pParserDataSet(ListField, ListValues, ClientDataSet);
    ClientDataSet.Post;
  end
  else
    UpdateDirect;
end;

procedure TDataContext.DeleteDirect;
var
  SQL: string;
begin
  SQL := 'Delete From ' + TAutoMapper.GetTableAttribute(FEntity.ClassType) + ' ' +
        ' Where ' + fParserWhere(TAutoMapper.GetAttributiesPrimaryKeyList(FEntity),
    TAutoMapper.GetValuesFieldsPrimaryKeyList(FEntity));
  Connection.ExecutarSQL(SQL);
  // verificar aqui se é o mesmo  registro
  if ClientDataSet <> nil then
    ClientDataSet.Delete;
end;

function TDataContext.GetFieldList: Data.DB.TFieldList;
begin
  result := ClientDataSet.FieldList;
end;

destructor TCustomDataContext.Destroy;
begin
  if ClientDataSet <> nil then
     ClientDataSet.Free;
  if drpProvider <> nil then
     drpProvider.Free;
  if qryQuery <> nil then
     qryQuery.Free;
  if oFrom <> nil then
     oFrom.Free;
  if Entity <> nil then
     Entity.Free;
end;

procedure TCustomDataContext.DataSetProviderGetTableName(Sender: TObject;
  DataSet: TDataSet; var TableName: string);
begin
  TableName := uppercase(FSEntity);
end;

procedure TDataContext.Delete;
begin
  if (ClientDataSet.Active) and (not ClientDataSet.IsEmpty) then
  ClientDataSet.Delete;
end;

procedure TDataContext.ApplyUpdates;
begin
  if ChangeCount > 0 then
  ClientDataSet.ApplyUpdates(0);
end;

procedure TDataContext.RefreshDataSet;
begin
  if (ClientDataSet.Active) then
      ClientDataSet.Refresh;
end;

function TDataContext.ChangeCount: Integer;
begin
  result := ClientDataSet.changeCount;
end;

constructor TCustomDataContext.Create(proConnection: TEntityConn = nil);
begin
  FConnection := proConnection;
end;

procedure TQueryAble.SetEntity(const Value: TEntityBase);
begin
  FEntity := Value;
end;


procedure TCustomDataContext.CreateProvider(var proSQLQuery: TDataSet;
  prsNomeProvider: string);
begin
  drpProvider                := TDataSetProvider.Create(Application);
  drpProvider.Name           := prsNomeProvider;
  drpProvider.DataSet        := proSQLQuery;
  drpProvider.UpdateMode     := upWhereKeyOnly;
//drpProvider.UpdateMode     := upWhereAll;
  drpProvider.Options        :=[poAutoRefresh,poUseQuoteChar];
  drpProvider.OnGetTableName := DataSetProviderGetTableName;
//drpProvider.ResolveToDataSet:= true;
end;

procedure TCustomDataContext.CreateClientDataSet( proDataSetProvider
  : TDataSetProvider; SQL: string = '');
begin
  if proDataSetProvider <>  nil then
  begin
    ClientDataSet := TClientDataSet.Create(Application);
    ClientDataSet.OnReconcileError := ReconcileError;
    ClientDataSet.ProviderName := proDataSetProvider.Name;
  end
  else
  if FProviderName <> '' then
  begin
    ClientDataSet.ProviderName := FProviderName;
    ClientDataSet.DataRequest(SQL);
  end
  else
  begin
    showmessage('DataSetProvider não foi definido!');
    abort;
  end;
  ClientDataSet.open;
end;

{ TLinq }

function TCustomDataContext.GetQuery(QueryAble: TQueryAble): string;
begin
  with QueryAble as TCustomDataContext do
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

function From(E: TEntityBase): TFrom;
begin
  result := TFrom(Linq.From(E));
end;

function From(E: array of TEntityBase): TFrom;
begin
  result := TFrom(Linq.From(E));
end;

function From(E: String): TFrom;
begin
  result := TFrom(Linq.From(E));
end;

function From(E: TClass): TFrom;
begin
  result := TFrom(Linq.From(E));
end;

function From(E: TQueryAble): TFrom;
begin
  result := TFrom(Linq.From(E));
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

function TCustomDataContext.Join(E, _On: string): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + E + StrOn + _On;
  result := self;
end;

function TCustomDataContext.Join(E: TEntityBase; _On: TString): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TCustomDataContext.Join(E: TEntityBase): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + TAutoMapper.GetReferenceAtribute(self.Entity, E);
  result := self;
end;

function TCustomDataContext.Join(E: TClass): TQueryAble;
begin
  self.SJoin := self.SJoin + StrInnerJoin + TAutoMapper.GetTableAttribute
    (E) + StrOn + TAutoMapper.GetReferenceAtribute(self.Entity, E);
  result := self;
end;

function TCustomDataContext.JoinLeft(E, _On: string): TQueryAble;
begin
  self.SJoin := self.SJoin + StrLeftJoin + E + StrOn + _On;
  result := self;
end;

function TCustomDataContext.JoinLeft(E: TEntityBase; _On: TString): TQueryAble;
begin
  self.SJoin := self.SJoin + StrLeftJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TCustomDataContext.JoinRight(E, _On: string): TQueryAble;
begin
  self.SJoin := self.SJoin + StrRightJoin + E + StrOn + _On;
  result := self;
end;

function TCustomDataContext.JoinRight(E: TEntityBase; _On: TString): TQueryAble;
begin
  self.SJoin := self.SJoin + StrRightJoin + TAutoMapper.GetTableAttribute
    (E.ClassType) + StrOn + _On.Value;
  result := self;
end;

function TCustomDataContext.Where(condition: string): TQueryAble;
begin
  self.SWhere := StrWhere + condition;
  result := self;
end;

function TCustomDataContext.Where(condition: TString): TQueryAble;
begin
  self.SWhere := Concat(StrWhere, condition);
  result := self;
end;

function TCustomDataContext.GroupBy(Fields: string): TQueryAble;
begin
  self.SGroupBy := Concat(StrGroupBy, Fields);
  result := self;
end;

function TCustomDataContext.GroupBy(Fields: array of string): TQueryAble;
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

function TCustomDataContext.Order(Fields: string): TQueryAble;
begin
  self.SOrder := Concat(StrOrderBy, Fields);
  result := self;
end;

function TCustomDataContext.Order(Fields: array of string): TQueryAble;
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

function TCustomDataContext.OrderDesc(Fields: string): TQueryAble;
begin
  self.SOrder := Concat(StrOrderBy, Fields, StrDesc);
  result := self;
end;

function TCustomDataContext.OrderDesc(Fields: array of string): TQueryAble;
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

function TCustomDataContext.Select(Fields: string = ''): TSelect;
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

function TCustomDataContext.Select(Fields: array of string): TSelect;
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


