unit ClassAluno;

interface

uses
 System.Classes, Dialogs, SysUtils, EntityBase, EntityTypes, Atributies;

type
  [EntityTable('Aluno')]
  Aluno = class( TEntityBase )
  private
    FNome: TString;
    FMatricula: TString;
  public
     [EntityField('Nome','varchar(50) not null',true)]
     property Nome: TString read FNome write FNome;
     [EntityField('Matricula','varchar(10) not null',true)]
     property Matricula: TString read FMatricula write FMatricula;
  end;

implementation

initialization RegisterClass(Aluno);
finalization UnRegisterClass(Aluno);
end.
