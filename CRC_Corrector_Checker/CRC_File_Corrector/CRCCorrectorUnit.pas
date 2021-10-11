unit CRCCorrectorUnit;

interface

uses
  SysUtils, Classes, Windows,
  Dialogs,
  crc32;

var
  //- ���� ����������� ����� ������ � ���������� �����
  ExamplePattern : array[0..1] of DWord= ($C3C3C3C3,$C3C3C3C3);

function WriteCrcAndCorrectionToStream(FileNameFrom, FileNameTo : String) : Boolean;

implementation

{$DEFINE DEBUG}
{.$DEFINE METH1} //- ������ ������� ��������� ��������� CRC - ���� ��� �� �������

{$IFDEF METH1}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Crc32Correction1(crcCurrent, crcWanted : DWord) : DWord;
// eax - crcCurrent, edx - crcWanted
var
  buffer : array [0..1] of DWord;
asm
  jmp   @@start
                                     // -1     0        1        2        3
@@FindIndexByValue:                  // xx 00000000 11111111 22222222 33333333 ....
  mov   ebx, offset CRC32Table-1     // �������� � ����� �� �������
@@FindIndexLoop:
    add   ebx, 4                     // �������� ��������� �� ��������� ������� ����� (CRC32Table - 1)+k*4 (k:1..256)
    cmp   [ebx], al                  // ����� ������� ���� �� ������� crc � ��������� �� ����������
  jne   @@FindIndexLoop              // ������ ���� �� ������ (����� ��� ������ �� ����� ���� �� ������) �� ������ �����
  sub   ebx, 3                       //
  mov   eax, [ebx]                   // � eax �������� �������� �� ������� � �������
  sub   ebx, offset CRC32Table       // �������� �������� ����� � �������
  shr   ebx, 2                       // ������������� � ������� �� ������� �����
  ret                                // �� ������ �� ��������� ������� eax ����� ����� ������ ����������
                                     // �� ������� � �������, � ������� bx � ����� ���� �������.
@@start:
  push  edi
  push  ebx
  mov   dword ptr [buffer], eax       //
  mov   dword ptr [buffer+4], edx     //
  mov   di, 4                        //  �������� � crcWanted 3 �����
@@computeReverseLoop:                //
//  mov   al, byte ptr //ss:[offset buffer+3+di]           //  �������� ����
  call  @@FindIndexByValue           //  ����� ������ � �������� �� �������� �����
  xor   dword ptr ss:[offset buffer+di], eax              //  ���������� ��������� �� ������� ������� DD � ������
  xor   byte ptr ss:[offset buffer+di-1], bl             //  ���������� �������� ���� ��������� �� 1 �����
  dec   di                           //  �� ��� ����� �� ������
  jnz   @@computeReverseLoop         //
  pop   ebx
  pop   edi
  mov   eax, dword ptr ss:[buffer]
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Crc32Correction(crcCurrent, crcWanted : DWord) : DWord;
  function FindIndexByValue(b : byte; var idx : byte) : dword;
  var
    i : Byte;
    P : PByteArray;
  begin
    Result := 0;
    P := @CRC32Table;
    //- ������� ���� ������ �������� �� ��� ����������� �����
    for i := 0 to 255 do begin
      //- ��������� ��� ������� ���� ������ � CRC.
      if (P^[(i*4)+3] = b) then begin
        //- ������� ������ ����������, ����������� ������� CRC, ��������
        idx := i;
        //- ������� ��������
        Result := CRC32Table[i];
        Exit;
      end;
    end;
  end; //StepBack - ������ �������� ������� � HiByte=Crc
var
  buffer : array [0..7] of byte;
  PDWord : ^DWord;
  i, idx : byte;
begin
  PDWord := Addr(buffer);
  PDWord^ := crcCurrent;
  Inc(PDWord); //- ����������� �� ��������� �������� �����
  PDWord^ := crcWanted;
  for i := 4 downto 1 do begin
    PDWord := Addr(buffer[i]);
    PDWord^ := PDWord^ xor FindIndexByValue(buffer[i+3], idx);
    buffer[i] := buffer[i-1] xor Lo(idx);
  end;
  PDWord := Addr(buffer);
  Result := PDWord^;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure WriteCrc32CorrectionToStream(Stream : TStream; const Pos : LongInt; const crcCurrent, crcWanted : DWord);
var
  BufValue : DWord;
begin
  Stream.Position := Pos;
  Stream.ReadBuffer(BufValue, SizeOf(BufValue));

  BufValue := Crc32Correction(crcCurrent, crcWanted);

  Stream.Position := Pos;
  Stream.WriteBuffer(BufValue, SizeOf(BufValue));
end;

