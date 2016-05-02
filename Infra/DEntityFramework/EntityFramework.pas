unit EntityFramework;

interface

uses
  MidasLib, System.Classes, strUtils, RTTI, SysUtils, Variants,  Dialogs,  DateUtils,
  Datasnap.Provider, Forms, Datasnap.DBClient, System.Contnrs, Data.DB,
  System.Generics.Collections, Vcl.DBCtrls, StdCtrls, Controls, EntityConsts,
  EntityConnection, EntityTypes,  Atributies , EntityBase, EntityFunctions, LinqSQL;

Type
  TDataContext = class(TCustomQueryAble)
  private
    qryQuery: TDataSet;
    drpProvider: TDataSetProvider;
    FConnection: TEntityConn;
    FProviderName: string;
    FTypeConnetion: TTypeConnection;
    procedure CreateTables(aClass: array of TClass);
    procedure AlterTables(aClass: array of TClass);
    procedure FreeObjects;
  protected
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
    destructor Destroy; override;
    constructor Create(proConnection: TEntityConn = nil );virtual;
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
  published
    property Connection: TEntityConn read FConnection write FConnection;
    property ProviderName: string read FProviderName write FProviderName;
    property TypeConnetion: TTypeConnection read FTypeConnetion write FTypeConnetion;
  end;

  function From(E: String): TFrom; overload;
  function From(E: TEntityBase): TFrom; overload;
  function From(E: array of TEntityBase): TFrom; overload;
  function From(E: TClass): TFrom; overload;
  function From(E: TQueryAble): TFrom; overload;

implementation

uses
  Vcl.ExtCtrls, Data.SqlExpr, FireDAC.Comp.Client,
  EntityFirebird, EntityMSSQL,  AutoMapper;

function TDataContext.GetData(QueryAble: TQueryAble): OleVariant;
begin
  qryQuery := Connection.CreateDataSet( GetQuery(QueryAble) );

  CreateProvider(qryQuery, trim(fStringReplace(TCustomQueryAble(QueryAble).SEntity,
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
        Keys     := TAutoMapper.GetAttributiesPrimaryKeyList( Entity  );
        SEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);
        qryQuery := Connection.CreateDataSet(GetQuery(QueryAble), Keys );
        CreateProvider( qryQuery, trim(SEntity) );
        CreateClientDataSet(drpProvider);
      end
      else
      begin
        CreateClientDataSet( nil, GetQuery(QueryAble));
      end;

      TAutoMapper.DataToEntity( ClientDataSet, Entity );
      result := ClientDataSet;
    except
    on E:Exception do
      begin
        showmessage(E.message);
      end;
    end;
  finally
    Keys.free;
    QueryAble.free;
  end;
end;

function TDataContext.GetList(QueryAble: TQueryAble): TList<TEntityBase>;
var
  List: TList<TEntityBase>;
  DataSet: TClientDataSet;
begin
  try
    Entity := TCustomQueryAble(QueryAble).Entity;
    SEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);

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
    Entity := TCustomQueryAble(QueryAble).Entity;
    SEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);

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
    Entity := TCustomQueryAble(QueryAble).Entity;
    SEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);

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
  TableList, KeyList: TStringList;
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
         try
           KeyList   := TStringList.Create(true);
           FConnection.ExecutarSQL( FConnection.CustomTypeDataBase.CreateTable( ListAtributes, Table, KeyList) );
           if (FConnection.Driver = 'Firebird') or (FConnection.Driver = 'FB') then
           with TFirebird(FConnection.CustomTypeDataBase) do
           begin
             FConnection.ExecutarSQL( CreateGenarator(Table , trim(KeyList.text)) );
             FConnection.ExecutarSQL( SetGenarator(Table , trim(KeyList.text)) );
             FConnection.ExecutarSQL( CrateTriggerGenarator(Table , trim(KeyList.text)) );
           end;
         finally
           KeyList.free;
         end;
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
  ColumnExist:boolean;
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
          if PParamAtributies(List.Items[K]).Tipo <>'' then
          begin
             ColumnExist:= FieldList.IndexOf( PParamAtributies(List.Items[K]).Name ) <> -1;
             FConnection.ExecutarSQL(  FConnection.CustomTypeDataBase.AlterTable(
                                       Table,
                                       PParamAtributies(List.Items[K]).Name,
                                       PParamAtributies(List.Items[K]).Tipo,
                                       PParamAtributies(List.Items[K]).IsNull,
                                       ColumnExist) );
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
  SQLInsert := 'Insert into ' + TAutoMapper.GetTableAttribute(Entity.ClassType) +
    ' (' + TAutoMapper.GetAttributies(Entity) + ') values ( ' +
    TAutoMapper.GetValuesFields(Entity) + ' )';
  Connection.ExecutarSQL(SQLInsert);
