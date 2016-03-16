unit FactoryRepository;

interface

uses
  Sysutils, EnumEntity, InterfaceRepository;

type
  TFactoryRepository = class
  private

  public
    class function GetRepository(E: TEnumEntities): IRepositoryBase;
  end;

implementation

{ TFactoryEntity }
uses Context, RepositoryCliente, RepositoryFornecedor, RepositoryFabricante;//RepositoryEntity;

class function TFactoryRepository.GetRepository(E: TEnumEntities): IRepositoryBase;
begin
  case E of
    tpCliente : result:= TRepositoryCliente.Create( TContext.Create(E) ) as IRepositoryBase;
    tpFornecedor : result:= TRepositoryFornecedor.Create( TContext.Create(E) ) as IRepositoryBase;
    tpFabricante: result:= TRepositoryFabricante.Create( TContext.Create(E) ) as IRepositoryBase;
//tpEntity: result := TRepositoryEntity.Create( TContext.Create(E) ) as IRepositoryBase;
  end;
end;

end.
