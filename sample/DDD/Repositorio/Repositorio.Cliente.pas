unit Repositorio.Cliente;

interface

uses
DB, Classes, Repositorio.GenericRepository, Domain.Entity.Cliente, Repositorio.Base,
Repositorio.Interfaces.Cliente,System.Generics.Collections,
Repositorio.Interfaces.base,  Context, EF.Core.Types, EF.Engine.DataContext;

type
  TRepositoryCliente<T:TCliente> = class(TRepositoryBase<T> ,IRepositoryCliente<T>)
  private
    _RepositoryCliente:IRepository<T>;
  public
    Constructor Create(dbContext:TdbContext<T>);override;
    function LoadDataSetPorNome(value: string):TDataSet;
    function LoadDataSetPorID(value: string):TDataSet;
  end;

  TRepositoryCliente = class sealed (TRepositoryCliente<TCliente>)
  end;

implementation

uses
  Vcl.Dialogs, System.SysUtils, Domain.Entity.ItensTabelaPreco,
  Domain.Entity.Contato;

{ TRepositoryCliente }

constructor TRepositoryCliente<T>.Create(dbContext:TdbContext<T>);
begin
  _RepositoryCliente := TRepository<T>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<T>;
  inherited;
end;

function TRepositoryCliente<T>.LoadDataSetPorID(value: string): TDataSet;
var
  E: T;
  ListaCliente: TEntityList<T>;
  item: T;
  ItensTbp: TItensTabelaPreco;
  Contato : TContato;

begin
   E := _RepositoryCliente.Entity;

   ListaCliente:= dbContext.Include( E.Veiculo ).
                            Include( E.Contatos ).
                            Include( E.ClienteTabelaPreco).
                              ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                                ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
                            Include( E.ClienteEmpresa).
                              ThenInclude(E.ClienteEmpresa.Empresa).
                  ToList( E.Ativo =  '1' );

   for Item in ListaCliente do
   begin
     showmessage( '  Empresa: '+Item.ClienteEmpresa.Empresa.Descricao.Value +#13+
                  '  Nome:  '+Item.Nome.Value +#13+
                  '  Veiculo  :'+Item.Veiculo.Placa.Value );

     for Contato in Item.Contatos do
     begin
       showmessage( 'Contato: '+ Contato.Nome.Value );
     end;

     for ItensTbp in   Item.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco do
     begin
        showmessage( '  ItensTabelaPreco.Produto '+ ItensTbp.ProdutoId.value.Tostring );
     end;

   end;

   ListaCliente.Free;
    (*
   Cliente := dbContext.Include( E.Veiculo ).
                        Include( E.Contatos ).
                        Include( E.ClienteTabelaPreco ).
                           ThenInclude(E.ClienteTabelaPreco.TabelaPreco ).
                              ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco ).
                             // ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.List.Produto ).
                        Include( E.ClienteEmpresa ).
                           ThenInclude(E.ClienteEmpresa.Empresa ).
                        Where<TCliente>( E.ID =  strtoint( value ) );

    showmessage( 'ClienteEmpresa:  '+ Cliente.ClienteEmpresa.Id.Value.ToString + '   '+
                 ' Empresa:  '+Cliente.ClienteEmpresa.Empresa.Descricao.Value + '   '+
                 ' Cliente:  '+ Cliente.Nome.Value+'   '+
                 ' Contatos Count :  '+inttostr(Cliente.Contatos.Count)+'   '+
                 ' Veiculo  :  '+Cliente.Veiculo.Placa.Value+'   '+
                 ' ClienteTabelaPreco ID:  '+Cliente.ClienteTabelaPreco.Id.Value.ToString+'   '+
                 ' TabelaPreco ID:  '+Cliente.ClienteTabelaPreco.TabelaPrecoId.Value.ToString+'   ' +
                 ' ItensTabelaPreco.Count:  '+inttostr(Cliente.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.Count)+
                 ' Id :  '+ Cliente.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco[1].Id.Value.ToString  );

      (*
      public Cliente GetById(int id)
      {
        var ret = _db.Clientes.AsNoTracking().Include(cli => cli.Pessoa)
                                             .Include(cli => cli.Pessoa.Enderecos)
                                             .Include(cli => cli.Pessoa.Contatos)
                                             .Include(cli => cli.CartoesFidelidade)
                                             .Include(cli => cli.Segmento)
                                             .Include(cli => cli.MotoristasCliente)
                                             .Include(cli => cli.VeiculosCliente)
                                             .Include(cli => cli.ClienteEmpresas)
                                                 .ThenInclude(cli => cli.Empresa)
                                                 .ThenInclude(p => p.Pessoa)
                                             .Include(cli => cli.ClienteTabelasPreco)
                                                 .ThenInclude(ct => ct.TabelaPreco)
                                                 .ThenInclude(tp => tp.ItensTabelaPreco)
                                             .Include(cli => cli.ClienteTabelasPreco)
                                                 .ThenInclude(ct => ct.FormaPagamento)
                                             .FirstOrDefault(cli => cli.Id == id);
        return ret;
      }

      showmessage( 'ClienteEmpresa:'+ E.ClienteEmpresa.Id.Value.ToString + '  '+
                    ' Empresa:'+E.ClienteEmpresa.Empresa.Id.Value.ToString + '   '+
                    ' Cliente:'+ E.Nome.Value+' '+
                    '  Contatos Count :'+inttostr(E.Contatos.Count)+'  '+
                    '  Veiculo  :'+E.Veiculo.Placa.Value+'  '+
                    '  ClienteTabelaPreco ID:'+E.ClienteTabelaPreco.Id.Value.ToString+'  '+
                    '  TabelaPreco ID:'+E.ClienteTabelaPreco.TabelaPrecoId.Value.ToString+'  ' +
                    '  ItensTabelaPreco.Count:'+inttostr(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.Count)
                  );

      *)
   if value <> ''  then
      result := dbContext.ToDataSet( From( T ).Where( E.ID = strtoint(value) ).Select );

end;

function TRepositoryCliente<T>.LoadDataSetPorNome(value: string): TDataSet;
var
  E: T;
begin
   E := _RepositoryCliente.Entity;

   dbContext.Include( E.Veiculo ).
             Include( E.Contatos ).
             Include( E.ClienteTabelaPreco).
             ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
             ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
             Where<TCliente>( E.Nome.Contains( value ) );

   showmessage( 'Cliente:'+ E.Nome.Value+' '+
                '  Contatos Count :'+inttostr(E.Contatos.Count)+'  '+
                '  Veiculo  :'+E.Veiculo.Placa.Value+'  '+
                '  ClienteTabelaPreco ID:'+E.ClienteTabelaPreco.Id.Value.ToString+'  '+
                '  TabelaPreco ID:'+E.ClienteTabelaPreco.TabelaPrecoId.Value.ToString+'  ' +
                '  ItensTabelaPreco.Count:'+inttostr(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.Count)
                );


   result := dbContext.ToDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select );

end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
