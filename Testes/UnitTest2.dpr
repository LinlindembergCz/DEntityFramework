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
  Entities in '..\Domain\Entities\Entities.pas',
  classCliente in '..\Domain\Entities\classCliente.pas' ,
  Email in '..\Domain\ValuesObjects\Email.pas',
  CPF in '..\Domain\ValuesObjects\CPF.pas',
  EF.Core.Types in '..\Infra\DEntityFramework\source\core\EF.Core.Types.pas',
  EF.Mapping.Atributes in '..\Infra\DEntityFramework\source\core\EF.Mapping.Atributes.pas',
  EF.Mapping.AutoMapper in '..\Infra\DEntityFramework\source\core\EF.Mapping.AutoMapper.pas',
  EF.QueryAble.Base in '..\Infra\DEntityFramework\source\core\EF.QueryAble.Base.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

