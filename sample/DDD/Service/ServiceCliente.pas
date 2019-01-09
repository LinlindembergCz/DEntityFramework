unit ServiceCliente;

interface

uses
System.Classes, ServiceBase, InterfaceServiceCliente, FactoryEntity, DB;

type
  TServiceCliente=class( TServiceBase , IServiceCliente)
  public
     function LoadPorNome( Value: string ): TDataSet;
  end;

implementation

{ TClienteService }

uses RepositoryCliente;

{ TServiceCliente }

function TServiceCliente.LoadPorNome(Value: string): TDataSet;
begin
  result := (Repository as TRepositoryCliente ).LoadPorNome( Value  );
end;

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
