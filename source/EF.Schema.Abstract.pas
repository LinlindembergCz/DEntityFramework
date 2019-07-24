{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Schema.Abstract;

interface

uses
Classes, EF.Mapping.Atributes;

type
  TCustomDataBase= class
  public
     function AlterColumn(Table, Field, Tipo: string; IsNull: boolean): string ;virtual; abstract;
     function CreateTable( List: TList; Table: string; Key:TStringList = nil ): string ;virtual; abstract;
     function AlterTable(Table, Field, Tipo: string; IsNull: boolean;ColumnExist:boolean): string ;virtual; abstract;
     function CreateForeignKey(AtributoForeignKey: PParamForeignKeys; Table: string): string;virtual; abstract;
     function CreateIndex(Table, IndexName, Field: string): string;virtual; abstract;
  end;

implementation

end.
