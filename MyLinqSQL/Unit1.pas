unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider,
  Data.DB, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids,Atributies, EntityBase,
  EntityTypes, EntityFramework,EntityFDConnection, EntitySQLConnection,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client;

type
  [EntityTable('Clientes')]
  TCliente = class(TEntityBase)
  private
    FBairro: TString;
    FUF: TString;
    FCodigo: TString;
    FCidade: TString;
    FNomeFantasia: TString;
  public
    constructor Create;override;
  published
    property Codigo: TString read FCodigo write FCodigo;
    property NomeFantasia: TString read FNomeFantasia write FNomeFantasia;
    property UF: TString read FUF write FUF;
    property Bairro: TString read FBairro write FBairro;
    property Cidade: TString read FCidade write FCidade;
  end;

  [EntityTable('ClientesAssociados')]
  TClientesAssociados = class(TEntityBase)
  private
    FCODCLI: TString;
    FNome: TString;
  published
    property Nome: TString read FNome write FNome;
    property CODCLI :TString read FCODCLI write FCODCLI;
  end;

  TForm1 = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    dbgrd1: TDBGrid;
    DataSource1: TDataSource;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    DataContext: TDataContext;
    Cliente: TCliente;
    ClientesAssociados:TClientesAssociados;
   end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses LinqSQL;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Cliente     := TCliente.Create;

   DataContext := TDataContext.Create( Cliente );

   DataContext.Connection:= TEntitySQLConnection.create('Firebird',
                                                        'SYSDBA',
                                                        'masterkey',
                                                        'localhost',
                                                        'D:\Producao\PostoOnLinePDV\Clientes\Planalto\POSTO.FDB');
end;

procedure TForm1.btn1Click(Sender: TObject);
var
  QueryAble: TQueryAble;
begin
  QueryAble := From(Cliente ).Order(Cliente.Id).Select([ Cliente.Id, Cliente.NomeFantasia ]);

  mmo1.Text := DataContext.GetQuery(QueryAble);

  DataSource1.DataSet := DataContext.GetDataSet( QueryAble );

end;

constructor TCliente.Create;
begin
  inherited;
end;


end.
