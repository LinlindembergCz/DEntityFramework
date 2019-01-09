unit ControllerCliente;

interface

uses
 DB, DBClient, System.Classes, ControllerBase,  FactoryEntity;

type
  TControllerCliente = class(TControllerBase)
  public
     function LoadPorNome( Value: string ): TDataSet;
  end;

implementation

{ TControllerCliente }

uses ServiceCliente;

function TControllerCliente.LoadPorNome(Value: string): TDataSet;
begin
   result := (Service as TServiceCliente).LoadPorNome( Value );
end;

initialization RegisterClass(TControllerCliente);
finalization UnRegisterClass(TControllerCliente);


end.
