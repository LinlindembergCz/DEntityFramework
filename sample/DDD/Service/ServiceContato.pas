unit ServiceContato;

interface

uses
System.Classes, ServiceBase,InterfaceRepository,
 InterfaceServiceContato, FactoryEntity, DB, ClassContato;

type
  TServiceContato<T:TContato>=class( TServiceBase<T> , IServiceContato<T>)
  public
    function Load(iId:Integer; Fields: string = ''): TDataSet;override;
  end;

  TServiceContato =class sealed (TServiceContato<TContato>)
  end;

implementation

{ TServiceContato }

function TServiceContato<T>.Load(iId: Integer; Fields: string): TDataSet;
begin

end;

initialization RegisterClass(TServiceContato);
finalization UnRegisterClass(TServiceContato);

end.
