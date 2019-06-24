unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  Domain.Entity.Cliente,
  EF.Engine.DataContext,
  EF.QueryAble.base, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Button1: TButton;
    panelButtons: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    panelEdits: TPanel;
    buttonLoadData: TButton;
    buttonGetDataSet: TButton;
    mLog: TMemo;
    buttonGetSQL: TButton;
    buttonGetEntity: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure buttonLoadDataClick(Sender: TObject);
    procedure buttonGetDataSetClick(Sender: TObject);
    procedure buttonGetSQLClick(Sender: TObject);
    procedure buttonGetEntityClick(Sender: TObject);
    procedure buttonUpdateClick(Sender: TObject);
    procedure buttonDeleteClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    Context: TDataContext<TCliente>;
    QueryAble: IQueryAble;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UDataModule, EF.Mapping.AutoMapper;

procedure TForm1.FormCreate(Sender: TObject);
var
  E: TCliente;
begin
  E:= TCliente.Create;
  E.Mapped := TAutoMapper.ToMapping(E, true, false );
  Context := TDataContext<TCliente>.Create( E );
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 Context.Connection := DataModule1.FConnection;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    mLog.Text:=  Context.Entity.ToJson;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Context.Entity.FromJson(mLog.Text);
end;

procedure TForm1.buttonDeleteClick(Sender: TObject);
begin
 Context.Entity.Id := 5;
 Context.RemoveDirect;
end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
begin
 QueryAble := From   ( Context.Entity )
              .Select([ Context.Entity.Id, Context.Entity.Nome, Context.Entity.Observacao ])
              .OrderBy ( Context.Entity.Nome );
 DataSource1.DataSet := Context.ToDataSet( QueryAble );
end;

procedure TForm1.buttonGetEntityClick(Sender: TObject);
begin
 QueryAble := From   ( Context.Entity )
              .Select
              .Where ( Context.Entity.Id = 2 );
 Context.Entity := Context.Find( QueryAble ) as TCliente;
 mlog.Lines.Text := 'Nome: ' + Context.Entity.Nome.Value;
end;

procedure TForm1.buttonGetSQLClick(Sender: TObject);
begin
 QueryAble := From   ( Context.Entity )
              .Select([ Context.Entity.Id, Context.Entity.Nome, Context.Entity.Observacao ])
              .OrderBy ( Context.Entity.Nome );
 mlog.Lines.Text := Context.GetQuery( QueryAble );
end;

procedure TForm1.buttonLoadDataClick(Sender: TObject);
begin
 QueryAble := From   ( Context.Entity )
              .Select([ Context.Entity.Id, Context.Entity.Nome, Context.Entity.Observacao ])
              .OrderBy ( Context.Entity.Nome );
 DataSource1.DataSet := ClientDataSet1;
 ClientDataSet1.Data := Context.ToData( QueryAble );
end;

procedure TForm1.buttonUpdateClick(Sender: TObject);
begin
 QueryAble := From   ( Context.Entity )
              .Select
              .Where ( Context.Entity.Id = 2 );
 Context.Entity := Context.Find( QueryAble ) as TCliente;
 Context.Entity.Observacao := 'Alterado em: ' + datetimeToStr( Now() );
 Context.UpdateDirect;
end;

end.
