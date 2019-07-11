{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		            Since 01/01/2019                        }
{*******************************************************}
unit EF.Engine.DataContext;

interface

uses
  System.Classes, strUtils, SysUtils, Variants, Dialogs,
  DateUtils, System.Types, Forms, System.Contnrs, Data.DB,
  System.Generics.Collections, Vcl.DBCtrls,
  FireDAC.Comp.Client, Data.DB.Helper,EF.Core.List,
  // Essas units darão suporte ao nosso framework
  EF.Drivers.Connection,
  EF.Core.Types,
  EF.Mapping.Atributes,
  EF.Mapping.Base,
  EF.Core.Functions,
  EF.QueryAble.Base,
  EF.QueryAble.Interfaces;

Type
   TTypeSQL       = (  tsInsert, tsUpdate );

  TDataContext<T:TEntityBase> = class(TQueryAble)
  private
    ListObjectsInclude:TObjectList;
    ListObjectsThenInclude:TObjectList;
    FDbSet: TFDQuery;
    FConnection: TEntityConn;
    FProviderName: string;
    FTypeConnetion: TTypeConnection;
    ListField: TStringList;
    FEntity : T;
    procedure FreeObjects;
    function PutQuoted(Fields: string):string;
    procedure Prepare(QueryAble: IQueryAble);
  protected
    property Connection: TEntityConn read FConnection write FConnection;
  public
    destructor Destroy; override;
    constructor Create(proEntity: TEntityBase = nil); overload; virtual;
    function Find(QueryAble: IQueryAble): TEntityBase;overload;
    function Find<T: TEntityBase>(QueryAble: IQueryAble): T;overload;
    function Where(Condicion: TString): T;

    function Include( E: TObject ):TDataContext<T>;
    function ThenInclude(E: TObject ): TDataContext<T>;
    function ToDataSet(QueryAble: IQueryAble): TFDQuery;
    function ToList(QueryAble: IQueryAble;  EntityList: TObject = nil): TEntityList;overload;
    function ToList<T: TEntityBase>(QueryAble: IQueryAble): TEntityList<T>; overload;
    function ToList(Condicion: TString): TEntityList<T>;overload;
    function ToJson(QueryAble: IQueryAble): string;

    procedure Add(E: T);
    procedure Update;
    procedure Remove;overload;
    procedure SaveChanges;
    procedure RemoveDirect;
    procedure RefreshDataSet;
    function ChangeCount: integer;
    function GetFieldList: Data.DB.TFieldList;
  published
    property DbSet: TFDQuery read FDbSet write FDbSet;
    property ProviderName: string read FProviderName write FProviderName;
    property TypeConnetion: TTypeConnection read FTypeConnetion write FTypeConnetion;
    property Entity : T read FEntity write FEntity;
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
  EF.Mapping.AutoMapper,  EF.Schema.PostGres;

procedure TDataContext<T>.FreeObjects;
begin
  if DbSet <> nil then
  begin
    DbSet.Close;
    DbSet.Free;
    DbSet:= nil;
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

function TDataContext<T>.ToDataSet(QueryAble: IQueryAble): TFDQuery;
var
  Keys: TStringList;
  DataSet:TFDQuery;
begin
  try
    try
      FreeObjects;
      Keys := TAutoMapper.GetFieldsPrimaryKeyList(QueryAble.ConcretEntity);
      FSEntity := TAutoMapper.GetTableAttribute(QueryAble.ConcretEntity.ClassType);
      Prepare(QueryAble);
      DataSet := FConnection.CreateDataSet(GetQuery(QueryAble), Keys);
      DataSet.Open;
      result := DataSet;
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
  ReferenceEntidy, ConcretEntity, EntidyInclude : TEntityBase;
  FirstEntity: T;
  CurrentEntidy ,ReferenceEntidyList, CurrentList : TObject;
  FirstTable, TableForeignKey, ValueId: string;
  ListEntity :TEntityList<T>;
  H, I, j : Integer;
  IndexInclude , IndexThenInclude:integer;
  Json: string;
