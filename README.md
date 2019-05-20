# DEntityFramework
DEntityFramework

It's EntityFramework for Delphi

Mapeamento de classes de entidade POCO ;<p/>
Controle de alterações automático ;<p/>
Conversão das consultas fortemente tipadas usando LINQ ;<p/>
Conectividade de banco de dados com base no FireDAC e vários ; <p/>
provedores disponíveis para se conectar ao SQL Server,  MySQL, FireBird, PostGree<p/><p/>

Mapping of POCO entity classes; <p />
Automatic change control; <p />
Conversion of strongly typed queries using LINQ; <p />
Database connectivity based on FireDAC and various; <p />
providers available to connect to SQL Server, MySQL, FireBird, PostGree

## Requirements

Embarcadero Delphi XE or higher.

## How to use:

In short, add the following path to your Delphi IDE (in the Tools/Environment/Library menu)

* Library path:

...\EntityFramework\source

## Main examples

* ...\EntityFramework\sample\DDD (Domain Driven Design)
* ...\EntityFramework\sample\Testes (TDD)

begin<br>
   dbContext.Include( E.Veiculo ).<br>
                    Include( E.Contatos ).<br>
                    Include( E.ClienteTabelaPreco).<br>
                        ThenInclude(E.ClienteTabelaPreco.TabelaPreco).                           ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.).<br>
                    Include( E.ClienteEmpresa).ThenInclude(E.ClienteEmpresa.Empresa).<br>
                    Where( E.ID = 3 ).<br>
                    ToJson;

end;                    

## Authors

* **Lindemberg Cortez** - *Initial work*
