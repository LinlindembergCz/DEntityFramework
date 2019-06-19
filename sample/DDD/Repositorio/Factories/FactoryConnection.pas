unit FactoryConnection;

interface

uses
  Forms, Data.DB,Data.SqlExpr,FireDAC.Comp.Client, EF.Schema.Firebird, EF.Schema.MSSQL,
  Sysutils, FactoryEntity,  System.Classes, EF.Drivers.Connection, EF.Drivers.FireDac;

type
  TFactoryConnection = class
  private
  public
    class function GetConnection( Conn : TFDConnection = nil ): TEntityConn;
  end;

implementation

{ TFactoryEntity }


class function TFactoryConnection.GetConnection( Conn : TFDConnection = nil ): TEntityConn;
begin
   result:= TEntityFDConnection.Create( fdPG , Conn );
            {
            TEntityFDConnection.Create(fdFB ,
                                     'SYSDBA',
                                     'masterkey',
                                     'LocalHost',
                                     extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');
           }
           {
           TEntityFDConnection.Create(fdPG ,
                                     'postgres',
                                     'master982666',
                                     '35.198.39.52',
                                     'postgres');
           }

end;

end.
