unit RepositoryFornecedor;

interface

uses
Classes, Repository, classFornecedor, RepositoryBase, InterfaceRepositoryFornecedor, InterfaceRepository,  Context, EntityBase;

type
  TRepositoryFornecedor = class(TRepositoryBase ,IRepositoryFornecedor)
  private
    _RepositoryFornecedor:IRepository<Fornecedor>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: Fornecedor;
  end;

implementation

{ TRepositoryFornecedor }

constructor TRepositoryFornecedor.Create(dbContext:TContext);
begin
  _RepositoryFornecedor := TRepository<Fornecedor>.create(dbContext) ;
  _RepositoryBase    := _RepositoryFornecedor As IRepository<TEntityBase>;
  //_RepositoryBase    :=  TRepository<Fornecedor>.create(dbContext) As IRepository<TEntityBase>;
end;

function TRepositoryFornecedor.GetEntity: Fornecedor;
begin
  result:= _RepositoryFornecedor.Entity;
end;

initialization RegisterClass(TRepositoryFornecedor);
finalization UnRegisterClass(TRepositoryFornecedor);

End.
