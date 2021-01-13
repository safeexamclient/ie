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
    ServerIP : String;       //������ַ
    ProjName : String;       //��������
    LockScreen : String;     //�Ƿ�����
    Password : String;       //ǿ���˳�����
    ExitStr : String;        //���Խ�����ַ�����ַ�

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

  //�ж��Ƿ�����
  if(LockScreen = 'ON') then
  begin
    UHook.HookStart;
    Self.BorderStyle := bsNone;
    Label2.Visible := True;
    //WINXP��״̬������
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
  Label3.Caption := 'Local��'+ U_Fun.Fun_LocalIP;
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

//�ر�WEB������Ҽ�����
procedure TFrmMain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = wm_rbuttondown) or (Msg.message = wm_rbuttonup) or
    (msg.message = WM_RBUTTONDBLCLK)   then
  begin
    if IsChild(Webbrowser1.Handle, Msg.hwnd) then
      Handled := true;//�������������������
  end;
end;

//˫��������ʾ���֣���ʾ�˳���ť
procedure TFrmMain.Label2DblClick(Sender: TObject);
begin
  BitBtn1.Visible := true;
  Edit1.Visible := true;
end;

//�����������ļ�
procedure TFrmMain.ReadIniFile();
var
  Inifile: TIniFile;
begin
  Inifile := TIniFile.Create(ExtractFilePath(ParamStr(0))+'Exam.ini');
  ServerIP := Inifile.ReadString('Config', 'URL', 'http://www.safeexamclient.com');   //������ַ��Ĭ���ǹ���
  ProjName := Inifile.ReadString('Config', 'NAME', '��ȫ���Կͻ���');                 //�������ƣ�Ĭ���ǲ�Ʒ��
  LockScreen := Inifile.ReadString('Config', 'LOCK', 'ON');                           //�Ƿ�������Ĭ���ǿ���
  Password := Inifile.ReadString('Config', 'PASSWORD', '781026');                     //ǿ���˳����룬Ĭ����781026
  ExitStr := Inifile.ReadString('Config', 'EXITSTR', '******');                       //���Խ�����ַ�����ַ���Ĭ���������˳���һ�㲻��ʾ
  Inifile.Free;
end;

//��������Զ��ǰ��
procedure TFrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle:=Params.ExStyle or WS_EX_TOPMOST;
  Params.WndParent:=GetDesktopWindow();
end;

//��ʾ״̬��
procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

//�˳�ϵͳ
procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
  if( Edit1.Text = Password) then
    Application.Terminate;
end;

//��ѭ�������˳���ť
procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  BitBtn1.Visible := false;
  Edit1.Visible := false;
end;

//��ѯ��ǰ��ַ�е�����������жϿ����Ƿ��ѽ���
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
