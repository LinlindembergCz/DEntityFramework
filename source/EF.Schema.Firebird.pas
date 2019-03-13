{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Schema.Firebird;

interface

uses
  SysUtils, classes, strUtils, Dialogs,
  EF.Mapping.Atributes,
  EF.Mapping.AutoMapper,
  EF.Drivers.Connection,
  EF.Schema.Abstract;

type
  TFirebird = class(TCustomDataBase)
  private
    function AlterColumn(Table, Field, Tipo: string; IsNull: boolean): string ;override;
  public
    function CreateTable( List: TList; Table: string; Key:TStringList = nil): string ;override;
    function AlterTable(Table, Field, Tipo: string; IsNull: boolean;ColumnExist: boolean): string;override;
    function CreateGenarator(Table,FieldAutoInc:string):string;
    function SetGenarator(Table,FieldAutoInc:string): string;
    function CrateTriggerGenarator(Table,FieldAutoInc:string): string;
    function CreateForenKey(AtributoForeignKey: PParamForeignKeys; Table: string ): string;
  end;

implementation

{ TFirebird }

function TFirebird.CreateForenKey(AtributoForeignKey: PParamForeignKeys; Table: string ): string;
begin
   result:= 'ALTER TABLE '+Table +
            ' ADD CONSTRAINT FK_'+AtributoForeignKey.ForeignKey+
            ' FOREIGN KEY ('+AtributoForeignKey.ForeignKey+')'+
            ' REFERENCES '+AtributoForeignKey.Name+'(ID) '+
            ' ON DELETE '+ ifthen( AtributoForeignKey.OnDelete = rlCascade, ' CASCADE ',
                           ifthen( AtributoForeignKey.OnDelete = rlSetNull, ' SET NULL ',
                                                                          ' NO ACTION' ))+
            ' ON Update '+ ifthen( AtributoForeignKey.OnUpdate = rlCascade, ' CASCADE ',
                           ifthen( AtributoForeignKey.OnUpdate = rlSetNull, ' SET NULL ',
                                                                          ' NO ACTION' ));
end;

function TFirebird.CreateGenarator(Table, FieldAutoInc: string): string;
begin
   result:= ' CREATE GENERATOR "' + Table + '_' + FieldAutoInc + '_GEN1"'
end;

function TFirebird.SetGenarator(Table, FieldAutoInc: string): string;
begin
   result:= ' SET GENERATOR  "' + Table + '_' + FieldAutoInc + '_GEN1" TO 1 ';
end;

function TFirebird.AlterColumn(Table, Field, Tipo: string;
  IsNull: boolean): string;
begin
   result:= 'Alter table ' + Table + ' Alter Column ' + Field + ' type ' + Tipo;
end;

function TFirebird.AlterTable(Table, Field, Tipo: string; IsNull: boolean; ColumnExist: boolean ): string;
begin
  if  ColumnExist then
   result := AlterColumn(Table, Field, Tipo, IsNull)
  else
  result:= 'Alter table ' + Table + ' Add ' + Field + ' ' +
            Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL')
end;

function TFirebird.CrateTriggerGenarator(Table,
  FieldAutoInc: string): string;
begin
   result:= ' CREATE TRIGGER "BI_' + Table + '_' +
              FieldAutoInc + '" FOR ' + Table +
              ' ACTIVE BEFORE INSERT POSITION 1' + ' AS' + ' BEGIN ' +
              '   IF (NEW."' + FieldAutoInc + '" IS NULL) THEN ' + '      NEW."'
              + FieldAutoInc + '"  = GEN_ID("' + Table + '_' + FieldAutoInc +
              '_GEN1", 1); ' + ' END';
end;

function TFirebird.CreateTable( List: TList; Table: string; Key:TStringList = nil ): string;
var
  J: integer;
  TableList: TStringList;
  FieldAutoInc: string;
  Name, Tipo: string;
  AutoInc, PrimaryKey, IsNull: boolean;
  CreateScript :TStringList;
begin
    CreateScript := TStringList.Create;
    if Key = nil then
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
          result := CreateScript.Text;
        end
        else
          ShowMessage('Primary Key is riquered!');
    finally
        CreateScript.Free;
    end;
end;

end.

