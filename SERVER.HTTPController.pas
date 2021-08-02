unit SERVER.HTTPController;

interface

uses Generics.Collections, System.Classes, System.IniFiles, System.StrUtils,
  System.SysUtils,
  SERVER.HTTPServer, SERVER.Source;

type

  THTTPController = class
  private
    FHTTPServers: TList<THTTPServer>;
    // FSources: TList<TSource>;
    FFileName: string;
    function getHTTPServers: TList<THTTPServer>;
    procedure ReadSources(AFileName: string; var ASources: TList<TSERVERSource>);
    // function getSources: TList<TSource>;
  public
    constructor Create(AFileName: string);
    destructor Destroy();
    function Refresh(): boolean;
    property HTTPServers: TList<THTTPServer> read getHTTPServers;
    // property Sources: TList<TSource> read getSources;

  end;

implementation

{ THTTPController }

constructor THTTPController.Create(AFileName: string);
var
  Source: TSERVERSource;
  Sources: TList<TSERVERSource>;
begin

  Sources := TList<TSERVERSource>.Create;
  ReadSources(AFileName, Sources);

  FHTTPServers := TList<THTTPServer>.Create;
  // tt:= TIdHTTPServer.Create();
  for Source in Sources do
  begin
    Source.Id := FHTTPServers.Count + 1;
    FHTTPServers.Add(THTTPServer.Create(Source));
  end;

end;

destructor THTTPController.Destroy;
var
  HTTPServer: THTTPServer;
begin
  for HTTPServer in FHTTPServers do
    HTTPServer.Free;
  FHTTPServers.Free;
end;

function THTTPController.getHTTPServers: TList<THTTPServer>;
begin
  Result := FHTTPServers;
end;

// function THTTPController.getSources: TList<TSource>;
// begin
// Result := FSources;
// end;

procedure THTTPController.ReadSources(AFileName: string; var ASources: TList<TSERVERSource>);
var
  FSubSections: TStrings;
  FSubSection: String;
  FSource: TSERVERSource;
  Ini: Tinifile;
begin
  try

    FSubSections := TStringList.Create;
    Ini := Tinifile.Create(AFileName);
    Ini.ReadSubSections('Servers', FSubSections);
    for FSubSection in FSubSections do
    begin
      FSource := TSERVERSource.Create;
      FSource.SName := FSubSection; // Latin1String();//TEncoding.Convert(TEncoding.UTF8, );
      FSource.DBHost := Ini.ReadString('Servers/' + FSubSection, 'DBHost', '');
      FSource.DBNames := SplitString(Ini.ReadString('Servers/' + FSubSection, 'DBName', ''), ';');
      FSource.DBPort := Ini.ReadString('Servers/' + FSubSection, 'DBPort', '');
      FSource.Port := Ini.ReadString('Servers/' + FSubSection, 'Port', '');
      FSource.DB := Ini.ReadString('Servers/' + FSubSection, 'DB', '');
      { FServer.RemoteControlHostHttps := Ini.ReadString('Servers/' + FSubSection,
        'RemoteControlHostHttps', '');
        FServer.ExtHosts := SplitString(Ini.ReadString('Servers/' + FSubSection,
        'ExtHosts', ''), ';'); }
      ASources.Add(FSource);
    end;
    FFileName := AFileName;
  finally
    FSubSections.Free;
    Ini.Free;

  end;
end;

function THTTPController.Refresh: boolean;
var
  Source, S: TSERVERSource;
  Sources: TList<TSERVERSource>;
  HTTPServer: THTTPServer;
begin
  Result := false;
  Sources := TList<TSERVERSource>.Create;
  try
    ReadSources(FFileName, Sources);
    for HTTPServer in FHTTPServers do
      HTTPServer.Destroy;
    FHTTPServers.Clear;
    for Source in Sources do
    begin
      S := Source;
      S.Id := FHTTPServers.Count + 1;
      FHTTPServers.Add(THTTPServer.Create(S));
    end;
    Result := true;
  finally
    Sources.Free;
  end;

end;


end.



