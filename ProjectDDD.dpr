program ProjectDDD;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  DUnitTestRunner,
  System.Classes,
  Dialogs,
  Forms,
  Vcl.Themes,
  Vcl.Styles,
  EntityConnection,
  FactoryEntity in 'Domain\Factories\FactoryEntity.pas',
  Entities in 'Domain\Entities\Entities.pas',
  Repository in 'Infra\Repositories\Repository.pas',
  Principal in 'Principal.pas' {FormPrincipal},
  EntityFramework in 'Infra\DEntityFramework\EntityFramework.pas',
  FactoryController in 'UI\Factories\FactoryController.pas',
  FactoryView in 'UI\Factories\FactoryView.pas',
  InterfaceController in 'UI\Controllers\InterfaceController.pas',
  ControllerBase in 'UI\Controllers\ControllerBase.pas',
  ControllerCliente in 'UI\Controllers\ControllerCliente.pas',
  ViewBase in 'UI\Views\ViewBase.pas' {FormViewBase},
  viewCliente in 'UI\Views\viewCliente.pas' {FormViewCliente},
  viewFornecedor in 'UI\Views\viewFornecedor.pas' {FormViewFornecedor},
  FactoryRepository in 'Infra\Factories\FactoryRepository.pas',
  InterfaceRepository in 'Domain\IRepositories\InterfaceRepository.pas',
  Email in 'Domain\ValuesObjects\Email.pas',
  EntityBase in 'Domain\Entities\EntityBase.pas',
  Atributies in 'Domain\Entities\Atributies\Atributies.pas',
  EntityTypes in 'Domain\Entities\types\EntityTypes.pas',
  InterfaceRepositoryCliente in 'Domain\IRepositories\InterfaceRepositoryCliente.pas',
  ServiceBase in 'Service\ServiceBase.pas',
  RepositoryCliente in 'Infra\Repositories\RepositoryCliente.pas',
  Context in 'Infra\Contexto\Context.pas',
  RepositoryBase in 'Infra\Repositories\RepositoryBase.pas',
  CPF in 'Domain\ValuesObjects\CPF.pas',
  AutoMapper in 'Infra\DEntityFramework\AutoMapper.pas',
  FactoryService in 'Service\Factories\FactoryService.pas',
  InterfaceServiceCliente in 'Domain\IService\InterfaceServiceCliente.pas',
  ServiceCliente in 'Service\ServiceCliente.pas',
  ClassCliente in 'Domain\Entities\ClassCliente.pas' {/unit in Caminho.pas},
  ClassFornecedor in 'Domain\Entities\ClassFornecedor.pas',
  InterfaceRepositoryFornecedor in 'Domain\IRepositories\InterfaceRepositoryFornecedor.pas',
  RepositoryFornecedor in 'Infra\Repositories\RepositoryFornecedor.pas',
  InterfaceServiceFornecedor in 'Domain\IService\InterfaceServiceFornecedor.pas',
  ServiceFornecedor in 'Service\ServiceFornecedor.pas',
  ControllerFornecedor in 'UI\Controllers\ControllerFornecedor.pas',
  ClassFabricante in 'Domain\Entities\ClassFabricante.pas',
  InterfaceRepositoryFabricante in 'Domain\IRepositories\InterfaceRepositoryFabricante.pas',
  RepositoryFabricante in 'Infra\Repositories\RepositoryFabricante.pas',
  InterfaceServiceFabricante in 'Domain\IService\InterfaceServiceFabricante.pas',
  ServiceFabricante in 'Service\ServiceFabricante.pas',
  ControllerFabricante in 'UI\Controllers\ControllerFabricante.pas' {,
  ViewFabricante in 'UI\Views\ViewFabricante.pas' {FormViewFabricante},
  ViewFabricante in 'UI\Views\ViewFabricante.pas' {FormViewFabricante},
  InterfaceService in 'Domain\IService\InterfaceService.pas' {,
  ClassAluno in 'Domain\Entities\ClassAluno.pas',
  InterfaceRepositoryAluno in 'Domain\IRepositories\InterfaceRepositoryAluno.pas',
  RepositoryAluno in 'Infra\Repositories\RepositoryAluno.pas',
  InterfaceServiceAluno in 'Domain\IService\InterfaceServiceAluno.pas',
  ServiceAluno in 'Service\ServiceAluno.pas',
  ControllerAluno in 'UI\Controllers\ControllerAluno.pas',
  viewAluno in 'UI\Views\viewAluno.pas' {FormViewAluno},
  ClassAluno in 'Domain\Entities\ClassAluno.pas',
  InterfaceRepositoryAluno in 'Domain\IRepositories\InterfaceRepositoryAluno.pas',
  RepositoryAluno in 'Infra\Repositories\RepositoryAluno.pas',
  InterfaceServiceAluno in 'Domain\IService\InterfaceServiceAluno.pas',
  ServiceAluno in 'Service\ServiceAluno.pas',
  ControllerAluno in 'UI\Controllers\ControllerAluno.pas' {/unit in Caminho.pas},
  viewAluno in 'UI\Views\viewAluno.pas' {FormViewAluno},
  CustomDataBase in 'Infra\DEntityFramework\Conection\CustomDataBase.pas',
  QueryAble in 'Infra\DEntityFramework\QueryAble.pas',
  FactoryConnection in 'Infra\Factories\FactoryConnection.pas',
  ClassCFOP in 'Domain\Entities\ClassCFOP.pas',
  InterfaceQueryAble in 'Infra\DEntityFramework\InterfaceQueryAble.pas';

{/unit in Caminho.pas}

{R *.RES}

var
 DataContext: TDataContext;

begin
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  try
    DataContext:= TDataContext.Create(nil);
    DataContext.Connection:= TFactoryConnection.GetConnection;
    //Essa  UpdateDataBase irá criar as tabelas e campos que estão mapeados na classe de dominio.
    if DataContext.UpdateDataBase([ TCliente , TCFOP (*Entity*) ]) then
    begin
       showmessage('O sistema será reiniciado!');
       application.Terminate;
    end;
  finally
    DataContext.Free;
  end;
  Application.run;
  //DUnitTestRunner.RunRegisteredTests;
  ReportMemoryLeaksOnShutdown := true;
end.
