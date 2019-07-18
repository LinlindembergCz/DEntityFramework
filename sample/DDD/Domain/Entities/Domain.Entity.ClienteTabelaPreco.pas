unit Domain.Entity.ClienteTabelaPreco;

interface

uses
  System.Classes,   Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Entity.TabelaPreco;

type
  [Table('ClienteTabelaPreco')]
  TClienteTabelaPreco = class( TEntityBase )
  private
    FClienteId: TInteger;
    FTabelaPrecoId: TInteger;
    FTabelaPreco: TTabelaPreco;
  published
    [Column('ClienteId','Integer',true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;

    [Column('TabelaPrecoId','Integer',true)]
    [ForeignKey('TabelaPrecoId','TabelaPrecos', rlCascade, rlCascade )]
    property TabelaPrecoId: TInteger read FTabelaPrecoId write FTabelaPrecoId;

    [NotMapped]
    property TabelaPreco: TTabelaPreco read  FTabelaPreco write FTabelaPreco;

    constructor Create;override;

  end;

implementation

uses GenericFactory;

{ TClienteTabelaPreco }

constructor TClienteTabelaPreco.Create;
begin
  inherited;
  TabelaPreco:=  TGenericFactory.CreateInstance<TTabelaPreco>;
end;


initialization RegisterClass(TClienteTabelaPreco);
finalization UnRegisterClass(TClienteTabelaPreco);



end.
