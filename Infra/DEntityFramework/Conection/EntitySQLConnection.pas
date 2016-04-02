unit EntitySQLConnection;

interface

uses
  EntityConnection, Data.SqlExpr , classes, Data.DB,Vcl.Forms, SysUtils,
  Data.DBXFirebird,  Data.FMTBcd, Data.DBXMSSQL;

type
 TEntitySQLConnection = class(TEntityConn)
  public
    procedure BeforeConnect(Sender: TObject);override;
    procedure GetTableNames(var List: TStringList); override;
    procedure GetFieldNames(var List: TStringList; Table: string); override;
    procedure ExecutarSQL(prsSQL: string); override;
    function CreateDataSet(prsSQL: string; Keys:TStringList = nil): TDataSet; override;
    procedure LoadFromFile(IniFileName: string);override;
    constructor Create(aDriver,aUser,aPassword,aServer,aDataBase: string);override;
  end;

implementation

uses
 EntityMSSQL, EntityFirebird;

{ TEntitySQLConnection }

constructor TEntitySQLConnection.Create(aDriver,aUser,aPassword,aServer,aDataBase: string);
begin
  inherited;
  CustomConnection := TSQLConnection.Create(application);
  CustomConnection.LoginPrompt:= false;
  CustomConnection.BeforeConnect:= BeforeConnect;
  FDriver   := aDriver;
  FServer   := aServer;
  FDataBase := aDataBase;
  FUser     := aUser;
  FPassword := aPassword;
  if FDriver = 'MSSSQL' then
     CustomTypeDataBase:= TMSSQL.create;
  if (FDriver = 'Firebird') or (FDriver = 'FB') then
     CustomTypeDataBase:= TFirebird.create;
end;

function TEntitySQLConnection.CreateDataSet(prsSQL: string; Keys:TStringList = nil): TDataSet;
var
  qryVariavel: TSQLQuery;
  J : integer;
begin
  qryVariavel := TSQLQuery.Create(Application);
  with TSQLQuery(qryVariavel) do
  begin
    SQLConnection := CustomConnection as TSQLConnection;
    TSQLQuery(qryVariavel).SQL.Text := prsSQL;
    Prepared := true;
    open;

    Fieldbyname('Id').ProviderFlags :=[pfInWhere, pfInKey];
    Fieldbyname('Id').Required := false;

    for J := 0 to Fields.Count-1 do
    begin
      if UpperCase( Fields[J].FieldName) <> 'ID' then
      begin
        Fields[J].Required := false;
        Fields[J].ProviderFlags:=[pfInUpdate];
      end;
    end;
  end;
  result := qryVariavel;
end;

procedure TEntitySQLConnection.ExecutarSQL(prsSQL: string);
begin
  TSQLConnection(CustomConnection).ExecuteDirect(prsSQL);
end;

procedure TEntitySQLConnection.GetFieldNames(var List: TStringList; Table: string);
begin
  TSQLConnection(CustomConnection).GetFieldNames(uppercase(Table), List);
end;

procedure TEntitySQLConnection.GetTableNames(var List: TStringList);
begin
  TSQLConnection(CustomConnection).GetTableNames(List);
end;

procedure TEntitySQLConnection.LoadFromFile(IniFileName: string);
begin
  inherited;
  TSQLConnection(CustomConnection).Params.LoadFromFile(IniFileName);
end;

procedure TEntitySQLConnection.BeforeConnect(Sender: TObject);
begin
  with TSQLConnection(CustomConnection) do
  begin
    DriverName   := FDriver;
    Params.Values['Server']:= FServer;
    Params.Values['DataBase']:= FDataBase;
    Params.Values['User']:= FUser;
    Params.Values['Password']:= FPassword;
  end;
end;

end.
