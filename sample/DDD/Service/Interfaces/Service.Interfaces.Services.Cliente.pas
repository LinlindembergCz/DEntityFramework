unit Service.Interfaces.Services.Cliente;

interface

uses
Service.Interfaces.Services.ServiceBase, Domain.Entity.Cliente;

type
  IServiceCliente<T:TCliente> = interface(IServiceBase<T>)
    ['{81D6040C-CC9E-4805-8E62-0215D3FA49B8}']
  end;

implementation

end.
