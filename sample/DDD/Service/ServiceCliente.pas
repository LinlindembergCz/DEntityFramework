unit ServiceCliente;

interface

uses
System.Classes, ServiceBase, InterfaceServiceCliente, FactoryEntity, DB;

type
  TServiceCliente=class( TServiceBase , IServiceCliente)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
  end;

implementation

{ TClienteService }

uses RepositoryCliente;

{ TServiceCliente }

function TServiceCliente.LoadDataSetPorNome(Value: string): TDataSet;
begin
  result := (Repository as TRepositoryCliente ).LoadDataSetPorNome( Value  );
end;

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
