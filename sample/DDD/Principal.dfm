object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'FormPrincipal'
  ClientHeight = 263
  ClientWidth = 357
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 244
    Width = 357
    Height = 19
    Panels = <
      item
        Text = 'Alo mundo'
        Width = 300
      end>
  end
  object Button1: TButton
    Left = 144
    Top = 80
    Width = 75
    Height = 25
    Action = Cliente
    TabOrder = 1
  end
  object ActionManager2: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Cliente
            Caption = '&Clientes'
            ImageIndex = 0
          end
          item
            Action = Action3
            Caption = '&Fornecedores'
            ImageIndex = 1
          end
          item
            Action = Action4
            Caption = 'F&abricantes'
            ImageIndex = 2
          end>
      end
      item
        Items = <
          item
            ChangesAllowed = [caModify]
            Items = <
              item
                Caption = '&ActionClientItem0'
              end>
            Caption = '&ActionClientItem0'
            KeyTip = 'F'
          end>
        AutoSize = False
      end
      item
        AutoSize = False
      end>
    Left = 160
    Top = 24
    StyleName = 'Platform Default'
    object Cliente: TAction
      Caption = 'Clientes'
      ImageIndex = 0
      OnExecute = ClienteExecute
    end
    object Action3: TAction
      Caption = 'Fornecedores'
      ImageIndex = 1
    end
    object Action4: TAction
      Caption = 'Fabricantes'
      ImageIndex = 2
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=postgres'
      'User_Name=postgres'
      'Password=master982666'
      'Server=35.198.39.52'
      'DriverID=PG')
    LoginPrompt = False
    Left = 160
    Top = 120
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'D:\Lindemberg\DEntityFramework\sample\DDD\bin\libpq.dll'
    Left = 160
    Top = 168
  end
end
