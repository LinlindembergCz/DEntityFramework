unit Principal;

interface

uses System.Classes, System.Actions, Vcl.ActnList, Vcl.Forms,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, System.ImageList, Vcl.ImgList,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormPrincipal = class(TForm)
    ImageList2: TImageList;
    ActionManager2: TActionManager;
    Cliente: TAction;
    Action3: TAction;
    Action4: TAction;
    StatusBar1: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    procedure ClienteExecute(Sender: TObject);
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
  FactoryView;

procedure TFormPrincipal.ClienteExecute(Sender: TObject);
begin
   TFactoryForm.GetForm( Cliente.Name );
end;

procedure TFormPrincipal.Button2Click(Sender: TObject);
begin
   TFactoryForm.GetDinamicForm( Cliente.Name );
end;

end.


