object LoginForm: TLoginForm
  Left = 0
  Top = 0
  Caption = 'LoginForm'
  ClientHeight = 360
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblTitle: TLabel
    Left = 56
    Top = 40
    Width = 453
    Height = 35
    Alignment = taCenter
    Caption = #36328#38899#20048'App'#27468#21333#31649#29702#22120#23458#25143#31471
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnLogin: TButton
    Left = 168
    Top = 240
    Width = 209
    Height = 73
    Caption = #30331#24405
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = btnLoginClick
  end
  object edtAccount: TEdit
    Left = 168
    Top = 128
    Width = 209
    Height = 45
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TextHint = #35831#36755#20837#36134#21495
  end
  object edtPassword: TEdit
    Left = 168
    Top = 179
    Width = 209
    Height = 45
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    TextHint = #35831#36755#20837#23494#30721
  end
  object btnSignUp: TButton
    Left = 432
    Top = 256
    Width = 121
    Height = 40
    Caption = #27880#20876#26032#29992#25143
    TabOrder = 3
    OnClick = btnSignUpClick
  end
  object btnAdmin: TButton
    Left = 432
    Top = 303
    Width = 121
    Height = 42
    Caption = #31649#29702#21592#31649#29702
    TabOrder = 4
    OnClick = btnAdminClick
  end
  object edthost: TEdit
    Left = 8
    Top = 284
    Width = 121
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TextHint = #36755#20837#26381#21153#22120'ip'
  end
  object btnAddHost: TButton
    Left = 8
    Top = 319
    Width = 121
    Height = 40
    Caption = #35774#32622#26381#21153#22120'ip'
    TabOrder = 6
    OnClick = btnAddHostClick
  end
end
