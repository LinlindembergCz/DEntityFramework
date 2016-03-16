inherited FormViewOrcamento: TFormViewOrcamento
  Caption = 'FormViewOrcamento'
  ClientHeight = 422
  ClientWidth = 664
  ExplicitWidth = 680
  ExplicitHeight = 460
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgPrincipal: TPageControl
    Width = 664
    Height = 381
    ExplicitWidth = 664
    ExplicitHeight = 381
    inherited TabSheet1: TTabSheet
      ExplicitWidth = 656
      ExplicitHeight = 353
      inherited grdEntity: TDBGrid
        Width = 656
        Height = 312
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Width = 87
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IDCliente'
            Title.Caption = 'Cod. Cliente'
            Width = 98
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Nome'
            Width = 285
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATA'
            Width = 88
            Visible = True
          end>
      end
      inherited Panel2: TPanel
        Width = 656
        ExplicitWidth = 656
      end
    end
    inherited TabSheet2: TTabSheet
      ExplicitLeft = 0
      ExplicitTop = 22
      ExplicitWidth = 656
      ExplicitHeight = 353
      object Label1: TLabel [0]
        Left = 44
        Top = 76
        Width = 161
        Height = 19
        Caption = 'Itens do Or'#231'amento'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      inherited pnlItens: TPanel
        Top = 94
        Height = 65
        ExplicitTop = 94
        ExplicitHeight = 65
        inherited Label3: TLabel
          Width = 38
          Caption = 'Produto'
          ExplicitWidth = 38
        end
        inherited Label4: TLabel
          Left = 362
          ExplicitLeft = 362
        end
        object Label5: TLabel [2]
          Left = 424
          Top = 13
          Width = 24
          Height = 13
          Caption = 'Valor'
        end
        inherited Quantidade: TEdit
          Left = 361
          Top = 29
          Width = 57
          ExplicitLeft = 361
          ExplicitTop = 29
          ExplicitWidth = 57
        end
        inherited Button4: TButton
          Left = 531
          Top = 28
          ExplicitLeft = 531
          ExplicitTop = 28
        end
        inherited cboIdProduto: TDBLookupComboBox
          Top = 29
          Width = 333
          ExplicitTop = 29
          ExplicitWidth = 333
        end
        inherited Button5: TButton
          Left = 498
          Top = 28
          ExplicitLeft = 498
          ExplicitTop = 28
        end
        object Valor: TEdit
          Left = 424
          Top = 29
          Width = 73
          Height = 21
          TabOrder = 4
          Text = '0'
        end
      end
      inherited grdItens: TDBGrid
        Top = 163
        Height = 183
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'idProduto'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Descricao'
            Width = 279
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Quantidade'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Valor'
            Visible = True
          end>
      end
      object Data: TDateTimePicker
        Left = 339
        Top = 32
        Width = 119
        Height = 21
        Date = 42143.837260289350000000
        Time = 42143.837260289350000000
        TabOrder = 2
      end
      object cboIdCliente: TDBLookupComboBox
        Left = 44
        Top = 32
        Width = 277
        Height = 21
        KeyField = 'Id'
        ListField = 'Nome'
        ListSource = srcClientes
        TabOrder = 3
      end
    end
  end
  inherited Panel1: TPanel
    Top = 381
    Width = 664
    ExplicitTop = 381
    ExplicitWidth = 664
    inherited btnNew: TButton
      Left = 142
      ExplicitLeft = 142
    end
    inherited btnEdit: TButton
      Left = 214
      ExplicitLeft = 214
    end
    inherited btnRemove: TButton
      Left = 280
      ExplicitLeft = 280
    end
    inherited btnPost: TButton
      Left = 352
      ExplicitLeft = 352
    end
    inherited btnCancel: TButton
      Left = 422
      ExplicitLeft = 422
    end
    inherited btnApply: TButton
      Left = 489
      Width = 76
      ExplicitLeft = 489
      ExplicitWidth = 76
    end
    inherited Button2: TButton
      Left = 571
      ExplicitLeft = 571
    end
    inherited Button1: TButton
      Width = 64
      ExplicitWidth = 64
    end
    inherited Button3: TButton
      Left = 78
      ExplicitLeft = 78
    end
  end
  inherited dsEntity: TDataSource
    Left = 544
    Top = 24
  end
  inherited dsEntityItens: TDataSource
    Left = 544
    Top = 248
  end
  inherited srcProdutos: TDataSource
    Left = 352
    Top = 120
  end
  object srcClientes: TDataSource
    Left = 176
    Top = 136
  end
end
