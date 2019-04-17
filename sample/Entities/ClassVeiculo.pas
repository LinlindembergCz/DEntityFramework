unit ClassVeiculo;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes;

type
  [EntityTable('Veiculos')]
  TVeiculo = class( TEntityBase )
  private
    FPlaca: TString;
    FClienteId: TInteger;
  public
    [EntityField('Placa','varchar(10)',false)]
     property Placa: TString read FPlaca write FPlaca;
    [EntityField('ClienteId','Integer',true)]
    [EntityForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;
  end;

implementation



initialization RegisterClass(TVeiculo);
finalization UnRegisterClass(TVeiculo);

end.
