unit FactoryRepository;

interface

uses
  Sysutils, FactoryEntity, Repositorio.Interfaces.Base, EF.Mapping.Base;

type
  TFactoryRepository = class
  private
  public
    class function GetRepository<T:TEntitybase>(E: string ): IRepositoryBase<T>;
  end;

implementation

{ TFactoryEntity }
uses Context , EF.Mapping.AutoMapper, Repositorio.Base;


class function TFactoryRepository.GetRepository<T>(E: string): IRepositoryBase<T>;
var
  Repository    : IRepositoryBase<T>;
  Instance      : TEntitybase;
begin
  Instance := TAutoMapper.GetInstance<T>( 'Repositorio.'+E+'.TRepository'+E );
  if Instance <> nil then
  begin
    Repository :=  TRepositoryBase<T>( Instance ).create( TdbContext<T>.Create );  //as IRepositoryBase
    result:= Repository;
  end;
end;


end.
