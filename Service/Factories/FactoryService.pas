unit FactoryService;

interface

uses
    FactoryEntity, InterfaceService, VCL.Dialogs, Sysutils;

type
   TFactoryService = class
  private
   public
     class function GetService( E: string ):IServiceBase;
   end;

implementation

uses  FactoryRepository, InterfaceRepository, ServiceBase, EF.Mapping.AutoMapper;//ServiceEntity;

{ TFactoryService }

class function TFactoryService.GetService(E: string): IServiceBase;
var
  Service     : IServiceBase;
  Instance      : TObject;
begin
  Instance := TAutoMapper.GetInstance(  'Service'+E+'.TService'+E );
  if Instance <> nil then
  begin
    Service :=  TServiceBase( Instance ).create( TFactoryRepository.GetRepository(E) );
    result:= Service;
  end;
end;

end.
