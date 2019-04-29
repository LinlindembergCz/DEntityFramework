unit Service.Utils.DataBind;

interface

uses
 System.Classes, RTTI, System.TypInfo,Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, SysUtils, DB,
  EF.Mapping.Base;

type
  TDataBind = class
  private
    class function ValidComponent(Comp: TComponent): boolean; static;
    class procedure DataToEntity(DataSet: TDataSet; Entity: TEntityBase); static;
  public
    class function Map(Component: TComponent; Entity: TObject;
      Valued: boolean= false): TObject;

    class procedure Read(Component: TComponent; Entity: TEntityBase;
      SetDefaultValue: boolean; DataSet: TDataSet = nil); static;
  end;

implementation

uses
  Vcl.Mask, EF.Mapping.Atributes, EF.Mapping.AutoMapper;

function PropNameEqualComponentName( Prop: TRttiProperty; Component: TComponent):boolean;
begin
  result:= Prop.Name = copy(Component.Name, Pos(Prop.Name, Component.Name), length(Component.Name));
end;

class function TDataBind.Map(Component: TComponent; Entity: TObject;Valued: boolean = false): TObject;

    function PropIsInstance( Prop: TRttiProperty):boolean;
    begin
      result:= ( Prop.PropertyType.IsInstance) and
               ( Prop.Name <> 'PropertyType' ) and
               ( Prop.Name <> 'Parent' )       and
               ( Prop.Name <> 'Package' );
    end;

    function SetValueProp(Component:TComponent; Prop: TRttiProperty; Entity: TObject):boolean;
    var
      Value: variant;
      ListField:string;
      TextListField: string;
      ItemIndex: integer;
      TypeClassName: string;
    begin
        if Component.InheritsFrom(TCustomMemo) then
        begin
            Value := TMemo(Component).Text
        end
        else
        if (Component.InheritsFrom(TCustomEdit)) then
        begin
            Value := TEdit(Component).Text
        end
        else
        if (Component.InheritsFrom(TCustomDBLookupComboBox)) then
        begin
            Value         := TDBLookUpCombobox(Component).KeyValue;
            ListField     := TDBLookUpCombobox(Component).ListField;
            TextListField := TDBLookUpCombobox(Component).text;
        end
        else
        if Component.InheritsFrom(TCustomCombobox) then
        begin
          Value := TCombobox(Component).Items.ValueFromIndex[ TCombobox(Component).Items.IndexOf(TCombobox(Component).Text) ];
        end
        else if Component.InheritsFrom(TCommonCalendar) then
            Value := TDateTimePicker(Component).Datetime
        else
        if Component.InheritsFrom(TCustomRadioGroup) then
        begin
          ItemIndex := (Component as TRadioGroup).ItemIndex;
          Value := TRadioGroup(Component).Items.ValueFromIndex[ ItemIndex ];
        end
        else
        if Component.InheritsFrom(TCustomCheckBox) then
        begin
          if (Component as TCheckBox).Checked then
            Value := '1'
          else
            Value := '0';
        end;

        TypeClassName := uppercase(Prop.PropertyType.ToString);
        if TypeClassName = uppercase('Integer') then
           Prop.SetValue(Entity,TValue.From<integer>(Value) )
        else
        if TypeClassName = uppercase('String') then
           Prop.SetValue(Entity,TValue.From<string>(Value) )
        else
        if TypeClassName = uppercase('Double') then
           Prop.SetValue(Entity,TValue.From<Double>(Value) )
        else
        if TypeClassName = uppercase('TDateTime') then
           Prop.SetValue(Entity,TValue.From<TDateTime>(Value) );

        result:= true;
    end;
var
  Prop: TRttiProperty;
  ComponentControl: TComponent;
  ctx: TRttiContext;
  TypObj: TRttiType;
  i :integer;
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
          if SetValueProp(Component,Prop, Entity ) then
             break;
        end;
      end
      else
      for i:= 0 to Component.componentcount - 1 do
      begin
        ComponentControl := Component.components[i];
        if PropNameEqualComponentName( Prop, ComponentControl) then
        begin
          if not PropIsInstance(prop)  then
          begin
            if SetValueProp(ComponentControl,Prop, Entity ) then
               break;
          end
          else
          begin
            Map( ComponentControl , GetObjectProp(Entity,Prop.Name), true );
          end;
        end;
      end;
    end;
  finally
    result:= Entity;
    ctx.Free;
  end;
end;

class function TDataBind.ValidComponent( Comp:TComponent):boolean;
begin
   result := ( Comp.InheritsFrom(TCustomEdit) ) or
             ( Comp.InheritsFrom(TCustomCombobox) ) or
             ( Comp.InheritsFrom(TCustomDBLookupComboBox) ) or
             ( Comp.InheritsFrom(TCustomCheckBox) ) or
             ( Comp.InheritsFrom(TCustomMemo) ) or
             ( Comp.InheritsFrom(TCustomRadioGroup) ) or
             ( Comp.InheritsFrom(TCommonCalendar) );
end;

class procedure TDataBind.Read(Component: TComponent; Entity: TEntityBase;
  SetDefaultValue: boolean; DataSet :TDataSet = nil);

