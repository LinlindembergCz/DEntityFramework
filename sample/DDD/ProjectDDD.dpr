program ProjectDDD;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  Domain.Entity.Cliente in 'Domain\Entities\Domain.Entity.Cliente.pas' {/unit in Caminho.pas},
  Domain.Entity.Contato in 'Domain\Entities\Domain.Entity.Contato.pas',
  Domain.Entity.Veiculo in 'Domain\Entities\Domain.Entity.Veiculo.pas',
  Domain.Entity.ClienteTabelaPreco in 'Domain\Entities\Domain.Entity.ClienteTabelaPreco.pas',
  Domain.Entity.TabelaPreco in 'Domain\Entities\Domain.Entity.TabelaPreco.pas',
  Domain.Entity.Produto in 'Domain\Entities\Domain.Entity.Produto.pas',
  Domain.Entity.ItensTabelaPreco in 'Domain\Entities\Domain.Entity.ItensTabelaPreco.pas',
  FactoryEntity in 'Domain\Factories\FactoryEntity.pas',
  Domain.Entity.Entities in 'Domain\Entities\Domain.Entity.Entities.pas',
  FactoryConnection in 'Repositorio\Factories\FactoryConnection.pas',
  Context in 'Repositorio\Contexto\Context.pas',
  Repositorio.Interfaces.Base in 'Repositorio\Interfaces\Repositorio.Interfaces.Base.pas',
  Repositorio.Interfaces.Cliente in 'Repositorio\Interfaces\Repositorio.Interfaces.Cliente.pas',
  Repositorio.GenericRepository in 'Repositorio\Repositorio.GenericRepository.pas',
  Repositorio.Base in 'Repositorio\Repositorio.Base.pas',
  Repositorio.Cliente in 'Repositorio\Repositorio.Cliente.pas',
  FactoryRepository in 'Repositorio\Factories\FactoryRepository.pas',
  Service.Interfaces.Servicebase in 'Service\Interfaces\Service.Interfaces.Servicebase.pas',
  Service.Interfaces.Cliente in 'Service\Interfaces\Service.Interfaces.Cliente.pas',
  Service.Cliente in 'Service\Service.Cliente.pas',
  Service.Base in 'Service\Service.Base.pas',
  FactoryService in 'Service\Factories\FactoryService.pas',
  Domain.ValuesObject.CPF in 'Domain\ValuesObjects\Domain.ValuesObject.CPF.pas',
  Domain.ValuesObject.Email in 'Domain\ValuesObjects\Domain.ValuesObject.Email.pas',
  Data.DB.Helper in '..\..\source\Data.DB.Helper.pas',
  System.uJson in '..\..\source\System.uJson.pas',
  JsonDataObjects in '..\..\source\JsonDataObjects.pas',
  EF.Core.Consts in '..\..\source\EF.Core.Consts.pas',
  EF.Core.Functions in '..\..\source\EF.Core.Functions.pas',
  EF.Core.Types in '..\..\source\EF.Core.Types.pas',
  EF.Drivers.Connection in '..\..\source\EF.Drivers.Connection.pas',
  EF.Drivers.FireDac in '..\..\source\EF.Drivers.FireDac.pas',
  EF.Engine.DataContext in '..\..\source\EF.Engine.DataContext.pas',
  EF.Mapping.Atributes in '..\..\source\EF.Mapping.Atributes.pas',
  EF.Mapping.AutoMapper in '..\..\source\EF.Mapping.AutoMapper.pas',
  EF.Mapping.Base in '..\..\source\EF.Mapping.Base.pas',
  EF.QueryAble.Base in '..\..\source\EF.QueryAble.Base.pas',
  EF.QueryAble.Interfaces in '..\..\source\EF.QueryAble.Interfaces.pas',
  EF.Schema.Abstract in '..\..\source\EF.Schema.Abstract.pas',
  EF.Schema.Firebird in '..\..\source\EF.Schema.Firebird.pas',
  EF.Schema.MSSQL in '..\..\source\EF.Schema.MSSQL.pas',
  EF.Schema.MySQL in '..\..\source\EF.Schema.MySQL.pas',
  FactoryController in 'App\Factories\FactoryController.pas',
  FactoryView in 'App\Factories\FactoryView.pas',
  ViewBase in 'App\Views\ViewBase.pas' {FormViewBase},
  viewCliente in 'App\Views\viewCliente.pas' {FormViewBase},
  App.Model.Cliente in 'App\Model\App.Model.Cliente.pas',
  App.Controller.Base in 'App\Controllers\App.Controller.Base.pas',
  App.Controller.Cliente in 'App\Controllers\App.Controller.Cliente.pas',
  App.Interfaces.ControllerBase in 'App\Controllers\App.Interfaces.ControllerBase.pas',
  Service.Utils.DataBind in 'Service\Utils\Service.Utils.DataBind.pas',
  Domain.Consts in 'Domain\Entities\Domain.Consts.pas',
  Domain.Entity.Empresa in 'Domain\Entities\Domain.Entity.Empresa.pas',
  Domain.Entity.ClienteEmpresa in 'Domain\Entities\Domain.Entity.ClienteEmpresa.pas',
  GenericFactory in 'Domain\Factories\GenericFactory.pas',
  EF.Schema.PostGres in '..\..\source\EF.Schema.PostGres.pas';

{$R *.res}

var
  c:TEntityConn;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //ReportMemoryLeaksOnShutdown:= true;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  try
    c:= TFactoryConnection.GetConnection;//(FormPrincipal.FDConnection1);
    //A ordem de criação das tabelas que se relacionam é importante!!!!
    c.MigrationDataBase( [ TEmpresa,
                           TCliente,
                           TClienteEmpresa,
                           TContato,
                           TVeiculo,
                           TTabelaPreco,
                           TClienteTabelaPreco,
                           TProduto,
                           TItensTabelaPreco ] );
    c.free;
    c:= nil;
  except
    application.Terminate;
    exit;
  end;
  Application.Run;
end.
