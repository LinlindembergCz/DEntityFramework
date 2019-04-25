unit viewCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ViewBase, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Datasnap.DBClient, System.Rtti, Vcl.Mask;

type
  TFormViewCliente = class(TFormViewBase)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtRenda: TEdit;
    edtRG: TEdit;
    edtNome: TEdit;
    edtNomeFantasia: TEdit;
    DataNascimento: TDateTimePicker;
    Ativo: TCheckBox;
    cboSituacao: TComboBox;
    rdgTipo: TRadioGroup;
    Observacao: TMemo;
    edtCPFCNPJ: TMaskEdit;
    edtEmail: TEdit;
    Label1: TLabel;
    Button4: TButton;
    Label7: TLabel;
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses UI.Controller.Cliente;

//Nosso crud so precisa disso e mais nada!
procedure TFormViewCliente.Button4Click(Sender: TObject);
begin
  inherited;
  dsEntity.DataSet :=  (ControllerQuery as TControllerCliente).LoadDataSetPorNome( '%'+edit1.Text+'%' );
end;

initialization RegisterClass(TFormViewCliente);
finalization UnRegisterClass(TFormViewCliente);

end.
