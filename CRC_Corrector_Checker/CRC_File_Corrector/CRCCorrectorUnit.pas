unit CRCCorrectorUnit;

interface

uses
  SysUtils, Classes, Windows,
  Dialogs,
  crc32;

var
  //- этот заполнитель будем искать в изменяемом файле
  ExamplePattern : array[0..1] of DWord= ($C3C3C3C3,$C3C3C3C3);

function WriteCrcAndCorrectionToStream(FileNameFrom, FileNameTo : String) : Boolean;

implementation

{$DEFINE DEBUG}
{.$DEFINE METH1} //- другой вариант алгоритма коррекции CRC - пока что не отлажен

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
  mov   ebx, offset CRC32Table-1     // начинать с байта до таблицы
@@FindIndexLoop:
    add   ebx, 4                     // сместить указатель на следующее двойное слово (CRC32Table - 1)+k*4 (k:1..256)
    cmp   [ebx], al                  // взять старший байт из таблицы crc и проверить на совпадение
  jne   @@FindIndexLoop              // искать пока не найдем (здесь нет выхода из цикла если не найдем) но найдем точно
  sub   ebx, 3                       //
  mov   eax, [ebx]                   // в eax получить значение по индексу в таблице
  sub   ebx, offset CRC32Table       // получить смещение байта в таблице
  shr   ebx, 2                       // преобразовать к индексу на двойное слово
  ret                                // На выходе из процедуры регистр eax будет иметь полное содержимое
                                     // из позиции в таблице, а регистр bx – номер этой позиции.
@@start:
  push  edi
  push  ebx
  mov   dword ptr [buffer], eax       //
  mov   dword ptr [buffer+4], edx     //
  mov   di, 4                        //  начинаем с crcWanted 3 цикла
@@computeReverseLoop:                //
//  mov   al, byte ptr //ss:[offset buffer+3+di]           //  получить байт
  call  @@FindIndexByValue           //  найти индекс и значение по старшему байту
  xor   dword ptr ss:[offset buffer+di], eax              //  инвертнуть значением из таблицы текущее DD в буфере
  xor   byte ptr ss:[offset buffer+di-1], bl             //  инвертнуть индексои байт смещенный на 1 назад
  dec   di                           //  на шаг назад по буферу
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
    //- функция ищет индекс значения по его контрольной сумме
    for i := 0 to 255 do begin
      //- проверить что старшый байт совпал с CRC.
      if (P^[(i*4)+3] = b) then begin
        //- вернуть индекс совпавшего, образующего входной CRC, элемента
        idx := i;
        //- вернуть значение
        Result := CRC32Table[i];
        Exit;
      end;
    end;
  end; //StepBack - индекс элемента массива с HiByte=Crc
var
  buffer : array [0..7] of byte;
  PDWord : ^DWord;
  i, idx : byte;
begin
  PDWord := Addr(buffer);
  PDWord^ := crcCurrent;
  Inc(PDWord); //- передвигает на следующее двойного слово
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
  Процедура вычисляет поправочные четыре байта которые восстановят
  CRC файла  (c) Андрей Рубин, немного изменена Виталием Царегородцевым
  ------------------------------------------------------------------------------
  CrcFrom - новый CRC который имеем в начале коректировояного блока
  CrcTo - CRC который нужно получить в конце корректировочного блока
  lpData - указатель на буфер куда будут сохранены четыре корректировочных байта
  ------------------------------------------------------------------------------
  Эту процедуру не нужно хранить в защищенном приложении
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
    //- функция ищет индекс значения по его контрольной сумме
    for I := 0 to 255 do begin
      //- взять значение из таблицы по индексу и побитно инвертировать его по входному CRC
      L_Crc := (CRC32Table[I] xor L_CrcVar);
      //- проверить что старшый байт совпал с CRC.
      if ((L_Crc shr 24) = 0) then begin
        Result := I;          // вернуть индекс совпавшего, образующего входной CRC, элемента
        Crc := (L_Crc shl 8); // вернуть предыдущее значение CRC
        Exit;
      end;
    end;
  end; //StepBack - индекс элемента массива с HiByte=Crc

var
  Crc, A, B, C, D: DWord;
  P: PChar;
