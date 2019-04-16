unit ClassCliente;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, ClassContato, ClassVeiculo,ClassClienteTabelaPreco, System.Generics.Collections;

type

  [EntityTable('Clientes')]
  TCliente = class( TEntityBase )
  private
    FCPFCNPJ: TString;
    FRenda: TFloat;
    FIdade: TInteger;
    FNome: TString;
    FRG: TString;
    FDataNascimento: TDate;
    FAtivo: TString;
    FNomeFantasia: TString;
    FApelido: TString;
    FSituacao: TString;
    FTipo: TString;
    FEstadoCivil: TString;
    FObservacao: TString;
    FEmail:TEmail;
    FCalcRenda: TFloat;
    FContados: TEntityList<TContato>;
    FVeiculo: TVeiculo;
    FClienteTabelaPreco: TClienteTabelaPreco;

    procedure Initialize;override;
  public
    constructor Create;override;
    destructor Destroy;override;
    procedure Validation; override;
  published
    [EntityField('Nome','varchar(50)',false)][LengthMin(10)][Edit]
    property Nome: TString read FNome write FNome;
    [EntityField('NomeFantasia','varchar(50)',false)][Edit]
    property NomeFantasia: TString read FNomeFantasia write FNomeFantasia;
    [EntityField('CPFCNPJ','varchar(15)',true)][LengthMin(11)][NotNull][EntityNotSpecialChar][Edit]
    property CPFCNPJ: TString read FCPFCNPJ write FCPFCNPJ;
    [EntityField('Renda','float',true)][Edit]
    property Renda:TFloat read FRenda write FRenda;
    [EntityField('Idade','integer',true)][Edit]
    property Idade: TInteger read FIdade write FIdade;
    [EntityField('RG','varchar(10)',true)][LengthMin(6)][Edit]
    property RG: TString read FRG write FRG;
    [EntityField('DataNascimento','Date',true)][DateTimePicker]
    property DataNascimento:TDate read FDataNascimento write FDataNascimento;
    [EntityField('Ativo','varchar(1)',true)][CheckBox]
    property Ativo: TString read FAtivo write FAtivo;
    [EntityField('Situacao','varchar(20)',true)]
    [EntityItems('D=Demitido;A=Afastado;F=Folga;I=Impedido;L=Livre')]
    [Default('L')] [Combobox]
    property Situacao:TString read FSituacao write FSituacao;
    [EntityField('Tipo','varchar(20)',true)]
    [EntityItems('F=Fisica;J=Juridica')]
    [Combobox]
    property Tipo: TString read FTipo write FTipo;
    [EntityField('EstadoCivil','varchar(20)',true)][Combobox]
    property EstadoCivil: TString read FEstadoCivil write FEstadoCivil;
    [EntityField('Observacao','varchar(500)',true)][Memo]
    property Observacao:TString read FObservacao write FObservacao;
    [Edit]
    property Email:TEmail read FEmail write FEmail;
    [NotMapper]
    property Contatos: TEntityList<TContato> read FContados write FContados;
    [NotMapper]
    property Veiculo: TVeiculo read  FVeiculo write FVeiculo;
    [NotMapper]
    property ClienteTabelaPreco: TClienteTabelaPreco  read  FClienteTabelaPreco write FClienteTabelaPreco;

  end;

implementation


constructor TCliente.Create;
begin
  CollateOn:= true;
  inherited Create;
  Initialize;
end;

destructor TCliente.Destroy;
begin
  inherited;
end;

procedure TCliente.Initialize;
begin
  inherited;
  Email    := Collate.RegisterObject<TEmail>(  TEmail.Create );
  Veiculo  := Collate.RegisterObject<TVeiculo>(  TVeiculo.create );

  ClienteTabelaPreco:= Collate.RegisterObject<TClienteTabelaPreco>( TClienteTabelaPreco.Create(true) );
  ClienteTabelaPreco.Initialize;

  Contatos:= Collate.RegisterObjectList<TContato>(
                                     TEntityList<TContato>.create(
                                             TContato.create ) );

  //TEntityList<TContato>.create(TContato.create);

end;

procedure TCliente.Validation;
begin
  inherited;
  Email.validar;
end;

{ TContatos }

initialization RegisterClass(TCliente);
finalization UnRegisterClass(TCliente);

end.