begin
  try
    if ListObjectsInclude = nil then
       ListObjectsInclude:= TObjectList.Create(false);
    //Adicionar primeira a entidade principal do contexto
    if ListObjectsInclude.Count = 0 then
       ListObjectsInclude.Add(Entity);

    FirstEntity:= Entity;

    H:=0;
    I:=0;
    j:=0;

    maxInclude:= ListObjectsInclude.Count-1;
    if ListObjectsthenInclude <> nil then
       maxthenInclude:= ListObjectsthenInclude.Count-1;

    ListEntity := ToList<T>( From( FirstEntity ).Where( Condicion ).Select );


    if (ListObjectsInclude.Count > 1) or ( ListObjectsthenInclude <> nil ) then
    begin
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
                  { TAutoMapper.SetObject( FirstEntity,
                                          CurrentEntidy.ClassName,
                                          Find( From(CurrentEntidy.ClassType).
                                                      Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                                                      Select ) ); }
                   EntidyInclude := Find( From( CurrentEntidy.ClassType).
                          Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                          Select );
                   Json:= EntidyInclude.ToJson;
                   EntidyInclude.Free;
                   EntidyInclude:= TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName ) as TEntityBase;
                   EntidyInclude.FromJson( Json );
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
    end;

    result  := ListEntity;
  finally
    ListObjectsInclude.clear;
    ListObjectsInclude.Free;
    ListObjectsInclude:= nil;
    if ListObjectsthenInclude <> nil then
    begin
      ListObjectsInclude.clear;
      ListObjectsthenInclude.Free;
      ListObjectsthenInclude:= nil;
    end;
  end;
end;

function TDataContext<T>.ToList<T>(QueryAble: IQueryAble): TEntityList<T>;
var
  List: TEntityList<T>;
  DataSet: TFDQuery;
  E: T;
begin
  try
    FSEntity := TAutoMapper.GetTableAttribute(QueryAble.ConcretEntity.ClassType);
    List := TEntityList<T>.Create;
    List.Clear;
    DataSet := ToDataSet(QueryAble);
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
  DataSet: TFDQuery;
  E: TEntityBase;
  Json: string;
begin
  try
    FSEntity := TAutoMapper.GetTableAttribute(QueryAble.ConcretEntity.ClassType);

    if EntityList = nil then
       List := TEntityList.Create
    else
       List :=  TEntityList(EntityList);

    List.Clear;
    DataSet := ToDataSet(QueryAble);
    while not DataSet.Eof do
    begin
      E:= QueryAble.ConcretEntity.NewInstance as TEntityBase;
      TAutoMapper.DataToEntity(DataSet, E );
      List.Add( E  );
      DataSet.Next;
    end;
    result := List;
  finally
     QueryAble.ConcretEntity.Free;
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext<T>.Find(QueryAble: IQueryAble): TEntityBase;
var
  DataSet: TFDQuery;
begin
  try
  //Está alterando os objetos  de entity quando na verdade deveria manter inalterada
  //e manipular o objeto de QueryAble.ConcretEntity da Entidade
    FSEntity := TAutoMapper.GetTableAttribute(QueryAble.ConcretEntity.ClassType);
    DataSet := ToDataSet(QueryAble);
    TAutoMapper.DataToEntity(DataSet, QueryAble.ConcretEntity);
    result := QueryAble.ConcretEntity;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDataContext<T>.Find<T>(QueryAble: IQueryAble): T;
var
  DataSet: TFDQuery;
  E: T;
begin
  try
    result := nil;
    DataSet := ToDataSet(QueryAble);
    //E:= T.Create;
    TAutoMapper.DataToEntity(DataSet,QueryAble.ConcretEntity );
    result := QueryAble.ConcretEntity as T;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

procedure TDataContext<T>.Add(E: T);
var
  ListValues: TStringList;
  i: integer;
begin
  if DbSet <> nil then
  begin
    E.Validation;
    FEntity := E;
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
      ListValues.Free;
      ListValues := nil;
    end;
  end
  else
  begin
    DbSet:= ToDataSet( from(E).Select.Where(E.Id = 0) );
    Add(E);
  end;
end;

procedure TDataContext<T>.Update;
var
  ListValues: TStringList;
begin
  if DbSet <> nil then
  begin
    Entity.Validation;
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
      ListValues.Free;
      ListValues := nil;
    end;
  end
  else
  begin
    DbSet:= ToDataSet( from(Entity).Select.Where(Entity.Id = Entity.Id.Value) );
    Update;
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

function TDataContext<T>.GetFieldList: Data.DB.TFieldList;
begin
  result := DbSet.FieldList;
end;

function TDataContext<T>.ToJson(QueryAble: IQueryAble): string;
  var
  Keys: TStringList;
begin
  try
    Keys     := TAutoMapper.GetFieldsPrimaryKeyList(QueryAble.ConcretEntity);
    FSEntity := TAutoMapper.GetTableAttribute(QueryAble.ConcretEntity.ClassType);
    DBSet := FConnection.CreateDataSet(GetQuery(QueryAble), Keys);
    if not DBSet.Active then
       DBSet.Open;
    result:= DBSet.ToJson();
  finally
    QueryAble.ConcretEntity.Free;
    DBSet.Free;
    DBSet:= nil;
    Keys.Free;
  end;
