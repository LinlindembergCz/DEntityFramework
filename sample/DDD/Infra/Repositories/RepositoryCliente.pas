unit RepositoryCliente;

interface

uses
DB, Classes, Repository, classCliente, RepositoryBase, InterfaceRepositoryCliente,
InterfaceRepository,  Context, EF.Core.Types, EF.Engine.DataContext;

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
  Vcl.Dialogs;

{ TRepositoryCliente }

constructor TRepositoryCliente<T>.Create(dbContext:TdbContext);
begin
  _RepositoryCliente := TRepository<T>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<T>;
  inherited;
end;

function TRepositoryCliente<T>.LoadDataSetPorNome(value: string): TDataSet;
var
  E: TCliente;
begin
   E := _RepositoryCliente.Entity;

   dbContext.Include( E ).
             Include( E.Veiculo ).
             Include( E.Contados.list ).
             Include( E.ClienteTabelaPreco).
             ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
             FirstOrDefault( E.Nome.Contains( value ));

   showmessage( E.Nome.Value  +'   '+  E.Veiculo.Placa.Value + '   '+E.Contados[0].Nome.Value+'    '+E.ClienteTabelaPreco.TabelaPreco.Descricao.Value );


   result := dbContext.GetDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select );


end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
