unit ClassTabelaPreco;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, ClassItensTabelaPreco;

type
  [EntityTable('TabelaPrecos')]
  TTabelaPreco = class( TEntityBase )
  private
    FDescricao: TString;
    FItensTabelaPreco: TEntityList<TItensTabelaPreco>;
    procedure Initialize;
  public
    [EntityField('Descricao','varchar(50)',false)]
    property Descricao: TString read FDescricao write FDescricao;
    [NotMapper]
    property ItensTabelaPreco: TEntityList<TItensTabelaPreco> read FItensTabelaPreco write FItensTabelaPreco;
    constructor Create;override;
    destructor Destroy;override;
  end;


implementation

{ TTabelaPreco }

constructor TTabelaPreco.Create;
begin
   CollateOn:= true;
   inherited Create;
   Initialize;
end;

destructor TTabelaPreco.Destroy;
begin
   //ItensTabelaPreco.Free;
   inherited;
end;

procedure TTabelaPreco.Initialize;
begin
  inherited;
  ItensTabelaPreco:= Collate.RegisterObjectList<TItensTabelaPreco>(
                                     TEntityList<TItensTabelaPreco>.create(
                                             TItensTabelaPreco.create(true) ) );
 { TabelaPreco:= Collate.RegisterObject<TTabelaPreco>( TTabelaPreco.Create(true) );
  TabelaPreco.Initialize;}
end;


initialization RegisterClass(TTabelaPreco);
finalization UnRegisterClass(TTabelaPreco);


end.
