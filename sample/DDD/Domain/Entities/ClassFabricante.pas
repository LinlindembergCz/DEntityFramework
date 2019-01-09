unit ClassFabricante;

interface

uses
 System.Classes, Dialogs, SysUtils, EntityBase, EntityTypes, Atributies;

type
  [EntityTable('Fabricante')]
  Fabricante = class( TEntityBase )
  private
    FCNPJ: TString;
    FRazaoSocial: TString;
  public
     [EntityField('CNPJ','varchar(20) ',true)]
     property CNPJ: TString read FCNPJ write FCNPJ;
     [EntityField('RazaoSocial','varchar(50) ',true)]
     property RazaoSocial: TString read FRazaoSocial write FRazaoSocial;
  end;

implementation

initialization RegisterClass(Fabricante);
finalization UnRegisterClass(Fabricante);
end.
