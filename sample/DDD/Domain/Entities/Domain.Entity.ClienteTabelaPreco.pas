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
    //FCliente: TCliente;

  public
    [FieldTable('ClienteId','Integer',true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;

    [FieldTable('TabelaPrecoId','Integer',true)]
    [ForeignKey('TabelaPrecoId','TabelaPrecos', rlCascade, rlCascade )]
    property TabelaPrecoId: TInteger read FTabelaPrecoId write FTabelaPrecoId;

    [NotMapper]
    property TabelaPreco: TTabelaPreco read  FTabelaPreco write FTabelaPreco;
    //[NotMapper]
    //property Cliente: TCliente read  FCliente write FCliente;

    constructor Create;override;
    procedure Initialize;override;
  end;

implementation



{ TClienteTabelaPreco }



constructor TClienteTabelaPreco.Create;
begin
  inherited;
end;

procedure TClienteTabelaPreco.Initialize;
begin
  inherited;
  TabelaPreco:= Collate.RegisterObject<TTabelaPreco>( TTabelaPreco.Create(true) );
  //Cliente:= TCliente.Create;
end;

initialization RegisterClass(TClienteTabelaPreco);
finalization UnRegisterClass(TClienteTabelaPreco);



end.
