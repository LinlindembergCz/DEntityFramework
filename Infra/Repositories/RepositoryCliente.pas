unit RepositoryCliente;

interface

uses
Classes, Repository, classCliente, RepositoryBase, InterfaceRepositoryCliente, InterfaceRepository,  Context, EntityBase;

type
  TRepositoryCliente = class(TRepositoryBase ,IRepositoryCliente)
  private
    _RepositoryCliente:IRepository<TCliente>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: TCliente;
  end;

implementation

{ TRepositoryCliente }

constructor TRepositoryCliente.Create(dbContext:TContext);
begin
  _RepositoryCliente := TRepository<TCliente>.create(dbContext) ;
  _RepositoryBase    := _RepositoryCliente As IRepository<TEntityBase>;
end;

function TRepositoryCliente.GetEntity: TCliente;
begin
  result:= _RepositoryCliente.Entity;
end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
