unit ControllerAluno;

interface

uses
System.Classes, DB, DBClient, ControllerBase,  EnumEntity;

type
  TControllerAluno = class(TControllerBase)
  public

  end;

implementation

initialization RegisterClass(TControllerAluno);
finalization UnRegisterClass(TControllerAluno);

end.
