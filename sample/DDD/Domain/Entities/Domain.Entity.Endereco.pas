unit Domain.Entity.Endereco;

interface

uses
  System.Classes, SysUtils,  EF.Mapping.Base, EF.Core.Types,EF.Mapping.Atributes,
  Domain.Consts;

type
   [Table('Endereco')]
   TEndereco = class( TEntityBase )
   private
     FLogradouro:TString;
     FNumero: TInteger;
     FMunicipio:TString;
     FUF:TString;
     FCEP:TString;
     FClienteId: TInteger;
   public
     [Column('Logradouro',varchar50)]
     property Logradouro:TString read FLogradouro write FLogradouro;
     [Column('Numero',int)]
     property Numero: TInteger read FNumero write FNumero;
     [Column('Municipio',varchar20)]
     property Municipio:TString read FMunicipio write FMunicipio;
     [Column('UF',varchar2)]
     property UF:TString read FUF write FUF;
     [Column('CEP',varchar10)]
     property CEP:TString read FCEP write FCEP;
     [Column('ClienteId',Int,true)]
     [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
     property ClienteId: TInteger read FClienteId write FClienteId;
   end;

implementation

initialization RegisterClass(TEndereco);
finalization UnRegisterClass(TEndereco);

end.
