unit EF.Engine.DbContext;

interface

uses
EF.Drivers.Connection, FireDAC.UI.Intf, FireDAC.Stan.Async,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Stan.Intf,
  FireDAC.Comp.Script, System.Classes;

type
   TDbContext =class( TPersistent )
   private
     Script: TFDScript;
     SQL: TFDSQLScript;
   public
     constructor Create(aDatabase: TDatabaseFacade = nil);virtual;
     destructor Destroy; virtual;
     procedure AddScript(aSQL: string);
     procedure ExecuteScript;
   end;

implementation

uses
  FireDAC.Comp.Client;

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
end;

destructor TDbContext.Destroy;
begin
  inherited;
  Script.Free;
//SQL.Free;
end;

procedure TDbContext.ExecuteScript;
begin
  Script.ValidateAll();
  Script.ExecuteAll();
  Script.SQLScripts.Clear;
end;

end.
