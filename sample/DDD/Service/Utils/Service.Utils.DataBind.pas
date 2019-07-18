unit Service.Utils.DataBind;

interface

uses
 System.Classes, RTTI, System.TypInfo,Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, SysUtils, DB,
  EF.Mapping.Base, FireDAC.Comp.Client;

type
  IDataBind = interface
  ['{2388D1DF-FA78-4EAC-8C97-600A89B71526}']
     function Map(Component: TComponent; Entity: TObject; Valued: boolean= false): TObject;
     procedure Read(Component: TComponent; dbSet:TFDQuery; Entity:TEntityBase; SetDefaultValue: boolean  );
  end;


  TVLCDataBind = class(TInterfacedObject,IDataBind )
  strict private
    procedure SetValueCheckBox(Component: TComponent; Value: variant);
    procedure SetValueCombobox(Component: TComponent; Value: variant;Prop: TRttiProperty);
    procedure SetValueDateTimePicker(Component: TComponent;
      Value: variant);
    procedure SetValueDBLookUpCombobox(Component: TComponent;
      Value: variant);
    procedure SetValueEdit(Component: TComponent; Value: variant;
      MaxLength: integer=0);
    procedure SetValueLabel(Component: TComponent; Value: variant);
    procedure SetValueMaskEdit(Component: TComponent; Value: variant;
      MaxLength: integer =0 );
    procedure SetValueMemo(Component: TComponent; Value: variant;
      MaxLength: integer =0);
    procedure SetValueRadioGroup(Component: TComponent; Value: variant;
      Prop: TRttiProperty);
  private
     function ValidComponent(Comp: TComponent): boolean;
     procedure DataToEntity(DataSet: TDataSet; Entity: TEntityBase);
     function GetValueComponent(Component: TComponent): variant;
     procedure SetValueComponent(Component: TComponent;Entity: TEntityBase;
                                      Value:variant; Prop: TRttiProperty);
  public
    function Map(Component: TComponent; Entity: TObject;
      Valued: boolean= false): TObject;
    procedure Read(Component: TComponent; dbSet:TFDQuery; Entity:TEntityBase;  SetDefaultValue: boolean );
  end;

implementation

uses
  Vcl.Mask, EF.Mapping.Atributes, EF.Mapping.AutoMapper;

function PropNameEqualComponentName( Prop: TRttiProperty; Component: TComponent):boolean;
begin
  result:= Prop.Name = copy(Component.Name, Pos(Prop.Name, Component.Name), length(Component.Name));
end;

function TVLCDataBind.GetValueComponent(Component: TComponent):variant;
var
  Value: variant;
  ListField:string;
  TextListField: string;
  ItemIndex: integer;
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
  result:= Value;
end;

procedure TVLCDataBind.SetValueComponent(Component: TComponent;Entity: TEntityBase; Value:variant; Prop: TRttiProperty);
begin
  if Component.InheritsFrom(TCustomMemo) then
     SetValueMemo( Component, Value,TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) )
    else
  if Component.InheritsFrom(TCustomCombobox) then
    SetValueCombobox( Component, Value, Prop)
    else
  if Component.InheritsFrom(TCustomDBLookupComboBox) then
    setValueDBLookUpCombobox( Component, Value )
    else
  if Component.InheritsFrom(TCommonCalendar) then
    SetValueDateTimePicker( Component, Value)
    else
  if Component.InheritsFrom(TCustomCheckBox) then
    SetValueCheckBox( Component, Value)
    else
  if Component.InheritsFrom(TCustomLabel) then
    SetValueLabel( Component, Value)
    else
  if Component.InheritsFrom(TCustomRadioGroup) then
    SetValueRadioGroup( Component, Value, Prop)
    else
  if Component.InheritsFrom(TCustomMaskEdit) then
    SetValueMaskEdit( Component, Value,TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) )
    else
  if Component.InheritsFrom(TCustomEdit) then
    SetValueEdit( Component, Value, TAutoMapper.GetMaxLengthValue(Entity, Prop.Name) );
