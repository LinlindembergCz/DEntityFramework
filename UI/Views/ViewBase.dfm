object FormViewBase: TFormViewBase
  Left = 0
  Top = 0
  Caption = 'Form'
  ClientHeight = 385
  ClientWidth = 671
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pgPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 671
    Height = 344
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Pesquisa'
      object grdEntity: TDBGrid
        Left = 0
        Top = 41
        Width = 663
        Height = 275
        Align = alClient
        DataSource = dsEntity
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = grdEntityDblClick
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 663
        Height = 41
        Align = alTop
        TabOrder = 1
        object Edit1: TEdit
          Left = 7
          Top = 12
          Width = 265
          Height = 21
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 344
    Width = 671
    Height = 41
    Align = alBottom
    BevelKind = bkFlat
    BevelOuter = bvSpace
    BorderStyle = bsSingle
    TabOrder = 1
    object btnNew: TButton
      Left = 128
      Top = 2
      Width = 66
      Height = 25
      Caption = 'New'
      TabOrder = 0
      OnClick = btnNewClick
    end
    object btnEdit: TButton
      Left = 200
      Top = 2
      Width = 60
      Height = 25
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnRemove: TButton
      Left = 266
      Top = 2
      Width = 66
      Height = 25
      Caption = 'Remove'
      TabOrder = 2
      OnClick = btnRemoveClick
    end
    object btnPost: TButton
      Left = 338
      Top = 2
      Width = 64
      Height = 25
      Caption = 'Post'
      Enabled = False
      TabOrder = 3
      OnClick = btnPostClick
    end
    object btnCancel: TButton
      Left = 408
      Top = 2
      Width = 61
      Height = 25
      Caption = 'Cancel'
      Enabled = False
      TabOrder = 4
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 484
      Top = 2
      Width = 83
      Height = 25
      Caption = 'ApplyUpdates'
      Enabled = False
      TabOrder = 5
      OnClick = btnApplyClick
    end
    object Button2: TButton
      Left = 578
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Refresh'
      TabOrder = 6
    end
    object Button1: TButton
      Left = 8
      Top = 2
      Width = 50
      Height = 25
      Caption = '<'
      TabOrder = 7
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 64
      Top = 2
      Width = 58
      Height = 25
      Caption = '>'
      TabOrder = 8
      OnClick = Button3Click
    end
  end
  object dsEntity: TDataSource
    Left = 64
    Top = 168
  end
end
