unit InterfaceRepositoryCliente;

interface

uses
InterfaceRepository, classCliente;

type
  IRepositoryCliente = interface(IRepositoryBase)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    function GetEntity: TCliente;
  end;


implementation

end.
