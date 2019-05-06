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
begin
  FConnection := TEntityFDConnection.Create(fdFB ,
                                       'SYSDBA',
                                       'masterkey',
                                       'LocalHost',
                                       extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');

end;

end.
