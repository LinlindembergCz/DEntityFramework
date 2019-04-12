unit ClassTabelaPreco;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes;

type
  [EntityTable('TabelaPrecos')]
  TTabelaPreco = class( TEntityBase )
  private
    FDescricao: TString;
  public
    [EntityField('Descricao','varchar(50)',false)]
    property Descricao: TString read FDescricao write FDescricao;
  end;


implementation

initialization RegisterClass(TTabelaPreco);
finalization UnRegisterClass(TTabelaPreco);


end.
