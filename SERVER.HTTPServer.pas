unit SERVER.HTTPServer;

interface

uses Generics.Collections, System.Types, System.StrUtils, System.SysUtils, SERVER.Source, System.Classes,

  idContext, IdCustomHTTPServer, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdHTTPServer,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  SERVER.Mediator;

type

  THTTPServer = class(TIdHTTPServer)
  private
    // FHTTPServer: TIdHTTPServer;
    FSource: TSERVERSource;
    // function getHTTPServers: TList<TIdHTTPServer>;
    procedure CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function getSource: TSERVERSource;
    function CreateConnection(ADBNumber: integer): TFDConnection;
    function Connected(AConnection: TFDConnection): boolean;
  public
    constructor Create(ASource: TSERVERSource); overload; // &!!!!!!!!!!!!!!!!!!
    destructor Destroy(); Override;
    procedure Update(ASource: TSERVERSource);
    // property HTTPServers: TList<TIdHTTPServer> read getHTTPServers;
    property Source: TSERVERSource read getSource;
  end;

implementation

{ TSERVERSource }

{ THTTPServer }

procedure THTTPServer.CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  str, bd, AuthPassword, AuthUsername: string;
  Connection: TFDConnection;
  Query: TFDQuery;
  procedure AuthFailed;
  begin
    AResponseInfo.AuthRealm := 'SHTTPS могла быть ваша реклама';
    AResponseInfo.WriteHeader;
  end;

  function CheckDB(): integer;
  var
    str1, str2: string;
    i: integer;
  begin
    Result := -1;

    for str1 in SplitString(ARequestInfo.URI, '/') do
    begin
      i := 0;
      for str2 in FSource.DBNames do
      begin
        if (LowerCase(str1) = LowerCase(str2)) and (str1 <> '') then
          exit(i);
        inc(i);
      end;
    end;

  end;

var
  DBN: integer;
begin

  AResponseInfo.SERVER := '1';
  AResponseInfo.CacheControl := 'no-cache';
  if ARequestInfo.URI = '/favicon.ico' then
    exit;
  AuthPassword := ARequestInfo.AuthPassword;
  AuthUsername := ARequestInfo.AuthUsername;
  DBN := CheckDB();
  if DBN = -1 then
    raise Exception.Create('Server not found');
  Connection := CreateConnection(DBN);
  // sleep(20000);
  Query := TFDQuery.Create(self);
  Query.Connection := Connection;
  Connection.Params.Password := AuthPassword;
  Connection.Params.UserName := AuthUsername;

  try
    if not(Connected(Connection)) then
      AuthFailed()
    else
    begin

      // Query.SQL.Text:='select * from ints';

      Query.SQL.Text := 'select  top 1  * from dbo.calendar ';
      Query.Active := true;
      str := ARequestInfo.URI;
      // ARequestInfo.CommandType;
      Mediator.Execute(ARequestInfo, AResponseInfo, Query, FSource);

      // ARequestInfo.Params.SaveToFile('1.txt');
      // bd := ARequestInfo.Document;
      // bd := ARequestInfo.AuthUsername;
      // bd := ARequestInfo.Password;
      while not Query.eof do
      begin
        bd := bd + '-' + Query.Fields[0].AsString;
        Query.Next;
      end;
    //  AResponseInfo.ContentText := bd;
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
  inherited Create(nil);
  FSource := ASource;

  self.OnCommandGet := CommandGet;
  self.DefaultPort := strtoint(ASource.Port);
  self.Active := true;
end;

function THTTPServer.CreateConnection(ADBNumber: integer): TFDConnection;
begin
  Result := TFDConnection.Create(self);
  with Result.Params do
  begin
    // Clear;
    Add('DriverID=' + FSource.DB);
    Add('Server=' + FSource.DBHost);
    Add('Database=' + FSource.DBNames[ADBNumber]);
  end;
end;

destructor THTTPServer.Destroy;
begin
  // FHTTPServer.Active := false;
  // FHTTPServer.Free;
  inherited Destroy;
end;

function THTTPServer.getSource: TSERVERSource;
begin
  Result := FSource;
end;

procedure THTTPServer.Update(ASource: TSERVERSource);
begin
  self.Active := false;
  FSource := ASource;
  self.DefaultPort := strtoint(ASource.Port);
  self.Active := true;
end;

end.
