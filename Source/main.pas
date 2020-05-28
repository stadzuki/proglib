unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Data.DB,
  Vcl.StdCtrls, RegularExpressions;

type
  ThomePage = class(TForm)
    shutdown_btn: TImage;
    collapse_btn: TImage;
    logo: TImage;
    book: TLabel;
    program_tool: TLabel;
    lib: TLabel;
    cheat: TLabel;
    user_icon: TImage;
    arrow_control: TImage;
    bg_nav: TImage;
    nav_profile: TLabel;
    nav_settings: TLabel;
    nav_exit: TLabel;
    nav_hello: TLabel;
    exit_menu: TImage;
    exit_yes: TImage;
    exit_no: TImage;
    overlay: TImage;
    admin_settings: TImage;
    bg_nav_settings: TImage;
    settings_title: TLabel;
    login_settings: TLabel;
    ip_settings: TLabel;
    data_settings: TLabel;
    last_enter_settings: TLabel;
    close_settings: TImage;
    switch_user: TLabel;
    user_settings: TImage;
    shut_settings: TImage;
    setting_label1: TLabel;
    setting_label2: TLabel;
    setting_label3: TLabel;
    setting_label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure collapse_btnClick(Sender: TObject);
    procedure shutdown_btnClick(Sender: TObject);
    procedure user_iconClick(Sender: TObject);
    procedure arrow_controlClick(Sender: TObject);
    procedure nav_exitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure exit_yesClick(Sender: TObject);
    procedure exit_noClick(Sender: TObject);
    procedure nav_profileClick(Sender: TObject);
    procedure nav_settingsClick(Sender: TObject);
    procedure bookClick(Sender: TObject);
    procedure admin_settingsClick(Sender: TObject);
    procedure program_toolClick(Sender: TObject);
    procedure libClick(Sender: TObject);
    procedure cheatClick(Sender: TObject);
    procedure close_settingsClick(Sender: TObject);
    procedure switch_userClick(Sender: TObject);
    procedure shut_settingsClick(Sender: TObject);
    procedure setting_label2Click(Sender: TObject);
    procedure setting_label3Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure setting_label4Click(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }

  public
    { Public declarations }
    name:tedit;
    pass:tedit;
    repeat_pass:tedit;
    procedure nameField(Sender: TObject);
    procedure passField(Sender: TObject);
    procedure repeatPassField(Sender: TObject);
  end;

const valid = '^[\w-.]{0,24}$';

var
  homePage: ThomePage;
  arrow_active:boolean;
  StateType, clicked, clicked2:integer;
  formatName:string;
  info1, info2, info3, info4, setting_label1:TLabel;
  bg_info1, bg_info2, bg_info3, bg_info4, settings1, settings2, settings3:Timage;


implementation

{$R *.dfm}

uses database, enter, enterform, login, themes, content, admin, WinSock;

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

procedure editUserName(var login:string; count:integer);
var i:integer;
  formatLogin:string;
begin
  for i := 1 to count do formatLogin:= formatLogin + login[i];
  formatName := formatLogin;
end;

procedure AlignContent(length, point:integer);
var math:real;
begin
    math := 400+((100-length*6.4)/2);
     length := round ( math );
     if point = 1 then info1.Left := length;
     if point = 2 then info2.Left := length;
     if point = 3 then info3.Left := length;
     if point = 4 then info4.Left := length;
end;

procedure showUserNav();
begin
  if arrow_active = false then
  begin
    homePage.bg_nav.Visible := true;
    homePage.nav_profile.Visible := true;
    homePage.nav_hello.Visible := true;
    homePage.nav_settings.Visible := true;
    homePage.nav_exit.Visible := true;
    homePage.arrow_control.Picture.LoadFromFile('images/arrow-up.png');
    arrow_active := true;
  end
  else
  begin
    homePage.bg_nav.Visible := false;
    homePage.nav_hello.Visible := false;
    homePage.nav_profile.Visible := false;
    homePage.nav_settings.Visible := false;
    homePage.nav_exit.Visible := false;
    homePage.arrow_control.Picture.LoadFromFile('images/arrow-down.png');
    arrow_active := false;
  end;
end;

