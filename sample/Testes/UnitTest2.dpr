program UnitTest2;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestLinqSQL in 'TestLinqSQL.pas',
  Data.DB.Helper in '..\..\source\Data.DB.Helper.pas',
  System.uJson in '..\..\source\System.uJson.pas',
  Domain.Entity.Cliente in '..\DDD\Domain\Entities\Domain.Entity.Cliente.pas',
  Domain.Entity.ClienteTabelaPreco in '..\DDD\Domain\Entities\Domain.Entity.ClienteTabelaPreco.pas',
  Domain.Entity.Contato in '..\DDD\Domain\Entities\Domain.Entity.Contato.pas',
  Domain.Entity.Entities in '..\DDD\Domain\Entities\Domain.Entity.Entities.pas',
  Domain.Entity.ItensTabelaPreco in '..\DDD\Domain\Entities\Domain.Entity.ItensTabelaPreco.pas',
  Domain.Entity.Produto in '..\DDD\Domain\Entities\Domain.Entity.Produto.pas',
  Domain.Entity.TabelaPreco in '..\DDD\Domain\Entities\Domain.Entity.TabelaPreco.pas',
  Domain.Entity.Veiculo in '..\DDD\Domain\Entities\Domain.Entity.Veiculo.pas',
  Domain.ValuesObject.CPF in '..\DDD\Domain\ValuesObjects\Domain.ValuesObject.CPF.pas',
  Domain.ValuesObject.Email in '..\DDD\Domain\ValuesObjects\Domain.ValuesObject.Email.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

