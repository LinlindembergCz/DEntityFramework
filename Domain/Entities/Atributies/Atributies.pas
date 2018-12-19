unit Atributies;

interface

uses
   sysUtils, RTTI, Classes, Dialogs;

type
  PParamAtributies = ^TParamAtributies;

  TParamAtributies = record
    Name: string;
    Tipo: String;
    IsNull: boolean;
    PrimaryKey: boolean;
    DefaultValue: variant;
    AutoInc: boolean;
  end;

  EntityTable = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: String);
    property Name: string read FName;
  end;

  EntityField = class(TCustomAttribute)
  private
    FName: String;
    FIsNull: boolean;
    FPrimaryKey: boolean;
    FTipo: string;
    FDefaultValue: variant;
    FAutoInc: boolean;
    procedure SetAutoInc(const Value: boolean);
  public
    constructor Create(aName: String; aTipo: string=''; aIsNull: boolean=true;
      aPrimaryKey: boolean = false; aAutoInc: boolean = false); overload;
    property Name: String read FName;
    property Tipo: string read FTipo;
    property IsNull: boolean read FIsNull;
    property PrimaryKey: boolean read FPrimaryKey;
    property DefaultValue: variant read FDefaultValue;
    property AutoInc: boolean read FAutoInc write SetAutoInc;
  end;

  EntityRef = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: String);
    property Name: string read FName;
  end;


  EntityExpression = class(TCustomAttribute)
  private
    FDisplay: string;
    FExpression: string;
  public
    constructor Create(aDisplay: String; aExpression:string);
    property Display: string read FDisplay;
    property Expression: string read FExpression;
  end;


  EntityItems = class(TCustomAttribute)
  private
    FItems: TStringList;
  public
    constructor Create(aItems: String);
    destructor Destroy; override;
    property Items: TStringList read FItems write FItems;
  end;

  EntityDefault = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: string);
    property Name: string read FName;
  end;

  EntityMaxLength = class(TCustomAttribute)
  private
    FValue: integer;
  public
    constructor Create(pMaxLength:integer ); virtual;
    property Value: integer read FValue;
  end;

  EntityLog = class(TCustomAttribute)
  private
    FValue: boolean;
  public
    constructor Create(pValue:boolean ); virtual;
    property Value: boolean read FValue;
  end;

  EntityValidation = class(TCustomAttribute)
  private
    FMensagem: String;
    procedure AfterValidar(pValido: boolean);
  public
    function Validar(pValue: TValue; pMensagem: string = ''): boolean; virtual;
    constructor Create(pMensagem: String = '');
  end;

  EntityNotSpecialChar = class(TCustomAttribute)
  end;

  //Nao permitir valor nulo
  EntityNotNull = class(EntityValidation)
  public
    function Validar(pValue: TValue; pMensagem: string = ''): boolean; override;
  end;

  //Verificar o tamanho do valor minimo informado
  EntityValueLengthMin = class(EntityValidation)
  private
    FMin: integer;
  public
    constructor Create(pMin: integer; pMensagem: String= ''); reintroduce;
    function Validar( pValue: TValue; pMensagem: string = ''): boolean; override;
  end;

  //Verificar se o valor está dentro do intervalo
  EntityRangeValues = class(EntityValidation)
  private
    FMax: integer;
    FMin: integer;
  public
    constructor Create(pMin, pMax: integer; pMensagem: String= ''); reintroduce;
    function Validar(pValue: TValue; pMensagem: string = ''): boolean; override;
  end;

  PItem = ^TItem;

  TItem = record
    Text: string;
    Value: string;
  end;

  Edit = class(TCustomAttribute)
  end;

  Combobox = class(TCustomAttribute)
  end;

  CheckBox = class(TCustomAttribute)
  end;

  Memo = class(TCustomAttribute)
  end;

  DateTimePicker = class(TCustomAttribute)
  end;

  LookupCombobox = class(TCustomAttribute)
  end;

  RadioGroup = class(TCustomAttribute)
  end;

implementation


{ EntityTable }
constructor EntityTable.Create(aName: String);
begin
  FName := aName;
end;

{ EntityField }

constructor EntityField.Create(aName: String; aTipo: string =''; aIsNull: boolean=true;
  aPrimaryKey: boolean = false; aAutoInc: boolean = false);
begin
  FName := aName;
  FTipo := aTipo;
  FIsNull := aIsNull;
  FPrimaryKey := aPrimaryKey;
  FAutoInc := aAutoInc;
end;

procedure EntityField.SetAutoInc(const Value: boolean);
begin
  FAutoInc := Value;
end;

{ EntityRef }
constructor EntityRef.Create(aName: String);
begin
  FName := aName;
end;

{ EntityItems }
constructor EntityItems.Create(aItems: String);
begin
  FItems := TStringList.Create;
  FItems.delimiter := ';';
  FItems.DelimitedText := aItems;
end;

destructor EntityItems.Destroy;
begin
  FItems.Free;
end;

constructor EntityDefault.Create(aName: string);
begin
  FName := aName;
end;

constructor EntityRangeValues.Create(pMin, pMax: integer; pMensagem: String = '');
begin
  inherited Create(pMensagem);
  FMin := pMin;
  FMax := pMax;
end;

constructor EntityValidation.Create(pMensagem: String = '');
begin
  if pMensagem <> '' then
    FMensagem := pMensagem
  else
    FMensagem := 'Campo requerido!';
end;

function EntityNotNull.Validar(pValue: TValue;pMensagem: string = ''): boolean;
begin
  FMensagem := pMensagem;
  result := pValue.AsString <> '';
  AfterValidar(result);
end;

procedure EntityValidation.AfterValidar(pValido: boolean);
begin
  if (not pValido) then
    ShowMessage(FMensagem);
end;

function EntityValidation.Validar(pValue: TValue; pMensagem: string = ''): boolean;
begin
  FMensagem := pMensagem;
  result := true;
  AfterValidar(result);
end;

function EntityRangeValues.Validar(pValue: TValue;pMensagem: string = ''): boolean;
begin
  FMensagem := pMensagem;
  result := true;
  if (pValue.AsInteger < FMin) then
    result := false;
  if (pValue.AsInteger > FMax) then
    result := false;
  AfterValidar(result);
end;

{ EntityMaxLenth }

constructor EntityMaxLength.Create(pMaxLength: integer);
begin
  FValue:= pMaxLength;
end;

{ EntityLog }

constructor EntityLog.Create(pValue: boolean);
begin
  FValue := pValue;
end;

{ EntityExpression }

constructor EntityExpression.Create(aDisplay: String; aExpression:string);
begin
  FDisplay:= aDisplay;
  FExpression := aExpression;
end;

{ EntityValueLengthMin }

function EntityValueLengthMin.Validar(pValue: TValue;
  pMensagem: string): boolean;
begin
  FMensagem := pMensagem;
  result := true;
  if (pValue.AsString.Length < FMin) then
    result := false;
  AfterValidar(result);
end;

constructor EntityValueLengthMin.Create(pMin: integer; pMensagem: String);
begin
  inherited Create(pMensagem);
  FMin := pMin;
end;

end.
