unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Domain.Entity.Cliente, System.Generics.Collections,
  Vcl.ExtCtrls, Datasnap.DBClient, Data.DB.Helper,
  DataContext, EF.Core.List, EF.QueryAble.Base, EF.QueryAble.Linq, EF.Core.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, EF.Drivers.Connection, EF.Drivers.FireDac;

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
    FDMemTable1: TFDMemTable;
    Button13: TButton;
    Button14: TButton;
    procedure buttonGetDataSetClick(Sender: TObject);
    procedure buttonGetEntityClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure buttonGetSQLClick(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    Connection:TEntityFDConnection;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}

uses UDataModule, EF.Mapping.AutoMapper,
     Domain.Entity.Contato;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Connection:= TEntityFDConnection.Create( fdFB ,
                                       'SYSDBA',
                                       'masterkey',
                                       'LocalHost',
                                       extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');
  {  Connection.MigrationDataBase( [ TEmpresa,
                                     TCliente,
                                     TClienteEmpresa,
                                     TContato,
                                     TVeiculo,
                                     TTabelaPreco,
                                     TClienteTabelaPreco,
                                     TProduto,
                                     TItensTabelaPreco ] ); }
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Connection.Free;
end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
var
  E: TCliente;
  _Db: TDataContext;
  QueryAble: IQueryAble;
begin
   try
     _Db := TDataContext.Create( Connection  );
      E:= _Db.Clientes.Entity;

      QueryAble := From( E ).Select.OrderBy ( E.Nome );

      FDMemTable1.CloneCursor( _Db.Clientes.ToDataSet( QueryAble ) );

   finally
     _Db.Destroy;
   end;
end;

procedure TForm1.buttonGetEntityClick(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
begin
   if DataSource1.DataSet <> nil then
   begin
      try
        _Db := TDataContext.Create(Connection);
        E:= _Db.Clientes.Entity;
         {QueryAble := From( E ).
                      Select.
                      Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );}
         //E := _Db.Clientes.Find( QueryAble );
         E := _Db.Clientes.Find( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger  );

         mlog.Lines.Add('ID: ' + E.ID.Value.ToString);
         mlog.Lines.Add( ' Nome:'+ E.Nome.Value);
         mlog.Lines.Add( ' CNPJ:'+ E.CPFCNPJ.Value);
         mlog.Lines.Add( ' Estado Civil:'+ E.EstadoCivil.Value);
         mlog.Lines.Add( ' Nascimento:'+ datetostr(E.DataNascimento.Value));
      finally
        _Db.Destroy;
      end;
   end;
end;

procedure TForm1.buttonGetSQLClick(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  QueryAble: IQueryAble;
begin
  if DataSource1.DataSet <> nil then
  begin
     _Db := TDataContext.Create(Connection);

     E:= _Db.Clientes.Entity;

     QueryAble := From( E )
                 .Select
                 .Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

     mLog.Text:= _Db.Clientes.BuildQuery(QueryAble);

     _Db.Destroy;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  QueryAble: IQueryAble;
begin
  try
    { QueryAble := From( E )
               .Select
               .Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );  }
   //E := _Db.Clientes.Find( QueryAble );

    _Db := TDataContext.Create(Connection);
     E:= _Db.Clientes.Entity;
     E := _Db.Clientes.Find( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

     mLog.Text:= E.ToJson;
  finally
    _Db.Destroy;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  L:Collection<TCliente>;
  C:TCliente;
   contato:TContato;
begin
  try
     _Db := TDataContext.Create(Connection);
     E:= _Db.Clientes.Entity;

     L := _Db.Clientes.Include(E.Veiculo)
                       .Include(E.Contatos)
                       .ToList( E.Ativo = '1' );
      mlog.Lines.clear;
     for C in L do
     begin
         mlog.Lines.Add('ID: ' + C.ID.Value.ToString +'       Nome: ' + C.Nome.Value+'       CNPJ: ' + C.CPFCNPJ.Value);
         mlog.Lines.Add('Placa: ' + C.Veiculo.Placa.Value );
         mlog.Lines.Add('Contatos :');
         for contato in C.Contatos do
         begin
           mlog.Lines.Add('    ' + contato.Nome.Value);
         end;
     end;
  finally
    _Db.Destroy;
    FreeAndNil( L );
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  C:TCliente;
  contato:TContato;
begin
   if DataSource1.DataSet <> nil then
   begin
     try
        _Db := TDataContext.Create(Connection);
        E:= _Db.Clientes.Entity;
        C := _Db.Clientes.Include(E.Contatos).
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
     finally
        _Db.Destroy;
        FreeAndNIL(C);
     end;
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
   C:TCliente;
   contato: TContato;
begin
  if DataSource1.DataSet <> nil then
  begin
     try
        _Db := TDataContext.Create(Connection);
        E:= _Db.Clientes.Entity;

        C := _Db.Clientes.Include(E.Veiculo).
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
        _Db.Destroy;
        FreeAndNIL(C);
     end;
  end;

end;

procedure TForm1.Button10Click(Sender: TObject);
var
   I:integer;
   Clientes : Collection<TCliente>;
   C: TCliente;
   E: TCliente;
  _Db: TDataContext;
begin
  try
    _Db := TDataContext.Create(Connection);
    E:= _Db.Clientes.Entity;

    Clientes := Collection<TCliente>.create(false);
    for I := 0 to 3 do
    begin
       C := TCliente.New( '02316937455',
                          0,
                          43,
                          'JOAO Cristo '+'-'+inttostr(I),
                          '111111',
                          strtodate('19/04/1976'),
                          '1',
                          'lindemberg',
                          '',
                          'Fisica',
                          'Casado',
                          'Teste');

       Clientes.Add(C);
    end;

    _Db.Clientes.AddRange(Clientes, true);

  finally
     _Db.Destroy;
    Clientes.Free;

  end;

end;

procedure TForm1.Button12Click(Sender: TObject);
var
  Entities: Collection<TCliente>;
  Cliente: TCliente;
  I:integer;
     E: TCliente;
  _Db: TDataContext;
begin
  try
     _Db := TDataContext.Create(Connection);
     E:= _Db.Clientes.Entity;

     Entities:=Collection<TCliente>.create;

     for I := 0 to 1 do
     begin
       Cliente:= TCliente.Create;
       TAutoMapper.DataToEntity( DataSource1.DataSet, Cliente );
       Entities.Add(Cliente);
       DataSource1.DataSet.Next;
     end;
     _Db.Clientes.RemoveRange(Entities);


  finally
     _Db.Destroy;
     Entities.Free;
  end;

end;

procedure TForm1.Button13Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
begin
   try
      _Db := TDataContext.Create(Connection);

      E:= _Db.Clientes.FromSQL('Select * From Clientes where ID = 3');

      mlog.Lines.Add('ID: ' + E.ID.Value.ToString);
      mlog.Lines.Add( ' Nome:'+ E.Nome.Value);
      mlog.Lines.Add( ' CNPJ:'+ E.CPFCNPJ.Value);
      mlog.Lines.Add( ' Estado Civil:'+ E.EstadoCivil.Value);
      mlog.Lines.Add( ' Nascimento:'+ datetostr(E.DataNascimento.Value));
   finally
      _Db.Destroy;
   end;
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  _Db: TDataContext;
begin
  _Db := TDataContext.Create(Connection);

  _Db.AddScript('Insert Into Clientes (Nome, NomeFantasia) Values (''Joao'',''Joao Maria'')');
  _Db.AddScript('Insert Into Clientes (Nome, NomeFantasia) Values (''Maria'',''Maria Jose'')');

  _Db.ExecuteScript;

  _Db.Destroy;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
begin
  try
     _Db := TDataContext.Create(Connection);
     E:= _Db.Clientes.Entity;
     _Db.Clientes.Entity.FromJson(mLog.Text);
     mLog.Text:= _Db.Clientes.Entity.ToJson;
  finally
     _Db.Destroy;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
   C: TCliente;
    E: TCliente;
  _Db: TDataContext;
begin
  try
    _Db := TDataContext.Create(Connection);
    E:= _Db.Clientes.Entity;

    C := TCliente.New( '02316937455',
                        0,
                        43,
                        'JOAO Cristo de nazare',
                        '111111',
                        strtodate('19/04/1976'),
                        '1',
                        'lindemberg',
                        '',
                        'Fisica',
                        'Casado',
                        'Teste');
    //C.Clientes.Validate;
    _Db.Clientes.Add(C, true);

    DataSource1.DataSet := _Db.Clientes.ToDataSet(From( E ).Select.OrderBy(E.Nome) );
  finally
    _Db.Destroy;
    C.Free;
  end;

end;

procedure TForm1.Button7Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;
      if (DataSource1.DataSet <> nil) and (DataSource1.DataSet.RecordCount > 0) then
      begin
       //TAutoMapper.DataToEntity( DataSource1.DataSet, E );
         E := _Db.Clientes.Find( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

         E.Nome.Value:= 'Nome do Cliente '+datetimetostr(now);

         _Db.Clientes.Update;

         _Db.Clientes.SaveChanges;
      end;

      DataSource1.DataSet := _Db.Clientes.ToDataSet( From( E ).Select.OrderBy ( E.Nome ) );
   finally
     _Db.Destroy;
   end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;
      _Db.Clientes.Remove(E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger);
      DataSource1.DataSet := _Db.Clientes.ToDataSet( From( E ).Select.OrderBy ( E.Nome ) );
   finally
     _Db.Destroy;
   end;
end;

end.
