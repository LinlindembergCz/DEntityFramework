inherited FormViewAluno: TFormViewAluno
  Caption = 'FormViewAluno'
  ExplicitWidth = 687
  ExplicitHeight = 424
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgPrincipal: TPageControl
    ActivePage = TabSheet1
    ExplicitLeft = -8
    ExplicitTop = -6
    inherited TabSheet1: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 316
    end
    inherited TabSheet2: TTabSheet
      ExplicitLeft = 8
      ExplicitTop = 22
      ExplicitWidth = 663
      ExplicitHeight = 316
      object Label1: TLabel
        Left = 8
        Top = 48
        Width = 27
        Height = 13
        Caption = 'Nome'
      end
      object Label2: TLabel
        Left = 8
        Top = 99
        Width = 43
        Height = 13
        Caption = 'Matricula'
      end
      object edtNome: TEdit
        Left = 64
        Top = 45
        Width = 292
        Height = 21
        TabOrder = 0
        Text = 'edtNome'
      end
      object edtMatricula: TEdit
        Left = 64
        Top = 93
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'edtMatricula'
      end
    end
  end
end
