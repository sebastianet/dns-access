object fDNS: TfDNS
  Left = 0
  Top = 0
  Caption = 'DNS lookup'
  ClientHeight = 590
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = MyInit
  PixelsPerInch = 120
  TextHeight = 16
  object btnDNS: TButton
    Left = 24
    Top = 56
    Width = 241
    Height = 89
    Caption = 'do DNS lokup'
    TabOrder = 0
    OnClick = btnDNSClick
  end
  object edHN: TEdit
    Left = 24
    Top = 168
    Width = 441
    Height = 24
    TabOrder = 1
    Text = 'out : hostname'
  end
  object edIP: TEdit
    Left = 24
    Top = 16
    Width = 449
    Height = 24
    TabOrder = 2
    Text = 'in : IP'
  end
  object lbEV: TListBox
    Left = 24
    Top = 221
    Width = 577
    Height = 361
    TabOrder = 3
  end
  object IdDNSResolver: TIdDNSResolver
    QueryType = []
    WaitingTime = 5000
    AllowRecursiveQueries = True
    IPVersion = Id_IPv4
    Left = 512
    Top = 48
  end
  object timDNS: TTimer
    OnTimer = timDNSTimeout
    Left = 520
    Top = 136
  end
end
