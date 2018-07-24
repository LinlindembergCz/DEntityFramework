unit AutoMapper;

interface

uses
   Forms, Atributies, EntityBase, EntityTypes,  RTTI, Classes,  SysUtils,
   Vcl.Controls, DB, System.Contnrs,  StdCtrls, strUtils, math,
   System.Generics.Collections;

type
  TAutoMapper = class
  private
    class var ctx: TRttiContext;
    class var TypObj: TRttiType;
    class function GetValueField(E: TEntityBase; Field: TRttiField)
      : string; static;
    class function ValidComponent(Comp: TComponent): boolean; static;
    class function GetMaxLengthValue(E: TEntityBase; aProp: string): variant; static;
    class function SetComponentValueProp(Componente: TComponent;
      Prop: TRttiProperty; Entity: TEntityBase): boolean; static;
    class function PropIsInstance(Prop: TRttiProperty): boolean; static;
    class function PropIsFloat(Prop: TRttiProperty): boolean; static;
    class function PropIsInteger(Prop: TRttiProperty): boolean; static;
    class function PropIsString(Prop: TRttiProperty): boolean; static;
    class function PropIsDate(Prop: TRttiProperty): boolean; static;
    class function PropIsVisible(prop: TRttiProperty): boolean; static;
    class function PropNameEqualComponentName(Prop: TRttiProperty;
      Componente: TComponent): boolean; static;
  public
    class function CreateObject(AQualifiedClassName: string): TObject; overload;
    class function CreateObject(ARttiType: TRttiType): TObject;overload;

    class function GetTableAttribute(Obj: TClass): String; overload;
    class function GetTableAttribute(ClassInfo: Pointer): String; overload;
    class procedure SetAtribute(Entity: TEntityBase; Campo, Valor: string;
      InContext: boolean = false); static;
    class function GetAttributies(E: TEntityBase;OnlyPublished:boolean = false): String; static;
    class function GetAttributiesList(E: TEntityBase;
      OnlyPublished: boolean = false): TStringList;overload;
    class function GetAttributiesList(E: Pointer;
      OnlyPublished: boolean = false): TStringList;overload;
    class function GetAttributiesPrimaryKeyList(E: TEntityBase): TStringList;
    class function GetListAtributes(Obj: TClass): TList;
    class function GetValuesFields(E: TEntityBase): String; static;
    class function GetValuesFieldsList(E: TEntityBase): TStringList; static;
    class function GetValuesFieldsPrimaryKeyList(E: TEntityBase)
      : TStringList; static;
    class function GetDafaultValue(E: TEntityBase; aProp: string)
      : variant; static;
    class function GetValueProperty(E: TEntityBase; Propert: string)
      : string; static;
    class procedure Puts(Component: TComponent; Entity: TEntityBase;Valued: boolean = false);overload;
    class procedure PutsFromControl(ComponentControl: TCustomControl; Entity: TEntityBase); static;
    class procedure Read(Component: TComponent; Entity: TEntityBase;
      SetDefaultValue: boolean; DataSet :TDataSet = nil);
    class procedure DataToEntity(DataSet: TDataSet; Entity: TEntityBase);
    class function ToMapping(Entity: TEntityBase; InContext: boolean): boolean;
    class function GetReferenceAtribute(Obj: TEntityBase; E: TEntityBase)
      : string;overload; static;
    class function GetReferenceAtribute(Obj: TEntityBase; E: TClass)
      : string;overload; static;

    class procedure SetFieldValue(Entity: TEntityBase; Campo: string;
      Valor: variant); overload;static;
    class procedure SetFieldValue(Entity: TEntityBase; Campo: TRttiProperty;
     Valor: variant);overload;static;

    class function GetInstance(const Str_Class: TValue): TObject; static;
    class procedure CreateDinamicView( Entity: TEntityBase; Form:TForm);
  end;

implementation

uses
  System.TypInfo, EntityFunctions, Vcl.DBCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, VCL.Mask;

{ TAutoMapper }

class function TAutoMapper.PropIsFloat(Prop: TRttiProperty): boolean;
begin
   result:= UpperCase(prop.PropertyType.ToString) = 'TFLOAT';
end;

class function TAutoMapper.PropIsInteger(Prop: TRttiProperty): boolean;
begin
   result:= UpperCase(prop.PropertyType.ToString) = 'TINTEGER';
end;

class function TAutoMapper.PropIsString(Prop: TRttiProperty): boolean;
begin
   result:= UpperCase(prop.PropertyType.ToString) = 'TSTRING';
end;

class function TAutoMapper.PropIsDate(Prop: TRttiProperty): boolean;
begin
   result:= UpperCase(prop.PropertyType.ToString) = 'TENTITYDATETIME';
end;

class function TAutoMapper.PropIsVisible(prop: TRttiProperty):boolean;
begin
  result:= Prop.Visibility in [mvPublished];
end;

class function TAutoMapper.GetListAtributes(Obj: TClass): TList;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  TypObj: TRttiType;
  Atributo: TCustomAttribute;
  Atributies: PParamAtributies;
  List: TList;
  Found:Boolean;

  procedure AddFieldByDefault;
  begin
    New(Atributies);
    Atributies^.Name := Prop.Name;
    if PropIsString(Prop) then Atributies^.Tipo := 'varchar(50)'
    else
    if PropIsInteger( prop )  then Atributies^.Tipo := 'integer'
    else
    if PropIsFloat ( prop )  then Atributies^.Tipo := 'Float'
    else
    if PropIsDate ( prop ) then  Atributies^.Tipo := 'Date';

    Atributies^.IsNull := not ( UpperCase(prop.Name) = 'ID');
    Atributies^.PrimaryKey :=  UpperCase(prop.Name) = 'ID';

    List.Add(Atributies);
  end;

