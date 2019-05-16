unit Repositorio.Cliente;

interface

uses
DB, Classes, Repositorio.GenericRepository, Domain.Entity.Cliente, Repositorio.Base,
Repositorio.Interfaces.Cliente,
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
begin
   E := _RepositoryCliente.Entity;

   dbContext.Include( E.Veiculo ).
             Include( E.Contatos ).
             Include( E.ClienteTabelaPreco).
             ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
             ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco).
             Where( E.ID = strtoint(value)  );

   showmessage( 'Cliente:'+ E.Nome.Value+' '+
                '  Contatos Count :'+inttostr(E.Contatos.Count)+'  '+
                '  Veiculo  :'+E.Veiculo.Placa.Value+'  '+
                '  ClienteTabelaPreco ID:'+E.ClienteTabelaPreco.Id.Value.ToString+'  '+
                '  TabelaPreco ID:'+E.ClienteTabelaPreco.TabelaPrecoId.Value.ToString+'  ' +
                '  ItensTabelaPreco.Count:'+inttostr(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.Count)
              );

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
