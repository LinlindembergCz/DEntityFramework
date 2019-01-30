unit TestLinqSQL;

interface

uses
  TestFramework, System.SysUtils, Vcl.Graphics, Winapi.Windows, System.Variants,
  Vcl.Dialogs, Vcl.Controls, Vcl.Forms, Winapi.Messages, classCliente,
  Math, strUtils, DB, Data.SqlExpr, DBClient, System.Classes,
  System.Generics.Collections, Data.Win.ADODB,FireDAC.Comp.Client,
  EF.Engine.DataContext,
  EF.QueryAble.Base,
  EF.Mapping.Atributes,
  EF.Mapping.Base ,
  EF.Core.Types ,
  EF.Mapping.AutoMapper,
  EF.QueryAble.Interfaces;

type
  TTest = class(TTestCase)
  private

  public
    Pessoa: TCliente;
    PessoaFisica:TCliente;
    PessoaJuridica: TCliente;
    //Endereco:TEndereco;
    Context: TDataContext;
    procedure SetUp;Override;
    procedure TearDown;Override;
  published
    procedure TestarAnd1;

    procedure TestarEqual1;
    procedure TestarEqual2;

    procedure TestarImplicit1;
    procedure TestarImplicit2;

    procedure Testar_GetAttributies;
    procedure Testar_GetValuesFields;
    //Basicos
    procedure TestarCapturaNomeAtributos;
    procedure TestarSelectTodosCampo_Object;
    procedure TestarSelectTodosCampo_DirectFrom_Object;
    procedure TestarSelectTodosCampo_Top_10_Object;
    procedure TestarSelectTodosCampo_Distinct_Nome_Object;
    procedure TestarSelectTodosCampo_Distinct_Object;
    procedure TestarSelectTodosCampoOrderByNome_Object;
    procedure TestarSelectTodosCampoOrderByDescNome_Object;
    procedure TestarSelectCOUNTCampoGroupByOrderByNome_Object;
    //Aritimeticas
    procedure TestarSelect_somar_inteiro_Object;
    procedure TestarSelect_subtrair_inteiro_Object;
    procedure TestarSelect_dividir_inteiro_Object;
    procedure TestarSelect_multiplicar_inteiro_Object;
    procedure TestarSelect_Max_com_tipo_inteiro_Object;
    procedure TestarSelect_Min_com_tipo_inteiro_Object;
    procedure TestarSelect_Sum_com_tipo_inteiro_Object;
    procedure TestarSelect_AVG_com_tipo_inteiro_Object;
    procedure TestarSelect_somar_float_Object;
    procedure TestarSelect_dividir_float_Object;
    procedure TestarSelect_multiplicar_float_Object;
    procedure TestarSelect_subtrair_float_Object;
    procedure TestarSelect_AVG_com_tipo_Float_Object;
    procedure TestarSelect_Max_com_tipo_Float_Object;
    procedure TestarSelect_Min_com_tipo_Float_Object;
    procedure TestarSelect_Sum_com_tipo_Float_Object;
    //operadores
    procedure TestarSelectComWhere_Igual_Object;
    procedure TestarSelectComWhere_Diferente_Object;
    procedure TestarSelectComWhere_IN_Object;
    procedure TestarSelectComWhere_IN_Select_Object;
    procedure TestarSelectComWhere_LIKE_Object;
    procedure TestarSelectComWhere_Concatenar_Object;
    procedure TestarSelectComWhere_Igual_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_Diferente_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_MaiorQue_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_MenorQue_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_MaiorIgualA_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_MenorIgualA_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_IN_com_tipo_inteiro_Object;
    procedure TestarSelectComWhere_Igual_com_tipo_float_Object;
    procedure TestarSelectComWhere_Diferente_com_tipo_float_Object;
    procedure TestarSelectComWhere_MaiorQue_com_tipo_float_Object;
    procedure TestarSelectComWhere_MenorQue_com_tipo_float_Object;
    procedure TestarSelectComWhere_MaiorIgualA_com_tipo_float_Object;
    procedure TestarSelectComWhere_MenorIgualA_com_tipo_float_Object;
    //Avançados
    procedure TestarSelectJoinComWhereObject;
    procedure TestarSelectDoisJoinComWhereObject;
    procedure TestarSelectLeftJoinComWhereObject;
    procedure TestarSelectRightJoinComWhereObject;
    procedure TestarSelectJoinELeftJoinComWhereObject;
    procedure TestarSelectJoinERightJoinComWhereObject;
    procedure TestarSelectCamposArrayComWhere_AND_Object;
    procedure TestarSelectCamposArrayComWhere_OR_Object;
    procedure TestarSelectJoin_Operator_AND_ComWhereObject;
    procedure TestarSelectCamposArrayComWhereObject;
    procedure TestarSelectCom_SubQuery_Object;
    procedure TestarSelectCom_SubQuery2_Object;
    procedure TestarSelectCom_SubQuery3_Object;
    procedure TestarSelect_UNION_Object;
    procedure TestarSelect_UNIONALL_Object;
    procedure TestarSelect_Not_Exist_Objec;
    procedure TestarSelect_Exist_Objec;
    //Strings
    procedure TestarSelect_SubString_Objec;
    procedure TestarSelect_CHARINDEX_Objec;
    procedure TestarSelect_LEFT_Objec;
    procedure TestarSelect_Len_Objec;
    procedure TestarSelect_LTRIM_Objec;
    procedure TestarSelect_REVERSE_Objec;
    procedure TestarSelect_RIGHT_Objec;
    procedure TestarSelect_RTRIM_Objec;
    procedure TestarSelect_UPPER_Objec;
    //Consultas strings
    procedure TestarSelect;
    procedure TestarSelectComWhere;
    procedure TestarSelectJoinComWhere;
    procedure TestarSelectLeftJoinComWhere;
    procedure TestarSelectRightJoinComWhere;
    procedure TestarSelectJoinELeftJoinComWhere;
    procedure TestarSelectJoinELeftJoinLeftJoinComWhere;
    procedure TestarSelectJoinJoinJoinComWhere;
    //Consultas
    procedure Testar_Sincronizer;

    procedure Testar_GetData;
    procedure Testar_ToList;
    procedure Testar_ToList_generics;
    procedure Testar_GetEntity;
    procedure Testar_GetEntity_generics;

    procedure Testar_COUNT_Simples;
    procedure Testar_COUNT;
    procedure Testar_CASE_string;
    procedure Testar_CASE_integer;

    procedure Testar_Reference;

    procedure Testar_Validation_campo_CNPJ_requerido;

    procedure Testar_ObjetoToJson;
    procedure Testar_ObjetoFromJson;
  end;

