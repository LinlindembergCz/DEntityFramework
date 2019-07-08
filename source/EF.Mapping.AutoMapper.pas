unit EF.Mapping.AutoMapper;

interface

uses
   Forms,  RTTI, Classes,  SysUtils,
   Vcl.Controls, DB, System.Contnrs,  StdCtrls, strUtils, math,
   System.Generics.Collections,
   EF.Mapping.Atributes,
   EF.Mapping.Base,
   EF.Core.Types, Rest.json, System.JSON;

type
  TAutoMapper = class
  private
    class var ctx: TRttiContext;
    class var TypObj: TRttiType;
    class function GetValueField(E: TEntityBase; Field: TRttiField): string; static;

  public
    class function GetMaxLengthValue(E: TEntityBase; aProp: string): variant; static;
    class function PropIsInstance(Prop: TRttiProperty): boolean; static;
    class function PropIsFloat(Prop: TRttiProperty): boolean; static;
    class function PropIsInteger(Prop: TRttiProperty): boolean; static;
    class function PropIsString(Prop: TRttiProperty): boolean; static;
    class function PropIsDate(Prop: TRttiProperty): boolean; static;
    class function PropIsVisible(prop: TRttiProperty): boolean; static;

    class function CreateObject(AQualifiedClassName: string): TObject; overload;
    class function CreateObject(ARttiType: TRttiType): TObject;overload;
    class function SetObject(Entity: TEntityBase; ClassName: string; Value: TObject):TObject;
    class function GetObject(Entity: TEntityBase; ClassName: string): TObject; static;

    class function GetTableAttribute(Obj: TClass): String; overload;
    class function GetTableAttribute(ClassInfo: Pointer): String; overload;
    class function GetAttributies(E: TEntityBase;OnlyPublished:boolean = false; WithID:boolean =true): String; static;
    class function GetListAtributesForeignKeys(Obj: TClass): TList; static;
    class procedure SetAtribute(Entity: TEntityBase; Campo, Valor: string;InContext: boolean = false); static;

    class function GetFieldsList(E: TEntityBase;OnlyPublished: boolean = false; WithID:boolean =false): TStringList;overload;
    class function GetFieldsList(E: Pointer; OnlyPublished: boolean = false): TStringList;overload;
    class function GetFieldsPrimaryKeyList(E: TEntityBase): TStringList;

    class function GetListAtributes(Obj: TClass): TList;
    class function GetValuesFields(E: TEntityBase; WithID :boolean = true): String; static;
    class function GetValuesFieldsList(E: TEntityBase; WithId:boolean = false): TStringList; static;
    class function GetValuesFieldsPrimaryKeyList(E: TEntityBase)
      : TStringList; static;
    class function GetDafaultValue(E: TEntityBase; aProp: string)
      : variant; static;
    class function GetValueProperty(E: TEntityBase; Propert: string)
      : string; static;
    class procedure DataToEntity(DataSet: TDataSet; Entity: TEntityBase);overload;
    class procedure DataToEntity(DataSet: TDataSet; Entity: TObject);overload;
    class function ToMapping(Entity: TEntityBase; InContext: boolean; Quoted :boolean ): boolean;
    class function GetReferenceAtribute(Obj: TEntityBase; E: TEntityBase)
      : string;overload; static;
    class function GetReferenceAtribute(Obj: TEntityBase; E: TClass)
      : string;overload; static;
    class procedure SetFieldValue(Entity: TEntityBase; Campo: string;
      Valor: variant); overload;static;
    class procedure SetFieldValue(Entity: TEntityBase; Campo: TRttiProperty;
     Valor: variant);overload;static;
    class procedure SetFieldValue(Entity: TEntityBase; Campo: TRttiProperty;
     Valor: Tdatetime);overload;static;

    class function GetInstance<T:TEntityBase>(const Str_Class: TValue): T; static;
    class function GetInstance2(const Str_Class: TValue): TObject;
    class procedure CreateDinamicView( Entity: TEntityBase; Form:TForm;Parent:TWinControl = nil);
    class procedure JsonObjectToObject<T:TEntityBase>(Json: TJSOnObject; O: T);
  end;

  Const
  cFLOAT    = 'TFLOAT';
  cInteger  = 'TINTEGER';
  cString   = 'TSTRING';
  cDatetime = 'TDATE';

implementation

uses
  System.TypInfo, Vcl.DBCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, VCL.Mask,
  EF.Core.Functions;

