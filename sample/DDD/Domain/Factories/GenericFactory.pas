unit GenericFactory;

interface

uses RTTI, SysUtils;

type
  TGenericFactory = class
    class function CreateInstance<T>: T;
  end;

implementation

uses
  System.TypInfo;

class function TGenericFactory.CreateInstance<T>: T;
var
  AValue: TValue;
  ctx: TRttiContext;
  rType: TRttiType;
  AMethCreate: TRttiMethod;
  instanceType: TRttiInstanceType;
begin
  try
    ctx := TRttiContext.Create;
    rType := ctx.GetType(TypeInfo(T));
    for AMethCreate in rType.GetMethods do
    begin
      if (AMethCreate.IsConstructor) and (Length(AMethCreate.GetParameters) = 0) then
      begin
        instanceType := rType.AsInstance;

        AValue := AMethCreate.Invoke(instanceType.MetaclassType, []);

        Result := AValue.AsType<T>;

        Exit;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

end.
