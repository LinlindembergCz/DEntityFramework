unit FactoryEntity;

interface

uses
  Sysutils,  EF.Mapping.Base;

type
  TFactoryEntity = class
  private

  public
    class function GetEntity(E: string): TEntityBase;
  end;

implementation

{ TFactoryEntity }

uses  EF.Mapping.AutoMapper;

class function TFactoryEntity.GetEntity(E: string ):TEntityBase;
var
  Instance:TObject;
begin
    result := TEntityBase( TAutoMapper.GetInstance( 'Class'+E+'.T'+E )).Create;
end;

end.
