unit Domain.Entity.TabelaPreco;

interface

uses
  System.Classes, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,EF.Core.List,
  EF.Mapping.Atributes, Domain.Entity.ItensTabelaPreco, Domain.Consts;

type
  [Table('TabelaPrecos')]
  TTabelaPreco = class( TEntityBase )
  private
    FDescricao: TString;
    FItensTabelaPreco: TEntityList<TItensTabelaPreco>;
  public
    constructor Create;override;
  published
    [FieldTable('Descricao',varchar50,false)]
    property Descricao: TString read FDescricao write FDescricao;
    [NotMapper]
    property ItensTabelaPreco: TEntityList<TItensTabelaPreco> read FItensTabelaPreco write FItensTabelaPreco;
  end;


implementation

{ TTabelaPreco }

constructor TTabelaPreco.Create;
begin
   inherited;
   ItensTabelaPreco:= TEntityList<TItensTabelaPreco>.create;
end;


initialization RegisterClass(TTabelaPreco);
finalization UnRegisterClass(TTabelaPreco);


end.
