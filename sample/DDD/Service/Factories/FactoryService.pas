unit FactoryService;

interface

uses
    FactoryEntity,
    Service.Interfaces.Services.Servicebase,
    infra.Interfaces.Repositorios.RepositoryBase, VCL.Dialogs, Sysutils, EF.Mapping.Base, Domain.Entity.Cliente;

type
   TFactoryService = class
   private
     class function GetService<T:TEntityBase>(E: string): IServiceBase<T>;overload;
   public
     class function GetService( E: string ):IServiceBase<TEntitybase>;overload;
   end;

implementation

uses  Service.Base, FactoryRepository,  EF.Mapping.AutoMapper;

{ TFactoryService }

class function TFactoryService.GetService(E: string): IServiceBase<TEntitybase>;
var
  Service  : IServiceBase<TEntitybase>;
begin
  if E = 'Cliente' then
     result   := GetService<TCliente>(E ) as IServiceBase<TEntitybase>;
  //...
end;

class function TFactoryService.GetService<T>(E: string ): IServiceBase<T>;
var
  Instance    : TEntitybase;
  pRepository : IRepositoryBase<T>;
  Service     : IServiceBase<T>;
begin
  pRepository := TFactoryRepository.GetRepository<T>(E) as IRepositoryBase<T>;
  Instance    := TAutoMapper.GetInstance<T>( 'Service.'+E+'.TService'+E);
  if Instance <> nil then
  begin
    Service :=  TServiceBase<T>( Instance ).create(pRepository );
    result:= Service;
  end;
end;

end.
