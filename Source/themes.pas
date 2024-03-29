unit themes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, FireDAC.Stan.Param, Data.DB,
  Vcl.StdCtrls;

type
  Ttheme = class(TForm)
    overlay: TImage;
    overlay_text: TLabel;
    okey_btn: TImage;
    arrow_left: TImage;
    arrow_right: TImage;
    choose_btn: TImage;
    close_btn: TImage;
    procedure FormPaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure okey_btnClick(Sender: TObject);
    procedure arrow_rightClick(Sender: TObject);
    procedure close_btnClick(Sender: TObject);
    procedure choose_btnClick(Sender: TObject);
    procedure arrow_leftClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  theme: Ttheme;
  //mouseMoving
  mouseMoving:boolean;
  mouseX, mouseY:integer;
  //theme
  theme_style:integer;

implementation

{$R *.dfm}

uses enterform, enter, login, main, database;

procedure Ttheme.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

    {TForm background}
procedure Ttheme.FormPaint(Sender: TObject);
var bg:TBitMap;//background image to firstEnterprise form
begin
  bg:=TBitMap.Create;
  case theme_style of
    0: bg.LoadFromFile('images/choose-orange.bmp');
    1: bg.LoadFromFile('images/choose-blue.bmp');
    2: bg.LoadFromFile('images/choose-green.bmp');
    3: bg.LoadFromFile('images/choose-pink.bmp');
    4: bg.LoadFromFile('images/choose-red.bmp');
  end;
  theme.Canvas.Draw(0,0,bg); //position and picture
  bg.Free;
end;

procedure Ttheme.okey_btnClick(Sender: TObject);
begin
  overlay.Width := 0;
  overlay_text.Visible := false;
  okey_btn.Visible := false;
  choose_btn.Visible := true;
  close_btn.Visible := true;
  arrow_left.Enabled := true;
  arrow_right.Enabled := true;

end;

procedure Ttheme.arrow_leftClick(Sender: TObject);
begin
  if theme_style = 0 then theme_style := 5;
  if theme_style <= 5 then theme_style := theme_style - 1;
  theme.FormPaint(self);
  arrow_right.BringToFront;
  arrow_left.BringToFront;
  close_btn.BringToFront;
  choose_btn.BringToFront;
end;

procedure Ttheme.arrow_rightClick(Sender: TObject);
begin
  theme_style := theme_style + 1;
  if theme_style > 4 then theme_style := 0;
  theme.FormPaint(self);
  arrow_right.BringToFront;
  arrow_left.BringToFront;
  close_btn.BringToFront;
  choose_btn.BringToFront;
end;

procedure Ttheme.choose_btnClick(Sender: TObject);
begin
  db.QueryTheme.SQL.Clear;
  db.QueryTheme.SQL.Add('UPDATE users SET u_theme = :u_theme WHERE u_login = :u_login');
  db.QueryTheme.ParamByName('u_theme').AsInteger := theme_style;
  db.QueryTheme.ParamByName('u_login').AsString := loginForm.loginField.Text;
  db.QueryTheme.Execute;
  homePage.show;
  showLogin.Close;
  firstEnterprice.Hide;
  theme.close;
end;

procedure Ttheme.close_btnClick(Sender: TObject);
begin
  firstEnterprice.hide;
  firstEnterprice.Close;
end;

procedure Ttheme.FormActivate(Sender: TObject);
begin
  arrow_left.Enabled := false;
  arrow_right.Enabled := false;
  close_btn.Visible := false;
  choose_btn.Visible := false;
  okey_btn.Visible := true;
  overlay_text.Visible := true;
  // theme_style = 0 - dark theme, theme_style = 1 - light theme, 2 - green theme, 3 - pink theme, 4 - red theme
  theme_style := 0;
  overlay.Width := 800;
  overlay_text.Caption := '�������� ���� �� �������'+chr(13)+'� ������� ���������';
end;

end.
