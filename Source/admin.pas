unit admin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtDlgs, RegularExpressions,
  Vcl.ComCtrls;

type
  Tadmin_control = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    choose_type: TComboBox;
    src_upload: TButton;
    link: TEdit;
    Button4: TButton;
    Button5: TButton;
    Edit4: TEdit;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    cContent: TButton;
    upload: TOpenPictureDialog;
    c_title: TRichEdit;
    c_description: TRichEdit;
    SavePictureDialog1: TSavePictureDialog;
    procedure Button8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure src_uploadClick(Sender: TObject);
    procedure cContentClick(Sender: TObject);
    procedure c_titleClick(Sender: TObject);
    procedure c_descriptionClick(Sender: TObject);
    procedure linkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//const link_to_picture = '^[\w-.]{0,24}$';
const downloadReg = '^https://|www.|http://+[\w-=?!./]$';

var
  admin_control: Tadmin_control;
  link_picture:string;
  content_type:integer;

implementation

{$R *.dfm}

uses content, database, enter, enterform, login, main, themes;

procedure Tadmin_control.Button1Click(Sender: TObject);
begin
 choose_type.Visible := true;
 c_title.Visible := true;
 c_description.Visible := true;
 src_upload.Visible := true;
 link.Visible := true;
 cContent.Visible := true;
end;

procedure Tadmin_control.Button8Click(Sender: TObject);
begin
  admin_control.Close;
end;

procedure Tadmin_control.cContentClick(Sender: TObject);
//const url = '^(http|https)://([wd-]+(.[wd-]+)+)(([wd-=?\./]+)+)$';
//const picha = '^[\w-_.]+.png|.bmp{0,100}$';
//var test:string;
var file_name : string;
begin
  if not TRegEx.IsMatch(link.Text, downloadReg) then begin showmessage('������ ������ ��������� https/http/www ��������. ������ https://site.ru. ��������� ������ �� ������������.'); exit end;
  //if not TRegEx.IsMatch(test, picha) then begin showmessage('����������� ������ ���� ������ � ������� *.png, *.jpg � *.bmp'); exit end;
  if choose_type.ItemIndex = -1 then begin showmessage('�������� ��� ��������'); exit end;
  if (AnsiCompareText(c_title.lines.Text, '������� ���������') = 0) AND (length(c_title.Lines.Text) < 6) then begin showmessage('��������� ��� ��������� ���� ���������'); exit end;
  if (AnsiCompareText(c_description.lines.Text, '������� ��������') = 0) AND (length(c_description.Lines.Text) < 6) then begin showmessage('��������� ��� ��������� ���� ��������'); exit end;
  if link_picture.IsEmpty then begin showmessage('������� ���� � ��������'); exit end;
  if (AnsiCompareText(link.Text, '������ �� ����������') = 0) AND (length(link.Text) < 6) then begin showmessage('��������� ���� ����������'); exit end;

  content_type := choose_type.ItemIndex;
  file_name := ExtractFileName( link_picture );
  link_picture := 'uploads/'+file_name;
//  if not TRegEx.IsMatch(link.Text, url) then begin showmessage('�������� ������'); exit end;

  db.QueryContent.SQL.Clear;
  db.QueryContent.SQL.Add('INSERT INTO content (c_type, c_src, c_title, c_description, c_download) VALUES ('+QuotedStr(inttostr(content_type))+','+QuotedStr(link_picture)+','+QuotedStr(c_title.Lines.Text)+','+QuotedStr(c_description.Text)+','+QuotedStr(link.Text)+');');
  db.QueryContent.Execute;

  ShowMessage('������� ��������');

  //resets
  choose_type.ItemIndex := -1;
  link.Text := '������ �� ����������';
  c_title.Lines.Text := '������� ���������';
  c_description.Lines.Text := '������� ��������';
  link_picture := '';

  admin_control.Hide;
  
end;

procedure Tadmin_control.c_descriptionClick(Sender: TObject);
begin
  if (length(c_description.Lines.Text) > 0 )  AND (not ansicomparetext(c_description.Lines.Text, '������� ��������') = 0) then c_description.Lines.Text := c_description.Lines.Text
  else c_description.Lines.Text := '';
end;

procedure Tadmin_control.c_titleClick(Sender: TObject);
begin
  if (length(c_title.Lines.Text) > 0 )  AND (not ansicomparetext(c_title.Lines.Text, '������� ��������') = 0) then c_title.Lines.Text := c_title.Lines.Text
  else c_title.Lines.Text := '';
end;

procedure Tadmin_control.linkClick(Sender: TObject);
begin
  if (length(link.Text) > 0 )  AND (not ansicomparetext(link.Text, '������ �� ����������') = 0) then link.Text := link.Text
  else link.Text := '';
end;

procedure Tadmin_control.src_uploadClick(Sender: TObject);
begin
  upload.Execute();
  link_picture := upload.FileName;
  showLogin.Hide;
  showLogin.Close;
end;

end.