unit Repositorio.Interfaces.Cliente;

interface

uses
Repositorio.Interfaces.Base, Domain.Entity.Cliente, DB;

type
  IRepositoryCliente<T:TCliente> = interface(IRepositoryBase<T>)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    function LoadDataSetPorNome(value: string):TDataSet;
  end;


implementation

end.
