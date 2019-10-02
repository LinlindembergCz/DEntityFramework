unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Domain.Entity.Cliente,
  System.Generics.Collections, Vcl.ExtCtrls, Datasnap.DBClient, Data.DB.Helper,
  DataContext, EF.Core.List, EF.QueryAble.Base, EF.QueryAble.Linq, EF.Core.Types,
  EF.Drivers.FireDac, Data.Bind.Components, Data.Bind.DBScope,
  Data.Bind.ObjectScope, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Controls, Vcl.Buttons,
  Vcl.Bind.Navigator, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.SQLiteVDataSet, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.VCLUI.Wait;

type
    //View Model
    TClienteView = class
    private
      FID:Integer;
      FNome:String;
      FCPFCNPJ: string;
    public
      property ID:Integer read FID write FID;
      property Nome: string read FNome write FNome;
      property CPFCNPJ: string read FCPFCNPJ write FCPFCNPJ;
    end;



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
    Panel1: TPanel;
    edtNome: TLabeledEdit;
    edtId: TLabeledEdit;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    BindNavigator1: TBindNavigator;
    edtCPF: TLabeledEdit;
    LinkControlToField3: TLinkControlToField;
    btnRefresh: TButton;
    Label1: TLabel;
    Button22: TButton;
    Button23: TButton;
    OpenDialog1: TOpenDialog;
    chkOffOline: TCheckBox;
    Button24: TButton;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDMemTable1: TFDMemTable;
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
    procedure PrototypeBindSource1CreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure btnRefreshClick(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure chkOffOlineClick(Sender: TObject);
    procedure Button24Click(Sender: TObject);

  private
    ViewModelList : TObjectList<TClienteView>;
    Connection:TEntityFDConnection;
    procedure LoadClientes;
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;



implementation

{$R *.dfm}

uses UDataModule, EF.Mapping.AutoMapper,  Domain.Entity.Contato, EF.Drivers.Connection,
     EF.Drivers.Migration, EF.Mapping.Base, Domain.Entity.Empresa,
  Domain.Entity.ClienteEmpresa, Domain.Entity.Veiculo,
  Domain.Entity.TabelaPreco, Domain.Entity.ClienteTabelaPreco,
  Domain.Entity.Produto, Domain.Entity.ItensTabelaPreco;

procedure TForm1.LoadClientes;
var
   L: Collection<TCliente>;
   _Db: TDataContext;
begin
   try
     if ViewModelList = nil then
        ViewModelList := TObjectList<TClienteView>.create
     else
        ViewModelList.clear;

     _Db := TDataContext.Create( Connection );

      L:= _Db.Clientes.
              Where( '0=0' ).
              OrderBy('ID').
              ToList;

      L.ForEach( procedure (C: TCliente)
                 var
                   E  : TClienteView;
                 begin
                   E:= TClienteView.Create;
                   E.ID:= C.ID.Value;
                   E.Nome:= C.Nome.Value;
                   E.CPFCNPJ:= C.CPFCNPJ.Value;

                   ViewModelList.Add( E )
                 end );
   finally
      L.Free;
      _Db.Destroy;
   end;
end;

procedure TForm1.PrototypeBindSource1CreateAdapter(Sender: TObject; var ABindSourceAdapter: TBindSourceAdapter);
begin
   Connection:= TEntityFDConnection.Create( fdFB ,
                                            'SYSDBA',
                                            'masterkey',
                                            'LocalHost',
                                            extractfilepath(application.ExeName)+
                                            '..\..\DataBase\DBLINQ.FDB');
   LoadClientes;

   ABindSourceAdapter := TListBindSourceAdapter<TClienteView>.Create(Self, ViewModelList, false );
end;



procedure TForm1.Button21Click(Sender: TObject);
var
  migrationBuilder: TMigrationBuilder;
  Cli:TCliente;
  //Func:TFuncionario;
  //Forn:TFornecedor;
begin

  Connection.MigrationDataBase( [ TEmpresa,
                                  TCliente,
                                  TClienteEmpresa,
                                  TContato,
                                  TVeiculo,
                                  TTabelaPreco,
                                  TClienteTabelaPreco,
                                  TProduto,
                                  TItensTabelaPreco ] );


 {
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
  }

end;


procedure TForm1.Button22Click(Sender: TObject);
var
  _Db: TDataContext;

   E: TClienteView;
begin
   try
      if PrototypeBindSource1.Editing then
         PrototypeBindSource1.Post;

      E := ViewModelList.Items[ PrototypeBindSource1.ItemIndex ];

      _Db := TDataContext.Create(Connection);

      _Db.Clientes.Find( _Db.Clientes.Entity.Id = E.ID );

      with E do
      begin
        _Db.Clientes.Entity.Nome.Value:=  Nome;
        _Db.Clientes.Entity.CPFCNPJ.Value:=  CPFCNPJ;
      end;

      _Db.Clientes.Update;

      _Db.Clientes.SaveChanges;

      //Não gosto de fazer isso, mas aqui é so um Demo!
      buttonGetDataSet.Click;

   finally
     _Db.Destroy;
   end;

end;

procedure TForm1.Button23Click(Sender: TObject);
var
  _Db: TDataContext;
  E:TCliente;
begin
   OpenDialog1.Execute;
   if OpenDialog1.FileName <> '' then
   begin
     try
       _Db := TDataContext.Create( Connection  );
        E:= _Db.Clientes.Entity;
       _Db.Clientes.Import( OpenDialog1.FileName, [E.Nome, E.NomeFantasia , E.CPFCNPJ]);
     finally
       _Db.Destroy;
     end;
   end;
end;

procedure TForm1.buttonGetDataSetClick(Sender: TObject);
var
  E: TCliente;
  _Db: TDataContext;
  QueryAble: IQueryAble;
  Q:TFDQuery;
begin
   try
     _Db := TDataContext.Create( Connection  );
      E:= _Db.Clientes.Entity;
      //FDMemTable1.Close;
      //FDMemTable1.CloneCursor( _Db.Clientes.ToDataSet( QueryAble ) );
      if (Connection.CustomConnection as TFDConnection).Connected then
      begin
        DataSource1.DataSet:= _Db.Clientes.
                                OrderBy('Nome').
                                ToDataSet( From( E ).Select);
        TFDQuery(DataSource1.DataSet).FetchAll;
        // TFDQuery(DataSource1.DataSet).FetchNext();
        ///Dados ainda podem ser visualizados e alterados
      end
      else
      begin
        //showmessage('Off line');
        DataSource1.DataSet.close;
        DataSource1.DataSet.Open;
      end;

      if chkOffOline.Checked then
         (Connection.CustomConnection as TFDConnection).Offline()
      else
         (Connection.CustomConnection as TFDConnection).Online();

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
         {
         QueryAble := From( E ).
                      Select.
                      Where( E.Id = DataSource1.DataSet.FieldByName('ID').AsInteger );
         }
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

procedure TForm1.chkOffOlineClick(Sender: TObject);
begin
  if not chkOffOline.Checked then
    (Connection.CustomConnection as TFDConnection).Online();
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  PrototypeBindSource1.Locate('ID', DataSource1.DataSet.FieldByName('ID').AsString);
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
begin
  try
    _Db := TDataContext.Create(Connection);
     E := _Db.Clientes.Find( _Db.Clientes.Entity.Id = 1 );
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
                      .Where( E.Ativo = '1' )
                      .OrderBy('ID')
                      .ToList;
     mlog.Lines.clear;

     L.ForEach(  procedure (C: TCliente)
                 var
                   contato:TContato;
                 begin
                    with C do
                    begin
                      mlog.Lines.Add('ID: ' + ID.Value.ToString +'       Nome: ' +
                                              Nome.Value+'       CNPJ: ' + CPFCNPJ.Value);
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
                          Where(E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger).
                          Single;

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

procedure TForm1.btnRefreshClick(Sender: TObject);
begin
  LoadClientes;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  _Db: TDataContext;
   I:integer;
   Clientes : Collection<TCliente>;
begin
  try
    _Db := TDataContext.Create(Connection);

    Clientes := Collection<TCliente>.create(false);
    for I := 0 to 3 do
    begin
       Clientes.Add( TCliente.New( '02316937455',
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
                                  'Teste' ) );
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
  _Db: TDataContext;
begin
  try
     _Db := TDataContext.Create(Connection);

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

      E:= _Db.Clientes.OrderBy('ID').FromSQL('Select * From Clientes where ID = 3');

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
  _Db: TDataContext;
  count: integer;
begin
   try
      _Db := TDataContext.Create(Connection);
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
  _Db: TDataContext;
begin
  try
     _Db := TDataContext.Create(Connection);
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

        C := _Db.Clientes.
                 Where(E.ID =  DataSource1.DataSet.FieldByName('ID').AsInteger).
                 Single;

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
                      //     ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
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
  _Db: TDataContext;
begin
  try
    _Db := TDataContext.Create(Connection);

    _Db.Clientes.Add(TCliente.New( '02316937455',
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
                        'Teste'));

    _Db.Clientes.SaveChanges;

  finally
    _Db.Destroy;
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

procedure TForm1.Button24Click(Sender: TObject);
var
  _Db: TDataContext;
  DataSet1,DataSet2:TFDQuery;
  E:TCliente;
  C:TContato;
begin
  try
    _Db := TDataContext.Create( Connection  );

     E:= TCliente.Create;
     C:= TContato.Create;

     DataSet1:= _Db.Clientes.ToDataSet(  From(E).Select );
     DataSet2:= _Db.Clientes.ToDataSet(  From(C).Select );

     _Db.LocalSQL.Add(DataSet1,'LISTA_DE_CLIENTES');
     _Db.LocalSQL.Add(DataSet2,'LISTA_DE_CONTATOS');

     FDMemTable1.Data:= _Db.LocalSQL.OpenSQL( 'Select count(*) from LISTA_DE_CLIENTES Union Select count(*) from LISTA_DE_CONTATOS ' );

     DataSource1.DataSet:= FDMemTable1;

  finally
    E.Free;
    C.Free;
    DataSet1.Free;
    DataSet2.Free;
    _Db.Destroy;

  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   ViewModelList.Free;
   Connection.Free;
end;

end.
