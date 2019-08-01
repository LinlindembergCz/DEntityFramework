unit EF.Engine.DbContext;

interface

uses
EF.Drivers.Connection;

type
   TDbContext =class
   public
     constructor Create(aDatabase: TDatabaseFacade = nil);virtual;
   end;

implementation

{ TDbContext }

constructor TDbContext.Create(aDatabase: TDatabaseFacade);
begin

end;

end.
