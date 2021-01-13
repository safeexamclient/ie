unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, SHDocVw, Buttons, Menus, AppEvnts, IniFiles,
  Mask;

type
  TFrmMain = class(TForm)
    Panel_Top: TPanel;
    Panel_Bottom: TPanel;
    Panel_Main: TPanel;
    Label1: TLabel;
    WebBrowser1: TWebBrowser;
    Label3: TLabel;
    ApplicationEvents1: TApplicationEvents;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    Label7: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Label2DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    
  private
    { Private declarations }

  public
    { Public declarations }
    ServerIP : String;       //考试网址
    ProjName : String;       //考试名称
    LockScreen : String;     //是否锁屏
    Password : String;       //强制退出密码
    ExitStr : String;        //考试结束网址特征字符

    procedure ReadIniFile();

    procedure CreateParams(var Params:TCreateParams);override;
    
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses UHook, U_Fun;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  ReadIniFile;
  Self.Width := Screen.Width;
  Self.Height := Screen.Height;
  Self.Left := Round((Screen.Width - Self.Width)/2);
  Self.Top := Round((Screen.Height - Self.Height)/2);
  BitBtn1.Visible := false;
  Edit1.Visible := false;

  //判断是否锁屏
  if(LockScreen = 'ON') then
  begin
    UHook.HookStart;
    Self.BorderStyle := bsNone;
    Label2.Visible := True;
    //WINXP下状态栏隐藏
    SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  end
  else
  begin
    Self.BorderStyle := bsSizeable; 
    Label2.Visible := True;
  end;   
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin      
  WebBrowser1.Navigate(ServerIP);
  Label1.Top := round((Panel_Top.Height - Label1.Height)/2)-2;
  Label3.Caption := 'Local：'+ U_Fun.Fun_LocalIP;
  Label3.Left := Self.Width - 145;  
  Label7.Visible := false;
  Label7.Left := round((Self.Width - Label7.Width )/2);
  if(ProjName <> '') then
    Label1.Caption := ProjName;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UHook.HookStop;
end;

//关闭WEB窗体的右键功能
procedure TFrmMain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = wm_rbuttondown) or (Msg.message = wm_rbuttonup) or
    (msg.message = WM_RBUTTONDBLCLK)   then
  begin
    if IsChild(Webbrowser1.Handle, Msg.hwnd) then
      Handled := true;//如果有其他处理，加这里
  end;
end;

//双击左下提示文字，显示退出按钮
procedure TFrmMain.Label2DblClick(Sender: TObject);
begin
  BitBtn1.Visible := true;
  Edit1.Visible := true;
end;

//读本地配置文件
procedure TFrmMain.ReadIniFile();
var
  Inifile: TIniFile;
begin
  Inifile := TIniFile.Create(ExtractFilePath(ParamStr(0))+'Exam.ini');
  ServerIP := Inifile.ReadString('Config', 'URL', 'http://www.safeexamclient.com');   //考试网址，默认是官网
  ProjName := Inifile.ReadString('Config', 'NAME', '安全考试客户端');                 //考试名称，默认是产品名
  LockScreen := Inifile.ReadString('Config', 'LOCK', 'ON');                           //是否锁屏，默认是开启
  Password := Inifile.ReadString('Config', 'PASSWORD', '781026');                     //强制退出密码，默认是781026
  ExitStr := Inifile.ReadString('Config', 'EXITSTR', '******');                       //考试结束网址特征字符，默认是永不退出，一般不公示
  Inifile.Free;
end;

//本窗体永远在前面
procedure TFrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:=Params.ExStyle or WS_EX_TOPMOST;
  Params.WndParent:=GetDesktopWindow();
end;

//显示状态栏
procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

//退出系统
procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
  if( Edit1.Text = Password) then
    Application.Terminate;
end;

//轮循，隐藏退出按钮
procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  BitBtn1.Visible := false;
  Edit1.Visible := false;
end;

//查询当前网址中的特征这符，判断考试是否已结束
procedure TFrmMain.Timer2Timer(Sender: TObject);
begin
  if( POS(ExitStr,WebBrowser1.LocationURL) >0 ) then
  begin
    UHook.HookStop;
    SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
    Self.BorderStyle := bsSingle;
    Label7.Visible := true;
  end 
end;

end.
