unit FactoryRepository;

interface

uses
  Sysutils, EnumEntity, InterfaceRepository, Dialogs;

type
  TFactoryRepository = class
  private
    class function GetRepositoryClassName(E: TEnumEntities): string; static;
  public
    class function GetRepository(E: TEnumEntities): IRepositoryBase;
  end;

implementation

{ TFactoryEntity }
uses Context , AutoMapper, RepositoryBase;


class function TFactoryRepository.GetRepositoryClassName( E: TEnumEntities):string;
begin
  case E of
     tpCliente   : result:= 'RepositoryCliente.TRepositoryCliente';
     tpFornecedor: result:= 'RepositoryFornecedor.TRepositoryFornecedor';
     tpFabricante: result:= 'RepositoryFabricante.TRepositoryFabricante';
       tpAluno : result:= 'RepositoryAluno.TRepositoryAluno';
//tpEntity: result:= RepositoryEntity.TRepositoryEntity;
  else
    begin
      showmessage('Verificar declaração "initialization RegisterClass" requerido do Repository !');
      abort;
    end;
  end;
end;

class function TFactoryRepository.GetRepository(E: TEnumEntities): IRepositoryBase;
var
  Repository     : IRepositoryBase;
  Instance      : TObject;
begin
  Instance := TAutoMapper.GetInstance( GetRepositoryClassName( E ) );
  if Instance <> nil then
  begin
    Repository :=  TRepositoryBase( Instance ).create( TContext.Create(E) )as IRepositoryBase;
    result:= Repository;
  end;
end;


end.
