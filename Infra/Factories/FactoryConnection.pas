unit FactoryConnection;

interface

uses
  Forms, Data.DB,Data.SqlExpr,FireDAC.Comp.Client, EF.Schema.Firebird, EF.Schema.MSSQL,
  Sysutils, FactoryEntity,  System.Classes, EF.Drivers.Connection, EF.Drivers.FireDac;

type
  TFactoryConnection = class
  private
    class var FConnection: TEntityConn;
  public
    class function GetConnection: TEntityConn;
  end;

implementation

{ TFactoryEntity }


class function TFactoryConnection.GetConnection: TEntityConn;
begin
  If FConnection = nil Then
  begin
    { FConnection := TEntitySQLConnection.Create('FB',
                                                 'SYSDBA',
                                                 'masterkey',
                                                 'LocalHost',
                                                 'D:\Lindemberg\Linq\DDD\DBLINQ.FDB'); }
      FConnection := TEntityFDConnection.Create('FB',
                                                 'SYSDBA',
                                                 'masterkey',
                                                 'LocalHost',
                                                 extractfilepath(application.ExeName)+'DBLINQ.FDB');
  end;
  result:= FConnection;
end;

end.
