{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		            Since 01/01/2019                        }
{*******************************************************}
unit EF.Engine.DbSet;

interface

uses
  System.Classes, strUtils, SysUtils, Variants, //Dialogs,
  DateUtils, System.Types,  System.Contnrs, Data.DB,
  System.Generics.Collections,
  FireDAC.Comp.Client, Data.DB.Helper,EF.Core.List,
  // Essas units darão suporte ao nosso framework
  EF.QueryAble.Linq,
  EF.Drivers.Connection,
  EF.Core.Types,
  EF.Mapping.Atributes,
  EF.Mapping.Base,
  EF.Core.Functions,
  EF.QueryAble.Base,
  EF.QueryAble.Interfaces;

Type
   TTypeSQL       = (  tsInsert, tsUpdate );



  TDbSet<T:TEntityBase> = class
  strict private
    ListObjectsInclude:TObjectList;
    ListObjectsThenInclude:TObjectList;
    FDbSet: TFDQuery;
    FDatabase: TDatabaseFacade;
    FListFields: TStringList;
    FEntity : T;
    procedure FreeDbSet;
  private

  protected
    function FindEntity(QueryAble: IQueryAble): TEntityBase;
    property DbSet: TFDQuery read FDbSet write FDbSet;
  public
    property Database: TDatabaseFacade read FDatabase write FDatabase;

    constructor Create( aDatabase: TDatabaseFacade ); overload; virtual;
    constructor Create(proEntity: T );overload; virtual;
    destructor Destroy; override;

    function Any:Boolean;overload;
    function Any(Condition:TString ):Boolean;overload;
    function Any(QueryAble: IQueryAble ):Boolean;overload;

    function Count:integer;overload;
    function Count(Condition:TString ):integer;overload;

    function BuildQuery(QueryAble: IQueryAble): string;

    function Find(QueryAble: IQueryAble): T; overload;
    function Find(Condition: TString): T;overload;

    function FromSQL(SQL: string):T;

    function Where(Condition: TString): T;

    function ToList(QueryAble: IQueryAble;  EntityList: TObject = nil): Collection;overload;
    function ToList<T: TEntityBase>(QueryAble: IQueryAble): Collection<T>; overload;
    function ToList(Condition: TString): Collection<T>;overload;
    function Include( E: TObject ):TDbSet<T>;
    function ThenInclude(E: TObject ): TDbSet<T>;

    function ToDataSet(QueryAble: IQueryAble): TFDQuery;overload;
    function ToDataSet(QueryAble: String): TFDQuery;overload;

    function ToJson(QueryAble: IQueryAble): string;overload;
    function ToJson(QueryAble: String): string; overload;

    procedure Add(E: T;AutoSaveChange:boolean = false); overload;
    //procedure Add(E: TAnonym;AutoSaveChange:boolean = false); overload;


    procedure Update(AutoSaveChange:boolean = false);
    procedure Remove(Condition: TString);overload;

    procedure AddRange(entities:  Collection<T>;AutoSaveChange:boolean = false);
    procedure UpdateRange(entities: Array of T;AutoSaveChange:boolean = false);
    procedure RemoveRange(entities: TObjectList<T>);

    procedure SaveChanges;
    procedure RefreshDataSet;
    function ChangeCount: integer;
    function GetFieldList: Data.DB.TFieldList;

  published

    property Entity : T read FEntity;
  end;

implementation

uses
  EF.Schema.Firebird,
  EF.Schema.MSSQL,
  EF.Mapping.AutoMapper,
  EF.Schema.PostGres;

procedure TDbSet<T>.FreeDbSet;
begin
  if DbSet <> nil then
  begin
    DbSet.Close;
    DbSet.Free;
    DbSet:= nil;
  end;
end;

function TDbSet<T>.FromSQL(SQL: string): T;
var
  DataSet: TFDQuery;
  E: T;
begin
  try
    result := nil;
    DataSet := ToDataSet(SQL);
    //E:= T.Create;
    TAutoMapper.DataToEntity(DataSet,Entity );
    result := Entity as T;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDbSet<T>.ToDataSet(QueryAble: IQueryAble): TFDQuery;
