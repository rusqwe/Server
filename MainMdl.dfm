object MainModule: TMainModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 460
  Width = 786
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=KRON_DEV'
      'User_Name=SimatovRL'
      'Password=Ktoheckfy1%'
      'Server=192.168.2.116,1433'
      'DriverID=MSSQL')
    Left = 96
    Top = 144
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evItems, evCache]
    SQL.Strings = (
      'select * from ints')
    Left = 192
    Top = 144
  end
  object FDPMySQLDriver: TFDPhysMySQLDriverLink
    VendorLib = 'C:\MySQL\MySQLServer5.5\lib\libmysql.dll'
    Left = 296
    Top = 144
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 400
    Top = 144
  end
  object UniConnection1: TUniConnection
    ProviderName = 'SQL Server'
    Left = 336
    Top = 240
  end
  object FDStoredProc: TFDStoredProc
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evItems, evCache]
    Left = 160
    Top = 224
  end
  object UniStoredProc1: TUniStoredProc
    Connection = UniConnection1
    Left = 448
    Top = 240
  end
end