end;

procedure TDataContext.Insert;
var
  ListField, ListValues: TStringList;
begin
  Entity.Validation;
  if ClientDataSet <> nil then
  begin
    ListField := TAutoMapper.GetAttributiesList(Entity);
    ListValues := TAutoMapper.GetValuesFieldsList(Entity);
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
  SQL := 'Update ' + TAutoMapper.GetTableAttribute(Entity.ClassType) + ' Set ' +
    fParserUpdate(TAutoMapper.GetAttributiesList(Entity),
    TAutoMapper.GetValuesFieldsList(Entity)) + ' Where ' +
    fParserWhere(TAutoMapper.GetAttributiesPrimaryKeyList(Entity),
    TAutoMapper.GetValuesFieldsPrimaryKeyList(Entity));
  Connection.ExecutarSQL(SQL);
end;

procedure TDataContext.InputEntity(Contener: TComponent);
begin
  //refatorar
  if Contener is TForm then
     TAutoMapper.Puts(Contener, Entity)
  else
     TAutoMapper.PutsFromControl(Contener as TCustomControl, Entity);
end;

procedure TDataContext.ReadEntity(Contener: TComponent;
  DataSet: TDataSet = nil);
begin
  //Refatorar
  if DataSet <> nil then
    TAutoMapper.Read(Contener, Entity, false, DataSet)
  else if not ClientDataSet.IsEmpty then
    TAutoMapper.Read(Contener, Entity, false, ClientDataSet)
  else
    TAutoMapper.Read(Contener, Entity, false);
end;

procedure TDataContext.InitEntity(Contener: TComponent);
begin
  //FEntity:= TEntityBase.create;
  Entity.Id:= 0;
  TAutoMapper.Read(Contener, Entity, true);
end;

procedure TDataContext.ReconcileError(DataSet: TCustomClientDataSet;
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
    ListField := TAutoMapper.GetAttributiesList(Entity);
    ListValues := TAutoMapper.GetValuesFieldsList(Entity);
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
  SQL := 'Delete From ' + TAutoMapper.GetTableAttribute(Entity.ClassType) + ' ' +
        ' Where ' + fParserWhere(TAutoMapper.GetAttributiesPrimaryKeyList(Entity),
    TAutoMapper.GetValuesFieldsPrimaryKeyList(Entity));
  Connection.ExecutarSQL(SQL);
  // verificar aqui se é o mesmo  registro
  if ClientDataSet <> nil then
    ClientDataSet.Delete;
end;

function TDataContext.GetFieldList: Data.DB.TFieldList;
begin
  result := ClientDataSet.FieldList;
end;

destructor TDataContext.Destroy;
begin
  if ClientDataSet <> nil then
     ClientDataSet.Free;
  if drpProvider <> nil then
     drpProvider.Free;
  if qryQuery <> nil then
     qryQuery.Free;
  if Entity <> nil then
     Entity.Free;
end;

procedure TDataContext.DataSetProviderGetTableName(Sender: TObject;
  DataSet: TDataSet; var TableName: string);
begin
  TableName := uppercase(SEntity);
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

constructor TDataContext.Create(proConnection: TEntityConn = nil);
begin
  FConnection := proConnection;
end;


procedure TDataContext.CreateProvider(var proSQLQuery: TDataSet;
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

procedure TDataContext.CreateClientDataSet( proDataSetProvider
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

end.
