unit UI.Utils.DataBind;

interface

uses
 System.Classes, RTTI, System.TypInfo,Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, SysUtils;

type
  TDataBind = class

  public
    class function Put(Component: TComponent; Entity: TObject;
      Valued: boolean= false): TObject;
  end;

implementation

class function TDataBind.Put(Component: TComponent; Entity: TObject;Valued: boolean = false): TObject;

    function PropNameEqualComponentName( Prop: TRttiProperty; Component: TComponent):boolean;
    begin
      result:= Prop.Name = copy(Component.Name, Pos(Prop.Name, Component.Name), length(Component.Name));
    end;

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
            put( ComponentControl , GetObjectProp(Entity,Prop.Name), true );
          end;
        end;
      end;
    end;
  finally
    result:= Entity;
    ctx.Free;
  end;
end;

end.