implementation

uses EF.Drivers.Connection, EF.Drivers.FireDac;

procedure TTest.SetUp;
begin
   Context            := TDataContext.Create(nil);
   Pessoa             := TCliente.Create;
   PessoaFisica       := TCliente.Create;
   PessoaJuridica     := TCliente.Create;

end;

procedure TTest.TearDown;
begin

   Pessoa.Free;
   PessoaFisica.Free;
   PessoaJuridica.Free;

   Context.Free;
   //DMConexao.SQLConnection1.Connected := false;
end;

procedure TTest.TestarAnd1;
var
  A:TString;
  B:TString;
  C:TString;
  D:TString;
begin
  A.SetAs( 'DescriptionA');
  B.SetAs( 'DescriptionB');
  C.SetAs( 'DescriptionC');
  D.SetAs( 'DescriptionD');
  CheckEquals( 'DescriptionA = DescriptionB and DescriptionC = DescriptionD',
  (A = B) and (C = D) );
end;

procedure TTest.TestarCapturaNomeAtributos;
begin
  CheckEquals( 'Clientes.CPFCNPJ as DOC', Pessoa.CPFCNPJ.&As('DOC'));
  CheckEquals( 'Clientes.Idade', Pessoa.Idade);
  CheckEquals( 'Clientes.DataNascimento', Pessoa.DataNascimento);
end;

procedure TTest.TestarEqual1;
var
  A:TString;
  B:TString;
begin
  A.SetAs('Description_A');
  B.SetAs('Description_B');
  CheckEquals( 'Description_A = Description_B', A = B );
end;

procedure TTest.TestarEqual2;
var
  cli :TCliente;
begin
  cli := TCliente.create;
  CheckEquals( 'LEN(Clientes.CPFCNPJ) = ''11''', cli.CPFCNPJ.Len = '11' );
end;

procedure TTest.TestarImplicit1;
begin
  //CheckeQuals('Pessoa.Nome', Pessoa.Nome );
  //Pessoa.Nome := 'Lindemberg';
  //CheckeQuals('Pessoa.Nome', Pessoa.Nome.&As );
  CheckeQuals('Clientes.Nome', Pessoa.Nome );
  Pessoa.Nome := 'Lindemberg';
  CheckeQuals('Lindemberg', Pessoa.Nome );
end;

procedure TTest.TestarImplicit2;
begin
  Pessoa.Nome := 'Lindemberg';
  CheckeQuals('Lindemberg', Pessoa.Nome );
end;

