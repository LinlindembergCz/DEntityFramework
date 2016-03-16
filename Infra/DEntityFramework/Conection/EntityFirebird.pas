unit EntityFirebird;

interface

uses Atributies, AutoMapper, sysutils, classes, strutils, EntityConnection, Dialogs;

type
  TFirebird = class
  public
    class procedure CreateTable(Connection: TEntityConn; List: TList; Table: string);
    class function CreateGenarator(Table,FieldAutoInc:string):string;
    class function SetGenarator(Table,FieldAutoInc:string): string;
    class function CrateTriggerGenarator(Table,FieldAutoInc:string): string;
  end;

implementation

{ TFirebird }

class function TFirebird.CreateGenarator(Table, FieldAutoInc: string): string;
begin
   result:= ' CREATE GENERATOR "' + Table + '_' + FieldAutoInc + '_GEN1"'
end;

class function TFirebird.SetGenarator(Table, FieldAutoInc: string): string;
begin
   result:= ' SET GENERATOR  "' + Table + '_' + FieldAutoInc + '_GEN1" TO 1 ';
end;

class function TFirebird.CrateTriggerGenarator(Table,
  FieldAutoInc: string): string;
begin
   result:= ' CREATE TRIGGER "BI_' + Table + '_' +
              FieldAutoInc + '" FOR ' + Table +
              ' ACTIVE BEFORE INSERT POSITION 1' + ' AS' + ' BEGIN ' +
              '   IF (NEW."' + FieldAutoInc + '" IS NULL) THEN ' + '      NEW."'
              + FieldAutoInc + '"  = GEN_ID("' + Table + '_' + FieldAutoInc +
              '_GEN1", 1); ' + ' END';
end;

class procedure TFirebird.CreateTable(Connection: TEntityConn; List: TList; Table: string);
var
  J: integer;
  TableList: TStringList;
  FieldAutoInc: string;
  Name, Tipo: string;
  AutoInc, PrimaryKey, IsNull: boolean;
  CreateScript , Key :TStringList;
begin
    CreateScript := TStringList.Create;
    Key := TStringList.Create;
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

          CreateScript.Add(Name + ' ' + Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL') +
            ifthen(PrimaryKey , ' Primary key', '') +
            ifthen(J < List.Count - 1, ',', ''));

          if (AutoInc) and (FieldAutoInc = '') then
             FieldAutoInc := uppercase(Name);
          if PrimaryKey then
            Key.Add(upperCase( trim( Name)));
        end;
        CreateScript.Add(');');
        if trim(Key.text) <> '' then
        begin
          Connection.ExecutarSQL(CreateScript.Text);
          Connection.ExecutarSQL( TFirebird.CreateGenarator(Table , trim(Key.text)) );
          Connection.ExecutarSQL( TFirebird.SetGenarator(Table , trim(Key.text)) );
          Connection.ExecutarSQL( TFirebird.CrateTriggerGenarator(Table , trim(Key.text)) );
        end
        else
          ShowMessage('Primary Key is riquered!');
    finally
        CreateScript.Free;
        Key.Free;
    end;

end;

end.

