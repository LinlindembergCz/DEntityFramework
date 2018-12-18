unit Email;

interface

uses
   EntityTypes, SysUtils, Dialogs, EntityBase, Atributies;

type
  TEmail = class(TEntityBase)
  private
    Fvalue: TString;
    procedure Setvalue(const Value: TString);
  public
    procedure validar;
  published
   [EntityField('Email','varchar(200)',true)]
    property value: TString read Fvalue write Setvalue;
  end;

implementation

procedure TEmail.Setvalue(const Value: TString);
begin
  Fvalue := Value;
end;

procedure TEmail.validar;
begin
  if trim(FValue.Value) <> '' then
  begin
    if ( Pos( '@',FValue.Value) = -1 ) then
    begin
       raise Exception.Create('Email "'+FValue.Value+'" inválido!');
    end;
  end;
end;

end.
