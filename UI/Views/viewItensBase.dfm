inherited FormViewItensBase: TFormViewItensBase
  Caption = 'FormViewItensBase'
  ClientWidth = 633
  ExplicitWidth = 649
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgPrincipal: TPageControl
    Width = 633
    ExplicitWidth = 633
    inherited TabSheet1: TTabSheet
      ExplicitWidth = 625
      inherited grdEntity: TDBGrid
        Width = 625
      end
      inherited Panel2: TPanel
        Width = 625
        ExplicitWidth = 625
      end
    end
    inherited TabSheet2: TTabSheet
      OnShow = TabSheet2Show
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 625
      ExplicitHeight = 316
      object pnlItens: TPanel
        Left = 40
        Top = 34
        Width = 577
        Height = 64
        TabOrder = 0
        object Label3: TLabel
          Left = 4
          Top = 14
          Width = 48
          Height = 13
          Caption = 'IdProduto'
        end
        object Label4: TLabel
          Left = 304
          Top = 14
          Width = 56
          Height = 13
          Caption = 'Quantidade'
        end
        object Quantidade: TEdit
          Left = 304
          Top = 33
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object Button4: TButton
          Left = 536
          Top = 31
          Width = 25
          Height = 25
          Caption = '-'
          TabOrder = 1
          OnClick = Button4Click
        end
        object cboIdProduto: TDBLookupComboBox
          Left = 4
          Top = 33
          Width = 292
          Height = 21
          KeyField = 'Id'
          ListField = 'Descricao'
          ListSource = srcProdutos
          TabOrder = 2
        end
        object Button5: TButton
          Left = 505
          Top = 31
          Width = 27
          Height = 25
          Caption = '+'
          TabOrder = 3
          OnClick = Button5Click
        end
      end
      object grdItens: TDBGrid
        Left = 40
        Top = 104
        Width = 577
        Height = 185
        DataSource = dsEntityItens
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  inherited Panel1: TPanel
    Width = 633
    ExplicitWidth = 633
    inherited btnApply: TButton
      Left = 475
      Width = 56
      Caption = 'Apply'
      ExplicitLeft = 475
      ExplicitWidth = 56
    end
    inherited Button2: TButton
      Left = 537
      ExplicitLeft = 537
    end
  end
  inherited dsEntity: TDataSource
    Left = 568
    Top = 32
  end
  object dsEntityItens: TDataSource
    Left = 568
    Top = 216
  end
  object srcProdutos: TDataSource
    Left = 96
    Top = 184
  end
end
