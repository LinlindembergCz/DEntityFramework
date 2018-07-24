unit ControllerFornecedor;

interface

uses
 DB, DBClient, System.Classes, ControllerBase,  FactoryEntity;

type
  TControllerFornecedor = class(TControllerBase)
  public

  end;

implementation

initialization RegisterClass(TControllerFornecedor);
finalization UnRegisterClass(TControllerFornecedor);

end.
