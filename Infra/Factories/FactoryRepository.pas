unit FactoryRepository;

interface

uses
  Sysutils, FactoryEntity, InterfaceRepository, Dialogs;

type
  TFactoryRepository = class
  private
  public
    class function GetRepository(E: string): IRepositoryBase;
  end;

implementation

{ TFactoryEntity }
uses Context , EntityAutoMapper, RepositoryBase;


class function TFactoryRepository.GetRepository(E: string): IRepositoryBase;
var
  Repository     : IRepositoryBase;
  Instance      : TObject;
begin
  Instance := TAutoMapper.GetInstance( 'Repository'+E+'.TRepository'+E );
  if Instance <> nil then
  begin
    Repository :=  TRepositoryBase( Instance ).create( TContext.Create(E) );  //as IRepositoryBase
    result:= Repository;
  end;
end;


end.
