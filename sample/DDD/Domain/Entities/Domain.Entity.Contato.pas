unit Domain.Entity.Contato;

interface

uses
  System.Classes,   Dialogs, SysUtils,  EF.Mapping.Base,
  EF.Core.Types, EF.Mapping.Atributes;


type
  [Table('Contatos')]
  TContato = class(TEntityBase)
  private
    FNome: TString;
    FTelefone: TString;
    FClienteId: TInteger;
  public
    [FieldTable('Nome','varchar(50)',false)]
    [LengthMin(10)][Edit]
    property Nome: TString read FNome write Fnome;
    [FieldTable('Telefone','varchar(15)',true)]
    [LengthMin(10)][Edit]
    property Telefone: TString read FTelefone write FTelefone;
    [FieldTable('ClienteId','Integer',true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;
  end;

implementation

{ TContatos }

initialization RegisterClass(TContato);
finalization UnRegisterClass(TContato);

end.
