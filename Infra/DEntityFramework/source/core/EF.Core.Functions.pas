unit EF.Core.Functions;

interface

uses
  sysutils, Classes, DB, EF.Core.Consts;

var
  fGetAs: TFunc<string, string, string>;
  FMax: TFunc<string, string, string>;
  FMin: TFunc<string, string, string>;
  fAVG: TFunc<string, string, string>;
  fSum: TFunc<string, string, string>;
  fEqual: TFunc<string, string, string>;
  fNotEqual: TFunc<string, string, string>;
  fLogicalAnd: TFunc<string, string, string>;
  fLogicalOr: TFunc<string, string, string>;
  fGreaterThan: TFunc<string, string, string>;
  fLessThan: TFunc<string, string, string>;
  fGreaterThanOrEqual: TFunc<string, string, string>;
  fLessThanOrEqual: TFunc<string, string, string>;
  fAdd: TFunc<string, string, string>;
  fDivide: TFunc<string, string, string>;
  fMultiply: TFunc<string, string, string>;
  fSubtract: TFunc<string, string, string>;
  fCaseof: TFunc<variant, variant, string>;
  fParserUpdate: TFunc<TStringList, TStringList, string>;
  fParserWhere: TFunc<TStringList, TStringList, string>;
  pParserDataSet: TProc<TStringList, TStringList, TDataSet>;
  fEmpty: TFunc<variant, boolean>;
  fStringReplace:TFunc<string, string,string,string>;

implementation

uses
  System.Variants;

initialization

fGetAs := function(Field, _as: string): string
  begin
    if _as <> '' then
    begin
      if (Pos('+', Field) > 0) or (Pos('/', Field) > 0) or (Pos('-', Field) > 0)
        or (Pos('*', Field) > 0) then
        result := '(' + Field + ')' + ' as ' + _as
      else
        result := Field + ' as ' + _as;
    end
    else
      result := Field;
  end;

FMax := function(Field, &As: string): string
  begin
    if trim(&As) = '' then
      result := 'Max(' + Field + ') as Max' + copy(Field, Pos('.', Field) + 1,
        length(Field))
    else
      result := 'Max(' + Field + ')' + ' as ' + &As;
  end;

fAVG := function(Field, &As: string): string
  begin
    if trim(&As) = '' then
      result := 'AVG(' + Field + ') as AVG' + copy(Field, Pos('.', Field) + 1,
        length(Field))
    else
      result := 'Max(' + Field + ')' + ' as ' + &As;
  end;

fSum := function(Field, &As: string): string
  begin
    if trim(&As) = '' then
      result := 'Sum(' + Field + ') as Sum' + copy(Field, Pos('.', Field) + 1,
        length(Field))
    else
      result := 'Max(' + Field + ')' + ' as ' + &As;
  end;

FMin := function(Field, &As: string): string
  begin
    if trim(&As) = '' then
      result := 'Min(' + Field + ') as Min' + copy(Field, Pos('.', Field) + 1,
        length(Field))
    else
      result := 'Max(' + Field + ')' + ' as ' + &As;
  end;

fEqual := function(Field1, Field2: string): string
  begin
    result := Field1 + _Equal + Field2;
  end;

fNotEqual := function(Field1, Field2: string): String
  begin
    result := Field1 + _NotEqual + Field2;
  end;

fLogicalAnd := function(Field1, Field2: string): String
  begin
    result := Field1 + _And + Field2;
  end;

fLogicalOr := function(Field1, Field2: string): String
  begin
    result := Field1 + _Or + Field2;
  end;

fGreaterThan := function(Field1, Field2: string): String
  begin
    result := Field1 + _GreaterThan + Field2;
  end;

fLessThan := function(Field1, Field2: string): String
  begin
    result := Field1 + _LessThan + Field2;
  end;

fGreaterThanOrEqual := function(Field1, Field2: string): String
  begin
    result := Field1 + _GreaterThanOrEqual + Field2;
  end;

fLessThanOrEqual := function(Field1, Field2: string): String
  begin
    result := Field1 + _LessThanOrEqual + Field2;
  end;

fAdd := function(Field1, Field2: string): String
  begin
    result := Field1 + _Add + Field2;
  end;

