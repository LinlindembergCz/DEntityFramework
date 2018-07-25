unit ViewBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Datasnap.Provider, Datasnap.DBClient, Data.DBXMSSQL,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.Bindings.Helper, strUtils,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls, InterfaceController, FactoryController,
  FactoryEntity, Data.Bind.ObjectScope;


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
    procedure btnApplyClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure grdEntityDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FEnumEntities: TEnumEntities;
    procedure SetAutoApplyUpdate(const Value: boolean);
    procedure LoadViewModel;
    function GetViewModel: TStringList;
    { Private declarations }
  protected
    ControllerQuery : IControllerBase;
    ControllerCommand: IControllerBase;
    FAutoApplyUpdate: boolean;
  public
    { Public declarations }
    property EnumEntities : TEnumEntities read FEnumEntities;
    property AutoApplyUpdate : boolean read FAutoApplyUpdate write SetAutoApplyUpdate;
    constructor Create( pControllerQuery : IControllerBase; pControllerCommand : IControllerBase );
  end;

implementation

{$R *.dfm}

constructor TFormViewBase.Create( pControllerQuery : IControllerBase; pControllerCommand : IControllerBase );
begin
  ControllerQuery := pControllerQuery;
  ControllerCommand := pControllerCommand;
  ControllerCommand.Contener := self;
  inherited Create(Application);
  LoadViewModel;
  pgPrincipal.ActivePageIndex:= 0;
  AutoApplyUpdate := true;
end;

function TFormViewBase.GetViewModel:TStringList;
var
   ViewModelList: TStringList;
   I: Integer;
begin
   ViewModelList := TStringList.Create;
   ViewModelList.Delimiter := ',';
   if grdEntity.Columns.Count > 1 then
   begin
     for I := 0 to grdEntity.Columns.Count - 1 do
     begin
       ViewModelList.Add( ifthen( grdEntity.Columns[I].ImeName <> '',
                                  grdEntity.Columns[I].ImeName ,
                                  grdEntity.Columns[I].FieldName ) );
     end;
   end;
   result :=  ViewModelList;
end;

procedure TFormViewBase.LoadViewModel;
var
   ViewModelList: TStringList;
begin
   ControllerQuery.EntityToDBGrid(grdEntity);
   ViewModelList := GetViewModel;
   if ViewModelList.Count > 0 then
   begin
     dsEntity.DataSet := ControllerQuery.Load(0, ViewModelList.DelimitedText);
   end
   else
   begin
     dsEntity.DataSet := ControllerQuery.Load(0);
   end;
end;

procedure TFormViewBase.grdEntityDblClick(Sender: TObject);
begin
  ControllerCommand.Load(dsEntity.DataSet.FieldByName('ID').AsInteger);
  ControllerCommand.Read;
end;

procedure TFormViewBase.SetAutoApplyUpdate(const Value: boolean);
begin
  FAutoApplyUpdate := Value;
end;

procedure TFormViewBase.btnNewClick(Sender: TObject);
begin
  ControllerCommand.Load(-1);
  ControllerCommand.Insert(FEnumEntities);
end;

procedure TFormViewBase.btnEditClick(Sender: TObject);
begin
  ControllerCommand.Load(dsEntity.DataSet.FieldByName('ID').AsInteger);
  ControllerCommand.Edit;
end;

procedure TFormViewBase.btnRemoveClick(Sender: TObject);
begin
  ControllerQuery.Delete;
end;

procedure TFormViewBase.btnPostClick(Sender: TObject);
begin
  ControllerCommand.Post;
  ControllerQuery.Refresh;
end;

procedure TFormViewBase.btnApplyClick(Sender: TObject);
begin
  ControllerCommand.Apply;
  pgPrincipal.ActivePageIndex:= 0;
end;

procedure TFormViewBase.btnCancelClick(Sender: TObject);
begin
  ControllerCommand.Cancel;
end;

procedure TFormViewBase.Button1Click(Sender: TObject);
begin
  dsEntity.DataSet.prior;
  ControllerQuery.Load(dsEntity.DataSet.FieldByName('ID').AsInteger);
  ControllerQuery.Read;
end;

procedure TFormViewBase.Button3Click(Sender: TObject);
begin
  dsEntity.DataSet.Next;
  ControllerQuery.Load(dsEntity.DataSet.FieldByName('ID').AsInteger);
  ControllerQuery.Read;
end;

end.


