unit RepositoryFabricante;

interface

uses
Classes, Repository, classFabricante, RepositoryBase, InterfaceRepositoryFabricante, InterfaceRepository,  Context, EntityBase;

type
  TRepositoryFabricante = class(TRepositoryBase ,IRepositoryFabricante)
  private
    _RepositoryFabricante:IRepository<Fabricante>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: Fabricante;
  end;

implementation

{ TRepositoryFabricante }

constructor TRepositoryFabricante.Create(dbContext:TContext);
begin
  _RepositoryFabricante := TRepository<Fabricante>.create(dbContext) ;
  _RepositoryBase    := _RepositoryFabricante As IRepository<TEntityBase>;
  //_RepositoryBase    :=  TRepository<Fabricante>.create(dbContext) As IRepository<TEntityBase>;
end;

function TRepositoryFabricante.GetEntity: Fabricante;
begin
  result:= _RepositoryFabricante.Entity;
end;

initialization RegisterClass(TRepositoryFabricante);
finalization UnRegisterClass(TRepositoryFabricante);

End.
