unit App.Controller.Cliente;

interface

uses
 DB, DBClient, System.Classes, App.Controller.Base,  FactoryEntity, SysUtils, strUtils,
 Rest.Json, System.JSON, RTTI, System.TypInfo;

type
  TControllerCliente = class(TControllerBase)
  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
     procedure Post;override;
  end;

implementation

{ TControllerCliente }

uses Service.Cliente, App.Model.Cliente,  Service.Utils.DataBind;

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
        C := TClienteDetail.Create;
        //O dataBind irá mapear todos os Componentes do "Form" e preencher o objeto TClienteDetail e
        // depois converter o objeto em um TJsonObject.
        JsonObject:= TJson.ObjectToJsonObject( Service.DataBind.Map(FContener, C) );
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
