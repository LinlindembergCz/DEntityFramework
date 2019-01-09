unit viewOrcamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, viewItensBase, Data.DB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.DBCtrls;

type
  TFormViewOrcamento = class(TFormViewItensBase)
    Data: TDateTimePicker;
    Label5: TLabel;
    Valor: TEdit;
    cboIdCliente: TDBLookupComboBox;
    srcClientes: TDataSource;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormViewOrcamento: TFormViewOrcamento;

implementation

{$R *.dfm}

uses FactoryEntity;

procedure TFormViewOrcamento.FormShow(Sender: TObject);
begin
  MyEntityItens := tpItensOrcamento;
  inherited;
  Controller.LoadLookUp( cboIdCliente, srcClientes, tpCliente  );
end;

end.
