unit U_Fun;

interface

uses
  SysUtils, Messages, Dialogs, Classes, Windows, Winsock, StrUtils;

procedure HideTaskBar;
procedure ShowTaskBar;

function Fun_LocalIP():String;

implementation

//���ع�����
procedure HideTaskBar;
var
  wndHandle : THandle;
  //char���鱣������������
  wndClass : array[0..50] of Char; 
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  //��nCmdShow��ΪSW_HIDE�����ش���
  ShowWindow(wndHandle, SW_HIDE);
end;

//��ʾ������
procedure ShowTaskBar;
var
  wndHandle : THandle;
  wndClass : array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  //��nCmdShow��ΪSW_RESTORE����ʾ����
  ShowWindow(wndHandle, SW_RESTORE); 
end;

{�õ����ػ�����IP�����ж��IP��ֻȡ��һ��}
function Fun_LocalIP():String;
type  
  TaPInAddr = array [0..10] of PInAddr;  
  PaPInAddr = ^TaPInAddr;  
var  
  phe : PHostEnt;  
  pptr : PaPInAddr;  
  Buffer : array [0..63] of char;  
  I : Integer;  
  GInitData : TWSADATA;  
begin
  WSAStartup($101, GInitData);  
  Result := ' ';  
  GetHostName(Buffer, SizeOf(Buffer));  
  phe :=GetHostByName(buffer);  
  if phe = nil then Exit;  
  pptr := PaPInAddr(Phe^.h_addr_list);  
  I := 0;  
  while pptr^[I] <> nil do begin  
  if i=0  
  then result:=StrPas(inet_ntoa(pptr^[I]^))  
  else result:=result+ ', '+StrPas(inet_ntoa(pptr^[I]^));  
  Inc(I);  
  end;  
  WSACleanup;  
  //������ phe.h_name  
  //��ʱ�� result �����Ƕ��IP�ģ��� 192.168.0.1,192.168.78.1,192.168.23.9 ����Ҫȡ����һ��  
  if pos(',', result) > 0 then  
    result := LeftStr(result, pos(',', result)-1);
end;



end.
