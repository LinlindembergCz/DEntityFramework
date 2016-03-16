object DMConexao: TDMConexao
  OldCreateOrder = False
  Height = 263
  Width = 263
  object SQLConnection1: TSQLConnection
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'SchemaOverride=%.dbo'
      'DriverUnit=Data.DBXMSSQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver210.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=21.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMsSqlMetaDataCommandFactory,DbxMSSQLDr' +
        'iver210.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMsSqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMSSQLDriver,Version=21.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMSSQL'
      'LibraryName=dbxmss.dll'
      'VendorLib=sqlncli10.dll'
      'VendorLibWin64=sqlncli10.dll'
      'HostName=.\SQLEXPRESS'
      'DataBase=DBLINQ'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'OSAuthentication=true'
      'PrepareSQL=True'
      'User_Name=user'
      'Password=password'
      'BlobSize=-1'
      'ErrorResourceFile='
      'OS Authentication=true'
      'Prepare SQL=False')
    Left = 112
    Top = 104
  end
  object SQLMonitor1: TSQLMonitor
    AutoSave = True
    FileName = 'D:\Lindemberg\Linq\Linq\log.txt'
    SQLConnection = SQLConnection1
    Left = 112
    Top = 40
  end
end
