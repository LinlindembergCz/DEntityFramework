unit viewFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewBase, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type
  TFormViewFornecedor = class(TFormViewBase)
    edtRazaoSocial: TEdit;
    edtCNPJ: TEdit;
    edtEndereco: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormViewFornecedor: TFormViewFornecedor;

implementation

{$R *.dfm}
initialization RegisterClass(TFormViewFornecedor);
finalization UnRegisterClass(TFormViewFornecedor);

end.
