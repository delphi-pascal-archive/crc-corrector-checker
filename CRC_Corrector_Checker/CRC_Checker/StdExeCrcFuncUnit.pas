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

//- ��������� ������� �� ������� CRC EXE ������.
// ���������:
// Filename - ��� exe �����
// HeaderSum - ����������� ����� ����������� �� ��������� �����.
// CheckSum - ����������� ����������� ����� ����� ��� ���������
// ���������� 0 ���� ��� � �������
function MapFileAndCheckSum(Filename : PChar; var HeaderSum, CheckSum : DWord) : DWord; stdcall; external 'imagehlp.dll' name 'MapFileAndCheckSumA';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function GetExeCrc(const ExeFileName : String; var HeaderCRC, ImageCRC : DWord) : Boolean;
var
  FName : String;
begin
  //- ���������� CRC exe ������ ����� � ��������������� ������ �� ����������.
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
  //- ��������� ����������� ����� �� ��������� � ��������� CRC.
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
    //- ��������� Exe �������
    Stream.ReadBuffer(ExeSig, SizeOf(ExeSig));
    //- ��������� �������
    if (ExeSig <> $5A4D {'MZ'}) then raise Exception.CreateFmt('%s �� EXE ����.',[ExeFileName]);
    //- ��������� �������� PE ���������
    Stream.Seek(PEHeaderOffsetInExeHeader, soFromBeginning);
    Stream.ReadBuffer(PEHeaderOffset, SizeOf(PEHeaderOffset));
    //- ��������� PE �������
    Stream.Seek(PEHeaderOffset, soFromBeginning);
    Stream.ReadBuffer(PESig, SizeOf(PESig));
    //- ��������� �������
    if (PESig <> $00004550 {'PE'#0#0}) then raise Exception.CreateFmt('%s �� PE ����.',[ExeFileName]);
    //- �������� CRC
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
