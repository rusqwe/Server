object MainModule: TMainModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 460
  Width = 786
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'User_Name=webapi'
      'Password=1234567'
      'Database=test'
      'DriverID=MySQL')
    Left = 96
    Top = 144
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
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
end
