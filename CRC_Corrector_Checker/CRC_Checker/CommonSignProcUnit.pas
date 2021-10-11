unit CommonSignProcUnit;

interface

{$A-}  //- выключить выравнивание
type
  PDword = ^LongWord;

var
  CRC : PDword; //- ”казатель на €чейку CRC

const
  CRCSize = 4;  //- размер €чейки где лежит CRC

implementation

uses
  Windows;

{
  данные пр€чем в функции-сигнатуре
  она возвращает указатель на CRC значение 
}
function _mcorr_ : PDword;
asm
  jmp @@exit
@@bufbegin:
  //- пр€мо в сегменте кода расположим нашу CRC и корректировочные значени€ но кода нужно бы побольше написать
  DW  0C3C3h,0C3C3h   //- сюда мы будем писать CRC-32
  DW  0C3C3h,0C3C3h   //- четыре подгоночных байта дл€ восстановлени€ CRC-32
@@exit:
  mov     eax, offset @@bufbegin
end;

procedure Init;
begin
  CRC := _mcorr_;
end;

initialization
  Init;

end.
