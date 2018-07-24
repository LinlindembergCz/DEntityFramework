unit ServiceCliente;

interface

uses
System.Classes, ServiceBase, InterfaceServiceCliente, FactoryEntity;

type
  TServiceCliente=class( TServiceBase , IServiceCliente)
  public

  end;

implementation

{ TClienteService }

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