procedure TTest.TestarSelectComWhere_Igual_Object;
//var
//  Query: IQueryAble;
begin

  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Nome = ''Lindemberg''',
  Context.GetQuery(From(Pessoa).
                Where( Pessoa.Nome = 'Lindemberg' ).
                Select([Pessoa.Nome])) );
end;

procedure TTest.TestarSelectComWhere_IN_com_tipo_inteiro_Object;
//var
//  Query: IQueryAble;
begin
  //CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID In (1,2,3)',
  //Context.GetQuery( From(Pessoa).
   //                 Where( Pessoa.Id In [1,2,3] ).
     //               Select([Pessoa.Nome])) );
end;

procedure TTest.TestarSelectComWhere_IN_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Nome in ['A','B','C'] ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Nome In (''A'',''B'',''C'')',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_IN_Select_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Nome in [Context.GetQuery( From(PessoaFisica).
                                                                  Select(PessoaFisica.Id))]).
                 Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Nome In (Select Clientes.ID From Clientes)',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_LIKE_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where(  Pessoa.Nome.Contains('Lindemberg%') ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Nome LIKE(''Lindemberg%'')',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_Concatenar_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Nome+Pessoa.NomeFantasia]);
  CheckEquals('Select Clientes.Nome + Clientes.NomeFantasia From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_somar_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id+Pessoa.Id]);
  CheckEquals('Select Clientes.ID + Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_subtrair_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id-Pessoa.Id]);
  CheckEquals('Select Clientes.ID - Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_dividir_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id/Pessoa.Id]);
  CheckEquals('Select Clientes.ID / Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_multiplicar_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id*Pessoa.Id]);
  CheckEquals('Select Clientes.ID * Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_somar_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(PessoaFisica).
                Select([(PessoaFisica.Renda+PessoaFisica.Renda).
                &As('Soma')]);
  CheckEquals('Select (Clientes.Renda + Clientes.Renda) as Soma From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_subtrair_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id-Pessoa.Id]);
  CheckEquals('Select Clientes.ID - Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_dividir_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id/Pessoa.Id]);
  CheckEquals('Select Clientes.ID / Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_multiplicar_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id*Pessoa.Id]);
  CheckEquals('Select Clientes.ID * Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_SubString_Objec;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.SubString(1,10)]);
  CheckEquals('Select SUBSTRING(Clientes.Nome,1,10) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_LEFT_Objec;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.LEFT(10)]);
  CheckEquals('Select LEFT(Clientes.Nome,10) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_RIGHT_Objec;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.RIGHT(10)]);
  CheckEquals('Select RIGHT(Clientes.Nome,10) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_RTRIM_Objec;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.RTRIM]);
  CheckEquals('Select RTRIM(Clientes.Nome) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

{
   E: IEmpExpression;
  Query: ILinqQueryable;
begin
  E := Context.Emp;
  Query := From(E)
               .OrderBy(E.EName)
               .Select([E.EName, E.Job, E.Dept.DName]);
  Result := Context.GetEntities(Query);
end;
}

procedure TTest.TestarSelect_LTRIM_Objec;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.LTRIM]);
  CheckEquals('Select LTRIM(Clientes.Nome) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_UPPER_Objec;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.UPPER]);
  CheckEquals('Select UPPER(Clientes.Nome) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.Testar_ToList;
var
  Query: IQueryAble;
  CliList: TList<TEntityBase>;
begin
  {
  CliList:= TList<TEntityBase>.create;
  Query := From(TCliente).Select.TopFirst(2);
  CliList := Context.GetList(Query);
  CheckTrue( TCliente(CliList.Items[0]).CPFCNPJ.Value <> '' );
  }
end;

procedure TTest.Testar_ToList_generics;
var
  Query: IQueryAble;
  CliList: TList<TCliente>;
begin
  {
  CliList:= TList<TCliente>.create;
  Query := From(TCliente).Select.TopFirst(2);
  CliList := Context.GetList<TCliente>(Query);
  CheckTrue( CliList.Items[0].CPFCNPJ.Value <> '' );
  }
end;

procedure TTest.Testar_Validation_campo_CNPJ_requerido;
begin
  try
     Pessoa:= TCliente.Create;
     Pessoa.CPFCNPJ := '';
     Pessoa.Validation;
     CheckTrue(false);
  except
    on E:Exception do
    begin
      CheckEquals('Operation aborted', E.Message );
    end;
  end;
end;

procedure TTest.Testar_CASE_string;
var
  Cli: TCliente;
  Query: IQueryAble;
begin
   Cli:= TCliente.create;
   query := From(cli).
            Select(
                  [ linq.CaseOf(cli.CPFCNPJ ,
                          ['02316937454' , '00123456000155'],
                          ['Fisica'      , 'Juridica']).&As('TipoPessoa')] );

   CheckEquals('Select (case Clientes.CPFCNPJ when ''02316937454'' then ''Fisica'' when ''00123456000155'' then ''Juridica'' end) as TipoPessoa From Clientes',
   Context.GetQuery( query )   );
end;


procedure TTest.Testar_CASE_integer;
var
  Cli: TCliente;
  Query: IQueryAble;
begin
   Cli:= TCliente.create;
   query := From(cli).
            Select(
                  [ linq.CaseOf(cli.id ,
                          [1 , 2],
                          ['Um','Dois']).
                          &As('Codigo')] );

   CheckEquals('Select (case Clientes.ID when 1 then ''Um'' when 2 then ''Dois'' end) as Codigo From Clientes',
   Context.GetQuery( query )   );
end;

procedure TTest.Testar_COUNT_Simples;
var
  Query: IQueryAble;
  dts: TClientDataSet;
  Cli: TCliente;
begin
  Cli:= TCliente.create;
  Query := From(Cli).Select.Count;
  dts:= TClientDataSet.create(application);
  CheckEquals( 'Select COUNT(*) From Clientes',
  Context.GetQuery(query)  );
end;

procedure TTest.Testar_COUNT;
var
  Query: IQueryAble;
  Cli: TCliente;
begin
  Cli:= TCliente.create;
  Query := From(Cli).
           GroupBy([cli.CPFCNPJ]).
           Select([cli.CPFCNPJ]).
           Count;
  CheckEquals( 'Select COUNT(*), Clientes.CPFCNPJ From Clientes Group by Clientes.CPFCNPJ',
  Context.GetQuery(query)  );
end;



procedure TTest.Testar_GetAttributies;
var
   Cli: TCliente;
begin
   Cli:= TCliente.create;
   checkEquals('Nome, NomeFantasia, CPFCNPJ, Renda, Idade, RG, DataNascimento, Ativo, Situacao, Tipo, EstadoCivil, Observacao, Email, ID',
   TAutoMapper.GetAttributies(Cli) );
end;

procedure TTest.Testar_GetValuesFields;
var
   Cli: TCliente;
begin
   Cli:= TCliente.create;
   Cli.Id:= 1;
   Cli.CPFCNPJ:= '02316937454';
   Cli.Renda := 1000;
   Cli.DataNascimento := strtodate( '01/01/2015' );
   Cli.Ativo := 'S';

   checkEquals(''''','''',''02316937454'',1000,0,'''',01/01/2015,''S'','''','''','''','''',,1', TAutoMapper.GetValuesFields(Cli) );
