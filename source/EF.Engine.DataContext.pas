{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		            Since 01/01/2019                        }
{*******************************************************}
unit EF.Engine.DataContext;

interface

uses
  MidasLib, System.Classes, strUtils, SysUtils, Variants, Dialogs,
  DateUtils,
  Datasnap.Provider, Forms, Datasnap.DBClient, System.Contnrs, Data.DB,
  System.Generics.Collections, Vcl.DBCtrls, StdCtrls, Controls, System.TypInfo,
  System.threading,
  // Essas units darão suporte ao nosso framework
  EF.Core.Consts,
  EF.Drivers.Connection,
  EF.Core.Types,
  EF.Mapping.Atributes,
  EF.Mapping.Base,
  EF.Core.Functions,
  EF.QueryAble.Base,
  EF.QueryAble.Interfaces,
  FireDAC.Comp.Client,
  Data.DB.Helper ;

Type
  TDataContext = class(TQueryAble)
  private
    ListObjectsInclude:TList;
    ListObjectsThenInclude:TList;
    //Classes: array of TClass;
    FFDQuery: TFDQuery;
    drpProvider: TDataSetProvider;
    FDbSet: TClientDataSet;

    FConnection: TEntityConn;
    FProviderName: string;
    FTypeConnetion: TTypeConnection;

    ListField: TStringList;
    //function CreateTables: boolean; // (aClass: array of TClass);
    //function AlterTables: boolean;
    procedure FreeObjects;
   //function CreateSingleTable(i: integer): boolean;
    //function IsFireBird: boolean;

  protected
    procedure DataSetProviderGetTableName(Sender: TObject; DataSet: TDataSet; var TableName: string); virtual;
    procedure ReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction); virtual;
    procedure CreateClientDataSet(proDataSetProvider: TDataSetProvider; SQL: string = '');
    procedure CreateProvider(var proSQLQuery: TFDQuery; prsNomeProvider: string);
    property Connection: TEntityConn read FConnection write FConnection;
  public
    destructor Destroy; override;
    constructor Create(proEntity: TEntityBase = nil); overload; virtual;
    procedure Add;
    procedure Update;
    procedure Remove;
    procedure SaveChanges;
    procedure AddDirect;
    procedure UpdateDirect;
    procedure RemoveDirect;
    function FindEntity(QueryAble: IQueryAble): TEntityBase; overload;
    function FindEntity<T: Class>(QueryAble: IQueryAble): T; overload;
    function Where(Condicion: TString): TEntityBase;
    function Include( E: TObject ):TDataContext;
    function ThenInclude(E: TObject ): TDataContext;
    function ToData(QueryAble: IQueryAble): OleVariant;
    function ToDataSet(QueryAble: IQueryAble): TClientDataSet;
    function ToList(QueryAble: IQueryAble): TList;overload;
    function ToList<T: TEntityBase>(QueryAble: IQueryAble): TList<T>; overload;
    function ToJson(QueryAble: IQueryAble): string;
  //function UpdateDataBase(aClasses: array of TClass): boolean;
    procedure RefreshDataSet;
    function ChangeCount: integer;
    function GetFieldList: Data.DB.TFieldList;

  published
    property DbSet: TClientDataSet read FDbSet write FDbSet;
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
  Vcl.ExtCtrls,
  EF.Schema.Firebird,
  EF.Schema.MSSQL,
  EF.Mapping.AutoMapper;

function TDataContext.ToData(QueryAble: IQueryAble): OleVariant;
begin
  try
    FFDQuery := FConnection.CreateDataSet(GetQuery(QueryAble));

    CreateProvider(FFDQuery, trim(fStringReplace(QueryAble.SEntity,
        trim(StrFrom), '')));
    CreateClientDataSet(drpProvider);

    result := DbSet.Data;

  finally
    FreeObjects;
  end;
end;

procedure TDataContext.FreeObjects;
begin
  if DbSet <> nil then
  begin
    DbSet.Close;
    DbSet.Free;
    DbSet:= nil;
  end;
  if drpProvider <> nil then
  begin
    drpProvider.Free;
    drpProvider:= nil;
  end;
  if FFDQuery <> nil then
  begin
    FFDQuery.close;
    FFDQuery.Free;
    FFDQuery:= nil;
  end;
end;

function TDataContext.ToDataSet(QueryAble: IQueryAble): TClientDataSet;
var
  Keys: TStringList;
