unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, Forms,
  EF.Drivers.Connection;

type
  TDataModule1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FConnection: TEntityConn;
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Uses
  EF.Drivers.FireDac;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
var
 vDB : String;
begin
  vDB := extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB';
  FConnection := TEntityFDConnection.Create('FB',
                                                 'SYSDBA',
                                                 'masterkey',
                                                 'LocalHost',
                                                 vDB);
end;

end.
