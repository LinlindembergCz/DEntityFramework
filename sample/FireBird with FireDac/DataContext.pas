unit DataContext;

interface

uses EF.Engine.DbSet, EF.Engine.DbContext, Domain.Entity.Cliente, EF.Drivers.Connection;

type
  TDataContext = class(TDbContext)
  public
    Clientes : TDbset<TCliente>;
  //Funcionarios : TDbset<TFuncionarios>;
  //Fornecedores : TDbset<TFornecedores>;
    constructor Create( aDatabase: TDatabaseFacade );override;
    destructor Destroy;override;
  end;

implementation

{ BoundContext }

constructor TDataContext.Create( aDatabase: TDatabaseFacade );
begin
  inherited;
  Clientes := TDbset<TCliente>.create( aDatabase )
end;

destructor TDataContext.Destroy;
begin
  inherited;
  Clientes.Free;

end;

end.