begin
  try
    try
      FreeObjects;
      if FProviderName = '' then
      begin
        Keys := TAutoMapper.GetFieldsPrimaryKeyList(QueryAble.Entity);
        FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

        FFDQuery := FConnection.CreateDataSet(GetQuery(QueryAble), Keys);

        CreateProvider(FFDQuery, trim(fStringReplace(QueryAble.SEntity,  trim(StrFrom), '')));

        CreateClientDataSet(drpProvider);
      end
      else
      begin
        CreateClientDataSet(nil, GetQuery(QueryAble));
      end;
      result := DbSet;
    except
      on E: Exception do
      begin
        showmessage(E.message);
      end;
    end;
  finally
    Keys.Free;
  end;
end;

function TDataContext.ToList<T>(QueryAble: IQueryAble): TList<T>;
var
  List: TList<T>;
  DataSet: TClientDataSet;
begin
  try
    FEntity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    List := TList<T>.Create;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    while not DataSet.Eof do
    begin
      TAutoMapper.DataToEntity(DataSet, QueryAble.Entity);
      List.Add(QueryAble.Entity);
      DataSet.Next;
    end;
    result := List;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext.ToList(QueryAble: IQueryAble): TList;
var
  List: TList;
  DataSet: TClientDataSet;
begin
  try
    FEntity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    List := TList.Create;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    while not DataSet.Eof do
    begin
      TAutoMapper.DataToEntity(DataSet, QueryAble.Entity);
      List.Add(QueryAble.Entity);
      DataSet.Next;
    end;
    result := List;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext.FindEntity(QueryAble: IQueryAble): TEntityBase;
var
  DataSet: TClientDataSet;
begin
  try

    FEntity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);

    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    TAutoMapper.DataToEntity(DataSet, QueryAble.Entity);
    result := QueryAble.Entity;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext.FindEntity<T>(QueryAble: IQueryAble): T;
var
  DataSet: TClientDataSet;
begin
  try
    result := nil;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    TAutoMapper.DataToEntity(DataSet, QueryAble.Entity);
    result := QueryAble.Entity as T;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

procedure TDataContext.AddDirect;
var
  SQLInsert: string;
begin
  SQLInsert := Format('Insert into %s ( %s ) ) values ( %s ) ',
                      [TAutoMapper.GetTableAttribute(FEntity.ClassType),
                      TAutoMapper.GetAttributies(FEntity),
                      TAutoMapper.GetValuesFields(FEntity)]);
  FConnection.ExecutarSQL(SQLInsert);
end;

procedure TDataContext.Add;
var
  ListValues: TStringList;
  i: integer;
begin
  FEntity.Validation;
  if DbSet <> nil then
  begin
    try
      try
        if ListField = nil then
           ListField := TAutoMapper.GetFieldsList(FEntity);
        ListValues := TAutoMapper.GetValuesFieldsList(FEntity);
        DbSet.append;
        pParserDataSet(ListField, ListValues, DbSet);
        DbSet.Post;
      except
        on E: Exception do
        begin
          raise Exception.Create(E.message);
        end;
      end;
    finally
      //ListField.Free;
      ListValues.Free;
    end;
  end
  else
    AddDirect;
end;

procedure TDataContext.Update;
var
   ListValues: TStringList;
  i: integer;
begin
  FEntity.Validation;
  if DbSet <> nil then
  begin
    try
      try
        if ListField = nil then
           ListField := TAutoMapper.GetFieldsList(FEntity);
        ListValues := TAutoMapper.GetValuesFieldsList(FEntity);
        DbSet.Edit;
        pParserDataSet(ListField, ListValues, DbSet);
        DbSet.Post;
      except
        on E: Exception do
        begin
          raise Exception.Create(E.message);
        end;
      end;
    finally
      //ListField.Free;
      //ListField := nil;
      ListValues.Free;
      ListValues := nil;
    end;
  end
  else
    UpdateDirect;
end;

procedure TDataContext.UpdateDirect;
var
  SQL: string;
  ListPrimaryKey, FieldsPrimaryKey: TStringList;
begin
  try
    try
      ListPrimaryKey := TAutoMapper.GetFieldsPrimaryKeyList(FEntity);
      FieldsPrimaryKey := TAutoMapper.GetValuesFieldsPrimaryKeyList(FEntity);

      SQL := Format( 'Update %s Set %s where %s',[TAutoMapper.GetTableAttribute(FEntity.ClassType),
                                                  fParserUpdate(TAutoMapper.GetFieldsList(FEntity),
                                                                TAutoMapper.GetValuesFieldsList(FEntity)),
                                                  fParserWhere(ListPrimaryKey, FieldsPrimaryKey) ] );
      FConnection.ExecutarSQL(SQL);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.message);
      end;
    end;
  finally
    ListPrimaryKey.Free;
    FieldsPrimaryKey.Free;
  end;
