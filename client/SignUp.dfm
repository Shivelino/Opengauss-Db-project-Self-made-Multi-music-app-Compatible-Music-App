object SignUpForm: TSignUpForm
  Left = 0
  Top = 0
  Caption = 'SignUp'
  ClientHeight = 506
  ClientWidth = 973
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object edtAccount: TEdit
    Left = 32
    Top = 8
    Width = 121
    Height = 23
    TabOrder = 0
    TextHint = #26032#24314#36134#21495
  end
  object edtPassword: TEdit
    Left = 225
    Top = 8
    Width = 121
    Height = 23
    TabOrder = 1
    TextHint = #23494#30721
  end
  object cbbProvinces: TComboBox
    Left = 32
    Top = 80
    Width = 145
    Height = 23
    TabOrder = 2
    TextHint = #30465#20221
    OnSelect = cbbProvincesSelect
  end
  object cbbCities: TComboBox
    Left = 225
    Top = 80
    Width = 145
    Height = 23
    TabOrder = 3
    TextHint = #22320#32423#24066
    OnSelect = cbbCitiesSelect
  end
  object cbbCounties: TComboBox
    Left = 439
    Top = 80
    Width = 145
    Height = 23
    TabOrder = 4
    TextHint = #21439
  end
  object edtNickname: TEdit
    Left = 439
    Top = 8
    Width = 121
    Height = 23
    TabOrder = 5
    TextHint = #26165#31216
  end
  object strGridMusicAppAccount: TStringGrid
    Left = 32
    Top = 152
    Width = 753
    Height = 273
    ColCount = 4
    FixedCols = 0
    RowCount = 2
    TabOrder = 6
    OnKeyDown = strGridMusicAppAccountKeyDown
    OnKeyPress = strGridMusicAppAccountKeyPress
    ColWidths = (
      127
      157
      168
      268)
  end
  object btnSubmit: TButton
    Left = 854
    Top = 456
    Width = 75
    Height = 25
    Caption = #27880#20876
    TabOrder = 7
    OnClick = btnSubmitClick
  end
  object btnInsert: TButton
    Left = 826
    Top = 240
    Width = 119
    Height = 25
    Caption = #22686#21152#19968#34892#36134#21495
    TabOrder = 8
    OnClick = btnInsertClick
  end
  object btnDelete: TButton
    Left = 826
    Top = 280
    Width = 119
    Height = 25
    Caption = #21024#38500#26411#34892#36134#21495
    TabOrder = 9
    OnClick = btnDeleteClick
  end
end