end;

procedure TVLCDataBind.SetValueDBLookUpCombobox(Component: TComponent; Value:variant);
begin
  TDBLookUpCombobox(Component).KeyValue := Value;
end;

procedure TVLCDataBind.SetValueDateTimePicker(Component: TComponent; Value:variant);
begin
  if Value <> '' then
    TDateTimePicker(Component ).Datetime := strtodate(Value)
  else
    TDateTimePicker(Component ).Date := Date;
end;

procedure TVLCDataBind.SetValueCheckBox(Component: TComponent; Value:variant);
begin
  TCheckBox(Component ).Checked := strtoIntdef(Value, 0) = 1;//abs(strtofloatdef(Value, 0)) = 1;
end;

procedure TVLCDataBind.SetValueLabel(Component: TComponent; Value:variant);
begin
  TLabel(Component ).caption := Value;
end;

procedure TVLCDataBind.SetValueMemo(Component: TComponent; Value:variant ;MaxLength:integer = 0);
begin
  TMemo(Component).Text := Value;
  if MaxLength > 0 then
     TMemo(Component).MaxLength := MaxLength;
end;

procedure TVLCDataBind.SetValueEdit(Component: TComponent;Value:variant;MaxLength:integer = 0);
begin
  TEdit(Component).Text := Value;
   if MaxLength > 0 then
     TEdit(Component).MaxLength := MaxLength;
end;

procedure TVLCDataBind.SetValueMaskEdit(Component: TComponent; Value:variant ;MaxLength:integer = 0);
begin
  TMaskEdit(Component).Text := Value;
   if MaxLength > 0 then
     TMaskEdit(Component).MaxLength := MaxLength;
end;

procedure TVLCDataBind.SetValueCombobox(Component: TComponent; Value:variant;Prop: TRttiProperty);
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
    if Atrib is Items then
    begin
      if TCombobox(Component).Items.Count = 0 then
      begin
        for i := 0 to Items(Atrib).Items.Count - 1 do
        begin
            ValueItem := Items(Atrib).Items.Strings[i];
            lsText := copy(ValueItem, Pos('=', ValueItem) + 1,length(ValueItem));
            lsValue := copy(ValueItem, 1, Pos('=', ValueItem) - 1);
            if (Component as TCombobox).Items.Values[lsText] = '' then
               TCombobox(Component).Items.AddPair( lsText, lsValue );
            if Value = lsValue then
               IndexOf:= i;
        end;
      end;
    end;
  end;
  if IndexOf > - 1 then
  begin
     TCombobox(Component).ItemIndex := IndexOf;
  end
  else
  for I := 0 to TCombobox(Component).Items.Count - 1 do
  begin
    if (Value =  TCombobox(Component).Items.ValueFromIndex[i]) then
    begin
       TCombobox(Component).ItemIndex := i;
       break;
    end;
  end;
end;

procedure TVLCDataBind.SetValueRadioGroup(Component: TComponent; Value:variant;Prop: TRttiProperty);
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
    if Atrib is items then
    begin
      if TRadioGroup(Component).Items.Count = 0 then
      begin
        for i := 0 to items(Atrib).Items.Count - 1 do
        begin
            ValueItem := items(Atrib).Items.Strings[i];
            lsText := copy(ValueItem, Pos('=', ValueItem) + 1,
              length(ValueItem));
            lsValue := copy(ValueItem, 1, Pos('=', ValueItem) - 1);
            if (Component as TRadioGroup).Items.Values[lsText] = '' then
               TRadioGroup(Component).Items.AddPair( lsText, lsValue );
            if (Value = lsValue) then
              IndexOf := i;
        end;
       // items(Atrib).Items.Free;
       // items(Atrib).Items := nil;
      end;
    end;
  end;
  if IndexOf > - 1 then
  begin
      TRadioGroup(Component).ItemIndex := IndexOf;
  end
  else
  for I := 0 to TRadioGroup(Component).Items.Count - 1 do
  begin
      if (Value =  TRadioGroup(Component).Items.ValueFromIndex[i]) then
      begin
        TRadioGroup(Component).ItemIndex := i;
        break;
      end;
  end;
