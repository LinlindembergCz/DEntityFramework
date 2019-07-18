unit Domain.Entity.Contato;

interface

uses
  System.Classes,   Dialogs, SysUtils,  EF.Mapping.Base,
  EF.Core.Types, EF.Mapping.Atributes, Domain.Consts;


type
  [Table('Contatos')]
  TContato = class(TEntityBase)
  private
    FNome: TString;
    FTelefone: TString;
    FClienteId: TInteger;
  published
    [Column('Nome',varchar50,false)]
    [LengthMin(10)]
    property Nome: TString read FNome write Fnome;
    [Column('Telefone',varchar15,true)]
    [LengthMin(10)]
    property Telefone: TString read FTelefone write FTelefone;
    [Column('ClienteId','Integer',true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;
  end;

implementation

{ TContatos }

initialization RegisterClass(TContato);
finalization UnRegisterClass(TContato);

end.
