# DEntityFramework
DEntityFramework

It's EntityFramework for Delphi

Mapeamento de classes de entidade POCO 
Controle de alterações automático
Conversão das consultas fortemente tipadas usando LINQ
Conectividade de banco de dados com base no FireDAC e vários 
provedores disponíveis para se conectar ao SQL Server,  MySQL, FireBird, PostGree

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
                    Include( E.Contatos ).
                    Include( E.ClienteTabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco).
                    ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.).
                    Where( E.ID = 3 ).
                    ToJson;

end;                    

## Authors

* **Lindemberg Cortez** - *Initial work*
