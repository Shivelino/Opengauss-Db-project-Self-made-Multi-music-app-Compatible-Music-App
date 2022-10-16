object UpdateAccountInfoForm: TUpdateAccountInfoForm
  Left = 0
  Top = 0
  Caption = 'UpdateAccountInfoForm'
  ClientHeight = 135
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblUpdatePassword: TLabel
    Left = 8
    Top = 8
    Width = 52
    Height = 15
    Caption = #20462#25913#23494#30721
  end
  object lblUpdateNickname: TLabel
    Left = 8
    Top = 80
    Width = 52
    Height = 15
    Caption = #20462#25913#26165#31216
  end
  object edtPassword: TEdit
    Left = 8
    Top = 29
    Width = 185
    Height = 23
    TabOrder = 0
    TextHint = #26032#23494#30721
  end
  object edtNickname: TEdit
    Left = 8
    Top = 101
    Width = 185
    Height = 23
    TabOrder = 1
    TextHint = #26032#26165#31216
  end
  object btnUpdatePassword: TButton
    Left = 216
    Top = 28
    Width = 75
    Height = 25
    Caption = #20462#25913
    TabOrder = 2
    OnClick = btnUpdatePasswordClick
  end
  object btnUpdateNickname: TButton
    Left = 216
    Top = 100
    Width = 75
    Height = 25
    Caption = #20462#25913
    TabOrder = 3
    OnClick = btnUpdateNicknameClick
  end
end