begin
  try
    List := TObjectList.Create;
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Obj.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if not PropIsInstance(Prop) then
      begin
        Found:= false;
        for Atributo in Prop.GetAttributes do
        begin
          if (Atributo is EntityField) then
          begin
            if EntityField(Atributo).Tipo <> '' then
            begin
              New(Atributies);
              Atributies^.Name := EntityField(Atributo).Name;
              Atributies^.Tipo := EntityField(Atributo).Tipo;
              Atributies^.IsNull := EntityField(Atributo).IsNull;
              Atributies^.PrimaryKey := EntityField(Atributo).PrimaryKey;
              Atributies^.DefaultValue := EntityField(Atributo).DefaultValue;
              Atributies^.AutoInc := EntityField(Atributo).AutoInc;
              List.Add(Atributies);
            end;
            Found:= true;
          end;
        end;

        if not Found then
        begin
          AddFieldByDefault;
        end;

      end;
    end;
  finally
    ctx.Free;
    result := List;
  end;
end;

class function TAutoMapper.GetReferenceAtribute(Obj: TEntityBase;
  E: TEntityBase): string;
var
  ctx: TRttiContext;
  ctx2: TRttiContext;
  Prop: TRttiProperty;
  TypObj: TRttiType;
  Atrib: TCustomAttribute;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Obj.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      ctx2 := TRttiContext.Create;
      if Prop.PropertyType = ctx2.GetType(E.ClassInfo) then
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is EntityRef then
          begin
            result := EntityRef(Atrib).Name;
            exit;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetReferenceAtribute(Obj: TEntityBase;
  E: TClass): string;
var
  ctx: TRttiContext;
  ctx2: TRttiContext;
  Prop: TRttiProperty;
  TypObj: TRttiType;
  Atrib: TCustomAttribute;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Obj.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      ctx2 := TRttiContext.Create;
      if Prop.PropertyType = ctx2.GetType(E.ClassInfo) then
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is EntityRef then
          begin
            result := EntityRef(Atrib).Name;
            exit;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetAttributies(E: TEntityBase;OnlyPublished: boolean = false): String;
var
  Prop: TRttiProperty;
  Attributies: string;
  ctx, ctx2: TRttiContext;
  Atributo: TCustomAttribute;
  FoundAttribute:boolean;
begin
  try
    if E <> nil then
    begin
       ctx := TRttiContext.Create;
       TypObj := ctx.GetType(E.ClassInfo);
       for Prop in TypObj.GetProperties do
       begin
         if (PropIsInstance(Prop)) then
         begin
            Attributies := Attributies + ', ' + GetAttributies( GetObjectProp(E ,Prop.Name) as TEntityBase , true );         
         end
         else
         begin
           ctx2 := TRttiContext.Create;
           for Atributo in Prop.GetAttributes do
           begin
             if (PropIsVisible(Prop) and (OnlyPublished)) or (not OnlyPublished) then
             begin
               FoundAttribute:= false;
               if Atributo is EntityField then
               begin
                 if Attributies = '' then
                    Attributies := EntityField(Atributo).Name
                 else
                 if Pos( EntityField(Atributo).Name , Attributies ) = 0 then
                    Attributies := Attributies + ', ' + EntityField(Atributo).Name;
                 FoundAttribute:= true;
                 break;
               end
               else
               if Atributo is EntityExpression then
               begin
                 if Attributies = '' then
                    Attributies := EntityExpression(Atributo).Expression
                 else
                    Attributies := Attributies + ', (' + EntityExpression(Atributo).Expression +') as '+EntityExpression(Atributo).Display;
                 FoundAttribute:= true;
                 break;
               end;

             end;
           end;
           if not FoundAttribute then
             if Attributies = '' then
                Attributies := Prop.Name
             else
                Attributies := Attributies + ', ' +Prop.Name;
         end;
       end;
    end;
  finally
    result := Attributies;
    ctx.Free;
  end;
end;


class function TAutoMapper.PropIsInstance( Prop: TRttiProperty):boolean;
begin
  result:= ( Prop.PropertyType.IsInstance) and
           ( Prop.Name <> 'PropertyType' ) and
           ( Prop.Name <> 'Parent' )       and
           ( Prop.Name <> 'Package' );
end;

class function TAutoMapper.GetAttributiesList(E: TEntityBase;
  OnlyPublished: boolean = false): TStringList;
var
  Prop: TRttiProperty;
  ctx, ctx2: TRttiContext;
  Atributo: TCustomAttribute;
  L: TStringList;
  tempStrings:TStrings;
  FoundAttribute:boolean;
