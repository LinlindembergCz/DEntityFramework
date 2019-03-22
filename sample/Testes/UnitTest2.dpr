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
  classCliente in '..\DDD\Domain\Entities\classCliente.pas',
  CPF in '..\DDD\Domain\ValuesObjects\CPF.pas',
  Email in '..\DDD\Domain\ValuesObjects\Email.pas',
  Data.DB.Helper in '..\..\source\Data.DB.Helper.pas',
  System.uJson in '..\..\source\System.uJson.pas',
  ClassContato in '..\DDD\Domain\Entities\ClassContato.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

