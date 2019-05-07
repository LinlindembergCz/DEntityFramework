unit FactoryView;

interface

uses
  Forms, Sysutils, FactoryEntity, Dialogs, ViewBase;

type
  TFactoryForm = class
  private
    class procedure ShowForm(Form: TForm; modal: boolean);
  public
    class function GetForm(E: string; modal:boolean = true ):TFormViewBase;
    class function GetDinamicForm(E: string; modal: boolean = true): TFormViewBase; static;
  end;

implementation

uses
App.Interfaces.ControllerBase, FactoryController, EF.Mapping.AutoMapper;

class procedure TFactoryForm.ShowForm(Form:TForm;modal:boolean);
begin
  if modal then
  begin
     Form.showmodal;
     Form.Free;
     Form:= nil;
  end
  else
  begin
    Form.show;
  end;
end;

class function TFactoryForm.GetDinamicForm(E: string; modal:boolean = true ):TFormViewBase;
var
  Form          : TFormViewBase;
    ControllerQuery : IControllerBase;
  ControllerCommand : IControllerBase;
begin
  result:= nil;
  ControllerQuery   := TFactoryController.GetController( E );
  ControllerCommand := TFactoryController.GetController( E );
  Form := TFormViewBase.create( ControllerQuery, ControllerCommand );
  if Form <> nil then
  begin
    TAutoMapper.CreateDinamicView( TFactoryEntity.GetEntity(E) , Form, Form.TabSheet2);
    ShowForm( Form , modal);
    if Form is TFormViewBase then
      result:= Form
    else
      showmessage('Formulário não implementado!');
  end
  else
    showmessage('Formulário não implementado!');
end;

class function TFactoryForm.GetForm(E: string; modal:boolean = true ):TFormViewBase;
var
  Form          : TFormViewBase;
  Instance      : TFormViewBase;
  ControllerQuery : IControllerBase;
  ControllerCommand : IControllerBase;
begin
  result:= nil;
  Instance := TFormViewBase( TAutoMapper.GetInstance2( 'view'+E+'.TFormView'+ E ) );

  if Instance <> nil then
  begin
     ControllerQuery   := TFactoryController.GetController( E );
     ControllerCommand := TFactoryController.GetController( E );
     Form := Instance.Create( ControllerQuery, ControllerCommand );
     if Form <> nil then
     begin
        ShowForm( Form , modal);
        if Form is TFormViewBase then
           result:= Form
        else
           showmessage('Formulário não implementado!');
     end
     else
        showmessage('Formulário não implementado!');
  end;
end;

end.
