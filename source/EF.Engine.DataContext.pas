unit EF.Engine.DataContext;

interface

uses
  MidasLib, System.Classes, strUtils, RTTI, SysUtils, Variants,  Dialogs,  DateUtils,
  Datasnap.Provider, Forms, Datasnap.DBClient, System.Contnrs, Data.DB,
  System.Generics.Collections, Vcl.DBCtrls, StdCtrls, Controls, System.TypInfo, System.threading,
  //Essas units dar�o suporte ao nosso framework
  EF.Core.Consts,
  EF.Drivers.Connection,
  EF.Core.Types,
  EF.Mapping.Atributes,
  EF.Mapping.Base,
  EF.Core.Functions,
  EF.QueryAble.Base,
  EF.QueryAble.Interfaces;


Type
  TDataContext = class(TQueryAble)
  private
    Classes: array of TClass;
    TableList:TStringList;
    qryQuery: TDataSet;
    drpProvider: TDataSetProvider;
    FConnection: TEntityConn;
    FProviderName: string;
    FTypeConnetion: TTypeConnection;
    FClientDataSet: TClientDataSet;
    function CreateTables:boolean;//(aClass: array of TClass);
    function AlterTables:boolean;
    procedure FreeObjects;
    function CriarTabela(i:integer):boolean;
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
    destructor Destroy; override;
    constructor Create(proEntity: TEntityBase = nil );overload;virtual;

    procedure InputEntity(Contener: TComponent);
    procedure ReadEntity(Contener: TComponent; DataSet: TDataSet = nil);
    procedure InitEntity(Contener: TComponent);
    function UpdateDataBase(aClasses: array of TClass):boolean;
    function GetEntity(QueryAble: IQueryAble): TEntityBase; overload;
    function GetEntity<T: Class>(QueryAble: IQueryAble): T; overload;
    function GetData(QueryAble: IQueryAble): OleVariant;
    function GetDataSet(QueryAble: IQueryAble): TClientDataSet;
    function GetList(QueryAble: IQueryAble): TList<TEntityBase>; overload;
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
    property ClientDataSet: TClientDataSet read FClientDataSet write FClientDataSet;
    property Connection: TEntityConn read FConnection write FConnection;
    property ProviderName: string read FProviderName write FProviderName;
    property TypeConnetion: TTypeConnection read FTypeConnetion write FTypeConnetion;
  end;


  function From(E: String): TFrom; overload;
  function From(E: TEntityBase): TFrom; overload;
  function From(E: array of TEntityBase): TFrom; overload;
  function From(E: TClass): TFrom; overload;
  function From(E: IQueryAble): TFrom; overload;



implementation

uses
  Vcl.ExtCtrls, Data.SqlExpr, FireDAC.Comp.Client,
  EF.Schema.Firebird,
  EF.Schema.MSSQL,
  EF.Mapping.AutoMapper;

