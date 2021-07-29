program Server;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  MainMdl in 'MainMdl.pas' {MainModule: TDataModule},
  SERVER.HTTPController in 'SERVER.HTTPController.pas',
  SERVER.Mediator in 'SERVER.Mediator.pas',
  SERVER.Command in 'SERVER.Command.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainModule, MainModule);
  Application.Run;
end.
