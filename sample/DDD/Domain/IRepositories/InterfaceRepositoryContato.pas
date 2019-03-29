unit InterfaceRepositoryContato;

interface

uses
InterfaceRepository, classContato, System.Generics.Collections;

type
  IRepositoryContato<T:TContato> = interface(IRepositoryBase<T>)
    ['{B554BA67-0B56-4860-AFC6-344EB02F8CD5}']
    function GetEntity: TContato;
    function LoadContatos(ClienteId: Integer): TList<TContato>;
  end;


implementation

end.
