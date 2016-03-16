unit viewItensBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewBase,
  Vcl.StdCtrls, EnumEntity, InterfaceController, Vcl.ComCtrls, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, InterfaceControllerItens, ControllerBase, Vcl.DBCtrls;

type
  TFormViewItensBase = class(TFormViewBase)
    pnlItens: TPanel;
    Quantidade: TEdit;
    dsEntityItens: TDataSource;
    grdItens: TDBGrid;
    Label3: TLabel;
    Label4: TLabel;
    Button4: TButton;
    cboIdProduto: TDBLookupComboBox;
    srcProdutos: TDataSource;
    Button5: TButton;
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ItensController: IControllerItensBase;
    MyEntityItens: TEnumEntities;
  end;

var
  FormViewItensBase: TFormViewItensBase;

implementation

{$R *.dfm}

uses FactoryItensController, ControllerItensBase;

procedure TFormViewItensBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(ItensController);
end;

procedure TFormViewItensBase.FormCreate(Sender: TObject);
begin
   //ItensController := TFactoryItensController.GetItensController( pnlItens , MyEntityItens );
  inherited;
end;

procedure TFormViewItensBase.FormShow(Sender: TObject);
begin
  inherited;
 ItensController := TFactoryItensController.GetItensController( pnlItens , MyEntityItens );
end;

procedure TFormViewItensBase.TabSheet2Show(Sender: TObject);
begin
  inherited;
  with ItensController as TControllerItensBase do
  begin
    dsEntityItens.DataSet := Load( dsEntity.DataSet.FieldByName('Id').AsInteger );
    EntityToDBGrid(grdItens);
    ViewItensBase := self;
    Controller.LoadLookUp( cboIdProduto, srcProdutos, tpProduto );
  end;
end;

procedure TFormViewItensBase.Button5Click(Sender: TObject);
begin
  inherited;
  ItensController.Post;
end;

procedure TFormViewItensBase.btnCancelClick(Sender: TObject);
begin
  inherited;
  dsEntityItens.DataSet := ItensController.Load( dsEntity.DataSet.FieldByName('Id').AsInteger );
end;

procedure TFormViewItensBase.btnNewClick(Sender: TObject);
begin
  inherited;
  dsEntityItens.DataSet := ItensController.Load( 0 );
end;

procedure TFormViewItensBase.btnPostClick(Sender: TObject);
begin
  inherited;
  ItensController.Apply(Controller);
end;

procedure TFormViewItensBase.Button4Click(Sender: TObject);
begin
  inherited;
  ItensController.Delete;
end;

end.
