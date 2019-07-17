unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Domain.Entity.Cliente,
  EF.Engine.DataContext, EF.QueryAble.base, Vcl.ExtCtrls, Datasnap.DBClient;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    Button1: TButton;
    panelButtons: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
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
    Button9: TButton;
    procedure FormCreate(Sender: TObject);
    procedure buttonGetDataSetClick(Sender: TObject);
    procedure buttonGetSQLClick(Sender: TObject);
    procedure buttonGetEntityClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

uses UDataModule, EF.Mapping.AutoMapper,
     Domain.Entity.Contato, EF.Core.Types,
  EF.Core.List;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Context.free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Context := TDataContext<TCliente>.Create;
  Context.Connection := DataModule1.FConnection;
  E:= Context.Entity;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   QueryAble := From( E )
               .Select
               .Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

   E := Context.Find<TCliente>( QueryAble );

   mLog.Text:= E.ToJson;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Context.Entity.FromJson(mLog.Text);

  mLog.Text:= Context.Entity.ToJson;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   C:TCliente;
   contato: TContato;
begin
  if DataSource1.DataSet <> nil then
  begin
     try
       C := Context.Include(E.Veiculo).
                      Include(E.Contatos).
                      Where( E.ID = DataSource1.DataSet.FieldByName('ID').AsInteger );

       mlog.Lines.Add('ID: ' + C.ID.Value.ToString );
       mlog.Lines.Add('Nome: ' + C.Nome.Value);

       mlog.Lines.Add('Veiculo: ' + C.Veiculo.Placa.Value);
       mlog.Lines.Add('Contatos :');
       for contato in C.Contatos do
       begin
          mlog.Lines.Add('    ' + contato.Nome.Value);
       end;
     finally
       FreeAndNIL(C);
     end;
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  C:TCliente;
  contato:TContato;
begin
   if DataSource1.DataSet <> nil then
   begin
     C := Context.Include(E.Contatos).
                  Include(E.ClienteEmpresa).
                  ThenInclude(E.ClienteEmpresa.Empresa).
                  Where( E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger);

     mlog.Lines.Add('Empresa : ' + C.ClienteEmpresa.Empresa.Descricao.Value);
     mlog.Lines.Add('ID : ' + C.ID.Value.ToString );
     mlog.Lines.Add('Cliente : ' +C.Nome.Value);
     mlog.Lines.Add('Contatos :');
     for contato in C.Contatos do
     begin
        mlog.Lines.Add('    ' + contato.Nome.Value);
     end;

     FreeAndNIL(C);
   end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  C: TCliente;
begin
  try
    C := TCliente.Create;
    C.Nome:= 'JOAO Cristo de nazare';
    C.NomeFantasia:= 'jesus Cristo de nazare';
    C.CPFCNPJ:= '02316937455';
    C.RG:= '1552666';
    C.Ativo:= '1';
    C.DataNascimento := strtodate('19/04/1976');
    C.Email.value := 'lindemberg.desenvolvimento@gmail.com';

    C.Validate;

    Context.Add(C, true);

    //Context.SaveChanges;

  finally
    C.Free;
    QueryAble:= From( E ).Select.OrderBy(E.Nome);
    DataSource1.DataSet := Context.ToDataSet(QueryAble );
  end;

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
   if (DataSource1.DataSet <> nil) and (DataSource1.DataSet.RecordCount > 0) then
   begin
      TAutoMapper.DataToEntity( DataSource1.DataSet, E );

      E.Nome.Value:= 'Nome do Cliente '+datetimetostr(now);

      Context.Update(true);

      //Context.SaveChanges;
   end;
   QueryAble := From( E ).Select.OrderBy ( E.Nome );
   DataSource1.DataSet := Context.ToDataSet( QueryAble );
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  L:TEntityList<TCliente>;
  C:TCliente;
begin
   mlog.Lines.clear;
   L := Context.ToList( E.Ativo = '1' );
   for C in L do
   begin
      mlog.Lines.Add('ID: ' + C.ID.Value.ToString +'       Nome: ' + C.Nome.Value);
   end;
   FreeAndNil( L );
end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
begin
   QueryAble := From( E ).Select.OrderBy ( E.Nome );
   DataSource1.DataSet := Context.ToDataSet( QueryAble );
end;

procedure TForm1.buttonGetEntityClick(Sender: TObject);
begin
   if DataSource1.DataSet <> nil then
   begin
     QueryAble := From( E ).
                  Select.
                  Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );
     E := Context.Find<TCliente>( QueryAble );
     mlog.Lines.Add('ID: ' + E.ID.Value.ToString+'      Nome: ' + E.Nome.Value);
   end;
end;

procedure TForm1.buttonGetSQLClick(Sender: TObject);
begin
   QueryAble := From   ( E )
                .Select([ E.Id, E.Nome, E.Observacao ])
                .OrderBy ( E.Nome );
   mlog.Lines.Text := Context.GetQuery( QueryAble );
end;

end.
