unit Unit2;

interface

uses
  Forms, StdCtrls, Controls, Graphics, ExtCtrls, Classes, ShellAPI;

type
  TfrmSobre = class(TForm)
    lbNome: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Image1: TImage;
    Label3: TLabel;
    Memo1: TMemo;
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSobre: TfrmSobre;

implementation

{$R *.dfm}

procedure TfrmSobre.Label3Click(Sender: TObject);
begin
ShellExecute(0,'open', PChar('mailto:glauber_lima@yahoo.com.br?Subject=[' + Application.Title + ']'), '', '', 0);
end;

procedure TfrmSobre.FormCreate(Sender: TObject);
begin
lbNome.Caption := Application.Title;
end;

procedure TfrmSobre.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then Close;
end;

end.
