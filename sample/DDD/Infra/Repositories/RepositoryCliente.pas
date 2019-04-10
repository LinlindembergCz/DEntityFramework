unit RepositoryCliente;

interface

uses
DB, Classes, Repository, classCliente, RepositoryBase, InterfaceRepositoryCliente,
InterfaceRepository,  Context, EF.Mapping.Base,EF.Core.Types, EF.Engine.DataContext;

type
  TRepositoryCliente<T:TCliente> = class(TRepositoryBase<T> ,IRepositoryCliente<T>)
  private
    _RepositoryCliente:IRepository<T>;
  public
    Constructor Create(dbContext:TContext);override;
    function LoadDataSetPorNome(value: string):TDataSet;
  end;

   TRepositoryCliente = class sealed (TRepositoryCliente<TCliente>)
   end;

implementation

uses
  Vcl.Dialogs;

{ TRepositoryCliente }

constructor TRepositoryCliente<T>.Create(dbContext:TContext);
begin
  _RepositoryCliente := TRepository<T>.create(dbContext);
  _RepositoryBase    := _RepositoryCliente As IRepository<T>;
  inherited;
end;

function TRepositoryCliente<T>.LoadDataSetPorNome(value: string): TDataSet;
var
  E:TCliente;
begin
  E := _RepositoryCliente.Entity;
  {
  showmessage( Context.Include( E ).
                       Include( E.Contados.list ).
                       FirstOrDefault( E.Nome.Contains( value )).
                       ToJson );
  }

  result := Context.GetDataSet( From( E ).Where( E.Nome.Contains( value ) ).Select );
end;

initialization RegisterClass(TRepositoryCliente);
finalization UnRegisterClass(TRepositoryCliente);

end.
