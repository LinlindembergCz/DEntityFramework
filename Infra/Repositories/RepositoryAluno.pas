unit RepositoryAluno;

interface

uses
System.Classes, Repository, classAluno, RepositoryBase, InterfaceRepositoryAluno, InterfaceRepository,  Context, EntityBase;

type
  TRepositoryAluno = class(TRepositoryBase ,IRepositoryAluno)
  private
    _RepositoryAluno:IRepository<Aluno>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: Aluno;
  end;

implementation

{ TRepositoryAluno }

constructor TRepositoryAluno.Create(dbContext:TContext);
begin
  _RepositoryAluno := TRepository<Aluno>.create(dbContext) ;
  _RepositoryBase    := _RepositoryAluno As IRepository<TEntityBase>;
  //_RepositoryBase    :=  TRepository<Aluno>.create(dbContext) As IRepository<TEntityBase>;
end;

function TRepositoryAluno.GetEntity: Aluno;
begin
  result:= _RepositoryAluno.Entity;
end;

initialization RegisterClass(TRepositoryAluno);
finalization UnRegisterClass(TRepositoryAluno);

End.



