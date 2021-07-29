unit SERVER.HTTPController;

interface

uses Generics.Collections, System.Classes, System.IniFiles, System.Types, System.StrUtils,
  System.SysUtils,

  idContext, IdCustomHTTPServer, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdHTTPServer,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys,  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  SERVER.Mediator;

type
  TSERVERSource = class
    Id: integer;
    SName: String;
    DB: String;
    DBHost: String;
    DBNames: TStringDynArray;
    DBPort: String;
    Port: String;
    constructor Create;
  end;

  THTTPServer = class(TIdHTTPServer)
  private
    FHTTPServer: TIdHTTPServer;
    FSource: TSERVERSource;
    // function getHTTPServers: TList<TIdHTTPServer>;
    procedure CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    function getSource: TSERVERSource;
    function CreateConnection(): TFDConnection;
    function Connected(AConnection: TFDConnection): boolean;
  public
    constructor Create(ASource: TSERVERSource);
    destructor Destroy();
    procedure Update(ASource: TSERVERSource);
    // property HTTPServers: TList<TIdHTTPServer> read getHTTPServers;
    property Source: TSERVERSource read getSource;
  end;

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
  Source, S: TSERVERSource;
  Sources: TList<TSERVERSource>;
begin

  Sources := TList<TSERVERSource>.Create;
  ReadSources(AFileName, Sources);

  FHTTPServers := TList<THTTPServer>.Create;
  // tt:= TIdHTTPServer.Create();
  for Source in Sources do
  begin
    S := Source;
    S.Id := FHTTPServers.Count + 1;
    FHTTPServers.Add(THTTPServer.Create(S));
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

{ THTTPServer }

procedure THTTPServer.CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo);
var
  str, bd, AuthPassword, AuthUsername: string;
  Connection: TFDConnection;
  Query: TFDQuery;
  procedure AuthFailed;
  begin
    AResponseInfo.AuthRealm := 'SHTTPS могла быть ваша реклама';
    AResponseInfo.WriteHeader;
  end;

begin

  AResponseInfo.SERVER := '1';
  AResponseInfo.CacheControl := 'no-cache';

  AuthPassword := ARequestInfo.AuthPassword;
  AuthUsername := ARequestInfo.AuthUsername;
  Connection := CreateConnection;
  Query := TFDQuery.Create(self);
  Query.Connection:= Connection;
  Connection.Params.Password := AuthPassword;
  Connection.Params.UserName := AuthUsername;

  try
    if not (Connected(Connection)) then
      AuthFailed()
    else
    begin

      Query.SQL.Text:='select * from ints';
      Query.Active:=true;
      str := ARequestInfo.URI;
      Mediator.Execute(ARequestInfo.URI, Query);
//      ARequestInfo.Params.SaveToFile('1.txt');
//      bd := ARequestInfo.Document;
//      bd := ARequestInfo.AuthUsername;
//      bd := ARequestInfo.Password;
      while not Query.eof do
      begin
        bd:=bd +'-'+Query.Fields[0].AsString ;
        Query.Next;
      end;
      AResponseInfo.ContentText := bd;
    end;

  finally
    Query.Free;
    Connection.Free;

  end;

end;

function THTTPServer.Connected(AConnection: TFDConnection): boolean;
begin
  if not AConnection.Connected then
    try
      AConnection.Connected := true;
      Result := true;
    except
      on E: Exception do
        Result := false;
    end;

end;

constructor THTTPServer.Create(ASource: TSERVERSource);
begin
  FSource := ASource;
  FHTTPServer := TIdHTTPServer.Create;
  FHTTPServer.OnCommandGet := CommandGet;
  FHTTPServer.DefaultPort := strtoint(ASource.Port);
  FHTTPServer.Active := true;
end;

function THTTPServer.CreateConnection: TFDConnection;
begin
  Result := TFDConnection.Create(self);
  Result.DriverName := Source.DB;
  Result.Params.Database := Source.DBNames[0];
end;

destructor THTTPServer.Destroy;
begin
  FHTTPServer.Active := false;
  FHTTPServer.Free;
end;

function THTTPServer.getSource: TSERVERSource;
begin
  Result := FSource;
end;

procedure THTTPServer.Update(ASource: TSERVERSource);
begin
  FHTTPServer.Active := false;
  FSource := ASource;
  FHTTPServer.DefaultPort := strtoint(ASource.Port);
  FHTTPServer.Active := true;
end;

{ TSERVERSource }

constructor TSERVERSource.Create;
begin
  DBNames := TStringDynArray.Create();
end;

end.
