unit Service.Cliente;

interface

uses
System.Classes, Service.Base, Service.Interfaces.Cliente, FactoryEntity, DB, Domain.Entity.Cliente;

type
  TServiceCliente<T:TCliente> =class( TServiceBase<T> , IServiceCliente<T>)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
     function LoadDataSetPorID(Value: string): TDataSet;
  end;

  TServiceCliente =  class sealed (TServiceCliente<TCliente>)
  end;

implementation

{ TClienteService }

uses Repositorio.Interfaces.Cliente;

{ TServiceCliente }

function TServiceCliente<T>.LoadDataSetPorNome(Value: string): TDataSet;
begin
  result := (Repository as IRepositoryCliente<T> ).LoadDataSetPorNome( Value  );
end;

function TServiceCliente<T>.LoadDataSetPorID(Value: string): TDataSet;
begin
  result := (Repository as IRepositoryCliente<T> ).LoadDataSetPorID( Value  );
end;

initialization RegisterClass(TServiceCliente);
finalization UnRegisterClass(TServiceCliente);


end.
