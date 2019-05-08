unit Domain.Entity.Produto;

interface

uses
  System.Classes,  Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Consts;

type
  [Table('Produto')]
  TProduto = class( TEntityBase )
  private
    FDescricao: string;
  public
    [FieldTable('Descricao',varchar50,false)]
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

initialization RegisterClass(TProduto);
finalization UnRegisterClass(TProduto);

end.
