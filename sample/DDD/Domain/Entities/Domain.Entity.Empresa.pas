unit Domain.Entity.Empresa;

interface

uses
  System.Classes, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Consts;

type
  [Table('Empresas')]
  TEmpresa = class( TEntityBase )
  private
    FDescricao: TString;
    FCNPJ: TString;
  published
    [FieldTable('Descricao',varchar20,false)]
    property Descricao: TString read FDescricao write FDescricao;
    [FieldTable('CNPJ',varchar20,false)]
    property CNPJ: TString read FCNPJ write FCNPJ;
  end;

implementation

initialization RegisterClass(TEmpresa);
finalization UnRegisterClass(TEmpresa);

end.