procedure ThomePage.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure ThomePage.exit_noClick(Sender: TObject);
begin
  book.Enabled := true;
  program_tool.Enabled := true;
  lib.Enabled := true;
  cheat.Enabled := true;
  nav_profile.Enabled := true;
  nav_settings.Enabled := true;
  nav_exit.Enabled := true;
  user_icon.Enabled := true;
  arrow_control.Enabled := true;
  //
  overlay.Width := 0;
  exit_menu.Visible := false;
  exit_yes.Visible := false;
  exit_no.Visible := false;
end;

procedure ThomePage.exit_yesClick(Sender: TObject);
begin
  homePage.close;
  firstEnterprice.Close;
end;

procedure ThomePage.admin_settingsClick(Sender: TObject);
begin
  admin_control.Show;
  admin_control.choose_type.Visible := false;
  admin_control.c_title.Visible := false;
  admin_control.c_description.Visible := false;
  admin_control.src_upload.Visible := false;
  admin_control.link.Visible := false;
  admin_control.cContent.Visible := false;
end;

procedure ThomePage.arrow_controlClick(Sender: TObject);
begin
  showUserNav;
end;

procedure ThomePage.bookClick(Sender: TObject);
begin
  StateType := 0;
  contentPage.Show;
  homePage.Close;
end;

procedure ThomePage.cheatClick(Sender: TObject);
begin
  StateType := 3;
  contentPage.Show;
  homePage.Close;
end;

procedure ThomePage.close_settingsClick(Sender: TObject);
begin
  switch_user.Visible := false;
  bg_nav_settings.Visible := false;
  settings_title.Visible := false;
  login_settings.Visible := false;
  ip_settings.Visible := false;
  close_settings.Visible := false;
  data_settings.Visible := false;
  last_enter_settings.Visible := false;
  overlay.Width := 0;

  FreeAndNil(info1);
  FreeAndNil(info2);
  FreeAndNil(info3);
  FreeAndNil(info4);

  FreeAndNil(bg_info1);
  FreeAndNil(bg_info2);
  FreeAndNil(bg_info3);
  FreeAndNil(bg_info4);
end;

procedure ThomePage.collapse_btnClick(Sender: TObject);
begin
  WindowState:= wsMinimized;
end;

procedure ThomePage.FormActivate(Sender: TObject);
begin
  clicked:=0;
  clicked2:=0;
  user_settings.Height := 184;
  admin_settings.Visible := false;

  db.QueryTheme.SQL.Text := 'SELECT u_theme FROM users WHERE u_login = ' +QuotedStr(loginForm.loginField.Text);
  db.QueryTheme.Open;

  db.QueryAdmin.SQL.Text := 'SELECT u_admin FROM users WHERE u_login = ' +QuotedStr(loginForm.loginField.Text);
  db.QueryAdmin.Open;

  if db.QueryAdmin['u_admin'] = 1 then admin_settings.Visible := true;

  formatName := loginForm.loginField.Text;
  arrow_active := true;
  showUserNav;
  overlay.Width := 0;
  exit_menu.Visible := false;
  exit_yes.Visible := false;
  exit_no.Visible := false;
  editUserName(formatName, 6);
  if length(loginForm.loginField.Text) > 6 then homePage.nav_hello.Caption := '������, '+formatName+'...'
  else homePage.nav_hello.Caption := '������, '+formatName+'!';

end;

procedure ThomePage.FormClick(Sender: TObject);
begin
  arrow_active := true;
  showUserNav;
end;

procedure ThomePage.FormCreate(Sender: TObject);
begin
  //Resets

    //Reset exit
  overlay.Width := 0;
  exit_menu.Visible := false;
  exit_yes.Visible := false;
  exit_no.Visible := false;
    //reset nav bar
  nav_hello.Visible := false;
  nav_profile.Visible := false;
  nav_settings.Visible := false;
  nav_exit.Visible := false;
  bg_nav.Visible := false;
  exit_menu.Visible := false;
  exit_yes.Visible := false;
  exit_no.Visible := false;
end;

//  <mouseLogic>

procedure ThomePage.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseMoving := true;
  mouseX := X;
  mouseY := Y;
  AlphaBlend := true;//opacity on/off
  AlphaBlendValue := 180;//opacity value
end;

procedure ThomePage.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if mouseMoving then
  begin
    left := left + (x - mouseX);
    top := top + (y - mouseY);
  end;

end;

procedure ThomePage.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseMoving := false;
  AlphaBlend := false;
end;

