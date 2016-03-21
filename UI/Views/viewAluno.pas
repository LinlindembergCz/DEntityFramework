unit viewAluno;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewBase, Vcl.StdCtrls, Data.DB,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type
  TFormViewAluno = class(TFormViewBase)
    Label1: TLabel;
    Label2: TLabel;
    edtNome: TEdit;
    edtMatricula: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormViewAluno: TFormViewAluno;

implementation

{$R *.dfm}

initialization RegisterClass(TFormViewAluno);
finalization UnRegisterClass(TFormViewAluno);

end.
