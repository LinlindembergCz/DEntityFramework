unit App.Model.Cliente;

interface

uses
  Dialogs, SysUtils, System.Classes;

type
  //json.Text := TJson.ObjectToJsonString(CooperadoDTO);
  TClienteDetail = class(TPersistent)
  private
    FCPFCNPJ: String;
    FRenda: Double;
    FIdade: Integer;
    FNome: String;
    FRG: String;
    FDataNascimento: TDatetime;
    FAtivo: String;
    FNomeFantasia: String;
    FApelido: String;
    FSituacao: String;
    FTipo: String;
    FEstadoCivil: String;
    FObservacao: String;
    FEmail: String;
    FCalcRenda: Double;
  published
    property Nome: String read FNome write FNome;
    property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
    property CPFCNPJ: String read FCPFCNPJ write FCPFCNPJ;
    property Renda:Double read FRenda write FRenda;
    property Idade: Integer read FIdade write FIdade;
    property RG: String read FRG write FRG;
    property DataNascimento:TDatetime read FDataNascimento write FDataNascimento;
    property Ativo: String read FAtivo write FAtivo;
    property Situacao:String read FSituacao write FSituacao;
    property Tipo: String read FTipo write FTipo;
    property EstadoCivil: String read FEstadoCivil write FEstadoCivil;
    property Observacao:String read FObservacao write FObservacao;
    property Email: String read FEmail write FEmail;
  end;

implementation

initialization RegisterClass(TClienteDetail);
finalization UnRegisterClass(TClienteDetail);

end.