end;

procedure TTest.Testar_ObjetoFromJson;
var
  c:TCliente;
begin
  c := TCliente.create;
  c.FromJson('{"Nome":"Lindemberg Cortez","Renda":"100","Idade":"42","DataNascimento":"19/04/1976"}');
  CheckEquals( c.Nome ,'Lindemberg Cortez' );
  CheckEquals( c.Renda , 100 );
  CheckEquals( c.Idade , 42 );
  CheckEquals( c.DataNascimento , strtodate( '19/04/1976' ) );
end;

procedure TTest.Testar_ObjetoToJson;
var
   Cli: TCliente;
begin
   Cli:= TCliente.Create;
   Cli.Nome:= 'Lindemberg';
   Cli.CPFCNPJ:= '02316937454';
   CheckEquals( Cli.ToJson , '{"Nome":"''Lindemberg''","NomeFantasia":"''''",'+
                             '"CPFCNPJ":"''02316937454''","Renda":"0","Idade":"0","RG":"''''","DataNascimento":"",'+
                             '"Ativo":"''''","Situacao":"''''","Tipo":"''''","EstadoCivil":"''''",'+
                             '"Observacao":"''''","Email":"''''"}' );
end;

procedure TTest.Testar_GetData;
var
  Query: TQueryAble;
  dts: TClientDataSet;
  Cli: TCliente;
begin
 { Cli:= TCliente.create;
  Query := From(Cli).Select([Cli.Id,Cli.CPFCNPJ]);
  dts:= TClientDataSet.create(application);
  dts.Data := Context.GetData(Query);
  CheckTrue( dts.recordcount > 0 );  }
end;

procedure TTest.Testar_GetEntity;
var
  Query: TQueryAble;
  Cli: TCliente;
begin
   {Cli := TCliente.Create;
   Query := From(Cli).
                 Select([ Cli.CPFCNPJ ]).
                       Where(Cli.CPFCNPJ = '02316937454'  );
   Cli := Context.GetEntity(Query) as TCliente;
   CheckEquals( '02316937454', Cli.CPFCNPJ.Value);}
end;

procedure TTest.Testar_GetEntity_generics;
var
  Query: TQueryAble;
  dts: TDataSet;
  Cli: TCliente;
