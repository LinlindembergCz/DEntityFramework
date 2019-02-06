unit RepositoryCliente;

interface

uses
DB, Classes, Repository, classCliente, RepositoryBase, InterfaceRepositoryCliente,
InterfaceRepository,  Context, EF.Mapping.Base,EF.Core.Types, EF.Engine.DataContext;

type
  TRepositoryCliente = class(TRepositoryBase ,IRepositoryCliente)
  private
    _RepositoryCliente:IRepository<TCliente>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: TCliente;
    function LoadDataSetPorNome(value: string):TDataSet;
  end;

implementation

{ TRepositoryCliente }

constructor TRepositoryCliente.Create(dbContext:TContext);
begin
  _RepositoryCliente := TRepository<TCliente>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<TEntityBase>;
  inherited;
end;

function TRepositoryCliente.GetEntity: TCliente;
begin
  result:= _RepositoryCliente.Entity;
end;

function TRepositoryCliente.LoadDataSetPorNome(value: string): TDataSet;
var
  E:TCliente;
begin
  E := GetEntity;
  result := Context.GetDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select );
end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
