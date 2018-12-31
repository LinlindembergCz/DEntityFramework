unit RepositoryCliente;

interface

uses
DB, Classes, Repository, classCliente, RepositoryBase, InterfaceRepositoryCliente,
InterfaceRepository,  Context, EntityBase,EntityTypes, EntityFramework;

type
  TRepositoryCliente = class(TRepositoryBase ,IRepositoryCliente)
  private
    _RepositoryCliente:IRepository<TCliente>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: TCliente;
    function LoadPorNome(value: string):TDataSet;
  end;

implementation

{ TRepositoryCliente }

constructor TRepositoryCliente.Create(dbContext:TContext);
begin
  _RepositoryCliente := TRepository<TCliente>.create(dbContext) ;
  _RepositoryBase    := _RepositoryCliente As IRepository<TEntityBase>;
end;

function TRepositoryCliente.GetEntity: TCliente;
begin
  result:= _RepositoryCliente.Entity;
end;

function TRepositoryCliente.LoadPorNome(value: string): TDataSet;
var
  E:TCliente;
begin
  E := (Context.Entity as TCliente);
  result := Context.GetDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select('') );
end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
