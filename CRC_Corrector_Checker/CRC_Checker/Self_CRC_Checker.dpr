program Self_CRC_Checker;

uses
  Forms,
  Self_CRC_Check_MainFormUnit in 'Self_CRC_Check_MainFormUnit.pas' {Form1},
  CommonSignProcUnit in 'CommonSignProcUnit.pas',
  crc32 in 'crc32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