var
  DataSet:TFDQuery;
begin
  try
    FreeDbSet;
    if FDatabase.CustomTypeDataBase is TPostGres then
       QueryAble.Prepare;

       DataSet :=  FDatabase.CreateDataSet( QueryAble.BuildQuery(QueryAble) );
       DataSet.Open;
       result := DataSet;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;



function TDbSet<T>.ToDataSet(QueryAble: String): TFDQuery;
var
  DataSet:TFDQuery;
begin
  try
    FreeDbSet;
    DataSet := FDatabase.CreateDataSet( QueryAble );
    DataSet.Open;
    //FDbSet:= DataSet;
    result := DataSet;
  except
    on E: Exception do
    begin
            raise Exception.Create(E.Message);
    end;
  end;
end;

function TDbSet<T>.ToList(Condition: TString): Collection<T>;
var
  maxthenInclude, maxInclude :integer;
  ReferenceEntidy, ConcretEntity, EntidyInclude : TEntityBase;
  FirstEntity: T;
  CurrentEntidy , CurrentList : TObject;
  FirstTable, TableForeignKey, ValueId: string;
  ListEntity :Collection<T>;
  H, I, j : Integer;
  IndexInclude , IndexThenInclude:integer;
  Json: string;
  QueryAble:IQueryAble;
begin
  try
    if ListObjectsInclude = nil then
       ListObjectsInclude:= TObjectList.Create(false);
    //Adicionar primeira a entidade principal do contexto
    if ListObjectsInclude.Count = 0 then
       ListObjectsInclude.Add(T.Create);

    FirstEntity:= ListObjectsInclude.Items[0] as T;//Entity;

    H:=0;
    I:=0;
    j:=0;

    maxInclude:= ListObjectsInclude.Count-1;
    if ListObjectsthenInclude <> nil then
       maxthenInclude:= ListObjectsthenInclude.Count-1;

    QueryAble:= From( FirstEntity ).Where( Condition ).Select;

    ListEntity := ToList<T>( QueryAble );

    FirstEntity.free;

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
                if Pos('Collection', CurrentEntidy.ClassName) > 0 then
                begin
                   CurrentEntidy := TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName );
                   QueryAble:= From( Collection(CurrentEntidy).List.ClassType ).
                                   Where( FirstTable+'Id='+ ValueId ).Select;
                   ToList(QueryAble , CurrentEntidy  );
                end
                else
                begin
                   QueryAble:= From( CurrentEntidy.ClassType).
                               Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                               Select;
                   EntidyInclude := FindEntity( QueryAble );
                   Json:= EntidyInclude.ToJson;
                   EntidyInclude.Free;
                   EntidyInclude:= TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName ) as TEntityBase;
                   EntidyInclude.FromJson( Json );
                end;
              end;
            finally
              Inc(I);
              FreeDbSet;
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
                  if Pos('Collection', CurrentEntidy.ClassName) > 0 then
                  begin
                    CurrentList := TAutoMapper.CreateObject(CurrentEntidy.QualifiedClassName );
                    ValueId:= TAutoMapper.GetValueProperty( ReferenceEntidy, 'Id');
                    QueryAble:= From( Collection(CurrentEntidy).List.ClassType).
                                Where( TableForeignKey+'Id='+ ValueId ).Select;
                    ToList( QueryAble , CurrentList );
                    TAutoMapper.SetObject( ReferenceEntidy, CurrentEntidy.ClassName, CurrentList );
                    ReferenceEntidy := nil;
                  end
                  else
                  begin
                    TableForeignKey := Copy(CurrentEntidy.ClassName,2,length(CurrentEntidy.ClassName) );
                    ValueId:=     TAutoMapper.GetValueProperty( ReferenceEntidy, TableForeignKey+'Id');
                    if ValueId <> '' then
                    begin
                       QueryAble:= From(CurrentEntidy.ClassType).Where('Id='+ ValueId).Select;
                       Json:= FindEntity( QueryAble ).ToJson;
                       ConcretEntity := TAutoMapper.CreateObject(CurrentEntidy.QualifiedClassName) as TEntityBase;
                       ConcretEntity.FromJson( Json );
                       TAutoMapper.SetObject( ReferenceEntidy, ConcretEntity.ClassName, ConcretEntity );
                    end;
                    ReferenceEntidy :=  ConcretEntity  as TEntityBase;
                    TableForeignKey := Copy(ConcretEntity.ClassName,2,length(ConcretEntity.ClassName) );
                  end;
                  Inc(I);
                end
                else
                begin
                  break;
                end;
              finally
                FreeDbSet;
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
      ListObjectsthenInclude.clear;
      ListObjectsthenInclude.Free;
      ListObjectsthenInclude:= nil;
    end;
  end;
