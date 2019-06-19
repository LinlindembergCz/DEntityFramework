unit Domain.Entity.ClienteEmpresa;

interface

uses
  System.Classes,   Dialogs, SysUtils,  EF.Mapping.Base, EF.Core.Types,
  EF.Mapping.Atributes, Domain.Entity.Empresa;

type
  [Table('ClienteEmpresa')]
  TClienteEmpresa = class( TEntityBase )
  private
    FClienteId: TInteger;
    FEmpresaId: TInteger;
    FEmpresa: TEmpresa;
    //FCliente: TCliente;
  public
      constructor Create;override;
    procedure Initialize;override;
  published
    [FieldTable('ClienteId','Integer',true)]
    [ForeignKey('ClienteId','Clientes', rlCascade, rlCascade )]
    property ClienteId: TInteger read FClienteId write FClienteId;

    [FieldTable('EmpresaId','Integer',true)]
    [ForeignKey('EmpresaId','Empresas', rlCascade, rlCascade )]
    property EmpresaId: TInteger read FEmpresaId write FEmpresaId;

    [NotMapper]
    property Empresa: TEmpresa read  FEmpresa write FEmpresa;
    //[NotMapper]
    //property Cliente: TCliente read  FCliente write FCliente;

  end;

implementation

uses
  GenericFactory;

{ TClienteTabelaPreco }



constructor TClienteEmpresa.Create;
begin
  inherited;
  Initialize;
end;

procedure TClienteEmpresa.Initialize;
begin
  inherited;
  FEmpresa:=  TGenericFactory.CreateInstance<TEmpresa>;//Collate.RegisterObject<TEmpresa>( TEmpresa.Create(true) );
  //Cliente:= TCliente.Create;
end;

initialization RegisterClass(TClienteEmpresa);
finalization UnRegisterClass(TClienteEmpresa);

end.
