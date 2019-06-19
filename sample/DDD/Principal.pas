unit Principal;

interface

uses
  System.Classes, System.Actions, Vcl.ActnList, Vcl.Forms,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, System.ImageList, Vcl.ImgList,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client;

type
  TFormPrincipal = class(TForm)
    ActionManager2: TActionManager;
    Cliente: TAction;
    Action3: TAction;
    Action4: TAction;
    StatusBar1: TStatusBar;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure ClienteExecute(Sender: TObject);
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

end.


