unit FactoryService;

interface

uses
    FactoryEntity, InterfaceService, Dialogs, Sysutils;

type
   TFactoryService = class
  private
    class function GetServiceClassName(E: TEnumEntities): string; static;
   public
     class function GetService( E: TEnumEntities ):IServiceBase;
   end;

implementation

uses  FactoryRepository, InterfaceRepository, ServiceBase, AutoMapper;//ServiceEntity;

{ TFactoryService }

class function TFactoryService.GetServiceClassName( E: TEnumEntities):string;
begin
  case E of
     tpCliente   : result:= 'ServiceCliente.TServiceCliente';
     tpFornecedor: result:= 'ServiceFornecedor.TServiceFornecedor';
     tpFabricante: result:= 'ServiceFabricante.TServiceFabricante';
       tpAluno : result:= 'ServiceAluno.TServiceAluno';
//tpEntity: result:= ServiceEntity.TServiceEntity;
  else
    begin
      showmessage('Verificar declaração "initialization RegisterClass" requerido do Service !');
      abort;
    end;
  end;
end;

class function TFactoryService.GetService(E: TEnumEntities): IServiceBase;
var
  Service     : IServiceBase;
  Instance      : TObject;
begin
  Instance := TAutoMapper.GetInstance( GetServiceClassName( E ) );
  if Instance <> nil then
  begin
    Service :=  TServiceBase( Instance ).create( TFactoryRepository.GetRepository(E) );
    result:= Service;
  end;
end;

end.
