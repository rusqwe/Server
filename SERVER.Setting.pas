unit SERVER.Setting;

interface

uses Generics.Collections, System.Classes, System.IniFiles, System.Types, System.StrUtils,
  System.SysUtils;

  type
  Latin1String = type AnsiString(28591);

  TServer = record
    Id: integer;
    Name: String;
    DB: String;
    DBHost: String;
    DBName: String;
    DBPort: String;
    Port: String;
  end;

  TSetting = class
  private
    FServers: TList<TServer>;
    FFileName:string;
    procedure ReadServers(AFileName: string);
    function getServers: TList<TServer>;
  public
    constructor Create(AFileName:string);
    destructor Destroy();

  end;


implementation

{ TSetting }

constructor TSetting.Create(AFileName: string);
begin
  FServers := TList<TServer>.Create;
  ReadServers(AFileName);
end;

destructor TSetting.Destroy;
begin
  FServers.Free;
end;

function TSetting.getServers: TList<TServer>;
begin
  Result := FServers;
end;

procedure TSetting.ReadServers(AFileName: string);
var
  FSubSections: TStrings;
  FSubSection: String;
  FServer: TServer;
  Ini: Tinifile;
begin
  try

    FSubSections := TStringList.Create;
    Ini := TIniFile.Create(AFileName);
    Ini.ReadSubSections('Servers', FSubSections);
    for FSubSection in FSubSections do
    begin

      FServer.Name := FSubSection;//Latin1String();//TEncoding.Convert(TEncoding.UTF8, );
      FServer.DBHost := Ini.ReadString('Servers/' + FSubSection, 'DBHost', '');
      FServer.DBName := Ini.ReadString('Servers/' + FSubSection, 'DBName', '');
      FServer.DBPort := Ini.ReadString('Servers/' + FSubSection,'DBPort', '');
      FServer.Port := Ini.ReadString('Servers/' + FSubSection,'Port', '');
      FServer.DB := Ini.ReadString('Servers/' + FSubSection,'DB', '');
     { FServer.RemoteControlHostHttps := Ini.ReadString('Servers/' + FSubSection,
        'RemoteControlHostHttps', '');
      FServer.ExtHosts := SplitString(Ini.ReadString('Servers/' + FSubSection,
        'ExtHosts', ''), ';');}
      FServers.Add(FServer);
    end;
    FFileName := AFileName;
  finally
    FSubSections.Free;
    Ini.Free;
  end;
end;
   {
procedure TSetting.Refresh;
begin
  FServers.Clear;
  ReadServers(FFileName);
end;
              }
end.
