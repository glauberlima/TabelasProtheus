unit Unit3;

interface

uses
  Forms, StdCtrls, Buttons, Controls, Classes, ShlObj, Windows, SysUtils,
  Graphics, ExtCtrls;

type
  TfrmConfig = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edSX2: TEdit;
    Label2: TLabel;
    edPATH: TEdit;
    Label3: TLabel;
    edSX3: TEdit;
    Label4: TLabel;
    edSIX: TEdit;
    spProcurar: TSpeedButton;
    btOK: TButton;
    btCancelar: TButton;
    lbAvisoPATH: TLabel;
    lbAvisoX2: TLabel;
    lbAvisoX3: TLabel;
    lbAvisoIX: TLabel;
    cbxSINDEX: TCheckBox;
    Label5: TLabel;
    Image1: TImage;
    GroupBox2: TGroupBox;
    btReindexar: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure spProcurarClick(Sender: TObject);
    procedure cbxSINDEXClick(Sender: TObject);
    procedure btReindexarClick(Sender: TObject);
  private
    { Private declarations }
    function SigaAdvValido(dir : string; aviso : TLabel) : boolean;
    function NomePadrao(arq : string) : string;
    function TabelaValida(campo : TEdit; aviso : TLabel) : boolean;
    function BrowseDialog(const titulo: string) : string;
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

uses Unit1;

{$R *.dfm}

function TfrmConfig.BrowseDialog(const titulo: string) : string;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..255] of char;
  TempPath : array[0..255] of char;
begin
  Result:='';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  with BrowseInfo do begin
    hwndOwner := Application.Handle;
    pszDisplayName := @DisplayName;
    lpszTitle := PChar(titulo);
    ulFlags := BIF_RETURNONLYFSDIRS;
  end;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

// Checa os campos de configuração para verificar se os nomes de tabelas neles
// digitadas realmente existem
function TfrmConfig.TabelaValida(campo : TEdit; aviso : TLabel) : boolean;
var
  dir  : string; // diretório
  nome : string; // nome da tabela
begin

dir := edPATH.Text;

// Se usuário marcou a checkbox de usar o SINDEX, então ignora o nome que ele
// digitou na caixa do nome do SIX...
if (cbxSINDEX.Checked) and (campo = edSIX) then
  nome := 'SINDEX.DBF'
else // ... senão considera o nome
  nome := campo.Text;

if FileExists(dir + '\' + nome) then begin
  aviso.Visible := False;
  Result        := True;
end
else begin
  aviso.Visible := True;
  Result        := False;
end;


end;

// Retorna o caminho completo do arquivo especificado
function TfrmConfig.NomePadrao(arq : string) : string;
var
  sr : TSearchRec;
  r  : integer;
begin

r := FindFirst(arq, faAnyFile, sr);

if r = 0 then
  Result := sr.Name
else
  Result := '';

  SysUtils.FindClose(sr);

end;

// Determina se o diretório SIGAADV selecionado é válido
function TfrmConfig.SigaAdvValido(dir : string; aviso : TLabel) : boolean;
var
  arq1, arq2, arq3 : integer;
  info             : TSearchRec;
begin

arq1 := FindFirst(dir + '\SX2*.*', faAnyFile, info); SysUtils.FindClose(info);
arq2 := FindFirst(dir + '\SX3*.*', faAnyFile, info); SysUtils.FindClose(info);
arq3 := FindFirst(dir + '\SIX*.*', faAnyFile, info); SysUtils.FindClose(info);

if (arq1 = 0) and (arq2 = 0) and (arq3 = 0) then begin
  aviso.Visible := False;
  Result        := True;
end
else begin
  aviso.Visible := True;
  Result        := False;
end;

end;

procedure TfrmConfig.FormActivate(Sender: TObject);
begin

// Carrega as configurações, com base nas variáveis que guardam essas configurações
// no formulário principal
edPATH.Text := PATH;
if X2_NAME = '' then edSX2.Text := NomePadrao(PATH + '\SX2*.DBF') else edSX2.Text := X2_NAME;
if X3_NAME = '' then edSX3.Text := NomePadrao(PATH + '\SX3*.DBF') else edSX3.Text := X3_NAME;
if IX_NAME = '' then edSIX.Text := NomePadrao(PATH + '\SIX*.DBF') else edSIX.Text := IX_NAME;

if IX_NAME = 'SINDEX.DBF' then cbxSINDEX.Checked := True else cbxSINDEX.Checked := False;

// Só ativa o botão de reindexar se o formulário principal estiver visível, porque se ele
// não estiver, quer dizer que é a primeira vez que o usuário entra no programa, logo, não
// tem como reindexar, já que a configuração ainda está sendo feita.
btReindexar.Enabled := frmMain.Visible;

end;

procedure TfrmConfig.btOKClick(Sender: TObject);
begin

// Verifica se todas as informações digitadas estão corretas
if ( SigaAdvValido(edPATH.Text, lbAvisoPATH) ) and
   ( TabelaValida(edSX2, lbAvisoX2)          ) and
   ( TabelaValida(edSX3, lbAvisoX3)          ) and
   ( TabelaValida(edSIX, lbAvisoIX)          ) then begin

    // Se estiverem, grava nas variáveis do sistema as configurações
    PATH      := edPATH.Text;
    X2_NAME   := edSX2.Text;
    X3_NAME   := edSX3.Text;

    if cbxSINDEX.Checked then begin
      IX_NAME   := 'SINDEX.DBF';
      USESINDEX := 1;
    end
    else begin
      IX_NAME   := edSIX.Text;
      USESINDEX := 0;
    end;

    Close;

end;


end;

procedure TfrmConfig.btCancelarClick(Sender: TObject);
begin
Close;
end;

procedure TfrmConfig.spProcurarClick(Sender: TObject);
var dir : string;
begin

dir := BrowseDialog('Selecione a pasta do SIGAADV.');

if dir <> '' then edPATH.Text := dir;

end;

procedure TfrmConfig.cbxSINDEXClick(Sender: TObject);
begin

edSIX.Enabled := not cbxSINDEX.Checked;

if cbxSINDEX.Checked then
  edSIX.Text := 'SINDEX.DBF'
else
  edSIX.Text := '';


end;

procedure TfrmConfig.btReindexarClick(Sender: TObject);
begin

// Força a reindexação das tabelas
frmMain.Indexar(frmMain.tbSX2, 'X2_CHAVE', True);
frmMain.Indexar(frmMain.tbSX3, 'X3_ARQUIVO+X3_ORDEM', True);
frmMain.Indexar(frmMain.tbSIX, 'INDICE+ORDEM', True);

end;

end.