end;


function TVLCDataBind.ValidComponent( Comp:TComponent):boolean;
begin
   result := ( Comp.InheritsFrom(TCustomEdit) ) or
             ( Comp.InheritsFrom(TCustomCombobox) ) or
             ( Comp.InheritsFrom(TCustomDBLookupComboBox) ) or
             ( Comp.InheritsFrom(TCustomCheckBox) ) or
             ( Comp.InheritsFrom(TCustomMemo) ) or
             ( Comp.InheritsFrom(TCustomRadioGroup) ) or
             ( Comp.InheritsFrom(TCommonCalendar) );
end;

procedure TVLCDataBind.DataToEntity(DataSet: TDataSet; Entity: TEntityBase);
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
            if (Atrib is NotMapped) then
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
          if Atrib is Column then
          begin
            if DataSet.FindField(Column(Atrib).Name) <> nil then
            begin
              TAutoMapper.SetFieldValue(Entity, Prop,
                            DataSet.Fieldbyname(Column(Atrib).Name).AsVariant);
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


function TVLCDataBind.Map(Component: TComponent; Entity: TObject;Valued: boolean = false): TObject;

    function SetValueProp(Component:TComponent; Prop: TRttiProperty; Entity: TObject):boolean;
    var
      Value: variant;

      TypeClassName: string;
    begin
        Value:= GetValueComponent(Component);

        TypeClassName := uppercase(Prop.PropertyType.ToString);
        if TypeClassName = uppercase('Integer') then
           Prop.SetValue( Entity,TValue.From<integer>(Value) )
        else
        if TypeClassName = uppercase('String') then
           Prop.SetValue( Entity,TValue.From<string>(Value) )
        else
        if TypeClassName = uppercase('Double') then
           Prop.SetValue( Entity,TValue.From<Double>(Value) )
        else
        if TypeClassName = uppercase('TDateTime') then
           Prop.SetValue( Entity,TValue.From<TDateTime>(Value) );

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
          if not TAutoMapper.PropIsInstance(prop)  then
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

procedure TVLCDataBind.Read(Component: TComponent; dbSet:TFDQuery; Entity:TEntityBase;  SetDefaultValue: boolean);

var
  J: integer;
  Prop: TRttiProperty;
  Componente: TComponent;
  ctx: TRttiContext;
  Value: string;
  breaked:boolean;
  Atributo: TCustomAttribute;
  TypObj: TRttiType;
begin
  try
    if (dbSet <> nil) and (not dbSet.IsEmpty ) then
       DataToEntity( dbSet, Entity);

    ctx := TRttiContext.Create;
    for J := 0 to Component.componentcount - 1 do
    begin
      Componente := Component.components[J];
      if ValidComponent(Componente) then
      begin
        TypObj := ctx.GetType( Entity.ClassInfo);
        for Prop in TypObj.GetProperties do
        begin
          if PropNameEqualComponentName(Prop,Componente ) then
          begin
            if TAutoMapper.PropIsInstance(prop)  then
            begin
               breaked:= false;
               for Atributo in Prop.GetAttributes do
               begin
                  if (Atributo is NotMapped) then
                  begin
                     breaked:= true;
                     break;
                  end
               end;
               if not breaked then
                  Value := TAutoMapper.GetValueProperty( GetObjectProp(Entity ,Prop.Name) as TEntityBase , 'value' )
            end
            else
            if SetDefaultValue then
              Value := TAutoMapper.GetDafaultValue(Entity, Prop.Name)
            else
              Value := TAutoMapper.GetValueProperty(Entity, Prop.Name);

            SetValueComponent(Componente, Entity,Value, Prop);
            break;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;



end.
