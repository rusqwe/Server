unit SERVER.Mediator;

interface

uses
 SERVER.Command, System.Classes, System.SysUtils, FireDAC.Comp.Client;

type

  TMediator = class
  private
    FMediator: TMediator;
    FCommandList: TStringList;
  public
    constructor Create;
    destructor Destroy;
    procedure Execute(ACommand: string; AQuery:TFDQuery);
    function CreateCommand(ACommand: string; AQuery: TFDQuery): TSERVERCommand;
    procedure RegisterCommand(ACommand: TSERVERCommandClass);
    //function CreateCommand(AAction: string): TCommand;
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
  FCommandList := TStringList.Create;
end;

function TMediator.CreateCommand(ACommand: string; AQuery: TFDQuery): TSERVERCommand;
begin

end;

destructor TMediator.Destroy;
begin
 FreeAndNil(FCommandList);
end;

procedure TMediator.Execute(ACommand: string; AQuery:TFDQuery);
var
  Cmd: TSERVERCommand;
begin
  Cmd := CreateCommand(ACommand, AQuery);
  if Cmd = nil then
  Raise Exception.Create('Command not maked');

  try
    Cmd.Execute;
  finally
    Cmd.Free;
  end;
end;

procedure TMediator.RegisterCommand(ACommand: TSERVERCommandClass);
begin
  FCommandList.AddObject(ACommand.GetName, TObject(ACommand));
end;

end.
