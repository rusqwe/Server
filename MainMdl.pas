unit MainMdl;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, IdContext, IdCustomHTTPServer, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdHTTPServer, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, SERVER.Setting,
  Vcl.Forms, SERVER.HTTPController, System.Types;

type
  TMainModule = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPMySQLDriver: TFDPhysMySQLDriverLink;
    IdHTTPServer1: TIdHTTPServer;
    procedure DataModuleCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
  private

  public
    Controller: THTTPController;
    function Connection(AUserName:string; APassword:string): boolean;

    destructor Destroy; override;
    function ArrayToStr(str: TStringDynArray; d: char): string;
  end;

var
  MainModule: TMainModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TMainModule.Connection(AUserName, APassword: string): boolean;
begin

  if not FDConnection1.Connected then
  try
    FDConnection1.Params.UserName := AUserName;
    FDConnection1.Params.Password := APassword;
    FDConnection1.Connected := true;
    Result := true;
  except
    on E : Exception do
    Result := false;
  end;

end;

procedure TMainModule.DataModuleCreate(Sender: TObject);
begin
  FDPMySQLDriver.VendorLib := ExtractFilePath(Application.ExeName) + 'libmysql.dll';
  //Setting := TSetting.Create(ExtractFilePath(Application.ExeName) + 'conf.ini');
  Controller := THTTPController.Create(ExtractFilePath(Application.ExeName) + 'conf.ini');
  IdHTTPServer1.DefaultPort := 991;
 // IdHTTPServer1.Active := true;

end;


function TMainModule.ArrayToStr(str: TStringDynArray; d: char): string;
var
 // i: integer;
  s: string;
begin
  Result:='';
  if str = nil then
    Exit;
  for s in str do
    Result := Result + s + d;
  Delete(Result, length(Result), 1);
end;

destructor TMainModule.Destroy;
begin
  FreeAndNil(Controller);
end;

procedure TMainModule.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo);
var
  str, bd, AuthPassword, AuthUsername: string;
  procedure AuthFailed;
  begin
    AResponseInfo.AuthRealm := 'SHTTPS:';
    AResponseInfo.WriteHeader;
  end;

begin
  // if ARequestInfo.Host='www.test.com' then

  AResponseInfo.Server := '1';
  AResponseInfo.CacheControl := 'no-cache';
  // AuthFailed();
  AuthPassword := ARequestInfo.AuthPassword;
  AuthUsername := ARequestInfo.AuthUsername;
  // if ARequestInfo.AuthExists then
  if not Connection(AuthUsername, AuthPassword) then //(AuthPassword<>'1') or (AuthUsername<>'2') then                                     // not Connection(AuthUsername, AuthPassword)
    AuthFailed()
  else
  begin
    ARequestInfo.Params.SaveToFile('1.txt');
   // FDQuery1.SQL.Text:='select * from ints';
   // FDQuery1.Active:=true;

    str := ARequestInfo.URI;
    bd := ARequestInfo.Document;
    bd := ARequestInfo.AuthUsername;
    bd := ARequestInfo.Password;
    AResponseInfo.ContentText := '000'//FDQuery1.Fields[0].AsString;

  end

end;

end.
