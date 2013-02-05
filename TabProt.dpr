program TabProt;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  Unit2 in 'Unit2.pas' {frmSobre},
  Unit3 in 'Unit3.pas' {frmConfig},
  Unit4 in 'Unit4.pas' {frmDetSX3},
  Unit6 in 'Unit6.pas' {frmDetSIX},
  Unit5 in 'Unit5.pas' {frmIndexar};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Tabelas Protheus 1.2.1';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
