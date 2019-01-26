unit EF.Mapping.Base;

interface

uses
  System.TypInfo, RTTI, SysUtils, System.Classes,
  EF.Mapping.Atributes,
  EF.Core.Types, JsonDataObjects;

type
  TEntityBase = class(TPersistent)
  private
    FId: TInteger;
    Mapped: boolean;
    // FDataCadastro: TEntityDatetime;
  public
    procedure Validation; virtual;
    constructor Create; virtual;
    destructor Destroy; override;
  published
    [EntityField('ID', 'integer', false, true, true)]
    property Id: TInteger read FId write FId;
    function ToJson: string;
    // property DataCadastro: TEntityDatetime read FDataCadastro write FDataCadastro;
  end;

implementation

{ TEntityBase }

uses EF.Mapping.AutoMapper;

destructor TEntityBase.Destroy;
begin
  FreeAndNilProperties(self);
end;

function TEntityBase.ToJson: string;
var
  json: TJsonObject;
  ListField , ListValues : TStringList;
  I:integer;
begin
  try
    json:= TJsonObject.Create;
    ListField  := TAutoMapper.GetAttributiesList(self);
    ListValues := TAutoMapper.GetValuesFieldsList(self);
    for I := 0 to ListField.Count -1 do
    begin
       json.S[ListField.Strings[i]]:=  ListValues.Strings[i];
    end;
    result:= json.ToJSON;
  finally
     ListField.Free;
     ListValues.Free;
     json.Free;
  end;
end;

procedure TEntityBase.Validation;
var
  ctx: TRttiContext;
  typeRtti: TRttiType;
  propRtti: TRttiProperty;
  atrbRtti: TCustomAttribute;
  mensagem: string;
begin
  ctx := TRttiContext.Create;
  typeRtti := ctx.GetType(self.ClassType);
  for propRtti in typeRtti.GetProperties do
  begin
    for atrbRtti in propRtti.GetAttributes do
    begin
      if atrbRtti is EntityNotNull then
      begin
        mensagem := 'Campo "' + propRtti.Name + '" Requerido!';
        if not(atrbRtti as EntityValidation)
            .Validar(TAutoMapper.GetValueProperty(self, propRtti.Name), mensagem)
        then
        begin
          abort;
        end;
      end
      else if atrbRtti is EntityRangeValues then
      begin
        mensagem := 'Valor "' + propRtti.Name + '" inválido para o intervalor!';
        if not(atrbRtti as EntityValidation)
            .Validar(TAutoMapper.GetValueProperty(self, propRtti.Name)
            .ToInteger, mensagem) then
        begin
          abort;
        end;
      end
      else if atrbRtti is EntityValueLengthMin then
      begin
        mensagem := 'Valor "' + propRtti.Name +
            '" é inválido para o mínimo requerido !';
        if not(atrbRtti as EntityValidation)
            .Validar(TAutoMapper.GetValueProperty(self, propRtti.Name), mensagem)
        then
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
