unit EF.Drivers.Migration;

interface

uses
  EF.Mapping.Base, System.Classes, EF.Drivers.Connection, StrUtils;

type
   TMigrationBuilder = class
   private
     Path: string;
     Filename:string;
     FTableName: string;
     FFDConn: FDConn;
     function BuildScript<T:TEntityBase>(E:T;Name:string): string;
   public
     Script:TStringList;
   type
       TMethod = reference to procedure;
     procedure CreateTable<T:TEntityBase>(out E:T; aTableName:string; Method: TMethod;aPrimareKey:string );
     constructor Create(aFDConn: FDConn ; aPath:string);
     destructor Destroy;override;
   end;

implementation

{ TMigrationBuilder }

uses EF.Mapping.AutoMapper, Vcl.Dialogs, System.SysUtils;

function TMigrationBuilder.BuildScript<T>(E: T;Name:string):string;
var
  columns: string;
begin
  columns:= TAutoMapper.GetColumns(E);
  result:= Format('Create Table %s ( %s )',[ Name, columns]);
end;

constructor TMigrationBuilder.Create(aFDConn: FDConn ;aPath: string);
begin
   Path := aPath;
   FFDConn:= aFDConn;
   filename:= Path+'\'+FormatDatetime('YYYYMMDDHHMNSS', now)+'.sql';
   Script:=TStringList.Create;
end;

procedure TMigrationBuilder.CreateTable<T>(out E:T; aTableName:string; Method: TMethod; aPrimareKey:string );
begin
  try
    E := T.Create;
    Method;
    Script.Add( BuildScript<T>(E,aTableName));
    Script.Add(ifthen(FFDConn = fdMSSQL,'GO',';'));
    Script.Add( Format('ALTER TABLE %s ADD PRIMARY KEY (%s)',[aTableName,aPrimareKey]) );
    Script.Add(ifthen(FFDConn = fdMSSQL,'GO',';'));
  finally
    E.free;//Destroi o objeto
  end;
end;

destructor TMigrationBuilder.Destroy;
begin
  Script.SaveToFile(filename);
  Script.Free;
end;

end.
