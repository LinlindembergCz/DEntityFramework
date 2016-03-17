unit InterfaceController;

interface

uses
  System.Classes, Vcl.Controls, DBClient, Forms, Dialogs, Vcl.Grids, DB,
  Vcl.DBGrids, Variants, Vcl.StdCtrls,  EnumEntity,Vcl.DBCtrls;


type
  IControllerBase = interface(IInterface)
    ['{0CA799B5-84C6-49D5-8615-ED1278D3043A}']
    procedure SetContener(const Value: TComponent);
    function GetContener:TComponent;

    procedure Read;
    function Load(iId:Integer = 0) : TDataSet;
    procedure Refresh;
    procedure Insert(E: TEnumEntities);
    procedure Edit;
    procedure Delete;
    procedure Post;
    procedure Cancel;
    procedure Apply;
    procedure EntityToDBGrid(Grid: TDBGrid);
    procedure LoadLookUp(DBLookupComboBox: TDBLookupComboBox ;
                         DataSource: TDataSource;
                         parEntity:TEnumEntities);
    property Contener: TComponent read GetContener write SetContener;
  end;

implementation

end.
