unit FactoryEntity;

interface

uses
  Sysutils,  EntityBase;

type
  TEnumEntities = ( tpCliente ,  tpFornecedor ,  tpFabricante , tpAluno, tpEntidade );

  TFactoryEntity = class
  private

  public
    class function GetEntity(aEntities: TEnumEntities): TEntityBase;
  end;

implementation

{ TFactoryEntity }

uses  AutoMapper;

class function TFactoryEntity.GetEntity(aEntities: TEnumEntities ):TEntityBase;
var
  Instance:TObject;
begin
  case aEntities of
    tpCliente    : result := TEntityBase( TAutoMapper.GetInstance( 'classCliente.TCliente' )).Create;
    tpFornecedor : result := TEntityBase( TAutoMapper.GetInstance( 'ClassFornecedor.Fornecedor' )).Create;
    tpFabricante : result := TEntityBase( TAutoMapper.GetInstance( 'ClassFabricante.Fabricante' )).Create;
    tpAluno : result := TEntityBase( TAutoMapper.GetInstance( 'ClassAluno.Aluno' )).Create;
//tpEntity: result := TEntityBase( TAutoMapper.GetInstance( 'classEntity.TEntity' )).Create;
  end;
end;

end.
