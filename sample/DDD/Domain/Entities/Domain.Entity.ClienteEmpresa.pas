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
    constructor Create;override;
    procedure Initialize;override;
  end;

implementation

{ TClienteTabelaPreco }

constructor TClienteEmpresa.Create;
begin
  inherited;
end;

procedure TClienteEmpresa.Initialize;
begin
  inherited;
  FEmpresa:= Collate.RegisterObject<TEmpresa>( TEmpresa.Create(true) );
  //Cliente:= TCliente.Create;
end;

initialization RegisterClass(TClienteEmpresa);
finalization UnRegisterClass(TClienteEmpresa);

end.
