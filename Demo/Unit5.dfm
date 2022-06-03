object Form5: TForm5
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Demo - Leitor arquivo .ofx'
  ClientHeight = 534
  ClientWidth = 1166
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
  object lblCredito: TLabel
    Left = 866
    Top = 83
    Width = 91
    Height = 18
    Alignment = taRightJustify
    Caption = 'Creditos: 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    StyleElements = [seBorder]
  end
  object lblDebito: TLabel
    Left = 1066
    Top = 83
    Width = 87
    Height = 18
    Alignment = taRightJustify
    Caption = 'D'#233'bitos: 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    StyleElements = [seBorder]
  end
  object Label1: TLabel
    Left = 906
    Top = 67
    Width = 51
    Height = 13
    Caption = 'CREDITOS'
  end
  object Label2: TLabel
    Left = 1110
    Top = 67
    Width = 43
    Height = 13
    Caption = 'DEBITOS'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 110
    Width = 844
    Height = 416
    Cursor = crHandPoint
    DataSource = dsOFX
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'INDEX'
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ID'
        Width = 359
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DOCUMENT'
        Width = 74
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MOVDATE'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MOVTYPE'
        Title.Caption = 'TP'
        Width = 25
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALUE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRIPTION'
        Width = 158
        Visible = True
      end>
  end
  object Edit1: TEdit
    Left = 8
    Top = 75
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'c:\temp\extrato.ofx'
  end
  object Button1: TButton
    Left = 135
    Top = 74
    Width = 114
    Height = 25
    Cursor = crHandPoint
    Caption = 'Ler Arquivo .OFX'
    TabOrder = 2
    OnClick = Button1Click
  end
  object cboTipos: TComboBox
    Left = 255
    Top = 75
    Width = 217
    Height = 21
    Cursor = crHandPoint
    Style = csDropDownList
    TabOrder = 3
  end
  object Button2: TButton
    Left = 478
    Top = 73
    Width = 114
    Height = 25
    Cursor = crHandPoint
    Caption = 'Filtrar'
    TabOrder = 4
    OnClick = Button2Click
  end
  object DBGrid2: TDBGrid
    Left = 855
    Top = 110
    Width = 298
    Height = 416
    Cursor = crHandPoint
    DataSource = dsTipos
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid2DrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'TIPO'
        Width = 172
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MOVTYPE'
        Title.Caption = 'TP'
        Width = 19
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR'
        Width = 71
        Visible = True
      end>
  end
  object Button3: TButton
    Left = 598
    Top = 73
    Width = 114
    Height = 25
    Cursor = crHandPoint
    Caption = 'Desfazer Filtro'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 2
    Width = 1145
    Height = 60
    Alignment = taCenter
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = 16250871
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 7
  end
  object DTLeitorOFX1: TDTLeitorOFX
    PositivarDebito = True
    Left = 256
    Top = 288
  end
  object cdsOfx: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 288
    object cdsOfxINDEX: TIntegerField
      FieldName = 'INDEX'
    end
    object cdsOfxID: TStringField
      FieldName = 'ID'
      Size = 70
    end
    object cdsOfxDOCUMENT: TStringField
      FieldName = 'DOCUMENT'
      Size = 10
    end
    object cdsOfxMOVDATE: TDateField
      FieldName = 'MOVDATE'
    end
    object cdsOfxMOVTYPE: TStringField
      FieldName = 'MOVTYPE'
      Size = 8
    end
    object cdsOfxVALUE: TFloatField
      FieldName = 'VALUE'
      DisplayFormat = '#,##0.00'
    end
    object cdsOfxDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 30
    end
  end
  object dsOFX: TDataSource
    DataSet = cdsOfx
    Left = 160
    Top = 288
  end
  object cdsTipos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 912
    Top = 232
    object cdsTiposTIPO: TStringField
      FieldName = 'TIPO'
      Size = 70
    end
    object cdsTiposMOVTYPE: TStringField
      FieldName = 'MOVTYPE'
      Size = 3
    end
    object cdsTiposVALOR: TFloatField
      FieldName = 'VALOR'
      DisplayFormat = '#,##0.00'
    end
  end
  object dsTipos: TDataSource
    DataSet = cdsTipos
    Left = 1008
    Top = 232
  end
end
