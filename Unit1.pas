unit Unit1;

interface

uses
  Windows, Forms, ShellAPI, ImgList, Controls, XPMan, Menus, ApoEnv, DB, ApoDSet, SysUtils,
  StdCtrls, Buttons, Graphics, ExtCtrls, Grids, DBGrids, ComCtrls, Classes, Messages, IniFiles;

const
  WM_ICONTRAY = WM_USER + 1;

type
  TfrmMain = class(TForm)
    sbar: TStatusBar;
    btFechar: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    DBGridX2: TDBGrid;
    TabSheet2: TTabSheet;
    DBGridX3: TDBGrid;
    TabSheet3: TTabSheet;
    DBGrid3: TDBGrid;
    btSobre: TButton;
    Panel1: TPanel;
    btIR: TBitBtn;
    edValor: TEdit;
    cbxOp: TComboBox;
    cbxCampo: TComboBox;
    Image1: TImage;
    btConfig: TButton;
    dsSX2: TDataSource;
    tbSX2: TApolloTable;
    tbSX3: TApolloTable;
    dsSX3: TDataSource;
    dsSIX: TDataSource;
    tbSIX: TApolloTable;
    ApolloEnv1: TApolloEnv;
    PopupMenu1: TPopupMenu;
    ExibirOcultar1: TMenuItem;
    Sobre1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    XPManifest1: TXPManifest;
    ImageList1: TImageList;
    tbSX2X2_CHAVE: TStringField;
    tbSX2X2_PATH: TStringField;
    tbSX2X2_ARQUIVO: TStringField;
    tbSX2X2_NOME: TStringField;
    tbSX2X2_MODO: TStringField;
    tbSX2_X2_MODO: TStringField;
    tbSX3X3_ARQUIVO: TStringField;
    tbSX3X3_TITULO: TStringField;
    tbSX3X3_ORDEM: TStringField;
    tbSX3X3_CAMPO: TStringField;
    tbSX3X3_TIPO: TStringField;
    tbSX3X3_TAMANHO: TSmallintField;
    tbSX3X3_DECIMAL: TSmallintField;
    tbSX3X3_DESCRIC: TStringField;
    tbSX3X3_PICTURE: TStringField;
    tbSX3X3_VALID: TStringField;
    tbSX3X3_F3: TStringField;
    tbSX3X3_VLDUSER: TStringField;
    tbSX3X3_CONTEXT: TStringField;
    tbSX3_X3_CONTEXTO: TStringField;
    tbSX3X3_CBOX: TStringField;
    tbSX3X3_RELACAO: TStringField;
    tbSX3X3_INIBRW: TStringField;
    tbSX3X3_WHEN: TStringField;
    tbSIXORDEM: TStringField;
    tbSIXCHAVE: TStringField;
    tbSIXDESCRICAO: TStringField;
    procedure cbxCampoChange(Sender: TObject);
    procedure cbxOpChange(Sender: TObject);
    procedure btIRClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edValorKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure tbSX2AfterOpen(DataSet: TDataSet);
    procedure tbSX2AfterScroll(DataSet: TDataSet);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ExibirOcultar1Click(Sender: TObject);
    procedure btConfigClick(Sender: TObject);
    procedure btSobreClick(Sender: TObject);
    procedure tbSX3CalcFields(DataSet: TDataSet);
    procedure tbSX2CalcFields(DataSet: TDataSet);
    procedure DBGridX3DblClick(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure tbSX3AfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    TrayIconData: TNotifyIconData;
    procedure ShowTrayIcon(mostrar : boolean);
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure ConfigINI(flag : byte);
    function TabelasOK : boolean;
    procedure InicializaTabelas;
    procedure FinalizaTabelas;
    procedure ShowConfig;
    procedure ShowSobre;
    procedure ShowDetSX3(tabela : string);
    procedure ShowDetSIX(tabela : string);
  public
    procedure ShowIndexar;
    procedure Indexar(tabela : TApolloTable ; expr : string ; ForceReindex : boolean);
    { Public declarations }
  end;

var
  frmMain     : TfrmMain;
  campo       : string;
  op          : string;
  valor       : string;

  // Variáveis globais que guardam as configurações do INI
  X2_NAME     : string;
  X3_NAME     : string;
  IX_NAME     : string;
  PATH        : string;
  USESINDEX   : byte;

implementation

uses Unit2, Unit3, Unit4, Unit6, Unit5;


{$R *.dfm}

// Reindexa as tabelas, para melhorar a velocidade do acesso
procedure TFrmMain.Indexar(tabela : TApolloTable ; expr : string ; ForceReindex : boolean);
var
  idx      : integer;
  nome_idx : string;
begin

with tabela do begin

  CloseIndexes;

  // nome do índice
  nome_idx   := ExtractFilePath(Application.ExeName) + ChangeFileExt(TableName, '.NTX');

  // se o parâmetro ForceReindex for True, então apaga o índice atual, para forçar
  // uma reindexação
  if ForceReindex then DeleteFile(nome_idx);

  try
    idx := IndexOpen(nome_idx); // tenta abrir o índice...
  except
    on EApolloError do begin // se não conseguir, cria um novo

        frmIndexar := TfrmIndexar.Create(self);
        with frmIndexar do begin
            lbTabela.Caption := TableName;
            Show;
            Update;
        end;

        // cria o novo índice
        idx := Index(nome_idx, expr, IDX_UNIQUE, False, '');
        FreeAndNil(frmIndexar);

    end;

  end;

  SetOrder(idx); // ativa o índice

end;

end;

// Exibe/oculta o ícone da bandeja
procedure TfrmMain.ShowTrayIcon(mostrar : boolean);
begin

if mostrar then begin // mostra o ícone
  with TrayIconData do
    begin
      cbSize := SizeOf(TrayIconData);
      Wnd := Handle;
      uID := 0;
      uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
      uCallbackMessage := WM_ICONTRAY;
      hIcon := Application.Icon.Handle;
      StrPCopy(szTip, Application.Title);
    end;
    Shell_NotifyIcon(NIM_ADD, @TrayIconData);
end
else // esconde o ícone
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);