function TDataContext.GetData(QueryAble: IQueryAble): OleVariant;
begin
  qryQuery := Connection.CreateDataSet( GetQuery(QueryAble) );

  CreateProvider(qryQuery, trim(fStringReplace(QueryAble.SEntity,
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

function TDataContext.GetDataSet(QueryAble: IQueryAble): TClientDataSet;
var
   Keys:TStringList;
begin
  try
    try
      FreeObjects;
      if FProviderName = '' then
      begin
        Keys := TAutoMapper.GetAttributiesPrimaryKeyList( QueryAble.Entity  );
        FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

        qryQuery := Connection.CreateDataSet(GetQuery(QueryAble), Keys );

        CreateProvider(qryQuery,
                        trim(fStringReplace(QueryAble.SEntity,
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

function TDataContext.GetList(QueryAble: IQueryAble): TList<TEntityBase>;
var
  List: TList<TEntityBase>;
  DataSet: TClientDataSet;
begin
  try
    FEntity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    List := TList<TEntityBase>.Create;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    while not DataSet.Eof do
    begin
      TAutoMapper.DataToEntity(DataSet, QueryAble.Entity);
      List.Add( QueryAble.Entity);
      DataSet.Next;
    end;
    result := List;
  finally
    FreeAndNil(DataSet);
  end;
end;

function TDataContext.GetEntity(QueryAble: IQueryAble): TEntityBase;
var
  DataSet: TClientDataSet;
begin
  try
    FEntity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    TAutoMapper.DataToEntity(DataSet, QueryAble .Entity);
    result := QueryAble.Entity;
  finally
    FreeAndNil(DataSet);
  end;
end;

function TDataContext.GetEntity<T>(QueryAble: IQueryAble): T;
var
  DataSet: TClientDataSet;
begin
  try
    result := nil;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := GetData(QueryAble);
    TAutoMapper.DataToEntity(DataSet,QueryAble.Entity);
    result := QueryAble.Entity as T;
  finally
    FreeAndNil(DataSet);
  end;
end;

function TDataContext.CriarTabela(i:integer): boolean;
  var
    Table: string;
    ListAtributes: TList;
    KeyList: TStringList;
    classe:TClass;
begin
   classe := Classes[i];
   Table := TAutoMapper.GetTableAttribute(classe);
   if Pos(uppercase(Table), uppercase(TableList.Text) ) = 0 then
   begin
     try
        ListAtributes  := nil;
        ListAtributes  := TAutoMapper.GetListAtributes(classe);
        KeyList   := TStringList.Create(true);
        if (FConnection.Driver = 'Firebird') or (FConnection.Driver = 'FB') then
        begin
          FConnection.ExecutarSQL( FConnection.CustomTypeDataBase.CreateTable( ListAtributes, Table, KeyList) );
          with TFirebird(FConnection.CustomTypeDataBase) do
          begin
            FConnection.ExecutarSQL( CreateGenarator(Table , trim(KeyList.text)) );
            FConnection.ExecutarSQL( SetGenarator(Table , trim(KeyList.text)) );
            FConnection.ExecutarSQL( CrateTriggerGenarator(Table , trim(KeyList.text)) );
          end;
        end
        else
           FConnection.ExecutarSQL( FConnection.CustomTypeDataBase.CreateTable( ListAtributes, Table, KeyList) );
        //ListAtributes.Free;
        result:= true;
     finally
        KeyList.Free;
     end;
   end;
end;

function TDataContext.UpdateDataBase(aClasses: array of TClass):boolean;
var
   I:integer;
   Created, Altered: boolean;
begin
   Created := false;
   Altered := false;
   if FConnection <> nil then
   begin
      TableList := TStringList.Create( true );
      FConnection.GetTableNames( TableList );
      SetLength( Classes , length(aClasses) );
      for I := 0 to length(aClasses)-1 do
      begin
         Classes[i] := aClasses[i];
      end;
      if length(aClasses) > 0 then
      begin
        Created := CreateTables;
        //Altered := AlterTables;
      end;
   end;
   result:= Created;
end;

function TDataContext.CreateTables:boolean;
var
  i: integer;
  created:boolean;
begin
  created := false;
  result  := false;
  for I := 0 to length(Classes) - 1  do
  begin
    created:= CriarTabela(I);
    if created then
       result:= created;
  end;

  {TParallel.for( 0, length(Classes) - 1 ,
                  procedure (Idx: Integer)
                  var Thr:TThread;
                  begin
                     Thr:= TThread.CurrentThread;

                     Thr.Queue( Thr,
                                    procedure
                                    begin
                                       CriarTabela(Idx);
                                    end);
                  end);  }

end;

function TDataContext.AlterTables:boolean;
var
  i, K , j: integer;
  Table: string;
  List: TList;
  FieldList: TStringList;
  ColumnExist:boolean;
  created:boolean;
begin
  try
    created:= false;
    FieldList := TStringList.Create(true);
    for i := 0 to length(Classes) - 1 do
    begin
      Table := TAutoMapper.GetTableAttribute(Classes[i]);
      if TableList.IndexOf(Table) <> -1 then
      begin
        FConnection.GetFieldNames(FieldList, Table);
        List := TAutoMapper.GetListAtributes(Classes[i]);
        for K := 0 to List.Count - 1 do
        begin
          if PParamAtributies(List.Items[K]).Tipo <>'' then
          begin
             ColumnExist:= FieldList.IndexOf( PParamAtributies(List.Items[K]).Name ) <> -1;
             if not ColumnExist then
             begin
                FConnection.ExecutarSQL(  FConnection.CustomTypeDataBase.AlterTable(
                                       Table,
                                       PParamAtributies(List.Items[K]).Name,
                                       PParamAtributies(List.Items[K]).Tipo,
                                       PParamAtributies(List.Items[K]).IsNull,
                                       ColumnExist) );
                created:= true;
             end;
          end;
        end;
      end;
    end;
  finally
    result:= created;
    FieldList.Free;
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
  I: Integer;
begin
  FEntity.Validation;
  if ClientDataSet <> nil then
  begin
    try
      try
        ListField := TAutoMapper.GetAttributiesList(FEntity);
        ListValues := TAutoMapper.GetValuesFieldsList(FEntity);
        ClientDataSet.append;
        pParserDataSet(ListField, ListValues, ClientDataSet);
        ClientDataSet.Post;
      except
        on E:Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      end;
    finally
      ListField.Free;
      ListValues.Free;
    end;
  end
  else
  InsertDirect;
end;

procedure TDataContext.UpdateDirect;
var
  SQL: string;
  ListPrimaryKey, FieldsPrimaryKey: TStringList;
begin
    try
      try
        ListPrimaryKey  := TAutoMapper.GetAttributiesPrimaryKeyList(FEntity);
        FieldsPrimaryKey := TAutoMapper.GetValuesFieldsPrimaryKeyList(FEntity);

        SQL := 'Update ' + TAutoMapper.GetTableAttribute(FEntity.ClassType) + ' Set ' +
        fParserUpdate(TAutoMapper.GetAttributiesList(FEntity),
        TAutoMapper.GetValuesFieldsList(FEntity)) + ' Where ' +
        fParserWhere( ListPrimaryKey , FieldsPrimaryKey );
        Connection.ExecutarSQL(SQL);
      except
        on E:Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      end;
    finally
      ListPrimaryKey.Free;
      FieldsPrimaryKey.Free;
    end;
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

procedure TDataContext.ReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  ShowMessage(E.Message);
end;

procedure TDataContext.Update;
var
  ListField, ListValues: TStringList;
  I: integer;
begin
  if ClientDataSet <> nil then
  begin
    try
      try
        ListField := TAutoMapper.GetAttributiesList(FEntity);
        ListValues := TAutoMapper.GetValuesFieldsList(FEntity);
        ClientDataSet.Edit;
        pParserDataSet(ListField, ListValues, ClientDataSet);
        ClientDataSet.Post;
      except
        on E:Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      end;
    finally
      ListField.Free;
      ListField:= nil;
      ListValues.Free;
      ListValues:= nil;
    end;
  end
  else
    UpdateDirect;
end;

procedure TDataContext.DeleteDirect;
var
  SQL: string;
  ListPrimaryKey, FieldsPrimaryKey: TStringList;
begin
  try
    try
      ListPrimaryKey  := TAutoMapper.GetAttributiesPrimaryKeyList(FEntity);
      FieldsPrimaryKey := TAutoMapper.GetValuesFieldsPrimaryKeyList(FEntity);

      SQL := 'Delete From ' + TAutoMapper.GetTableAttribute(FEntity.ClassType) + ' ' +
            ' Where ' + fParserWhere(ListPrimaryKey,FieldsPrimaryKey);
      Connection.ExecutarSQL(SQL);
      // verificar aqui se � o mesmo  registro
      if ClientDataSet <> nil then
        ClientDataSet.Delete;
    except
      on E:Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    ListPrimaryKey.Free;
    FieldsPrimaryKey.Free;
  end;
end;

function TDataContext.GetFieldList: Data.DB.TFieldList;
begin
  result := ClientDataSet.FieldList;
end;

destructor TDataContext.Destroy;
begin
  if ClientDataSet <> nil then  ClientDataSet.Free;
  if drpProvider <> nil then    drpProvider.Free;
  if qryQuery <> nil then       qryQuery.Free;
  if oFrom <> nil then          oFrom.Free;
  if Entity <> nil then         Entity.Free;
  if TableList <> nil then      TableList.Free;
  //if FConnection <> nil then    FConnection.Free;
end;

procedure TDataContext.DataSetProviderGetTableName(Sender: TObject;
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
  result := FClientDataSet.changeCount;
end;


procedure TDataContext.CreateProvider(var proSQLQuery: TDataSet;
  prsNomeProvider: string);
begin
  drpProvider                := TDataSetProvider.Create(Application);
  drpProvider.Name           := prsNomeProvider+ formatdatetime('SS', now);
  drpProvider.DataSet        := proSQLQuery;
  drpProvider.UpdateMode     := upWhereKeyOnly;
//drpProvider.UpdateMode     := upWhereAll;
  drpProvider.Options        :=[poAutoRefresh,poUseQuoteChar];
  drpProvider.OnGetTableName := DataSetProviderGetTableName;
//drpProvider.ResolveToDataSet:= true;
end;

constructor TDataContext.Create(proEntity: TEntityBase = nil);
begin
  FEntity:= proEntity;
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
    ClientDataSet.ProviderName := FProviderName+ formatdatetime('SS', now);
    ClientDataSet.DataRequest(SQL);
  end
  else
  begin
    showmessage('DataSetProvider n�o foi definido!');
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

function From(E: IQueryAble): TFrom;
begin
  result := TFrom(Linq.From(E));
end;

end.


