program Proglib;

uses
  Vcl.Forms,
  enter in 'enter.pas' {firstEnterprice},
  login in 'login.pas' {showLogin},
  themes in 'themes.pas' {theme},
  main in 'main.pas' {homePage},
  enterform in 'enterform.pas' {Form1},
  database in 'database.pas' {db},
  content in 'content.pas' {contentPage},
  admin in 'admin.pas' {admin_control};

{$R *.res}

 procedure SetAsMainForm(aForm:TForm);
 var
   P:Pointer;
 begin
   P := @Application.Mainform;
   Pointer(P^) := aForm;
 end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfirstEnterprice, firstEnterprice);
  Application.CreateForm(ThomePage, homePage);
  Application.CreateForm(TshowLogin, showLogin);
  Application.CreateForm(Ttheme, theme);
  Application.CreateForm(TloginForm, loginForm);
  Application.CreateForm(Tdb, db);
  Application.CreateForm(TcontentPage, contentPage);
  Application.CreateForm(Tadmin_control, admin_control);
  Application.Run;

end.
