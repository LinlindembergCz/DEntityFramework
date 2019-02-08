unit EF.Mapping.Base;

interface

uses
  System.TypInfo, RTTI, SysUtils, System.Classes,
  EF.Mapping.Atributes, EF.Core.Types,{REST.JSON,} JsonDataObjects;

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
    procedure FromJson{<T: class, constructor>}(const AJson: String);
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
  ListField, ListValues: TStringList;
  I: integer;
begin
  //result:= TJson.ObjectToJsonString(self);
  try
    json := TJsonObject.Create;
    ListField := TAutoMapper.GetFieldsList(self);
    ListValues := TAutoMapper.GetValuesFieldsList(self);
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
        if joJSON.Contains(PropRtti.Name) then
        begin
          TAutoMapper.SetAtribute( self, PropRtti.Name, joJSON.S[PropRtti.Name], false );
        end;
      end;
    end;
  finally
    Contexto.Free;
    FreeAndNil(joJSON);
  end;

end;

procedure TEntityBase.Validation;
var
  ctx: TRttiContext;
  typeRtti: TRttiType;
  PropRtti: TRttiProperty;
  atrbRtti: TCustomAttribute;
  mensagem: string;
begin
  ctx := TRttiContext.Create;
  typeRtti := ctx.GetType(self.ClassType);
  for PropRtti in typeRtti.GetProperties do
  begin
    for atrbRtti in PropRtti.GetAttributes do
    begin
      if atrbRtti is NotNull then
      begin
        mensagem := 'Campo "' + PropRtti.Name + '" Requerido!';
        if not(atrbRtti as Valiator).Validar(TAutoMapper.GetValueProperty(self, PropRtti.Name), mensagem)
        then
        begin
          abort;
        end;
      end
      else if atrbRtti is Range then
      begin
        mensagem := 'Valor "' + PropRtti.Name + '" inválido para o intervalor!';
        if not(atrbRtti as Valiator)
            .Validar(TAutoMapper.GetValueProperty(self, PropRtti.Name)
            .ToInteger, mensagem) then
        begin
          abort;
        end;
      end
      else if atrbRtti is LengthMin then
      begin
        mensagem := 'Valor "' + PropRtti.Name +
            '" é inválido para o mínimo requerido !';
        if not(atrbRtti as Valiator)
            .Validar(TAutoMapper.GetValueProperty(self, PropRtti.Name), mensagem)
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
