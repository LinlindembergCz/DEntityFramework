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
    FConnection: TDatabaseFacade;
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Uses
  EF.Drivers.FireDac, Domain.Entity.Cliente, Domain.Entity.ClienteEmpresa,
  Domain.Entity.ClienteTabelaPreco, Domain.Entity.Contato,
  Domain.Entity.Empresa, Domain.Entity.Entities, Domain.Entity.ItensTabelaPreco,
  Domain.Entity.Produto, Domain.Entity.TabelaPreco, Domain.Entity.Veiculo;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  FConnection := TEntityFDConnection.Create(fdFB ,
                                       'SYSDBA',
                                       'masterkey',
                                       'LocalHost',
                                       extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');

    FConnection.MigrationDataBase( [ TEmpresa,
                                     TCliente,
                                     TClienteEmpresa,
                                     TContato,
                                     TVeiculo,
                                     TTabelaPreco,
                                     TClienteTabelaPreco,
                                     TProduto,
                                     TItensTabelaPreco ] );


end;

end.
