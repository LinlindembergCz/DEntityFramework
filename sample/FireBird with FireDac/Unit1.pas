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
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
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
    procedure Button10Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
  private
     E: TCliente;
    { Private declarations }
  public
    Context: TDbContext<TCliente>;
    QueryAble: IQueryAble;
  //E2: TvwCliente;
  //Context2: TDbContext<TvwCliente>;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UDataModule, EF.Mapping.AutoMapper,
     Domain.Entity.Contato, EF.Core.Types,
  EF.Core.List, System.Generics.Collections;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Context := TDbContext<TCliente>.Create(DataModule1.FConnection);
  E:= Context.Entity;
end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
begin
   QueryAble := From( E ).Select.OrderBy ( E.Nome );

   DataSource1.DataSet := Context.ToDataSet( QueryAble );

   //QueryAble := From( E2 ).Select.OrderBy ( E2.Nome );
   //DataSource1.DataSet := Context2.ToDataSet( QueryAble );
end;

procedure TForm1.buttonGetEntityClick(Sender: TObject);
begin
   if DataSource1.DataSet <> nil then
   begin
     QueryAble := From( E ).
                  Select.
                  Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

     E := Context.Find( QueryAble  );

     mlog.Lines.Add('ID: ' + E.ID.Value.ToString);
     mlog.Lines.Add( ' Nome:'+ E.Nome.Value);
     mlog.Lines.Add( ' CNPJ:'+ E.CPFCNPJ.Value);
     mlog.Lines.Add( ' Estado Civil:'+ E.EstadoCivil.Value);
     mlog.Lines.Add( ' Nascimento:'+ datetostr(E.DataNascimento.Value));
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   QueryAble := From( E )
               .Select
               .Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

   E := Context.Find( QueryAble );

   mLog.Text:= E.ToJson;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  L:Collection<TCliente>;
  C:TCliente;
begin
   mlog.Lines.clear;

   L := Context.ToList( E.Ativo = '1' );

   for C in L do
   begin
      mlog.Lines.Add('ID: ' + C.ID.Value.ToString +'       Nome: ' + C.Nome.Value+'       CNPJ: ' + C.CPFCNPJ.Value);
   end;

   FreeAndNil( L );
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  C:TCliente;
  contato:TContato;
begin
   if DataSource1.DataSet <> nil then
   begin
     C := Context.Include(E.Contatos).
                  Include(E.Veiculo).
                  Include(E.ClienteEmpresa).
                  ThenInclude(E.ClienteEmpresa.Empresa).
                  Where( E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger);

     mlog.Lines.Add('Empresa : ' + C.ClienteEmpresa.Empresa.Descricao.Value);
     mlog.Lines.Add('ID : ' + C.ID.Value.ToString );
     mlog.Lines.Add('Cliente : ' +C.Nome.Value);
     mlog.Lines.Add('Veiculo: ' + C.Veiculo.Placa.Value);
     mlog.Lines.Add('Contatos :');

     for contato in C.Contatos do
     begin
        mlog.Lines.Add('    ' + contato.Nome.Value);
     end;

     FreeAndNIL(C);
   end;
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

procedure TForm1.Button13Click(Sender: TObject);
begin
   Context.SaveChanges;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  I:integer;
  C: TCliente;
  Clientes : TObjectList<TCliente>;
begin
  try
    Clientes := TObjectList<TCliente>.create;

    for I := 0 to 2 do
    begin
      C := TCliente.Create;
      C.Nome:= 'JOAO MARIA'+'-'+inttostr(I);
      C.NomeFantasia:= 'jesus Cristo de nazare';
      C.CPFCNPJ:= '02316937455';
      C.RG:= '1552666';
      C.Ativo:= '1';
      C.DataNascimento := strtodate('19/04/1976');
      C.Email.value := 'lindemberg.desenvolvimento@gmail.com';

      Clientes.Add( C );
    end;

    Context.AddRange( Clientes , true);

  finally
    Clientes.Free;
    QueryAble:= From( E ).Select.OrderBy(E.Nome);
    DataSource1.DataSet := Context.ToDataSet(QueryAble );
  end;

end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  {
  E := Context.Find(E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );
  E.Nome.Value:= 'Nome do Cliente '+datetimetostr(now);
  Context.UpdateRange(true);
  }
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  Entities:TObjectList<TCliente>;
  Cliente: TCliente;
  I:integer;
begin
  Entities:=TObjectList<TCliente>.create;
  for I := 0 to 1 do
  begin
    Cliente:= TCliente.Create;
    TAutoMapper.DataToEntity( DataSource1.DataSet, Cliente );
    Entities.Add(Cliente);
    DataSource1.DataSet.Next;
  end;
  Context.RemoveRange(Entities);
  Entities.Free;
  DataSource1.DataSet := Context.ToDataSet(QueryAble );
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Context.Entity.FromJson(mLog.Text);

  mLog.Text:= Context.Entity.ToJson;
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
    //TAutoMapper.DataToEntity( DataSource1.DataSet, E );
      E := Context.Find(E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

      E.Nome.Value:= 'Nome do Cliente '+datetimetostr(now);

      Context.Update(true);
      //Context.SaveChanges;
   end;

   QueryAble := From( E ).Select.OrderBy ( E.Nome );

   DataSource1.DataSet := Context.ToDataSet( QueryAble );
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Context.Remove(E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger);
  DataSource1.DataSet := Context.ToDataSet(QueryAble );
end;

procedure TForm1.buttonGetSQLClick(Sender: TObject);
//var
 //Q: IQueryAble;
begin
 //Q:= From( E ).Select([ E.Id, E.Nome, E.Observacao ]).OrderBy( E.Nome ) ;
 //mlog.Lines.Text := Context.BuildQuery(  Q );
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Context.free;
end;

end.
