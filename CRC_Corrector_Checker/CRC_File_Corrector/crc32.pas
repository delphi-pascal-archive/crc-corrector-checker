unit crc32;

{
Данный модуль в своем большинстве взят из проекта Андрея Рубина немного окультурен
}

{$INCLUDE crc32.inc}

interface

uses
  Classes, SysUtils;

type
  DWord = LongWord;
  TCRC32Table = array [Byte] of DWord;
  PCRC32Table = ^TCRC32Table;

const
  //- размер страницы для буфера обмена
  IoPageSize = 8192 * 2; // 16 Kb

{$IFDEF USE_FILLED_TABLE}
const
  //- готовая таблица значений
  CRC32Table: TCRC32Table = (
    $00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F, $E963A535,
    $9E6495A3, $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD,
    $E7B82D07, $90BF1D91, $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D,
    $6DDDE4EB, $F4D4B551, $83D385C7, $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4,
    $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C,
    $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC,
    $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB,
    $B6662D3D, $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589, $06B6B51F,
    $9FBFE4A5, $E8B8D433, $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB,
    $086D3D2D, $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA,
    $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE,
    $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A,
    $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409,
    $CE61E49F, $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81,
    $B7BD5C3B, $C0BA6CAD, $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739,
    $9DD277AF, $04DB2615, $73DC1683, $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1, $F00F9344, $8708A3D2, $1E01F268,
    $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7, $FED41B76, $89D32BE0,
    $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8,
    $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF,
    $4669BE79, $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703,
    $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7,
    $B5D0CF31, $2CD99E8B, $5BDEAE1D, $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713, $95BF4A82, $E2B87A14, $7BB12BAE,
    $0CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242,
    $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777, $88085AE6,
    $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D,
    $3E6E77DB, $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5,
    $47B2CF7F, $30B5FFE9, $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605,
    $CDD70693, $54DE5729, $23D967BF, $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D
  );
{$ELSE}
const
  //- базовый полином для вычисления CRC32
  Crc32Polynomial : DWord = $EDB88320;
var
  CRC32Table: array [Byte] of DWord;
{$ENDIF}

{$IFNDEF USE_FILLED_TABLE}
  function Crc32Initialization: PCRC32Table;
{$ENDIF USE_FILLED_TABLE}
  //- инверсия CRC
  function InvertCrc32(Crc32: DWord): DWord;
  //- Вычисление CRC следующего блока
  function Crc32Next(CRC32Current: DWord; const Data; Count: DWord): DWord;
  //- Вычисление CRC потока
  function Crc32NextStream(Source: TStream; FromPosition, Count: DWord; Crc32Init: DWord): DWord;
  //- Вычисление CRC файла
  function Crc32File(const FileName : String; var Crc : DWord) : Boolean;

implementation

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function InvertCrc32(Crc32: DWord): DWord;
asm
  not   eax
end; //- of InvertCrc32

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Crc32Next(CRC32Current: DWord; const Data; Count: DWord): DWord;
asm //eax - CRC32Current; edx - Data; ecx - Count
  test  ecx, ecx
  jz    @@exit
  push  esi
  mov   esi, edx  //data
@@loop:
    mov edx, eax                       // копируем текущий CRC в edx (все кроме dl потом будет красиво сброшено xor)
    lodsb                              // грузим следующий байт из буффера данных в al
    xor edx, eax                       // данными из буфера инвертируем dl (все старшие байты edx будут сброшены)
                                       // тоесть в edx - у нас инвертированый данными из буфера младший байт CRC-аккумулятора 
    shr eax, 8                         // сместим ah в al
    shl edx, 2                         // преобразуем байт из буфера в индекс на элемент массива edx * 4
                                       // массив 256 элементов * 4 хотя можно было бы написать CRC32Table[edx*4]
    xor eax, dword ptr CRC32Table[edx] // вычислить следующее значние CRC 
    dec   ecx
  jnz   @@loop                         // крутиться пока не исчерпается ecx
  pop   esi
@@exit:
end; //- of Crc32Next

{$IFNDEF USE_FILLED_TABLE}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Crc32Initialization: PCRC32Table;
asm
  push    edi       //- портить edi не рекомендуется
  std               //- установить обратное направление сканирования
  mov     edi, offset CRC32Table+ ($400-4)  // ставим edi на последний DWORD элемент таблицы
  mov     edx, $FF  //- количество элементов таблицы
@im0:
  mov     eax, edx  //- индекс элемента таблицы в eax
  mov     ecx, 8    //- будем делать восемь сдвигов индекса элемента таблицы
@im1:
  shr     eax, 1    //- сдвинуть вправо
  jnc     @Bit0     //- если небыло переноса
  xor     eax, Crc32Polynomial // если был перенос - инвертнуть полиномом
@Bit0:
  dec     ecx       //- уменишить ecx
  jnz     @im1      //- если ecx не 0 то повторить формирование значения
  stosd             //- сохранить eax в таблице
  dec     edx       //- индекс на один элемент назад
  jns     @im0      //- повторять для индексов включая 0 тоесть пока не станет -1
  cld               //- сбросить флаг направления сканирования
  pop     edi       //- восстановить edi
  mov     eax, offset CRC32Table
end; //- Crc32Initialization
{$ENDIF USE_FILLED_TABLE}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Crc32NextStream(Source: TStream; FromPosition, Count: DWord; Crc32Init: DWord): DWord;
var
  BufSize : DWord;
  N : DWord;
  Buffer : PChar;
begin
  //- делаем функцияю повторно вызываемой (для этого нужно стартовать с инверсии стартового значения)
  Result := InvertCrc32(Crc32Init);
  if (Count = 0) then Exception.Create('не буду считать ЦЫРС для пустого блока');
  //- позиционировать на позицию начала отсчета
  Source.Position := FromPosition;
  //- проверить размер
  if (Count > (Source.Size-Source.Position)) then Count := Source.Size;

  //- если размер больше страницы то будем работать страницами
  if (Count > IoPageSize) then BufSize := IoPageSize
    else BufSize := Count;

  GetMem(Buffer, BufSize);

  try
    while (Count <> 0) do begin
      if (Count > BufSize) then N := BufSize
        else N := Count;
      Source.ReadBuffer(Buffer^, N);
      Result := Crc32Next(Result, Buffer^, N);
      Dec(Count, N);
    end;
  except
    FreeMem(Buffer);
    raise;
  end;
  FreeMem(Buffer);
  Result := InvertCrc32(Result);
end; //- Crc32NextStream

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Crc32File(const FileName : String; var Crc : DWord) : Boolean;
var
  Stream: TFileStream;
begin
  Result := False;
  try
    Stream := TFileStream.Create(FileName, (fmOpenRead or fmShareDenyNone));
  except
    Crc := 1;
    Exit;
  end;
  try
    Crc := Crc32NextStream(Stream, 0, Stream.Size, 0);
  except
    Stream.Free;
    Crc := 2;
    Exit;
  end;
  Stream.Free;
  Result := True;
end;

initialization
begin
{$IFNDEF USE_FILLED_TABLE}
  Crc32Initialization;
{$ENDIF USE_FILLED_TABLE}
end;

end.