end;

destructor TDataContext<T>.Destroy;
begin
  if FDbSet <> nil then
    FreeAndNil(FDbSet);
  if oFrom <> nil then
    FreeAndNil(oFrom);
  if FEntity <> nil then
    FreeAndNil(FEntity);
  if ListField <> nil then
    FreeAndNil(ListField);
  if ListObjectsInclude <> nil then
    FreeAndNil(ListObjectsInclude);
  if ListObjectsThenInclude <> nil then
    FreeAndNil(ListObjectsThenInclude);
  if Connection <> nil then
     Connection.Free;
end;

procedure TDataContext<T>.Remove;
begin
  //Refatorar
  if (DbSet <> nil ) and (DbSet.Active) and (not DbSet.IsEmpty) then
    DbSet.Delete;
end;

procedure TDataContext<T>.SaveChanges;
begin
  if (DbSet <> nil ) and (ChangeCount > 0) then
      DbSet.ApplyUpdates(0);
end;

procedure TDataContext<T>.RefreshDataSet;
begin
  if (DbSet <> nil ) and (DbSet.Active) then
    DbSet.Refresh;
end;

function TDataContext<T>.ChangeCount: integer;
begin
   if (DbSet <> nil ) then
      result := FDbSet.ChangeCount
   else
      result := 0;
end;

constructor TDataContext<T>.Create(proEntity: TEntityBase = nil);
begin
  Entity := T.Create
end;

function TDataContext<T>.Where(Condicion: TString ): T;
var
  maxthenInclude, maxInclude :integer;
  ReferenceEntidy, EntidyInclude: TEntityBase;
  FirstEntity: T;
  CurrentEntidy: TObject;
  FirstTable, TableForeignKey: string;
  List:TEntityList;
  I, j, k: Integer;
  IndexInclude , IndexThenInclude:integer;

  Json:string;
begin
  try
    if ListObjectsInclude = nil then
    begin
       ListObjectsInclude:= TObjectList.Create(false);
    end;
    if ListObjectsInclude.Count = 0 then
    begin
       ListObjectsInclude.Add(T.Create);
    end;

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
            FirstEntity := Find<T>( From(FirstEntity).Where( Condicion ).Select );
          end
          else
          begin
            if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
            begin
              CurrentEntidy := TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName );
              ToList( From( TEntityList(CurrentEntidy).List.ClassType ).
                      Where( FirstTable+'Id='+ FirstEntity.Id.Value.ToString ).
                      Select,
                      CurrentEntidy  );
            end
            else
            begin
               EntidyInclude := Find( From( CurrentEntidy.ClassType).
                                        Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                                        Select );
               Json:= EntidyInclude.ToJson;
               EntidyInclude.Free;
               EntidyInclude:= TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName ) as TEntityBase;
               EntidyInclude.FromJson( Json );
            end;
          end;
        finally
          Inc(i);
          FreeObjects;
        end;
      end
      else
      begin
        if ListObjectsthenInclude <> nil then
        begin
          ReferenceEntidy := EntidyInclude;
          TableForeignKey := Copy(ReferenceEntidy.ClassName,2,length(ReferenceEntidy.ClassName) );

          for j := i-1 to maxthenInclude do
          begin
            try
              if ListObjectsthenInclude.Items[j] <> nil then
              begin
                CurrentEntidy:= ListObjectsthenInclude.Items[j];
                if Pos('TEntityList', CurrentEntidy.ClassName) > 0 then
                begin
                   //Refatorar
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
                   EntidyInclude := Find( From( CurrentEntidy.ClassType).
                                          Where( 'Id='+  TAutoMapper.GetValueProperty( ReferenceEntidy, TableForeignKey+'Id') ).
                                          Select );
                   Json:= EntidyInclude.ToJson;
                   EntidyInclude.Free;
                   EntidyInclude:= TAutoMapper.GetObject(ReferenceEntidy, CurrentEntidy.ClassName ) as TEntityBase;
                   EntidyInclude.FromJson( Json );
                end;
                ReferenceEntidy := ListObjectsthenInclude.Items[j] as TEntityBase;
                TableForeignKey := Copy( CurrentEntidy.ClassName, 2, length(CurrentEntidy.ClassName) );
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
      end;

      if i > maxInclude then
         break;
    end;

    //Entity := FirstEntity;
    result := FirstEntity;
  finally
    ListObjectsInclude.Clear;
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
      ListObjectsInclude:= TObjectList.Create(false);
      ListObjectsInclude.Add(T.Create);
      ListObjectsThenInclude:= TObjectList.Create(false);
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
