program Server;

uses
  Vcl.Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  MainMdl in 'MainMdl.pas' {MainModule: TDataModule},
  SERVER.HTTPController in 'SERVER.HTTPController.pas',
  SERVER.Mediator in 'SERVER.Mediator.pas',
  SERVER.Command in 'SERVER.Command.pas',
  SERVER.HTTPServer in 'SERVER.HTTPServer.pas',
  SERVER.Source in 'SERVER.Source.pas',
  DataSetConverter4D.Helper in 'JSONConverter\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'JSONConverter\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'JSONConverter\DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'JSONConverter\DataSetConverter4D.Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainModule, MainModule);
  Application.Run;
end.
