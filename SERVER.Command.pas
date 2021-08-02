unit SERVER.Command;

interface

uses
  System.Classes, System.StrUtils, System.Types, System.SysUtils,  FireDAC.Phys.Intf, System.JSON,
  FireDAC.Comp.Client, idCustomHTTPServer,   System.Rtti,System.TypInfo, DataSetConverter4D,
  DataSetConverter4D.Impl, SERVER.Source;

type
  DefaultAttribute = class(TCustomAttribute)
  private
    FValue: Variant;
  public
    constructor Create(AValue: String); overload;
    constructor Create(AValue: Integer); overload;
    constructor Create(AValue: Boolean); overload;
    class function GetAttribute(TypeInfo: PTypeInfo; Name:string):Variant;
    property Value: Variant read FValue;
  end;

  TSERVERCommand = class(TPersistent)
  private
    procedure AssignTo(Dest: TPersistent); overload;
  public
    constructor Create(AOwner: TComponent); virtual;
  end;

  TSERVERCustomCommand = class(TSERVERCommand)
  private
    FCommand: string;
    FQuery: TFDQuery;
    FParams: TStringList;
    [Default('JSON')]
    FFormat: String;
    AProcName:string;
    FResponseInfo: TIdHTTPResponseInfo;
    FCommandType: THTTPCommandType;

    procedure InternalExecute(); virtual;
    function GetProcName(): string;
    function GetParams(AName: string): Variant;

    function GetValue(AIndex: integer): Variant;
    procedure SetParam(AParam: TStrings);
    procedure SetQuery(const Value: TFDQuery);
    procedure SetParams(AName: string; const Value: Variant);
    procedure PrepareName(var AName: string); virtual;
    procedure PrepareParams(var AParams:string); virtual;
    procedure SetResponseInfo(const Value: TIdHTTPResponseInfo);
    procedure PrepareQuery();

    { FParams: TKRONValues;
      FOwner: TComponent;                          //Компонент, который владеет информацией об объектах
      FLastCommand: TKRONCommand;                 //Предыдущая команда, которая повлияла на создание этой
      FID: Integer;                               //Уникальный идентификатор команды в сессии
      function GetName(AIndex: integer): string;
      function GetParams(AName: string): Variant;
      function GetValue(AIndex: integer): Variant;
      procedure SetParams(AName: string; const Value: Variant);
      function GetTextValues(ANames: string): string;
      function GetCount: integer; }
  protected
    // function GetBody: string; virtual;
    // procedure Clear; virtual;
    // procedure InitParams; virtual;
  public
    constructor Create(ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo; AQuery: TFDQuery;
      ASource: TSERVERSource); reintroduce;
    destructor Destroy; override;
    procedure Execute;
    class function GetName: string; virtual;

    property Command: string read FCommand;
    property Query: TFDQuery read FQuery write SetQuery;
    property Params[AName: string]: Variant read GetParams write SetParams; default;
    property Values[AIndex: integer]: Variant read GetValue;

    property ResponseInfo: TIdHTTPResponseInfo read FResponseInfo write SetResponseInfo;
    property Format: string read FFormat write FFormat;
  end;

  TSERVERCustomCommandClass = class of TSERVERCustomCommand;

  TSERVERMySQLCommand = class(TSERVERCustomCommand)
  private
    // function GetNameProc():string; override;
  public
    class function GetName: string; override;
  end;

  TSERVERMSSQLCommand = class(TSERVERCustomCommand)
  private
    // function GetNameProc():string; override;
  public
    class function GetName: string; override;
  end;

implementation

uses SERVER.Mediator;

{ TSERVERMySQLCommand }

class function TSERVERMySQLCommand.GetName: string;
begin
  Result := 'MySQL';
end;

{ TSERVERMSSQLCommand }

class function TSERVERMSSQLCommand.GetName: string;
begin
  Result := 'MSSQL';
end;

{ TSERVERCustomCommand }

constructor TSERVERCustomCommand.Create(ARequestInfo: TIdHTTPRequestInfo; var AResponseInfo: TIdHTTPResponseInfo;
  AQuery: TFDQuery; ASource: TSERVERSource);
begin

  FCommand := ARequestInfo.URI;
  FCommandType := ARequestInfo.CommandType;
  SetParam(ARequestInfo.Params);
  Query := AQuery;

  FResponseInfo:= AResponseInfo;

  AProcName := GetProcName;

end;

destructor TSERVERCustomCommand.Destroy;
begin
  FParams.Free;
  inherited;
end;

procedure TSERVERCustomCommand.Execute;
begin

  PrepareName(AProcName);

  InternalExecute;
end;

class function TSERVERCustomCommand.GetName: string;
begin
  Result := '';
end;

function TSERVERCustomCommand.GetProcName: string;
var
  strList: TStringDynArray;