begin
 {  Cli := TCliente.Create;
   Query := From(Cli).
                 Select([ Cli.CPFCNPJ ]).
                       Where(Cli.CPFCNPJ = '02316937454'  );
   Cli := Context.GetEntity<TCliente>(Query);
   CheckEquals( '02316937454', Cli.CPFCNPJ.Value);
   }
end;


procedure TTest.Testar_Reference;
var
  Query: TQueryAble;
begin
  {Query := From(Pessoa).
           Join(Pessoa.Endereco).
           Where(Pessoa.Id = 1).
           Select([ Pessoa.Nome,
                    Pessoa.Endereco.Logradouro]) ;

  CheckEquals('Select Pessoa.Nome, Endereco.Logradouro From Pessoa '+
  'Inner Join Endereco On Pessoa.Id = Endereco.PessoaId Where Pessoa.Id = 1',
  Context.GetQuery(Query) );}
end;

procedure TTest.Testar_Sincronizer;
begin
  //Context.UpdateDataBase([  TProduto ]);
end;

procedure TTest.TestarSelect_REVERSE_Objec;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.REVERSE]);
  CheckEquals('Select REVERSE(Clientes.Nome) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_CHARINDEX_Objec;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
                 Select([Pessoa.Nome.CHARINDEX('L')]);
  CheckEquals('Select CHARINDEX(''L'',Clientes.Nome) as Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Len_Objec;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
           Select([Pessoa.Nome.Len('Tamanho')]);
  CheckEquals('Select LEN(Clientes.Nome) as Tamanho From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Max_com_tipo_inteiro_Object;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id.Max('Id')]);
  CheckEquals('Select Max(Clientes.ID) as Id From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Min_com_tipo_inteiro_Object;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id.Min]);
  CheckEquals('Select Min(Clientes.ID) as MinID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_AVG_com_tipo_inteiro_Object;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id.AVG]);
  CheckEquals('Select AVG(Clientes.ID) as AVGID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Sum_com_tipo_inteiro_Object;
var
  Query: TQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Id.Sum]);
  CheckEquals('Select Sum(Clientes.ID) as SumID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_UNION_Object;
var
  Query: IQueryAble;
begin
   Query := From(TCliente).
                 Select([PessoaFisica.Nome]).
                 Union( From(PessoaJuridica).
                        Select([PessoaJuridica.Nome]) );

   CheckEquals( 'Select Clientes.Nome From Clientes'+
                ' Union '+
                'Select Clientes.Nome From Clientes',
                Context.GetQuery(Query) );
end;


procedure TTest.TestarSelect_UNIONALL_Object;
var
  Query: IQueryAble;
begin
   Query := From(TCliente).
                 Select([PessoaFisica.Nome]).
                 Concat( From(PessoaJuridica).
                        Select([PessoaJuridica.Nome]) );

   CheckEquals( 'Select Clientes.Nome From Clientes'+
                ' Union all '+
                'Select Clientes.Nome From Clientes',
                Context.GetQuery(Query) );
end;


procedure TTest.TestarSelect_Not_Exist_Objec;
var
  Query: IQueryAble;
begin
   Query := From(TCliente).
                 Select([PessoaFisica.Nome]).
                 &Except( From(PessoaJuridica).
                        Select([PessoaJuridica.Nome]) );

   CheckEquals( 'Select Clientes.Nome From Clientes'+
                ' Where Not (Exists('+
                'Select Clientes.Nome From Clientes))',
                Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Exist_Objec;
var
  Query: IQueryAble;
begin
   Query := From(Pessoa).
                 Select([Pessoa.Nome]).
                      Intersect( From(PessoaJuridica).
                           Select([PessoaJuridica.Nome]) );

   CheckEquals( 'Select Clientes.Nome From Clientes'+
                ' Where Exists('+
                'Select Clientes.Nome From Clientes)',
                Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Max_com_tipo_Float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Renda.Max]);
  CheckEquals('Select Max(Clientes.Renda) as MaxRenda From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Min_com_tipo_Float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Renda.Min]);
  CheckEquals('Select Min(Clientes.Renda) as MinRenda From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_AVG_com_tipo_Float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Renda.AVG]);
  CheckEquals('Select AVG(Clientes.Renda) as AVGRenda From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelect_Sum_com_tipo_Float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select([Pessoa.Renda.Sum]);
  CheckEquals('Select Sum(Clientes.Renda) as SumRenda From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_Diferente_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Nome  <> 'Lindemberg' ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Nome <> ''Lindemberg''',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_Igual_com_tipo_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Renda  = 15.36 ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Renda = 15.36',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_Diferente_com_tipo_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Renda  <> 15.36 ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Renda <> 15.36',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MaiorIgualA_com_tipo_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Renda  >= 15.36 ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Renda >= 15.36',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MaiorQue_com_tipo_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Renda  > 15.36 ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Renda > 15.36',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MenorIgualA_com_tipo_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Renda <= 15.36 ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Renda <= 15.36',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MenorQue_com_tipo_float_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Renda < 1505.36 ).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.Renda < 1505.36',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_Diferente_com_tipo_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Id  = 1).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID = 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MaiorIgualA_com_tipo_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Id  >= 1).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID >= 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MaiorQue_com_tipo_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
               Where( Pessoa.Id  > 1).
               Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID > 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MenorIgualA_com_tipo_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Id  <= 1).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID <= 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_MenorQue_com_tipo_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Id  < 1).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID < 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere_Igual_com_tipo_inteiro_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Where( Pessoa.Id <> 1).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Where Clientes.ID <> 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectCamposArrayComWhere_AND_Object;
var
  Query: IQueryAble;
begin
  Query := From(TCliente).
                Where( (PessoaFisica.Nome  = 'Lindemberg') and (PessoaFisica.Id=1) ).
                Select([PessoaFisica.CPFCNPJ,PessoaFisica.Nome]);

  CheckEquals('Select Clientes.CPFCNPJ, Clientes.Nome From Clientes Where Clientes.Nome = ''Lindemberg'' and Clientes.ID = 1',
   Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectCamposArrayComWhere_OR_Object;
var
  Query: IQueryAble;
begin
  Query := From(TCliente).
                Where( (PessoaFisica.Nome  = 'Lindemberg') or (PessoaFisica.Id=1) ).
                Select([PessoaFisica.CPFCNPJ, PessoaFisica.Nome]);
  CheckEquals('Select Clientes.CPFCNPJ, Clientes.Nome From Clientes Where Clientes.Nome = ''Lindemberg'' or Clientes.ID = 1',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectJoinComWhereObject;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Include(PessoaFisica, PessoaFisica.Id=Pessoa.Id).
                Where(Pessoa.Id=1).
                OrderBy([Pessoa.Nome]).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Inner Join Clientes On Clientes.ID = Clientes.ID Where Clientes.ID = 1 Order by Clientes.Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectDoisJoinComWhereObject;
var
  Query: IQueryAble;
begin
  {
  Query := From(Pessoa).
                Join( Pessoa.Endereco , Pessoa.Endereco.PessoaId = Pessoa.Id ).
                Join( PessoaFisica, PessoaFisica.Id=Pessoa.Id).
                Where(Pessoa.Id=1).
                Order([Pessoa.Nome]).
                Select([Pessoa.Nome]);
  CheckEquals( 'Select Pessoa.Nome From Pessoa Inner Join Endereco On Endereco.PessoaId = Pessoa.Id '+
               'Inner Join PessoaFisica On PessoaFisica.Id = Pessoa.Id Where Pessoa.Id = 1 Order by Pessoa.Nome',
               Context.GetQuery(Query) );
  }
end;

procedure TTest.TestarSelectLeftJoinComWhereObject;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                IncludeLeft(PessoaFisica, PessoaFisica.Id=Pessoa.Id).
                Where(Pessoa.Id=1).
                OrderBy([Pessoa.Nome]).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Left Join Clientes On Clientes.ID = Clientes.ID Where Clientes.ID = 1 Order by Clientes.Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectRightJoinComWhereObject;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                IncludeRight(PessoaFisica, PessoaFisica.Id=Pessoa.Id).
                Where(Pessoa.Id=1).
                OrderBy([Pessoa.Nome]).
                Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Right Join Clientes On Clientes.ID = Clientes.ID Where Clientes.ID = 1 Order by Clientes.Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampoOrderByDescNome_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 OrderByDesc(Pessoa.Nome).
                 Select([Pessoa.Nome]);
  CheckEquals('Select Clientes.Nome From Clientes Order by Clientes.Nome Desc',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampoOrderByNome_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
               OrderBy(Pessoa.Nome).
                     Select;
  CheckEquals('Select Nome, NomeFantasia, CPFCNPJ, Renda, Idade, RG, DataNascimento, Ativo, Situacao, Tipo, EstadoCivil, Observacao, Email, ID From Clientes Order by Clientes.Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampo_Distinct_Nome_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select(Pessoa.Id).
                       Distinct(Pessoa.Nome);
  CheckEquals('Select Distinct(Clientes.Nome), Clientes.ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampo_Distinct_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                Select(Pessoa.Nome).
                Distinct;
  CheckEquals('Select Distinct Clientes.Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampo_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).
                 Select([]);
  CheckEquals('Select Nome, NomeFantasia, CPFCNPJ, Renda, Idade, RG, DataNascimento, Ativo, Situacao, Tipo, EstadoCivil, Observacao, Email, ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampo_DirectFrom_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).Select([]);
  CheckEquals('Select Nome, NomeFantasia, CPFCNPJ, Renda, Idade, RG, DataNascimento, Ativo, Situacao, Tipo, EstadoCivil, Observacao, Email, ID From Clientes',Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectTodosCampo_Top_10_Object;
var
  Query: IQueryAble;
begin
  Query := From(Pessoa).Select.TopFirst(10);

  CheckEquals('Select Top 10 Nome, NomeFantasia, CPFCNPJ, Renda, Idade, RG, DataNascimento, Ativo, Situacao, Tipo, EstadoCivil, Observacao, Email, ID From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectJoinERightJoinComWhereObject;
var
  Query: IQueryAble;
begin
  {
  Query := From(Pessoa).
                Join( Pessoa.Endereco , Pessoa.Endereco.PessoaId = Pessoa.Id ).
                JoinRight( PessoaFisica, PessoaFisica.Id=Pessoa.Id).
                Where(Pessoa.Id=1).
                Order([Pessoa.Nome]).
                Select([Pessoa.Nome]);
  CheckEquals('Select Pessoa.Nome From Pessoa Inner Join Endereco On Endereco.PessoaId = Pessoa.Id '+
  'Right Join PessoaFisica On PessoaFisica.Id = Pessoa.Id Where Pessoa.Id = 1 Order by Pessoa.Nome',
  Context.GetQuery(Query) );
  }
end;

procedure TTest.TestarSelectJoinELeftJoinComWhereObject;
var
  Query: IQueryAble;
begin
  {
  Query := From(Pessoa).
                Join( Pessoa.Endereco , Pessoa.Endereco.PessoaId = Pessoa.Id ).
                JoinLeft( PessoaFisica, PessoaFisica.Id=Pessoa.Id).
                Where(Pessoa.Id=1).
                Order([Pessoa.Nome]).
                Select([Pessoa.Nome]);
  CheckEquals('Select Pessoa.Nome From Pessoa Inner Join Endereco On Endereco.PessoaId = Pessoa.Id '+
  'Left Join PessoaFisica On PessoaFisica.Id = Pessoa.Id Where Pessoa.Id = 1 Order by Pessoa.Nome',
  Context.GetQuery(Query) );
  }
end;

procedure TTest.TestarSelectJoin_Operator_AND_ComWhereObject;
var
  Query: IQueryAble;
begin
  {
  Query := From(Pessoa).
                Join( Pessoa.Endereco , Pessoa.Endereco.PessoaId = Pessoa.Id).
                Join( PessoaFisica, (PessoaFisica.Id=Pessoa.Id) and (PessoaFisica.Nome=Pessoa.Nome) ).
                Where(Pessoa.Id=1).
                Order([Pessoa.Nome]).
                Select([Pessoa.Nome]);

  CheckEquals('Select Pessoa.Nome From Pessoa Inner Join Endereco On Endereco.PessoaId = Pessoa.Id '+
  'Inner Join PessoaFisica On PessoaFisica.Id = Pessoa.Id and PessoaFisica.Nome = Pessoa.Nome Where Pessoa.Id = 1 Order by Pessoa.Nome',
  Context.GetQuery(Query) );
  }
end;

procedure TTest.TestarSelectCamposArrayComWhereObject;
var
  Query: IQueryAble;
begin
  Query := From(TCliente).
                Where( PessoaFisica.Nome  = 'Lindemberg' ).
                Select([PessoaFisica.CPFCNPJ,
                        PessoaFisica.Nome]);
  CheckEquals('Select Clientes.CPFCNPJ, Clientes.Nome From Clientes Where Clientes.Nome = ''Lindemberg''',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectCom_SubQuery_Object;
var
  Query : TQueryAble;
begin
  Query  := From( From( Pessoa ).
                  Include(PessoaFisica, Pessoa.Id = PessoaFisica.Id ).
                  Select(Pessoa.Nome) ).Select('NomeFantasia');

  CheckEquals('Select NomeFantasia From '+
              '(Select Clientes.Nome From Clientes '+
              'Inner Join Clientes On '+
              'Clientes.ID = Clientes.ID)',
  Context.GetQuery(Query) );

end;

procedure TTest.TestarSelectCom_SubQuery2_Object;
var
  Query : TQueryAble;
  SubQuery: string;
begin
  SubQuery:= Context.GetQuery( From(PessoaFisica).
                                        Where( PessoaFisica.Id = Pessoa.Id ).
                                        Select(PessoaFisica.Nome));
  Query := From(Pessoa).Select( SubQuery );

  CheckEquals('Select '+
              '(Select Clientes.Nome From Clientes '+
              'Where '+
              'Clientes.ID = Clientes.ID)'+
              ' From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectCom_SubQuery3_Object;
var
  Query : TQueryAble;
begin
//BUG: implementar para quando for só select sem where e nem join left Right
  Query  := From(
                 From( Pessoa ).
               //Join(PessoaFisica, Pessoa.Id = PessoaFisica.Id ).
                 Where( Pessoa.Nome = 'Lindemberg').
                 Select([Pessoa.Nome]) ).Select('NomeFantasia');

  CheckEquals('Select NomeFantasia From '+
              '(Select Clientes.Nome From Clientes '+
              'Where Clientes.Nome = ''Lindemberg'')', Context.GetQuery(Query) );
end;


procedure TTest.TestarSelectCOUNTCampoGroupByOrderByNome_Object;
begin
  CheckEquals('Select COUNT(*), Clientes.Nome From Clientes Group by Clientes.Nome',
               Context.GetQuery(From(Pessoa).
                 GroupBy([Pessoa.Nome]).
                 Select([Pessoa.Nome]).Count) );
end;

procedure TTest.TestarSelect;
var
  Query: IQueryAble;
begin
  Query :=  From('Clientes').
                 Select('Nome');
  CheckEquals('Select Nome From Clientes',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Clientes').
                Where('Nome = 30').
                OrderBy( 'Nome' ).
                Select('Nome');
  CheckEquals('Select Nome From Clientes Where Nome = 30 Order by Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectJoinComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Clientes').
                Include('Tabela2', 'Tabela2.Id = Clientes.ID').
                Where('0=1').
                OrderBy('Nome').
                Select('Nome');
  CheckEquals('Select Nome From Clientes Inner Join Tabela2 On Tabela2.Id = Clientes.ID Where 0=1 Order by Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectLeftJoinComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Clientes').
                IncludeLeft('Clientes', 'Clientes.ID = Clientes.ID').
                Where('0=1').
                OrderBy('Nome').
                Select('Nome');
  CheckEquals('Select Nome From Clientes Left Join Clientes On Clientes.ID = Clientes.ID Where 0=1 Order by Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectRightJoinComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Clientes').
                IncludeRight('Clientes', 'Clientes.ID = Clientes.ID').
                Where('0=1').
                OrderBy('Nome').
                Select('Nome');
  CheckEquals('Select Nome From Clientes Right Join Clientes On Clientes.ID = Clientes.ID Where 0=1 Order by Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectJoinELeftJoinComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Tabela').
                Include('Tabela2', 'Tabela2.Id = Tabela.Id').
                IncludeLeft('Tabela3','Tabela3.Id = Tabela2.Id').
                Where('0=1').
                OrderBy('Nome').
                Select('Nome');
  CheckEquals('Select Nome From Tabela Inner Join Tabela2 On Tabela2.Id = Tabela.Id '+
  'Left Join Tabela3 On Tabela3.Id = Tabela2.Id Where 0=1 Order by Nome',
  Context.GetQuery(Query) );
end;


procedure TTest.TestarSelectJoinELeftJoinLeftJoinComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Tabela').
                Include('Tabela2', 'Tabela2.Id = Tabela.Id').
                IncludeLeft('Tabela3','Tabela3.Id = Tabela2.Id').
                IncludeLeft('Tabela4','Tabela4.Id = Tabela3.Id').
                Where('0=1').
                OrderBy('Nome').
                Select('Nome');
  CheckEquals('Select Nome From Tabela Inner Join Tabela2 On Tabela2.Id = Tabela.Id '+
  'Left Join Tabela3 On Tabela3.Id = Tabela2.Id Left Join Tabela4 On Tabela4.Id = Tabela3.Id Where 0=1 Order by Nome',
  Context.GetQuery(Query) );
end;

procedure TTest.TestarSelectJoinJoinJoinComWhere;
var
  Query: IQueryAble;
begin
  Query := From('Tabela').
                Include('Tabela2','Tabela2.Id = Tabela.Id').
                Include('Tabela3','Tabela3.Id = Tabela2.Id').
                Include('Tabela4','Tabela4.Id = Tabela3.Id').
                Where('0=1').
                OrderBy('Nome').
                Select('Nome');
  CheckEquals('Select Nome From Tabela Inner Join Tabela2 On Tabela2.Id = Tabela.Id '+
  'Inner Join Tabela3 On Tabela3.Id = Tabela2.Id Inner Join Tabela4 On Tabela4.Id = Tabela3.Id Where 0=1 Order by Nome',
  Context.GetQuery(Query) );
end;

initialization
   TestFramework.RegisterTest(TTest.Suite);
   //ReportMemoryLeaksOnShutdown := true;
end.


