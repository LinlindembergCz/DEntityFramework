unit ClassCFOP;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils, EntityBase, EntityTypes, Atributies;

type
  [EntityTable('CFOP')]
  TCFOP = class( TEntityBase )
  private
    FCodigo: string;
    FDescricao: string;
  public
    [EntityField('Codigo','varchar(4)',false)][EntityValueLengthMin(4)][Edit]
    property Codigo: string read FCodigo write FCodigo;
    [EntityField('Descricao','varchar(50)',false)][EntityValueLengthMin(50)][Edit]
    property Descricao : string read FDescricao write FDescricao;
  end;

implementation

initialization RegisterClass(TCFOP);
finalization UnRegisterClass(TCFOP);

end.