procedure ThomePage.FormPaint(Sender: TObject);
var bg:TBitMap;//background image to firstEnterprise form
begin
  bg:=TBitMap.Create;
  case db.QueryTheme['u_theme'] of
    0: bg.LoadFromFile('images/bg-orange.bmp');
    1: bg.LoadFromFile('images/bg-blue.bmp');
    2: bg.LoadFromFile('images/bg-green.bmp');
    3: bg.LoadFromFile('images/bg-pink.bmp');
    4: bg.LoadFromFile('images/bg-red.bmp');
  end;
  homePage.Canvas.Draw(0,0,bg); //position and picture
  bg.Free;
end;

procedure ThomePage.libClick(Sender: TObject);
begin
  StateType := 2;
  contentPage.Show;
  homePage.Close;
end;

procedure ThomePage.nav_exitClick(Sender: TObject);
begin
  showUserNav;
  book.Enabled := false;
  program_tool.Enabled := false;
  lib.Enabled := false;
  cheat.Enabled := false;
  nav_profile.Enabled := false;
  nav_settings.Enabled := false;
  nav_exit.Enabled := false;
  user_icon.Enabled := false;
  arrow_control.Enabled := false;
  //
  exit_menu.BringToFront;
  exit_yes.BringToFront;
  exit_no.BringToFront;
  overlay.Width := 800;
  exit_menu.Visible := true;
  exit_yes.Visible := true;
  exit_no.Visible := true;
end;

procedure ThomePage.nav_profileClick(Sender: TObject);
var
keyLogin,keyLastEnter, keyIP, keyDataReg:integer;
dataReg, lastEnter:string;
begin
  db.QueryAuth.sql.Text := 'SELECT u_dataReg, u_lastEnter FROM users WHERE u_login = '+QuotedStr(loginForm.loginField.Text);
  db.QueryAuth.Open;

  dataReg := db.QueryAuth['u_dataReg'];
  lastEnter := db.QueryAuth['u_lastEnter'];

  overlay.Width := 800;
  admin_settings.SendToBack;

  showUserNav;

  bg_nav_settings.Visible := true;
  settings_title.Visible := true;
  login_settings.Visible := true;
  ip_settings.Visible := true;

  close_settings.Visible := true;
  close_settings.BringToFront;
  close_settings.Left := 490;
  close_settings.Top := 80;

  data_settings.Visible := true;
  last_enter_settings.Visible := true;

  switch_user.Left := 333;
  switch_user.Visible := true;

  bg_nav_settings.Left := 285;
  bg_nav_settings.Top := 65;

  settings_title.Left := 355;
  settings_title.Top := 85;

  login_settings.Left := 300;
  login_settings.Top := 135;

  ip_settings.Left := 300;
  ip_settings.Top := 165;

  data_settings.Left := 300;
  data_settings.Top := 195;
  data_settings.Caption := '����'+chr(13)+'�����������:';

  last_enter_settings.Left := 300;
  last_enter_settings.Top := 250;
  last_enter_settings.Caption := '���������'+chr(13)+'����:';

  keyLogin := length(loginForm.loginField.Text);
  keyIP := length(GetLocalIP);
  keyDataReg := length(dataReg);
  keyLastEnter := length(lastEnter);


  // show info

  //bg
  // bg - 1 Login
  bg_info1 := TImage.Create(nil);
  InsertControl(bg_info1);
  bg_info1.Picture.LoadFromFile('images/setting-field.png');
  bg_info1.Width := 100;
  bg_info1.Height := 19;
  bg_info1.Left := 400;
  bg_info1.Top := 132;

   // bg - 2 IP
  bg_info2 := TImage.Create(nil);
  InsertControl(bg_info2);
  bg_info2.Picture.LoadFromFile('images/setting-field.png');
  bg_info2.Width := 100;
  bg_info2.Height := 19;
  bg_info2.Left := 400;
  bg_info2.Top := 165;

   // bg - 3 Data registration
  bg_info3 := TImage.Create(nil);
  InsertControl(bg_info3);
  bg_info3.Picture.LoadFromFile('images/setting-field.png');
  bg_info3.Width := 100;
  bg_info3.Height := 19;
  bg_info3.Left := 400;
  bg_info3.Top := 202;

   // bg - 4 Last enter
  bg_info4 := TImage.Create(nil);
  InsertControl(bg_info4);
  bg_info4.Picture.LoadFromFile('images/setting-field.png');
  bg_info4.Width := 100;
  bg_info4.Height := 19;
  bg_info4.Left := 400;
  bg_info4.Top := 255;


  //info
  // info - 1
  info1 := TLabel.Create(nil);
  InsertControl(info1);
  info1.Top := 133;
  info1.Font.Size := 10;
  info1.font.color := clWhite;

  AlignContent(keyLogin, 1);
  editUserName(formatName, 12);
  if length(formatName) > 12 then info1.Caption := formatName+'...';
  info1.Caption := formatName;

  // info - 2
  info2 := TLabel.Create(nil);
  InsertControl(info2);
  info2.Top := 167;
  info2.Font.Size := 10;
  info2.font.color := clWhite;

  AlignContent(keyIP, 2);
  info2.Caption := GetLocalIP;

  // info - 3
  info3 := TLabel.Create(nil);
  InsertControl(info3);
  info3.Top := 204;
  info3.Font.Size := 10;
  info3.font.color := clWhite;

  AlignContent(keyDataReg, 3);
  info3.Caption := dataReg;

  // info - 4
  info4 := TLabel.Create(nil);
  InsertControl(info4);
  info4.Top := 257;;
  info4.Font.Size := 10;
  info4.font.color := clWhite;

  AlignContent(keyLastEnter, 4);
  info4.Caption := lastEnter;

