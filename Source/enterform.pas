unit enterform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Data.DB,
  Vcl.ExtCtrls, RegularExpressions;

type
  TloginForm = class(TForm)
    login_title: TLabel;
    loginField: TEdit;
    passwordField: TEdit;
    login_description: TLabel;
    enter_btn: TImage;
    deny_btn: TImage;
    login_subtitle: TLabel;
    reg_btn: TImage;
    arrow_btn: TImage;
    Edit1: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure passwordFieldClick(Sender: TObject);
    procedure loginFieldClick(Sender: TObject);
    procedure deny_btnClick(Sender: TObject);
    procedure enter_btnClick(Sender: TObject);
    procedure reg_btnClick(Sender: TObject);
    procedure arrow_btnClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const valid = '^[\w-.]{0,24}$';

var
  loginForm: TloginForm;
  RegState:boolean;
  last_date:string;

implementation

{$R *.dfm}

uses login, enter, themes, main, database, WinSock;

function GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

procedure TloginForm.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TloginForm.deny_btnClick(Sender: TObject);
begin
  edit1.Visible := true;
  showLogin.Enabled:=true;
  login_subtitle.Visible:=true;
  reg_btn.Visible:=true;
  loginForm.close;
end;

procedure TloginForm.enter_btnClick(Sender: TObject);
var check_ban:integer;
begin
  if (AnsiCompareStr(loginField.Text, '������� �����') = 0) AND (AnsiCompareStr(passwordField.Text, '������� ������') = 0) then
  begin
    showmessage('��������� ���� ����� ������!');
    exit;
  end;
  if (RegState = true) then// ���� �����������
  begin // �������� �� ���������� user name
    db.QueryReg.SQL.Text := 'SELECT * FROM users WHERE u_login = '+QuotedStr(loginField.Text);
    db.QueryReg.Open;
    if db.QueryReg.IsEmpty then
    begin // �������� �� ��������� ������ � ������
      if (length(loginField.text) < 24) and (length(passwordField.text) < 24) and (length(loginField.text) > 3) and (length(passwordField.text) > 3) and (TRegEx.IsMatch(loginField.Text, valid)) and (TRegEx.IsMatch(passwordField.Text, valid)) then
      begin // ������� � ��
        try
          db.QueryReg.SQL.Clear;
          db.QueryReg.SQL.Add('INSERT INTO users (u_login, u_pass, u_ipReg, u_ipEnter, u_dataReg, u_lastEnter) VALUES ('+QuotedStr(loginField.Text)+', '+QuotedStr(passwordField.Text)+', '+QuotedStr(GetLocalIP)+', '+QuotedStr(GetLocalIP)+', '+QuotedStr(last_date)+', '+QuotedStr(last_date)+');');
          db.QueryReg.Execute;
        finally // �������� ����� ���������� ����� ����
          db.QueryReg.Free;
          showLogin.close;
          RegState:=false;
          theme.Show;
          loginForm.close;
        end;
      end
      else showmessage('���� ������ �������� �� ��������� �������� ������� �� ����� 4-� �������� � �� ����� 24-�');
    end
    else showmessage('����� ������������ ��� ����������!');
  end
  else if (RegState = false) then  //�����������
  begin // ��������� �� ������������ ������
    db.QueryAuth.SQL.Text := 'SELECT * FROM users WHERE u_login = '+QuotedStr(loginField.Text)+' AND u_pass = '+QuotedStr(passwordField.Text)+';';
    db.QueryAuth.Open;

    if (db.QueryAuth.IsEmpty = false) AND (AnsiCompareStr(loginField.Text, db.QueryAuth['u_login']) = 0) AND (AnsiCompareStr(passwordField.Text, db.QueryAuth['u_pass']) = 0) then
    begin // ���� ����������, �� �������� �� ������� ����
//      db.QueryAuth.SQL.Text := 'SELECT u_theme FROM users WHERE u_login = '+QuotedStr(loginField.Text);
//      db.QueryAuth.Open;

      if db.QueryAuth['u_theme'] = -1 then
      begin // ���� ���� ��� ������� ����� ����
        showLogin.Enabled := true;
        showLogin.close;
        theme.Show;
        loginForm.close;
      end
      else
      begin      // ���� ��� ����� � ���� ������� ���������� ������� ��������
        check_ban := db.QueryAuth['u_ban'];
        if  check_ban > 0 then
        begin
          showmessage('��� ������� ������������ �� '+inttostr(check_ban)+' �.');
          exit;
        end;
        db.QueryAuth.SQL.Clear;
        db.QueryAuth.SQL.Add('UPDATE users SET u_lastEnter = '+QuotedStr(last_date)+', u_ipEnter = '+QuotedStr(GetLocalIP)+' WHERE u_login = '+QuotedStr(loginForm.loginField.Text));
        db.QueryAuth.Execute;
        homePage.show;
        showLogin.close;
        firstEnterprice.Hide;
        loginForm.close;
      end;
    end
    else showmessage('����� ��� ������ ������ �������!');
  end;
end;

procedure TloginForm.FormActivate(Sender: TObject);
begin
  last_date := FormatDateTime('dd.mm.yyyy', now);
  edit1.Visible := true;
  loginForm.Edit1.SetFocus;
  loginForm.edit1.Visible := false;
  login_subtitle.Caption := '���� � ��� ���� ��������,'+chr(13)+'�� �������'+'       ';
  RegState:=false;
  login_subtitle.Visible:=true;
  reg_btn.Visible:=true;
  enter_btn.Picture.LoadFromFile('images/enter-btn.png');
end;

procedure TloginForm.FormPaint(Sender: TObject);
var bg:TBitMap;
begin
  bg := TBitmap.Create;
  bg.LoadFromFile('images/bg-login.bmp');
  loginForm.Canvas.Draw(0, 0, bg);
  bg.Free;
end;

procedure TloginForm.arrow_btnClick(Sender: TObject);
begin
  loginForm.deny_btnClick(nil);
end;

procedure TloginForm.loginFieldClick(Sender: TObject);
begin
  loginField.Text:='';
end;

procedure TloginForm.passwordFieldClick(Sender: TObject);
begin
  passwordField.Text:='';
  passwordField.PasswordChar:=#42;
end;

procedure TloginForm.reg_btnClick(Sender: TObject);
begin
  loginForm.edit1.Visible := true;
  loginForm.Edit1.SetFocus;
  loginForm.edit1.Visible := false;
  RegState:=true;
  loginForm.loginField.Text:='������� �����';
  loginForm.passwordfield.Text:='������� ������';
  loginForm.passwordField.PasswordChar:=#0;
  login_title.Caption := '�����������';
  login_description.Left:=88;
  login_description.Caption := '���������  ���� ����� ������������������';
  login_subtitle.Visible:=false;
  reg_btn.Visible:=false;
  enter_btn.Picture.LoadFromFile('images/reg-btn.png');
end;

end.
