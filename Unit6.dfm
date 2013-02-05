object frmDetSIX: TfrmDetSIX
  Left = 161
  Top = 454
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '###'
  ClientHeight = 232
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 112
    Width = 31
    Height = 13
    Caption = 'Chave'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 31
    Height = 13
    Caption = 'Ordem'
  end
  object Label9: TLabel
    Left = 8
    Top = 168
    Width = 48
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object sbar: TStatusBar
    Left = 0
    Top = 213
    Width = 768
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 41
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 4
    object sbFechar: TSpeedButton
      Left = 5
      Top = 5
      Width = 32
      Height = 32
      Hint = 'Fechar (Esc)'
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888808888888888088800088888888888880000888888
        8088888000888888088888880008888008888888800088008888888888000008
        8888888888800088888888888800000888888888800088008888888000088880
        0888880000888888008888000888888888088888888888888888}
      ParentShowHint = False
      ShowHint = True
      OnClick = sbFecharClick
    end
    object DBNav: TDBNavigator
      Left = 42
      Top = 5
      Width = 540
      Height = 32
      DataSource = frmMain.dsSIX
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Flat = True
      Hints.Strings = (
        'Primeiro (Home)'
        'Anterior (Seta esquerda / Seta acima)'
        'Pr'#243'ximo (Seta direita / Seta abaixo)'
        #218'ltimo (End)')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = DBNavClick
    end
  end
  object DBEdit2: TDBEdit
    Left = 8
    Top = 128
    Width = 753
    Height = 21
    DataField = 'CHAVE'
    DataSource = frmMain.dsSIX
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 8
    Top = 72
    Width = 89
    Height = 21
    DataField = 'ORDEM'
    DataSource = frmMain.dsSIX
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object DBEdit9: TDBEdit
    Left = 8
    Top = 184
    Width = 753
    Height = 21
    DataField = 'DESCRICAO'
    DataSource = frmMain.dsSIX
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
end
