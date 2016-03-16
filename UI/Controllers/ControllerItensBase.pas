unit ControllerItensBase;

interface

uses
  Data.DB , Forms,InterfaceController, ControllerBase,
  EntityBase, DBClient, InterfaceControllerItens, viewItensBase;

type
  TControllerItensBase = class(TControllerBase, IControllerItensBase)
  private
  protected
    FViewItensBase:TFormViewItensBase;
  public
    procedure Apply(MasterController:IController);reintroduce;virtual;
    property ViewItensBase: TFormViewItensBase read FViewItensBase write FViewItensBase;
  end;

implementation { TControllerItensBase }

uses Entities, EnumEntity;

procedure TControllerItensBase.Apply(MasterController:IController);
var lsField:string;
begin
  //lsField := copy(prsFieldIdEntity, Pos('.',prsFieldIdEntity)+1, length( prsFieldIdEntity) );
 { EntityDataSet.First;
  while not EntityDataSet.eof do
  begin
    EntityDataSet.Edit;
    EntityDataSet.FieldByName( (App.GetContext.Entity as TItensORcamento).IdOrcamento ).Value:=
    (MasterController as TControllerBase).App.GetContext.Entity.Id.Value;
  //MasterEntity.Id.Value;//(MasterEntity.Id as TOrcamento).Id.Value;
    EntityDataSet.post;

    EntityDataSet.Next;
  end; }
  inherited Apply;
end;


end.
