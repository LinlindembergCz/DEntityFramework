object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 479
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    449
    479)
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 8
    Top = 296
    Width = 433
    Height = 129
    Anchors = [akLeft, akRight, akBottom]
    Lines.Strings = (
      'mmo1')
    TabOrder = 0
  end
  object btn1: TButton
    Left = 176
    Top = 442
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
  object dbgrd1: TDBGrid
    Left = 8
    Top = 8
    Width = 433
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    Left = 216
    Top = 88
  end
end
