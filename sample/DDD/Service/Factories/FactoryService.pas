unit FactoryService;

interface

uses
    FactoryEntity, InterfaceService, VCL.Dialogs, Sysutils, EF.Mapping.Base;

type
   TFactoryService = class
  private
   public
     class function GetService( E: string ):IServiceBase<TEntitybase>;
   end;

implementation

uses  FactoryRepository, InterfaceRepository, ServiceBase, EF.Mapping.AutoMapper, ClassCliente;//ServiceEntity;

{ TFactoryService }

class function TFactoryService.GetService(E: string): IServiceBase<TEntitybase>;
var
  Service     : IServiceBase<TEntitybase>;
  Instance    : TEntitybase;
begin
  Instance := TAutoMapper.GetInstance<TCliente>( 'Service'+E+'.TService'+E);
  if Instance <> nil then
  begin
    Service :=  TServiceBase<TEntitybase>( Instance ).create( TFactoryRepository.GetRepository<TCliente>(E) );
    result:= Service;
  end;
end;

end.
