program ProjectDDD;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
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
  Atributies in 'Infra\DEntityFramework\Atributies\Atributies.pas',
  EntityTypes in 'Infra\DEntityFramework\EntityTypes.pas',
  InterfaceRepositoryCliente in 'Domain\IRepositories\InterfaceRepositoryCliente.pas',
  ServiceBase in 'Service\ServiceBase.pas',
  RepositoryCliente in 'Infra\Repositories\RepositoryCliente.pas',
  Context in 'Infra\Contexto\Context.pas',
  RepositoryBase in 'Infra\Repositories\RepositoryBase.pas',
  CPF in 'Domain\ValuesObjects\CPF.pas',
  EntityAutoMapper in 'Infra\DEntityFramework\EntityAutoMapper.pas',
  FactoryService in 'Service\Factories\FactoryService.pas',
  InterfaceServiceCliente in 'Domain\IService\InterfaceServiceCliente.pas',
  ServiceCliente in 'Service\ServiceCliente.pas',
  ClassCliente in 'Domain\Entities\ClassCliente.pas' {/unit in Caminho.pas},
  InterfaceService in 'Domain\IService\InterfaceService.pas' {,
  ClassAluno in 'Domain\Entities\ClassAluno.pas',
  InterfaceRepositoryAluno in 'Domain\IRepositories\InterfaceRepositoryAluno.pas',
  RepositoryAluno in 'Infra\Repositories\RepositoryAluno.pas',
  InterfaceServiceAluno in 'Domain\IService\InterfaceServiceAluno.pas',
  ServiceAluno in 'Service\ServiceAluno.pas',
  ControllerAluno in 'UI\Controllers\ControllerAluno.pas',
  viewAluno in 'UI\Views\viewAluno.pas' {FormViewAluno},
  CustomDataBase in 'Infra\DEntityFramework\Conection\CustomDataBase.pas',
  QueryAble in 'Infra\DEntityFramework\QueryAble.pas',
  FactoryConnection in 'Infra\Factories\FactoryConnection.pas',
  InterfaceQueryAble in 'Infra\DEntityFramework\InterfaceQueryAble.pas',
  EntityBase in 'Infra\DEntityFramework\EntityBase.pas',
  EntityAtributies in 'Infra\DEntityFramework\EntityAtributies.pas';

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
    if DataContext.UpdateDataBase([ TCliente {'Array de Classes descendentes de TEntityBase'} ]) then
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
