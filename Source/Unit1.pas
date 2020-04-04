unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Registry, Data.DB, MemDS, DBAccess, MyAccess;

type
  TfirstEnterprice = class(TForm)
    shutdown_btn: TImage;
    collapse_btn: TImage;
    nextStep_btn: TImage;
    educateMouse: TImage;
    text_space: TLabel;
    MyConnection1: TMyConnection;
    MyQuery1: TMyQuery;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
    procedure shutdown_btnClick(Sender: TObject);
    procedure collapse_btnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure nextStep_btnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  firstEnterprice: TfirstEnterprice;
  //mouseMoving
  mouseMoving:boolean;
  mouseX, mouseY:integer;
  //buttons
  next_btn:TPngImage;
  //Registry
  reg:TRegistry;
implementation

{$R *.dfm}

uses Unit2;



// <main>

procedure TfirstEnterprice.FormActivate(Sender: TObject);
begin
      {Connecting to datebase..}
  MyConnection1.Server:= 'localhost';
  MyConnection1.Database := 'proglib';
  MyConnection1.Username := 'root';
  MyConnection1.Connect;
  if MyConnection1.Connected = false then begin
    nextStep_btn.Enabled := false;
    nextStep_btn.Picture.LoadFromFile('images/next-btn_disable.png');
  end;
      {Register cheeeck}
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    if(KeyExists('Software\Proglib')) then
    begin
      showLogin.Show;
    end;
  end;
end;

procedure TfirstEnterprice.FormCreate(Sender: TObject);
begin
  //-------------------
  mouseMoving := false;//Moving 'firstEnterprice' TForm
  //-------------------
  text_space.Caption := '�����: ������� ���'+chr(13)+'����� ���������� ���� ���������'; //Content
  //-------------------
end;

    {TForm background}
procedure TfirstEnterprice.FormPaint(Sender: TObject);
var bg:TBitMap;//background image to firstEnterprise form
begin
  bg:=TBitMap.Create;
  bg.LoadFromFile('images/background-dark.bmp'); //src
  firstEnterprice.Canvas.Draw(0,0,bg); //position and picture
  bg.Free;
end;

//  </main>



//  <mouseLogic>

    {mouse down}
procedure TfirstEnterprice.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseMoving:=true;
  mouseX:=X;
  mouseY:=Y;
  AlphaBlend:=true;//opacity on/off
  AlphaBlendValue:=180;//opacity value
end;
    {mouse moving}
procedure TfirstEnterprice.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if mouseMoving then
  begin
    left:=left+(x-mouseX);
    top:=top+(y-mouseY);
  end;
end;
    {mouse up}
procedure TfirstEnterprice.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseMoving:=false;
  AlphaBlend:=false;
end;

//  </mouseLogic>



//  <clickLogic>

procedure TfirstEnterprice.shutdown_btnClick(Sender: TObject);
begin
  firstEnterprice.Close;
end;

procedure TfirstEnterprice.collapse_btnClick(Sender: TObject);
begin
  WindowState:= wsMinimized;
end;

procedure TfirstEnterprice.nextStep_btnClick(Sender: TObject);
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    if (not KeyExists('Software\Proglib')) then begin
      OpenKey('Software\Proglib', True);
      WriteString('educate','true');
      CloseKey;
    end
    else
    begin
      firstEnterprice.Hide;
      showLogin.Show;
    end;
  end;
end;

//  </clickLogic>

end.
