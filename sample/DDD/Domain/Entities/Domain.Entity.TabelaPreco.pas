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
    FItensTabelaPreco: Collection<TItensTabelaPreco>;
  public
    constructor Create;override;
  published
    [Column('Descricao',varchar50,false)]
    property Descricao: TString read FDescricao write FDescricao;
    [NotMapped]
    property ItensTabelaPreco: Collection<TItensTabelaPreco> read FItensTabelaPreco write FItensTabelaPreco;
  end;


implementation

{ TTabelaPreco }

constructor TTabelaPreco.Create;
begin
   inherited;
   ItensTabelaPreco:= Collection<TItensTabelaPreco>.create;
end;


initialization RegisterClass(TTabelaPreco);
finalization UnRegisterClass(TTabelaPreco);


end.
