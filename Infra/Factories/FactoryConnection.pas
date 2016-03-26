unit FactoryConnection;

interface

uses
  Forms, Data.DB,Data.SqlExpr,FireDAC.Comp.Client,EntityFirebird, EntityMSSQL,
  Sysutils, EnumEntity,  System.Classes, EntityConnection, EntityFDConnection;

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
                                                 'D:\Lindemberg\EntityFramework\DBLINQ.FDB');
  end;
  result:= FConnection;
end;

end.
