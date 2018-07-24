inherited FormViewFabricante: TFormViewFabricante
  Caption = 'FormViewFabricante'
  ExplicitWidth = 687
  ExplicitHeight = 423
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgPrincipal: TPageControl
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 316
    end
    inherited TabSheet2: TTabSheet
      ExplicitLeft = 8
      ExplicitTop = 28
      ExplicitWidth = 663
      ExplicitHeight = 316
      object Label1: TLabel
        Left = 3
        Top = 43
        Width = 25
        Height = 13
        Caption = 'CNPJ'
      end
      object Label2: TLabel
        Left = 3
        Top = 91
        Width = 60
        Height = 13
        Caption = 'Razao Social'
      end
      object Label7: TLabel
        Left = 352
        Top = 40
        Width = 269
        Height = 25
        Caption = 'S'#243' os FORTES entender'#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CNPJ: TEdit
        Left = 88
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'CNPJ'
      end
      object RazaoSocial: TEdit
        Left = 88
        Top = 88
        Width = 401
        Height = 21
        TabOrder = 1
        Text = 'Edit2'
      end
    end
  end
end
