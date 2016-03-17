unit ServiceCliente;

interface

uses
System.Classes, ServiceBase, InterfaceServiceCliente, EnumEntity;

type
  TServiceCliente=class( TServiceBase , IServiceCliente)
  public

  end;

implementation

{ TClienteService }

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
