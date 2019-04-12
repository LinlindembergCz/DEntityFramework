unit ClassClienteTabelaPreco;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, ClassTabelaPreco;

type
  [EntityTable('ClienteTabelaPreco')]
  TClienteTabelaPreco = class( TEntityBase )
  private
    FClienteId: TInteger;
    FTabelaPrecoId: TInteger;
    FTabelaPreco: TTabelaPreco;
  public
    [EntityField('ClienteId','Integer',true)]
    [EntityForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;

    [EntityField('TabelaPrecoId','Integer',true)]
    [EntityForeignKey('TabelaPrecoId','TabelaPrecos', rlCascade, rlCascade )]
    property TabelaPrecoId: TInteger read FTabelaPrecoId write FTabelaPrecoId;

    [NotMapper]
    property TabelaPreco: TTabelaPreco read  FTabelaPreco write FTabelaPreco;

    constructor Create;override;
  end;

implementation



{ TClienteTabelaPreco }

constructor TClienteTabelaPreco.Create;
begin
  inherited;
  TabelaPreco:= TTabelaPreco.Create;
end;

initialization RegisterClass(TClienteTabelaPreco);
finalization UnRegisterClass(TClienteTabelaPreco);



end.
