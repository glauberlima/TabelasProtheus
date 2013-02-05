unit Unit4;

interface

uses
  Windows, Forms, DBCtrls, Buttons, Controls, ExtCtrls, StdCtrls, Mask, ComCtrls,
  Classes, SysUtils;

type
  TfrmDetSX3 = class(TForm)
    sbar: TStatusBar;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Panel1: TPanel;
    DBNav: TDBNavigator;
    sbFechar: TSpeedButton;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    DBEdit6: TDBEdit;
    Label6: TLabel;
    DBEdit7: TDBEdit;
    Label7: TLabel;
    DBEdit8: TDBEdit;
    Label8: TLabel;
    DBEdit9: TDBEdit;
    Label9: TLabel;
    DBEdit12: TDBEdit;
    Label12: TLabel;
    DBEdit13: TDBEdit;
    Label13: TLabel;
    DBEdit14: TDBEdit;
    Label14: TLabel;
    DBEdit15: TDBEdit;
    Label15: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    DBEdit4: TDBEdit;
    Label11: TLabel;
    DBEdit5: TDBEdit;
    Label16: TLabel;
    DBEdit10: TDBEdit;
    Label17: TLabel;
    DBEdit11: TDBEdit;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit16: TDBEdit;
    Label20: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    procedure sbFecharClick(Sender: TObject);
    procedure DBNavClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDetSX3: TfrmDetSX3;

implementation

uses Unit1;

{$R *.dfm}

procedure TfrmDetSX3.sbFecharClick(Sender: TObject);
begin
Close;
end;

procedure TfrmDetSX3.DBNavClick(Sender: TObject;
  Button: TNavigateBtn);
begin
FormActivate(Sender);
end;

//procedure TfrmDetSX3.FormActivate(Sender: TObject);
//begin
//frmDetSX3.Caption := 'Detalhes do campo ' + DBEdit2.Text;
//end;

procedure TfrmDetSX3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

case Key of
  36     : DBNav.BtnClick(nbFirst); // Tecla Home -> simular clique no botão de "Primeiro" do DBNavigator
  35     : DBNav.BtnClick(nbLast);  // Tecla End -> simular clique no botão de "Último" do DBNavigator
  37, 38 : DBNav.BtnClick(nbPrior); // Tecla Seta esquerda / Seta acima -> simular clique no botão de "Anterior" do DBNavigator
  39, 40 : DBNav.BtnClick(nbNext);  // Tecla Seta direita / Seta abaixo -> simular clique no botão de "Próximo" do DBNavigator
  27     : sbFecharClick(Sender);   // Tecla ESC -> faz o mesmo que clicar no botão fechar
end;

end;

procedure TfrmDetSX3.FormActivate(Sender: TObject);
begin
frmDetSX3.Caption := 'Detalhes do campo: ' + DBEdit2.Field.AsString;
end;

end.
