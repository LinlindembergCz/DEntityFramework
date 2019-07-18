{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Drivers.DBExpress;

interface

uses
  Forms,DBClient, classes, Data.DB, SysUtils, EF.Drivers.Connection, Data.FMTBcd, Data.SqlExpr ;

type


  TEntitySQLConnection = class(TEntityConn)
  private
    procedure BeforeConnect(Sender: TObject);
  public
    procedure GetTableNames(var List: TStringList); override;
    procedure GetFieldNames(var List: TStringList; Table: string); override;
    procedure ExecutarSQL(prsSQL: string); override;
    function CreateDataSet(prsSQL: string; Keys:TStringList = nil): TDataSet; override;
    procedure LoadFromFile(IniFileName: string);override;
    constructor Create(aDriver: FDConn; aUser,aPassword,aServer,aDataBase: string);overload;override;
    constructor Create(aDriver: FDConn; Conn : TSQLConnection);overload;override;
  end;



implementation

uses
 EF.Core.Functions,
 EF.Schema.MSSQL,
 EF.Schema.Firebird,
 EF.Schema.MySQL,
 EF.Schema.PostGres;

resourcestring
  StrMyQL = 'MySQL';
  StrMSSQL = 'MSSQL';
  StrFirebird = 'Firebird';
  StrFB = 'FB';
  StrPG = 'PG';

{ TLinqFDConnection }

function TEntitySQLConnection.CreateDataSet(prsSQL: string; Keys:TStringList = nil ): TDataSet;
var
  qryVariavel: TSQLQuery;
  J : integer;
begin
  qryVariavel := TSQLQuery.Create(Application);

  with TSQLQuery(qryVariavel) do
  begin

    SQLConnection := CustomConnection as TSQLConnection;
    SQL.Text := prsSQL;
    Prepared := true;
    open;

    //UpdateOptions.AutoIncFields:= 'ID';
    Fieldbyname('ID').ProviderFlags :=[pfInWhere, pfInKey];
    Fieldbyname('ID').Required := false;
    //UpdateOptions.UpdateMode := upWhereKeyOnly;

    for J := 0 to Fields.Count-1 do
    begin
      if UpperCase( Fields[J].FieldName) <> 'ID' then
      begin
        Fields[J].ProviderFlags:=[pfInUpdate];
      end;
    end;
  end;
  result := qryVariavel as TDataSet;
end;

procedure TEntitySQLConnection.ExecutarSQL(prsSQL: string);
begin
  TSQLConnection(CustomConnection).ExecuteDirect(prsSQL);
end;

procedure TEntitySQLConnection.GetFieldNames(var List: TStringList; Table: string);
var
  I:integer;
begin
  TSQLConnection(CustomConnection).GetFieldNames(Table,List);
  for I := 0 to List.Count - 1 do
  begin
    List[i]:= fStringReplace( List[i] ,'"','');
  end;
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

constructor TEntitySQLConnection.Create(aDriver: FDConn; aUser,aPassword,aServer,aDataBase: string);
begin
  inherited;
  CustomConnection := TSQLConnection.Create(application);
  CustomConnection.LoginPrompt:= false;
  CustomConnection.BeforeConnect:= BeforeConnect;


  FServer   := aServer;
  FDataBase := aDataBase;
  FUser     := aUser;
  FPassword := aPassword;

  case aDriver of
     fdMyQL:
     begin
        CustomTypeDataBase := TMySQL.create;
        FDriver   := StrMyQL;
     end;
     fdMSSQL:
     begin
        CustomTypeDataBase := TMSSQL.create;
        FDriver   := StrMSSQL;
     end;
     fdFirebird:
     begin
        CustomTypeDataBase := TFirebird.create;
        FDriver   := StrFirebird;
     end;
     fdFB:
     begin
        CustomTypeDataBase := TFirebird.create;
        FDriver   := StrFB;
     end;
     fdPG:
     begin
        CustomTypeDataBase := TPostgres.create;
        FDriver   := StrPG;
     end;
  end;
end;

constructor TEntitySQLConnection.Create(aDriver: FDConn; Conn: TSQLConnection);
begin
  CustomConnection:= Conn;
  CustomConnection.LoginPrompt:= false;
  case aDriver of
     fdMyQL:
     begin
        CustomTypeDataBase := TMySQL.create;
        FDriver   := StrMyQL;
     end;
     fdMSSQL:
     begin
        CustomTypeDataBase := TMSSQL.create;
        FDriver   := StrMSSQL;
     end;
     fdFirebird:
     begin
        CustomTypeDataBase := TFirebird.create;
        FDriver   := StrFirebird;
     end;
     fdFB:
     begin
        CustomTypeDataBase := TFirebird.create;
        FDriver   := StrFB;
     end;
     fdPG:
     begin
        CustomTypeDataBase := TPostgres.create;
        FDriver   := StrPG;
     end;
  end;

end;

procedure TEntitySQLConnection.BeforeConnect(Sender: TObject);
begin
  with TSQLConnection(CustomConnection) do
  begin
    DriverName                  := FDriver;
    Params.Values['DriverID']   := FDriver;
    Params.Values['Server']     := FServer;
    Params.Values['DataBase']   := FDataBase;
    Params.Values['User_Name']  := FUser;
    Params.Values['Password']   := FPassword;
   //if Params.Find('yes',I) then
    //Params.Values['OSAuthent']  := 'yes';
  end;
end;

end.
