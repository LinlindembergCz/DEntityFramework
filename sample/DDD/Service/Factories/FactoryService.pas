unit FactoryService;

interface

uses
    FactoryEntity, InterfaceService, InterfaceRepository, VCL.Dialogs, Sysutils, EF.Mapping.Base;

type
   TFactoryService = class
   private
     class function GetServiceCliente(E: string; var pRepository : IRepositoryBase<TEntitybase>): TEntitybase;
   public
     class function GetService( E: string ):IServiceBase<TEntitybase>;
   end;

implementation

uses  FactoryRepository, ServiceBase, EF.Mapping.AutoMapper, ClassCliente;//ServiceEntity;

{ TFactoryService }

class function TFactoryService.GetService(E: string): IServiceBase<TEntitybase>;
var
  Service     : IServiceBase<TEntitybase>;
  Instance    : TEntitybase;
  pRepository : IRepositoryBase<TEntitybase>;
begin
  Instance := GetServiceCliente(E, pRepository );
  if Instance <> nil then
  begin
    Service :=  TServiceBase<TEntitybase>( Instance ).create(pRepository );
    result:= Service;
  end;
end;

class function TFactoryService.GetServiceCliente(E: string; var pRepository : IRepositoryBase<TEntitybase> ): TEntitybase;
begin
  pRepository := TFactoryRepository.GetRepository<TCliente>(E);
  result      := TAutoMapper.GetInstance<TCliente>( 'Service'+E+'.TService'+E);
end;

end.
