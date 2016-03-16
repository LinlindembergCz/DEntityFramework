unit Entities;

interface

uses
  System.Classes, Dialogs, SysUtils, EntityBase, EntityTypes, Atributies,CPF, classCLiente;

type
  [EntityTable('Endereco')]
  TEndereco = class( TEntityBase )
  private
    FLogradouro: TString;
    FPessoaId:TInteger;
  public
    [EntityField('Logradouro','varchar(50)',true)]
    property Logradouro: TString read FLogradouro write FLogradouro;
    [EntityField('PessoaId','integer',false)]
    property PessoaId: TInteger read FPessoaId write FPessoaId;
  end;

  [EntityTable('Pessoa')]
  TPessoa = class( TEntityBase)
  private
    FNome: TString;
    FSalario: TFloat;
    FEndereco: TEndereco;
  public
    constructor Create;
  published
    [EntityField('Nome','varchar(50)',true)]
    property Nome: TString read FNome write FNome;
    [EntityRef('Pessoa.Id = Endereco.PessoaId')]
    property Endereco:TEndereco read FEndereco write FEndereco;
    [EntityField('Salario','float',true)]
    property Salario: TFloat read FSalario write FSalario;
  end;

  [EntityTable('PessoaFisica')]
  TPessoaFisica = class( TPessoa )
  private
    FCPFCNPJ: TCPF;
    FIdade: TInteger;
    FComissao: TFloat;
    FDataNascimento: TEntityDatetime;
  published
    [EntityField('CPF','varchar(11)',true)]
    property CPFCNPJ: TCPF read FCPFCNPJ write FCPFCNPJ;
    [EntityField('Idade','integer',true)]
    property Idade: TInteger read FIdade write FIdade;
    [EntityField('Comissao','float', true)]
    property Comissao: TFloat read FComissao write FComissao;
    [EntityField('DataNascimento','Datetime',true)]
    property DataNascimento:TEntityDatetime read FDataNascimento write FDataNascimento;
  end;

  [EntityTable('PessoaJuridica')]
  TPessoaJuridica = class( TPessoa )
  private
    FCNPJ: TString;
  published
    [EntityField('CNPJ','varchar(15)',true)]
    property CNPJ: TString read FCNPJ write FCNPJ;
  end;



  [EntityTable('Produto')]
  TProduto = class ( TEntityBase )
  private
    FDescricao: TString;
    FUNidade:TString;
    FPrecoVenda:TFloat;
  published
    [EntityField('Descricao','varchar(50)',true)]
    [EntityMaxLength(20)]
    property Descricao: TString read FDescricao write FDescricao;
    [EntityField('Unidade','varchar(5)',true)]
    [EntityDefault('UN')]
    property Unidade: TString read FUnidade write FUnidade;
    [EntityField('PrecoVenda','float',true)]
    //[EntityDefault('0')]
    property PrecoVenda: TFloat read FPrecoVenda write FPrecoVenda;
  end;

  TItens = class(TEntityBase)
  private
     FProduto: TProduto;
     FDescricao: TString;
  public
     [EntityRef('IdProduto=Produto.Id')]
     property Produto: TProduto read FProduto write FProduto;
     [EntityField('Descricao','', true)]
     property Descricao: TString read FDescricao write FDescricao;
     constructor Create;
  end;

  [EntityTable('ItensOrcamento')]
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

  [EntityTable('Orcamento')]
  TOrcamento = class ( TEntityBase )
  private
    FIdCliente: TInteger;
    FData: TEntityDatetime;
    FCliente:TCliente;
  public
    [EntityRef('IdCliente=Clientes.Id')]
    property Cliente: TCliente read FCliente write FCliente;
    constructor Create;
  published
    //[EntityField('Data','date',true)]
    property Data:TEntityDatetime read FData write FData;
    //[EntityField('IdCliente','integer',true)]
    property IdCliente: TInteger read FIdCliente write FIdCliente;
  end;

  //Classe mapeada!
  [EntityTable('ClassificacaoPessoa')]
  TClassificacaoPessoa = class(TEntityBase)
  private
    FDescricao: TString;
  public
    [EntityField('Descricao','varchar(20)',false)]
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


