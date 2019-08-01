unit EF.QueryAble.Linq;

interface

uses
  EF.QueryAble.Base, EF.QueryAble.Interfaces, EF.Mapping.Base;

  function From(E: String): TFrom; overload;
  function From(E: TEntityBase): TFrom; overload;
  function From(E: array of TEntityBase): TFrom; overload;
  function From(E: TClass): TFrom; overload;
  function From(E: IQueryAble): TFrom; overload;

implementation

{ TLinq }

function From(E: TEntityBase): TFrom;
var
  F: TFrom;
begin
  F := TFrom.create;
  with  F  do
  begin
    InitializeString;
    result := From( E );
  end;
end;

function From(E: array of TEntityBase): TFrom;
var
  F: TFrom;
begin
  F := TFrom.create;
  with  F do
  begin
    InitializeString;
    result := From( E );
  end;
end;

function From(E: String): TFrom;
var
  F: TFrom;
begin
  F := TFrom.create;
  with  F  do
  begin
    InitializeString;
    result := From( E );
  end;
end;

function From(E: TClass): TFrom;
var
  F: TFrom;
begin
  F := TFrom.create;
  with  F  do
  begin
    InitializeString;
    result := From( E );
  end;
end;

function From(E: IQueryAble): TFrom;
var
  F: TFrom;
begin
  F := TFrom.create;
  with  F  do
  begin
    InitializeString;
    result := From( E );
  end;
end;

end.
