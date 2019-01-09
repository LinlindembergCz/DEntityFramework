unit EF.Drivers.ADO;

interface

uses
EF.Drivers.Connection, Data.Win.ADODB,DBClient,  classes, Data.DB,Vcl.Forms, SysUtils;

type
  TEntityADOConnection = class(TEntityConn)
  private
    procedure BeforeConnect(Sender: TObject);
  public
    procedure GetTableNames(var List: TStringList); override;
    procedure GetFieldNames(var List: TStringList; Table: string); override;
    procedure ExecutarSQL(SQL: string); override;
    function CreateDataSet(SQL: string; Keys:TStringList = nil): TDataSet; override;
  end;

implementation

{ TLinqADOConnection }

function TEntityADOConnection.CreateDataSet(SQL: string; Keys:TStringList = nil): TDataSet;
var
  qryVariavel: TADOQuery;
begin
  qryVariavel := TADOQuery.Create(Application);
  TADOQuery(qryVariavel).Connection := CustomConnection as TADOConnection;
  TADOQuery(qryVariavel).SQL.Text := SQL;
  result := qryVariavel;
end;

procedure TEntityADOConnection.ExecutarSQL(SQL: string);
begin
  TADOConnection(CustomConnection).Execute(SQL);
end;

procedure TEntityADOConnection.GetFieldNames(var List: TStringList; Table: string);
begin
  TADOConnection(CustomConnection).GetFieldNames(uppercase(Table), List);
end;

procedure TEntityADOConnection.GetTableNames(var List: TStringList);
begin
  TADOConnection(CustomConnection).GetTableNames(List);
end;

procedure TEntityADOConnection.BeforeConnect(Sender: TObject);
begin
  with TADOConnection(CustomConnection) do
  begin
    TADOConnection(CustomConnection).ConnectionString := FDataBase;
    {DriverName                 := FDriver;
    Params.Values['DriverID']   := FDriver;
    Params.Values['Server']     := FServer;
    Params.Values['DataBase']   := FDataBase;
    Params.Values['User_Name']  := FUser;
    Params.Values['Password']   := FPassword;
    FetchOptions.Unidirectional := true; }
  end;
end;

end.
