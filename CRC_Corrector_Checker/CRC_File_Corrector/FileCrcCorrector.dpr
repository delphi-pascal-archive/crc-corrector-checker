program FileCrcCorrector;

uses
  Forms,
  FileCRCCorrectorFormUnit in 'FileCRCCorrectorFormUnit.pas' {FileCRCCorrectorForm},
  crc32 in 'crc32.pas',
  CRCCorrectorUnit in 'CRCCorrectorUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFileCRCCorrectorForm, FileCRCCorrectorForm);
  Application.Run;
end.
