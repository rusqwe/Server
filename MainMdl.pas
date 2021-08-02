unit MainMdl;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, IdContext, IdCustomHTTPServer, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdHTTPServer, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, SERVER.Setting,
  Vcl.Forms, SERVER.HTTPController, System.Types, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, IBX.IBSQLMonitor, DBAccess, Uni, DASQLMonitor, UniSQLMonitor, MemDS;

type
  TMainModule = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPMySQLDriver: TFDPhysMySQLDriverLink;
    IdHTTPServer1: TIdHTTPServer;
    UniConnection1: TUniConnection;
    FDStoredProc: TFDStoredProc;
    UniStoredProc1: TUniStoredProc;
    procedure DataModuleCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure IBSQLMonitor1SQL(EventText: string; EventTime: TDateTime);
  private

  public
    Controller: THTTPController;
    function Connection(AUserName:string; APassword:string): boolean;
    destructor Destroy; override;
    function ArrayToStr(str: TStringDynArray; d: char): string;
    procedure test();
    procedure test2();
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
  IdHTTPServer1.Active := true;

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

procedure TMainModule.IBSQLMonitor1SQL(EventText: string; EventTime: TDateTime);
var
str: string;
begin
str:=EventText
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
var
  I:integer;
begin
  AResponseInfo.Server := '1';
  AResponseInfo.CacheControl := 'no-cache';

  AuthPassword := ARequestInfo.AuthPassword;
  AuthUsername := ARequestInfo.AuthUsername;

  if (AuthPassword<>'1') or (AuthUsername<>'2') then  //(AuthPassword<>'1') or (AuthUsername<>'2') then     not Connection(AuthUsername, AuthPassword) then                                 // not Connection(AuthUsername, AuthPassword)
    AuthFailed()
  else
  begin
  for I := 1 to 200 do
    sleep(100);
    AResponseInfo.ContentText := '000'

  end

end;

procedure TMainModule.test;
var
  variant2: Variant;
begin
  if Connection('SimatovRL', 'Ktoheckfy1%') then
  begin
    // FDQuery1.FetchOptions.Items := FDQuery1.FetchOptions.Items - [fiMeta];
    with FDQuery1.SQL do
    begin
      Clear;

      Add('ticket.service_request__select__data');

      Add(':service_request_kind_id');
    end;
    // FDQuery1.ParamByName('@service_request_kind_id').DataType:= TFieldType.ftInteger;
    // FDQuery1.Prepare;

    // variant2:=  FDQuery1.Params[0].Name;
    // FDQuery1.Command.CommandKind := skSelect;
    variant2 := '1';
    // FDQuery1.Params.Add
    // FDQuery1.Params.ParamValues['service_request_id'] := '0';

    FDQuery1.Params.ParamByName('service_request_kind_id').Value := 5;

    variant2 := FDQuery1.SQL.Text;

    FDQuery1.Open;
    if not FDQuery1.IsEmpty then
      FDQuery1.Fields[0].AsString;
  end;

end;

procedure TMainModule.test2;
var
  variant2: Variant;
  p: TFDParam;
begin
  if Connection('SimatovRL', 'Ktoheckfy1%') then
  begin
    FDStoredProc.Command.CommandKind := skSelect;
    FDStoredProc.SchemaName := 'ticket';
    FDStoredProc.StoredProcName := '[service_request__select__data]';

    FDStoredProc.Prepare;
    p := FDStoredProc.FindParam('@service_request_kind_id');
    if p <> nil then
      p.Value := 5;
    FDStoredProc.ParamByName('@service_request_kind_id').DataType := TFieldType.ftInteger;
    FDStoredProc.OpenOrExecute;

    if not FDStoredProc.IsEmpty then
      FDStoredProc.Fields[0].AsString;
  end;

end;

end.
