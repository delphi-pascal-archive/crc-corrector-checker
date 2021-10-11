unit FileCRCCorrectorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFileCRCCorrectorForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FileCRCCorrectorForm: TFileCRCCorrectorForm;

implementation

uses
  CRCCorrectorUnit,
  crc32;

{$R *.DFM}

procedure TFileCRCCorrectorForm.FormCreate(Sender: TObject);
begin
  Edit2.Text := Format('%x:%x', [ExamplePattern[0], ExamplePattern[1]]);
  Edit2.Enabled := False;
  Edit2.Color := clBtnFace;
end;

procedure TFileCRCCorrectorForm.Button1Click(Sender: TObject);
begin
  if (Edit3.Text = Edit1.Text) then begin
    ShowMessage('Вы собрались испортить файл источник. :)');
    Exit;
  end;
  if WriteCrcAndCorrectionToStream(Edit3.Text, Edit1.Text)
  then ShowMessage('Файл пропатчен успешно.');
end;

end.
 