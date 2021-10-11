unit StdExeCrcFuncUnit;

interface

uses
  Windows, Classes, Forms, Types, SysUtils;

  function GetExeCrc(const ExeFileName : String; var HeaderCRC, ImageCRC : DWord) : Boolean;
  function SelfCrcCheck(const ExeFileName : String = '') : Boolean;

{$IFDEF CORRECTOR_APP}
  procedure WritePEHeaderCrc(const ExeFileName : String; Crc : DWord);
{$ENDIF CORRECTOR_APP}

implementation

//- Системная функция по расчету CRC EXE файлов.
// Параметры:
// Filename - имя exe файла
// HeaderSum - Контрольная сумма прочитанная из заголовка файла.
// CheckSum - Расчитанная контрольная сумма файла без заголовка
// возвращает 0 если все в порядке
function MapFileAndCheckSum(Filename : PChar; var HeaderSum, CheckSum : DWord) : DWord; stdcall; external 'imagehlp.dll' name 'MapFileAndCheckSumA';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function GetExeCrc(const ExeFileName : String; var HeaderCRC, ImageCRC : DWord) : Boolean;
var
  FName : String;
begin
  //- Возвращает CRC exe образа файла и соответствующую запись из заголовока.
  FName := Trim(ExeFileName);
  if (FName = '') then FName := Application.ExeName;
  Result := (MapFileAndCheckSum(PChar(FName), HeaderCRC, ImageCRC) = 0);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function SelfCrcCheck(const ExeFileName : String = '') : Boolean;
var
  HeaderCRC : DWord;
  ImageCRC : DWord;
begin
  //- проверяет целостность файла по заголовку и реальному CRC.
  Result := GetExeCrc(ExeFileName, HeaderCRC, ImageCRC);
  if not Result then Exit;
  Result := (HeaderCRC = ImageCRC);
end;

{$IFDEF CORRECTOR_APP}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure WritePEHeaderCrc(const ExeFileName : String; Crc : DWord);
var
  ExeSig : Word;
  PESig : DWord;
  PEHeaderOffset : DWord;
  Stream : TFileStream;
const
  PECRCOffset = 84;
  PEHeaderOffsetInExeHeader = 60;
begin
  Stream := TFileStream.Create(ExeFileName, (fmOpenReadWrite or fmShareDenyWrite));
  try
    Stream.Position := 0;
    //- прочитать Exe подпись
    Stream.ReadBuffer(ExeSig, SizeOf(ExeSig));
    //- проверить подпись
    if (ExeSig <> $5A4D {'MZ'}) then raise Exception.CreateFmt('%s не EXE файл.',[ExeFileName]);
    //- прочитать смещение PE заголовка
    Stream.Seek(PEHeaderOffsetInExeHeader, soFromBeginning);
    Stream.ReadBuffer(PEHeaderOffset, SizeOf(PEHeaderOffset));
    //- прочитать PE подпись
    Stream.Seek(PEHeaderOffset, soFromBeginning);
    Stream.ReadBuffer(PESig, SizeOf(PESig));
    //- проверить подпись
    if (PESig <> $00004550 {'PE'#0#0}) then raise Exception.CreateFmt('%s не PE файл.',[ExeFileName]);
    //- записать CRC
    Stream.Seek(PECRCOffset, soFromCurrent);
    Stream.WriteBuffer(Crc, SizeOf(Crc));
  except
    Stream.Free;
    raise;
  end;
  Stream.Free;
end;
{$ENDIF CORRECTOR_APP}

end.
