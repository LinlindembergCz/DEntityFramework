unit ServiceFornecedor;

interface

uses
System.Classes, ServiceBase, InterfaceServiceFornecedor, EnumEntity;

type
  TServiceFornecedor=class( TServiceBase , IServiceFornecedor)
  public

  end;

implementation

{ ServiceFornecedor }

initialization RegisterClass(TServiceFornecedor);
finalization UnRegisterClass(TServiceFornecedor);

end.
