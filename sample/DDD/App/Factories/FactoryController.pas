unit FactoryController;

interface

uses
  Forms,  Sysutils, FactoryEntity, App.Interfaces.ControllerBase, System.Classes, RTTI, Dialogs;

type
  TFactoryController = class
  private

  public
    class function GetController(E: string ): IControllerBase;Virtual;
  end;

implementation

{ TFactoryEntity }

uses
  FactoryService, App.Controller.Base, EF.Mapping.AutoMapper;

class function TFactoryController.GetController( E: string ): IControllerBase;
var
  Controller     : IControllerBase;
  Instance      : TObject;
begin
  Instance := TAutoMapper.GetInstance2( 'App.Controller.'+E+'.TController'+ E );
  if Instance <> nil then
  begin
    Controller :=  TControllerBase( Instance ).create( TFactoryService.GetService(E) );
    result:= Controller;
  end;
end;

end.

