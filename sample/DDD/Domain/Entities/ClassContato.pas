unit ClassContato;

interface

uses
  System.Classes,  Email, Dialogs, SysUtils,  EF.Mapping.Base,
  EF.Core.Types, EF.Mapping.Atributes, ClassCliente;


type
  [EntityTable('Contatos')]
  TContato = class(TEntityBase)
  private
    FNome: TString;
    FTelefone: TString;
    FClienteId: TInteger;
    FCliente : TCliente;
  public
    [EntityField('Nome','varchar(50)',false)]
    [LengthMin(10)][Edit]
    property Nome: TString read FNome write Fnome;
    [EntityField('Telefone','varchar(15)',true)]
    [LengthMin(10)][Edit]
    property Telefone: TString read FTelefone write FTelefone;
    [EntityField('ClienteId','Integer',true)]
    [EntityForenKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;
  end;

implementation

{ TContatos }

initialization RegisterClass(TContato);
finalization UnRegisterClass(TContato);

end.
