unit EntityBase;

interface

uses
  System.TypInfo, RTTI, SysUtils, Atributies, EntityTypes, System.Classes;

type
  TEntityBase = class(TPersistent)
  private
    FId: TInteger;
    Mapped: boolean;
  //FDataCadastro: TEntityDatetime;
  public
    procedure Validation;virtual;
    constructor Create;virtual;
    destructor Destroy;override;
  published
    [EntityField('ID','integer',false,true, true)]
    property Id:TInteger read FId write FId;
  //property DataCadastro: TEntityDatetime read FDataCadastro write FDataCadastro;
  end;

implementation

{ TEntityBase }
uses AutoMapper;

destructor TEntityBase.Destroy;
begin
  FreeAndNilProperties(self);
end;

procedure TEntityBase.Validation;
var
  ctx: TRttiContext;
  typeRtti: TRttiType;
  propRtti: TRttiProperty;
  atrbRtti: TCustomAttribute;
begin
  ctx := TRttiContext.Create;
  typeRtti := ctx.GetType(self.ClassType);
  for propRtti in typeRtti.GetProperties do
  begin
      for atrbRtti in propRtti.GetAttributes do
      begin
          if atrbRtti is EntityNotNull then
          begin
              if not(atrbRtti as EntityValidation).
              Validar( TAutoMapper.GetValueProperty( self , propRtti.Name),
              'Campo "'+propRtti.Name+'" Requerido!' ) then
              begin
               abort;
              end;
          end
          else
          if atrbRtti is EntityRangeValues then
          begin
              if not(atrbRtti as EntityValidation).
              Validar( TAutoMapper.GetValueProperty( self , propRtti.Name).ToInteger ,
              'Valor "'+propRtti.Name+'" inválido para o intervalor!' ) then
              begin
                abort;
              end;
          end
          else
          if atrbRtti is EntityValueLengthMin then
          begin
              if not(atrbRtti as EntityValidation).
              Validar( TAutoMapper.GetValueProperty( self , propRtti.Name) ,
              'Valor "'+propRtti.Name+'" é inválido para o mínimo requerido !' ) then
              begin
                abort;
              end;
          end;
      end;
  end;
  ctx.Free;
end;

constructor TEntityBase.Create;
begin
  Mapped := TAutoMapper.ToMapping(self, true);
end;

end.