end;

// Finaliza corretamente as tabelas
procedure TfrmMain.FinalizaTabelas;
begin

tbSX2.Close;
tbSIX.Close;
tbSX3.Close;

end;


// Inicializa corretamente as tabelas
procedure TfrmMain.InicializaTabelas;
begin

// Seta o diretórios das tabelas
tbSX2.DatabaseName := PATH;
tbSX3.DatabaseName := PATH;
tbSIX.DatabaseName := PATH;

// Seta os nomes das tabelas
tbSX2.TableName := X2_NAME;
tbSX3.TableName := X3_NAME;
tbSIX.TableName := IX_NAME;

// Abre as tabelas
tbSX2.Open;
tbSX3.Open;
tbSIX.Open;

// Reindexa as tabelas, se necessário
Indexar(tbSX2, 'X2_CHAVE', False);
Indexar(tbSX3, 'X3_ARQUIVO+X3_ORDEM', False);
Indexar(tbSIX, 'INDICE+ORDEM', False);

end;


// Checa se as tabelas necessárias existem
function TfrmMain.TabelasOK : boolean;
var X2_PATH, X3_PATH, IX_PATH : string;
begin

X2_PATH := PATH + '\' + X2_NAME;  // Caminho completo do SX2
X3_PATH := PATH + '\' + X3_NAME;  // Caminho completo do SX3
IX_PATH := PATH + '\' + IX_NAME;  // Caminho completo do SIX

if (not FileExists(X2_PATH)) or (not FileExists(X3_PATH)) or (not FileExists(IX_PATH)) then begin
  messagebox(0,PChar('Configurações incorretas. Clique em OK para entrar no modo de configuração e corrigir o erro.'), 'Aviso', MB_ICONERROR+MB_TASKMODAL);
  Result := False;
end
else
  Result := True;

end;

// Exibe a tela Reindexar
procedure TfrmMain.ShowIndexar;
begin

  try
    frmIndexar := TfrmIndexar.Create(self);
    frmIndexar.ShowModal;
  finally
    FreeAndNil(frmIndexar);
  end;

end;

// Exibe a tela de sobre
procedure TfrmMain.ShowSobre;
begin

  try
    frmSobre := TfrmSobre.Create(self);
    frmSobre.ShowModal;
  finally
    FreeAndNil(frmSobre);
  end;

end;

// Exibe a tela de detalhes dos índices (SIX)
procedure TfrmMain.ShowDetSIX(tabela : string);
begin

  try
    frmDetSIX := TfrmDetSIX.Create(self);
    frmDetSIX.sbar.SimpleText := 'Tabela: ' + tabela;
    frmDetSIX.ShowModal;
  finally
    FreeAndNil(frmDetSIX);
  end;

end;

// Exibe a tela de detalhes dos campos (SX3)
procedure TfrmMain.ShowDetSX3(tabela : string);
begin

  try
    frmDetSX3 := TfrmDetSX3.Create(self);
    frmDetSX3.sbar.SimpleText := 'Tabela: ' + tabela;
    frmDetSX3.ShowModal;
  finally
    FreeAndNil(frmDetSX3);
  end;

end;

// Exibe a tela de configurações
procedure TfrmMain.ShowConfig;
begin

  try
    frmConfig := TfrmConfig.Create(self);
    frmConfig.ShowModal;
  finally
    FreeAndNil(frmConfig);
  end;

