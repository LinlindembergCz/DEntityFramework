unit FactoryService;

interface

uses
    FactoryEntity,
    Service.Interfaces.Services.Servicebase,
    infra.Interfaces.Repositorios.RepositoryBase, VCL.Dialogs, Sysutils, EF.Mapping.Base, Domain.Entity.Cliente;

type
   TFactoryService = class
   private
     class function GetServiceCliente(E: string): IServiceBase<TCliente>;
   public
     class function GetService( E: string ):IServiceBase<TEntitybase>;
   end;

implementation

uses  FactoryRepository, Service.Base, EF.Mapping.AutoMapper;//ServiceEntity;

{ TFactoryService }

class function TFactoryService.GetService(E: string): IServiceBase<TEntitybase>;
var
  Service  : IServiceBase<TEntitybase>;
begin
  if E = 'Cliente' then
     result   := GetServiceCliente(E ) as IServiceBase<TEntitybase>;
end;

class function TFactoryService.GetServiceCliente(E: string ): IServiceBase<TCliente>;
var
  Instance    : TEntitybase;
  pRepository : IRepositoryBase<TCliente>;
  Service     : IServiceBase<TCliente>;
begin
  pRepository := TFactoryRepository.GetRepository<TCliente>(E) as IRepositoryBase<TCliente>;
  Instance    := TAutoMapper.GetInstance<TCliente>( 'Service.'+E+'.TService'+E);
  if Instance <> nil then
  begin
    Service :=  TServiceBase<TCliente>( Instance ).create(pRepository );
    result:= Service;
  end;
end;

end.
