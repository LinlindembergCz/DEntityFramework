unit InterfaceRepositoryFabricante;

interface

uses
InterfaceRepository,classFabricante;

type
  IRepositoryFabricante = interface(IRepositoryBase)
    function GetEntity: Fabricante;
  end;

implementation

end.
