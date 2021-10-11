unit CommonSignProcUnit;

interface

{$A-}  //- ��������� ������������
type
  PDword = ^LongWord;

var
  CRC : PDword; //- ��������� �� ������ CRC

const
  CRCSize = 4;  //- ������ ������ ��� ����� CRC

implementation

uses
  Windows;

{
  ������ ������ � �������-���������
  ��� ���������� ��������� �� CRC �������� 
}
function _mcorr_ : PDword;
asm
  jmp @@exit
@@bufbegin:
  //- ����� � �������� ���� ���������� ���� CRC � ���������������� �������� �� ���� ����� �� �������� ��������
  DW  0C3C3h,0C3C3h   //- ���� �� ����� ������ CRC-32
  DW  0C3C3h,0C3C3h   //- ������ ����������� ����� ��� �������������� CRC-32
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
