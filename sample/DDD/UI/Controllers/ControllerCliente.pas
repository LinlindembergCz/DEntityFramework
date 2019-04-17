unit ControllerCliente;

interface

uses
 DB, DBClient, System.Classes, ControllerBase,  FactoryEntity;

type
  TControllerCliente = class(TControllerBase)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
  end;

implementation

{ TControllerCliente }

uses Service.Cliente;

function TControllerCliente.LoadDataSetPorNome(Value: string): TDataSet;
begin
   result := (Service as TServiceCliente).LoadDataSetPorNome( Value );
end;

initialization RegisterClass(TControllerCliente);
finalization UnRegisterClass(TControllerCliente);


end.