end;

procedure ThomePage.nav_settingsClick(Sender: TObject);
begin
  showUserNav;

  admin_settings.SendToBack;

  overlay.Width := 800;

  user_settings.Visible := true;
  shut_settings.Visible := true;
  setting_label1.Visible := true;
  setting_label2.Visible := true;
  setting_label3.Visible := true;
  setting_label4.Visible := true;

  setting_label1.BringToFront;
  setting_label2.BringToFront;
  setting_label3.BringToFront;
  setting_label4.BringToFront;

  user_settings.Left := 285;
  user_settings.Top := 135;

  shut_settings.top := 160 - 16;
  shut_settings.Left := 493;

  settings1 := TImage.Create(nil);
  settings2 := TImage.Create(nil);
  settings3 := TImage.Create(nil);

  InsertControl(settings1);
  InsertControl(settings2);
  InsertControl(settings3);

  settings1.Picture.LoadFromFile('images/settings.png');
  settings2.Picture.LoadFromFile('images/settings.png');
  settings3.Picture.LoadFromFile('images/settings.png');

  settings1.Left := 300;
  settings1.Top := 200;
  settings1.Width := 199;
  settings1.Height := 21;

  settings2.Left := 300;
  settings2.Top := 237;
  settings2.Width := 199;
  settings2.Height := 21;

  settings3.Left := 300;
  settings3.Top := 275;
  settings3.Width := 199;
  settings3.Height := 21;

  setting_label1.Caption := '���������';
  setting_label1.Left := 367;
  setting_label1.Top := 160;
  setting_label1.Font.Color := clWindowFrame;
  setting_label1.Font.Name := 'Century Gothic';
  setting_label1.Font.Size := 10;

  setting_label2.Caption := '������� ����';
  setting_label2.Left := 360;
  setting_label2.Font.Color := clWhite;
  setting_label2.Font.Name := 'Century Gothic';
  setting_label2.Top := 204;
  setting_label2.Cursor := crHandPoint;
  setting_label2.BringToFront;
  setting_label2.BringToFront;

  setting_label3.Caption := '������� �����';
  setting_label3.Left := 358;
  setting_label3.Font.Color := clWhite;
  setting_label3.Font.Name := 'Century Gothic';
  setting_label3.Top := 241;
  setting_label3.Cursor := crHandPoint;
  setting_label3.BringToFront;

  setting_label4.Caption := '������� ������';
  setting_label4.Left := 353;
  setting_label4.Font.Color := clWhite;
  setting_label4.Font.Name := 'Century Gothic';
  setting_label4.Top := 279;
  setting_label4.Cursor := crHandPoint;
  setting_label4.BringToFront;
end;

procedure ThomePage.program_toolClick(Sender: TObject);
begin
  StateType := 1;
  contentPage.Show;
  homePage.Close;
end;

procedure ThomePage.shutdown_btnClick(Sender: TObject);
begin
  homePage.Close;
  firstEnterprice.Close;