end;

// Captura os cliques dados no trayicon do programa
procedure TfrmMain.TrayMessage(var Msg: TMessage);
var
  p : TPoint;
begin
  case Msg.lParam of
      WM_LBUTTONDBLCLK:
    begin
      ExibirOcultar1Click(nil);
    end;
    WM_RBUTTONDOWN:
    begin
       SetForegroundWindow(Handle);
       GetCursorPos(p);
       PopUpMenu1.Popup(p.x-85, p.y);
       PostMessage(Handle, WM_NULL, 0, 0);
    end;
  end;
end;

// Lê/Grava o arquivo INI
procedure TfrmMain.ConfigINI(flag : byte);
var
  arq_ini : string;
  ini     : TIniFile;
begin

// flag  = 1 -> Ler
// flag != 1 -> Gravar

// Nome do arquivo INI, obtido automaticamente do .EXE
arq_ini :=  ExtractFilePath(Application.ExeName) + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');

ini := TIniFile.Create(arq_ini);

if(flag=1) then begin

  // Pega os nomes da SX2, SX3 e SIX, PATH e UseSindex do arquivo INI
  X2_NAME   := ini.ReadString('Config','X2Name','SX2010.DBF');
  X3_NAME   := ini.ReadString('Config','X3Name','SX3010.DBF');
  IX_NAME   := ini.ReadString('Config','IXName','SIX010.DBF');
  PATH      := ini.ReadString('Config','Path','.');
  USESINDEX := ini.ReadInteger('Config','UseSindex',0);

end
else begin

  ini.WriteString('Config','X2Name',X2_NAME);
  ini.WriteString('Config','X3Name',X3_NAME);
  ini.WriteString('Config','IXName',IX_NAME);
  ini.WriteString('Config','Path',PATH);
  ini.WriteInteger('Config','UseSindex',USESINDEX);

end;

FreeAndNil(ini);

end;

procedure TfrmMain.cbxCampoChange(Sender: TObject);
begin
campo := cbxCampo.Text;
end;

procedure TfrmMain.cbxOpChange(Sender: TObject);
begin
op := cbxOp.Text;
end;

// Ao clicar no botão Localizar
procedure TfrmMain.btIRClick(Sender: TObject);
var
  vrT1 : string;
  vrT2 : string;
begin

// Ativa a primeira página: Tabelas
PageControl.ActivePageIndex  := 0;

vrT1 := UpperCase(QuotedStr(edValor.Text + '%'));
vrT2 := UpperCase(QuotedStr('%' + edValor.Text + '%'));

if (campo = 'Sigla') and (op = 'começa com') then
  //tbSX2.Filter := 'UPPER(X2_CHAVE) LIKE ' + vrT1
  tbSX2.Query('UPPER(X2_CHAVE) LIKE ' + vrT1)

else if (campo = 'Sigla') and (op = 'contém') then
  //tbSX2.Filter := 'UPPER(X2_CHAVE) LIKE ' + vrT2
  tbSX2.Query('UPPER(X2_CHAVE) LIKE ' + vrT2)

else if (campo = 'Nome') and (op = 'começa com') then
  //tbSX2.Filter := 'UPPER(X2_NOME) LIKE ' + vrT1
  tbSX2.Query('UPPER(X2_NOME) LIKE ' + vrT1)

else if (campo = 'Nome') and (op = 'contém') then
  //tbSX2.Filter := 'UPPER(X2_NOME) LIKE ' + vrT2
  tbSX2.Query('UPPER(X2_NOME) LIKE ' + vrT2)

end;

// Ao clicar no botão Fechar
procedure TfrmMain.btFecharClick(Sender: TObject);
begin
Application.Terminate;
end;

// Ao ativar o formulário principal
procedure TfrmMain.FormActivate(Sender: TObject);
begin

// Configura os hints para 5 segundos
Application.HintHidePause := 5000;

frmMain.Caption := Application.Title;

sbar.Panels[1].Text := Format('Caminho SIGAADV: %s',[PATH]);

campo := 'Sigla';
op    := 'começa com';
edValor.SetFocus;

end;

// Ao pressionar alguma tecla dentro do campo Valor
procedure TfrmMain.edValorKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then btIRClick(Sender);
end;

// Ao criar o formulário (ocorre antes do Ativar)
procedure TfrmMain.FormCreate(Sender: TObject);
begin

// Lê os dados do INI
ConfigINI(1);

// Verifica se as tabelas estão OK
if TabelasOK then begin
  InicializaTabelas;
  ShowTrayIcon(true);
end
else begin // opa! Não estão Ok... abrindo configurações
  frmMain.WindowState := WsMinimized;
  frmMain.Hide;
  ShowConfig;
  Application.Terminate;