end;

function TDbSet<T>.ToList<T>(QueryAble: IQueryAble): Collection<T>;
var
  List: Collection<T>;
  DataSet: TFDQuery;
  E: T;
begin
  try
    List := Collection<T>.Create;
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

function TDbSet<T>.ToList(QueryAble: IQueryAble; EntityList: TObject = nil): Collection;
var
  List: Collection;
  DataSet: TFDQuery;
  E: TEntityBase;
  Json: string;
begin
  try
    if EntityList = nil then
       List := Collection.Create
    else
       List := Collection(EntityList);

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

function TDbSet<T>.FindEntity(QueryAble: IQueryAble): TEntityBase;
var
  DataSet: TFDQuery;
begin
  try
    DataSet := ToDataSet(QueryAble);
    TAutoMapper.DataToEntity(DataSet, QueryAble.ConcretEntity);
    result := QueryAble.ConcretEntity;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

function TDbSet<T>.Find(QueryAble: IQueryAble): T;
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

function TDbSet<T>.Find(Condition: TString): T;
var
  DataSet: TFDQuery;
  E: T;
  QueryAble:IQueryAble;
begin
  try
    result := nil;
    QueryAble:= From(FEntity).Where(Condition).Select;

    DataSet := ToDataSet( QueryAble );

    TAutoMapper.DataToEntity(DataSet,QueryAble.ConcretEntity );
    result := QueryAble.ConcretEntity as T;
  finally
     DataSet.Free;
     DataSet:= nil;
  end;
end;

procedure TDbSet<T>.Add(E: T; AutoSaveChange:boolean = false);
var
  ListValues: TStringList;
  i: integer;
begin
  if FDbSet <> nil then
  begin
    //E.Validate;
    try
      try
        if FListFields = nil then
           FListFields := TAutoMapper.GetFieldsList(E);
        ListValues := TAutoMapper.GetValuesFieldsList(E);
        FDbSet.append;
        pParserDataSet(FListFields, ListValues, FDbSet);
        FDbSet.Post;
        if AutoSaveChange then
           SaveChanges;
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
    FDbSet:= ToDataSet( from(E).Select.Where(E.Id = 0) );
    Add(E, AutoSaveChange);
  end;
end;

{procedure TDbSet<T>.Add(E: TAnonym; AutoSaveChange: boolean);
begin
  Add( E, AutoSaveChange );
end;}

procedure TDbSet<T>.Update( AutoSaveChange:boolean = false);
var
  ListValues: TStringList;
begin
  if FDbSet <> nil then
  begin
    //Entity.Validate;
    try
      try
         if FListFields = nil then
           FListFields := TAutoMapper.GetFieldsList(Entity);
        ListValues := TAutoMapper.GetValuesFieldsList(Entity);
        FDbSet.Edit;
        pParserDataSet(FListFields, ListValues, FDbSet);
        FDbSet.Post;
        if AutoSaveChange then
           SaveChanges;
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
    FDbSet:= ToDataSet( from(Entity).Select.Where(Entity.Id = Entity.Id.Value) );
    Update(AutoSaveChange);
  end;
end;

procedure TDbSet<T>.AddRange(entities: Collection<T>;AutoSaveChange:boolean = false );
var
  E: T;
begin
   for E in entities  do
   begin
     Add( E );
   end;
   if AutoSaveChange then
      SaveChanges;
