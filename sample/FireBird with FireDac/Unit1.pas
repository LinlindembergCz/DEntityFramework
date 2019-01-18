unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  Entity.Cliente,
  EF.Engine.DataContext,
  EF.QueryAble.base, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Button1: TButton;
    panelButtons: TPanel;
    buttonInsert: TButton;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    panelEdits: TPanel;
    buttonLoadData: TButton;
    buttonGetDataSet: TButton;
    mLog: TMemo;
    buttonGetSQL: TButton;
    buttonGetEntity: TButton;
    buttonUpdate: TButton;
    buttonDelete: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure buttonInsertClick(Sender: TObject);
    procedure buttonLoadDataClick(Sender: TObject);
    procedure buttonGetDataSetClick(Sender: TObject);
    procedure buttonGetSQLClick(Sender: TObject);
    procedure buttonGetEntityClick(Sender: TObject);
    procedure buttonUpdateClick(Sender: TObject);
    procedure buttonDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    Cliente: TCliente;
    Context: TDataContext;
    QueryAble: IQueryAble;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UDataModule;


procedure TForm1.buttonDeleteClick(Sender: TObject);
begin
 Cliente.Id := 5;
 Context.Entity := Cliente;
 Context.DeleteDirect;
end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
begin
 QueryAble := From   ( Cliente )
              .Select([ Cliente.Id, Cliente.Nome, Cliente.Observacao ])
              .OrderBy ( Cliente.Nome );
 DataSource1.DataSet := Context.GetDataSet( QueryAble );
end;

procedure TForm1.buttonGetEntityClick(Sender: TObject);
begin
 QueryAble := From   ( Cliente )
              .Select
              .Where ( Cliente.Id = 2 );
 Cliente := Context.GetEntity( QueryAble ) as TCliente;
 mlog.Lines.Text := 'Nome: ' + Cliente.Nome.Value;
end;

procedure TForm1.buttonGetSQLClick(Sender: TObject);
begin
 QueryAble := From   ( Cliente )
              .Select([ Cliente.Id, Cliente.Nome, Cliente.Observacao ])
              .OrderBy ( Cliente.Nome );
 mlog.Lines.Text := Context.GetQuery( QueryAble );
end;

procedure TForm1.buttonInsertClick(Sender: TObject);
begin
 Cliente.Nome := 'Cliente 1';
 Cliente.NomeFantasia := 'Nro 1';
 Cliente.CPFCNPJ := '11440008866';
 Cliente.Renda := 1500;
 Cliente.Idade := 25;
 Cliente.RG := '99999999-9';
 Cliente.DataNascimento := strtoDate( '28/12/1993' );
 Cliente.Ativo := '1';
 Cliente.Situacao := 'L';
 Cliente.Tipo := 'Fisica';
 Cliente.EstadoCivil := 'Solteiro';
 Cliente.Observacao := 'Compra a cada 3 meses';
 Context.Entity := Cliente;
 Context.InsertDirect;
end;

procedure TForm1.buttonLoadDataClick(Sender: TObject);
begin
 QueryAble := From   ( Cliente )
              .Select([ Cliente.Id, Cliente.Nome, Cliente.Observacao ])
              .OrderBy ( Cliente.Nome );
 DataSource1.DataSet := ClientDataSet1;
 ClientDataSet1.Data := Context.GetData( QueryAble );
end;

procedure TForm1.buttonUpdateClick(Sender: TObject);
begin
 QueryAble := From   ( Cliente )
              .Select
              .Where ( Cliente.Id = 2 );
 Cliente := Context.GetEntity( QueryAble ) as TCliente;
 Cliente.Observacao := 'Alterado em: ' + datetimeToStr( Now() );
 Context.Entity := Cliente;
 Context.UpdateDirect;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Cliente := TCliente.Create;
  Context := TDataContext.Create(Cliente);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 Context.Connection := DataModule1.FConnection;
end;

end.