{ TAutoMapper }

class function TAutoMapper.PropIsFloat(Prop: TRttiProperty): boolean;
begin

   result:= UpperCase(prop.PropertyType.ToString) = cFLOAT;
end;

class function TAutoMapper.PropIsInteger(Prop: TRttiProperty): boolean;
begin
   result:= UpperCase(prop.PropertyType.ToString) = cInteger;
end;

class function TAutoMapper.PropIsString(Prop: TRttiProperty): boolean;
begin
   result:= UpperCase(prop.PropertyType.ToString) = cString;
end;

class function TAutoMapper.PropIsDate(Prop: TRttiProperty): boolean;
var
  date:TDatetime;
begin
   result:= UpperCase(prop.PropertyType.ToString) = cDatetime;
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
  tempList:TList;
  Instance: TObject;

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
    List := TObjectList.Create(true);
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Obj.ClassInfo);

    for Prop in TypObj.GetProperties do
    begin
      if PropIsInstance(Prop) then
      begin
         if Prop.Propertytype.AsInstance <> nil then
         begin
           Found:= false;
           for Atributo in Prop.GetAttributes do
           begin
              if (Atributo is NotMapper) then
              begin
                 Found:= true;
                 break;
              end
           end;
           if not Found then
           begin
             tempList := GetListAtributes( Prop.Propertytype.AsInstance.MetaclassType);
             if tempList.Count > 0 then
                List.Add( tempList[0] );
           end;
         end
         //tempList.Clear;
      end
      else
      begin
        Found:= false;
        for Atributo in Prop.GetAttributes do
        begin
          if (Atributo is FieldTable) then
          begin
            if FieldTable(Atributo).Tipo <> '' then
            begin
              New(Atributies);
              Atributies^.Name := FieldTable(Atributo).Name;
              Atributies^.Tipo := FieldTable(Atributo).Tipo;
              Atributies^.IsNull := FieldTable(Atributo).IsNull;
              Atributies^.PrimaryKey := FieldTable(Atributo).PrimaryKey;
              Atributies^.DefaultValue := FieldTable(Atributo).DefaultValue;
              Atributies^.AutoInc := FieldTable(Atributo).AutoInc;
              List.Add(Atributies);
            end;
            Found:= true;
          end;
          if (Atributo is NotMapper) then
          begin
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

class function TAutoMapper.GetListAtributesForeignKeys(Obj: TClass): TList;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  TypObj: TRttiType;
  Atributo: TCustomAttribute;
  Atributies: PParamForeignKeys;
  List: TList;
  Found:Boolean;
begin
  try
    List := TObjectList.Create(true);
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Obj.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      Found:= false;
      for Atributo in Prop.GetAttributes do
      begin
        if (Atributo is ForeignKey) then
        begin
          New(Atributies);
          Atributies^.ForeignKey:= ForeignKey(Atributo).ForeignKey;
          Atributies^.Name := ForeignKey(Atributo).Name;
          Atributies^.OnDelete:=ForeignKey(Atributo).OnDelete;
          Atributies^.OnUpdate:=ForeignKey(Atributo).OnUpdate;
          List.Add(Atributies);
          Found:= true;
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
          if Atrib is Reference then
          begin
            result := Reference(Atrib).Name;
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
          if Atrib is Reference then
          begin
            result := Reference(Atrib).Name;
            exit;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetAttributies(E: TEntityBase;OnlyPublished: boolean = false; WithID:boolean = true): String;
