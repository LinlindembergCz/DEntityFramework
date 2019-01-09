unit InterfaceRepositoryAluno;

interface

uses
InterfaceRepository, ClassAluno;

type
  IRepositoryAluno = interface(IRepositoryBase)
    function GetEntity: Aluno;
  end;

implementation

end.
