unit Repositorio.Cliente;

interface

uses
 System.SysUtils, DB, Classes, Repositorio.GenericRepository, Domain.Entity.Cliente, Repositorio.Base,
Repositorio.Interfaces.Cliente,System.Generics.Collections,
Repositorio.Interfaces.base,  Context, EF.Core.Types, EF.Engine.DataContext;

type
  TRepositoryCliente<T:TCliente> = class(TRepositoryBase<T> ,IRepositoryCliente<T>)
  private
     E: T;
    _RepositoryCliente:IRepository<T>;
  public
    Constructor Create(dbContext:TContext<T>);override;
    function LoadDataSetPorNome(value: string):TDataSet;
    function LoadDataSetPorID(value: string):TDataSet;
  end;

  TRepositoryCliente = class sealed (TRepositoryCliente<TCliente>)
  end;

implementation

{ TRepositoryCliente }

constructor TRepositoryCliente<T>.Create(dbContext:TContext<T>);
begin
  _RepositoryCliente := TRepository<T>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<T>;
  inherited;
  E := _RepositoryCliente.Entity;
end;

function TRepositoryCliente<T>.LoadDataSetPorID(value: string): TDataSet;
begin
   if value <> ''  then
      result := dbContext.ToDataSet( From( E ).Where( E.ID = strtoint(value) ).Select )
   else
   result := dbContext.ToDataSet( From( E ).Select );
end;

function TRepositoryCliente<T>.LoadDataSetPorNome(value: string): TDataSet;
begin
   if value <> ''  then
      result := dbContext.ToDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select )
   else
      result := dbContext.ToDataSet( From( E ).Select );

end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
