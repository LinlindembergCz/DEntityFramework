object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 557
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 0
  end
  object panelButtons: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 557
    Align = alLeft
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 1
    object buttonGetDataSet: TButton
      Left = 14
      Top = 31
      Width = 120
      Height = 25
      Caption = 'ToDataSet'
      TabOrder = 0
      OnClick = buttonGetDataSetClick
    end
    object buttonGetSQL: TButton
      Left = 14
      Top = 217
      Width = 120
      Height = 25
      Caption = 'BuildQuery'
      TabOrder = 1
      OnClick = buttonGetSQLClick
    end
    object buttonGetEntity: TButton
      Left = 14
      Top = 83
      Width = 120
      Height = 25
      Caption = 'Find'
      TabOrder = 2
      OnClick = buttonGetEntityClick
    end
    object Button2: TButton
      Left = 14
      Top = 407
      Width = 120
      Height = 25
      Caption = 'ToJson'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 14
      Top = 436
      Width = 120
      Height = 25
      Caption = 'FromJson'
      Enabled = False
      TabOrder = 4
      OnClick = Button3Click
    end
    object Button5: TButton
      Left = 14
      Top = 136
      Width = 120
      Height = 25
      Caption = 'Include/Single'
      TabOrder = 5
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 161
      Top = 4
      Width = 120
      Height = 25
      Caption = 'Add'
      TabOrder = 6
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 161
      Top = 85
      Width = 120
      Height = 25
      Caption = 'Update'
      TabOrder = 7
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 161
      Top = 166
      Width = 120
      Height = 25
      Caption = 'Remove'
      TabOrder = 8
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 14
      Top = 110
      Width = 120
      Height = 25
      Caption = 'ToList + ForEach'
      TabOrder = 9
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 161
      Top = 31
      Width = 120
      Height = 25
      Caption = 'Add Range'
      TabOrder = 10
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 161
      Top = 112
      Width = 120
      Height = 25
      Caption = 'Update  Range'
      Enabled = False
      TabOrder = 11
    end
    object Button12: TButton
      Left = 161
      Top = 139
      Width = 120
      Height = 25
      Caption = 'Remove  Range'
      TabOrder = 12
      OnClick = Button12Click
    end
    object Button13: TButton
      Left = 14
      Top = 190
      Width = 120
      Height = 25
      Caption = 'FromSQL'
      TabOrder = 13
      OnClick = Button13Click
    end
    object Button14: TButton
      Left = 161
      Top = 59
      Width = 120
      Height = 25
      Caption = 'AddScript'
      TabOrder = 14
      OnClick = Button14Click
    end
    object Button15: TButton
      Left = 14
      Top = 379
      Width = 120
      Height = 25
      Caption = 'Any'
      TabOrder = 15
      OnClick = Button15Click
    end
    object Button16: TButton
      Left = 14
      Top = 243
      Width = 120
      Height = 25
      Caption = 'Count'
      TabOrder = 16
      OnClick = Button16Click
    end
    object Button17: TButton
      Left = 14
      Top = 270
      Width = 120
      Height = 25
      Caption = 'Sum'
      TabOrder = 17
      OnClick = Button17Click
    end
    object Button18: TButton
      Left = 14
      Top = 297
      Width = 120
      Height = 25
      Caption = 'Min'
      TabOrder = 18
      OnClick = Button18Click
    end
    object Button19: TButton
      Left = 14
      Top = 324
      Width = 120
      Height = 25
      Caption = 'Max'
      TabOrder = 19
      OnClick = Button19Click
    end
    object Button20: TButton
      Left = 14
      Top = 352
      Width = 120
      Height = 25
      Caption = 'Avg'
      TabOrder = 20
      OnClick = Button20Click
    end
    object Button21: TButton
      Left = 14
      Top = 4
      Width = 120
      Height = 25
      Caption = 'Migration'
      TabOrder = 21
      OnClick = Button21Click
    end
    object Button4: TButton
      Left = 14
      Top = 163
      Width = 120
      Height = 25
      Caption = 'Entry/Load'
      TabOrder = 22
      OnClick = Button4Click
    end
    object Button23: TButton
      Left = 161
      Top = 193
      Width = 120
      Height = 25
      Caption = 'Import with ArrayDML'
      TabOrder = 23
      OnClick = Button23Click
    end
    object chkOffOline: TCheckBox
      Left = 14
      Top = 62
      Width = 97
      Height = 17
      Caption = 'OffLine'
      TabOrder = 24
      OnClick = chkOffOlineClick
    end
  end
  object Panel2: TPanel
    Left = 289
    Top = 0
    Width = 633
    Height = 557
    Align = alClient
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 376
      Height = 317
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
    end
    object mLog: TMemo
      Left = 0
      Top = 317
      Width = 629
      Height = 236
      Align = alBottom
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Panel1: TPanel
      Left = 376
      Top = 0
      Width = 253
      Height = 317
      Align = alRight
      TabOrder = 2
      object Label1: TLabel
        Left = 16
        Top = 4
        Width = 75
        Height = 19
        Caption = 'DataBind'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtNome: TLabeledEdit
        Left = 16
        Top = 100
        Width = 217
        Height = 21
        CharCase = ecUpperCase
        EditLabel.Width = 27
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome'
        TabOrder = 0
      end
      object edtId: TLabeledEdit
        Left = 16
        Top = 60
        Width = 49
        Height = 21
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        EditLabel.Width = 11
        EditLabel.Height = 13
        EditLabel.Caption = 'ID'
        ReadOnly = True
        TabOrder = 1
        Text = '0'
      end
      object edtCPF: TLabeledEdit
        Left = 16
        Top = 141
        Width = 217
        Height = 21
        EditLabel.Width = 19
        EditLabel.Height = 13
        EditLabel.Caption = 'CPF'
        TabOrder = 2
      end
      object btnRefresh: TButton
        Left = 199
        Top = 179
        Width = 49
        Height = 25
        Caption = 'Refresh'
        TabOrder = 3
        OnClick = btnRefreshClick
      end
      object Button22: TButton
        Left = 18
        Top = 179
        Width = 49
        Height = 25
        Caption = 'Update'
        TabOrder = 4
        OnClick = Button22Click
      end
    end
    object BindNavigator1: TBindNavigator
      Left = 444
      Top = 179
      Width = 132
      Height = 25
      DataSource = PrototypeBindSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Orientation = orHorizontal
      TabOrder = 3
    end
  end
  object DataSource1: TDataSource
    Left = 376
    Top = 104
  end
  object PrototypeBindSource1: TPrototypeBindSource
    AutoActivate = True
    AutoPost = False
    FieldDefs = <
      item
        Name = 'ID'
        FieldType = ftInteger
        ReadOnly = False
      end
      item
        Name = 'Nome'
        ReadOnly = False
      end
      item
        Name = 'CPFCNPJ'
        ReadOnly = False
      end>
    ScopeMappings = <>
    OnCreateAdapter = PrototypeBindSource1CreateAdapter
    Left = 377
    Top = 168
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 380
    Top = 229
    object LinkControlToField1: TLinkControlToField
      Category = 'Quick Bindings'
      DataSource = PrototypeBindSource1
      FieldName = 'ID'
      Control = edtId
      Track = True
    end
    object LinkControlToField2: TLinkControlToField
      Category = 'Quick Bindings'
      DataSource = PrototypeBindSource1
      FieldName = 'Nome'
      Control = edtNome
      Track = True
    end
    object LinkControlToField3: TLinkControlToField
      Category = 'Quick Bindings'
      DataSource = PrototypeBindSource1
      FieldName = 'CPFCNPJ'
      Control = edtCPF
      Track = True
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'CSV'
    Filter = 'CSV|*.csv|TXT|*.txt'
    Left = 384
    Top = 296
  end
end
