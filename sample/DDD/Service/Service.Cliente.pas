unit Service.Cliente;

interface

uses
System.Classes, Service.Base, Domain.Interfaces.Services.Cliente, FactoryEntity, DB, Domain.Entity.Cliente;

type
  TServiceCliente<T:TCliente> =class( TServiceBase<T> , IServiceCliente<T>)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
  end;

  TServiceCliente =  class sealed (TServiceCliente<TCliente>)
  end;

implementation

{ TClienteService }

uses Domain.Interfaces.Repositorios.Cliente;

{ TServiceCliente }

function TServiceCliente<T>.LoadDataSetPorNome(Value: string): TDataSet;
begin
  result := (Repository as IRepositoryCliente<T> ).LoadDataSetPorNome( Value  );
end;

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
