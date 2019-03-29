unit InterfaceRepositoryCliente;

interface

uses
InterfaceRepository, classCliente;

type
  IRepositoryCliente<T:TCliente> = interface(IRepositoryBase<T>)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']

  end;


implementation

end.
