object MainForm: TMainForm
  Left = 345
  Top = 252
  Caption = 'MainForm'
  ClientHeight = 706
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object MainWindowGridpanel: TGridPanel
    Left = 8
    Top = 6
    Width = 1084
    Height = 692
    Caption = 'MainWindowGridpanel'
    ColumnCollection = <
      item
        Value = 16.445204578344950000
      end
      item
        Value = 65.780818313379830000
      end
      item
        Value = 8.222602289172466000
      end
      item
        Value = 9.551374819102763000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblAccountInfoNickname
        Row = 0
        RowSpan = 3
      end
      item
        Column = 0
        Control = strGridSonglists
        Row = 3
      end
      item
        Column = 1
        ColumnSpan = 3
        Control = strGridSongs
        Row = 2
        RowSpan = 2
      end
      item
        Column = 1
        Control = edtAddSonglist
        Row = 1
      end
      item
        Column = 2
        Control = cbbAddSonglistMusiApp
        Row = 1
      end
      item
        Column = 3
        Control = btnAddSonglistSubmit
        Row = 1
      end
      item
        Column = 3
        Control = btnUpdateAccountInfo
        Row = 0
      end
      item
        Column = 0
        Control = btnShowKnownSongs
        Row = 4
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = lblTitle
        Row = 0
      end>
    RowCollection = <
      item
        Value = 5.352387203398743000
      end
      item
        Value = 5.352387203398743000
      end
      item
        Value = 3.040693320144785000
      end
      item
        Value = 80.285808050981150000
      end
      item
        Value = 5.968724222076585000
      end>
    TabOrder = 0
    DesignSize = (
      1084
      692)
    object lblAccountInfoNickname: TLabel
      Left = 34
      Top = 30
      Width = 112
      Height = 37
      Alignment = taCenter
      Anchors = []
      Caption = #24403#21069#26165#31216
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 64
      ExplicitTop = 41
    end
    object strGridSonglists: TStringGrid
      Left = 6
      Top = 105
      Width = 167
      Height = 536
      Anchors = []
      ColCount = 1
      DefaultColWidth = 140
      DefaultRowHeight = 50
      FixedCols = 0
      RowCount = 10
      FixedRows = 0
      PopupMenu = pmSonglistAlter
      TabOrder = 0
      OnClick = strGridSonglistsClick
      OnDblClick = strGridSonglistsDblClick
    end
    object strGridSongs: TStringGrid
      Left = 186
      Top = 84
      Width = 890
      Height = 557
      Anchors = []
      ColCount = 3
      DefaultRowHeight = 30
      FixedColor = clSkyBlue
      FixedCols = 0
      RowCount = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PopupMenu = pmSongAlter
      TabOrder = 1
      OnDblClick = strGridSongsDblClick
      ColWidths = (
        422
        188
        237)
    end
    object edtAddSonglist: TEdit
      Left = 186
      Top = 45
      Width = 698
      Height = 23
      Anchors = []
      TabOrder = 2
      TextHint = #36755#20837#33258#24314#27468#21333#21517#23383#25110#20854#20182#38899#20048'App'#30340#27468#21333#32534#21495
    end
    object cbbAddSonglistMusiApp: TComboBox
      Left = 898
      Top = 45
      Width = 74
      Height = 23
      Anchors = []
      TabOrder = 3
      TextHint = 'App'
      OnDropDown = cbbAddSonglistMusiAppDropDown
    end
    object btnAddSonglistSubmit: TButton
      Left = 986
      Top = 44
      Width = 90
      Height = 25
      Anchors = []
      Caption = #21019#24314#27468#21333
      TabOrder = 4
      OnClick = btnAddSonglistSubmitClick
    end
    object btnUpdateAccountInfo: TButton
      Left = 986
      Top = 7
      Width = 90
      Height = 25
      Anchors = []
      Caption = #20462#25913#36134#21495#20449#24687
      TabOrder = 5
      OnClick = btnUpdateAccountInfoClick
    end
    object btnShowKnownSongs: TButton
      Left = 7
      Top = 658
      Width = 165
      Height = 25
      Anchors = []
      Caption = #25152#26377#24050#30693#27468#26354
      TabOrder = 6
      OnClick = btnShowKnownSongsClick
    end
    object lblTitle: TLabel
      Left = 469
      Top = 9
      Width = 220
      Height = 21
      Anchors = []
      Caption = #36328#38899#20048'App'#27468#21333#31649#29702#22120
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = #20223#23435
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 479
      ExplicitTop = 10
    end
  end
  object pmSongAlter: TPopupMenu
    Left = 568
    Top = 470
  end
  object pmSonglistAlter: TPopupMenu
    Left = 72
    Top = 478
  end
end
