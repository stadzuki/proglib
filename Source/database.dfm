object db: Tdb
  Left = 0
  Top = 0
  Caption = 'db'
  ClientHeight = 202
  ClientWidth = 447
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
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=stadzuki.myspt.ru'
      'CharacterSet=utf8'
      'DriverID=MySQL')
    Left = 32
    Top = 8
  end
  object QueryReg: TFDQuery
    Connection = FDConnection1
    Left = 16
    Top = 80
  end
  object QueryTheme: TFDQuery
    Connection = FDConnection1
    Left = 80
    Top = 80
  end
  object QueryAuth: TFDQuery
    Connection = FDConnection1
    Left = 144
    Top = 80
  end
  object QueryAdmin: TFDQuery
    Connection = FDConnection1
    Left = 208
    Top = 80
  end
  object QueryContent: TFDQuery
    Connection = FDConnection1
    Left = 280
    Top = 80
  end
  object QueryLoadContent: TFDQuery
    Connection = FDConnection1
    Left = 368
    Top = 80
  end
  object QueryPage: TFDQuery
    Connection = FDConnection1
    Left = 16
    Top = 136
  end
  object QueryPageInfo: TFDQuery
    Connection = FDConnection1
    Left = 88
    Top = 136
  end
  object QueryInsertComment: TFDQuery
    Connection = FDConnection1
    Left = 168
    Top = 136
  end
end
