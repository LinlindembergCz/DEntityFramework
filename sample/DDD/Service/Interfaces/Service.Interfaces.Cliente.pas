unit Service.Interfaces.Cliente;

interface

uses
Service.Interfaces.ServiceBase, Domain.Entity.Cliente,DB;

type
  IServiceCliente<T:TCliente> = interface(IServiceBase<T>)
    ['{81D6040C-CC9E-4805-8E62-0215D3FA49B8}']
    function LoadDataSetPorNome( Value: string ): TDataSet;
  end;

implementation

end.