end;

procedure TDataContext.RemoveDirect;
var
  SQL: string;
  ListPrimaryKey, FieldsPrimaryKey: TStringList;
begin
  try
    try
      ListPrimaryKey := TAutoMapper.GetFieldsPrimaryKeyList(FEntity);
      FieldsPrimaryKey := TAutoMapper.GetValuesFieldsPrimaryKeyList(FEntity);
      SQL := Format( 'Delete From %s where %s',[TAutoMapper.GetTableAttribute(FEntity.ClassType),
                                                fParserWhere(ListPrimaryKey, FieldsPrimaryKey) ] );
      FConnection.ExecutarSQL(SQL);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.message);
      end;
    end;
  finally
    ListPrimaryKey.Free;
    FieldsPrimaryKey.Free;
  end;
end;

procedure TDataContext.ReconcileError(DataSet: TCustomClientDataSet;
    E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  showmessage(E.message);
end;

function TDataContext.GetFieldList: Data.DB.TFieldList;
begin
  result := DbSet.FieldList;
end;

function TDataContext.ToJson(QueryAble: IQueryAble): string;
  var
  Keys: TStringList;
begin
  try
    Keys     := TAutoMapper.GetFieldsPrimaryKeyList(QueryAble.Entity);
    FSEntity := TAutoMapper.GetTableAttribute(FEntity.ClassType);
    FFDQuery := FConnection.CreateDataSet(GetQuery(QueryAble), Keys);
    if not FFDQuery.Active then
       FFDQuery.Open;
    result:= FFDQuery.ToJson();
  finally
    FFDQuery.Free;
    FFDQuery:= nil;
    Keys.Free;
  end;
end;

destructor TDataContext.Destroy;
begin
  if drpProvider <> nil then
    drpProvider.Free;
  if FFDQuery <> nil then
    FFDQuery.Free;
  if DbSet <> nil then
    DbSet.Free;
  if oFrom <> nil then
    oFrom.Free;
  if FEntity <> nil then
    FEntity.Free;
  if ListField <> nil then
    ListField.Free;
  if ListObjectsInclude <> nil then
    ListObjectsInclude.Free;
  if ListObjectsThenInclude <> nil then
    ListObjectsThenInclude.Free;
  // if FConnection <> nil then    FConnection.Free;
end;

procedure TDataContext.DataSetProviderGetTableName(Sender: TObject;
    DataSet: TDataSet; var TableName: string);
begin
  TableName := uppercase(FSEntity);
end;

procedure TDataContext.Remove;
begin
  if (DbSet.Active) and (not DbSet.IsEmpty) then
    DbSet.Delete;
end;

procedure TDataContext.SaveChanges;
begin
  if ChangeCount > 0 then
    DbSet.ApplyUpdates(0);
end;

procedure TDataContext.RefreshDataSet;
begin
  if (DbSet.Active) then
    DbSet.Refresh;
end;

function TDataContext.ChangeCount: integer;
begin
  result := FDbSet.ChangeCount;
end;

procedure TDataContext.CreateProvider(var proSQLQuery: TFDQuery;
    prsNomeProvider: string);
begin
  drpProvider := TDataSetProvider.Create(Application);
  drpProvider.Name := prsNomeProvider + formatdatetime('SS', now);
  drpProvider.DataSet := proSQLQuery;
  drpProvider.UpdateMode := upWhereKeyOnly;
  // drpProvider.UpdateMode     := upWhereAll;
  drpProvider.Options := [poAutoRefresh, poUseQuoteChar];
  drpProvider.OnGetTableName := DataSetProviderGetTableName;
  // drpProvider.ResolveToDataSet:= true;
end;

constructor TDataContext.Create(proEntity: TEntityBase = nil);
begin
  FEntity := proEntity;
end;

procedure TDataContext.CreateClientDataSet(proDataSetProvider: TDataSetProvider;
    SQL: string = '');
begin
  if proDataSetProvider <> nil then
  begin
    DbSet := TClientDataSet.Create(Application);
    DbSet.OnReconcileError := ReconcileError;
    DbSet.ProviderName := proDataSetProvider.Name;
  end
  else if FProviderName <> '' then
  begin
    DbSet.ProviderName := FProviderName + formatdatetime('SS', now);
    DbSet.DataRequest(SQL);
  end
  else
  begin
    showmessage('DataSetProvider não foi definido!');
    abort;
  end;
  DbSet.open;
end;


function TDataContext.Where(Condicion: TString ): TEntityBase;
var
  maxthenInclude, maxInclude :integer;
  ReferenceEntidy, FirstEntity, PriorEntity: TEntityBase;
  CurrentEntidy: TObject;
  FirstTable, TableForeignKey: string;
  List:TList;
  I, j, k: Integer;
  IndexInclude , IndexThenInclude:integer;
begin
  try
    if ListObjectsInclude = nil then
       ListObjectsInclude:= TList.Create;
    //Adicionar primeira a entidade principal do contexto
    if ListObjectsInclude.Count = 0 then
       ListObjectsInclude.Add(FEntity);

    I:=0;
    j:=0;
    k:=0;
    maxInclude:= ListObjectsInclude.Count-1;
    maxthenInclude:= ListObjectsthenInclude.Count-1;

    //for I := 0 to max do
    while I <= maxInclude do
    begin
      IndexInclude:= i;
      if ListObjectsInclude.Items[IndexInclude] <> nil then
      begin
        CurrentEntidy:= ListObjectsInclude.Items[IndexInclude];
        try
          if i = 0 then
          begin
            FirstEntity := TEntityBase(ListObjectsInclude.Items[0]);
            FirstTable := Copy(FirstEntity.ClassName,2,length(FirstEntity.ClassName) );
            FirstEntity := FindEntity( From(TEntityBase(FirstEntity)).Where( Condicion ).Select );
          end
          else
          begin
            if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
               CurrentEntidy := ToList( From(TEntityBase(TEntityList(CurrentEntidy).List)).
                                                      Where( FirstTable+'Id='+ FirstEntity.Id.Value.ToString ).
                                                      Select )
            else
               CurrentEntidy := FindEntity( From(TEntityBase(CurrentEntidy)).
                                            Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                                            Select );
          end;
        finally
          Inc(I);
          FreeObjects;
        end;
      end
      else
      begin
        ReferenceEntidy := TEntityBase(CurrentEntidy);
        TableForeignKey := Copy(ReferenceEntidy.ClassName,2,length(ReferenceEntidy.ClassName) );

        for j := i-1 to maxthenInclude do
        begin
          try
            if ListObjectsthenInclude.Items[j] <> nil then
            begin
              CurrentEntidy:= ListObjectsthenInclude.Items[j];
              if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
              begin
                 List := ToList( From(TEntityBase(TEntityList(ListObjectsthenInclude.Items[j]).List)).
                                 Where( TableForeignKey+'Id='+ TAutoMapper.GetValueProperty( ReferenceEntidy, 'Id') ).
                                 Select );

                 while TEntityList(ListObjectsthenInclude.items[j]).Count > 1 do
                    TEntityList(ListObjectsthenInclude.items[j]).Delete( TEntityList(ListObjectsthenInclude.items[j]).Count - 1 );

                 for k := 0 to List.Count-1 do
                 begin
                    TEntityList(ListObjectsthenInclude.items[j]).Add( List[k]);
                 end;
              end
              else
              begin
                TableForeignKey := Copy(CurrentEntidy.ClassName,2,length(CurrentEntidy.ClassName) );
                ListObjectsthenInclude.Items[j] := FindEntity( From(TEntityBase(ListObjectsthenInclude.Items[j])).
                                                               Where( 'Id='+ TAutoMapper.GetValueProperty( ReferenceEntidy, TableForeignKey+'Id') ).
                                                               Select );
              end;
              ReferenceEntidy := ListObjectsthenInclude.Items[j];
              TableForeignKey := Copy(CurrentEntidy.ClassName,2,length(CurrentEntidy.ClassName) );
              Inc(I);
            end
            else
            begin
              break;
            end;
          finally
            FreeObjects;
          end;
        end;
      end;

      if i > maxInclude then
         break;
    end;

    FEntity := FirstEntity;
    result  := FEntity;

  finally
    ListObjectsInclude.clear;
    ListObjectsInclude.Free;
    ListObjectsInclude:= nil;
    ListObjectsthenInclude.Clear;
    ListObjectsthenInclude.Free;
    ListObjectsthenInclude:= nil;
  end;

end;


function TDataContext.Include( E: TObject ):TDataContext;
begin
   if ListObjectsInclude = nil then
   begin
      ListObjectsInclude:= TList.Create;
      ListObjectsInclude.Add(FEntity);
   end;
   if ListObjectsThenInclude = nil then
   begin
      ListObjectsThenInclude:= TList.Create;
   end;
   ListObjectsInclude.Add( E );
   ListObjectsThenInclude.Add( nil );
   result:= self;
end;

function TDataContext.ThenInclude( E: TObject ):TDataContext;
begin
   ListObjectsThenInclude.Add( E );
   ListObjectsInclude.Add( nil );
   result:= self;
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
