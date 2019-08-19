unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Domain.Entity.Cliente,
  System.Generics.Collections, Vcl.ExtCtrls, Datasnap.DBClient, Data.DB.Helper,
  DataContext, EF.Core.List, EF.QueryAble.Base, EF.QueryAble.Linq, EF.Core.Types,
  EF.Drivers.FireDac;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    Button1: TButton;
    panelButtons: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    buttonGetDataSet: TButton;
    buttonGetSQL: TButton;
    buttonGetEntity: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    mLog: TMemo;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button4: TButton;
    procedure buttonGetDataSetClick(Sender: TObject);
    procedure buttonGetEntityClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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

uses UDataModule, EF.Mapping.AutoMapper, Domain.Entity.Funcionario,
     Domain.Entity.Fornecedor, Domain.Entity.Contato, EF.Drivers.Connection,
     EF.Drivers.Migration, EF.Mapping.Base;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Connection:= TEntityFDConnection.Create( fdFB ,
                                              'SYSDBA',
                                              'masterkey',
                                              'LocalHost',
                                              extractfilepath(application.ExeName)+'..\..\DataBase\DBLINQ.FDB');
end;

procedure TForm1.Button21Click(Sender: TObject);
var
  migrationBuilder: TMigrationBuilder;
  Cli:TCliente;
  Func:TFuncionario;
  Forn:TFornecedor;
begin
  {
  Connection.MigrationDataBase( [ TEmpresa,
                                  TCliente,
                                  TClienteEmpresa,
                                  TContato,
                                  TVeiculo,
                                  TTabelaPreco,
                                  TClienteTabelaPreco,
                                  TProduto,
                                  TItensTabelaPreco ] );
  }

  migrationBuilder:= TMigrationBuilder.Create( fdFirebird ,'C:\Windows\Temp' );

  migrationBuilder.CreateTable<TCliente>( Cli,
                                          'Clientes' ,
                                          procedure
                                          begin
                                            Cli.ID.Column := 'ID int not null';
                                            Cli.Nome.Column := 'Nome varchar(50) is null';
                                          end,
                                          'ID'
                                         );

  migrationBuilder.CreateTable<TFuncionario>( Func,
                                             'Funcionario' ,
                                             procedure
                                             begin
                                               Func.ID.Column := 'ID int not null';
                                               Func.Nome.Column := 'Nome varchar(50) is null';
                                               Func.CPF.Column:= 'CPF varchar(11) is null';
                                             end ,
                                             'ID'
                                            );

  migrationBuilder.CreateTable<TFornecedor>( Forn,
                                             'Fornecedor' ,
                                             procedure
                                             begin
                                               Forn.ID.Column := 'ID int not null';
                                               Forn.RazaoSocial.Column := 'Nome varchar(50) is null';
                                               Forn.CPFCNPJ.Column := 'CPFCNPJ varchar(20) not null';
                                             end,
                                             'ID'
                                           );

  mLog.Text := migrationBuilder.Script.Text;

  migrationBuilder.Free;

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
      //FDMemTable1.Close;
      //FDMemTable1.CloneCursor( _Db.Clientes.ToDataSet( QueryAble ) );
      DataSource1.DataSet := _Db.Clientes.ToDataSet(From( E ).Select.OrderBy(E.Nome) );
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

     QueryAble := From( E ).Select
                 .Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );

     mLog.Text:= _Db.Clientes.BuildQuery(QueryAble);

     _Db.Destroy;
  end;
end;

procedure TForm1.Button20Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  Media: Double;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;

      Media:= _Db.Clientes.Avg(E.Idade);

      mlog.Lines.Add( Media.ToString );

   finally
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
    _Db := TDataContext.Create(Connection);
     E := _Db.Clientes.Find( _Db.Clientes.Entity.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );
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
begin
  try
     _Db := TDataContext.Create(Connection);
     E:= _Db.Clientes.Entity;

     L := _Db.Clientes.Include(E.Veiculo)
                       .Include(E.Contatos)
                       .ToList( E.Ativo = '1' );
     mlog.Lines.clear;
     L.ForEach(  procedure (C: TCliente)
                 var
                   contato:TContato;
                 begin

                    with C do
                    begin
                      mlog.Lines.Add('ID: ' + ID.Value.ToString +'       Nome: ' + Nome.Value+'       CNPJ: ' +CPFCNPJ.Value);
                      mlog.Lines.Add('Placa: ' + Veiculo.Placa.Value );
                      mlog.Lines.Add('Contatos :');
                      for contato in Contatos do
                      begin
                        mlog.Lines.Add('    ' + contato.Nome.Value);
                      end;
                    end;
                 end
                 );
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
                          Single( E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger);

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

