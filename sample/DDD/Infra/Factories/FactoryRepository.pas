unit FactoryRepository;

interface

uses
  Sysutils, FactoryEntity, infra.Interfaces.Repositorios.Repositorybase, EF.Mapping.Base, System.Generics.Collections;

type
  TFactoryRepository = class
  private
  public
    class function GetRepository<T:TEntitybase>(E: string ): IRepositoryBase<T>;
  end;

implementation

{ TFactoryEntity }
uses Context , EF.Mapping.AutoMapper, Infra.Repository.Base;


class function TFactoryRepository.GetRepository<T>(E: string): IRepositoryBase<T>;
var
  Repository    : IRepositoryBase<T>;
  Instance      : TEntitybase;
begin
  Instance := TAutoMapper.GetInstance<T>( 'Infra.Repository.'+E+'.TRepository'+E );
  if Instance <> nil then
  begin
    Repository :=  TRepositoryBase<T>( Instance ).create( TdbContext.Create(E) );  //as IRepositoryBase
    result:= Repository;
  end;
end;


end.
