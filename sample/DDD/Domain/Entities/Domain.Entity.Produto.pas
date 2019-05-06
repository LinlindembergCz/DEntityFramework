unit Domain.Entity.Produto;

interface

uses
  System.Classes,  Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes;

type
  [TableName('Produto')]
  TProduto = class( TEntityBase )
  private
    FDescricao: string;
  public
    [FieldTable('Descricao','varchar(50)',false)]
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

initialization RegisterClass(TProduto);
finalization UnRegisterClass(TProduto);

end.
