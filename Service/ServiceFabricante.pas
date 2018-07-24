unit ServiceFabricante;

interface

uses
System.Classes, ServiceBase, InterfaceServiceFabricante, FactoryEntity;

type
  TServiceFabricante=class( TServiceBase , IServiceFabricante)
  public

  end;

implementation

{ ServiceFabricante }

initialization RegisterClass(TServiceFabricante);
finalization UnRegisterClass(TServiceFabricante);

end.
