unit InterfaceServiceContato;

interface

uses
InterfaceService, classContato;

type
  IServiceContato<T:TContato>= interface(IServiceBase<T>)
   ['{2A2270C1-F20B-4B90-8B00-ED182EF41E58}']
  end;

implementation

end.