var
  Prop: TRttiProperty;
  Attributies: string;
  ctx, ctx2: TRttiContext;
  Atributo: TCustomAttribute;
  FoundAttribute:boolean;
  FieldName: string;
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
           FoundAttribute:= false;
           for Atributo in Prop.GetAttributes do
           begin
              if (Atributo is NotMapper) then
              begin
                 FoundAttribute:= true;
                 break;
              end
           end;
           if not FoundAttribute then
           begin
              FieldName := GetAttributies( GetObjectProp(E ,Prop.Name) as TEntityBase , true, WithID );
              if FieldName <> '' then
                 Attributies := Attributies + ', ' + FieldName;
           end;
         end
         else
         begin
           ctx2 := TRttiContext.Create;
           for Atributo in Prop.GetAttributes do
           begin
             if ( (PropIsVisible(Prop) and (OnlyPublished)) or (not OnlyPublished) )  then
             begin
               if ( (uppercase(Prop.Name) = 'ID' ) and (not WithID ) ) then
                 break;

               FoundAttribute:= false;
               if Atributo is FieldTable then
               begin
                 if Attributies = '' then
                    Attributies := FieldTable(Atributo).Name
                 else
                 if Pos( FieldTable(Atributo).Name , Attributies ) = 0 then
                    Attributies := Attributies + ', ' + FieldTable(Atributo).Name;
                 FoundAttribute:= true;
                 break;
               end
               else
               if Atributo is Expression then
               begin
                 if Attributies = '' then
                    Attributies := Expression(Atributo).Expression
                 else
                    Attributies := Attributies + ', (' + Expression(Atributo).Expression +') as '+Expression(Atributo).Display;
                 FoundAttribute:= true;
                 break;
               end
               else
               if Atributo IS NotMapper then
               begin
                  FoundAttribute:= true;
                  break;
               end;
             end;
           end;
           ctx2.Free;
           if not FoundAttribute then
           begin
             if Attributies = '' then
                Attributies := Prop.Name
             else
                Attributies := Attributies + ', ' +Prop.Name;
           end;
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

class function TAutoMapper.GetFieldsList(E: TEntityBase;
  OnlyPublished: boolean = false; WithID:boolean =false): TStringList;
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
         FoundAttribute:= false;
         for Atributo in Prop.GetAttributes do
         begin
            if (Atributo is NotMapper) then
            begin
               FoundAttribute:= true;
               break;
            end
         end;
         if not FoundAttribute then
         begin
           tempStrings:= ( TAutoMapper.GetFieldsList( GetObjectProp(E ,Prop.Name) as TEntityBase , true ) );
           if tempStrings.Count > 0 then
              L.AddStrings( tempStrings );
           tempStrings.free;
         end;
      end
      else
      if (PropIsVisible(Prop) and (OnlyPublished)) or
        (not OnlyPublished) then
      begin
        FoundAttribute:= false;
        ctx2 := TRttiContext.Create;
        for Atributo in Prop.GetAttributes do
        begin
          if Atributo is FieldTable then
          begin
            if (not FieldTable(Atributo).AutoInc) or (WithID) then
            begin
               L.Add(upperCase(FieldTable(Atributo).Name));
               FoundAttribute:= true;
            end;
          end;
          if Atributo is NotMapper then
          begin
            FoundAttribute:= true;
          end;
        end;
        ctx2.Free;
        if (not FoundAttribute) and (not FieldTable(Atributo).AutoInc) then
           L.Add( upperCase(Prop.Name) );
      end;
    end;
  finally
    result := L;
    ctx.Free;
  end;
end;

