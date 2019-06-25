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
  DateUtils, RTTI,
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
  Data.DB.Helper;

Type
  TDataContext<T:TEntityBase> = class(TQueryAble)
  private
    ListObjectsInclude:TList;
    ListObjectsThenInclude:TList;
    FFDQuery: TFDQuery;
    drpProvider: TDataSetProvider;
    FDbSet: TClientDataSet;
    FConnection: TEntityConn;
    FProviderName: string;
    FTypeConnetion: TTypeConnection;
    ListField: TStringList;
    procedure FreeObjects;
    function PutQuoted(Fields: string):string;
    procedure Prepare(QueryAble: IQueryAble);
  protected
    procedure DataSetProviderGetTableName(Sender: TObject; DataSet: TDataSet; var TableName: string); virtual;
    procedure ReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction); virtual;
    procedure CreateClientDataSet(proDataSetProvider: TDataSetProvider; SQL: string = '');
    procedure CreateProvider(var proSQLQuery: TFDQuery; prsNomeProvider: string);
    property Connection: TEntityConn read FConnection write FConnection;
  public
    destructor Destroy; override;
    constructor Create(proEntity: TEntityBase = nil); overload; virtual;
    function Find(QueryAble: IQueryAble): TEntityBase;overload;
    function Find<T: TEntityBase>(QueryAble: IQueryAble): T;overload;
    function Where<T:TEntityBase>(Condicion: TString): T;

    function Include( E: TObject ):TDataContext<T>;
    function ThenInclude(E: TObject ): TDataContext<T>;
    function ToData(QueryAble: IQueryAble): OleVariant;
    function ToDataSet(QueryAble: IQueryAble): TClientDataSet;
    function ToList(QueryAble: IQueryAble;  EntityList: TObject = nil): TEntityList;overload;
    function ToList<T: TEntityBase>(QueryAble: IQueryAble): TEntityList<T>; overload;
    function ToList(Condicion: TString): TEntityList<T>;overload;
    function ToJson(QueryAble: IQueryAble): string;

    procedure Add;
    procedure Update;
    procedure Remove;overload;
    procedure SaveChanges;
    procedure AddDirect;
    procedure UpdateDirect;
    procedure RemoveDirect;
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
  EF.Mapping.AutoMapper, System.Types, EF.Schema.PostGres;

function TDataContext<T>.ToData(QueryAble: IQueryAble): OleVariant;
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

procedure TDataContext<T>.FreeObjects;
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


function TDataContext<T>.PutQuoted(Fields: string):string;
var
   A: TStringDynArray;
   I: Integer;
   text: string;
begin
   Fields:= trim(stringreplace(Fields,'Select','', [] ));
   A:= strUtils.SplitString(Fields, ',');
   for I := 0 to length(A)-1 do
   begin
      if pos('.',A[I] ) > 0 then
         A[I] :=  '"'+ upperCase( copy( A[I],0, pos('.',A[I] )-1 ) )+'.'+ copy( A[I], pos('.',A[I] )+1, length(A[I]) )  +'"'
      else
         A[I] :=  '"'+ trim(A[I]) +'"';

      if I < length(A)-1 then
         text:= text + A[I] +' , '
      else
         text:= text + A[I];
   end;
   text:= stringreplace(text,'.','"."', [rfReplaceAll] );
   result:= text;
end;

procedure TDataContext<T>.Prepare(QueryAble: IQueryAble);
begin
  if FConnection.CustomTypeDataBase is TPostGres then
  begin
  //De modo a contemplar consultas às tabelas do Postgres,
  //faz-se necessário colocar aspas duplas
     QueryAble.SSelect := 'Select '+ PutQuoted( QueryAble.SSelect );
     QueryAble.SEntity := ' From "'+ upperCase( trim( stringreplace( QueryAble.SEntity ,'From ','', [] ) ) ) +'"';
  end;
end;

