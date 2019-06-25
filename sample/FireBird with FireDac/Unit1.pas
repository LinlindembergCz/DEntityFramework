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
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure buttonLoadDataClick(Sender: TObject);
    procedure buttonGetDataSetClick(Sender: TObject);
    procedure buttonGetSQLClick(Sender: TObject);
    procedure buttonGetEntityClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
     E: TCliente;
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

begin
  E:= TCliente.Create;
  E.Mapped := TAutoMapper.ToMapping(E, true, false );
  Context := TDataContext<TCliente>.Create( E );
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

procedure TForm1.Button4Click(Sender: TObject);
var
  C:TCliente;
begin
    C:= Context.Include(E.Veiculo).Where<TCliente>( E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger );

    mlog.Lines.Add('ID: ' + C.ID.Value.ToString );
    mlog.Lines.Add('Nome: ' + C.Nome.Value);
    mlog.Lines.Add('Veiculo: ' + C.Veiculo.Placa.Value);

    FreeAndNIL(C);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  C:TCliente;
begin
    C:= Context.Include(E.ClienteEmpresa).
                ThenInclude(E.ClienteEmpresa.Empresa).
                Where<TCliente>( E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger );

    mlog.Lines.Add('ID: ' + C.ID.Value.ToString );
    mlog.Lines.Add('Nome: ' + C.Nome.Value);
    mlog.Lines.Add('Empresa: ' + C.ClienteEmpresa.Empresa.Descricao.Value);

    FreeAndNIL(C);

end;

procedure TForm1.Button6Click(Sender: TObject);
var
  //C:  TDataContext<TCliente>;
  E: TCliente;
begin
  //E.Mapped := TAutoMapper.ToMapping(E, true, false );
  //C:= TDataContext<TCliente>.Create( E );
  //C.Connection := DataModule1.FConnection;

  E:= TCliente.Create;

  E.Nome:= 'jesus Cristo de nazare';
  E.NomeFantasia:= 'jesus Cristo de nazare';
  E.CPFCNPJ:= '02316937454';
  E.RG:= '1552666';
  E.Ativo:= '1';
  E.DataNascimento := strtodate('19/04/1976');
  E.Email.value := 'lindemberg.desenvolvimento@gmail.com';

  Context.Entity:= E;

  Context.Add;

  Context.SaveChanges;

  buttonGetDataSet.Click;

end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
begin
 QueryAble := From( E ).Select.OrderBy ( E.Nome );
 DataSource1.DataSet := Context.ToDataSet( QueryAble );
end;

procedure TForm1.buttonGetEntityClick(Sender: TObject);
begin
 QueryAble := From   ( E )
              .Select
              .Where ( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );
 Context.Entity := Context.Find( QueryAble );

 mlog.Lines.Add('ID: ' + E.ID.Value.ToString );
 mlog.Lines.Add('Nome: ' + E.Nome.Value);
end;

procedure TForm1.buttonGetSQLClick(Sender: TObject);
begin
 QueryAble := From   ( E )
              .Select([ E.Id, E.Nome, E.Observacao ])
              .OrderBy ( E.Nome );
 mlog.Lines.Text := Context.GetQuery( QueryAble );
end;

procedure TForm1.buttonLoadDataClick(Sender: TObject);
begin
 QueryAble := From( E )
              .Select
              .OrderBy ( E.Nome );
 DataSource1.DataSet := ClientDataSet1;
 ClientDataSet1.Data := Context.ToData( QueryAble );
end;

end.
