unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, Forms;

type
  TDataModule1 = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Uses
  Domain.Entity.Cliente, Domain.Entity.ClienteEmpresa,
  Domain.Entity.ClienteTabelaPreco, Domain.Entity.Contato,
  Domain.Entity.Empresa, Domain.Entity.Entities, Domain.Entity.ItensTabelaPreco,
  Domain.Entity.Produto, Domain.Entity.TabelaPreco, Domain.Entity.Veiculo;

end.