begin
  strList := SplitString(FCommand, '/');
  if Length(strList[Length(strList) - 1]) = 0 then
    raise Exception.Create('Not proc');
  Result := strList[Length(strList) - 1];
end;

function TSERVERCustomCommand.GetParams(AName: string): Variant;
begin

end;

function TSERVERCustomCommand.GetValue(AIndex: integer): Variant;
begin

end;

procedure TSERVERCustomCommand.InternalExecute;
var
  JSONStr, Params:string;
  i:integer;
  //ja: TJSONArray;
begin
  FResponseInfo.ContentType:='text/html';
  FResponseInfo.Charset := 'utf-8';

  if FCommandType = hcGET then
  begin
    PrepareParams(Params);
    with Query.SQL do
    begin
      Clear;
      Add(AProcName); // Add('[ticket].[service_request__select__data]');
      Add(Params); // Add(':service_request_id, :service_request_kind_id');
    end;
    Query.Command.CommandKind := skSelect;
    for i := 0 to FParams.Count - 1 do
      Query.Params.ParamValues[FParams.KeyNames[i]] := FParams.ValueFromIndex[i] ;

    Query.OpenOrExecute;
    if not Query.IsEmpty then
    begin

 //     FResponseInfo.ContentText := 'все ок - ' + Query.Fields[0].AsString;
      JSONStr := TConverter.New.DataSet(Query).AsJSONArray.ToString;
      //FResponseInfo.ContentText:= copy(JSONStr, 2, length(JSONStr)-2)
      FResponseInfo.ContentText:= JSONStr
    end;

  end;
end;

procedure TSERVERCustomCommand.PrepareName(var AName: string);
var
  strList: TStringDynArray;
  i: Integer;
begin
  if FCommandType = hcGET then
  begin
    strList := SplitString(AName, ':');
    if Length(strList) > 1 then
      AName := '';
    for i := 0 to Length(strList) - 1 do
    begin
      if strList[i] = '' then
        raise Exception.Create(': located incorrectly');
      if i <> Length(strList) - 1 then
        AName := AName + strList[i] + '__select__'
      else
        AName := AName + strList[i];
    end;
  end;
end;

procedure TSERVERCustomCommand.PrepareParams(var AParams: string);
var i:Integer;
begin
  for i := 0 to FParams.Count-1 do
    AParams:= AParams + ':' + FParams.KeyNames[i] + ',';
  if AParams <> '' then
    AParams := Copy(AParams, 1, Length(AParams) - 1)
end;

procedure TSERVERCustomCommand.PrepareQuery;
begin
  if Query = nil then
    raise Exception.Create('Something went wrong');

end;

procedure TSERVERCustomCommand.SetParam(AParam: TStrings);
var
  i: integer;
begin
  if FParams = nil then
    FParams := TStringList.Create;
 // FParams.QuoteChar:=':';
  FParams.Assign(AParam);
  FFormat := FParams.Values['format'];
  i := FParams.IndexOfName('format');
  if i <> -1 then
    FParams.Delete(i)
  else
    FFormat:=DefaultAttribute.GetAttribute(Self.ClassInfo,'FFormat');

//    if attr <> nil then
//      FFormat:=attr.Value;

end;

procedure TSERVERCustomCommand.SetParams(AName: string; const Value: Variant);
begin

end;

procedure TSERVERCustomCommand.SetQuery(const Value: TFDQuery);
begin
  FQuery := Value;
end;


procedure TSERVERCustomCommand.SetResponseInfo(const Value: TIdHTTPResponseInfo);
begin
  FResponseInfo := Value;
end;

{ TSERVERCommand }

procedure TSERVERCommand.AssignTo(Dest: TPersistent);
begin
 Inherited AssignTo(Dest) ;

end;

constructor TSERVERCommand.Create(AOwner: TComponent);
begin

end;

{ DefaultAttribute }

constructor DefaultAttribute.Create(AValue: String);
begin
  FValue := AValue;
end;

constructor DefaultAttribute.Create(AValue: Integer);
begin
  FValue := AValue;
end;

constructor DefaultAttribute.Create(AValue: Boolean);
begin
  FValue := AValue;
end;

class function DefaultAttribute.GetAttribute(TypeInfo: PTypeInfo; Name:string): Variant;
var
  Attr: TCustomAttribute;
  Ctx:TRTTIContext;
  Fld: TRttiField;
  str:string;
begin
  Ctx := TRTTIContext.Create;
  Result := '';
  for Fld in Ctx.GetType(TypeInfo).GetFields do
    for Attr in Fld.GetAttributes do
      if (Attr is DefaultAttribute) and (Name = Fld.Name) then
        Result := (Attr as DefaultAttribute).Value;
  Ctx.Free;
end;

initialization

Mediator.RegisterCommand(TSERVERMySQLCommand);
Mediator.RegisterCommand(TSERVERMSSQLCommand);

end.
