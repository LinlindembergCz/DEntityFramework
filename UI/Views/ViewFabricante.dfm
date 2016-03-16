inherited FormViewFabricante: TFormViewFabricante
  Caption = 'FormViewFabricante'
  ExplicitWidth = 687
  ExplicitHeight = 424
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
      ExplicitTop = 22
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
