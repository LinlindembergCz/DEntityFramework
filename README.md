# DEntityFramework
DEntityFramework

It's EntityFramework for Delphi

Mapeamento de classes de entidade POCO ;<br>
Controle de alterações automático ;<br>
Conversão das consultas fortemente tipadas usando LINQ ;<br>
Conectividade de banco de dados com base no FireDAC e vários ; <br>
provedores disponíveis para se conectar ao SQL Server,  MySQL, FireBird, PostGree<br>

<br><br>

Mapping of POCO entity classes; <br>
Automatic change control; <<br>
Conversion of strongly typed queries using LINQ; <br>
Database connectivity based on FireDAC and various; <br>
providers available to connect to SQL Server, MySQL, FireBird, PostGree<br><br>

## Requirements

Embarcadero Delphi XE or higher.

## How to use:

In short, add the following path to your Delphi IDE (in the Tools/Environment/Library menu)

* Library path:

...\EntityFramework\source

## Demos

* ...\EntityFramework\sample\DDD (Domain Driven Design)
* ...\EntityFramework\sample\Testes (TDD)

begin<br>
    _Db := TDataContext.Create(DataModule1.FConnection);
    
   C :=  _Db.Clientes.Include( E.Veiculo ).<br>
                    Include( E.Contatos ).<br>
                    Include( E.ClienteTabelaPreco).<br>
                        ThenInclude(E.ClienteTabelaPreco.TabelaPreco).                           ThenInclude(E.ClienteTabelaPreco.TabelaPreco.ItensTabelaPreco.).<br>
                    Include( E.ClienteEmpresa).ThenInclude(E.ClienteEmpresa.Empresa).<br>
                    Where( E.ID = 3 ).<br>
                    ToJson;<br><br><br>
                    
                    
   L  := _Db.Clientes.Include(E.Veiculo)
                    .Include(E.Contatos)
                    .ToList( E.Ativo = '1' );                    
                    
                    

end;                    
<br><br>
var<br>
  Query: IQueryAble;<br>
begin<br>
  Query := From(TPessoa).<br>
                inner( Pessoa.Endereco , Pessoa.Endereco.PessoaId = Pessoa.Id ).<br>
                innerLeft( PessoaFisica, PessoaFisica.Id=Pessoa.Id).<br>
                Where(Pessoa.Id=1).<br>
                OrderBy(Pessoa,[Pessoa.Nome]).<br>
                Select([Pessoa.Nome]);<br>
end;<br><br>

Other:

TDbContext;
TDbset<T>;
EF.QueryAble.Linq;

Add;<br>
AddRange
Update;<br>
UpdateRange;<br>
Remove;<br>
RemoveRange;<br>
SaveChanges;<br>
Find;<br>
ToList;<br>
ToJson;<br>
ToDataSet;<br>




## Authors

* **Lindemberg Cortez** - *Initial work*