begin
  try
    L := TStringList.Create(true);
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(E.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if  PropIsInstance(prop)  then
      begin
         //tempStrings:= ( GetAttributiesList( Prop.ClassInfo , true ) );
         tempStrings:= ( GetAttributiesList( GetObjectProp(E ,Prop.Name) as TEntityBase , true ) );         
         if tempStrings.Count > 0 then
            L.AddStrings( tempStrings );
         tempStrings.Clear;
      end
      else
      if (PropIsVisible(Prop) and (OnlyPublished)) or
        (not OnlyPublished) then
      begin
        FoundAttribute:= false;
        ctx2 := TRttiContext.Create;
        for Atributo in Prop.GetAttributes do
        begin
          if Atributo is EntityField then
          begin
            if not EntityField(Atributo).AutoInc then
            begin
               L.Add(EntityField(Atributo).Name);
               FoundAttribute:= true;
            end;
          end;
        end;
        if (not FoundAttribute) and (not EntityField(Atributo).AutoInc) then
           L.Add( Prop.Name );
      end;
    end;
  finally
    result := L;
    ctx.Free;
  end;
end;

class function TAutoMapper.GetAttributiesList(E: Pointer;
  OnlyPublished: boolean = false): TStringList;
var
  Prop: TRttiProperty;
  ctx, ctx2: TRttiContext;
  Atributo: TCustomAttribute;
  L: TStringList;
  tempStrings: TStrings;
  FoundAttribute:boolean;
begin
  try
    L := TStringList.Create(true);
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(E);
    for Prop in TypObj.GetProperties do
    begin
      if PropIsInstance(Prop) then
      begin
         tempStrings:= ( GetAttributiesList( Prop.ClassInfo , true ) );
         if tempStrings.Count > 0 then
            L.AddStrings( tempStrings );
         tempStrings.Clear;
      end
      else 
      if (PropIsVisible(Prop) and (OnlyPublished)) or
        (not OnlyPublished) then
      begin
        FoundAttribute:= false;
        ctx2 := TRttiContext.Create;
        for Atributo in Prop.GetAttributes do
        begin
          if Atributo is EntityField then
          begin
            if not EntityField(Atributo).AutoInc then
            begin
               L.Add(EntityField(Atributo).Name);
               FoundAttribute:= true;
            end;
          end;
        end;
        if (not FoundAttribute) and (not EntityField(Atributo).AutoInc ) then
           L.Add( Prop.Name );
      end;
    end;
  finally
    result := L;
    ctx.Free;
  end;
end;


class function TAutoMapper.GetAttributiesPrimaryKeyList(E: TEntityBase)
  : TStringList;
var
  Prop: TRttiProperty;
  ctx, ctx2: TRttiContext;
  Atrib: TCustomAttribute;
  L: TStringList;
  FoundAttribute: boolean;
begin
  try
    L := TStringList.Create(true);
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(E.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      ctx2 := TRttiContext.Create;
      for Atrib in Prop.GetAttributes do
      begin
        if Atrib is EntityField then
        begin
          if EntityField(Atrib).PrimaryKey then
          begin
            L.Add(EntityField(Atrib).Name);
            break;////////////////////////////
          end;
        end;
      end;
    end;
  finally
    result := L;
    ctx.Free;
  end;
end;

class function TAutoMapper.GetDafaultValue(E: TEntityBase; aProp: string): variant;
var
  ctx: TRttiContext;

  Prop: TRttiProperty;
  TypObj: TRttiType;
  Atrib: TCustomAttribute;
begin
  try
    result := '';
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(E.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if uppercase(aProp) = uppercase(Prop.Name) then
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is EntityDefault then
          begin
            result := EntityDefault(Atrib).Name;
            exit;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetMaxLengthValue(E: TEntityBase; aProp: string): variant;
var
  ctx: TRttiContext;

  Prop: TRttiProperty;
  TypObj: TRttiType;
  Atrib: TCustomAttribute;
begin
  try
    result := 0;
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(E.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if uppercase(aProp) = uppercase(Prop.Name) then
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is EntityMaxLength then
          begin
            result := EntityMaxLength(Atrib).Value;
            exit;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetValueField(E: TEntityBase; Field: TRttiField): string;
var
  Val: TValue;
  iInteger: TInteger;
  fFloat: TFloat;
  sString: TString;
  dDatetime: TEntityDatetime;
  Value, TypeClassName: string;
begin
  Val := Field.GetValue(E);
  TypeClassName := uppercase(Field.FieldType.ToString);
  if TypeClassName = uppercase('TInteger') then
  begin
    iInteger := Val.AsType<TInteger>;
    Value := iInteger.Value.ToString;
  end
  else if TypeClassName = uppercase('TFloat') then
  begin
    fFloat := Val.AsType<TFloat>;
    Value := fFloat.Value.ToString;
  end
  else if TypeClassName = uppercase('TString') then
  begin
    sString := Val.AsType<TString>;
    Value := quotedstr(sString.Value);
  end
  else if TypeClassName = uppercase('TEntityDateTime') then
  begin
    dDatetime := Val.AsType<TEntityDatetime>;
    if not fEmpty(dDatetime.Value) then
      Value := datetostr(dDatetime.Value);
  end;
  result := Value;
end;

class function TAutoMapper.GetValuesFields(E: TEntityBase): String;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  Field: TRttiField;
  values, Value: string;
begin
  for Prop in ctx.GetType(E.ClassType).GetProperties do
  begin
    for Field in ctx.GetType(E.ClassType).GetFields do
    begin
      if uppercase(Field.Name) = uppercase('F' + Prop.Name) then
      begin
        Value := GetValueField(E, Field);
        if values = '' then
          values := Value
        else
          values := values + ',' + Value;
        break;
      end;
    end;
  end;
  result := values;
end;

class function TAutoMapper.GetValueProperty(E: TEntityBase;
  Propert: string): string;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  Field: TRttiField;
  values, Value: string;
begin
  for Prop in ctx.GetType(E.ClassType).GetProperties do
    for Field in ctx.GetType(E.ClassType).GetFields do
    begin
      if (uppercase(Field.Name) = uppercase('F' + Propert)) and
        (uppercase(Propert) = uppercase(Prop.Name)) then
      begin
        Value := GetValueField(E, Field);

        if values = '' then
          values := Value
        else
          values := values + ',' + Value;
        break;
      end;
    end;
  result := fStringReplace(values, '''', '');
end;

class function TAutoMapper.GetValuesFieldsList(E: TEntityBase): TStringList;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  Field: TRttiField;
  Value: string;
  L: TStringList;
  FoundAtribute:boolean;
  typ: TRttiType;
  tempStrings:TStrings;
begin
  try
    L := TStringList.Create(true);
    typ := ctx.GetType(E.ClassType);
    
    for Prop in typ.GetProperties do
    begin
      FoundAtribute := false;
      if PropIsInstance(Prop) then
      begin
         tempStrings:= GetValuesFieldsList( GetObjectProp(E ,Prop.Name) as TEntityBase );
         if tempStrings.Count > 0 then
            L.AddStrings( tempStrings );
         tempStrings.Clear;
      end
      else
      begin
        for Field in typ.GetFields do
        begin
          if (uppercase(Field.Name) = uppercase('F' + Prop.Name)) or (Field.Name = 'Fvalue') then
          begin
            for Atrib in Prop.GetAttributes do
            begin
              if Atrib is EntityField then
              begin
                if not EntityField(Atrib).AutoInc then
                begin
                  Value := GetValueField(E, Field);
                  L.Add(Value);
                  break;
                end;
              end;
            end;
          end;
          //break;
        end;
      end;
    //if not FoundAtribute then
    end;
  finally
    result := L;
  end;
end;

class function TAutoMapper.GetValuesFieldsPrimaryKeyList(E: TEntityBase)
  : TStringList;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  Field: TRttiField;
  Value: string;
  L: TStringList;
  Atributo: TCustomAttribute;
begin
  try
    L := TStringList.Create(true);
    for Prop in ctx.GetType(E.ClassType).GetProperties do
      for Field in ctx.GetType(E.ClassType).GetFields do
      begin
        if uppercase(Field.Name) = uppercase('F' + Prop.Name) then
        begin
          for Atributo in Prop.GetAttributes do
          begin
            if (Atributo is EntityField) and (EntityField(Atributo).PrimaryKey)
            then
            begin
              Value := GetValueField(E, Field);
              L.Add(Value);
              break;
            end;
          end;
        end;
        break;/////////////////////////////
      end;
  finally
    result := L;
  end;
end;

class function TAutoMapper.GetTableAttribute(Obj: TClass): String;
var
  ctx: TRttiContext;
  TypObj: TRttiType;
  Atributo: TCustomAttribute;
  strTables: String;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Obj.ClassInfo);
    for Atributo in TypObj.GetAttributes do
    begin
      if (Atributo is EntityTable) then
      begin
        strTables := EntityTable(Atributo).Name;
        break;
      end;
    end;
    if strTables = '' then  strTables := Obj.ClassName;

    result := strTables
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetTableAttribute(ClassInfo: Pointer): String;
var
  ctx: TRttiContext;
  TypObj: TRttiType;
  Atributo: TCustomAttribute;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(ClassInfo);
    for Atributo in TypObj.GetAttributes do
    begin
      if Atributo is EntityTable then
      begin
        result := EntityTable(Atributo).Name;
        break;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TAutoMapper.SetAtribute(Entity: TEntityBase; Campo, Valor: string;
  InContext: boolean = false);
var
  ctx: TRttiContext;
  Field: TRttiField;
  Val: TValue;
  iInteger: TInteger;
  fFloat: TFloat;
  sString: TString;
  dDatetime: TEntityDatetime;
  TypeClassName: string;
begin
  for Field in ctx.GetType(Entity.ClassType).GetFields do
    if uppercase(Field.Name) = uppercase('F' + Campo) then
    begin
      Val := Field.GetValue(Entity);
      TypeClassName := uppercase(Field.FieldType.ToString);
      if TypeClassName = uppercase('TInteger') then
      begin
        iInteger := Val.AsType<TInteger>;
        iInteger.SetAs(Valor);
        TValue.Make(@iInteger, TypeInfo(TInteger), Val);
      end
      else if TypeClassName = uppercase('TFloat') then
      begin
        fFloat := Val.AsType<TFloat>;
        fFloat.SetAs(Valor);
        TValue.Make(@fFloat, TypeInfo(TFloat), Val);
      end
      else if TypeClassName = uppercase('TString') then
      begin
        sString := Val.AsType<TString>;
        sString.SetAs(Valor);
        sString.InContext := InContext;
        TValue.Make(@sString, TypeInfo(TString), Val);
      end
      else if TypeClassName = uppercase('TEntityDateTime') then
      begin
        dDatetime := Val.AsType<TEntityDatetime>;
        dDatetime.SetAs(Valor);
        TValue.Make(@dDatetime, TypeInfo(TEntityDatetime), Val);
      end;

      Field.SetValue(Entity, Val);
      break;
    end;
end;

class procedure TAutoMapper.SetFieldValue(Entity: TEntityBase; Campo: string;
  Valor: variant);
var
  ctx: TRttiContext;
  Field: TRttiField;
  Val: TValue;
  iInteger: TInteger;
  fFloat: TFloat;
  sString: TString;
  dDatetime: TEntityDatetime;
  TypeClassName: string;
begin
  for Field in ctx.GetType(Entity.ClassType).GetFields do
    if uppercase(Field.Name) = uppercase('F' + Campo) then
    begin
      TypeClassName := uppercase(Field.FieldType.ToString);
      Val := Field.GetValue(Entity);
      if TypeClassName = uppercase('TInteger') then
      begin
        iInteger := Val.AsType<TInteger>;
        iInteger.Value := ifthen( not fEmpty(Valor), Valor, 0);
        TValue.Make(@iInteger, TypeInfo(TInteger), Val);
      end
      else if TypeClassName = uppercase('TFloat') then
      begin
        fFloat := Val.AsType<TFloat>;
        fFloat.Value := ifthen( not fEmpty(Valor), Double(Valor), 0);
        TValue.Make(@fFloat, TypeInfo(TFloat), Val);
      end
      else if TypeClassName = uppercase('TString') then
      begin
        sString := Val.AsType<TString>;
        sString.Value := ifthen( fEmpty(Valor) ,'',valor);
        TValue.Make(@sString, TypeInfo(TString), Val);
      end
      else if TypeClassName = uppercase('TEntityDateTime') then
      begin
        dDatetime := Val.AsType<TEntityDatetime>;
        if not fEmpty(Valor) then
          dDatetime.Value := Valor;
        TValue.Make(@dDatetime, TypeInfo(TEntityDatetime), Val);
      end;
      Field.SetValue(Entity, Val);
      break;
    end;
end;

class procedure TAutoMapper.SetFieldValue(Entity: TEntityBase; Campo: TRttiProperty;
  Valor: variant);
var
  ctx: TRttiContext;
  Val: TValue;
  iInteger: TInteger;
  fFloat: TFloat;
  sString: TString;
  vInstance:Variant;
  dDatetime: TEntityDatetime;
  TypeClassName: string;
begin
    TypeClassName := uppercase(Campo.PropertyType.ToString);
    Val := Campo.GetValue(Entity);
    if TypeClassName = uppercase('TInteger') then
    begin
      iInteger := Val.AsType<TInteger>;
      iInteger.Value := ifthen( not fEmpty(Valor), Valor, 0);
      TValue.Make(@iInteger, TypeInfo(TInteger), Val);
    end
    else if TypeClassName = uppercase('TFloat') then
    begin
      fFloat := Val.AsType<TFloat>;
      fFloat.Value := ifthen( not fEmpty(Valor), Double(Valor), 0);
      TValue.Make(@fFloat, TypeInfo(TFloat), Val);
    end
    else if TypeClassName = uppercase('TString') then
    begin
      sString := Val.AsType<TString>;
      sString.Value := ifthen( fEmpty(Valor) ,'',valor);
      TValue.Make(@sString, TypeInfo(TString), Val);
    end
    else if TypeClassName = uppercase('TEntityDateTime') then
    begin
      dDatetime := Val.AsType<TEntityDatetime>;
      if not fEmpty(Valor) then
        dDatetime.Value := Valor;
      TValue.Make(@dDatetime, TypeInfo(TEntityDatetime), Val);
    end;
    Campo.SetValue(Entity, Val);
end;

class function TAutoMapper.ToMapping(Entity: TEntityBase;
  InContext: boolean): boolean;
var
  ctx: TRttiContext;
  RTTI: TRttiType;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  Found:boolean;
begin
  try
    result := false;
    ctx := TRttiContext.Create;
    RTTI := ctx.GetType(Entity.ClassInfo);
    for Prop in RTTI.GetProperties do
    begin
      Found:= false;
      if not PropIsInstance(Prop) then
      begin
        for Atrib in Prop.GetAttributes do
        begin
          try
            if Atrib is EntityField then
            begin
              TAutoMapper.SetAtribute(Entity, Prop.Name,
                TAutoMapper.GetTableAttribute(Entity.ClassType) + '.' +
                EntityField(Atrib).Name, InContext);
              result := true;
              break;
            end;
          except
            result := false;
            exit;
          end;
        end;
        if not Found then
        begin
          TAutoMapper.SetAtribute(Entity, Prop.Name,
                TAutoMapper.GetTableAttribute(Entity.ClassType) + '.' +
                Prop.Name, InContext);
              result := true;
        end;
      end;

    end;
  finally
    ctx.Free;
  end;
end;

class procedure TAutoMapper.DataToEntity(DataSet: TDataSet; Entity: TEntityBase);
var
  J: integer;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  ctx: TRttiContext;
  breaked:boolean;
begin
  try
    ctx := TRttiContext.Create;
    for J := 0 to DataSet.fieldcount - 1 do
    begin
      breaked:= false;
      TypObj := ctx.GetType(Entity.ClassInfo);
      for Prop in TypObj.GetProperties do
      begin
        if PropIsInstance(Prop) then
        begin
           DataToEntity( DataSet, GetObjectProp( Entity ,Prop.Name) as TEntityBase );
        end
        else
        begin 
          for Atrib in Prop.GetAttributes do
          begin
            if Atrib is EntityField then
            begin
              if uppercase(EntityField(Atrib).Name)
                = uppercase(DataSet.Fields[J].FieldName) then
              begin
                SetFieldValue(Entity, Prop,
                              DataSet.Fieldbyname(EntityField(Atrib).Name).AsVariant);
                breaked:= true;
                break;
              end;
            end;
          end;
        end;
        if breaked then
           break;
      end;
    end;
  finally
    ctx.Free;
  end;
end;


class function TAutoMapper.ValidComponent( Comp:TComponent):boolean;
begin
   result := ( Comp.InheritsFrom(TCustomEdit) ) or
             ( Comp.InheritsFrom(TCustomCombobox) ) or
             ( Comp.InheritsFrom(TCustomDBLookupComboBox) ) or
             ( Comp.InheritsFrom(TCustomCheckBox) ) or
             ( Comp.InheritsFrom(TCustomMemo) ) or
             ( Comp.InheritsFrom(TCustomRadioGroup) ) or
             ( Comp.InheritsFrom(TCommonCalendar) );
end;

class procedure TAutoMapper.Read(Component: TComponent; Entity: TEntityBase;
  SetDefaultValue: boolean; DataSet :TDataSet = nil);
var
  J: integer;
  Prop: TRttiProperty;
  Componente: TComponent;
  ctx: TRttiContext;
  Value: string;

  procedure setValueDBLookUpCombobox;
  begin
    TDBLookUpCombobox(Componente).KeyValue := Value;
  end;

  procedure SetValueDateTimePicker;
  begin
    if Value <> '' then
      TDateTimePicker(Componente ).Datetime := strtodate(Value)
    else
      TDateTimePicker(Componente ).Date := Date;
  end;

  procedure SetValueCheckBox;
  begin
    TCheckBox(Componente ).Checked := strtoIntdef(Value, 0) = 1;//abs(strtofloatdef(Value, 0)) = 1;
  end;

  procedure SetValueLabel;
  begin
    TLabel(Componente ).caption := Value;
  end;

  procedure SetValueMemo(MaxLength:integer = 0);
  begin
    TMemo(Componente).Text := Value;
    if MaxLength > 0 then
       TMemo(Componente).MaxLength := MaxLength;
  end;

  procedure SetValueEdit(MaxLength:integer = 0);
  begin
    TEdit(Componente).Text := Value;
     if MaxLength > 0 then
       TEdit(Componente).MaxLength := MaxLength;
  end;

  procedure SetValueMaskEdit(MaxLength:integer = 0);
  begin
    TMaskEdit(Componente).Text := Value;
     if MaxLength > 0 then
       TMaskEdit(Componente).MaxLength := MaxLength;
  end;

  procedure SetValueCombobox;
  var
    Atrib: TCustomAttribute;
    i: integer;
    Item: PItem;
    ValueItem: string;
    IndexOf: integer;
  begin
    IndexOf := -1;
    if (TCombobox(Componente ).Items.Count = 0) or (SetDefaultValue) then
    begin
      TCombobox(Componente).Items.Clear;
      for Atrib in Prop.GetAttributes do
      begin
        if Atrib is EntityItems then
        begin
          for i := 0 to EntityItems(Atrib).Items.Count - 1 do
          begin
            ValueItem := EntityItems(Atrib).Items.Strings[i];
            System.New(Item);
            Item.Text := copy(ValueItem, Pos('=', ValueItem) + 1,
              length(ValueItem));
            Item.Value := copy(ValueItem, 1, Pos('=', ValueItem) - 1);
            TCombobox(Componente).Items.AddObject(Item.Text, TObject(Item));
            if (Value = Item.Value) or (Value = Item.Text) then
              IndexOf := i;
          end;
        end;
      end;
    end;
    if IndexOf > -1 then
      (Componente as TCombobox).ItemIndex := IndexOf;
  end;

  procedure SetValueRadioGroup;
  var
    Atrib: TCustomAttribute;
    i: integer;
    Item: PItem;
    ValueItem: string;
    IndexOf: integer;
  begin
    IndexOf := -1;
    if ((Componente as TRadioGroup).Items.Count = 0) or (SetDefaultValue) then
    begin
      (Componente as TRadioGroup).Items.Clear;
      for Atrib in Prop.GetAttributes do
      begin
        if Atrib is EntityItems then
        begin
          for i := 0 to EntityItems(Atrib).Items.Count - 1 do
          begin
            ValueItem := EntityItems(Atrib).Items.Strings[i];
            System.New(Item);
            Item.Text := copy(ValueItem, Pos('=', ValueItem) + 1,
              length(ValueItem));
            Item.Value := copy(ValueItem, 1, Pos('=', ValueItem) - 1);
            (Componente as TRadioGroup).Items.AddObject(Item.Text,
              TObject(Item));
            if (Value = Item.Value) or (Value = Item.Text) then
              IndexOf := i;
          end;
        end;
      end;
    end;
    if IndexOf > -1 then
      (Componente as TRadioGroup).ItemIndex := IndexOf;
  end;

begin
  try
    if DataSet <> nil then
       DataToEntity(DataSet, Entity);

    ctx := TRttiContext.Create;
    for J := 0 to Component.componentcount - 1 do
    begin
      Componente := Component.components[J];
      if ValidComponent(Componente) then
      begin
        TypObj := ctx.GetType(Entity.ClassInfo);
        for Prop in TypObj.GetProperties do
        begin
           if PropNameEqualComponentName(Prop,Componente ) then
           begin
               if PropIsInstance(prop)  then
                  Value := TAutoMapper.GetValueProperty( GetObjectProp( Entity ,Prop.Name) as TEntityBase , 'value' )
               else
               if SetDefaultValue then
                 Value := TAutoMapper.GetDafaultValue(Entity, Prop.Name)
               else
                 Value := TAutoMapper.GetValueProperty(Entity, Prop.Name);

               if Componente.InheritsFrom(TCustomMemo) then
                 SetValueMemo( TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) ) else
               if Componente.InheritsFrom(TCustomCombobox) then
                 SetValueCombobox else
               if Componente.InheritsFrom(TCustomDBLookupComboBox) then
                 setValueDBLookUpCombobox else
               if Componente.InheritsFrom(TCommonCalendar) then
                 SetValueDateTimePicker else
               if Componente.InheritsFrom(TCustomCheckBox) then
                 SetValueCheckBox else
               if Componente.InheritsFrom(TCustomLabel) then
                 SetValueLabel else
               if Componente.InheritsFrom(TCustomRadioGroup) then
                 SetValueRadioGroup else
               if Componente.InheritsFrom(TCustomMaskEdit) then
                 SetValueMaskEdit( TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) ) else
               if Componente.InheritsFrom(TCustomEdit) then
                 SetValueEdit( TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) );
               break;
           end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.SetComponentValueProp(Componente:TComponent;Prop: TRttiProperty; Entity: TEntityBase):boolean;
var
  Value: variant;
  ListField:string;
  TextListField: string;
  Item: PItem;
  ItemIndex: integer;
begin
    if Componente.InheritsFrom(TCustomMemo) then
    begin
        Value := TMemo(Componente).Text
    end
    else
    if (Componente.InheritsFrom(TCustomEdit)) then
    begin
        Value := TEdit(Componente).Text
    end
    else
    if (Componente.InheritsFrom(TCustomDBLookupComboBox)) then
    begin
        Value         := TDBLookUpCombobox(Componente).KeyValue;
        ListField     := TDBLookUpCombobox(Componente).ListField;
        TextListField := TDBLookUpCombobox(Componente).text;
    end
    else
    if Componente.InheritsFrom(TCustomCombobox) then
    begin
      Item := PItem(TCombobox(Componente).Items.Objects
        [TCombobox(Componente)
        .Items.IndexOf(TCombobox(Componente).Text)]);
      if Item <> nil then
          Value := ifthen(Item.Value <> '', Item.Value, Item.Text)
      else
          Value := TCombobox(Componente).Text;
    end
    else if Componente.InheritsFrom(TCommonCalendar) then
        Value := TDateTimePicker(Componente).Datetime
    else
    if Componente.InheritsFrom(TCustomRadioGroup) then
    begin
      ItemIndex := (Componente as TRadioGroup).ItemIndex;
      if ItemIndex > -1 then
      begin
          Item := PItem(TRadioGroup(Componente).Items.Objects
            [TRadioGroup(Componente)
            .Items.IndexOf((Componente as TRadioGroup).Items.Strings
            [ItemIndex])]);

          if Item <> nil then
          begin
            Value := ifthen(Item.Value <> '', Item.Value, Item.Text)
          end
          else
            Value := (Componente as TRadioGroup).Items.Strings
              [(Componente as TRadioGroup).ItemIndex];
      end;
    end
    else
    if Componente.InheritsFrom(TCustomCheckBox) then
    begin
      if (Componente as TCheckBox).Checked then
        Value := '1'
      else
        Value := '0';
    end;

   SetFieldValue(Entity, Prop, Value); 

    if ListField <> '' then
    begin
       SetFieldValue(Entity, ListField, TextListField);
       ListField:= '';
    end;

    result:= true;
end;

class function TAutoMapper.PropNameEqualComponentName( Prop: TRttiProperty; Componente: TComponent):boolean;
begin
  result:= Prop.Name = copy(Componente.Name, Pos(Prop.Name, Componente.Name), length(Componente.Name));
end;

class procedure TAutoMapper.Puts(Component: TComponent; Entity: TEntityBase;Valued: boolean = false);
var
  J: integer;
  Prop: TRttiProperty;
  Componente: TComponent;
  ctx: TRttiContext;
  obj:TEntityBase;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
        if Valued then
        begin
          if upperCase(Prop.Name) = 'VALUE' then
          begin
             if SetComponentValueProp(Component,Prop, Entity ) then
                break;
          end;
        end
        else
        for J := 0 to Component.componentcount - 1 do
        begin
           Componente := Component.components[J];
           if PropNameEqualComponentName( Prop, Componente) then
           begin
              if not PropIsInstance(prop)  then
              begin
                 if SetComponentValueProp(Componente,Prop, Entity ) then
                    break;
              end
              else
              begin
                puts( Componente , GetObjectProp(Entity,Prop.Name) as TEntityBase, true );
              end;
           end;
        end;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TAutoMapper.PutsFromControl(ComponentControl: TCustomControl; Entity: TEntityBase);
var
  J: integer;
  Prop: TRttiProperty;
  Componente: TComponent;
  ctx: TRttiContext;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if not PropIsInstance(prop)  then
      begin
        for J := 0 to ComponentControl.ControlCount- 1 do
        begin
          Componente := ComponentControl.Controls[J];
          if PropNameEqualComponentName( Prop, Componente) then
          begin
            if SetComponentValueProp(Componente,Prop, Entity ) then
             break;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetInstance(const Str_Class: TValue): TObject;
var
  C: TRttiContext;
  instancia: TRttiInstanceType;
  p: TRttiType;
  Erro: String;
begin
  try
    case Str_Class.Kind of
      tkString, tkLString, tkWString, tkUString:
      begin
          Erro := Str_Class.AsString + ' Classe Não encontrada';
          instancia := (C.FindType(Str_Class.AsString) as TRttiInstanceType);
          result := (instancia.MetaclassType.Create);
      end;
      tkClassRef:
      begin
          Erro := 'O parâmetro passado deve ser do tipo Tclass' + sLineBreak;
          p := C.GetType(Str_Class.AsClass);
          instancia := (C.FindType(p.QualifiedName) as TRttiInstanceType);
          result := instancia.MetaclassType.Create;
      end;
      else
      begin
          Erro := 'O parâmetro passado não é válidado para a função' + sLineBreak;
          abort;
      end;
    end;
  except
    raise Exception.Create(Erro);
  end;
end;

class function TAutoMapper.CreateObject(AQualifiedClassName: string): TObject;
var
  rttitype: TRttiType;
begin
  rttitype := ctx.FindType(AQualifiedClassName);
  if Assigned(rttitype) then
    Result := CreateObject(rttitype)
  else
    raise Exception.Create('Cannot find RTTI for ' + AQualifiedClassName + '. Hint: Is the specified classtype linked in the module?');
end;

class function TAutoMapper.CreateObject(ARttiType: TRttiType): TObject;
var
  Method: TRttiMethod;
  metaClass: TClass;
begin
  { First solution, clear and slow }
  metaClass := nil;
  Method := nil;
  for Method in ARttiType.GetMethods do
    if Method.HasExtendedInfo and Method.IsConstructor then
      if Length(Method.GetParameters) = 0 then
      begin
        metaClass := ARttiType.AsInstance.MetaclassType;
        Break;
      end;
  if Assigned(metaClass) then
    Result := Method.Invoke(metaClass, []).AsObject
  else
    raise Exception.Create('Cannot find a propert constructor for ' + ARttiType.ToString);

  { Second solution, dirty and fast }
  // Result := TObject(ARttiType.GetMethod('Create')
  // .Invoke(ARttiType.AsInstance.MetaclassType, []).AsObject);
end;

class procedure TAutoMapper.CreateDinamicView(Entity: TEntityBase; Form: TForm);
//TAutoMapper.CreateDinamicView( TCliente.create , Self );
var
  J: integer;
  Prop: TRttiProperty;
  Componente: TComponent;
  ctx: TRttiContext;
  Value: string;
  Atrib: TCustomAttribute;

  Labels: Array[1..100] of TLabel;
  Edits: Array[1..100] of TEdit;
  Memos: Array[1..100] of TMemo;
  Dates: Array[1..100] of TDateTimePicker;
  Checks: Array[1..100] of TCheckBox;
  Combos: Array[1..100] of TComboBox;
  LookUpCombos: Array[1..100] of TDBLookUpComboBox;

  i,c, altura: integer;

  procedure CreateLabel;
  begin
    Labels[c] := TLabel.Create(Form);
    Labels[c].Parent := Form;
    Labels[c].Left := 40;
    Labels[c].Top := altura;
    Labels[c].Width := 50;
    Labels[c].Height := 13;
    Labels[c].Caption := prop.name;
  end;

  procedure CreateEdit(Name: string);
  begin
    Edits[c] := TEdit.Create(Form);
    Edits[c].Parent := Form;
    Edits[c].Left := 40;
    Edits[c].Top := altura;
    Edits[c].Width := 100;
    Edits[c].Height := 21;
    Edits[c].TabOrder := c;
    Edits[c].NumbersOnly := (PropIsInteger(prop)) and(PropIsFloat(prop));
    Edits[c].Name:= name;
  end;

  procedure CreateCheckBox(Name: string);
  begin
    Checks[c] := TCheckBox.Create(Form);
    Checks[c].Parent := Form;
    Checks[c].Left := 40;
    Checks[c].Top := altura;
    Checks[c].Width := 100;
    Checks[c].Height := 21;
    Checks[c].TabOrder := c;
    Checks[c].Caption := prop.name;
    Checks[c].Name:= 'chk'+name;
  end;

  procedure CreateMemo(Name: string);
  begin
    Memos[c] := TMemo.Create(Form);
    Memos[c].Parent := Form;
    Memos[c].Left := 40;
    Memos[c].Top := altura;
    Memos[c].TabOrder := c;
    Memos[c].Name:= 'memo'+name;
  end;

  procedure CreateDatetimePick(Name: string);
  begin
    Dates[c] := TDateTimePicker.Create(Form);
    Dates[c].Parent := Form;
    Dates[c].Left := 40;
    Dates[c].Top := altura;
    Dates[c].Width := 100;
    Dates[c].Height := 21;
    Dates[c].TabOrder := c;
    Dates[c].Name:= 'date'+name;
  end;

  procedure CreateCombobox(Name: string);
  begin
    Combos[c] := TCombobox.Create(Form);
    Combos[c].Parent := Form;
    Combos[c].Left := 40;
    Combos[c].Top := altura;
    Combos[c].Width := 100;
    Combos[c].Height := 21;
    Combos[c].TabOrder := c;
    Combos[c].Name:= 'cbo'+name;
  end;

  procedure CreateLookUpCombobox(Name: string);
  begin
    LookUpCombos[c] := TDBLookUpCombobox.Create(Form);
    LookUpCombos[c].Parent := Form;
    LookUpCombos[c].Left := 40;
    LookUpCombos[c].Top := altura;
    LookUpCombos[c].Width := 100;
    LookUpCombos[c].Height := 21;
    LookUpCombos[c].TabOrder := c;
    LookUpCombos[c].Name:= 'cbo'+name;
  end;

begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Entity.ClassInfo);

    c := 0;
    altura := 10;
    for Prop in TypObj.GetProperties do
    begin
       if (not PropIsInstance(prop)) and (PropIsVisible(prop)) then
       begin
          for Atrib in Prop.GetAttributes do
          begin
            CreateLabel;

          //Labels[c].Font.Color := clred;
            if Atrib is Edit then
            begin
                Altura := altura + 15;
                CreateEdit(prop.name);
               //Edits[c].MaxLength :=  ClientDataSet1.Fields[c].Size;
              break;
            end
            else
            if Atrib is CheckBox then
            begin
              Altura := altura + 15;
              CreateCheckBox(prop.name);
              break;
            end
            else
            if Atrib is Memo then
            begin
              Altura := altura + 15;
              CreateMemo(prop.name);
              //Memos[c].MaxLength :=  ClientDataSet1.Fields[c].Size;
              break;
            end
            else
            if Atrib is  DateTimePicker then
            begin
              Altura := altura + 15;
              CreateDateTimePick(prop.name);
              break;
            end
            else
            if Atrib is  Combobox then
            begin
              Altura := altura + 15;
              CreateCombobox(prop.name);
              break;
            end
            else
            if Atrib is  LookupCombobox then
            begin
              Altura := altura + 15;
              CreateLookupCombobox(prop.name);
              break;
            end;

          end;
          Altura := altura + 23;
          c := c+1;
       end;
     end;
  finally
    ctx.Free;
  end;

end;

end.

