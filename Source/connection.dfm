object data_module: Tdata_module
  Left = 0
  Top = 0
  Caption = 'data_module'
  ClientHeight = 222
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MyConnection1: TMyConnection
    Left = 344
    Top = 120
  end
  object MyQuery1: TMyQuery
    Connection = MyConnection1
    Left = 344
    Top = 48
  end
  object themeQuery: TMyQuery
    Connection = MyConnection1
    Left = 264
    Top = 72
  end
end
