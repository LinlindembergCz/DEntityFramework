unit RepositoryContato;

interface

uses
  DB, Classes, Repository, classContato, RepositoryBase,
  InterfaceRepositoryContato,
  InterfaceRepository,  Context, EF.Mapping.Base,EF.Core.Types, EF.Engine.DataContext,
  System.Generics.Collections;

type
  TRepositoryContato = class(TRepositoryBase ,IRepositoryContato)
  protected
    _RepositoryContato:IRepository<TContato>;
  public
    Constructor Create(dbContext:TContext);override;
    function GetEntity: TContato;
    function LoadContatos(ClienteId: Integer): TList<TContato>;
    //function LoadDataSet(iId:Integer; Fields: string = ''): TDataSet;override;
  end;

implementation

{ TRepositoryCliente }

uses FactoryEntity;

constructor TRepositoryContato.Create(dbContext:TContext);
begin
  _RepositoryContato := TRepository<TContato>.create(dbContext);
  _RepositoryBase    := _RepositoryContato As IRepository<TEntityBase>;
  inherited;
end;

function TRepositoryContato.GetEntity: TContato;
begin
  result:= _RepositoryContato.Entity;
end;

function TRepositoryContato.LoadContatos(ClienteId: Integer): TList<TContato>;
var
  c: TContato;
begin
  c := _RepositoryContato.Entity;
  result:= Context.GetList<TContato>( From( c ).Where( c.ClienteId = ClienteId ).Select );
end;

initialization RegisterClass(TRepositoryContato);
finalization UnRegisterClass(TRepositoryContato);

end.
