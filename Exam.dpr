program Exam;

uses
  Forms,
  UMain in 'UMain.pas' {FrmMain},
  UHook in 'UHook.pas',
  U_Fun in 'U_Fun.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '安全考试客户端';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
