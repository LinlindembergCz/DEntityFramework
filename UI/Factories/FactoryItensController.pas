unit FactoryItensController;

interface

uses
  EntityFramework, Forms,  Sysutils, EnumEntity, ControllerItensBase, InterfaceControllerItens,
  System.Classes;

type
  TFactoryItensController = class
  public
    class function GetItensController(Component: TComponent;
                                    aEntities: TEnumEntities ): IControllerItensBase;Virtual;
  end;

implementation

{ TFactoryEntity }

uses ControllerItensOrcamento;

class function TFactoryItensController.GetItensController(Component: TComponent ;
                                                             aEntities: TEnumEntities ): IControllerItensBase;
begin
   case aEntities of
      tpEntity : result := nil;
      tpItensOrcamento:result := TControllerItensOrcamento.Create( Component , aEntities );
   else
      result := TControllerItensBase.Create( Component , aEntities );
   end;
end;

end.