function TDataContext<T>.ToDataSet(QueryAble: IQueryAble): TClientDataSet;
var
  Keys: TStringList;
begin
  try
    try
      FreeObjects;
      Keys := TAutoMapper.GetFieldsPrimaryKeyList(Entity);
      FSEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);

      Prepare(QueryAble);

      FFDQuery := FConnection.CreateDataSet(GetQuery(QueryAble), Keys);

      CreateProvider( FFDQuery, trim(fStringReplace(QueryAble.SEntity,  trim(StrFrom), '')) );

      CreateClientDataSet( drpProvider );

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

function TDataContext<T>.ToList(Condicion: TString): TEntityList<T>;
var
  maxthenInclude, maxInclude :integer;
  ReferenceEntidy, ConcretEntity : TEntityBase;

  FirstEntity: T;

  CurrentEntidy ,ReferenceEntidyList, CurrentList : TObject;

  FirstTable, TableForeignKey, ValueId: string;

  ListEntity :TEntityList<T>;

  H, I, j : Integer;
  IndexInclude , IndexThenInclude:integer;

  Json: string;
begin
  try
    H:=0;   I:=0;    j:=0;

    if ListObjectsInclude = nil then
       ListObjectsInclude:= TList.Create;
    //Adicionar primeira a entidade principal do contexto
    if ListObjectsInclude.Count = 0 then
       ListObjectsInclude.Add(Entity);

    maxInclude:= ListObjectsInclude.Count-1;
    if ListObjectsthenInclude <> nil then
       maxthenInclude:= ListObjectsthenInclude.Count-1;

    ListEntity := ToList<T>( From( T ).Where( Condicion ).Select );
    for H := 0 to ListEntity.Count - 1 do
    begin
      I:= 0;
      while I <= maxInclude do
      begin
        IndexInclude:= i;
        if ListObjectsInclude.Items[IndexInclude] <> nil then
        begin
          try
            if i = 0 then
            begin
              Json:= (ListEntity.Items[H] as T).ToJson;
              FirstEntity := T.Create;
              FirstEntity.FromJson( Json );
              FirstTable  := Copy(FirstEntity.ClassName,2,length(FirstEntity.ClassName) );
            end
            else
            begin
              CurrentEntidy := ListObjectsInclude.Items[IndexInclude];
              ValueId:= FirstEntity.Id.Value.ToString;
              if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
              begin
                 CurrentEntidy := TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName );
                 ToList( From( TEntityList(CurrentEntidy).List.ClassType ).
                                 Where( FirstTable+'Id='+ ValueId ).Select, CurrentEntidy  );
              end
              else
              begin
                 TAutoMapper.SetObject( FirstEntity,
                                        CurrentEntidy.ClassName,
                                        Find( From(CurrentEntidy.ClassType).
                                                    Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                                                    Select ) );
              end;
            end;
          finally
            Inc(I);
            FreeObjects;
          end;
        end
        else
        begin
          ReferenceEntidy  := TAutoMapper.CreateObject(CurrentEntidy.QualifiedClassName ) as TEntityBase;
          json := (TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName ) as TEntityBase).ToJson;
          ReferenceEntidy.FromJson( json );

          TAutoMapper.SetObject( FirstEntity,
                                 ReferenceEntidy.ClassName,
                                 ReferenceEntidy );

          TableForeignKey := Copy(ReferenceEntidy.ClassName,2,length(ReferenceEntidy.ClassName) );
          for j := i-1 to maxthenInclude do
          begin
            try
              if ListObjectsthenInclude.Items[j] <> nil then
              begin
                CurrentEntidy:= ListObjectsthenInclude.Items[j];
                if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
                begin
                  CurrentList := TAutoMapper.CreateObject(CurrentEntidy.QualifiedClassName );
                  ValueId:= TAutoMapper.GetValueProperty( ReferenceEntidy, 'Id');
                  ToList( From( TEntityList(CurrentEntidy).List.ClassType).
                          Where( TableForeignKey+'Id='+ ValueId ).Select, CurrentList );
                  TAutoMapper.SetObject( ReferenceEntidy, CurrentEntidy.ClassName, CurrentList );
                  ReferenceEntidy := nil;
                  ReferenceEntidyList:=  CurrentList;
                end
                else
                begin
                  TableForeignKey := Copy(CurrentEntidy.ClassName,2,length(CurrentEntidy.ClassName) );
                  ValueId:=     TAutoMapper.GetValueProperty( ReferenceEntidy, TableForeignKey+'Id');
                  if ValueId <> '' then
                  begin
                     Json:= Find( From(CurrentEntidy.ClassType).Where('Id='+ ValueId).Select ).ToJson;
                     ConcretEntity := TAutoMapper.CreateObject(CurrentEntidy.QualifiedClassName) as TEntityBase;
                     ConcretEntity.FromJson( Json );
                     TAutoMapper.SetObject( ReferenceEntidy, ConcretEntity.ClassName, ConcretEntity );
                  end;
                  ReferenceEntidy :=  ConcretEntity  as TEntityBase;
                  TableForeignKey := Copy(ConcretEntity.ClassName,2,length(ConcretEntity.ClassName) );

                  ReferenceEntidyList:= nil;
                end;
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
      ListEntity.Items[H]:= FirstEntity as T;
    end;
    result  := ListEntity;
  finally
    ListObjectsInclude.clear;
    ListObjectsInclude.Free;
    ListObjectsInclude:= nil;
    if ListObjectsthenInclude <> nil then
    begin
      ListObjectsthenInclude.Clear;
      ListObjectsthenInclude.Free;
      ListObjectsthenInclude:= nil;
    end;
  end;
