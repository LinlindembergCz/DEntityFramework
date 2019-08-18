unit Domain.Entity.Fornecedor;

interface

uses
  System.Classes, Dialogs, SysUtils, EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, System.Generics.Collections;

type
  TFornecedor = class( TEntityBase )
  private
    FCPFCNPJ: TString;
    FRazaoSocial: TString;
  published
    property RazaoSocial: TString read FRazaoSocial write FRazaoSocial;
    property CPFCNPJ: TString read FCPFCNPJ write FCPFCNPJ;
  end;

implementation

initialization RegisterClass(TFornecedor);
finalization UnRegisterClass(TFornecedor);

end.
