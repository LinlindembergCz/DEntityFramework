unit EntityMSSQL;

interface

uses
  Atributies, AutoMapper, sysutils, classes, strUtils, EntityConnection, Dialogs;

type
  TMSSQL = class
  public
    class procedure CreateTable(Connection: TEntityConn; List: TList; Table: string);
    class function GetPrimaryKey( Table, Fields: string):string;
  end;

implementation

{ TMSSQLServer }

class procedure TMSSQL.CreateTable(Connection: TEntityConn; List: TList; Table: string);
var
  J: integer;

  TableList: TStringList;
  FieldAutoInc: string;

  Name, Tipo: string;
  AutoInc, PrimaryKey, IsNull: boolean;
  CreateScript , Key :TStringList;

begin
  CreateScript := TStringList.Create;
  Key          := TStringList.Create;
  Key.delimiter := ',';

  CreateScript.Clear;
  CreateScript.Add('Create Table ' + uppercase(Table));
  CreateScript.Add('(');
  FieldAutoInc := '';
  try
      for J := 0 to List.Count - 1 do
      begin
        Name := PParamAtributies(List.Items[J]).Name;
        Tipo := PParamAtributies(List.Items[J]).Tipo;
        if Tipo ='' then
          break;
        AutoInc := PParamAtributies(List.Items[J]).AutoInc;
        PrimaryKey := PParamAtributies(List.Items[J]).PrimaryKey;
        IsNull := PParamAtributies(List.Items[J]).IsNull;

        CreateScript.Add(Name + ' ' + Tipo + ' ' + ifthen(AutoInc, ' IDENTITY(1,1) ', '') +
         ifthen(IsNull, '', 'NOT NULL') + ifthen(J < List.Count - 1, ',', ''));

        if PrimaryKey then
          Key.Add(Name);
      end;
      if Key.Count > 0 then
      begin
        CreateScript.Add( GetPrimaryKey(Table,Key.DelimitedText) );
        Connection.ExecutarSQL(CreateScript.Text);
      end
      else
        ShowMessage('Primary Key is riquered!');
  finally
     CreateScript.Free;
     Key.Free;
  end;
end;

class function TMSSQL.GetPrimaryKey(Table, Fields: string): string;
begin
  result:= ', CONSTRAINT [PK_' + Table +
            '] PRIMARY KEY CLUSTERED([' + Fields +
            '] ASC) ON [PRIMARY])';
end;

end.
