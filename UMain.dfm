object FrmMain: TFrmMain
  Left = 312
  Top = 262
  Width = 940
  Height = 518
  Caption = #32771#35797#23458#25143#31471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel_Top: TPanel
    Left = 0
    Top = 0
    Width = 924
    Height = 50
    Align = alTop
    Color = clWhite
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 161
      Height = 28
      Caption = #32771#35797#23433#20840#23458#25143#31471' '
      Font.Charset = GB2312_CHARSET
      Font.Color = clGrayText
      Font.Height = -21
      Font.Name = #24494#36719#38597#40657' Light'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 384
      Top = 12
      Width = 242
      Height = 28
      Caption = #32771#35797#32467#26463#65292#35831#20851#38381#31383#21475#65281
      Font.Charset = GB2312_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = #24494#36719#38597#40657' Light'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel_Bottom: TPanel
    Left = 0
    Top = 439
    Width = 924
    Height = 40
    Align = alBottom
    Color = clWhite
    TabOrder = 1
    object Label3: TLabel
      Left = 768
      Top = 10
      Width = 38
      Height = 16
      Caption = 'Label3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 10
      Width = 156
      Height = 13
      Caption = #25552#31034#65306#32771#35797#36807#31243#20840#31243#38145#23631#65281
      Font.Charset = GB2312_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      OnDblClick = Label2DblClick
    end
    object BitBtn1: TBitBtn
      Left = 248
      Top = 6
      Width = 57
      Height = 24
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object Edit1: TEdit
      Left = 184
      Top = 6
      Width = 57
      Height = 25
      TabOrder = 1
    end
  end
  object Panel_Main: TPanel
    Left = 0
    Top = 50
    Width = 924
    Height = 389
    Align = alClient
    TabOrder = 2
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 922
      Height = 387
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C0000004B5F0000FF2700000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 488
    Top = 8
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 416
    Top = 448
  end
  object Timer2: TTimer
    Interval = 2000
    OnTimer = Timer2Timer
    Left = 504
    Top = 448
  end
end
