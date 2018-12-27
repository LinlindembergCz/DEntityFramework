unit InterfaceController;

interface

uses
  System.Classes, Vcl.Controls, DBClient, Forms, Dialogs, Vcl.Grids, DB,
  Vcl.DBGrids, Variants, Vcl.StdCtrls,  FactoryEntity,Vcl.DBCtrls;


type
  IControllerBase = interface(IInterface)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    procedure SetContener(const Value: TComponent);
    function GetContener:TComponent;
    procedure SetAutoApply(const Value: boolean);
    function GetAutoApply:boolean;

    procedure Read;
    function Load(iId:Integer; Fields: string = '') : TDataSet;
    procedure Refresh;
    procedure Insert;
    procedure Edit;
    procedure Delete;
    procedure Post;
    procedure Cancel;
    procedure Apply;
    procedure EntityToDBGrid(Grid: TDBGrid);
    procedure LoadLookUp(DBLookupComboBox: TDBLookupComboBox ;
                         DataSource: TDataSource;
                         parEntity: string);
    property Contener: TComponent read GetContener write SetContener;
    property AutoApply :boolean read GetAutoApply write SetAutoApply;
  end;

implementation

end.
