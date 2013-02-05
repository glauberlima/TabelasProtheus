unit ShBrowseU;
{wrapper for ShBrowseForFolder}
{*D 22/01/2004}

interface

uses
  Windows, Messages, SysUtils
  {,Classes, Graphics, Controls, Forms}, Dialogs{, StdCtrls}, ShlObj ;

type
  TFolderCheck = function(Sender : TObject; Folder : string) : boolean of object;

  TShBrowseOption = (sboBrowseForComputer, sboBrowseForPrinter,
                     sboBrowseIncludeFiles, sboBrowseIncludeURLs,
                     sboDontGoBelowDomain, sboEditBox, sboNewDialogStyle,
                     sboNoNewFolderButton, sboReturnFSAncestors,
                     sboReturnOnlyFSDirs, sboShareable, sboStatusText,
                     sboUAHint, sboUseNewUI, sboValidate);
  TShBrowseOptions = set of TShBrowseOption;

  TShBrowse = class(TObject)
  private
    FBrowseWinHnd : THandle;
    FCaption : string;
    FFolder : string;
    FFolderCheck : TFolderCheck;
    FInitFolder : string;
    FLeft : integer;
    FOptions : TShBrowseOptions;
    FSelIconIndex : integer;
    FTop : integer;
    FUserMessage : string;
    WinFlags : DWord;
    procedure Callback(Handle : THandle; MsgId : integer; lParam : DWord);
    function GetUNCFolder : string;
    function IdFromPIdL(PtrIdL : PItemIdList; FreeMem : boolean) : string;
    procedure SetOptions(AValue : TShBrowseOptions);
  protected
    property BrowseWinHnd : THandle read FBrowseWinHnd write FBrowseWinHnd;
  public
    constructor Create;
    function Execute : boolean;
    property Caption : string write FCaption;
    property Folder : string read FFolder;
    property FolderCheck : TFolderCheck write FFolderCheck;
    property InitFolder : string write FInitFolder;
    property Left : integer write FLeft; // both Left & Top must be > 0 to position widow
    property Options : TShBrowseOptions read FOptions write SetOptions;
    property SelIconIndex : integer read FSelIconIndex;
    property Top : integer write FTop;
    property UNCFolder : string read GetUNCFolder;
    property UserMessage : string write FUserMessage;
  end;

implementation

uses
  ActiveX;

const
  BIF_RETURNONLYFSDIRS    = $00000001;
  BIF_DONTGOBELOWDOMAIN   = $00000002;
  BIF_STATUSTEXT          = $00000004;
  BIF_RETURNFSANCESTORS   = $00000008;
  BIF_EDITBOX             = $00000010;
  BIF_VALIDATE            = $00000020;
  BIF_NEWDIALOGSTYLE      = $00000040;
  BIF_USENEWUI            = $00000040;
  BIF_BROWSEINCLUDEURLS   = $00000080;
  BIF_NONEWFOLDERBUTTON   = 0;
  BIF_UAHINT              = 0;
  BIF_BROWSEFORCOMPUTER   = $00001000;
  BIF_BROWSEFORPRINTER    = $00002000;
  BIF_BROWSEINCLUDEFILES  = $00004000;
  BIF_SHAREABLE           = $00008000;
  BFFM_VALIDATEFAILED     = 3;

  ShBrowseOptionArray : array[TShBrowseOption] of DWord =
                    (BIF_BROWSEFORCOMPUTER, BIF_BROWSEFORPRINTER,
                     BIF_BROWSEINCLUDEFILES, BIF_BROWSEINCLUDEURLS,
                     BIF_DONTGOBELOWDOMAIN, BIF_EDITBOX, BIF_NEWDIALOGSTYLE,
                     BIF_NONEWFOLDERBUTTON, BIF_RETURNFSANCESTORS,
                     BIF_RETURNONLYFSDIRS, BIF_SHAREABLE, BIF_STATUSTEXT,
                     BIF_UAHINT, BIF_USENEWUI, BIF_VALIDATE);

function ShBFFCallback(hWnd : THandle; uMsg : integer;
                       lParam, lpData : DWord) : integer; stdcall;
{connects the ShBFF callback general function to the
 Delphi method which handles it}
begin
  TShBrowse(lpData).Callback(hWnd, uMsg, lParam); // calls object's method
  Result := 0;
end;

constructor TShBrowse.Create;
begin
  inherited Create;
  Caption := 'Browse for Folder';  // default
  UserMessage := 'Select folder';  // default
end;

procedure TShBrowse.Callback(Handle : THandle; MsgId : integer; lParam : DWord);
{Delphi method which handles the ShBFF callback}
var
  WorkArea, WindowSize : TRect;
  BFFWidth, BFFHeight : integer;
  SelOK : boolean;
