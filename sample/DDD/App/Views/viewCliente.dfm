inherited FormViewCliente: TFormViewCliente
  Caption = 'FormViewCliente'
  ClientHeight = 467
  ExplicitHeight = 506
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgPrincipal: TPageControl
    Height = 426
    ExplicitHeight = 426
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 398
      inherited grdEntity: TDBGrid
        Top = 57
        Height = 341
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            ImeName = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Nome'
            ImeName = 'Nome'
            Width = 364
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RG'
            ImeName = 'RG'
            Width = 105
            Visible = True
          end>
      end
      inherited Panel2: TPanel
        Height = 57
        ExplicitHeight = 57
        object Label7: TLabel [0]
          Left = 143
          Top = 4
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object Label8: TLabel [1]
          Left = 7
          Top = 4
          Width = 11
          Height = 13
          Caption = 'ID'
        end
        inherited Edit1: TEdit
          Left = 143
          Top = 19
          Width = 234
          ExplicitLeft = 143
          ExplicitTop = 19
          ExplicitWidth = 234
        end
        object Button4: TButton
          Left = 383
          Top = 17
          Width = 63
          Height = 25
          Caption = 'pesquisar'
          TabOrder = 1
          OnClick = Button4Click
        end
        object Edit2: TEdit
          Left = 7
          Top = 19
          Width = 50
          Height = 21
          TabOrder = 2
        end
        object Button5: TButton
          Left = 63
          Top = 17
          Width = 63
          Height = 25
          Caption = 'pesquisar'
          TabOrder = 3
          OnClick = Button5Click
        end
      end
    end
    inherited TabSheet2: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 398
      object Label2: TLabel
        Left = 10
        Top = 16
        Width = 70
        Height = 13
        Caption = 'Raz'#227'o social'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 8
        Top = 111
        Width = 20
        Height = 13
        Caption = 'CPF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 8
        Top = 161
        Width = 36
        Height = 13
        Caption = 'Renda'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 10
        Top = 210
        Width = 16
        Height = 13
        Caption = 'RG'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 10
        Top = 64
        Width = 83
        Height = 13
        Caption = 'Nome Fantasia'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 10
        Top = 347
        Width = 30
        Height = 13
        Caption = 'Email'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtRenda: TEdit
        Left = 8
        Top = 178
        Width = 121
        Height = 21
        TabOrder = 6
      end
      object edtRG: TEdit
        Left = 8
        Top = 227
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edtNome: TEdit
        Left = 8
        Top = 31
        Width = 281
        Height = 21
        TabOrder = 1
      end
      object edtNomeFantasia: TEdit
        Left = 8
        Top = 79
        Width = 281
        Height = 21
        TabOrder = 2
      end
      object DataNascimento: TDateTimePicker
        Left = 8
        Top = 262
        Width = 121
        Height = 21
        Date = 42135.604163750000000000
        Time = 42135.604163750000000000
        TabOrder = 3
      end
      object Ativo: TCheckBox
        Left = 8
        Top = 293
        Width = 97
        Height = 17
        Caption = 'Ativo'
        TabOrder = 4
      end
      object cboSituacao: TComboBox
        Left = 8
        Top = 320
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object rdgTipo: TRadioGroup
        Left = 144
        Top = 248
        Width = 185
        Height = 97
        Caption = 'Tipo'
        TabOrder = 7
      end
      object Observacao: TMemo
        Left = 345
        Top = 256
        Width = 296
        Height = 89
        Lines.Strings = (
          'Observacao')
        TabOrder = 8
      end
      object edtCPFCNPJ: TMaskEdit
        Left = 8
        Top = 130
        Width = 117
        Height = 21
        TabOrder = 9
        Text = ''
      end
      object edtEmail: TEdit
        Left = 8
        Top = 366
        Width = 281
        Height = 21
        TabOrder = 10
      end
    end
  end
  inherited Panel1: TPanel
    Top = 426
    ExplicitTop = 426
    inherited btnNew: TButton
      Left = 201
      ExplicitLeft = 201
    end
    inherited btnEdit: TButton
      Left = 135
      ExplicitLeft = 135
    end
    inherited btnRemove: TButton
      Left = 273
      ExplicitLeft = 273
    end
    inherited btnPost: TButton
      Left = 345
      ExplicitLeft = 345
    end
    inherited btnCancel: TButton
      Left = 415
      Width = 68
      ExplicitLeft = 415
      ExplicitWidth = 68
    end
    inherited btnApply: TButton
      Left = 489
      ExplicitLeft = 489
    end
    inherited Button2: TButton
      Width = 78
      ExplicitWidth = 78
    end
    inherited Button3: TButton
      Left = 71
      ExplicitLeft = 71
    end
  end
  inherited dsEntity: TDataSource
    Left = 184
    Top = 144
  end
end
