unit FactoryController;

interface

uses
  Forms,  Sysutils, EnumEntity, InterfaceController, System.Classes, RTTI;

type
  TFactoryController = class
  public
    class function GetController(E: TEnumEntities ): IControllerBase;Virtual;
  end;

implementation

{ TFactoryEntity }

uses
InterfaceService, FactoryService, ControllerBase,
ControllerCliente, ControllerFornecedor, ControllerFabricante;//ControllerEntity;

class function TFactoryController.GetController( E: TEnumEntities ): IControllerBase;
var
  Instance      : TObject;
begin
   case E of
      tpCliente: result := TControllerCliente.create( TFactoryService.GetService(E) );
      tpFornecedor: result := TControllerFornecedor.Create( TFactoryService.GetService(E) );
      tpFabricante: result := TControllerFabricante.Create( TFactoryService.GetService(E) );
//tpEntity: result := TControllerEntity.Create( TFactoryService.GetService(E) );
   end;
end;

end.
