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
  Infra.Interfaces.Repositorios.RepositoryBase in 'Infra\Interfaces\Infra.Interfaces.Repositorios.RepositoryBase.pas',
  Infra.Interfaces.Repositorios.Cliente in 'Infra\Interfaces\Infra.Interfaces.Repositorios.Cliente.pas',
  FactoryEntity in 'Domain\Factories\FactoryEntity.pas',
  Domain.Entity.Entities in 'Domain\Entities\Domain.Entity.Entities.pas',
  Context in 'Infra\Contexto\Context.pas',
  FactoryConnection in 'Infra\Factories\FactoryConnection.pas',
  Infra.Repository.GenericRepository in 'Infra\Repositories\Infra.Repository.GenericRepository.pas',
  Infra.Repository.Base in 'Infra\Repositories\Infra.Repository.Base.pas',
  Infra.Repository.Cliente in 'Infra\Repositories\Infra.Repository.Cliente.pas',
  FactoryRepository in 'Infra\Factories\FactoryRepository.pas',
  Service.Interfaces.Services.Servicebase in 'Service\Interfaces\Service.Interfaces.Services.Servicebase.pas',
  Service.Interfaces.Services.Cliente in 'Service\Interfaces\Service.Interfaces.Services.Cliente.pas',
  Service.Cliente in 'Service\Service.Cliente.pas',
  Service.Base in 'Service\Service.Base.pas',
  FactoryService in 'Service\Factories\FactoryService.pas',
  FactoryController in 'UI\Factories\FactoryController.pas',
  FactoryView in 'UI\Factories\FactoryView.pas',
  ViewBase in 'UI\Views\ViewBase.pas' {FormViewBase},
  viewCliente in 'UI\Views\viewCliente.pas' {FormViewBase},
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
  UI.Model.Cliente in 'UI\Model\UI.Model.Cliente.pas',
  UI.Controller.Base in 'UI\Controllers\UI.Controller.Base.pas',
  UI.Controller.Cliente in 'UI\Controllers\UI.Controller.Cliente.pas',
  UI.Interfaces.ControllerBase in 'UI\Controllers\UI.Interfaces.ControllerBase.pas',
  Service.Utils.DataBind in 'Service\Utils\Service.Utils.DataBind.pas';

{$R *.res}

var
  c:TEntityConn;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown:= true;
  try
    c:= TFactoryConnection.GetConnection;
    //A ordem de criação das tabelas que se relacionam é importante!!!!
    c.UpdateDataBase([ TCliente,
                       TContato,
                       TVeiculo,
                       TTabelaPreco,
                       TClienteTabelaPreco,
                       TProduto,
                       TItensTabelaPreco ]);
    c.free;
    c:= nil;
  except
    application.Terminate;
    exit;
  end;

  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
