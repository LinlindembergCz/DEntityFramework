unit InterfaceRepositoryFornecedor;

interface

uses
InterfaceRepository,classFornecedor;

type
  IRepositoryFornecedor = interface(IRepositoryBase)
    function GetEntity: Fornecedor;
  end;

implementation

end.
