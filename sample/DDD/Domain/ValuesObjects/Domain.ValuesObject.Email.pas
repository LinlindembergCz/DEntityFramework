unit Domain.ValuesObject.Email;

interface

uses
   EF.Core.Types, SysUtils, Dialogs,  EF.Mapping.Base, EF.Mapping.Atributes;

type
  TEmail = class(TEntityBase)
  private
    Fvalue: TString;
    procedure Setvalue(const Value: TString);
  public
    procedure validar;
  published
   [Column('Email','varchar(200)',true)]
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
