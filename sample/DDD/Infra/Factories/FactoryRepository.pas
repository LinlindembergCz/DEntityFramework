unit FactoryRepository;

interface

uses
  Sysutils, FactoryEntity, InterfaceRepository, EF.Mapping.Base, System.Generics.Collections;

type
  TFactoryRepository = class
  private
  public
    class function GetRepository<T:TEntitybase>(E: string ): IRepositoryBase<TEntitybase>;
  end;

implementation

{ TFactoryEntity }
uses Context , EF.Mapping.AutoMapper, RepositoryBase, classCliente;


class function TFactoryRepository.GetRepository<T>(E: string): IRepositoryBase<TEntitybase>;
var
  Repository    : IRepositoryBase<TEntitybase>;
  Instance      : TEntitybase;
begin
  Instance := TAutoMapper.GetInstance<T>( 'Repository'+E+'.TRepository'+E );
  if Instance <> nil then
  begin
    Repository :=  TRepositoryBase<TEntitybase>( Instance ).create( TContext.Create(E) );  //as IRepositoryBase
    result:= Repository;
  end;
end;


end.
