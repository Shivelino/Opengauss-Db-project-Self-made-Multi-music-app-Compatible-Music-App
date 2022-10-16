object AdminForm: TAdminForm
  Left = 0
  Top = 0
  Caption = 'AdminForm'
  ClientHeight = 441
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 15
  object lblAdminLogin: TLabel
    Left = 208
    Top = 8
    Width = 182
    Height = 32
    Caption = #31649#29702#21592#36134#25143#30331#24405
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtAdminPassword: TEdit
    Left = 240
    Top = 59
    Width = 121
    Height = 23
    TabOrder = 0
    TextHint = #31649#29702#21592#23494#30721
  end
  object btnAdminLogin: TButton
    Left = 462
    Top = 58
    Width = 98
    Height = 25
    Caption = #30331#24405
    TabOrder = 1
    OnClick = btnAdminLoginClick
  end
  object strGridUsers: TStringGrid
    Left = 24
    Top = 96
    Width = 536
    Height = 337
    ColCount = 3
    FixedCols = 0
    PopupMenu = pmUsers
    TabOrder = 2
    OnDblClick = strGridUsersDblClick
    ColWidths = (
      136
      158
      183)
  end
  object edtAdminUser: TEdit
    Left = 24
    Top = 59
    Width = 121
    Height = 23
    TabOrder = 3
    TextHint = #31649#29702#21592#29992#25143#21517
  end
  object pmUsers: TPopupMenu
    Left = 280
    Top = 256
  end
end
