{*******************************************************}
{         Copyright(c) Lindemberg Cortez.               }
{              All rights reserved                      }
{         https://github.com/LinlindembergCz            }
{		Since 01/01/2019                        }
{*******************************************************}
unit EF.Schema.PostGres;

interface

uses
  SysUtils, classes, strUtils, Dialogs,
  EF.Mapping.Atributes,
  EF.Mapping.AutoMapper,
  EF.Drivers.Connection,
  EF.Schema.Abstract;

type
  TPostGres = class(TCustomDataBase)
  private
     function AlterColumn(Table, Field, Tipo: string; IsNull: boolean): string ;override;

  public
     function CreateTable( List: TList; Table: string;  Key:TStringList = nil): string ;override;
     function AlterTable( Table, Field, Tipo: string; IsNull: boolean;ColumnExist: boolean): string ;override;
     function GetPrimaryKey( Table, Fields: string):string;
     function CreateForeignKey(AtributoForeignKey: PParamForeignKeys;Table: string): string;override;
  end;

implementation

{ TMSSQLServer }

function TPostGres.AlterColumn(Table, Field, Tipo: string;
  IsNull: boolean): string;
begin
   result:= 'Alter table ' + Table + ' Alter Column ' + Field + ' ' +
                 Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL');
end;

function TPostGres.AlterTable(Table, Field, Tipo: string; IsNull: boolean;ColumnExist: boolean): string;
begin
  if ColumnExist then
    result:= AlterColumn( Table , Field, tipo , IsNull)
  else
    result:= 'Alter table ' + Table + ' Add ' + Field + ' ' +
            Tipo + ' ' + ifthen(IsNull, '', 'NOT NULL')
end;

function TPostGres.CreateTable( List: TList; Table: string; Key:TStringList = nil ): string;
var
  J: integer;

  TableList: TStringList;
  FieldAutoInc: string;

  Name, Tipo: string;
  AutoInc, PrimaryKey, IsNull: boolean;
  CreateScript , ListKey :TStringList;

begin
  CreateScript := TStringList.Create;
  ListKey          := TStringList.Create;
  ListKey.delimiter := ',';

  CreateScript.Clear;
  CreateScript.Add('Create Table ' +'public."'+uppercase(Table)+'"');
  CreateScript.Add('(');
  FieldAutoInc := '';
  try
      for J := 0 to List.Count - 1 do
      begin
        Name := PParamAtributies(List.Items[J]).Name;
        Tipo := PParamAtributies(List.Items[J]).Tipo;
        Tipo := stringReplace(Tipo, 'varchar', 'character varying',[] );
        Tipo := stringReplace(Tipo, 'Date', 'timestamp without time zone',[] );
        Tipo := stringReplace(Tipo, 'float', 'double precision',[] );

        if Tipo ='' then
          break;
       // AutoInc := PParamAtributies(List.Items[J]).AutoInc;
        PrimaryKey := PParamAtributies(List.Items[J]).PrimaryKey;
        IsNull := PParamAtributies(List.Items[J]).IsNull;

        CreateScript.Add( '"'+Name+'"' + ' ' + Tipo + ' ' +
                          ifthen(IsNull, '', 'NOT NULL') +
                          ifthen(J < List.Count - 1, ',', '') );

        if PrimaryKey then
        begin
          ListKey.Add(Name);
          if Key <> nil then
             Key.Add(Name);
        end;

      end;

      if ListKey.Count > 0 then
      begin
        CreateScript.Add( GetPrimaryKey(Table,ListKey.DelimitedText) );
        result:= CreateScript.Text;
      end
      else
        ShowMessage('Primary Key is riquered!');

      CreateScript.Add( ' ) ' );
      result:= CreateScript.Text;
  finally
     CreateScript.Free;
     ListKey.Free;
     //Key.Free;
  end;
end;

{
     CREATE TABLE public."Clientes"
    (
      "Id" integer NOT NULL DEFAULT nextval('"Clientes_Id_seq"'::regclass),
      "Ativo" boolean NOT NULL,
      "BloquearVendasPrazo" boolean NOT NULL,
      "DataAtualizacao" timestamp without time zone,
      "DataCadastro" timestamp without time zone,
      "DataFundacao" timestamp without time zone NOT NULL,
      "DestacarAliquotaICMSCompraNaNFE" boolean NOT NULL,
      "EhColaborador" boolean NOT NULL,
      "EhFornecedor" boolean NOT NULL,
      "EmailRecepcaoDanfe" text,
      "EmailRecepcaoVendasPDV" text,
      "EmailRecepcaoXML" text,
      "LimiteCreditoDisponivel" double precision NOT NULL,
      "LimiteCreditoDisponivelLitro" double precision NOT NULL,
      "MotivoBloqueioVendasPrazo" character varying(300),
      "ObservacoesPDV" character varying(300),
      "Operador" character varying(50),
      "OptanteSimples" boolean NOT NULL,
      "PessoaId" integer,
      "PlanoContasId" integer,
      "PoliticaComercialId" integer,
      "PossuiRetencaoISS" boolean NOT NULL,
      "RecadoPDV" character varying(300),
      "SegmentoId" integer,
      "EmailFrota" text,
      "GMStatus" integer,
      "IntegraDadosComGestorMotors" boolean,
      "Bloqueado" boolean NOT NULL DEFAULT false,
      "DataUltimaCompra" timestamp without time zone,
      "GerarBoletoFaturamento" boolean NOT NULL DEFAULT false,
      "NFePDV" boolean NOT NULL DEFAULT false,
      "GerarNfeFaturamento" boolean NOT NULL DEFAULT false,
      "TotalCredito" double precision NOT NULL DEFAULT 0.0,
      "TotalCreditoLitro" double precision NOT NULL DEFAULT 0.0,
      "MostrarSaldoNoPDV" boolean NOT NULL DEFAULT false,
      "RepresentanteId" integer,
      "PercentualRetencaoISS" double precision NOT NULL DEFAULT 0,
      "TipoFaturamento" integer NOT NULL DEFAULT 1,
      CONSTRAINT "PK_Clientes" PRIMARY KEY ("Id"),
      CONSTRAINT "FK_Clientes_FuncionarioRepresentante_RepresentanteId" FOREIGN KEY ("RepresentanteId")
          REFERENCES public."FuncionarioRepresentante" ("Id") MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "FK_Clientes_Pessoas_PessoaId" FOREIGN KEY ("PessoaId")
          REFERENCES public."Pessoas" ("Id") MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "FK_Clientes_PlanoContas_PlanoContasId" FOREIGN KEY ("PlanoContasId")
          REFERENCES public."PlanoContas" ("Id") MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "FK_Clientes_PoliticaComercial_PoliticaComercialId" FOREIGN KEY ("PoliticaComercialId")
          REFERENCES public."PoliticaComercial" ("Id") MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION,
      CONSTRAINT "FK_Clientes_Segmento_SegmentoId" FOREIGN KEY ("SegmentoId")
          REFERENCES public."Segmento" ("Id") MATCH SIMPLE
          ON UPDATE NO ACTION ON DELETE NO ACTION
    )
}

function TPostGres.GetPrimaryKey(Table, Fields: string): string;
begin
  result:= ', CONSTRAINT "PK_'+Table+'" PRIMARY KEY ("'+Fields+'")';


end;

function TPostGres.CreateForeignKey(AtributoForeignKey: PParamForeignKeys;
  Table: string): string;
begin
  result:= 'ALTER TABLE '+Table +
           ' ADD CONSTRAINT FK_'+AtributoForeignKey.ForeignKey+
           ' FOREIGN KEY ('+AtributoForeignKey.ForeignKey+')'+
           ' REFERENCES '+AtributoForeignKey.Name+' (ID) '+
           ' ON DELETE '+ ifthen( AtributoForeignKey.OnDelete = rlCascade, ' CASCADE ',
                          ifthen( AtributoForeignKey.OnDelete = rlSetNull, ' SET NULL ',
                          ifthen( AtributoForeignKey.OnDelete = rlRestrict,' RESTRICT ',
                                                                           ' NO ACTION ' )))+
           ' ON Update '+ ifthen( AtributoForeignKey.OnUpdate = rlCascade, ' CASCADE ',
                          ifthen( AtributoForeignKey.OnUpdate = rlSetNull, ' SET NULL ',
                          ifthen( AtributoForeignKey.OnUpdate = rlRestrict,' RESTRICT ',
                                                                           ' NO ACTION ' )));
end;

end.
