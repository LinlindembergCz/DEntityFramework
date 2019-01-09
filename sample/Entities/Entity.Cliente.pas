unit Entity.Cliente;

interface

uses
  System.Classes, SysUtils,
  EF.Mapping.Atributes,
  EF.Mapping.Base,
  EF.Core.Types;

type
  [EntityTable('Clientes')]
  TCliente = class( TEntityBase )
  private
    FCPFCNPJ: TString;
    FRenda: TFloat;
    FIdade: TInteger;
    FNome: TString;
    FRG: TString;
    FDataNascimento: TTDatetime;
    FAtivo: TString;
    FNomeFantasia: TString;
    FApelido: TString;
    FSituacao: TString;
    FTipo: TString;
    FEstadoCivil: TString;
    FObservacao: TString;
    FCalcRenda: TFloat;
  public
  published
    [EntityField('Nome','varchar(50)',false)][EntityValueLengthMin(10)][Edit]
    property Nome: TString read FNome write FNome;
    [EntityField('NomeFantasia','varchar(50)',false)][Edit]
    property NomeFantasia: TString read FNomeFantasia write FNomeFantasia;
    [EntityField('CPFCNPJ','varchar(15)',true)][EntityValueLengthMin(11)][EntityNotNull][EntityNotSpecialChar][Edit]
    property CPFCNPJ: TString read FCPFCNPJ write FCPFCNPJ;
    [EntityField('Renda','float',true)][Edit]
    property Renda:TFloat read FRenda write FRenda;
    [EntityField('Idade','integer',true)][Edit]
    property Idade: TInteger read FIdade write FIdade;
    [EntityField('RG','varchar(10)',true)][EntityValueLengthMin(6)][Edit]
    property RG: TString read FRG write FRG;
    [EntityField('DataNascimento','Date',true)][DateTimePicker]
    property DataNascimento:TTDatetime read FDataNascimento write FDataNascimento;
    [EntityField('Ativo','varchar(1)',true)][CheckBox]
    property Ativo: TString read FAtivo write FAtivo;
    [EntityField('Situacao','varchar(20)',true)]
    [EntityItems('D=Demitido;A=Afastado;F=Folga;I=Impedido;L=Livre')]
    [EntityDefault('L')] [Combobox]
    property Situacao:TString read FSituacao write FSituacao;
    [EntityField('Tipo','varchar(20)',true)]
    [EntityItems('F=Fisica;J=Juridica')]
    [Combobox]
    property Tipo: TString read FTipo write FTipo;
    [EntityField('EstadoCivil','varchar(20)',true)][Combobox]
    property EstadoCivil: TString read FEstadoCivil write FEstadoCivil;
    [EntityField('Observacao','varchar(500)',true)][Memo]
    property Observacao:TString read FObservacao write FObservacao;
  end;

implementation

initialization RegisterClass(TCliente);
finalization UnRegisterClass(TCliente);
End.
