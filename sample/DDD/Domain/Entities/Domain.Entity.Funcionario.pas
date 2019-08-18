unit Domain.Entity.Funcionario;

interface

uses
  System.Classes,  Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, System.Generics.Collections;

type
  TFuncionario = class( TEntityBase )
  private
    FCPF: TString;
    FNome: TString;
  published
    property Nome: TString read FNome write FNome;
    property CPF: TString read FCPF write FCPF;
  end;

implementation

initialization RegisterClass(TFuncionario);
finalization UnRegisterClass(TFuncionario);

end.
