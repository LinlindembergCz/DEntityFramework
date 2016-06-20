unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.FMTBcd,
  Datasnap.Provider, Data.DB, Data.SqlExpr, Vcl.ExtCtrls, Vcl.Mask,
  FireDAC.Phys.MSSQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Comp.Client, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.Ribbon, Vcl.RibbonLunaStyleActnCtrls, Vcl.ActnMenus, Vcl.RibbonActnMenus,
  Vcl.ComCtrls, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.DataSet,
  FireDAC.Phys.SQLiteVDataSet, FireDAC.Comp.DataSet, FireDAC.Stan.StorageBin;

type
  TFormPrincipal = class(TForm)
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    RibbonQuickAccessToolbar1: TRibbonQuickAccessToolbar;
    ImageList2: TImageList;
    ActionManager2: TActionManager;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    StatusBar1: TStatusBar;
    procedure Button3Click(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
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
  FactoryView, EnumEntity, AutoMapper,  ClassAluno, FactoryEntity,
  ViewBase;


procedure TFormPrincipal.Action2Execute(Sender: TObject);
begin
 // TFactoryForm.GetDinamicForm( tpCliente );
  TFactoryForm.GetForm( tpCliente );
end;

procedure TFormPrincipal.Action3Execute(Sender: TObject);
begin
  TFactoryForm.GetForm( tpFornecedor );
end;

procedure TFormPrincipal.Action4Execute(Sender: TObject);
begin
TFactoryForm.GetForm( tpFabricante );
end;

procedure TFormPrincipal.Button3Click(Sender: TObject);
begin
  TFactoryForm.GetDinamicForm( tpAluno );
  //TFactoryForm.GetForm( tpAluno );
end;

end.