begin
  FBrowseWinHnd := Handle;
  case MsgId of
    BFFM_INITIALIZED :
        begin
          if (FLeft = 0) or (FTop = 0) then begin
            {centre the browse window on screen}
            GetWindowRect(FBrowseWinHnd, WindowSize);  // get ShBFF window size
            with WindowSize do begin
              BFFWidth := Right - Left;
              BFFHeight := Bottom - Top;
            end;
            SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0); // get screen size
            with WorkArea do begin  // calculate ShBFF window position
              FLeft := (Right - Left - BFFWidth) div 2;
              FTop := (Bottom - Top - BFFHeight) div 2;
            end;
          end;
          {set browse window position}
          SetWindowPos(FBrowseWinHnd, HWND_TOP, FLeft, FTop, 0, 0, SWP_NOSIZE);
          if (FCaption <> '') then
            {set Caption}
            SendMessage(FBrowseWinHnd, WM_SETTEXT, 0, integer(PChar(FCaption)));
          if (FInitFolder <> '') then
            {set initial folder}
            SendMessage(FBrowseWinHnd, BFFM_SETSELECTION, integer(LongBool(true)),
                        integer(PChar(FInitFolder)));
        end;
    BFFM_SELCHANGED :
        begin
          if Assigned(FFolderCheck) then
            {get folder and check for validity}
            if (lParam <> 0) then begin
              FFolder := IdFromPIdL(PItemIdList(lParam), false);
              {check folder ....}
              SelOK := FFolderCheck(Self, FFolder);
              {... en/disable OK button}
              SendMessage(Handle, BFFM_ENABLEOK, 0, integer(SelOK));
            end; {if (lParam <> nil)}
          {end; if Assigned(FFolderCheck)}
        end;
  {  BFFM_IUNKNOWN :;
    BFFM_VALIDATEFAILED :;  }
  end;
end;

procedure TShBrowse.SetOptions(AValue : TShBrowseOptions);
var
  I : TShBrowseOption;
begin
  if (AValue <> FOptions) then begin
    FOptions := AValue;
    WinFlags := 0;
    for I := Low(TShBrowseOption) to High(TShBrowseOption) do
      if I in AValue then
        WinFlags := WinFlags or ShBrowseOptionArray[I];
    {end; for I := Low(TBrowseOption) to High(TBrowseOption)}
  end; {if (AValue <> FOptions)}
end;

function TShBrowse.Execute : boolean;
{called to display the ShBFF window and return the selected folder}
var
  BrowseInfo : TBrowseInfo;
  IconIndex : integer;
  PtrIDL : PItemIdList;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  IconIndex := 0;
  with BrowseInfo do begin
    hwndOwner := Self.FBrowseWinHnd;
    PIDLRoot := nil;
    pszDisplayName := nil;
    lpszTitle := PChar(FUserMessage);
    ulFlags := WinFlags;
    lpfn := @ShBFFCallback;
    lParam := integer(Self); // this object's reference
    iImage := IconIndex;
  end;
  CoInitialize(nil);
  PtrIDL := ShBrowseForFolder(BrowseInfo);
  if PtrIDL = nil then
    Result := false
  else begin
    FSelIconIndex := BrowseInfo.iImage;
    FFolder := IdFromPIdL(PtrIDL, true);
    Result := true;
  end; {if PtrIDL = nil else}
end;

function TShBrowse.IdFromPIdL(PtrIdL : PItemIdList; FreeMem : boolean) : string;
var
  AMalloc : IMalloc;
begin
  Result := '';
  SetLength(Result, MAX_PATH);
  SHGetPathFromIDList(PtrIDL, PChar(Result));
  Result := trim(Result);
  Result := string(PChar(Result));
  // When a PIDL is passed via BFFM_SELCHANGED and that selection is OK'ed
  // then the PIDL memory is the same as that returned by ShBrowseForFolder.
  // This leads to the assumption that ShBFF frees the memory for the PIDL
  // passed by BFFM_SELCHANGED if that selection is NOT OK'ed. Hence one
  // should free memory ONLY when ShBFF returns, NOT for BFF_SELCHANGED
  if FreeMem then begin
    {free PIDL memory ...}
    ShGetMalloc(AMalloc);
    AMalloc.Free(PtrIDL);
  end;
end;

function TShBrowse.GetUNCFolder : string;
// sub-proc start = = = = = = = = = = = = = = = =
  function GetErrorStr(Error : integer) : string;
  begin
    Result := 'Unknown Error : ' + IntToStr(Error); // default
    case Error of
      ERROR_BAD_DEVICE :         Result := 'Invalid path';
      ERROR_CONNECTION_UNAVAIL : Result := 'No connection';
      ERROR_EXTENDED_ERROR :     Result := 'Network error';
      ERROR_MORE_DATA :          Result := 'Buffer too small';
      ERROR_NOT_SUPPORTED :      Result := 'UNC name not supported';
      ERROR_NO_NET_OR_BAD_PATH : Result := 'Unrecognised path';
      ERROR_NO_NETWORK :         Result := 'Network unavailable';
      ERROR_NOT_CONNECTED :      Result := 'Not connected';
    end;
  end;
// sub-proc end = = = = = = = = = = = = = = = = =
var
  LenResult, Error : integer;
  PtrUNCInfo : PUniversalNameInfo;
begin
  {note that both the PChar _and_ the characters it
   points to are placed in UNCInfo by WNetGetUniversalName
   on return, hence the extra allocation for PtrUNCInfo}
  LenResult := 4 + MAX_PATH; // "4 +" for storage for lpUniversalName == @path
  SetLength(Result, LenResult);
  PtrUNCInfo := AllocMem(LenResult);
  Error := WNetGetUniversalName(PChar(FFolder), UNIVERSAL_NAME_INFO_LEVEL,
                                PtrUNCInfo, LenResult);
  if Error = NO_ERROR then begin
    Result := string(PtrUNCInfo^.lpUniversalName);
    SetLength(Result, Length(Result));
    end
  else
    Result := GetErrorStr(Error);
end;

end.
