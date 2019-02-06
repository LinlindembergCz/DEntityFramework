{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Drivers.Connection;

interface

uses
  Data.SqlExpr , classes, Data.DB,Vcl.Forms, SysUtils, EF.Schema.Abstract,
  FireDAC.Comp.Client;

type
  TTypeConnection = (tpNone, tpADO, tpDBExpress, tpFireDac);
  FDConn = ( fdMyQL,fdMSSQL,fdFirebird, fdFB );
  TEntityConn = class
  private
    FCustomTypeDataBase: TCustomDataBase;
  protected
    FCustomConnection : TCustomConnection;
    FDataBase: string;
    FServer: string;
    FUser: string;
    FPassword: string;
    FDriver: string;
    procedure InsereFields(ADataSet: TFDQuery);
    procedure BeforeConnect(Sender: TObject);virtual;abstract;
  public
    constructor Create(aDriver:FDConn; aUser,aPassword,aServer,aDataBase: string);virtual; abstract;
    procedure GetTableNames(var List: TStringList); virtual; abstract;
    procedure GetFieldNames(var List: TStringList; Table: string); virtual;abstract;
    procedure ExecutarSQL(prsSQL: string); virtual; abstract;
    procedure AlterTable(Table, Field, Tipo: string; IsNull: boolean);virtual;abstract;
    procedure AlterColumn(Table, Field, Tipo: string; IsNull: boolean);virtual;abstract;
    function CreateDataSet(prsSQL: string; Keys:TStringList = nil): TFDQuery; virtual; abstract;
    procedure LoadFromFile(IniFileName: string);virtual; abstract;
    property CustomConnection: TCustomConnection read FCustomConnection write FCustomConnection;
    property CustomTypeDataBase: TCustomDataBase read FCustomTypeDataBase write FCustomTypeDataBase;
    property Driver: string read FDriver write FDriver;
    property DataBase: string read FDataBase write FDataBase;
    property Server : string read FServer write FServer;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
  end;

implementation

procedure TEntityConn.InsereFields(ADataSet: TFDQuery);
var
  i: integer;
  Field: TComponent;
  j:word;
begin
  For i := 0 to (ADataSet.Fields.Count - 1) do
  begin
    Case ADataSet.Fields[i].DataType of
      ftBoolean:
        begin
          Field := TBooleanField.Create(ADataSet);
          TBooleanField(Field).FieldName := ADataSet.Fields[i].FieldName;
          TBooleanField(Field).DisplayLabel := ADataSet.Fields[i]
            .DisplayLabel;
          TBooleanField(Field).Size := ADataSet.Fields[i].Size;
          TBooleanField(Field).DisplayWidth := ADataSet.Fields[i]
            .DisplayWidth;
          TBooleanField(Field).Required := ADataSet.Fields[i].Required;
          TBooleanField(Field).DataSet := ADataSet;
        end;
      ftString:
        begin
          Field := TStringField.Create(ADataSet);
          TStringField(Field).FieldName := ADataSet.Fields[i].FieldName;
          TStringField(Field).DisplayLabel := ADataSet.Fields[i].DisplayLabel;
          TStringField(Field).Size := ADataSet.Fields[i].Size;
          TStringField(Field).DisplayWidth := ADataSet.Fields[i].DisplayWidth;
          TStringField(Field).Required := ADataSet.Fields[i].Required;
          TStringField(Field).DataSet := ADataSet;
        end;
      ftInteger:
        begin
          Field := TIntegerField.Create(ADataSet);
          TIntegerField(Field).FieldName := ADataSet.Fields[i].FieldName;
          TIntegerField(Field).DisplayLabel := ADataSet.Fields[i]
            .DisplayLabel;
          TIntegerField(Field).Size := ADataSet.Fields[i].Size;
          TIntegerField(Field).DisplayWidth := ADataSet.Fields[i]
            .DisplayWidth;
          TIntegerField(Field).Required := ADataSet.Fields[i].Required;
          TIntegerField(Field).DataSet := ADataSet;
        end;
      ftFloat:
        begin
          Field := TFloatField.Create(ADataSet);
          TFloatField(Field).FieldName := ADataSet.Fields[i].FieldName;
          TFloatField(Field).DisplayLabel := ADataSet.Fields[i].DisplayLabel;
          TFloatField(Field).Size := ADataSet.Fields[i].Size;
          TFloatField(Field).DisplayWidth := ADataSet.Fields[i].DisplayWidth;
          TFloatField(Field).Required := ADataSet.Fields[i].Required;
          TFloatField(Field).DataSet := ADataSet;
        end;
      ftDateTime:
        begin
          Field := TDateTimeField.Create(ADataSet);
          TDateTimeField(Field).FieldName := ADataSet.Fields[i].FieldName;
          TDateTimeField(Field).DisplayLabel := ADataSet.Fields[i]
            .DisplayLabel;
          TDateTimeField(Field).Size := ADataSet.Fields[i].Size;
          TDateTimeField(Field).DisplayWidth := ADataSet.Fields[i]
            .DisplayWidth;
          TDateTimeField(Field).Required := ADataSet.Fields[i].Required;
          TDateTimeField(Field).DataSet := ADataSet;
        end;
    end;
    Field.Name := ADataSet.Name + ADataSet.Fields[i].FieldName;
  end;
end;

end.