end;

function TDbSet<T>.Any: Boolean;
var
  DataSet: TFDQuery;
  QueryAble:IQueryAble;
begin
    QueryAble:= From(FEntity).Select.Count;//From(FEntity).Select(FEntity.ID);
    DataSet := ToDataSet( QueryAble );
    result:= not DataSet.IsEmpty;
    DataSet.Free;
end;

function TDbSet<T>.Any(QueryAble: IQueryAble): Boolean;
var
  DataSet: TFDQuery;
begin
    DataSet := ToDataSet( QueryAble );
    result:= not DataSet.IsEmpty;
    DataSet.Free;
end;

function TDbSet<T>.Any(Condition:TString ): Boolean;
var
  DataSet: TFDQuery;
  QueryAble:IQueryAble;
begin
    QueryAble:= From(FEntity).Where(Condition).Select.Count;
    DataSet := ToDataSet( QueryAble );
    result:= not DataSet.IsEmpty;
    DataSet.Free;
end;

procedure TDbSet<T>.UpdateRange(entities: array of T;AutoSaveChange:boolean = false);
var
  E: T;
begin
   for E in entities do
   begin
     FEntity:= E;
     Update;
   end;
   if AutoSaveChange then
      SaveChanges;
end;

procedure TDbSet<T>.RemoveRange(entities: TObjectList<T>);
var
  E: T;
begin
   for E in entities do
   begin
     Remove(Entity.ID = E.ID.Value );
   end;
end;

function TDbSet<T>.GetFieldList: Data.DB.TFieldList;
begin
  result := DbSet.FieldList;
end;

function TDbSet<T>.BuildQuery(QueryAble: IQueryAble): string;
begin
   result:= QueryAble.BuildQuery(QueryAble);
end;

function TDbSet<T>.ToJson(QueryAble: IQueryAble): string;
  var
  Keys: TStringList;
begin
  try
    DBSet := FDatabase.CreateDataSet(QueryAble.BuildQuery(QueryAble));
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

function TDbSet<T>.ToJson(QueryAble: String): string;
  var
  Keys: TStringList;
begin
  try
    DBSet := FDatabase.CreateDataSet(QueryAble);
    if not DBSet.Active then
       DBSet.Open;
    result:= DBSet.ToJson();
  finally
    DBSet.Free;
    DBSet:= nil;
    Keys.Free;
  end;
end;

destructor TDbSet<T>.Destroy;
begin
  if FDbSet <> nil then
    FreeAndNil(FDbSet);
  if FEntity <> nil then
    FreeAndNil(FEntity);
  if FListFields <> nil then
    FreeAndNil(FListFields);
  if ListObjectsInclude <> nil then
    FreeAndNil(ListObjectsInclude);
  if ListObjectsThenInclude <> nil then
    FreeAndNil(ListObjectsThenInclude);
  //if Database <> nil then
  //  Database.Free;
end;

procedure TDbSet<T>.Remove(Condition: TString);
var
  SQL: string;
begin
  try
    SQL := Format( 'Delete From %s where %s',[TAutoMapper.GetTableAttribute(T), Condition.Value ] );
    FDataBase.ExecutarSQL(SQL);
  except
    on E: Exception do
    begin
      raise Exception.Create(E.message);
    end;
  end;
end;

procedure TDbSet<T>.SaveChanges;
begin
  if (DbSet <> nil ) and (ChangeCount > 0) then
      DbSet.ApplyUpdates(0);
end;

procedure TDbSet<T>.RefreshDataSet;
begin
  if (DbSet <> nil ) and (DbSet.Active) then
    DbSet.Refresh;
end;

function TDbSet<T>.ChangeCount: integer;
begin
   if (DbSet <> nil ) then
      result := FDbSet.ChangeCount
   else
      result := 0;
end;

function TDbSet<T>.Count: integer;
var
  DataSet: TFDQuery;
  QueryAble:IQueryAble;
begin
  QueryAble:= From(FEntity).Select('Count(*)');//From(FEntity).Select(FEntity.ID);
  DataSet := ToDataSet( QueryAble );
  result:= DataSet.fields[0].AsInteger;
  DataSet.Free;
