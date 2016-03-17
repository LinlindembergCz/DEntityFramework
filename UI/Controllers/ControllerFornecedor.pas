unit ControllerFornecedor;

interface

uses
 DB, DBClient, System.Classes, ControllerBase,  EnumEntity;

type
  TControllerFornecedor = class(TControllerBase)
  public

  end;

implementation

initialization RegisterClass(TControllerFornecedor);
finalization UnRegisterClass(TControllerFornecedor);

end.
