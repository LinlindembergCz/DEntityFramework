unit EntityFDConnection;

interface

uses
  Forms,EntityConnection,FireDAC.Phys.FBDef, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  DBClient, classes, Data.DB, SysUtils;

type
  TEntityFDConnection = class(TEntityConn)
  private
    procedure BeforeConnect(Sender: TObject);
  public
    procedure GetTableNames(var List: TStringList); override;
    procedure GetFieldNames(var List: TStringList; Table: string); override;
    procedure ExecutarSQL(prsSQL: string); override;
    function CreateDataSet(prsSQL: string; Keys:TStringList = nil): TDataSet; override;
    procedure LoadFromFile(IniFileName: string);override;
    constructor Create(aDriver,aUser,aPassword,aServer,aDataBase: string);override;
  end;

implementation

uses EntityFunctions;

{ TLinqFDConnection }

function TEntityFDConnection.CreateDataSet(prsSQL: string; Keys:TStringList = nil ): TDataSet;
var
  qryVariavel: TFDQuery;
  J , I : integer;
begin
  qryVariavel := TFDQuery.Create(Application);
  with TFDQuery(qryVariavel) do
  begin
    Connection := CustomConnection as TFDConnection;
    SQL.Text := prsSQL;
    Prepared := true;
    open;

    UpdateOptions.AutoIncFields:= 'ID';
    Fieldbyname('ID').ProviderFlags :=[pfInWhere, pfInKey];
    Fieldbyname('ID').Required := false;
    UpdateOptions.UpdateMode := upWhereKeyOnly;

    for J := 0 to Fields.Count-1 do
    begin
      if UpperCase( Fields[J].FieldName) <> 'ID' then
      begin
        Fields[J].ProviderFlags:=[pfInUpdate];
      end;
    end;
    {
    if Keys <> nil then
    begin
      for I := 0 to Keys.Count-1 do
      begin
        if uppercase( Keys.Strings[i] ) <> 'ID' then
        begin
          Fieldbyname(Keys.Strings[i]).ProviderFlags :=[pfInWhere, pfInKey, pfInUpdate];
          Fieldbyname(Keys.Strings[i]).Required := false;
          Fieldbyname(Keys.Strings[i]).ReadOnly := false;
        end;
      end;
    end;
    }
  end;
  result := qryVariavel;
end;

procedure TEntityFDConnection.ExecutarSQL(prsSQL: string);
begin
  TFDConnection(CustomConnection).ExecSQL(prsSQL);
end;

procedure TEntityFDConnection.GetFieldNames(var List: TStringList; Table: string);
var
  I:integer;
begin
  TFDConnection(CustomConnection).GetFieldNames('','',Table,'',List);
  for I := 0 to List.Count - 1 do
  begin
    List[i]:= fStringReplace( List[i] ,'"','');
  end;
end;

procedure TEntityFDConnection.GetTableNames(var List: TStringList);
begin
  TFDConnection(CustomConnection).GetTableNames('','','',List);
end;

procedure TEntityFDConnection.LoadFromFile(IniFileName: string);
begin
  inherited;
  TFDConnection(CustomConnection).Params.LoadFromFile(IniFileName);
end;

constructor TEntityFDConnection.Create(aDriver,aUser,aPassword,aServer,aDataBase: string);
begin
  inherited;
  CustomConnection := TFDConnection.Create(application);
  CustomConnection.LoginPrompt:= false;
  CustomConnection.BeforeConnect:= BeforeConnect;
  FDriver   := aDriver;
  FServer   := aServer;
  FDataBase := aDataBase;
  FUser     := aUser;
  FPassword := aPassword;
end;

procedure TEntityFDConnection.BeforeConnect(Sender: TObject);
begin
  with TFDConnection(CustomConnection) do
  begin
    DriverName                  := FDriver;
    Params.Values['DriverID']   := FDriver;
    Params.Values['Server']     := FServer;
    Params.Values['DataBase']   := FDataBase;
    Params.Values['User_Name']  := FUser;
    Params.Values['Password']   := FPassword;
  end;
end;

end.