var
  J: integer;
  Prop: TRttiProperty;
  Componente: TComponent;
  ctx: TRttiContext;
  Value: string;
  breaked:boolean;
  Atributo: TCustomAttribute;
  TypObj: TRttiType;

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
    ValueItem: string;
    IndexOf: integer;
    lsText, lsValue: string;

  begin
    IndexOf := -1;
    for Atrib in Prop.GetAttributes do
    begin
      if Atrib is EntityItems then
      begin
        if TCombobox(Componente).Items.Count = 0 then
        begin
          for i := 0 to EntityItems(Atrib).Items.Count - 1 do
          begin
              ValueItem := EntityItems(Atrib).Items.Strings[i];
              lsText := copy(ValueItem, Pos('=', ValueItem) + 1,length(ValueItem));
              lsValue := copy(ValueItem, 1, Pos('=', ValueItem) - 1);
              if (Componente as TCombobox).Items.Values[lsText] = '' then
                 TCombobox(Componente).Items.AddPair( lsText, lsValue );
              if Value = lsValue then
                 IndexOf:= i;
          end;
          //EntityItems(Atrib).Items.Free;
          //EntityItems(Atrib).Items := nil;
        end;
      end;
    end;
    if IndexOf > - 1 then
    begin
       TCombobox(Componente).ItemIndex := IndexOf;
    end
    else
    for I := 0 to TCombobox(Componente).Items.Count - 1 do
    begin
      if (Value =  TCombobox(Componente).Items.ValueFromIndex[i]) then
      begin
         TCombobox(Componente).ItemIndex := i;
         break;
      end;
    end;
  end;

  procedure SetValueRadioGroup;
  var
    Atrib: TCustomAttribute;
    i: integer;
    ValueItem: string;
    IndexOf: integer;
    lsText, lsValue: string;
  begin
    IndexOf := -1;
    for Atrib in Prop.GetAttributes do
    begin
      if Atrib is EntityItems then
      begin
        if TRadioGroup(Componente).Items.Count = 0 then
        begin
          for i := 0 to EntityItems(Atrib).Items.Count - 1 do
          begin
              ValueItem := EntityItems(Atrib).Items.Strings[i];
              lsText := copy(ValueItem, Pos('=', ValueItem) + 1,
                length(ValueItem));
              lsValue := copy(ValueItem, 1, Pos('=', ValueItem) - 1);
              if (Componente as TRadioGroup).Items.Values[lsText] = '' then
                 TRadioGroup(Componente).Items.AddPair( lsText, lsValue );
              if (Value = lsValue) then
                IndexOf := i;
          end;
         // EntityItems(Atrib).Items.Free;
         // EntityItems(Atrib).Items := nil;
        end;
      end;
    end;
    if IndexOf > - 1 then
    begin
        TRadioGroup(Componente).ItemIndex := IndexOf;
    end
    else
    for I := 0 to TRadioGroup(Componente).Items.Count - 1 do
    begin
        if (Value =  TRadioGroup(Componente).Items.ValueFromIndex[i]) then
        begin
          TRadioGroup(Componente).ItemIndex := i;
          break;
        end;
    end;
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
            if TAutoMapper.PropIsInstance(prop)  then
            begin
               breaked:= false;
               for Atributo in Prop.GetAttributes do
               begin
                  if (Atributo is NotMapper) then
                  begin
                     breaked:= true;
                     break;
                  end
               end;
               if not breaked then
                  Value := TAutoMapper.GetValueProperty( GetObjectProp( Entity ,Prop.Name) as TEntityBase , 'value' )
            end
            else
            if SetDefaultValue then
              Value := TAutoMapper.GetDafaultValue(Entity, Prop.Name)
            else
              Value := TAutoMapper.GetValueProperty(Entity, Prop.Name);

            if Componente.InheritsFrom(TCustomMemo) then
              SetValueMemo( TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) )
              else
            if Componente.InheritsFrom(TCustomCombobox) then
              SetValueCombobox
              else
            if Componente.InheritsFrom(TCustomDBLookupComboBox) then
              setValueDBLookUpCombobox
              else
            if Componente.InheritsFrom(TCommonCalendar) then
              SetValueDateTimePicker
              else
            if Componente.InheritsFrom(TCustomCheckBox) then
              SetValueCheckBox
              else
            if Componente.InheritsFrom(TCustomLabel) then
              SetValueLabel
              else
            if Componente.InheritsFrom(TCustomRadioGroup) then
              SetValueRadioGroup
              else
            if Componente.InheritsFrom(TCustomMaskEdit) then
              SetValueMaskEdit( TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) )
              else
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

class procedure TDataBind.DataToEntity(DataSet: TDataSet; Entity: TEntityBase);
var
  J: integer;
  Prop: TRttiProperty;
  Atrib: TCustomAttribute;
  ctx: TRttiContext;
  breaked:boolean;
  TypObj: TRttiType;
begin
  try
    ctx := TRttiContext.Create;
    breaked:= false;
    TypObj := ctx.GetType(Entity.ClassInfo);
    for Prop in TypObj.GetProperties do
    begin
      if TAutoMapper.PropIsInstance(Prop) then
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
            TAutoMapper.DataToEntity( DataSet, GetObjectProp( Entity ,Prop.Name) as TEntityBase );
      end
      else
      begin
        for Atrib in Prop.GetAttributes do
        begin
          if Atrib is EntityField then
          begin
            if DataSet.FindField(EntityField(Atrib).Name) <> nil then
            begin
              TAutoMapper.SetFieldValue(Entity, Prop,
                            DataSet.Fieldbyname(EntityField(Atrib).Name).AsVariant);
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

end.