end;

function TDbSet<T>.Count(Condition: TString): integer;
var
  DataSet: TFDQuery;
  QueryAble:IQueryAble;
begin
  QueryAble:= From(FEntity).Where(Condition).Select('Count(*)');//From(FEntity).Select(FEntity.ID);
  DataSet := ToDataSet( QueryAble );
  result:= DataSet.fields[0].AsInteger;
  DataSet.Free;
end;

constructor TDbSet<T>.Create( aDatabase: TDatabaseFacade );
begin
  //if proEntity = nil then
  FEntity := T.Create;
  //else
  //Entity := proEntity as T;
  FDatabase:= aDatabase;
end;

constructor TDbSet<T>.Create(proEntity: T );
begin
  if proEntity = nil then
    FEntity := T.Create
  else
    FEntity := proEntity as T;
end;

function TDbSet<T>.Where(Condition: TString ): T;
var
  maxthenInclude, maxInclude :integer;
  ReferenceEntidy, EntidyInclude: TEntityBase;
  FirstEntity: T;
  CurrentEntidy: TObject;
  FirstTable, TableForeignKey: string;
  List:Collection;
  I, j, k: Integer;
  IndexInclude , IndexThenInclude:integer;
  QueryAble: IQueryAble;
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
            QueryAble   := From(FirstEntity).Where( Condition ).Select;
            FirstEntity := Find( QueryAble );
          end
          else
          begin
            if Pos('Collection', CurrentEntidy.ClassName) > 0 then
            begin
              CurrentEntidy := TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName );
              QueryAble:= From( Collection(CurrentEntidy).List.ClassType ).
                          Where( FirstTable+'Id='+ FirstEntity.Id.Value.ToString ).
                          Select;
              ToList( QueryAble , CurrentEntidy  );
            end
            else
            begin
               QueryAble:= From( CurrentEntidy.ClassType).
                           Where( FirstTable+'Id='+  FirstEntity.Id.Value.ToString ).
                           Select;
               EntidyInclude := FindEntity( QueryAble );
               Json:= EntidyInclude.ToJson;
               EntidyInclude.Free;
               EntidyInclude:= TAutoMapper.GetObject(FirstEntity, CurrentEntidy.ClassName ) as TEntityBase;
               EntidyInclude.FromJson( Json );
            end;
          end;
        finally
          Inc(i);
          FreeDbSet;
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
                if Pos('Collection', CurrentEntidy.ClassName) > 0 then
                begin
                   //Refatorar
                   QueryAble:= From(TEntityBase(Collection(ListObjectsthenInclude.Items[j]).List)).
                               Where( TableForeignKey+'Id='+ TAutoMapper.GetValueProperty( ReferenceEntidy, 'Id') ).
                               Select;
                   List := ToList( QueryAble );

                   while Collection(ListObjectsthenInclude.items[j]).Count > 1 do
                      Collection(ListObjectsthenInclude.items[j]).Delete( Collection(ListObjectsthenInclude.items[j]).Count - 1 );

                   for k := 0 to List.Count-1 do
                   begin
                      Collection(ListObjectsthenInclude.items[j]).Add( List[k]);
                   end;
                end
                else
                begin
                  TableForeignKey := Copy(CurrentEntidy.ClassName,2,length(CurrentEntidy.ClassName) );
                  QueryAble:= From( CurrentEntidy.ClassType).
                                          Where( 'Id='+  TAutoMapper.GetValueProperty( ReferenceEntidy, TableForeignKey+'Id') ).
                                          Select;
                   EntidyInclude := FindEntity( QueryAble );
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
              FreeDbSet;
            end;
          end;
        end;
      end;

      if i > maxInclude then
         break;
    end;

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

function TDbSet<T>.Include( E: TObject ):TDbSet<T>;
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

function TDbSet<T>.ThenInclude( E: TObject ):TDbSet<T>;
begin
   ListObjectsThenInclude.Add( E );
   ListObjectsInclude.Add( nil );
   result:= self;
end;



end.
