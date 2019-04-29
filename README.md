# DEntityFramework
DEntityFramework

This is EntityFramework for Delphi

## Requirements

Embarcadero Delphi XE or higher.

## How to use:

In short, add the following path to your Delphi IDE (in the Tools/Environment/Library menu)

* Library path:

...\EntityFramework\source

## Main examples

* ...\EntityFramework\sample\DDD (Domain Driven Design)
* ...\EntityFramework\sample\Testes (TDD)

begin
   dbContext.Include( E.Veiculo ).
                    Include( E.Contatos.list ).
                    Include( E.ClienteTabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.List).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.List.Produto).
                    FirstOrDefault( E.Nome.Contains( value ) );
end;                    

## Authors

* **Lindemberg Cortez** - *Initial work*
