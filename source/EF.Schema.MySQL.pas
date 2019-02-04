{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Schema.MySQL;

interface

uses
  SysUtils, classes, strUtils, Dialogs,
  EF.Mapping.Atributes,
  EF.Mapping.AutoMapper,
  EF.Drivers.Connection,
  EF.Schema.Abstract;

type
  TMySQL = class(TCustomDataBase)
  private
     function AlterColumn(Table, Field, Tipo: string; IsNull: boolean): string ;override;
  public
     function CreateTable( List: TList; Table: string;  Key:TStringList = nil): string ;override;
     function AlterTable( Table, Field, Tipo: string; IsNull: boolean;ColumnExist: boolean): string ;override;

     function GetPrimaryKey( Table, Fields: string):string;
  end;

implementation

{ TMySQL }

function TMySQL.AlterColumn(Table, Field, Tipo: string;
  IsNull: boolean): string;
begin
   result:= 'Alter table ' + quotedstr(Table) + ' Alter Column ' + quotedstr(Field) + ' ' +
                 Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL');
end;

function TMySQL.AlterTable(Table, Field, Tipo: string; IsNull: boolean;ColumnExist: boolean): string;
begin
  if ColumnExist then
    result:= AlterColumn( Table , Field, tipo , IsNull)
  else
    result:= 'Alter table ' + quotedstr(Table) + ' Add ' + quotedstr(Field) + ' ' +
            Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL')
end;

function TMySQL.CreateTable( List: TList; Table: string; Key:TStringList = nil ): string;
var
  J: integer;

  TableList: TStringList;
  FieldAutoInc: string;

  Name, Tipo: string;
  AutoInc, PrimaryKey, IsNull: boolean;
  CreateScript , ListKey :TStringList;

begin
  CreateScript := TStringList.Create;
  ListKey          := TStringList.Create;
  ListKey.delimiter := ',';

 { CREATE TABLE `db_leitura`.`minhatabela` (
  `idMinhaTabela` INT NOT NULL ,
  `minhatabelacol` VARCHAR(45) NULL,
  PRIMARY KEY (`idMinhaTabela`)); }

  CreateScript.Clear;
  CreateScript.Add('Create Table ' + quotedstr( uppercase(Table)) );
  CreateScript.Add('(');
  FieldAutoInc := '';
  try
      for J := 0 to List.Count - 1 do
      begin
        Name := quotedstr( PParamAtributies(List.Items[J]).Name );
        Tipo := PParamAtributies(List.Items[J]).Tipo;
        if Tipo ='' then
          break;
        AutoInc := PParamAtributies(List.Items[J]).AutoInc;
        PrimaryKey := PParamAtributies(List.Items[J]).PrimaryKey;
        IsNull := PParamAtributies(List.Items[J]).IsNull;

        CreateScript.Add(Name + ' ' + Tipo + ' ' + ifthen(AutoInc, ' AUTO_INCREMENT ', '') +
         ifthen(IsNull, '', 'NOT NULL') + ifthen(J < List.Count - 1, ',', ''));

        if PrimaryKey then
        begin
          ListKey.Add(Name);
          if Key <> nil then
             Key.Add(Name);
        end;
      end;
      if ListKey.Count > 0 then
      begin
        CreateScript.Add( GetPrimaryKey(Table,ListKey.DelimitedText) );
        result:= CreateScript.Text;
      end
      else
        ShowMessage('Primary Key is riquered!');
  finally
     CreateScript.Free;
     ListKey.Free;
     //Key.Free;
  end;
end;

function TMySQL.GetPrimaryKey(Table, Fields: string): string;
begin
  result:= ',  PRIMARY KEY ('+quotedstr(Fields)+') ';
end;

end.
