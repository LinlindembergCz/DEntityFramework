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
    FTableList: TStringList;
    FClasses: array of TClass;
    function AlterTables: boolean;
    function CreateSingleTable(i: integer): boolean;
    function CreateTables: boolean;
    function IsFireBird: boolean;

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
    destructor Destroy;virtual;
    procedure GetTableNames(var List: TStringList); virtual; abstract;
    procedure GetFieldNames(var List: TStringList; Table: string); virtual;abstract;
    procedure ExecutarSQL(prsSQL: string); virtual; abstract;
    procedure AlterTable(Table, Field, Tipo: string; IsNull: boolean);virtual;abstract;
    procedure AlterColumn(Table, Field, Tipo: string; IsNull: boolean);virtual;abstract;
    function CreateDataSet(prsSQL: string; Keys:TStringList = nil): TFDQuery; virtual; abstract;
    procedure LoadFromFile(IniFileName: string);virtual; abstract;
    function UpdateDataBase(aClasses: array of TClass): boolean;
    property CustomConnection: TCustomConnection read FCustomConnection write FCustomConnection;
    property CustomTypeDataBase: TCustomDataBase read FCustomTypeDataBase write FCustomTypeDataBase;
    property Driver: string read FDriver write FDriver;
    property DataBase: string read FDataBase write FDataBase;
    property Server : string read FServer write FServer;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
  end;

implementation

uses
  EF.Mapping.AutoMapper,EF.Mapping.Atributes, EF.Schema.Firebird;

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

function TEntityConn.IsFireBird:boolean;
begin
  result:= (Driver = 'Firebird') or (Driver = 'FB');
end;

function TEntityConn.UpdateDataBase(aClasses: array of TClass): boolean;
var
  i: integer;
  Created, Altered: boolean;
begin
  Created := false;
  Altered := false;

  FTableList := TStringList.Create(true);
  GetTableNames(FTableList);
  SetLength(FClasses, length(aClasses));
  for i := 0 to length(aClasses) - 1 do
  begin
    FClasses[i] := aClasses[i];
  end;
  if length(aClasses) > 0 then
  begin
    Created := CreateTables;
    // Altered := AlterTables;
  end;

  result := Created;
end;

function TEntityConn.CreateTables: boolean;
var
  i: integer;
  Created: boolean;
begin
  Created := false;
  result := false;
  for i := 0 to length(FClasses) - 1 do
  begin
    Created := CreateSingleTable(i);
    if Created then
      result := Created;
  end;
end;

destructor TEntityConn.Destroy;
begin
  if FTableList <> nil then
     FTableList.Free;
end;

function TEntityConn.CreateSingleTable(i: integer): boolean;
var
  Table: string;
  ListAtributes: TList;
  ListForeignKeys: TList;
  KeyList: TStringList;
  classe: TClass;
  index:integer;

begin
  classe := FClasses[i];
  Table := TAutoMapper.GetTableAttribute(classe);
  if Pos(uppercase(Table), uppercase(FTableList.Text)) = 0 then
  begin
    try
      ListAtributes := nil;
      ListAtributes := TAutoMapper.GetListAtributes(classe);
      KeyList := TStringList.Create(true);
      ExecutarSQL(CustomTypeDataBase.CreateTable(ListAtributes, Table, KeyList));

      ListForeignKeys:= TAutoMapper.GetListAtributesForeignKeys(classe);

      if CustomTypeDataBase is TFirebird then
      begin
        with FCustomTypeDataBase as TFirebird do
        begin
          ExecutarSQL( CreateGenarator(Table, trim(KeyList.Text)) );
          ExecutarSQL( SetGenarator(Table, trim(KeyList.Text)) );
          ExecutarSQL( CrateTriggerGenarator(Table,trim(KeyList.Text)) );
        end;
      end;

      for index := 0 to ListForeignKeys.Count -1  do
      begin
        ExecutarSQL( CustomTypeDataBase.CreateForeignKey( ListForeignKeys[index], Table ) );
      end;

      result := true;
    finally
      KeyList.Free;
    end;
  end;
end;

function TEntityConn.AlterTables: boolean;
var
  i, K, j: integer;
  Table: string;
  List: TList;
  FieldList: TStringList;
  ColumnExist: boolean;
  Created: boolean;
begin
  try
    Created := false;
    FieldList := TStringList.Create(true);
    for i := 0 to length(FClasses) - 1 do
    begin
      Table := TAutoMapper.GetTableAttribute(FClasses[i]);
      if FTableList.IndexOf(Table) <> -1 then
      begin
        GetFieldNames(FieldList, Table);
        List := TAutoMapper.GetListAtributes(FClasses[i]);
        for K := 0 to List.Count - 1 do
        begin
          if PParamAtributies(List.Items[K]).Tipo <> '' then
          begin
            ColumnExist := FieldList.IndexOf(PParamAtributies(List.Items[K])
                .Name) <> -1;
            if not ColumnExist then
            begin
              ExecutarSQL( CustomTypeDataBase.AlterTable
                  (Table, PParamAtributies(List.Items[K]).Name,
                  PParamAtributies(List.Items[K]).Tipo,
                  PParamAtributies(List.Items[K]).IsNull, ColumnExist));
              Created := true;
            end;
          end;
        end;
      end;
    end;
  finally
    result := Created;
    FieldList.Free;
  end;
end;

end.
