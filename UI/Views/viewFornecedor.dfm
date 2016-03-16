inherited FormViewFornecedor: TFormViewFornecedor
  Caption = 'FormViewFornecedor'
  ExplicitWidth = 687
  ExplicitHeight = 424
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgPrincipal: TPageControl
    ActivePage = TabSheet1
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 316
    end
    inherited TabSheet2: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 316
      object Label1: TLabel
        Left = 3
        Top = 19
        Width = 30
        Height = 13
        Caption = 'Razao'
      end
      object Label2: TLabel
        Left = 3
        Top = 59
        Width = 25
        Height = 13
        Caption = 'CNPJ'
      end
      object Label7: TLabel
        Left = 3
        Top = 99
        Width = 45
        Height = 13
        Caption = 'Endereco'
      end
      object edtRazaoSocial: TEdit
        Left = 67
        Top = 16
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edtCNPJ: TEdit
        Left = 67
        Top = 56
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object edtEndereco: TEdit
        Left = 67
        Top = 96
        Width = 121
        Height = 21
        TabOrder = 2
      end
    end
  end
end
