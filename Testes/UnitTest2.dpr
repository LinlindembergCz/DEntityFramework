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
  LinqSQL in '..\Infra\DEntityFramework\LinqSQL.pas',
  Entities in '..\Domain\Entities\Entities.pas',
  Atributies in '..\Domain\Entities\Atributies\Atributies.pas',
  EntityBase in '..\Domain\Entities\EntityBase.pas',
  EntityTypes in '..\Domain\Entities\types\EntityTypes.pas',
  AutoMapper in '..\Infra\DEntityFramework\AutoMapper.pas',
  classCliente in '..\Domain\Entities\classCliente.pas' {$R *.RES},
  Email in '..\Domain\ValuesObjects\Email.pas',
  CPF in '..\Domain\ValuesObjects\CPF.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

