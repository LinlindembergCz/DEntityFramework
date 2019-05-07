unit InterfaceControllerItens;

interface

uses
InterfaceController;


type
  IControllerItensBase =interface(IController)
  procedure Apply(MasterController:IController);
  end;

implementation

end.
