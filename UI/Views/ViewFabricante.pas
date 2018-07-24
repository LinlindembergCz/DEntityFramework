unit ViewFabricante;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewBase, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type

  TFormViewFabricante = class(TFormViewBase)
    CNPJ: TEdit;
    RazaoSocial: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormViewFabricante: TFormViewFabricante;

implementation

{$R *.dfm}

initialization RegisterClass(TFormViewFabricante);
finalization UnRegisterClass(TFormViewFabricante);


end.
