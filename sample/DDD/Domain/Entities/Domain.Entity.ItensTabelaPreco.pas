unit Domain.Entity.ItensTabelaPreco;

interface

uses
  System.Classes,   Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Entity.Produto;

type
  [Table('ItensTabelaPreco')]
  TItensTabelaPreco = class( TEntityBase )
  private
    FTabelaPrecoId: TInteger;
    FProdutoId: TInteger;
    FValor: TFloat;
    FProduto: TProduto;
  published
    [Column('ProdutoId','integer',false)]
    property ProdutoId:TInteger read FProdutoId write FProdutoId;

    [Column('TabelaPrecoId','integer',false)]
    property TabelaPrecoId:TInteger read FTabelaPrecoId write FTabelaPrecoId;

    [Column('Valor','float',false)]
    property Valor: TFloat read FValor write FValor;

    [NotMapped]
    property Produto: TProduto read  FProduto write FProduto;
    constructor Create;override;
  end;

implementation

{ TItensTabelaPreco }

constructor TItensTabelaPreco.Create;
begin
  inherited;
  Produto :=  TProduto.Create;
end;



initialization RegisterClass(TItensTabelaPreco);
finalization UnRegisterClass(TItensTabelaPreco);

end.
