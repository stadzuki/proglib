object admin_control: Tadmin_control
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'admin_control'
  ClientHeight = 337
  ClientWidth = 550
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
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 145
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1085#1090#1077#1085#1090
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 373
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 1
    Text = #1055#1086#1080#1089#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object Button2: TButton
    Left = 500
    Top = 8
    Width = 42
    Height = 25
    Caption = #1087#1086#1080#1089#1082
    TabOrder = 2
  end
  object choose_type: TComboBox
    Left = 8
    Top = 48
    Width = 145
    Height = 21
    TabOrder = 3
    Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1082#1086#1085#1090#1077#1085#1090#1072
    Items.Strings = (
      'book'
      'program'
      'lib'
      'cheat')
  end
  object src_upload: TButton
    Left = 8
    Top = 240
    Width = 145
    Height = 25
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1087#1091#1090#1100' '#1082' '#1092#1086#1090#1086
    TabOrder = 4
    OnClick = src_uploadClick
  end
  object link: TEdit
    Left = 8
    Top = 280
    Width = 145
    Height = 21
    TabOrder = 5
    Text = #1057#1089#1099#1083#1082#1072' '#1085#1072' '#1089#1082#1072#1095#1080#1074#1072#1085#1080#1077
    OnClick = linkClick
  end
  object Button4: TButton
    Left = 373
    Top = 46
    Width = 169
    Height = 25
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077
    TabOrder = 6
  end
  object Button5: TButton
    Left = 487
    Top = 163
    Width = 55
    Height = 25
    Caption = #1047#1072#1073#1072#1085#1080#1090#1100
    TabOrder = 7
  end
  object Edit4: TEdit
    Left = 373
    Top = 165
    Width = 108
    Height = 21
    TabOrder = 8
    Text = #1047#1072#1073#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1085#1072'...'
  end
  object Button6: TButton
    Left = 373
    Top = 86
    Width = 169
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    TabOrder = 9
  end
  object Button7: TButton
    Left = 373
    Top = 126
    Width = 169
    Height = 25
    Caption = #1042#1099#1076#1072#1090#1100' '#1087#1088#1072#1074#1072' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072
    TabOrder = 10
  end
  object Button8: TButton
    Left = 373
    Top = 280
    Width = 169
    Height = 49
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 11
    OnClick = Button8Click
  end
  object cContent: TButton
    Left = 8
    Top = 307
    Width = 145
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 12
    OnClick = cContentClick
  end
  object c_title: TRichEdit
    Left = 8
    Top = 75
    Width = 145
    Height = 46
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      #1042#1074#1077#1076#1080#1090#1077' '#1079#1072#1075#1086#1083#1086#1074#1086#1082)
    ParentFont = False
    TabOrder = 13
    Zoom = 100
    OnClick = c_titleClick
  end
  object c_description: TRichEdit
    Left = 8
    Top = 127
    Width = 145
    Height = 89
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      #1042#1074#1077#1076#1080#1090#1077' '#1086#1087#1080#1089#1072#1085#1080#1077)
    ParentFont = False
    TabOrder = 14
    Zoom = 100
    OnClick = c_descriptionClick
  end
  object upload: TOpenPictureDialog
    Left = 176
    Top = 16
  end
  object SavePictureDialog1: TSavePictureDialog
    Left = 176
    Top = 80
  end
end
