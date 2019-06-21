unit EF.Mapping.Base;

interface

uses
  System.TypInfo, RTTI, SysUtils, System.Classes,System.Contnrs,
  EF.Mapping.Atributes, EF.Core.Types,REST.JSON, JsonDataObjects;

type
  TCollate = Class;

  TEntityBase = class(TPersistent)
  private
    FId: TInteger;

    FCollateOn: boolean;
  protected
    // FDataCadastro: TEntityDatetime;
  public
    Mapped: boolean;
    Collate: TCollate;
    constructor Create; overload; virtual;
    constructor Create(aCollateOn:boolean);overload;virtual;
    destructor Destroy; override;
    procedure Validation; virtual;
    procedure Initialize; virtual;
  published
    [FieldTable('ID', 'integer', false, true, true)]
    property Id: TInteger read FId write FId;
    function ToJson(UsingRestJson:boolean = false): string;
    procedure FromJson{<T: class, constructor>}(const AJson: String);
    [NotMapper]
    property CollateOn: boolean read FCollateOn write FCollateOn;
    // property DataCadastro: TEntityDatetime read FDataCadastro write FDataCadastro;
  end;

  TCollate= class(TPersistent)
  private
     ObjectList:TObjectList;
  public
     function RegisterObject<T:TEntityBase>(O:T):T;overload;
     function RegisterObjectList<T:TEntityBase>(O: TEntityList<T>):TEntityList<T>;overload;
  end;

implementation

{ TEntityBase }

uses EF.Mapping.AutoMapper;

constructor TEntityBase.Create(aCollateOn: boolean);
begin
   CollateOn := aCollateOn;
   Create;
   inherited Create;

end;

destructor TEntityBase.Destroy;
begin
 if Collate <> nil then
  begin
    Collate.ObjectList.Free;
    Collate.free;
  end;
  if not CollateON then
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

procedure TEntityBase.Initialize;
begin

end;

function TCollate.RegisterObject<T>( O:T):T;
begin
  if ObjectList = nil then
     ObjectList := TObjectList.Create;
  ObjectList.Add( O );
  result:= O;
end;

function TCollate.RegisterObjectList<T>(O: TEntityList<T>): TEntityList<T>;
begin
  if ObjectList = nil then
     ObjectList := TObjectList.Create;
  ObjectList.Add( O );
  result:= O;
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
        if not(atrbRtti as Validator).IsValid(TAutoMapper.GetValueProperty(self, PropRtti.Name), mensagem)
        then
        begin
          abort;
        end;
      end
      else if atrbRtti is Range then
      begin
        mensagem := 'Valor "' + PropRtti.Name + '" inválido para o intervalor!';
        if not(atrbRtti as Validator)
            .IsValid(TAutoMapper.GetValueProperty(self, PropRtti.Name)
            .ToInteger, mensagem) then
        begin
          abort;
        end;
      end
      else if atrbRtti is LengthMin then
      begin
        mensagem := 'Valor "' + PropRtti.Name +
            '" é inválido para o mínimo requerido !';
        if not(atrbRtti as Validator)
            .IsValid(TAutoMapper.GetValueProperty(self, PropRtti.Name), mensagem)
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
  if CollateOn then
  begin
    if Collate = nil then
       Collate:= TCollate.Create;
  end;
  //Mapped := TAutoMapper.ToMapping(self, true);
end;



end.
