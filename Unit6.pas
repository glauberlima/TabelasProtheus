unit Unit6;

interface

uses
  Windows, Forms, StdCtrls, DBCtrls, Buttons, Controls, ExtCtrls, ComCtrls,
  Classes, Mask;

type
  TfrmDetSIX = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    sbar: TStatusBar;
    Panel1: TPanel;
    sbFechar: TSpeedButton;
    DBNav: TDBNavigator;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit9: TDBEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbFecharClick(Sender: TObject);
    procedure DBNavClick(Sender: TObject; Button: TNavigateBtn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDetSIX: TfrmDetSIX;

implementation

uses Unit1;

{$R *.dfm}

procedure TfrmDetSIX.FormActivate(Sender: TObject);
begin
frmDetSIX.Caption := 'Detalhes do índice ' + DBEdit3.Field.AsString;
end;

procedure TfrmDetSIX.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmDetSIX.sbFecharClick(Sender: TObject);
begin
Close;
end;

procedure TfrmDetSIX.DBNavClick(Sender: TObject; Button: TNavigateBtn);
begin
FormActivate(Sender);
end;

end.
