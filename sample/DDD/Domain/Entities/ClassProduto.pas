unit ClassProduto;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes;

type
  [EntityTable('Produtos')]
  TProduto = class( TEntityBase )
  private
    FDescricao: string;
  public
    [EntityField('Descricao','varchar(50)',false)]
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

initialization RegisterClass(TProduto);
finalization UnRegisterClass(TProduto);

end.
