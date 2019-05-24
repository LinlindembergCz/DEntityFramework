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
    Constructor Create(dbContext:TdbContext);override;
    function LoadDataSetPorNome(value: string):TDataSet;
    function LoadDataSetPorID(value: string):TDataSet;
  end;

  TRepositoryCliente = class sealed (TRepositoryCliente<TCliente>)
  end;

implementation

uses
  Vcl.Dialogs, System.SysUtils, Domain.Entity.ItensTabelaPreco;

{ TRepositoryCliente }

constructor TRepositoryCliente<T>.Create(dbContext:TdbContext);
begin
  _RepositoryCliente := TRepository<T>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<T>;
  inherited;
end;

function TRepositoryCliente<T>.LoadDataSetPorID(value: string): TDataSet;
var
  E: T;
  L: TEntityList<TCliente>;
  I: Integer;
begin
   E := _RepositoryCliente.Entity;

   L:= dbContext.Include( E.Veiculo ).
                 Include( E.Contatos ).
                { Include( E.ClienteTabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                       ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
                 Include( E.ClienteEmpresa).
                    ThenInclude(E.ClienteEmpresa.Empresa).}
                 ToList<TCliente>( E.Idade = 43 ) ;

   for I := 0 to l.Count-1 do
   begin
     showmessage( '  Nome'+L.Items[I].Nome.Value +
                  '  Veiculo  :'+L.Items[I].Veiculo.Placa.Value+
                  '  Contato: '+ (L.Items[I].Contatos[0].Nome.Value) );
   end;



   {
   dbContext.Include( E.Veiculo ).
             Include( E.Contatos ).
             Include( E.ClienteTabelaPreco).
                ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                   ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
             Include( E.ClienteEmpresa).
                ThenInclude(E.ClienteEmpresa.Empresa).
             Where( E.ID = strtoint('43'));

    showmessage( 'ClienteEmpresa:'+ E.ClienteEmpresa.Id.Value.ToString + '  '+
                ' Empresa:'+E.ClienteEmpresa.Empresa.Id.Value.ToString + '   '+
                ' Cliente:'+ E.Nome.Value+' '+
                '  Contatos Count :'+inttostr(E.Contatos.Count)+'  '+
                '  Veiculo  :'+E.Veiculo.Placa.Value+'  '+
                '  ClienteTabelaPreco ID:'+E.ClienteTabelaPreco.Id.Value.ToString+'  '+
                '  TabelaPreco ID:'+E.ClienteTabelaPreco.TabelaPrecoId.Value.ToString+'  ' +
                '  ItensTabelaPreco.Count:'+inttostr(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.Count)
              );
    }


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
   result := dbContext.ToDataSet( From( E ).Where( E.ID = strtoint(value) ).Select );

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
             Where( E.Nome.Contains( value ) );

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
