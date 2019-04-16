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
  InterfaceService in 'Domain\IService\InterfaceService.pas' {,
  ClassAluno in 'Domain\Entities\ClassAluno.pas',
  InterfaceRepositoryAluno in 'Domain\IRepositories\InterfaceRepositoryAluno.pas',
  RepositoryAluno in 'Infra\Repositories\RepositoryAluno.pas',
  InterfaceServiceAluno in 'Domain\IService\InterfaceServiceAluno.pas',
  ServiceAluno in 'Service\ServiceAluno.pas',
  ControllerAluno in 'UI\Controllers\ControllerAluno.pas',
  viewAluno in 'UI\Views\viewAluno.pas' {FormViewAluno},
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
  ClassContato in 'Domain\Entities\ClassContato.pas',
  ClassVeiculo in 'Domain\Entities\ClassVeiculo.pas',
  ClassClienteTabelaPreco in 'Domain\Entities\ClassClienteTabelaPreco.pas',
  ClassTabelaPreco in 'Domain\Entities\ClassTabelaPreco.pas',
  ClassProduto in 'Domain\Entities\ClassProduto.pas',
  ClassItensTabelaPreco in 'Domain\Entities\ClassItensTabelaPreco.pas';

{$R *.res}

var
  c:TDataContext;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown:= true;

  try
    c:= TDataContext.Create;
    c.Connection:= TFactoryConnection.GetConnection;
    //A ordem de criação das tabelas que se relacionam é importante!!!!
    c.UpdateDataBase([TCliente,
                      TContato,
                      TVeiculo,
                      TTabelaPreco,
                      TClienteTabelaPreco,
                      TProduto,
                      TItensTabelaPreco ]);
  except
    application.Terminate;
    exit;
  end;

  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