end;

function TDataContext<T>.ToList<T>(QueryAble: IQueryAble): TEntityList<T>;
var
  List: TEntityList<T>;
  DataSet: TClientDataSet;
  E: T;
begin
  try
    Entity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);
    List := TEntityList<T>.Create;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    while not DataSet.Eof do
    begin
      E:= T.Create;
      TAutoMapper.DataToEntity(DataSet, E );
      List.Add( E );
      DataSet.Next;
    end;
    result := List;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext<T>.ToList(QueryAble: IQueryAble; EntityList: TObject = nil): TEntityList;
var
  List: TEntityList;
  DataSet: TClientDataSet;
  E:TObject;
  Json: string;
begin
  try
    Entity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);

    if EntityList = nil then
       List := TEntityList.Create
    else
       List :=  TEntityList(EntityList);

    List.Clear;

    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    while not DataSet.Eof do
    begin
      E:= Entity.NewInstance;
      TAutoMapper.DataToEntity(DataSet, E  );
      List.Add( E );
      DataSet.Next;
    end;
    result := List;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext<T>.Find(QueryAble: IQueryAble): TEntityBase;
var
  DataSet: TClientDataSet;
begin
  try
    //FEntity := QueryAble.Entity;
    FSEntity := TAutoMapper.GetTableAttribute(QueryAble.Entity.ClassType);
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    TAutoMapper.DataToEntity(DataSet, QueryAble.Entity);
    result := QueryAble.Entity;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext<T>.Find<T>(QueryAble: IQueryAble): T;
var
  DataSet: TClientDataSet;
  E: T;
begin
  try
    result := nil;
    DataSet := TClientDataSet.Create(Application);
    DataSet.Data := ToData(QueryAble);
    E:= T.Create;
    TAutoMapper.DataToEntity(DataSet, E);
    result := E;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;


procedure TDataContext<T>.AddDirect;
var
  SQLInsert: string;
begin
  SQLInsert := Format('Insert into %s ( %s ) values ( %s ) ',
                      [TAutoMapper.GetTableAttribute(Entity.ClassType),
                      TAutoMapper.GetAttributies(Entity),
                      TAutoMapper.GetValuesFields(Entity)]);
  FConnection.ExecutarSQL(SQLInsert);
