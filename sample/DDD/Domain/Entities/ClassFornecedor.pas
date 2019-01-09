unit ClassFornecedor;

interface

uses
 System.Classes, Dialogs, SysUtils, EntityBase, EntityTypes, Atributies;

type
  [EntityTable('Fornecedor')]
  Fornecedor = class( TEntityBase )
  private
    FRazaoSocial: TString;
    FCNPJ: TString;
  public
     [EntityField('RazaoSocial','varchar(50) ',true)]
     property RazaoSocial: TString read FRazaoSocial write FRazaoSocial;
     [EntityField('CNPJ','varchar(50) ',true)]
     property CNPJ: TString read FCNPJ write FCNPJ;
  end;

implementation

initialization RegisterClass(Fornecedor);
finalization UnRegisterClass(Fornecedor);
end.
