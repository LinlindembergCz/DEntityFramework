unit FactoryEntity;

interface

uses
  Sysutils,  EntityBase;

type
  TFactoryEntity = class
  private

  public
    class function GetEntity(E: string): TEntityBase;
  end;

implementation

{ TFactoryEntity }

uses  AutoMapper;

class function TFactoryEntity.GetEntity(E: string ):TEntityBase;
var
  Instance:TObject;
begin
    result := TEntityBase( TAutoMapper.GetInstance( 'class'+E+'.T'+E )).Create;
end;

end.