end;

procedure ThomePage.shut_settingsClick(Sender: TObject);
begin
  overlay.Width := 0;

  user_settings.Visible := false;
  shut_settings.Visible := false;

  setting_label1.Visible := false;
  setting_label2.Visible := false;
  setting_label3.Visible := false;
  setting_label4.Visible := false;

  FreeAndNil(settings1);
  FreeAndNil(settings2);
  FreeAndNil(settings3);
  FreeAndNil(name);
  FreeAndNil(pass); FreeAndNil(repeat_pass);
end;

procedure ThomePage.switch_userClick(Sender: TObject);
begin
  bg_nav_settings.Visible := false;
  settings_title.Visible := false;
  login_settings.Visible := false;
  ip_settings.Visible := false;
  close_settings.Visible := false;
  data_settings.Visible := false;
  last_enter_settings.Visible := false;
  switch_user.Visible := false;
  overlay.Width := 0;

  FreeAndNil(info1);
  FreeAndNil(info2);
  FreeAndNil(info3);
  FreeAndNil(info4);

  FreeAndNil(bg_info1);
  FreeAndNil(bg_info2);
  FreeAndNil(bg_info3);
  FreeAndNil(bg_info4);

  showLogin.Show;
  showLogin.Enabled := true;
  homePage.Close;

end;

procedure ThomePage.setting_label2Click(Sender: TObject);
begin
  homePage.shut_settingsClick(self);
  Theme.Show;
  homePage.Close;
end;

procedure ThomePage.setting_label3Click(Sender: TObject);
begin
  clicked := clicked + 1;
  if clicked = 1 then
  begin
    name := TEdit.Create(nil);
    name.Text := '������� ����� �����';
    InsertControl(name);
    name.Width := 199;
    name.Height := 21;
    name.Left := settings3.left;
    name.Top := settings3.top - 8;
    name.Font.Color := clWindowFrame;
    name.OnClick := nameField;

    setting_label4.Top := setting_label4.top + 20;
    settings3.Top := settings3.top + 20;
    setting_label3.Caption := '�������';
    setting_label3.Left := 376;
  end;

  if (clicked = 2) and (AnsiCompareText(name.Text, '������� ����� �����') = 0) then
  begin
    setting_label4.Top := setting_label4.top - 20;
    settings3.Top := settings3.top - 20;
    setting_label3.Caption := '������� �����';
    setting_label3.Left := 358;
    FreeAndNil(name);
    clicked := 0;
  end;

  if clicked > 1 then
  begin
    if (length(name.text) < 3) and (length(name.text) > 24) then
    begin
      showmessage('���������� �������� �� ������ ���� ����� 24-� �������� � �� ����� 4-�');
      name.Text := '������� ����� �����';
      exit;
    end;
    if TRegEx.IsMatch(name.Text, valid) then
    begin
      db.QueryAuth.SQL.Text := 'SELECT * FROM users WHERE u_login =' +QuotedStr(name.Text);
      db.QueryAuth.Open;
      if db.QueryAuth.IsEmpty = true then
      begin
        if AnsiCompareStr(loginForm.loginField.text, name.Text) = 0 then begin showmessage('����� �� ����� ���������'); name.Text := '������� ����� �����'; end;
        db.QueryAuth.SQL.Clear;
        db.QueryAuth.SQL.Add('UPDATE users SET u_login = '+QuotedStr(name.Text)+' WHERE u_login = '+QuotedStr(loginForm.loginField.Text));
        db.QueryAuth.Execute;
        loginForm.loginField.Text := name.Text;
        homePage.shut_settingsClick(self);
        homePage.FormActivate(self);
        showmessage('����� ������� �������!');
        clicked := 0;
      end
      else begin showmessage('����� ������������ ��� ����������'); name.Text := '������� ����� �����'; end;
    end
    else begin showmessage('����� ������� �������� ������ �� ��������� ��������'); name.Text := '������� ����� �����'; end;
    clicked := 1;
  end;
end;

