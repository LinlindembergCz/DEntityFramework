unit ViewBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Datasnap.Provider, Datasnap.DBClient, Data.DBXMSSQL,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.Bindings.Helper,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls, InterfaceController, FactoryController, EnumEntity;

type
  TFormViewBase = class(TForm)
    dsEntity: TDataSource;
    pgPrincipal: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    grdEntity: TDBGrid;
    Panel2: TPanel;
    Edit1: TEdit;
    Panel1: TPanel;
    btnNew: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    btnPost: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    procedure btnNewClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure grdEntityDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FE: TEnumEntities;
    procedure SetAutoApplyUpdate(const Value: boolean);
    { Private declarations }
  protected
    Controller : IControllerBase;
    FAutoApplyUpdate: boolean;
  public
    { Public declarations }
    property E : TEnumEntities read FE;
    property AutoApplyUpdate : boolean read FAutoApplyUpdate write SetAutoApplyUpdate;
    constructor Create( pController : IControllerBase );
  end;


implementation

{$R *.dfm}

constructor TFormViewBase.Create( pController : IControllerBase );
begin
  Controller := pController;
  Controller.Contener := self;
  inherited Create(Application);
  dsEntity.DataSet := Controller.Load;
  Controller.EntityToDBGrid(grdEntity);
  pgPrincipal.ActivePageIndex:= 0;
  AutoApplyUpdate := true;
end;

procedure TFormViewBase.grdEntityDblClick(Sender: TObject);
begin
  Controller.Read;
end;

procedure TFormViewBase.SetAutoApplyUpdate(const Value: boolean);
begin
  FAutoApplyUpdate := Value;
end;

procedure TFormViewBase.btnNewClick(Sender: TObject);
begin
  Controller.Insert(FE);
end;

procedure TFormViewBase.btnEditClick(Sender: TObject);
begin
  Controller.Edit;
end;

procedure TFormViewBase.btnRemoveClick(Sender: TObject);
begin
  Controller.Delete;
end;

procedure TFormViewBase.btnPostClick(Sender: TObject);
begin
  Controller.Post;
end;

procedure TFormViewBase.btnApplyClick(Sender: TObject);
begin
  Controller.Apply;
  pgPrincipal.ActivePageIndex:= 0;
end;

procedure TFormViewBase.btnCancelClick(Sender: TObject);
begin
  Controller.Cancel;
end;

procedure TFormViewBase.Button2Click(Sender: TObject);
begin
  Controller.Refresh;
end;

procedure TFormViewBase.Button1Click(Sender: TObject);
begin
  dsEntity.DataSet.prior;
  Controller.Read;
end;

procedure TFormViewBase.Button3Click(Sender: TObject);
begin
  dsEntity.DataSet.Next;
  Controller.Read;
end;

end.


