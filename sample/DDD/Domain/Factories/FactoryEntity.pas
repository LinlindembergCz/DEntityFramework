unit FactoryEntity;

interface

uses
  Sysutils,  EF.Mapping.Base;

type
  TFactoryEntity<T:TEntityBase> = class
  private

  public
    class function GetEntity: T;
  end;

implementation

{ TFactoryEntity }

uses  EF.Mapping.AutoMapper;

class function TFactoryEntity<T>.GetEntity:T;
begin
  result := T.Create;//TEntityBase( TAutoMapper.GetInstance2( 'Domain.Entity.'+E+'.T'+E ) ).Create;
end;

end.
