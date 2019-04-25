unit ControllerCliente;

interface

uses
 DB, DBClient, System.Classes, ControllerBase,  FactoryEntity, SysUtils, strUtils,
 Rest.Json, System.JSON;

type
  TControllerCliente = class(TControllerBase)
  private

  public
     function LoadDataSetPorNome( Value: string ): TDataSet;
     procedure Post;override;
  end;

implementation

{ TControllerCliente }

uses Service.Cliente, UI.Model.Cliente, viewCliente;

function TControllerCliente.LoadDataSetPorNome(Value: string): TDataSet;
begin
   result := (Service as TServiceCliente).LoadDataSetPorNome( Value );
end;

procedure TControllerCliente.Post;
var
  C: TModelCliente;
  F: TFormViewCliente;
  JsonObject:TJsonObject;
begin
  C:= TModelCliente.Create;
  F:= TFormViewCliente(FContener);
  with C do
  begin
    CPFCNPJ:= F.edtCPFCNPJ.Text;
    Renda:= strtofloat( F.edtRenda.Text );
    Nome:=F.edtNome.Text;
    RG:=F.edtRG.Text;
    DataNascimento:=F.DataNascimento.date;
    Ativo:= ifthen( F.Ativo.Checked,'S','N' );
    NomeFantasia:=F.edtNomeFantasia.Text;
    Tipo:=ifthen( F.rdgTipo.ItemIndex = 0,'F','J' );
    Observacao:=F.Observacao.Text;
    Email:= F.edtEmail.Text;
  end;
  JsonObject:= TJson.ObjectToJsonObject( C );
  inherited Post( JsonObject );
  JsonObject.Free;
  C.Free;
end;



initialization RegisterClass(TControllerCliente);
finalization UnRegisterClass(TControllerCliente);


end.
