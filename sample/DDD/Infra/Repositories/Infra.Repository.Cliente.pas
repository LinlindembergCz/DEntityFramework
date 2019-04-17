unit Infra.Repository.Cliente;

interface

uses
DB, Classes, Infra.Repository.Repository, Domain.Entity.Cliente, Infra.Repository.Base,
Domain.Interfaces.Repositorios.Cliente,
Domain.Interfaces.Repositorios.Repositorybase,  Context, EF.Core.Types, EF.Engine.DataContext;

type
  TRepositoryCliente<T:TCliente> = class(TRepositoryBase<T> ,IRepositoryCliente<T>)
  private
    _RepositoryCliente:IRepository<T>;
  public
    Constructor Create(dbContext:TdbContext);override;
    function LoadDataSetPorNome(value: string):TDataSet;
  end;

  TRepositoryCliente = class sealed (TRepositoryCliente<TCliente>)
  end;

implementation

uses
  Vcl.Dialogs, System.SysUtils;

{ TRepositoryCliente }

constructor TRepositoryCliente<T>.Create(dbContext:TdbContext);
begin
  _RepositoryCliente := TRepository<T>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<T>;
  inherited;
end;

function TRepositoryCliente<T>.LoadDataSetPorNome(value: string): TDataSet;
var
  E: T;
begin
   E := _RepositoryCliente.Entity;

   dbContext.Include( E.Veiculo ).
                    Include( E.Contatos.list ).
                    Include( E.ClienteTabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.List).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.List.Produto).
                    FirstOrDefault( E.Nome.Contains( value ) );
   {
   showmessage( E.Nome.Value+' '+
                inttostr(E.Contatos.Count)+'  '+
                E.ClienteTabelaPreco.ClienteId.Value.ToString+'  '+
                inttostr(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.Count)+ ' ' +
                E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.List.Produto.Descricao);
   }

   result := dbContext.GetDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select );

end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