end;

procedure TDataContext<T>.Add;
var
  ListValues: TStringList;
  i: integer;
begin
  Entity.Validation;
  if DbSet <> nil then
  begin
    try
      try
        if ListField = nil then
           ListField := TAutoMapper.GetFieldsList(Entity);
        ListValues := TAutoMapper.GetValuesFieldsList(Entity);
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

procedure TDataContext<T>.Update;
var
   ListValues: TStringList;
  i: integer;
begin
  Entity.Validation;
  if DbSet <> nil then
  begin
    try
      try
        if ListField = nil then
           ListField := TAutoMapper.GetFieldsList(Entity);
        ListValues := TAutoMapper.GetValuesFieldsList(Entity);
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

procedure TDataContext<T>.UpdateDirect;
var
  SQL: string;
  ListPrimaryKey, FieldsPrimaryKey: TStringList;
begin
  try
    try
      ListPrimaryKey := TAutoMapper.GetFieldsPrimaryKeyList(Entity);
      FieldsPrimaryKey := TAutoMapper.GetValuesFieldsPrimaryKeyList(Entity);

      SQL := Format( 'Update %s Set %s where %s',[ TAutoMapper.GetTableAttribute(Entity.ClassType),
                                                   fParserUpdate(TAutoMapper.GetFieldsList(Entity),
                                                                TAutoMapper.GetValuesFieldsList(Entity)),
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

procedure TDataContext<T>.RemoveDirect;
var
  SQL: string;
  ListPrimaryKey, FieldsPrimaryKey: TStringList;
begin
  try
    try
      ListPrimaryKey := TAutoMapper.GetFieldsPrimaryKeyList(Entity);
      FieldsPrimaryKey := TAutoMapper.GetValuesFieldsPrimaryKeyList(Entity);
      SQL := Format( 'Delete From %s where %s',[TAutoMapper.GetTableAttribute(Entity.ClassType),
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

procedure TDataContext<T>.ReconcileError(DataSet: TCustomClientDataSet;
    E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  showmessage(E.message);
end;

function TDataContext<T>.GetFieldList: Data.DB.TFieldList;
begin
  result := DbSet.FieldList;
end;

function TDataContext<T>.ToJson(QueryAble: IQueryAble): string;
  var
  Keys: TStringList;
begin
  try
    Keys     := TAutoMapper.GetFieldsPrimaryKeyList(QueryAble.Entity);
    FSEntity := TAutoMapper.GetTableAttribute(Entity.ClassType);
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

destructor TDataContext<T>.Destroy;
begin
  if drpProvider <> nil then
    drpProvider.Free;
  if FFDQuery <> nil then
    FFDQuery.Free;
  if DbSet <> nil then
    DbSet.Free;
  if oFrom <> nil then
    oFrom.Free;
  if Entity <> nil then
    Entity.Free;
  if ListField <> nil then
    ListField.Free;
  if ListObjectsInclude <> nil then
    ListObjectsInclude.Free;
  if ListObjectsThenInclude <> nil then
    ListObjectsThenInclude.Free;
  // if FConnection <> nil then    FConnection.Free;
end;

procedure TDataContext<T>.DataSetProviderGetTableName(Sender: TObject;
    DataSet: TDataSet; var TableName: string);
begin
  TableName := uppercase(FSEntity);
end;

procedure TDataContext<T>.Remove;
begin
  //Refatorar
  if (DbSet.Active) and (not DbSet.IsEmpty) then
    DbSet.Delete;
end;

procedure TDataContext<T>.SaveChanges;
begin
  if ChangeCount > 0 then
    DbSet.ApplyUpdates(0);
end;

procedure TDataContext<T>.RefreshDataSet;
begin
  if (DbSet.Active) then
    DbSet.Refresh;
end;

function TDataContext<T>.ChangeCount: integer;
begin
  result := FDbSet.ChangeCount;
end;

procedure TDataContext<T>.CreateProvider(var proSQLQuery: TFDQuery;
    prsNomeProvider: string);
begin
  drpProvider := TDataSetProvider.Create(Application);
  drpProvider.Name := stringreplace(prsNomeProvider,'"','',[rfReplaceAll]) + formatdatetime('SSMS', now);
  drpProvider.DataSet := proSQLQuery;
  drpProvider.UpdateMode := upWhereKeyOnly;
  // drpProvider.UpdateMode     := upWhereAll;
  drpProvider.Options := [poAutoRefresh, poUseQuoteChar];
  drpProvider.OnGetTableName := DataSetProviderGetTableName;
  // drpProvider.ResolveToDataSet:= true;
end;

constructor TDataContext<T>.Create(proEntity: TEntityBase = nil);
begin
  Entity := proEntity;
end;

procedure TDataContext<T>.CreateClientDataSet(proDataSetProvider: TDataSetProvider;
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
    DbSet.ProviderName := FProviderName + formatdatetime('SSMS', now);
    DbSet.DataRequest(SQL);
  end
  else
  begin
    showmessage('DataSetProvider não foi definido!');
    abort;
  end;
  DbSet.open;
end;


function TDataContext<T>.Where<T>(Condicion: TString ): T;
var
  maxthenInclude, maxInclude :integer;
  ReferenceEntidy, PriorEntity: TEntityBase;
  FirstEntity:T;
  CurrentEntidy: TObject;
  FirstTable, TableForeignKey: string;
  List:TEntityList;
  I, j, k: Integer;
  IndexInclude , IndexThenInclude:integer;
begin
  try
    if ListObjectsInclude = nil then
       ListObjectsInclude:= TList.Create;
    //Adicionar primeira a entidade principal do contexto
    if ListObjectsInclude.Count = 0 then
       ListObjectsInclude.Add(Entity);

    I:=0;
    j:=0;
    k:=0;
    maxInclude:= ListObjectsInclude.Count-1;
    if ListObjectsthenInclude <> nil then
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
            FirstEntity := T(ListObjectsInclude.Items[0]);
            FirstTable  := Copy(FirstEntity.ClassName,2,length(FirstEntity.ClassName) );
            FirstEntity := Find<T>( From(T(FirstEntity)).Where( Condicion ).Select );
          end
          else
          begin
            if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
               CurrentEntidy := ToList( From( TEntityBase(TEntityList(CurrentEntidy).List)).
                                Where( FirstTable+'Id='+ FirstEntity.Id.Value.ToString ).
                                Select )
            else
               CurrentEntidy := Find( From( TEntityBase(CurrentEntidy)).
                                Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                                Select );

            TAutoMapper.SetObject( FirstEntity, CurrentEntidy.ClassName , CurrentEntidy );
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
                ListObjectsthenInclude.Items[j] := Find( From(TEntityBase(ListObjectsthenInclude.Items[j])).
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

    Entity := FirstEntity;
    result  := FirstEntity;

  finally
    ListObjectsInclude.clear;
    ListObjectsInclude.Free;
    ListObjectsInclude:= nil;
    if ListObjectsthenInclude <> nil then
    begin
      ListObjectsthenInclude.Clear;
      ListObjectsthenInclude.Free;
      ListObjectsthenInclude:= nil;
    end;
  end;

end;


function TDataContext<T>.Include( E: TObject ):TDataContext<T>;
begin
   if ListObjectsInclude = nil then
   begin
      ListObjectsInclude:= TList.Create;
      ListObjectsInclude.Add(Entity);
   end;
   if ListObjectsThenInclude = nil then
   begin
      ListObjectsThenInclude:= TList.Create;
   end;
   ListObjectsInclude.Add( E );
   ListObjectsThenInclude.Add( nil );
   result:= self;
end;

function TDataContext<T>.ThenInclude( E: TObject ):TDataContext<T>;
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
