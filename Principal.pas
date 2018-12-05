unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  System.ImageList, Vcl.ImgList, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Graphics, Vcl.Forms, Vcl.Dialogs;

type
  TFormPrincipal = class(TForm)
    ImageList2: TImageList;
    ActionManager2: TActionManager;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    StatusBar1: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    procedure Action2Execute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses
  FactoryView, FactoryEntity;


procedure TFormPrincipal.Action2Execute(Sender: TObject);
begin
 // TFactoryForm.GetDinamicForm( tpCliente );
  TFactoryForm.GetForm( 'Cliente' );
end;

procedure TFormPrincipal.Button2Click(Sender: TObject);
begin
   TFactoryForm.GetDinamicForm( 'Cliente' );
end;

end.