end;

end;

// Ao destruir o formulário
procedure TfrmMain.FormDestroy(Sender: TObject);
begin

// Grava o INI
ConfigINI(2);

// Fecha as tabelas
FinalizaTabelas;

// Remove o ícone da bandeja
ShowTrayIcon(false);

end;

procedure TfrmMain.Sobre1Click(Sender: TObject);
begin
btSobreClick(Sender);
end;

procedure TfrmMain.Sair1Click(Sender: TObject);
begin
btFecharClick(Sender);
end;

procedure TfrmMain.tbSX2AfterOpen(DataSet: TDataSet);
begin
sbar.Panels[0].Text := Format('%d tabela(s) encontrada(s)',[DataSet.RecordCount]);
end;

procedure TfrmMain.tbSX2AfterScroll(DataSet: TDataSet);
var x2_chave, n1, n2, n3 : string;
begin

  x2_chave := QuotedStr(tbSX2.FieldByName('X2_CHAVE').AsString);

  //tbSX3.Filter := 'X3_ARQUIVO = ' + x2_chave;
  tbSX3.Query('X3_ARQUIVO = ' + x2_chave);

  //tbSIX.Filter := 'INDICE = ' + x2_chave;
  tbSIX.Query('INDICE = ' + x2_chave);

  n1 := Application.Title;
  n2 := Trim(DataSet.FieldByName('x2_chave').AsString);
  n3 := Trim(DataSet.FieldByName('x2_nome').AsString);

  // Define o título do formulário: mostra ou não o nome da tabela
  // atual junto com o título do form
  if DataSet.RecordCount = 0 then begin
    frmMain.Caption                := Format('%s - [Nenhuma tabela encontrada]', [Application.Title]);
    PageControl.ActivePageIndex  := 0;
    PageControl.Pages[1].TabVisible := False;
    PageControl.Pages[2].TabVisible := False;
  end
  else begin
    frmMain.Caption := Format('%s  - [%s - %s]',[n1, n2, n3]);
    PageControl.Pages[1].TabVisible := True;
    PageControl.Pages[2].TabVisible := True;
  end;

  tbSX2AfterOpen(DataSet);

end;

procedure TfrmMain.PopupMenu1Popup(Sender: TObject);
begin

if frmMain.Visible then
  ExibirOcultar1.Caption := '&Ocultar'
else
  ExibirOcultar1.Caption := '&Exibir';

end;

procedure TfrmMain.ExibirOcultar1Click(Sender: TObject);
begin
frmMain.Visible := not frmMain.Visible;
end;

procedure TfrmMain.btConfigClick(Sender: TObject);
begin
ShowConfig;
end;

procedure TfrmMain.btSobreClick(Sender: TObject);
begin
ShowSobre;
end;

procedure TfrmMain.tbSX3CalcFields(DataSet: TDataSet);
var x3_contexto_valor : string;
begin

// Calcula o valor do campo virtual _X3_CONTEXTO
if tbSX3.FieldByName('X3_CONTEXT').AsString = 'V' then
  x3_contexto_valor := 'Virtual'
else
  x3_contexto_valor := 'Real';

// Seta os valores dos campos virtuais
tbSX3.FieldByName('_X3_CONTEXTO').AsString := x3_contexto_valor;

end;

procedure TfrmMain.tbSX2CalcFields(DataSet: TDataSet);
begin

// Cálculo do campo fórmula _X2_MODO
if tbSX2.FieldByName('X2_MODO').AsString = 'C' then
  tbSX2.FieldByName('_X2_MODO').AsString := 'Compartilhado'
else
  tbSX2.FieldByName('_X2_MODO').AsString := 'Exclusivo';

end;

procedure TfrmMain.DBGridX3DblClick(Sender: TObject);
var tabela : string;
begin

tabela := tbSX2.FieldByName('X2_CHAVE').AsString + ' - ' +
          tbSX2.FieldByName('X2_NOME').AsString;

ShowDetSX3(tabela);

end;

procedure TfrmMain.DBGrid3DblClick(Sender: TObject);
var tabela : string;
begin

tabela := tbSX2.FieldByName('X2_CHAVE').AsString + ' - ' +
          tbSX2.FieldByName('X2_NOME').AsString;

ShowDetSIX(tabela);

end;

procedure TfrmMain.tbSX3AfterScroll(DataSet: TDataSet);
begin

// Só executa se o frmDetSX3 existir na memória
if Assigned(frmDetSX3) then begin // frmDetSX3 <> nil
  frmDetSX3.Caption := 'Detalhes do campo: ' + DataSet.FieldByName('X3_CAMPO').AsString;
end;

end;

end.
