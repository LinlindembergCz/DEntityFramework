unit ServiceCliente;

interface

uses
System.Classes, ServiceBase, InterfaceServiceCliente, FactoryEntity, DB,ClassCliente;

type
  TServiceCliente<T:TCliente> =class( TServiceBase<T> , IServiceCliente<T>)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
  end;

  TServiceCliente =  class sealed (TServiceCliente<TCliente>)
  end;

implementation

{ TClienteService }

uses RepositoryCliente;

{ TServiceCliente }

function TServiceCliente<T>.LoadDataSetPorNome(Value: string): TDataSet;
begin
  result := (Repository as TRepositoryCliente<T> ).LoadDataSetPorNome( Value  );
end;

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
