unit UI.Controller.Cliente;

interface

uses
 DB, DBClient, System.Classes, UI.Controller.Base,  FactoryEntity, SysUtils, strUtils,
 Rest.Json, System.JSON, RTTI, System.TypInfo;

type
  TControllerCliente = class(TControllerBase)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
     procedure Post;override;
  end;

implementation

{ TControllerCliente }

uses Service.Cliente, UI.Model.Cliente, viewCliente, UI.Utils.DataBind;

function TControllerCliente.LoadDataSetPorNome(Value: string): TDataSet;
begin
   result := (Service as TServiceCliente).LoadDataSetPorNome( Value );
end;

procedure TControllerCliente.Post;
var
  C: TClienteDetail;
  JsonObject:TJsonObject;
begin
  try
     try
        C:= TClienteDetail.Create;
        JsonObject:= TJson.ObjectToJsonObject(  TDataBind.Put(FContener, C) );
        inherited Post( JsonObject );
     except
       On E:Exception do
       begin
         raise Exception.Create('Erro(TControllerCliente.Post):'+E.message);
       end;
     end;
  finally
    JsonObject.Free;
    C.Free;
  end;
end;

initialization RegisterClass(TControllerCliente);
finalization UnRegisterClass(TControllerCliente);


end.
