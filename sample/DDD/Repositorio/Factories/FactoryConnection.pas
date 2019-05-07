unit FactoryConnection;

interface

uses
  Forms, Data.DB,Data.SqlExpr,FireDAC.Comp.Client, EF.Schema.Firebird, EF.Schema.MSSQL,
  Sysutils, FactoryEntity,  System.Classes, EF.Drivers.Connection, EF.Drivers.FireDac;

type
  TFactoryConnection = class
  private
  public
    class function GetConnection: TEntityConn;
  end;

implementation

{ TFactoryEntity }


class function TFactoryConnection.GetConnection: TEntityConn;
begin
   result:= TEntityFDConnection.Create(fdFB ,
                                       'SYSDBA',
                                       'masterkey',
                                       'LocalHost',
                                       extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');
end;

end.
