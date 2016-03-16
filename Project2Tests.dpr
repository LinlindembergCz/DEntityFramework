program Project2Tests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Forms,
  Vcl.Themes,
  Vcl.Styles,
  EntityConnection,
  TestUnit2 in 'TestUnit2.pas',
  EnumEntity in 'EnumEntity.pas',
  FactoryEntity in 'Domain\Factories\FactoryEntity.pas',
  Entities in 'Domain\Entities\Entities.pas',
  RepositoryBase in 'Infra\Data\Repositories\RepositoryBase.pas',
  Principal in 'Principal.pas' {FormPrincipal},
  FactoryConnection in 'Infra\Factories\FactoryConnection.pas',
  RepositoryCliente in 'Infra\Data\Repositories\RepositoryCliente.pas',
  EntityXE in 'Infra\DEntityFramework\EntityXE.pas',

  FactoryController in 'UI\Factories\FactoryController.pas',
  FactoryItensController in 'UI\Factories\FactoryItensController.pas',
  FactoryView in 'UI\Factories\FactoryView.pas',
  InterfaceController in 'UI\Controllers\InterfaceController.pas',
  InterfaceControllerItens in 'UI\Controllers\InterfaceControllerItens.pas',
  ControllerBase in 'UI\Controllers\ControllerBase.pas',
  ControllerCliente in 'UI\Controllers\ControllerCliente.pas',
  ControllerItensBase in 'UI\Controllers\ControllerItensBase.pas',
  ControllerItensOrcamento in 'UI\Controllers\ControllerItensOrcamento.pas',
  ControllerOrcamento in 'UI\Controllers\ControllerOrcamento.pas',
  ViewBase in 'UI\Views\ViewBase.pas' {FormViewBase},
  viewCliente in 'UI\Views\viewCliente.pas' {FormViewCliente},
  viewFornecedor in 'UI\Views\viewFornecedor.pas' {FormViewFornecedor},
  viewItensBase in 'UI\Views\viewItensBase.pas' {FormViewItensBase},
  viewOrcamento in 'UI\Views\viewOrcamento.pas' {FormViewOrcamento},
  viewProduto in 'UI\Views\viewProduto.pas' {FormViewProduto},
  FactoryRepository in 'Domain\Factories\FactoryRepository.pas',

  InterfaceRepositoryBase in 'Domain\Repositories\InterfaceRepositoryBase.pas',
  ValueObject.Email in 'Domain\ValuesObjects\ValueObject.Email.pas',
  RepositoryOrcamento in 'Infra\Data\Repositories\RepositoryOrcamento.pas',
  Entity in 'Domain\Entities\Entity.pas';

{R *.RES}

var
  DataContext: TDataContext;

begin

  Application.CreateForm(TFormPrincipal, FormPrincipal);
  {
  DataContext:= TDataContext.Create;
  DataContext.Connection := TFactoryConnection.GetConnection( tpFireDac );
  DataContext.UpdateDataBase([ TCliente, TProduto, TFornecedor, TClassificacaoPessoa, TOrcamento, TItensOrcamento ]);
  DataContext.Free;
  }
  Application.run;
  //DUnitTestRunner.RunRegisteredTests;
end.
