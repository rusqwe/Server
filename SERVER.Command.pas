unit SERVER.Command;

interface
uses
  System.Classes;

type
  TSERVERCommand = class(TPersistent)
  private
    procedure InternalExecute(); virtual;
  protected
   // function GetBody: string; virtual;
   // procedure Clear; virtual;
   // procedure InitParams; virtual;
  public
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
    procedure Execute;
    class function GetName: string; virtual;
  end;

  TSERVERCommandClass = class of TSERVERCommand;
  TSERVERMySQLCommand = class(TSERVERCommand)
  private
  public
    class function GetName: string; override;
  end;
  TSERVERMSSQLCommand = class(TSERVERCommand)
  private
  public
    class function GetName: string; override;
  end;

implementation

uses SERVER.Mediator;

{ TSERVERCommand }

constructor TSERVERCommand.Create(AOwner: TComponent);
begin

end;

destructor TSERVERCommand.Destroy;
begin

end;

procedure TSERVERCommand.Execute;
begin

end;

class function TSERVERCommand.GetName: string;
begin
  Result := '';
end;

procedure TSERVERCommand.InternalExecute;
begin

end;

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

initialization
  Mediator.RegisterCommand(TSERVERMySQLCommand);
  Mediator.RegisterCommand(TSERVERMSSQLCommand);

end.
