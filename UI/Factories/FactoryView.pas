unit FactoryView;

interface

uses
  Forms, Sysutils, EnumEntity, Dialogs, ViewBase;

type
  TFactoryForm = class
  private
    class function GetFormClassName(E: TEnumEntities): string; static;
    class procedure ShowForm(Form: TForm; modal: boolean);

  public
    class function GetForm(E: TEnumEntities; modal:boolean = true ):TFormViewBase;
    class function GetDinamicForm(E: TEnumEntities; modal: boolean = true): TFormViewBase; static;
  end;

implementation

uses
InterfaceController, FactoryController, AutoMapper, FactoryEntity;

class function TFactoryForm.GetFormClassName( E: TEnumEntities):string;
begin
  case E of
     tpCliente   : result:= 'viewCliente.TFormViewCliente';
     tpFornecedor: result:= 'viewFornecedor.TFormViewFornecedor';
     tpFabricante: result:= 'ViewFabricante.TFormViewFabricante';
     tpAluno     : result:= 'viewAluno.TFormViewAluno';
  else
    begin
      showmessage('Verificar declaração "initialization RegisterClass" requerido no form !');
      abort;
    end;
  end;
end;

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

class function TFactoryForm.GetDinamicForm(E: TEnumEntities; modal:boolean = true ):TFormViewBase;
var
  Form          : TFormViewBase;
begin
  result:= nil;

  Form := TFormViewBase.create( TFactoryController.GetController( E ) ,
                                TFactoryController.GetController( E ) );
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

class function TFactoryForm.GetForm(E: TEnumEntities; modal:boolean = true ):TFormViewBase;
var
  Form          : TFormViewBase;
  Instance      : TFormViewBase;
begin
  result:= nil;
  Instance := TFormViewBase( TAutoMapper.GetInstance( GetFormClassName( E ) ) );

  if Instance <> nil then
  begin
    Form := Instance.Create( TFactoryController.GetController( E ) ,
                             TFactoryController.GetController( E )  );
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
