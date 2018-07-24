unit ServiceFornecedor;

interface

uses
System.Classes, ServiceBase, InterfaceServiceFornecedor, FactoryEntity;

type
  TServiceFornecedor=class( TServiceBase , IServiceFornecedor)
  public

  end;

implementation

{ ServiceFornecedor }

initialization RegisterClass(TServiceFornecedor);
finalization UnRegisterClass(TServiceFornecedor);

end.
