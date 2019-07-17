unit EF.Mapping.Base;

interface

uses
  System.TypInfo, RTTI, SysUtils, System.Classes,System.Contnrs,
  EF.Mapping.Atributes, EF.Core.Types,REST.JSON, JsonDataObjects;

type
  //TCollate = Class;

  TEntityBase = class(TPersistent)
  private
    FId: TInteger;
    procedure ValidateFieldNotNull(PropRtti: TRttiProperty; atrbRtti: TCustomAttribute);
    procedure ValidateRange(PropRtti: TRttiProperty; atrbRtti: TCustomAttribute);
    procedure ValidateLengthMin(PropRtti: TRttiProperty; atrbRtti: TCustomAttribute);
  protected
    // FDataCadastro: TEntityDatetime;
  public
    Mapped: boolean;
    constructor Create; overload; virtual;
    destructor Destroy;override;
    procedure Validate; virtual;
  published
    [FieldTable('ID', 'integer', false, true, true)]
    property Id: TInteger read FId write FId;
    function ToJson(UsingRestJson:boolean = false): string;
    procedure FromJson{<T: class, constructor>}(const AJson: String);
    // property DataCadastro: TEntityDatetime read FDataCadastro write FDataCadastro;
  end;


implementation

{ TEntityBase }

uses EF.Mapping.AutoMapper;

constructor TEntityBase.Create;
begin
   if not Mapped then
     Mapped := TAutoMapper.ToMapping(self, true, false);
   inherited Create;
end;

destructor TEntityBase.Destroy;
begin
  inherited;
  FreeAndNilProperties(self);
end;

function TEntityBase.ToJson(UsingRestJson:boolean = false): string;
var
  json: TJsonObject;
  ListField, ListValues: TStringList;
  I: integer;
begin
  if UsingRestJson then
     result:= TJson.ObjectToJsonString(self)
  else
  begin
    try
      json := TJsonObject.Create;
      ListField := TAutoMapper.GetFieldsList(self, false, true);
      ListValues := TAutoMapper.GetValuesFieldsList(self, true);
      for I := 0 to ListField.Count - 1 do
      begin
        json.S[ListField.Strings[I]] := ListValues.Strings[I];
      end;
      result := json.ToJson;
    finally
      ListField.Free;
      ListValues.Free;
      json.Free;
    end;
  end;

end;

procedure TEntityBase.FromJson{<T>}(const AJson: String);
 var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  joJSON: TJsonObject;
begin
  //self := TJson.JsonToObject<T>( AJson ) as TEntityBase;
  Contexto := TRttiContext.Create;
  try
    joJSON := TJsonObject.Create;
    joJSON.FromJson(AJson);
    TipoRtti := Contexto.GetType(self.ClassType);
    for PropRtti in TipoRtti.GetProperties do
    begin
      if PropRtti.IsWritable then
      begin
        if (joJSON.Contains(upperCase(PropRtti.Name))) then
        begin
          if (PropRtti.PropertyType.ToString = 'TDate') then
          begin
             if (joJSON.S[upperCase(PropRtti.Name)] <> '') then
                TAutoMapper.SetAtribute( self, PropRtti.Name, joJSON.S[upperCase(PropRtti.Name)], false )
          end
          else
             TAutoMapper.SetAtribute( self, PropRtti.Name, joJSON.S[upperCase(PropRtti.Name)], false );
        end;
      end;
    end;
  finally
    Contexto.Free;
    FreeAndNil(joJSON);
  end;

end;

procedure TEntityBase.ValidateLengthMin(PropRtti: TRttiProperty; atrbRtti: TCustomAttribute);
var
  mensagem: string;
begin
  mensagem := 'Valor "' + PropRtti.Name + '" é inválido para o mínimo requerido !';
  if not (atrbRtti as Validator).IsValid(TAutoMapper.GetValueProperty(self, PropRtti.Name), mensagem) then
  begin
    abort;
  end;
end;

procedure TEntityBase.ValidateRange(PropRtti: TRttiProperty; atrbRtti: TCustomAttribute);
var
  mensagem: string;
begin
  mensagem := 'Valor "' + PropRtti.Name + '" inválido para o intervalor!';
  if not (atrbRtti as Validator).IsValid(TAutoMapper.GetValueProperty(self, PropRtti.Name).ToInteger, mensagem) then
  begin
    abort;
  end;
end;

procedure TEntityBase.ValidateFieldNotNull(PropRtti: TRttiProperty; atrbRtti: TCustomAttribute);
var
  mensagem: string;
begin
  mensagem := 'Campo "' + PropRtti.Name + '" Requerido!';
  if not (atrbRtti as Validator).IsValid(TAutoMapper.GetValueProperty(self, PropRtti.Name), mensagem) then
  begin
    abort;
  end;
end;

procedure TEntityBase.Validate;
var
  ctx: TRttiContext;
  typeRtti: TRttiType;
  PropRtti: TRttiProperty;
  atrbRtti: TCustomAttribute;
begin
  try
    ctx := TRttiContext.Create;
    typeRtti := ctx.GetType(self.ClassType);
    for PropRtti in typeRtti.GetProperties do
    begin
      for atrbRtti in PropRtti.GetAttributes do
      begin
        if atrbRtti is NotNull then
        begin
          ValidateFieldNotNull(PropRtti, atrbRtti);
        end
        else if atrbRtti is Range then
        begin
          ValidateRange(PropRtti, atrbRtti);
        end
        else if atrbRtti is LengthMin then
        begin
          ValidateLengthMin(PropRtti, atrbRtti);
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;


end.
