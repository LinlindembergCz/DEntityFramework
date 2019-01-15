program ProjectDDD;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {FormPrincipal},
  FactoryView in 'UI\Factories\FactoryView.pas',
  ViewBase in 'UI\Views\ViewBase.pas' {FormViewBase},
  viewCliente in 'UI\Views\viewCliente.pas' {FormViewBase},
  InterfaceController in 'UI\Controllers\InterfaceController.pas',
  FactoryController in 'UI\Factories\FactoryController.pas',
  ControllerBase in 'UI\Controllers\ControllerBase.pas',
  Context in 'Infra\Contexto\Context.pas',
  FactoryConnection in 'Infra\Factories\FactoryConnection.pas',
  FactoryRepository in 'Infra\Factories\FactoryRepository.pas',
  InterfaceService in 'Domain\IService\InterfaceService.pas',
  InterfaceServiceCliente in 'Domain\IService\InterfaceServiceCliente.pas',
  CPF in 'Domain\ValuesObjects\CPF.pas',
  Email in 'Domain\ValuesObjects\Email.pas',
  FactoryEntity in 'Domain\Factories\FactoryEntity.pas',
  InterfaceRepositoryCliente in 'Domain\IRepositories\InterfaceRepositoryCliente.pas',
  classCliente in 'Domain\Entities\classCliente.pas' {/unit in Caminho.pas},
  Entities in 'Domain\Entities\Entities.pas',
  FactoryService in 'Service\Factories\FactoryService.pas',
  RepositoryBase in 'Infra\Repositories\RepositoryBase.pas',
  InterfaceRepository in 'Domain\IRepositories\InterfaceRepository.pas',
  Repository in 'Infra\Repositories\Repository.pas',
  ControllerCliente in 'UI\Controllers\ControllerCliente.pas',
  RepositoryCliente in 'Infra\Repositories\RepositoryCliente.pas',
  ServiceCliente in 'Service\ServiceCliente.pas',
  ServiceBase in 'Service\ServiceBase.pas',
  Data.DB.Helper in '..\..\source\Data.DB.Helper.pas',
  System.uJson in '..\..\source\System.uJson.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
