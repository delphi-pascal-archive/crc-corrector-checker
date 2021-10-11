unit Self_CRC_Check_MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  CommonSignProcUnit, crc32;

{$R *.dfm}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function CRC_Check : Boolean;
var
  L_Crc : LongWord;
begin
  //- эта процедура может пойти на съедение кракеру.
  //- другие процедуры и типы не нужно именовать по точному назначению.
  //- лучше путать
  Result := Crc32File(Application.ExeName, L_Crc);
  if Not Result then Exit;
  Result := (CRC^ = L_Crc);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TForm1.FormCreate(Sender: TObject);
begin
  if CRC_Check then begin
    Label1.Caption := 'Контрольная сумма в порядке!';
    Label1.Font.Color := clGreen;
    Label1.Font.Style := [fsBold];
  end else begin
    Label1.Caption := 'Контрольная сумма НЕ в порядке !!!';
    Label1.Font.Color := clRed;
    Label1.Font.Style := [fsBold];
  end;
end;

end.
