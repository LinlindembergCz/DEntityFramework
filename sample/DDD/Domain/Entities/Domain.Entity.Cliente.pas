unit Domain.Entity.Cliente;

interface

uses
  System.Classes,  Domain.ValuesObject.Email, Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Entity.Contato, Domain.Entity.Veiculo,Domain.Entity.ClienteTabelaPreco,
  System.Generics.Collections, Domain.Consts, Domain.Entity.ClienteEmpresa, EF.Core.List;

type
  [Table('Clientes')]
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
    FClienteEmpresa: TClienteEmpresa;
  public
    constructor Create;override;
    destructor Destroy;override;
    procedure Validation; override;
  published
    [FieldTable('Nome', varchar50,false)][LengthMin(10)]
    property Nome: TString read FNome write FNome;
    [FieldTable('NomeFantasia',varchar50,false)]
    property NomeFantasia: TString read FNomeFantasia write FNomeFantasia;
    [FieldTable('CPFCNPJ', varchar15,true)][LengthMin(11)][NotNull][NotSpecialChar]
    property CPFCNPJ: TString read FCPFCNPJ write FCPFCNPJ;
    [FieldTable('Renda','float',true)]
    property Renda:TFloat read FRenda write FRenda;
    [FieldTable('Idade','integer',true)]
    property Idade: TInteger read FIdade write FIdade;
    [FieldTable('RG','varchar(10)',true)][LengthMin(6)]
    property RG: TString read FRG write FRG;
    [FieldTable('DataNascimento','Date',true)]
    property DataNascimento:TDate read FDataNascimento write FDataNascimento;
    [FieldTable('Ativo','varchar(1)',true)]
    property Ativo: TString read FAtivo write FAtivo;
    [FieldTable('Situacao',varchar20,true)]
    [Items(ItemsSituacaoCliente)]
    [Default('L')]
    property Situacao:TString read FSituacao write FSituacao;
    [FieldTable('Tipo',varchar20,true)]
    [Items('F=Fisica;J=Juridica')]
    property Tipo: TString read FTipo write FTipo;
    [FieldTable('EstadoCivil',varchar20,true)]
    property EstadoCivil: TString read FEstadoCivil write FEstadoCivil;
    [FieldTable('Observacao',varchar500,true)]
    property Observacao:TString read FObservacao write FObservacao;
    property Email:TEmail read FEmail write FEmail;
    [NotMapper]
    property Contatos: TEntityList<TContato> read FContados write FContados;
    [NotMapper]
    property Veiculo: TVeiculo read  FVeiculo write FVeiculo;
    [NotMapper]
    property ClienteTabelaPreco: TClienteTabelaPreco  read  FClienteTabelaPreco write FClienteTabelaPreco;
    [NotMapper]
    property ClienteEmpresa: TClienteEmpresa read FClienteEmpresa write FClienteEmpresa;

  end;

implementation

uses GenericFactory;

constructor TCliente.Create;
begin
  inherited;
  FEmail              := TGenericFactory.CreateInstance<TEmail>;
  FVeiculo            := TGenericFactory.CreateInstance<TVeiculo>;
  FClienteTabelaPreco := TGenericFactory.CreateInstance<TClienteTabelaPreco>;
  FClienteEmpresa     := TGenericFactory.CreateInstance<TClienteEmpresa>;
  FContados           := TEntityList<TContato>.create;
end;

destructor TCliente.Destroy;
begin
  inherited;
end;

procedure TCliente.Validation;
begin
  inherited;
  //Email.validar;
end;

{ TContatos }

initialization RegisterClass(TCliente);
finalization UnRegisterClass(TCliente);

end.
