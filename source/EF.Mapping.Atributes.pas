{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Mapping.Atributes;

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

  TRule = ( rlCascade, rlSetNull, rlRestrict, rlNoAction );

  PParamForeignKeys = ^TParamForeignKeys;

  TParamForeignKeys= record
    ForeignKey: string;
    Name: string;
    OnDelete: TRule;
    OnUpdate: TRule;
  end;

  NotMapped = class(TCustomAttribute)
  end;


  Table = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: String);
    property Name: string read FName;
  end;

  Column = class(TCustomAttribute)
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

  ForeignKey = class(TCustomAttribute)
  private
    FForeignKey: string;
    FName: string;
    FOnDelete: TRule;
    FOnUpdate: TRule;
  public
    constructor Create(aForeignKey : string; aName: String; aOnDelete: TRule; aOnUpdate: TRule );
    property ForeignKey: string read FForeignKey;
    property Name: string read FName;
    property OnDelete: TRule read FOnDelete;
    property OnUpdate: TRule read FOnUpdate;

  end;

  Reference = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: String);
    property Name: string read FName;
  end;


  Expression = class(TCustomAttribute)
  private
    FDisplay: string;
    FExpression: string;
  public
    constructor Create(aDisplay: String; aExpression:string);
    property Display: string read FDisplay;
    property Expression: string read FExpression;
  end;


  Items = class(TCustomAttribute)
  private
    FItems: TStringList;
  public
    constructor Create(aItems: String);
    destructor Destroy; override;
    property Items: TStringList read FItems write FItems;
  end;

  Default = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aName: string);
    property Name: string read FName;
  end;

  MaxLength = class(TCustomAttribute)
  private
    FValue: integer;
  public
    constructor Create(pMaxLength:integer ); virtual;
    property Value: integer read FValue;
  end;

  Log = class(TCustomAttribute)
  private
    FValue: boolean;
  public
    constructor Create(pValue:boolean ); virtual;
    property Value: boolean read FValue;
  end;

  Validator = class(TCustomAttribute)
  private
    FMensagem: String;
    procedure AfterValid(pValido: boolean);
  public
    function IsValid(pValue: TValue; pMensagem: string = ''): boolean; virtual;
    constructor Create(pMensagem: String = '');
  end;

  NoSpecialChar = class(TCustomAttribute)
  end;

  //Nao permitir valor nulo
  NotNull = class(Validator)
  public
    function IsValid(pValue: TValue; pMensagem: string = ''): boolean; override;
  end;

  //Verificar o tamanho do valor minimo informado
  LengthMin = class(Validator)
  private
    FMin: integer;
  public
    constructor Create(pMin: integer; pMensagem: String= ''); reintroduce;
    function IsValid( pValue: TValue; pMensagem: string = ''): boolean; override;
  end;

  //Verificar se o valor está dentro do intervalo
  Range = class(Validator)
  private
    FMax: integer;
    FMin: integer;
  public
    constructor Create(pMin, pMax: integer; pMensagem: String= ''); reintroduce;
    function IsValid(pValue: TValue; pMensagem: string = ''): boolean; override;
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

  const
    Char1      = 'varchar(1)';
    varchar10  = 'varchar(10)';
    varchar15  = 'varchar(15)';
    varchar20  = 'varchar(20)';
    varchar50  = 'varchar(50)';
    varchar100 = 'varchar(100)';
    varchar200 = 'varchar(200)';
    varchar300 = 'varchar(200)';
    varchar500 = 'varchar(500)';

implementation

{ EntityTable }
constructor Table.Create(aName: String);
begin
  FName := aName;
end;

{ EntityField }

constructor Column.Create(aName: String; aTipo: string =''; aIsNull: boolean=true;
  aPrimaryKey: boolean = false; aAutoInc: boolean = false);
begin
  FName := aName;
  FTipo := aTipo;
  FIsNull := aIsNull;
  FPrimaryKey := aPrimaryKey;
  FAutoInc := aAutoInc;
end;

procedure Column.SetAutoInc(const Value: boolean);
begin
  FAutoInc := Value;
end;

{ EntityRef }
constructor Reference.Create(aName: String);
begin
  FName := aName;
end;

{ EntityItems }
constructor Items.Create(aItems: String);
begin
  FItems := TStringList.Create;
  FItems.delimiter := ';';
  FItems.DelimitedText := aItems;
end;

destructor Items.Destroy;
begin
  FItems.Free;
end;

constructor Default.Create(aName: string);
begin
  FName := aName;
end;

constructor Range.Create(pMin, pMax: integer; pMensagem: String = '');
begin
  inherited Create(pMensagem);
  FMin := pMin;
  FMax := pMax;
end;

constructor Validator.Create(pMensagem: String = '');
begin
  if pMensagem <> '' then
    FMensagem := pMensagem
  else
    FMensagem := 'Campo requerido!';
end;

function NotNull.IsValid(pValue: TValue;pMensagem: string = ''): boolean;
begin
  FMensagem := pMensagem;
  result := pValue.AsString <> '';
  AfterValid(result);
end;

procedure Validator.AfterValid(pValido: boolean);
begin
  if (not pValido) then
    ShowMessage(FMensagem);
end;

function Validator.IsValid(pValue: TValue; pMensagem: string = ''): boolean;
begin
  FMensagem := pMensagem;
  result := true;
  AfterValid(result);
end;

function Range.IsValid(pValue: TValue;pMensagem: string = ''): boolean;
begin
  FMensagem := pMensagem;
  result := true;
  if (pValue.AsInteger < FMin) then
    result := false;
  if (pValue.AsInteger > FMax) then
    result := false;
  AfterValid(result);
end;

{ EntityMaxLenth }

constructor MaxLength.Create(pMaxLength: integer);
begin
  FValue:= pMaxLength;
end;

{ EntityLog }

constructor Log.Create(pValue: boolean);
begin
  FValue := pValue;
end;

{ EntityExpression }

constructor Expression.Create(aDisplay: String; aExpression:string);
begin
  FDisplay:= aDisplay;
  FExpression := aExpression;
end;

{ EntityValueLengthMin }

function LengthMin.IsValid(pValue: TValue;
  pMensagem: string): boolean;
begin
  FMensagem := pMensagem;
  result := true;
  if (pValue.AsString.Length < FMin) then
    result := false;
  AfterValid(result);
end;

constructor LengthMin.Create(pMin: integer; pMensagem: String);
begin
  inherited Create(pMensagem);
  FMin := pMin;
end;

{ EntityForeignKey }

//'ClienteId','integer',true,'CLIENTES.ID',True
constructor ForeignKey.Create(aForeignKey : string; aName: String; aOnDelete: TRule; aOnUpdate: TRule );
begin
  FForeignKey:= aForeignKey;
  FName := aName;
  FOnDelete := aOnDelete;
  FOnUpdate := aOnUpdate;
//ALTER TABLE CONTATOS ADD CONSTRAINT FK_CONTATOS_1 FOREIGN KEY (CLIENTEID) REFERENCES CLIENTES(ID) ON DELETE CASCADE
end;

end.