procedure TForm1.Button10Click(Sender: TObject);
var
  _Db: TDataContext;
   I:integer;
   Clientes : Collection<TCliente>;
   C: TCliente;
begin
  try
    _Db := TDataContext.Create(Connection);

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
                          'Teste' );

       Clientes.Add(C);
    end;

    _Db.Clientes.AddRange(Clientes);

    _Db.Clientes.SaveChanges;

  finally
     //DataSource1.DataSet := _Db.Clientes.ToDataSet(From( E ).Select.OrderBy(E.Nome) );
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

  _Db.AddScript(Format('Insert Into Clientes (Nome, NomeFantasia) Values ( ''%s'', ''%s'')',['Joao','Joao Maria']));
  _Db.AddScript(Format('Insert Into Clientes (Nome, NomeFantasia) Values (''%s'', ''%s'')',['Maria','Maria Jose']));

  _Db.ExecuteScript;

  _Db.Destroy;
end;

procedure TForm1.Button15Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;
       {QueryAble := From( E ).
                    Select.
                    Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );}

       if _Db.Clientes.Any(E.Id = 3 ) then
           mlog.Lines.Add( 'Tem Cliente' )
       else
          mlog.Lines.Add( 'Nao Tem Cliente' );

   finally
     _Db.Destroy;
   end;
end;

procedure TForm1.Button16Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  count: integer;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;

      count:= _Db.Clientes.Count;

      mlog.Lines.Add( count.ToString );

   finally
     _Db.Destroy;
   end;
end;

procedure TForm1.Button17Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  SUM: Double;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;

      SUM:= _Db.Clientes.SUM(E.Renda);

      mlog.Lines.Add( SUM.ToString );

   finally
     _Db.Destroy;
   end;
end;

procedure TForm1.Button18Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  Min: Double;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;

      Min:= _Db.Clientes.Min(E.Id);

      mlog.Lines.Add( Min.ToString );

   finally
     _Db.Destroy;
   end;

end;

procedure TForm1.Button19Click(Sender: TObject);
var
   E: TCliente;
  _Db: TDataContext;
  Max: Double;
begin
   try
      _Db := TDataContext.Create(Connection);
      E:= _Db.Clientes.Entity;

      Max:= _Db.Clientes.Max(E.Id);

      mlog.Lines.Add( Max.ToString );

   finally
     _Db.Destroy;
   end;

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

procedure TForm1.Button4Click(Sender: TObject);
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

        C := _Db.Clientes.Single( E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger);

        mlog.Lines.Add('Cliente : ' +C.Nome.Value);

        if C.Id.Value > 0 then
        begin
          _Db.Clientes.
                      Entry(C).
                      Include(E.Contatos).
                      Include(E.Veiculo).
                      Include(E.ClienteEmpresa).
                         ThenInclude(E.ClienteEmpresa.Empresa).
                      Include(E.ClienteTabelaPreco).
                          ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                      //      ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
                      Load();

          mlog.Lines.Add('Empresa : ' + C.ClienteEmpresa.Empresa.Descricao.Value);
          mlog.Lines.Add('ID : ' + C.ID.Value.ToString );

          mlog.Lines.Add('Veiculo: ' + C.Veiculo.Placa.Value);

          mlog.Lines.Add('Tabela de Preco: ' + E.ClienteTabelaPreco.TabelaPreco.Id.Value.ToString);

          mlog.Lines.Add('Contatos :');

          for contato in C.Contatos do
          begin
             mlog.Lines.Add('    ' + contato.Nome.Value);
          end;
        end;
     finally
        _Db.Destroy;
        FreeAndNIL(C);
     end;
   end;

end;

procedure TForm1.Button6Click(Sender: TObject);
var
   C: TCliente;
  _Db: TDataContext;
begin
  try
    _Db := TDataContext.Create(Connection);

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
    _Db.Clientes.Add(C);

    _Db.Clientes.SaveChanges;

  finally
    _Db.Destroy;
    C.Free;
  end;

end;

procedure TForm1.Button7Click(Sender: TObject);
var
  _Db: TDataContext;
   E: TCliente;
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
