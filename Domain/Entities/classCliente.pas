unit classCliente;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils, EntityBase, EntityTypes, Atributies;

type
  [EntityTable('Clientes')]
  TCliente = class( TEntityBase )
  private
    FCPFCNPJ: TString;
    FRenda: TFloat;
    FIdade: TInteger;
    FNome: TString;
    FRG: TString;
    FDataNascimento: TEntityDatetime;
    FAtivo: TString;
    FNomeFantasia: TString;
    FApelido: TString;
    FSituacao: TString;
    FTipo: TString;
    FEstadoCivil: TString;
    FObservacao: TString;
    FEmail:TEmail;
    FCalcRenda: TFloat;
  public
    constructor Create;override;
    destructor Destroy;override;
    procedure Validation; override;
  published
    [EntityField('Nome','varchar(50)',false)]
    property Nome: TString read FNome write FNome;
    [EntityField('NomeFantasia','varchar(50)',false)]
    property NomeFantasia: TString read FNomeFantasia write FNomeFantasia;
    [EntityField('CPFCNPJ','varchar(15)',true)]
    [EntityNotNull]
    [EntityNotSpecialChar]
    property CPFCNPJ: TString read FCPFCNPJ write FCPFCNPJ;
    [EntityField('Renda','float',true)]
    property Renda:TFloat read FRenda write FRenda;
    [EntityField('Idade','integer',true)]
    property Idade: TInteger read FIdade write FIdade;
    [EntityField('RG','varchar(10)',true)]
    property RG: TString read FRG write FRG;
    [EntityField('DataNascimento','Date',true)]
    property DataNascimento:TEntityDatetime read FDataNascimento write FDataNascimento;
    [EntityField('Ativo','varchar(1)',true)]
    property Ativo: TString read FAtivo write FAtivo;
    [EntityField('Situacao','varchar(20)',true)]
    [EntityItems('D=Demitido;A=Afastado;F=Folga;I=Impedido;L=Livre')]
    [EntityDefault('L')]
    property Situacao:TString read FSituacao write FSituacao;
    [EntityField('Tipo','varchar(20)',true)]
    [EntityItems('Fisica;Juridica')]
    property Tipo: TString read FTipo write FTipo;
    [EntityField('EstadoCivil','varchar(20)',true)]
    property EstadoCivil: TString read FEstadoCivil write FEstadoCivil;
    [EntityField('Observacao','varchar(500)',true)]
    property Observacao:TString read FObservacao write FObservacao;
    [EntityField('Email','varchar(100)',true)]
    property Email:TEmail read FEmail write FEmail;

    [EntityExpression('CalcRenda','Renda * 2')]
    property CalcRenda:TFloat read FCalcRenda;
  end;

implementation

constructor TCliente.Create;
begin
  inherited;
  Email:= TEmail.Create;
end;

destructor TCliente.Destroy;
begin
  Email.free;
end;

procedure TCliente.Validation;
begin
  inherited;
  //Email.validar;
end;

initialization RegisterClass(TCliente);
finalization UnRegisterClass(TCliente);

end.
