program Project1;

uses
  Vcl.Forms,
  UDataModule in 'UDataModule.pas' {DataModule1: TDataModule},
  Data.DB.Helper in '..\..\source\Data.DB.Helper.pas',
  System.uJson in '..\..\source\System.uJson.pas',
  Domain.ValuesObject.CPF in '..\DDD\Domain\ValuesObjects\Domain.ValuesObject.CPF.pas',
  Domain.ValuesObject.Email in '..\DDD\Domain\ValuesObjects\Domain.ValuesObject.Email.pas',
  Domain.Consts in '..\DDD\Domain\Entities\Domain.Consts.pas',
  Domain.Entity.Cliente in '..\DDD\Domain\Entities\Domain.Entity.Cliente.pas',
  Domain.Entity.ClienteEmpresa in '..\DDD\Domain\Entities\Domain.Entity.ClienteEmpresa.pas',
  Domain.Entity.ClienteTabelaPreco in '..\DDD\Domain\Entities\Domain.Entity.ClienteTabelaPreco.pas',
  Domain.Entity.Contato in '..\DDD\Domain\Entities\Domain.Entity.Contato.pas',
  Domain.Entity.Empresa in '..\DDD\Domain\Entities\Domain.Entity.Empresa.pas',
  Domain.Entity.Entities in '..\DDD\Domain\Entities\Domain.Entity.Entities.pas',
  Domain.Entity.ItensTabelaPreco in '..\DDD\Domain\Entities\Domain.Entity.ItensTabelaPreco.pas',
  Domain.Entity.Produto in '..\DDD\Domain\Entities\Domain.Entity.Produto.pas',
  Domain.Entity.TabelaPreco in '..\DDD\Domain\Entities\Domain.Entity.TabelaPreco.pas',
  Domain.Entity.Veiculo in '..\DDD\Domain\Entities\Domain.Entity.Veiculo.pas',
  GenericFactory in '..\DDD\Domain\Factories\GenericFactory.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
