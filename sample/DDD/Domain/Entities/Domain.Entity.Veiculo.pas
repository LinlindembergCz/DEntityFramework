unit Domain.Entity.Veiculo;

interface

uses
  System.Classes, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Consts;

type
  [Table('Veiculos')]
  TVeiculo = class( TEntityBase )
  private
    FPlaca: TString;
    FClienteId: TInteger;
  public
  published
    [Column('Placa',varchar10,false)]
     property Placa: TString read FPlaca write FPlaca;
    [Column('ClienteId',Int,true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;

  end;

implementation

{ TVeiculo }

initialization RegisterClass(TVeiculo);
finalization UnRegisterClass(TVeiculo);

end.