fDivide := function(Field1, Field2: string): String
  begin
    result := Field1 + _Divide + Field2;
  end;

fMultiply := function(Field1, Field2: string): String
  begin
    result := Field1 + _Multiply + Field2;
  end;

fSubtract := function(Field1, Field2: string): String
  begin
    result := Field1 + _Subtract + Field2;
  end;

fCaseof := function(S1, S2: variant): String
  begin
    if VarIsNumeric(S1) then
      result := ' when ' + string(S1) + ' then ' + quotedstr(string(S2))
    else
      result := ' when ' + quotedstr(S1) + ' then ' + quotedstr(string(S2));
  end;

fParserUpdate := function(L1, L2: TStringList): string
  var
    i: integer;
    sUpdate: string;
  begin
    for i := 0 to L1.Count - 1 do
      if sUpdate = '' then
        sUpdate := L1[i] + ' = ' + L2[i]
      else
        sUpdate := sUpdate + ', ' + L1[i] + ' = ' + L2[i];
    result := sUpdate;
  end;

fParserWhere := function(L1, L2: TStringList): string
  var
    i: integer;
    sUpdate: string;
  begin
    for i := 0 to L1.Count - 1 do
      if sUpdate = '' then
        sUpdate := L1[i] + ' = ' + L2[i]
      else
        sUpdate := sUpdate + ' and ' + L1[i] + ' = ' + L2[i];
    result := sUpdate;
  end;

fEmpty := function(xValue: variant): boolean
  var
    sTmp: String;
    iDia, iMes, iAno: Word;
  begin
    { Pré-Definição do Retorno }
    result := false;
    if (xValue = Null) then
    begin
      result := true;
      exit;
    end;
    if (VarType(xValue) = varUString) then
      result := (trim(xValue) = '')
    else if (VarType(xValue) = VarEmpty) then
      result := true
    else if (VarType(xValue) = varNull) then
      result := true
    else if (VarType(xValue) = varSmallInt) then
      result := (xValue = 0)
    else if (VarType(xValue) = varInteger) then
      result := (xValue = 0)
    else if (VarType(xValue) = varSingle) then
      result := (xValue = 0)
    else if (VarType(xValue) = varDouble) then
      result := (xValue = 0)
    else if (VarType(xValue) = varCurrency) then
      result := (xValue = 0)
    else if (VarType(xValue) = varDate) then
    begin
      result := (xValue = Null);
      if (not result) then
      begin
        DecodeDate(xValue, iAno, iMes, iDia);
        if ((iDia = 30) and (iMes = 12) and (iAno = 1899)) then
          result := true;
      end;
      if (not result) then
      begin
        sTmp := datetostr(xValue);
        sTmp := stringReplace(sTmp, '/', '', []);
        sTmp := stringReplace(sTmp, '-', '', []);
        sTmp := stringReplace(sTmp, '.', '', []);
        result := fEmpty(sTmp);
      end;
    end
    else if (VarType(xValue) = varOleStr) then
      result := (xValue = Null)
    else if (VarType(xValue) = varDispatch) then
      result := (xValue = Null)
    else if (VarType(xValue) = varByte) then
      result := (xValue = Null);
  end;

pParserDataSet := procedure(L1, L2: TStringList; DataSet: TDataSet)
  var
    i: integer;
    Field: string;
  begin
    for i := 0 to L1.Count - 1 do
    begin
      Field  := L1[i];
      DataSet.Fieldbyname(Field).ReadOnly:= false;
      if DataSet.Fieldbyname(Field).DataType in [ftDateTime, ftTimeStamp, ftDate] then
      begin
        if not fEmpty(L2[i]) then
          DataSet.Fieldbyname(Field).AsString := stringReplace(L2[i], '''', '',[rfReplaceAll]);
      end
      else
        DataSet.Fieldbyname(Field).AsString   := stringReplace(L2[i], '''', '',[rfReplaceAll]);
    end;
  end;

fStringReplace:= function (aString: string;Ch1, ch2: string): string
                  var
                    sb: TStringBuilder;
                  begin
                    sb := TStringBuilder.Create;
                    sb.Append(aString);
                    sb.Replace(Ch1, ch2);
                    Result := sb.ToString();
                    sb.Free;
                  end;

end.