begin
  //- привести параметры к виду готовому для расчета CRC
  CrcFrom := InvertCrc32(CrcFrom);
  CrcTo := InvertCrc32(CrcTo);

  //- 1. D, C, B, A - поиск в таблице индексов элементов со старшими байтами образующими новый CRC32
  D := StepBack(CrcTo);
  C := StepBack(CrcTo);
  B := StepBack(CrcTo);
  A := StepBack(CrcTo);
  //- 2. (X xor Crc) xor Crc = X - зная какие элементы таблицы формируют
  //- нужный CRC - просто подставляем их

  Crc := CrcFrom;
  P := lpData;
  P^ := chr(A xor Crc);                 // младший байт индекса инвертнутого на CRC дает искомый байт буфера
  Crc := (Crc shr 8) xor Crc32Table[A]; // делаем прямой шаг расчета CRC

  inc(P);                               // переводим указатель буфера на следующий байт
  P^ := chr(B xor Crc);                 // младший байт индекса инвертнутого на CRC дает искомый байт буфера
  Crc := (Crc shr 8) xor Crc32Table[B];

  inc(P);
  P^ := chr(C xor Crc);                 // младший байт индекса инвертнутого на CRC дает искомый байт буфера
  Crc := (Crc shr 8) xor Crc32Table[C];

  inc(P);
  P^ := chr(D xor Crc);                 // младший байт индекса инвертнутого на CRC дает искомый байт буфера
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
        //- если I достиг конца буффера сигнытуры то это
        if (I = PatternSize) then begin
          Result := 0; //- полное совпадение
          //-
          BuffOffset := J;
          Exit;
        end else begin
          if ((J + I) = BufSize) then begin
            Result := 1; //- частичное совпадение
            //-
            BuffOffset := J;
            Exit;
          end;
        end;
      end; //- if (Buffer^[J] = Pattern^[0])
    end;
    Result := 2; // не найдено ничего
    BuffOffset := 0; // не смещено в буфере
  end;

begin
  //- позиционировать в позицию FromPos
  Stream.Position := FromPos;
  //- взять размер
  Count := Stream.Size;
  //- если размер больше страницы то будем работать страницами
  if (Count > IoPageSize) then BufSize := IoPageSize
  else BufSize := Count;
  GetMem(Buffer, BufSize);
  try
    //- пока не достигнут конец потока
    while (Stream.Position < Stream.Size) do begin
      //- смотреть сколько еще читать
      ToRead := (Stream.Size - Stream.Position);
      if (ToRead > BufSize) then ToRead := BufSize;
      //- прочитать буффер из потока
      Stream.ReadBuffer(Buffer^, ToRead);
      //- искать сигнатуру
      case Search(Buffer, Pattern, BuffOffset) of
        0 : begin // полное совпадение
          //- вернуть смещение начала совпадения
          Offset := Stream.Position - ToRead + BuffOffset;
          Result := True;
          Exit; //- ВНИМАНИЕ Exit выполнит finally !!!! внимательно читайте хелп - полезно...
        end;
        1 : begin // частично найдено на границе буффера
          //- сдвинуть указатель потока на начало совпадения
          Stream.Position := (Stream.Position - ToRead + BuffOffset);
        end;
        //else // не найдено
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
  CE : DWord;             //- контрольная сумма всего исходного F0 "непатченого" файла
{$IFDEF DEBUG}
  ResultFileCrc : DWord;  //- контрольная сумма полученного файла F1 (должна совпадать с предыдущей)
{$ENDIF DEBUG}

  C1 : DWord;             //- контрольная сумма с НЕизмененным файлом в конце блока коррекции
  C2 : DWord;             //- контрольная сумма с измененным блоком в точке начала блока коррекции

  Pattern : PByteArray;
  Offset : LongInt;
const
  PatternSize = 8;        //- длина блока 8 байт
begin
  Result := False;
  if (AnsiCompareFileName(FileNameFrom, FileNameTo) = 0) then begin
    FileNameTo := FileNameFrom;
  end else begin
    //- если имена разные то копировать файл
    if not CopyFile(PChar(FileNameFrom), PChar(FileNameTo), False) then Exit;
  end;

  try
    FS := TFileStream.Create(FileNameTo, (fmOpenReadWrite or fmShareDenyWrite));
  except
    Exit;
  end;

  try

    // здесь можно делать всякие изменения в файле асоциированом с потоком FS
    // например прописать серийный номер приложения асоциированый с клиентом
    //......
    // MakeSomeChanges(FS);
    //......
    // а дальше уже идет запись CRC в одну ячейку и коррекция результата

    //- считаем CRC-32 на исходном файле
    CE := Crc32NextStream(FS, 0, FS.Size, 0);

    Pattern := @ExamplePattern;
    //- ищем смещение сигнатуры в файле!
    if FindSignInStream(FS, 0, Pattern, PatternSize, Offset) then begin
      //- Расчитываем контрольную сумму до конца коректировочного блока B2
      C1 := Crc32NextStream(FS, 0, Offset+PatternSize, 0);

      //- пишем CRC - изменяем блок B1
      WriteCrc32ToStream(FS, CE, Offset);

      //- Вычислить контрольную сумму до начала корректировочного блока после внесения всех изменений
      C2 := Crc32NextStream(FS, 0, Offset+(PatternSize shr 1), 0);

      //- Скорректировать CRC изменяя четыре байта после блока
      WriteCrc32CorrectionToStream(FS, Offset+4, C2, C1);
{$IFDEF DEBUG}
      //- отладка
      Assert(C1 = Crc32NextStream(FS, 0, Offset+PatternSize, 0), 'После коррекции блока CRC не совпал.');
      //- Вычислить контрольную сумму после всех действий
      ResultFileCrc := Crc32NextStream(FS, 0, FS.Size, 0);
      //- отладка
      Assert((CE = ResultFileCrc), Format('Исходный и результирующий CRC не равны! %x - %x',[CE, ResultFileCrc]));
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
