unit Domain.Entity.Veiculo;

interface

uses
  System.Classes, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes;

type
  [Table('Veiculos')]
  TVeiculo = class( TEntityBase )
  private
    FPlaca: TString;
    FClienteId: TInteger;
  public
    [FieldTable('Placa','varchar(10)',false)]
     property Placa: TString read FPlaca write FPlaca;
    [FieldTable('ClienteId','Integer',true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;
  end;

implementation



initialization RegisterClass(TVeiculo);
finalization UnRegisterClass(TVeiculo);

end.
