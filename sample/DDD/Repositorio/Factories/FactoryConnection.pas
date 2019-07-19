unit FactoryConnection;

interface

uses
  Forms, Data.DB,Data.SqlExpr,FireDAC.Comp.Client, EF.Schema.Firebird, EF.Schema.MSSQL,
  Sysutils, FactoryEntity,  System.Classes, EF.Drivers.Connection, EF.Drivers.FireDac;

type
  TFactoryConnection = class
  private
  public
    class function GetConnection( Conn : TFDConnection = nil ): TDataBaseFacade;
  end;

implementation

{ TFactoryEntity }


class function TFactoryConnection.GetConnection( Conn : TFDConnection = nil ): TDataBaseFacade;
begin
  //if Conn <> nil then
   //   result:= TEntityFDConnection.Create( fdPG , Conn )
   //else
   result := TEntityFDConnection.Create(fdFB ,
                             'SYSDBA',
                             'masterkey',
                             'LocalHost',
                             extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');

  {
    TEntityFDConnection.Create(fdPG ,
                                     'postgres',
                                     '',
                                     '35.198.39.52',
                                     'postgres');


   }




end;

end.
