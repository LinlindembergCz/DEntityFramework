unit EF.Engine.DbContext;

interface

uses
  System.Classes, Data.DB, EF.Drivers.Connection,FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,  FireDAC.Comp.Client,
  FireDAC.Phys.SQLiteVDataSet, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Comp.DataSet;

type
   TLocalSQL = class(TFDLocalSQL)
   private
      FLocalConnection: TFDConnection;
      FLocalDataSet: TFDQuery;
   public
      constructor Create(AOwner: TComponent);override;
      destructor Destroy;override;
      function OpenSQL(SQL: string): IFDDataSetReference;
      procedure Add( DataSet: TFDQuery; Name: string );
   end;

   TDbContext =class( TPersistent )
   private
     Script: TFDScript;
     SQL: TFDSQLScript;
     FLocalSQL: TLocalSQL;
   public
     constructor Create(aDatabase: TDatabaseFacade = nil);virtual;
     destructor Destroy; virtual;
     procedure AddScript(aSQL: string);
     procedure ExecuteScript;
     property LocalSQL: TLocalSQL read FLocalSQL;
   end;

implementation

{ TDbContext }

procedure TDbContext.AddScript(aSQL: string);
begin
  SQL.SQL.Add(aSQL+';');
end;

constructor TDbContext.Create(aDatabase: TDatabaseFacade);
begin
  Script:= TFDScript.Create(nil);
  Script.Connection := aDatabase.CustomConnection as TFDConnection;;
  SQL := Script.SQLScripts.Add();
  FLocalSQL:= TLocalSQL.Create(nil);
end;

destructor TDbContext.Destroy;
begin
  inherited;
  Script.Free;
  FLocalSQL.Free;
//SQL.Free;
end;

procedure TDbContext.ExecuteScript;
begin
   Script.ValidateAll();
   Script.ExecuteAll();
   Script.SQLScripts.Clear;
end;

procedure TLocalSQL.Add(DataSet: TFDQuery;Name: string );
begin
   DataSets.Add( DataSet,'', Name )
end;

constructor TLocalSQL.Create(AOwner: TComponent);
begin
   inherited;
   FLocalConnection := TFDConnection.Create(AOwner);
   FLocalConnection.DriverName:= 'SQLite';
   FLocalConnection.Connected := true;

   Connection:= FLocalConnection;

   FLocalDataSet := TFDQuery.Create(AOwner);
   FLocalDataSet.Connection:=FLocalConnection;
   FLocalDataSet.LocalSQL:= Self;

end;

destructor TLocalSQL.Destroy;
begin
   inherited;
   FLocalConnection.Free;
   FLocalDataSet.Free;
end;

function  TLocalSQL.OpenSQL(SQL: string):IFDDataSetReference;
begin
   DataSets.Add( FLocalDataSet );
   DataSets[0].Temporary := true;

   FLocalDataSet.SQL.Text:= SQL;
   Active:= true;
   FLocalDataSet.open;

   result:= FLocalDataSet.Data;
end;

end.
