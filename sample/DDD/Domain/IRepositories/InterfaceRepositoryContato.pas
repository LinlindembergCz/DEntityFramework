unit InterfaceRepositoryContato;

interface

uses
InterfaceRepository, classContato, System.Generics.Collections;

type
  IRepositoryContato = interface(IRepositoryBase)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    function GetEntity: TContato;
    function LoadContatos(ClienteId: Integer): TList<TContato>;
  end;


implementation

end.
