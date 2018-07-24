unit ControllerCliente;

interface

uses
 DB, DBClient, System.Classes, ControllerBase,  FactoryEntity;

type
  TControllerCliente = class(TControllerBase)
  public

  end;

implementation

initialization RegisterClass(TControllerCliente);
finalization UnRegisterClass(TControllerCliente);


end.
