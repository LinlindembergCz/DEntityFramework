unit FactoryService;

interface

uses
    EnumEntity, InterfaceService;

type
   TFactoryService = class
   public
     class function GetService( E: TEnumEntities ):IService;
   end;

implementation

uses ClienteService, FactoryRepository, InterfaceRepository, ServiceFornecedor,
  ServiceFabricante;//ServiceEntity;

{ TFactoryService }

class function TFactoryService.GetService(E: TEnumEntities): IService;
begin
  case E of
    tpCliente: result:= TClienteService.Create( TFactoryRepository.GetRepository( E ) );
    tpFornecedor: result:= TServiceFornecedor.Create( TFactoryRepository.GetRepository( E ) );
    tpFabricante: result:= TServiceFabricante.Create( TFactoryRepository.GetRepository( E ) );
//tpEntity: result:= TServiceEntity.Create( TFactoryRepository.GetRepository( E ) );

  end;
end;

end.
