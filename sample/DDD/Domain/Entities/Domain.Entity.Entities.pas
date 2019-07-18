unit Domain.Entity.Entities;

interface

uses
  System.Classes, Dialogs, SysUtils, EF.Mapping.Base, EF.Core.Types, EF.Mapping.Atributes, Domain.ValuesObject.CPF, Domain.Entity.Cliente;

type
  [Table('Endereco')]
  TEndereco = class( TEntityBase )
  private
    FLogradouro: TString;
    FPessoaId:TInteger;
  public
    [Column('Logradouro','varchar(50)',true)]
    property Logradouro: TString read FLogradouro write FLogradouro;
    [Column('PessoaId','integer',false)]
    property PessoaId: TInteger read FPessoaId write FPessoaId;
  end;

  [Table('Pessoa')]
  TPessoa = class( TEntityBase)
  private
    FNome: TString;
    FSalario: TFloat;
    FEndereco: TEndereco;
  public
    constructor Create;
  published
    [Column('Nome','varchar(50)',true)]
    property Nome: TString read FNome write FNome;
    [Reference('Pessoa.Id = Endereco.PessoaId')]
    property Endereco:TEndereco read FEndereco write FEndereco;
    [Column('Salario','float',true)]
    property Salario: TFloat read FSalario write FSalario;
  end;

  [Table('PessoaFisica')]
  TPessoaFisica = class( TPessoa )
  private
    FCPFCNPJ: TCPF;
    FIdade: TInteger;
    FComissao: TFloat;
    FDataNascimento: TDate;
  published
    [Column('CPF','varchar(11)',true)]
    property CPFCNPJ: TCPF read FCPFCNPJ write FCPFCNPJ;
    [Column('Idade','integer',true)]
    property Idade: TInteger read FIdade write FIdade;
    [Column('Comissao','float', true)]
    property Comissao: TFloat read FComissao write FComissao;
    [Column('DataNascimento','Datetime',true)]
    property DataNascimento:TDate read FDataNascimento write FDataNascimento;
  end;

  [Table('PessoaJuridica')]
  TPessoaJuridica = class( TPessoa )
  private
    FCNPJ: TString;
  published
    [Column('CNPJ','varchar(15)',true)]
    property CNPJ: TString read FCNPJ write FCNPJ;
  end;

  [Table('Produto')]
  TProduto = class ( TEntityBase )
  private
    FDescricao: TString;
    FUNidade:TString;
    FPrecoVenda:TFloat;
  published
    [Column('Descricao','varchar(50)',true)]
    [MaxLength(20)]
    property Descricao: TString read FDescricao write FDescricao;
    [Column('Unidade','varchar(5)',true)]
    [Default('UN')]
    property Unidade: TString read FUnidade write FUnidade;
    [Column('PrecoVenda','float',true)]
    //[EntityDefault('0')]
    property PrecoVenda: TFloat read FPrecoVenda write FPrecoVenda;
  end;

  TItens = class(TEntityBase)
  private
     FProduto: TProduto;
     FDescricao: TString;
  public
     [Reference('IdProduto=Produto.Id')]
     property Produto: TProduto read FProduto write FProduto;
     [Column('Descricao','', true)]
     property Descricao: TString read FDescricao write FDescricao;
     constructor Create;
  end;

  [Table('ItensOrcamento')]
  TItensOrcamento = class(TItens)
  private
    FIdProduto: TInteger;
    FValor: TFloat;
    FQuantidade: TFloat;
    FIdOrcamento: TInteger;
    FDescricao:TString;
  public
    //[EntityField('IdOrcamento','integer',true,true)]
    property IdOrcamento :TInteger read FIdOrcamento write FIdOrcamento;
  published
    //[EntityField('Quantidade','Float', true)]
    property Quantidade: TFloat read FQuantidade write FQuantidade;
    //[EntityField('Valor','Float', true)]
    property Valor: TFloat read FValor write FValor;
    //[EntityField('IdProduto','integer', true, true )]
    property IdProduto: TInteger read FIdProduto write FIdProduto;
  end;

  [Table('Orcamento')]
  TOrcamento = class ( TEntityBase )
  private
    FIdCliente: TInteger;
    FData: TDate;
    FCliente:TCliente;
  public
    [Reference('IdCliente=Clientes.Id')]
    property Cliente: TCliente read FCliente write FCliente;
    constructor Create;
  published
    //[EntityField('Data','date',true)]
    property Data:TDate read FData write FData;
    //[EntityField('IdCliente','integer',true)]
    property IdCliente: TInteger read FIdCliente write FIdCliente;
  end;

  //Classe mapeada!
  [Table('ClassificacaoPessoa')]
  TClassificacaoPessoa = class(TEntityBase)
  private
    FDescricao: TString;
  public
    [Column('Descricao','varchar(20)',false)]
    property Descricao:TString read FDescricao write FDescricao;
  end;

implementation

{ TEntityBase }


{ Titens }

constructor Titens.Create;
begin
  inherited;
  FProduto:= TProduto.Create;
end;

{ TPessoa }

constructor TPessoa.Create;
begin
  inherited;
  FEndereco:= TEndereco.Create;
end;

{ TOrcamento }

constructor TOrcamento.Create;
begin
  inherited;
  FCliente:= TCliente.Create;
end;



end.