procedure ThomePage.setting_label4Click(Sender: TObject);
begin
  clicked2 := clicked2 + 1;
  if clicked2 = 1 then
  begin
    pass := TEdit.Create(nil);
    pass.Text := '������� ������� ������';
    InsertControl(pass);
    pass.Width := 199;
    pass.Height := 21;
    pass.Left := settings3.left;
    pass.Top := settings3.top + 5 + 21;
    pass.Font.Color := clWindowFrame;
    pass.OnClick := passField;

    repeat_pass := TEdit.Create(nil);
    repeat_pass.Text := '������� ����� ������';
    InsertControl(repeat_pass);
    repeat_pass.Width := 199;
    repeat_pass.Height := 21;
    repeat_pass.Left := settings3.left;
    repeat_pass.Top := settings3.top + 42 + 10;
    repeat_pass.Font.Color := clWindowFrame;
    repeat_pass.OnClick := repeatPassField;

    setting_label4.Caption := '�������';
    setting_label4.Left := 376;
    user_settings.height := 240;
  end;

  if (clicked2 = 2) and (AnsiCompareText(pass.Text, '������� ������� ������') = 0) and  (AnsiCompareText(repeat_pass.Text, '������� ����� ������') = 0) then
  begin
    setting_label4.Caption := '������� ������';
    setting_label4.Left := 353;
    FreeAndNil(pass);  FreeAndNil(repeat_pass);
    user_settings.Height := 184;
    clicked2 := 0;
  end;

  if clicked2 > 1 then
  begin
    if (length(pass.text) < 3) and (length(pass.text) > 24) and (length(repeat_pass.text) < 3) and (length(repeat_pass.text) > 24) then
    begin
      showmessage('���������� �������� �� ������ ���� ����� 24-� �������� � �� ����� 4-�');
      pass.PasswordChar := #0; repeat_pass.PasswordChar := #0;
      pass.Text := '������� ������� ������';  repeat_pass.Text := '������� ����� ������';
      exit;
    end;
    if TRegEx.IsMatch(repeat_pass.Text, valid) then
    begin
      db.QueryAuth.SQL.Text := 'SELECT u_pass FROM users WHERE u_login =' +QuotedStr(loginForm.loginField.Text);
      db.QueryAuth.Open;
//      if db.QueryAuth.IsEmpty = true then
      if AnsiCompareStr(db.QueryAuth['u_pass'], pass.Text) = 0 then
      begin
        if AnsiCompareStr(repeat_pass.text, pass.Text) = 0 then begin showmessage('������ �� ����� ���������'); pass.PasswordChar := #0; repeat_pass.PasswordChar := #0; pass.Text := '������� ������� ������';  repeat_pass.Text := '������� ����� ������'; end
        else
        begin
          db.QueryAuth.SQL.Clear;
          db.QueryAuth.SQL.Add('UPDATE users SET u_pass = '+QuotedStr(repeat_pass.Text)+' WHERE u_login = '+QuotedStr(loginForm.loginField.Text));
          db.QueryAuth.Execute;
          loginForm.passwordField.Text := repeat_pass.Text;
          homePage.shut_settingsClick(self);
          homePage.FormActivate(self);
          showmessage('������ ������� �������!');
          clicked2 := 0;
        end;
      end
      else begin showmessage('������ ������ ������ �������'); pass.PasswordChar := #0; repeat_pass.PasswordChar := #0; pass.Text := '������� ������� ������ ';  repeat_pass.Text := '������� ����� ������';  end;
    end
    else begin showmessage('������ ������� �������� ������ �� ��������� ��������'); pass.PasswordChar := #0; repeat_pass.PasswordChar := #0; pass.Text := '������� ������� ������';  repeat_pass.Text := '������� ����� ������'; end;
    clicked2 := 1;
  end;
end;

procedure ThomePage.nameField(Sender: TObject);
begin
  if not AnsiCompareText(name.Text, '������� ����� �����') = 0 then name.Text := name.Text
  else name.Text := '';
end;

procedure ThomePage.passField(Sender: TObject);
begin
  if not AnsiCompareText(pass.Text, '������� ����� �����') = 0 then pass.Text := pass.Text
  else begin pass.PasswordChar := #42; pass.Text := '' end;
end;

procedure ThomePage.repeatPassField(Sender: TObject);
begin
  if not AnsiCompareText(repeat_pass.Text, '������� ����� �����') = 0 then repeat_pass.Text := repeat_pass.Text
  else begin repeat_pass.PasswordChar := #42; repeat_pass.Text := ''; end;
end;

procedure ThomePage.user_iconClick(Sender: TObject);
begin
  showUserNav;
end;

//  </mouseLogic>

end.