{$ELSE METH1}
{ ------------------------------------------------------------------------------
  ��������� ��������� ����������� ������ ����� ������� �����������
  CRC �����  (c) ������ �����, ������� �������� �������� ��������������
  ------------------------------------------------------------------------------
  CrcFrom - ����� CRC ������� ����� � ������ ���������������� �����
  CrcTo - CRC ������� ����� �������� � ����� ����������������� �����
  lpData - ��������� �� ����� ���� ����� ��������� ������ ���������������� �����
  ------------------------------------------------------------------------------
  ��� ��������� �� ����� ������� � ���������� ����������
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure Crc32UpdateDelta(CrcFrom, CrcTo : DWord; lpData : Pointer);

  function StepBack(var Crc : DWord) : DWord;
  var
    I : DWord;
    L_Crc : DWord;
    L_CrcVar : DWord;
  begin
    Result := 0;
    L_CrcVar := Crc;
    //- ������� ���� ������ �������� �� ��� ����������� �����
    for I := 0 to 255 do begin
      //- ����� �������� �� ������� �� ������� � ������� ������������� ��� �� �������� CRC
      L_Crc := (CRC32Table[I] xor L_CrcVar);
      //- ��������� ��� ������� ���� ������ � CRC.
      if ((L_Crc shr 24) = 0) then begin
        Result := I;          // ������� ������ ����������, ����������� ������� CRC, ��������
        Crc := (L_Crc shl 8); // ������� ���������� �������� CRC
        Exit;
      end;
    end;
  end; //StepBack - ������ �������� ������� � HiByte=Crc

var
  Crc, A, B, C, D: DWord;
  P: PChar;
begin
  //- �������� ��������� � ���� �������� ��� ������� CRC
  CrcFrom := InvertCrc32(CrcFrom);
  CrcTo := InvertCrc32(CrcTo);

  //- 1. D, C, B, A - ����� � ������� �������� ��������� �� �������� ������� ����������� ����� CRC32
  D := StepBack(CrcTo);
  C := StepBack(CrcTo);
  B := StepBack(CrcTo);
  A := StepBack(CrcTo);
  //- 2. (X xor Crc) xor Crc = X - ���� ����� �������� ������� ���������
  //- ������ CRC - ������ ����������� ��

  Crc := CrcFrom;
  P := lpData;
  P^ := chr(A xor Crc);                 // ������� ���� ������� ������������ �� CRC ���� ������� ���� ������
  Crc := (Crc shr 8) xor Crc32Table[A]; // ������ ������ ��� ������� CRC

  inc(P);                               // ��������� ��������� ������ �� ��������� ����
  P^ := chr(B xor Crc);                 // ������� ���� ������� ������������ �� CRC ���� ������� ���� ������
  Crc := (Crc shr 8) xor Crc32Table[B];

  inc(P);
  P^ := chr(C xor Crc);                 // ������� ���� ������� ������������ �� CRC ���� ������� ���� ������
  Crc := (Crc shr 8) xor Crc32Table[C];

  inc(P);
  P^ := chr(D xor Crc);                 // ������� ���� ������� ������������ �� CRC ���� ������� ���� ������
end; //- Crc32UpdateDelta

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure WriteCrc32CorrectionToStream(Stream : TStream; const Pos : LongInt; const CrcFrom, CrcTo : DWord);
var
  BufValue : DWord;
begin
  Stream.Position := Pos;
  Stream.ReadBuffer(BufValue, SizeOf(BufValue));

  Crc32UpdateDelta(CrcFrom, CrcTo, @BufValue);

  Stream.Position := Pos;
  Stream.WriteBuffer(BufValue, SizeOf(BufValue));
end;
{$ENDIF METH1}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function FindSignInStream(Stream: TStream; const FromPos : LongInt; const Pattern : PByteArray; PatternSize: LongInt; var Offset : LongInt): Boolean;
var
  Buffer: PByteArray;
  BufSize: LongInt;
  ToRead: LongInt;
  Count : LongInt;
  BuffOffset : LongInt;

  function Search(Buffer, Pattern : PByteArray; var BuffOffset : LongInt) : Integer;
  var
    I : LongInt;
    J : LongInt;
  begin
    for J := 0 to BufSize-1 do begin
      if (Buffer^[J] = Pattern^[0]) then begin
        I := 1;
        while (I < PatternSize) and ((J + I) < BufSize) and (Buffer^[(J + I)] = Pattern^[I]) do Inc(I);
        //- ���� I ������ ����� ������� ��������� �� ���
        if (I = PatternSize) then begin
          Result := 0; //- ������ ����������
          //-
          BuffOffset := J;
          Exit;
        end else begin
          if ((J + I) = BufSize) then begin
            Result := 1; //- ��������� ����������
            //-
            BuffOffset := J;
            Exit;
          end;
        end;
      end; //- if (Buffer^[J] = Pattern^[0])
    end;
    Result := 2; // �� ������� ������
    BuffOffset := 0; // �� ������� � ������
  end;

begin
  //- ��������������� � ������� FromPos
  Stream.Position := FromPos;
  //- ����� ������
  Count := Stream.Size;
  //- ���� ������ ������ �������� �� ����� �������� ����������
  if (Count > IoPageSize) then BufSize := IoPageSize
  else BufSize := Count;
  GetMem(Buffer, BufSize);
  try
    //- ���� �� ��������� ����� ������
    while (Stream.Position < Stream.Size) do begin
      //- �������� ������� ��� ������
      ToRead := (Stream.Size - Stream.Position);
      if (ToRead > BufSize) then ToRead := BufSize;
      //- ��������� ������ �� ������
      Stream.ReadBuffer(Buffer^, ToRead);
      //- ������ ���������
      case Search(Buffer, Pattern, BuffOffset) of
        0 : begin // ������ ����������
          //- ������� �������� ������ ����������
          Offset := Stream.Position - ToRead + BuffOffset;
          Result := True;
          Exit; //- �������� Exit �������� finally !!!! ����������� ������� ���� - �������...
        end;
        1 : begin // �������� ������� �� ������� �������
          //- �������� ��������� ������ �� ������ ����������
          Stream.Position := (Stream.Position - ToRead + BuffOffset);
        end;
        //else // �� �������
      end;
    end;
  finally
    FreeMem(Buffer);
  end;
  Result := False;
end; //- FindSignInStream

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure WriteCrc32ToStream(Stream : TStream; const Crc32 : DWord; Offset : LongInt);
var
  SavePos : LongInt;
begin
  SavePos := Stream.Position;
  Stream.Position := Offset;
  Stream.WriteBuffer(Crc32, SizeOf(Crc32));
  Stream.Position := SavePos;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function WriteCrcAndCorrectionToStream(FileNameFrom, FileNameTo : String) : Boolean;
var
  FS: TFileStream;
  CE : DWord;             //- ����������� ����� ����� ��������� F0 "�����������" �����
{$IFDEF DEBUG}
  ResultFileCrc : DWord;  //- ����������� ����� ����������� ����� F1 (������ ��������� � ����������)
{$ENDIF DEBUG}

  C1 : DWord;             //- ����������� ����� � ������������ ������ � ����� ����� ���������
  C2 : DWord;             //- ����������� ����� � ���������� ������ � ����� ������ ����� ���������

  Pattern : PByteArray;
  Offset : LongInt;
const
  PatternSize = 8;        //- ����� ����� 8 ����
begin
  Result := False;
  if (AnsiCompareFileName(FileNameFrom, FileNameTo) = 0) then begin
    FileNameTo := FileNameFrom;
  end else begin
    //- ���� ����� ������ �� ���������� ����
    if not CopyFile(PChar(FileNameFrom), PChar(FileNameTo), False) then Exit;
  end;

  try
    FS := TFileStream.Create(FileNameTo, (fmOpenReadWrite or fmShareDenyWrite));
  except
    Exit;
  end;

  try

    // ����� ����� ������ ������ ��������� � ����� ������������� � ������� FS
    // �������� ��������� �������� ����� ���������� ������������� � ��������
    //......
    // MakeSomeChanges(FS);
    //......
    // � ������ ��� ���� ������ CRC � ���� ������ � ��������� ����������

    //- ������� CRC-32 �� �������� �����
    CE := Crc32NextStream(FS, 0, FS.Size, 0);

    Pattern := @ExamplePattern;
    //- ���� �������� ��������� � �����!
    if FindSignInStream(FS, 0, Pattern, PatternSize, Offset) then begin
      //- ����������� ����������� ����� �� ����� ���������������� ����� B2
      C1 := Crc32NextStream(FS, 0, Offset+PatternSize, 0);

      //- ����� CRC - �������� ���� B1
      WriteCrc32ToStream(FS, CE, Offset);

      //- ��������� ����������� ����� �� ������ ����������������� ����� ����� �������� ���� ���������
      C2 := Crc32NextStream(FS, 0, Offset+(PatternSize shr 1), 0);

      //- ��������������� CRC ������� ������ ����� ����� �����
      WriteCrc32CorrectionToStream(FS, Offset+4, C2, C1);
{$IFDEF DEBUG}
      //- �������
      Assert(C1 = Crc32NextStream(FS, 0, Offset+PatternSize, 0), '����� ��������� ����� CRC �� ������.');
      //- ��������� ����������� ����� ����� ���� ��������
      ResultFileCrc := Crc32NextStream(FS, 0, FS.Size, 0);
      //- �������
      Assert((CE = ResultFileCrc), Format('�������� � �������������� CRC �� �����! %x - %x',[CE, ResultFileCrc]));
{$ENDIF DEBUG}
    end;
  except
    FS.Free;
    raise;
  end;
  FS.Free;

  Result := True;
end;

end.
