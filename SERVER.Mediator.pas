unit SERVER.Mediator;

interface

uses
  SERVER.Command, System.Classes, System.SysUtils, FireDAC.Comp.Client, SERVER.Source, IdCustomHTTPServer;

type
  { TKRON4ShowFormProc   = procedure(ACommand: TKRON4Command) of object;
    TKRON4ShowReportProc = procedure(AReportName: string; AValues: TKRONValues) of object;
    TKRON4CommandEnabledProc = procedure(ACommand: TKRON4CustomCommand; var AEnabled: boolean) of object; }

  TMediator = class
  private
    FCommandClassList: TStringList;
    function GetCmdClass(ACommandClass: string): TSERVERCustomCommandClass;
  public
    constructor Create;
    destructor Destroy;
    procedure Execute(ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo; AQuery: TFDQuery;
      ASource: TSERVERSource);
    function CreateCommand(ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo; AQuery: TFDQuery;
      ASource: TSERVERSource): TSERVERCustomCommand;
    procedure RegisterCommand(ACommand: TSERVERCustomCommandClass);

    // function CreateCommand(AAction: string): TCommand;
  end;

function Mediator: TMediator;

implementation

var
  FMediator: TMediator;

function Mediator: TMediator;
begin
  if FMediator = nil then
    FMediator := TMediator.Create;
  Result := FMediator;
end;

{ TMediator }

constructor TMediator.Create;
begin
  FCommandClassList := TStringList.Create;
end;

function TMediator.GetCmdClass(ACommandClass: string): TSERVERCustomCommandClass;
var
  I: integer;
begin
  I := FCommandClassList.IndexOf(ACommandClass);
  if I <> -1 then
    Result := TSERVERCustomCommandClass(FCommandClassList.Objects[I])
  else
    Result := nil;
end;

function TMediator.CreateCommand(ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo; AQuery: TFDQuery;
  ASource: TSERVERSource): TSERVERCustomCommand;
var
  cmdClass: TSERVERCustomCommandClass;
begin
  Result := nil;
  cmdClass := GetCmdClass(ASource.DB);
  if cmdClass <> nil then
    Result := cmdClass.Create(ARequestInfo, AResponseInfo, AQuery, ASource);
end;

destructor TMediator.Destroy;
begin
  FreeAndNil(FCommandClassList);
end;

procedure TMediator.Execute(ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo; AQuery: TFDQuery;
  ASource: TSERVERSource);
var
  Cmd: TSERVERCustomCommand;
begin
  Cmd := CreateCommand(ARequestInfo, AResponseInfo, AQuery, ASource);
  if Cmd = nil then
    raise Exception.Create('Command not maked');
  try
    Cmd.Execute;
  finally
    Cmd.Free;
  end;
end;

procedure TMediator.RegisterCommand(ACommand: TSERVERCustomCommandClass);
begin
  FCommandClassList.AddObject(ACommand.GetName, TObject(ACommand));
end;

end.
