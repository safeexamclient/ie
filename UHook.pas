{
����һ���������������ܰ�

���ܣ�
    1. ����ס���ּ��̲���������DEL+CTRL+DEL��
    2. ��Ҫ���ڿ���ʱ������

ʹ�ã�
    HookStart: ��ʼ����
    HookStop ��ֹͣ����

���ߣ�ChenGuang
���£�2013-06-06
}

unit UHook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, StdCtrls, TlHelp32, Registry;
type
  tagKBDLLHOOKSTRUCT = packed record
    vkCode : DWORD;
    scanCode : DWORD;
    flags : DWORD;
    time : DWORD;
    dwExtraInfo : DWORD;
  end;
  KBDLLHOOKSTRUCT = tagKBDLLHOOKSTRUCT;
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;

const
  WH_KEYBOARD_LL = 13;
  LLKHF_ALTDOWN = $20;

  procedure HookStart;                       //�������̹���
  procedure HookStop;                        //ֹͣ���̹���
  function LowLevelKeyboardProc(nCode : Integer; WParam : WPARAM; LParam : LPARAM) : LRESULT; stdcall;  //���̹���

  {
  function KillTask(ExeFileName: string): Integer;     //�رս���
  function FindProcessId(ExeFileName: string):THandle; //���ҽ���
  procedure DisableTaskmgr(Key: Boolean);              //���������
  }

var
  hhkLowLevelKybd:HHOOK;

implementation 

//��ʼ���̹���
procedure HookStart;
begin
  if hhkLowLevelKybd=0 then
    hhkLowLevelKybd:=SetWindowsHookExW(WH_KEYBOARD_LL,LowLevelKeyboardProc, Hinstance,0);
end;

//ֹͣ���̹���
procedure HookStop;
begin
  if (hhkLowLevelKybd<>0) and UnhookWindowsHookEx(hhkLowLevelKybd) then
   hhkLowLevelKybd:=0;
end;

//�ͼ����̹���
function LowLevelKeyboardProc(nCode: Integer;WParam: WPARAM;LParam: LPARAM):LRESULT; stdcall;
var
  fEatKeystroke :   BOOL;
  p : PKBDLLHOOKSTRUCT;
begin
  Result:=0;
  fEatKeystroke:=FALSE;
  p:=PKBDLLHOOKSTRUCT(lParam);
  if (nCode=HC_ACTION) then
  begin
     case wParam of
      WM_KEYDOWN,
      WM_SYSKEYDOWN,
      WM_KEYUP,
      WM_SYSKEYUP:
      fEatKeystroke:=
        ((p.vkCode=VK_TAB) and ((p.flags and LLKHF_ALTDOWN) <> 0)) or
        ((p.vkCode=VK_ESCAPE) and ((p.flags and LLKHF_ALTDOWN) <> 0))or
        (p.vkCode=VK_Lwin) or
        (p.vkCode=VK_Rwin) or
        (p.vkCode=VK_apps) or
        ((p.vkCode=VK_ESCAPE) and ((GetKeyState(VK_CONTROL) and $8000) <> 0)) or
        ((p.vkCode=VK_F4) and ((p.flags and LLKHF_ALTDOWN) <> 0)) or
        ((p.vkCode=VK_SPACE) and ((p.flags and LLKHF_ALTDOWN) <> 0)) or
        (((p.vkCode=VK_CONTROL) and (P.vkCode = LLKHF_ALTDOWN and p.flags) and (P.vkCode=VK_Delete)))
    end;
  end;
  if fEatKeystroke=True then
    Result:=1;
  if nCode <> 0 then
    Result := CallNextHookEx(0,nCode,wParam,lParam);
end;

//��ѯ����
function FindProcessId(ExeFileName: string):THandle;
 var
   ContinueLoop:BOOL;
   FSnapshotHandle:THandle;
   FProcessEntry32:TProcessEntry32;
 begin
   result:=0;
   FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
   FProcessEntry32.dwSize:=Sizeof(FProcessEntry32);
   ContinueLoop:=Process32First(FSnapshotHandle,FProcessEntry32);
   while integer(ContinueLoop)<>0 do
   begin
     if UpperCase(FProcessEntry32.szExeFile)=UpperCase(ExeFileName) then
     begin
       result:=FProcessEntry32.th32ProcessID;
       break;
     end;
     ContinueLoop:=Process32Next(FSnapshotHandle,FProcessEntry32);
   end;
   CloseHandle (FSnapshotHandle);
 end;

//ɱ������
function KillTask(ExeFileName: string): Integer;
 const
   PROCESS_TERMINATE = $0001;
 var
   ContinueLoop: boolean;
   FSnapshotHandle: THandle;
   FProcessEntry32: TProcessEntry32;
 begin
   Result := 0;
   FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
   ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

   while Integer(ContinueLoop) <> 0 do
   begin
     if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
       UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
       UpperCase(ExeFileName))) then
     Result := Integer(TerminateProcess(
     OpenProcess(PROCESS_TERMINATE,
     BOOL(0),
     FProcessEntry32.th32ProcessID),
     0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
   end;
   CloseHandle(FSnapshotHandle);
end;

//������������Ĳ���
procedure DisableTaskmgr(Key: Boolean);
Var
  Reg:TRegistry;
Begin
  Reg:=TRegistry.Create(KEY_WRITE and KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System', True) then
    begin
      if Key then
        Reg.WriteString('DisableTaskMgr','1')
      else
        Reg.WriteInteger('DisableTaskMgr',0);
      Reg.CloseKey;
    end;
  except
    Reg.Free;
  end;
end;

end.