class function TAutoMapper.GetFieldsList(E: Pointer;
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
         FoundAttribute:= false;
         for Atributo in Prop.GetAttributes do
         begin
            if (Atributo is NotMapper) then
            begin
               FoundAttribute:= true;
               break;
            end
         end;
         if not FoundAttribute then
         begin
           tempStrings:= ( GetFieldsList( Prop.ClassInfo , true ) );
           if tempStrings.Count > 0 then
              L.AddStrings( tempStrings );
           tempStrings.Clear;
           tempStrings.Free;
         end;
      end
      else 
      if (PropIsVisible(Prop) and (OnlyPublished)) or
        (not OnlyPublished) then
      begin
        FoundAttribute:= false;
        ctx2 := TRttiContext.Create;
        for Atributo in Prop.GetAttributes do
        begin
          if Atributo is FieldTable then
          begin
            if not FieldTable(Atributo).AutoInc then
            begin
               L.Add(FieldTable(Atributo).Name);
               FoundAttribute:= true;
            end;
          end;
        end;
        ctx2.Free;
        if (not FoundAttribute) and (not FieldTable(Atributo).AutoInc ) then
           L.Add( Prop.Name );
      end;
    end;
  finally
    result := L;
    ctx.Free;
  end;
end;


class function TAutoMapper.GetFieldsPrimaryKeyList(E: TEntityBase)
  : TStringList;
var
  Prop: TRttiProperty;
  ctx, ctx2: TRttiContext;
  Atrib: TCustomAttribute;
  L: TStringList;
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
        if Atrib is FieldTable then
        begin
          if FieldTable(Atrib).PrimaryKey then
          begin
            L.Add(FieldTable(Atrib).Name);
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
          if Atrib is Default then
          begin
            result := Default(Atrib).Name;
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
          if Atrib is MaxLength then
          begin
            result := MaxLength(Atrib).Value;
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
  dDatetime: TDate;
  Value, TypeClassName: string;
begin
  Val := Field.GetValue(E);
  TypeClassName := uppercase(Field.FieldType.ToString);
  if TypeClassName = uppercase(cInteger) then
  begin
    iInteger := Val.AsType<TInteger>;
    Value := iInteger.Value.ToString;
  end
  else if TypeClassName = uppercase(cFloat) then
  begin
    fFloat := Val.AsType<TFloat>;
    Value := fFloat.Value.ToString;
  end
  else if TypeClassName = uppercase(cString) then
  begin
    sString := Val.AsType<TString>;
    Value := quotedstr(sString.Value);
  end
  else if TypeClassName = uppercase(cDateTime) then
  begin
    dDatetime := Val.AsType<TDate>;
    if not fEmpty(dDatetime.Value) then
      Value := datetostr(dDatetime.Value);// quotedstr( datetostr() ); // FormatDateTime('DD/MM/YYYY',)  quotedstr( FormatDateTime('YYYY-MM-DD',dDatetime.Value) );//
  end;
  result := Value;
end;

class function TAutoMapper.GetValuesFields(E: TEntityBase; WithID :boolean = true): String;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  Field: TRttiField;
  values, Value: string;
begin
  for Prop in ctx.GetType(E.ClassType).GetProperties do
  begin
    if not PropIsInstance(Prop) then
    begin
      for Field in ctx.GetType(E.ClassType).GetFields do
      begin
        if (uppercase(Field.Name) = uppercase('F' + Prop.Name))  or
           ( (uppercase(Prop.Name) = 'ID' ) and (WithID ) )  then
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
  begin
    if not PropIsInstance(Prop) then
    begin
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
    end;
    if (uppercase(Propert) = uppercase(Prop.Name)) then
       break;
  end;
  result := fStringReplace( values, '''', '' );
end;

class function TAutoMapper.GetValuesFieldsList(E: TEntityBase; WithId:boolean = false): TStringList;
var
  ctx: TRttiContext;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  lField: TRttiField;
  Value: string;
  L: TStringList;
  typ: TRttiType;
  tempStrings:TStrings;
  FoundAttribute:boolean;
  Instance: TObject;
begin
  try
    L := TStringList.Create(true);
    typ := ctx.GetType(E.ClassType);
    for Prop in typ.GetProperties do
    begin
      if PropIsInstance(Prop) then
      begin
         Instance := GetObjectProp(E ,Prop.Name);
         if Instance <> nil then
         begin
           FoundAttribute:= false;
           for Atrib in Prop.GetAttributes do
           begin
              if (Atrib is NotMapper) then
              begin
                 FoundAttribute:= true;
                 break;
              end
           end;
           if not FoundAttribute then
           begin
             tempStrings:= GetValuesFieldsList( instance as TEntityBase );
             if tempStrings.Count > 0 then
                L.AddStrings( tempStrings );
             tempStrings.Clear;
             tempStrings.Free;
           end;
         end;
      end
      else
      begin
        for lField in typ.GetFields do
        begin
          if (uppercase(lField.Name) = uppercase('F' + Prop.Name)) or (lField.Name = 'Fvalue') then
          begin
            for Atrib in Prop.GetAttributes do
            begin
              if Atrib is FieldTable then
              begin
                if (not FieldTable(Atrib).AutoInc) or (WithId) then
                begin
                  Value := GetValueField(E, lField);
                  L.Add(Value);
                  break;
                end;
              end
              else
              if Atrib is NotMapper then
              begin
                  break;
              end;

            end;
          end;//break;
        end;
      end;
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
  lField: TRttiField;
  Value: string;
  L: TStringList;
  Atributo: TCustomAttribute;
  lcClassType : TClass;
begin
  try
    L := TStringList.Create(true);
    for Prop in ctx.GetType(E.ClassType).GetProperties do
    begin
      for lField in ctx.GetType(E.ClassType).GetFields do
      begin
        if uppercase(lField.Name) = uppercase('F' + Prop.Name) then
        begin
          for Atributo in Prop.GetAttributes do
          begin
            if (Atributo is FieldTable) and (FieldTable(Atributo).PrimaryKey)
            then
            begin
              Value := GetValueField(E, lField);
              L.Add(Value);
              break;
            end;
          end;
        end;
        break;/////////////////////////////
      end;
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
      if (Atributo is Table) then
      begin
        strTables := Table(Atributo).Name;
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
      if Atributo is Table then
      begin
        result := Table(Atributo).Name;
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
  dDatetime: TDate;
  TypeClassName: string;
begin
  for Field in ctx.GetType(Entity.ClassType).GetFields do
    if uppercase(Field.Name) = uppercase('F' + Campo) then
    begin
      Val := Field.GetValue(Entity);
      TypeClassName := uppercase(Field.FieldType.ToString);
      if TypeClassName = uppercase(cInteger) then
      begin
        iInteger := Val.AsType<TInteger>;
        if InContext then
           iInteger.SetAs(Valor)
        else
           iInteger.SetValue(strtoint(Valor));
        TValue.Make(@iInteger, TypeInfo(TInteger), Val);
      end
      else if TypeClassName = uppercase(cFloat) then
      begin
        fFloat := Val.AsType<TFloat>;
        if InContext then
           fFloat.SetAs(Valor)
        else
           fFloat.SetValue( strtofloat(Valor));
        TValue.Make(@fFloat, TypeInfo(TFloat), Val);
      end
      else if TypeClassName = uppercase(cString) then
      begin
        sString := Val.AsType<TString>;
        sString.InContext := InContext;
        if InContext then
           sString.SetAs(Valor)
        else
           sString.SetValue(Valor);
        TValue.Make(@sString, TypeInfo(TString), Val);
      end
      else if TypeClassName = uppercase(cDateTime) then
      begin
        dDatetime := Val.AsType<TDate>;
        if InContext then
           dDatetime.SetAs(Valor)
        else
           dDatetime.SetValue(strtodate(Valor));
        TValue.Make(@dDatetime, TypeInfo(TDate), Val);
      end;
      Field.SetValue(Entity, Val );
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
  dDatetime: TDate;
  TypeClassName: string;
begin
  for Field in ctx.GetType(Entity.ClassType).GetFields do
    if uppercase(Field.Name) = uppercase('F' + Campo) then
    begin
      TypeClassName := uppercase(Field.FieldType.ToString);
      Val := Field.GetValue(Entity);
      if TypeClassName = uppercase(cInteger) then
      begin
        iInteger := Val.AsType<TInteger>;
        iInteger.Value := ifthen( not fEmpty(Valor), Valor, 0);
        TValue.Make(@iInteger, TypeInfo(TInteger), Val);
      end
      else if TypeClassName = uppercase(cFloat) then
      begin
        fFloat := Val.AsType<TFloat>;
        fFloat.Value := ifthen( not fEmpty(Valor), Double(Valor), 0);
        TValue.Make(@fFloat, TypeInfo(TFloat), Val);
      end
      else if TypeClassName = uppercase(cString) then
      begin
        sString := Val.AsType<TString>;
        sString.Value := ifthen( fEmpty(Valor) ,'',valor);
        TValue.Make(@sString, TypeInfo(TString), Val);
      end
      else if TypeClassName = uppercase(cDateTime) then
      begin
        dDatetime := Val.AsType<TDate>;
        if not fEmpty(Valor) then
          dDatetime.Value := Valor;
        TValue.Make(@dDatetime, TypeInfo(TDate), Val);
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
  dDatetime: TDate;
  TypeClassName: string;
begin
    TypeClassName := uppercase(Campo.PropertyType.ToString);
    Val := Campo.GetValue(Entity);
    if TypeClassName = uppercase(cInteger) then
    begin
      iInteger := Val.AsType<TInteger>;
      iInteger.Value := ifthen( not fEmpty(Valor), Valor, 0);
      TValue.Make(@iInteger, TypeInfo(TInteger), Val);
    end
    else if TypeClassName = uppercase(cFloat) then
    begin
      fFloat := Val.AsType<TFloat>;
      fFloat.Value := ifthen( not fEmpty(Valor), Double(Valor), 0);
      TValue.Make(@fFloat, TypeInfo(TFloat), Val);
    end
    else if TypeClassName = uppercase(cString) then
    begin
      sString := Val.AsType<TString>;
      sString.Value := ifthen( fEmpty(Valor) ,'',valor);
      TValue.Make(@sString, TypeInfo(TString), Val);
    end
    else if TypeClassName = uppercase(cDateTime) then
    begin
      dDatetime := Val.AsType<TDate>;
      if not fEmpty(Valor) then
        dDatetime.Value := Valor;
      TValue.Make(@dDatetime, TypeInfo(TDate), Val);
    end;
    Campo.SetValue(Entity, Val);
end;

class procedure TAutoMapper.SetFieldValue(Entity: TEntityBase;
  Campo: TRttiProperty; Valor: Tdatetime);
  var
  ctx: TRttiContext;
  Val: TValue;
  dDatetime: TDate;
begin
  dDatetime := Val.AsType<TDate>;
  if not fEmpty(Valor) then
    dDatetime.Value := Valor;
  TValue.Make(@dDatetime, TypeInfo(TDate), Val);
    Campo.SetValue(Entity, Val);
end;

class function TAutoMapper.SetObject(Entity: TEntityBase; ClassName: string;
  Value: TObject):TObject;
var
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  ctx: TRttiContext;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if ( PropIsInstance(Prop) ) and ( Pos(ClassName , prop.PropertyType.ToString )>0 ) then
      begin
        //SetObjectProp( Entity,Prop.Name, Value )
        Prop.SetValue( Entity ,  Value);
        result:= GetObject(Entity,ClassName);
        break;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetObject(Entity: TEntityBase; ClassName: string):TObject;
var
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  ctx: TRttiContext;
begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if ( PropIsInstance(Prop) ) and ( prop.PropertyType.ToString = ClassName ) then
      begin
        result:= prop.GetValue(Entity).AsObject;
        break;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.ToMapping(Entity: TEntityBase;
  InContext: boolean; Quoted :boolean ): boolean;
var
  ctx: TRttiContext;
  RTTI: TRttiType;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  Found:boolean;
  CharQuoted: string;
begin
  try
    result := false;
    ctx := TRttiContext.Create;
    RTTI := ctx.GetType(Entity.ClassInfo);
    if Quoted then
      CharQuoted:= '"';

    for Prop in RTTI.GetProperties do
    begin
      Found:= false;
      if not PropIsInstance(Prop) then
      begin
        for Atrib in Prop.GetAttributes do
        begin
          try
            if Atrib is FieldTable then
            begin
              Found := true;

              TAutoMapper.SetAtribute(Entity, Prop.Name,
               CharQuoted+ UpperCase( TAutoMapper.GetTableAttribute(Entity.ClassType) ) + CharQuoted + '.' +
               CharQuoted+ FieldTable(Atrib).Name + CharQuoted, InContext);
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
                 CharQuoted+ UpperCase(TAutoMapper.GetTableAttribute(Entity.ClassType))+CharQuoted + '.' +
                 CharQuoted+ Prop.Name+CharQuoted, InContext);
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
  Instance:TObject;
begin
  try
    ctx := TRttiContext.Create;
    breaked:= false;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if PropIsInstance(Prop) then
      begin
         Instance := GetObjectProp( Entity ,Prop.Name);
         if Instance <> nil then
         begin
           breaked:= false;
           for Atrib in Prop.GetAttributes do
           begin
              if (Atrib is NotMapper) then
              begin
                 breaked:= true;
                 break;
              end
           end;
           if not breaked then
              DataToEntity( DataSet, Instance as TEntityBase );
         end;
      end
      else
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is FieldTable then
          begin
            if DataSet.FindField(FieldTable(Atrib).Name) <> nil then
            begin
              SetFieldValue(Entity, Prop,
                            DataSet.Fieldbyname(FieldTable(Atrib).Name).AsVariant);
              breaked:= true;
              break;
            end;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TAutoMapper.DataToEntity(DataSet: TDataSet; Entity: TObject);
var
  J: integer;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  ctx: TRttiContext;
  breaked:boolean;
  Instance: TObject;
begin
  try
    ctx := TRttiContext.Create;
    breaked:= false;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if PropIsInstance(Prop) then
      begin
         Instance:= GetObjectProp( Entity ,Prop.Name);
         if instance <> nil then
         begin
           breaked:= false;
           for Atrib in Prop.GetAttributes do
           begin
              if (Atrib is NotMapper) then
              begin
                 breaked:= true;
                 break;
              end
           end;
           if not breaked then
              DataToEntity( DataSet, instance as TEntityBase );
         end;
      end
      else
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is FieldTable then
          begin
            if DataSet.FindField(FieldTable(Atrib).Name) <> nil then
            begin
              SetFieldValue( Entity  as TEntityBase , Prop,
                            DataSet.Fieldbyname(FieldTable(Atrib).Name).AsVariant);
              breaked:= true;
              break;
            end;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class function TAutoMapper.GetInstance<T>(const Str_Class: TValue): T;
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
          Erro := Str_Class.AsString + ' Classe N�o encontrada';
          instancia := (C.FindType(Str_Class.AsString) as TRttiInstanceType);
          result := T(instancia.MetaclassType.Create);
      end;
      tkClassRef:
      begin
          Erro := 'O par�metro passado deve ser do tipo Tclass' + sLineBreak;
          p := C.GetType(Str_Class.AsClass);
          instancia := (C.FindType(p.QualifiedName) as TRttiInstanceType);
          result := T(instancia.MetaclassType.Create);
      end;
      else
      begin
          Erro := 'O par�metro passado n�o � v�lidado para a fun��o' + sLineBreak;
          abort;
      end;
    end;
  except
    raise Exception.Create(Erro);
  end;
end;

class function TAutoMapper.GetInstance2(const Str_Class: TValue): TObject;
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
          Erro := Str_Class.AsString + ' Classe N�o encontrada';
          instancia := (C.FindType(Str_Class.AsString) as TRttiInstanceType);
          result := (instancia.MetaclassType.Create);
      end;
      tkClassRef:
      begin
          Erro := 'O par�metro passado deve ser do tipo Tclass' + sLineBreak;
          p := C.GetType(Str_Class.AsClass);
          instancia := (C.FindType(p.QualifiedName) as TRttiInstanceType);
          result := (instancia.MetaclassType.Create);
      end;
      else
      begin
          Erro := 'O par�metro passado n�o � v�lidado para a fun��o' + sLineBreak;
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

class procedure TAutoMapper.CreateDinamicView(Entity: TEntityBase; Form: TForm;Parent:TWinControl = nil);
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

  i,c, altura, MaxLength: integer;

  procedure CreateLabel(Name: string;cont:integer; top:integer);
  begin
    Labels[cont] := TLabel.Create(Form);
    if Parent = nil then
       Labels[cont].Parent := Form
    else
       Labels[cont].Parent := Parent;
    Labels[cont].Left := 40;
    Labels[cont].Top := top;
    Labels[cont].Width := 50;
    Labels[cont].Height := 13;
    Labels[cont].Caption := Name;
  end;

  procedure CreateEdit(Name: string; cont:integer; top:integer; IsNumeric:boolean; MaxLength:integer);
  begin
    Edits[cont] := TEdit.Create(Form);
    if Parent = nil then
       Edits[cont].Parent := Form
    else
       Edits[cont].Parent := Parent;

    Edits[cont].Left := 40;
    Edits[cont].Top := top;
    Edits[cont].Width := 100;
    Edits[cont].Height := 21;
    Edits[cont].TabOrder := cont;
    Edits[cont].NumbersOnly :=  IsNumeric;
    Edits[cont].Name:= name;
    if MaxLength > 0 then
       Edits[cont].MaxLength := MaxLength;
  end;

  procedure CreateCheckBox(Name: string; cont:integer; top:integer);
  begin
    Checks[cont] := TCheckBox.Create(Form);
    if Parent = nil then
       Checks[cont].Parent := Form
    else
       Checks[cont].Parent := Parent;
    Checks[cont].Left := 40;
    Checks[cont].Top := top;
    Checks[cont].Width := 100;
    Checks[cont].Height := 21;
    Checks[cont].TabOrder := cont;
    Checks[cont].Caption := Name;
    Checks[cont].Name:= 'chk'+name;
  end;

  procedure CreateMemo(Name: string; cont:integer; top:integer);
  begin
    Memos[cont] := TMemo.Create(Form);
    if Parent = nil then
       Memos[cont].Parent := Form
    else
       Memos[cont].Parent := Parent;
    Memos[cont].Left := 40;
    Memos[cont].Top := top;
    Memos[cont].TabOrder := cont;
    Memos[cont].Name:= 'memo'+name;
  end;

  procedure CreateDatetimePick(Name: string; cont:integer; top:integer);
  begin
    Dates[cont] := TDateTimePicker.Create(Form);
    if Parent = nil then
       Dates[cont].Parent := Form
    else
       Dates[cont].Parent := Parent;
    Dates[cont].Left := 40;
    Dates[cont].Top := top;
    Dates[cont].Width := 100;
    Dates[cont].Height := 21;
    Dates[cont].TabOrder := cont;
    Dates[cont].Name:= 'date'+name;
  end;

  procedure CreateCombobox(Name: string; cont:integer; top:integer);
  begin
    Combos[cont] := TCombobox.Create(Form);
    if Parent = nil then
       Combos[cont].Parent := Form
    else
       Combos[cont].Parent := Parent;
    Combos[cont].Left := 40;
    Combos[cont].Top := top;
    Combos[cont].Width := 100;
    Combos[cont].Height := 21;
    Combos[cont].TabOrder := cont;
    Combos[cont].Name:= 'cbo'+name;
  end;

  procedure CreateLookUpCombobox(Name: string; cont:integer; top:integer);
  begin
    LookUpCombos[cont] := TDBLookUpCombobox.Create(Form);
    if Parent = nil then
       LookUpCombos[cont].Parent := Form
    else
       LookUpCombos[cont].Parent := Parent;
    LookUpCombos[cont].Left := 40;
    LookUpCombos[cont].Top := top;
    LookUpCombos[cont].Width := 100;
    LookUpCombos[cont].Height := 21;
    LookUpCombos[cont].TabOrder := cont;
    LookUpCombos[cont].Name:= 'cbo'+name;
  end;

begin
  try
    ctx := TRttiContext.Create;
    TypObj := ctx.GetType(Entity.ClassInfo);

    altura := 10;
    for Prop in TypObj.GetProperties do
    begin
       if (not PropIsInstance(prop)) and (PropIsVisible(prop)) then
       begin
          c := 0;
          for Atrib in Prop.GetAttributes do
          begin
            if Atrib is Edit then
            begin
              CreateLabel(prop.name, c, altura);
              Altura := altura + 15;
              MaxLength:=  GetMaxLengthValue(Entity, prop.name) ;
              MaxLength:= 0;
              CreateEdit( prop.name, c, altura, (PropIsInteger(prop)) and(PropIsFloat(prop)) , MaxLength );
              inc(c);
              break;
            end
            else
            if Atrib is CheckBox then
            begin
              Altura := altura + 15;
              CreateCheckBox( prop.name, c, altura);
              inc(c);
              break;
            end
            else
            if Atrib is Memo then
            begin
              CreateLabel(prop.name, c, altura);
              Altura := altura + 15;
              CreateMemo( prop.name, c, altura);
              inc(c);
              break;
            end
            else
            if Atrib is  DateTimePicker then
            begin
              CreateLabel(prop.name, c, altura);
              Altura := altura + 15;
              CreateDateTimePick( prop.name, c, altura);
              inc(c);
              break;
            end
            else
            if Atrib is  Combobox then
            begin
              CreateLabel(prop.name, c, altura);
              Altura := altura + 15;
              CreateCombobox( prop.name, c, altura);
              inc(c);
              break;
            end
            else
            if Atrib is  LookupCombobox then
            begin
              CreateLabel(prop.name, c, altura);
              Altura := altura + 15;
              CreateLookupCombobox( prop.name, c, altura);
              inc(c);
              break;
            end;

          end;
          Altura := altura + 23;

       end;
     end;
  finally
    ctx.Free;
  end;

end;


class procedure  TAutoMapper.JsonObjectToObject<T>(Json:TJSOnObject; O:T);
var
  L:TStringList;
  I:integer;
  Name: string;
  jsonName: string;
  value:Variant;
begin
   L := TAutoMapper.GetFieldsList(O.ClassInfo);
   for I := 0 to L.Count - 1 do
   begin
      try
          Name := L.Strings[I];
          TAutoMapper.SetFieldValue( O, Name , json.Values[lowercase(Name)].Value );
      except
          try
              jsonName:= lowercase(copy(Name,1,1))+Copy(Name,2,20);
              TAutoMapper.SetFieldValue( O, Name , json.Values[ jsonName ].Value );
          except
              on E:Exception do
              begin
                  if pos('Could not convert variant of type (UnicodeString) into type (Double)',e.Message) > 0 then
                  begin
                     value:= json.Values[ jsonName ].Value;
                     TAutoMapper.SetFieldValue( O, Name , strtodatetime(fFormatDateJson(value)) );
                  end;
              end;
          end;
      end;
   end;
end;



end.

