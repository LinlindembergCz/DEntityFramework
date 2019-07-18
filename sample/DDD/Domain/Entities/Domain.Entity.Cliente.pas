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
    FCalcRenda: TFloat;

    FEmail:TEmail;
    FContados: TEntityList<TContato>;
    FVeiculo: TVeiculo;
    FClienteTabelaPreco: TClienteTabelaPreco;
    FClienteEmpresa: TClienteEmpresa;

  public
    constructor Create;override;
    procedure Validate; override;
  published
    [FieldTable('Nome', varchar50,false)]
    [LengthMin(10)]
    property Nome: TString read FNome write FNome;
    [FieldTable('NomeFantasia',varchar50,false)]
    property NomeFantasia: TString read FNomeFantasia write FNomeFantasia;
    [FieldTable('CPFCNPJ', varchar15,true)]
    [LengthMin(11)]
    [NoSpecialChar]
    property CPFCNPJ: TString read FCPFCNPJ write FCPFCNPJ;
    [FieldTable('Renda','float',true)]
    property Renda:TFloat read FRenda write FRenda;
    [FieldTable('Idade','integer',true)]
    property Idade: TInteger read FIdade write FIdade;
    [FieldTable('RG',varchar10,true)]
    [LengthMin(6)]
    property RG: TString read FRG write FRG;
    [FieldTable('DataNascimento','Date',true)]
    property DataNascimento:TDate read FDataNascimento write FDataNascimento;
    [FieldTable('Ativo',Char1 ,true)]
    property Ativo: TString read FAtivo write FAtivo;
    [FieldTable('Situacao',varchar20,true)]
    [Items(ItemsSituacaoCliente)]
    [Default('L')]
    property Situacao:TString read FSituacao write FSituacao;
    [FieldTable('Tipo',varchar20,true)]
    [Items( ItemsTipoPessoa )]
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

constructor TCliente.Create;
begin
  inherited;
  FEmail              := TEmail.Create;
  FVeiculo            := TVeiculo.Create;
  FClienteTabelaPreco := TClienteTabelaPreco.Create;
  FClienteEmpresa     := TClienteEmpresa.Create;
  FContados           := TEntityList<TContato>.create;
end;



procedure TCliente.Validate;
begin
  inherited;
 //Email.Validate;
end;


initialization RegisterClass(TCliente);
finalization UnRegisterClass(TCliente);

end.
