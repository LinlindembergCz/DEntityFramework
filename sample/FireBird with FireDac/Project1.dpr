program Project1;

uses
  Vcl.Forms,
  UDataModule in 'UDataModule.pas' {DataModule1: TDataModule},
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
  Unit1 in 'Unit1.pas' {Form1},
  Data.DB.Helper in '..\..\source\Data.DB.Helper.pas',
  EF.Core.Consts in '..\..\source\EF.Core.Consts.pas',
  EF.Core.Functions in '..\..\source\EF.Core.Functions.pas',
  EF.Core.Types in '..\..\source\EF.Core.Types.pas',
  EF.Drivers.Connection in '..\..\source\EF.Drivers.Connection.pas',
  EF.Drivers.FireDac in '..\..\source\EF.Drivers.FireDac.pas',
  EF.Engine.DbSet in '..\..\source\EF.Engine.DbSet.pas',
  EF.Mapping.Atributes in '..\..\source\EF.Mapping.Atributes.pas',
  EF.Mapping.AutoMapper in '..\..\source\EF.Mapping.AutoMapper.pas',
  EF.Mapping.Base in '..\..\source\EF.Mapping.Base.pas',
  EF.QueryAble.Base in '..\..\source\EF.QueryAble.Base.pas',
  EF.QueryAble.Interfaces in '..\..\source\EF.QueryAble.Interfaces.pas',
  EF.Schema.Abstract in '..\..\source\EF.Schema.Abstract.pas',
  EF.Schema.Firebird in '..\..\source\EF.Schema.Firebird.pas',
  EF.Schema.MSSQL in '..\..\source\EF.Schema.MSSQL.pas',
  EF.Schema.MySQL in '..\..\source\EF.Schema.MySQL.pas',
  EF.Schema.PostGres in '..\..\source\EF.Schema.PostGres.pas',
  JsonDataObjects in '..\..\source\JsonDataObjects.pas',
  System.uJson in '..\..\source\System.uJson.pas',
  EF.Core.List in '..\..\source\EF.Core.List.pas',
  DataContext in 'DataContext.pas',
  EF.Engine.DbContext in '..\..\source\EF.Engine.DbContext.pas',
  EF.QueryAble.Linq in '..\..\source\EF.QueryAble.Linq.pas',
  EF.Schema.SQLite in '..\..\source\EF.Schema.SQLite.pas',
  Domain.Entity.Endereco in '..\DDD\Domain\Entities\Domain.Entity.Endereco.pas',
  EF.Drivers.Migration in '..\..\source\EF.Drivers.Migration.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown:= true;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  pplication.CreateForm(TForm1, Form1);
  Application.Run;
end.
