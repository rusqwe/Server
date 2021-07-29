unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, Vcl.Grids,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.StdCtrls, SERVER.HTTPController;


type
  TMainForm = class(TForm)
    grdServer: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public
    procedure FillGRD();
  end;

var
  MainForm: TMainForm;

implementation

uses MainMdl;

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FillGRD();
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  if MainModule.Controller.Refresh then
    ShowMessage('Удачно!');
end;

procedure TMainForm.FillGRD();
var
  i:integer;
  S: TSERVERSource;
begin

  grdServer.ColWidths[0] := 180;
  grdServer.ColWidths[1] := 180;
  grdServer.ColWidths[2] := 180;
  grdServer.ColWidths[3] := 50;
  grdServer.ColWidths[4] := 50;

  grdServer.RowCount := MainModule.Controller.HTTPServers.Count;
  with MainModule.Controller do
    for i := 0 to HTTPServers.Count - 1 do
    begin
      S:= HTTPServers[i].Source;
      grdServer.Cells[0, i] := S.SName;
      grdServer.Cells[1, i] := MainModule.ArrayToStr(S.DBNames, ',');
      grdServer.Cells[2, i] := S.DBHost;
      grdServer.Cells[3, i] := S.Port;
      grdServer.Cells[4, i] := S.DB;
    end;
end;


end.
