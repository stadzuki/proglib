unit content;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TcontentPage = class(TForm)
    shutdown_btn: TImage;
    collapse_btn: TImage;
    arrow_btn: TImage;
    contentScroll: TImage;
    procedure FormPaint(Sender: TObject);
    procedure collapse_btnClick(Sender: TObject);
    procedure shutdown_btnClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure arrow_btnClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  private
    { Private declarations }
  public
    { Public declarations }
    pGoBack:TImage;
    pItem:TImage;
    pDownload:TImage;
    pRating:TLabel;
    pRatingImg:TImage;
    pRate: array of TImage;
    pTitle:TLabel;
    pSub:TLabel;
    pDescription:TLabel;
    pContent:TImage;
    pUserIcon:TImage;
    pUserName:TLabel;
    pUserComment:TLabel;
    pAddComment:TMemo;


    bgImg: array of TImage;
    bgContent: array of TImage;
    titleContent: array of TLabel;
    subContent: array of TLabel;
    descriptionContent: array of TLabel;
    procedure bgImgClick(Sender: TObject);
    procedure titleContentClick(Sender: TObject);
    procedure subContentClick(Sender: TObject);
    procedure descriptionContentClick(Sender: TObject);
    procedure bgContentClick(Sender: TObject);
    procedure pRateHover(Sender: TObject);
    procedure pRateLeave(Sender: TObject);
    procedure pRateClick(Sender: TObject);

    procedure LoadPage(var id:integer);
    procedure LoadRate();
  end;

var
  contentPage: TcontentPage;
  QueryType, link, QueryTypeBook:string;
  RateCount:real;
  scrollResult, scroll_pos, query_count, posRate, query_id, PageID, heightResult, book_top, bg_top, title_top, typeBook, sub_top, desc_top:integer;
  isPage, isRate:boolean;

implementation

{$R *.dfm}

uses main, database, enter, enterform, login, themes;

procedure getContentHeight(var count:integer);
var cHeight, i:integer;
begin
  cHeight := 465;
  if count > 3 then
    for i := 4 to count do
    begin
      cHeight := cHeight + 165;
      heightResult := cHeight;
    end
  else heightResult := 465;
end;

procedure TcontentPage.CreateParams(var Params: TCreateParams) ;
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure TcontentPage.arrow_btnClick(Sender: TObject);
var i : integer;
begin
  for i := 1 to db.QueryContent.RecordCount do
  begin
    FreeAndNil(bgContent[i]);
    FreeAndNil(bgImg[i]);
    FreeAndNil(titleContent[i]);
    FreeAndNil(subContent[i]);
    FreeAndNil(descriptionContent[i]);
  end;


  homePage.Show;
  contentPage.close;
end;

procedure TcontentPage.collapse_btnClick(Sender: TObject);
begin
  WindowState:= wsMinimized;
end;

procedure TcontentPage.FormActivate(Sender: TObject);
var i, refreshText, titleLength: integer;
begin
  isPage := false;
  isRate := false;
  scrollResult := 465;
  bg_top := 30;
  book_top := 40;
  title_top := 40;
  sub_top := 43;
  desc_top := 65;
  posRate := 50;

  db.QueryContent.SQL.Text := 'SELECT * FROM content WHERE c_type = '+QuotedStr(inttostr(StateType));
  db.QueryContent.Open;
  if db.QueryContent.IsEmpty = false then
  begin
      //�������� ��������
      SetLength(bgContent, db.QueryContent.RecordCount + 1);
      SetLength(bgImg, db.QueryContent.RecordCount + 1);
      SetLength(titleContent, db.QueryContent.RecordCount + 1);
      SetLength(subContent, db.QueryContent.RecordCount + 1);
      SetLength(descriptionContent, db.QueryContent.RecordCount + 1);
      for i := 1 to db.QueryContent.RecordCount do
      begin

          //�������� ������� ����
        bgContent[i]:=TImage.Create(nil);
        InsertControl(bgContent[i]);
        bgContent[i].Height := 135;
        bgContent[i].Width := 635;
        bgContent[i].Left := 107;
        bgContent[i].Top := bg_top;
        bg_top := bg_top + 165;
        bgContent[i].Cursor := crHandPoint;
        bgContent[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        bgContent[i].OnClick := bgContentClick;
        bgContent[i].Picture.LoadFromFile('images/element.png');

          //�������� ��������
        query_id := db.QueryContent['id'];
        bgImg[i]:=TImage.Create(nil);
        InsertControl(bgImg[i]);
        bgImg[i].Height := 109;
        bgImg[i].Width := 85;
        bgImg[i].Left := 120;
        bgImg[i].Top := book_top;
        book_top := book_top + 165;
        bgImg[i].Cursor := crHandPoint;
        bgImg[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        bgImg[i].OnClick := bgImgClick;

        db.QueryLoadContent.SQL.Text := 'SELECT * FROM content WHERE id = ' + QuotedStr(inttostr(query_id));
        db.QueryLoadContent.Open;
        link:=db.QueryLoadContent['c_src'];
        bgImg[i].Picture.LoadFromFile(link);

          //�������� ���������
        titleContent[i]:=TLabel.Create(nil);
        InsertControl(titleContent[i]);
        titleContent[i].Left := 220;
        titleContent[i].Top := title_top;
        title_top := title_top + 165;
        titleContent[i].Font.Color := clWindowFrame;
        titleContent[i].Font.Name := 'Century Gothic';
        titleContent[i].Font.Size := 12;
        titleContent[i].Font.Style := [fsBold];
        titleContent[i].Cursor := crHandPoint;
        titleContent[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        titleContent[i].OnClick := titleContentClick;

        titleContent[i].Caption := db.QueryLoadContent['c_title']+', ';

          //�������� ������������
        titleLength := titleContent[i].Width;
        subContent[i]:=TLabel.Create(nil);
        InsertControl(subContent[i]);
        subContent[i].Left := 222 + titleLength;
        subContent[i].Top := sub_top;
        sub_top := sub_top + 165;
        subContent[i].Font.Color := clWindowFrame;
        subContent[i].Font.Name := 'Century Gothic';
        subContent[i].Font.Size := 10;
        subContent[i].Cursor := crHandPoint;
        subContent[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        subContent[i].OnClick := subContentClick;

        typeBook := db.QueryLoadContent['c_typeBook'];
        case typeBook of
         0: QueryTypeBook := '�����';
         1: QueryTypeBook := '����������';
         2: QueryTypeBook := '������������';
        end;

        subContent[i].Caption := QueryTypeBook+', �����: ' +db.QueryLoadContent['c_athor'];

          //�������� ��������
        descriptionContent[i]:=TLabel.Create(nil);
        InsertControl(descriptionContent[i]);
        descriptionContent[i].Left := 220;
        descriptionContent[i].Top := desc_top;
        desc_top := desc_top + 165;
        descriptionContent[i].Font.Color := clWindowFrame;
        descriptionContent[i].Font.Name := 'Century Gothic';
        descriptionContent[i].Font.Size := 8;
        descriptionContent[i].Width := 515;
        descriptionContent[i].Height := 85;
        descriptionContent[i].AutoSize := false;
        descriptionContent[i].WordWrap := true;
        descriptionContent[i].Cursor := crHandPoint;
        descriptionContent[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        descriptionContent[i].OnClick := descriptionContentClick;

        descriptionContent[i].Caption := db.QueryLoadContent['c_description'];

        bgContent[i].Picture.LoadFromFile('images/bg_element.png'); { ���� ����������� ���������� � ����� ����� ��� ���� �����
        ��� ���� �����-������ ������� ���� �������� � �� ��� � �������� }

        db.QueryContent.next;
      end;

        //�������� �������
      query_count:=db.QueryContent.RecordCount;
      getContentHeight(query_count);
      if query_count > 3 then
      begin
        contentScroll.Visible := true;
        for i := 4 to query_count do
        begin
          if contentScroll.Height <= 20 then break;
          contentScroll.Height := contentScroll.Height - 97;
        end;
      end;
  end;

end;

procedure TcontentPage.LoadRate();
var i, UserID:integer;
begin
  UserID := db.QueryContent['id'];
  db.QueryPage.SQL.Text := 'SELECT * FROM rating WHERE id_page = '+QuotedStr(inttostr(PageID))+' AND id_user = ' +QuotedStr(inttostr(UserID));
  db.QueryPage.Open;
  if db.QueryPage.IsEmpty = false then
  begin
    isRate := true;

  end;


end;

procedure TcontentPage.LoadPage(var id:integer);
var i:integer;
begin
  PageID := id;
  arrow_btn.Visible := false;
  shutdown_btn.BringToFront;
  collapse_btn.BringToFront;

  for i := 1 to db.QueryContent.RecordCount do
  begin
    FreeAndNil(bgContent[i]);
    FreeAndNil(bgImg[i]);
    FreeAndNil(titleContent[i]);
    FreeAndNil(subContent[i]);
    FreeAndNil(descriptionContent[i]);
  end;

  isPage := true;
  contentPage.FormPaint(self);

  LoadRate();

  db.QueryPage.SQL.Text := 'SELECT * FROM content WHERE id = '+QuotedStr(inttostr(id));
  db.QueryPage.Open;

  typeBook := db.QueryLoadContent['c_typeBook'];
    case typeBook of
     0: QueryTypeBook := '�����';
     1: QueryTypeBook := '����������';
     2: QueryTypeBook := '������������';
    end;

  pGoBack := TImage.Create(nil);
  InsertControl(pGoBack);
  pGoBack.Width := 31;
  pGoBack.Height := 9;
  pGoBack.Left := 50;
  pGoBack.Top := 20;
  pGoBack.Picture.LoadFromFile('images/arrow.png');
  pGoBack.Cursor := crHandPoint;

  pItem := TImage.Create(nil);
  InsertControl(pItem);
  pItem.Width := 125;
  pItem.Height := 160;
  pItem.Stretch := true;
  pItem.Left := 50;
  pItem.Top := 50;
  pItem.Picture.LoadFromFile(db.QueryPage['c_src']);

  pDownload := TImage.Create(nil);
  InsertControl(pDownload);
  pDownload.Width := 70;
  pDownload.Height := 21;
  pDownload.Top := 230;
  pDownload.Left := 50;
  pDownload.Picture.LoadFromFile('images/download.png');

  pRatingImg := TImage.Create(nil);
  InsertControl(pRatingImg);
  pRatingImg.Width := 12;
  pRatingImg.Height := 12;
  pRatingImg.Left := 133;
  pRatingImg.Top := 235;
  pRatingImg.Picture.LoadFromFile('images/star.png');

  pRating := TLabel.Create(nil);
  InsertControl(pRating);
  pRating.Left := 150;
  pRating.Top := 228;
  pRating.Caption := '0.0';
  pRating.Font.Color := RGB(255, 193, 7);
  pRating.Font.Size := 14;

  setLength(pRate, 6);
  for i := 1 to 5 do
  begin
    pRate[i] := TImage.Create(nil);
    InsertControl(pRate[i]);
    pRate[i].Left := posRate;
    posRate := posRate + 26;
    pRate[i].Top := 260;
    pRate[i].Width := 22;
    pRate[i].Height := 21;
    pRate[i].Picture.LoadFromFile('images/star-none.png');
    pRate[i].Tag := i;
    pRate[i].OnClick := pRateClick;
    pRate[i].OnMouseEnter := pRateHover;
    pRate[i].OnMouseLeave := pRateLeave;
  end;

  pTitle := TLabel.Create(nil);
  InsertControl(pTitle);
  pTitle.Width := 515;
  pTitle.Height := 35;
  pTitle.Left := 230;
  pTitle.Top := 50;
  pTitle.Font.Color := clWindowFrame;
  pTitle.Font.Name := 'Century Gothic';
  pTitle.Font.Size := 12;
  pTitle.Font.Style := [fsBold];
  pTitle.Caption := db.QueryPage['c_title']+', ';

  pSub := TLabel.Create(nil);
  InsertControl(pSub);
  pSub.Left := 230 + pTitle.Width;
  pSub.Top := 53;
  pSub.Font.Color := clWindowFrame;
  pSub.Font.Name := 'Century Gothic';
  pSub.Font.Size := 10;
  pSub.Caption := QueryTypeBook + ', �����: '+ db.QueryPage['c_athor'];

  pDescription:=TLabel.Create(nil);
  InsertControl(pDescription);
  pDescription.Left := 230;
  pDescription.Top := 105;
  pDescription.Font.Color := clWindowFrame;
  pDescription.Font.Size := 14;
  pDescription.Width := 515;
  pDescription.Height := 175;
  pDescription.AutoSize := false;
  pDescription.WordWrap := true;
  pDescription.Caption := db.QueryPage['c_description'];

end;

procedure TcontentPage.pRateClick(Sender: TObject);
var
  getID:TImage absolute Sender;
  id, i, userId, pageId: integer;
begin
  if isRate = false then
  begin
    id := getID.Tag;
    case id of
    1: RateCount := 0.2;
    2: RateCount := 0.4;
    3: RateCount := 0.6;
    4: RateCount := 0.8;
    5: RateCount := 1.0;
    end;
    db.QueryPageInfo.SQL.Text := 'SELECT * FROM users WHERE u_login ='+QuotedStr(loginForm.loginField.Text);
    db.QueryPageInfo.Open;
    userId := db.QueryPageInfo['id'];
    pageId := db.QueryContent['id'];
    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('INSERT INTO rating (rateCount, id_user, id_page) VALUES ( '+QuotedStr(FloatToStr(RateCount))+', '+QuotedStr(intToStr(userId))+', '+QuotedStr(intToStr(pageId))+');');
    db.QueryPage.Execute;
    loadRate();
  end;
end;

procedure TcontentPage.pRateLeave(Sender: TObject);
var
  getID:TImage absolute Sender;
  id, i: integer;
begin
  if isRate = false then
  begin
    id := getID.Tag;
    for i := 1 to id do pRate[i].Picture.LoadFromFile('images/star-none.png');
  end;
end;

procedure TcontentPage.pRateHover(Sender: TObject);
var
  getID:TImage absolute Sender;
  id, i: integer;
begin
  if isRate = false then
  begin
    id := getID.Tag;
    for i := 1 to id do pRate[i].Picture.LoadFromFile('images/star-fill.png');
  end;
end;

procedure TcontentPage.bgContentClick(Sender: TObject);
var
  getID:TImage absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.bgImgClick(Sender: TObject);
var
  getID:TImage absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.titleContentClick(Sender: TObject);
var
  getID:TLabel absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.subContentClick(Sender: TObject);
var
  getID:TLabel absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.descriptionContentClick(Sender: TObject);
var
  getID:TLabel absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.FormPaint(Sender: TObject);
var bg:TBitMap;//background image to firstEnterprise form
begin
  bg:=TBitMap.Create;
  if isPage = true then
  begin
    bg.LoadFromFile('images/bg-page.bmp');
  end
  else bg.LoadFromFile('images/bg-content.bmp');
  contentPage.Canvas.Draw(0,0,bg); //position and picture
  bg.Free;
end;

procedure TcontentPage.shutdown_btnClick(Sender: TObject);
var i:integer;
begin
//  FreeAndNil(pGoBack);
//  FreeAndNil(pItem);
//  FreeAndNil(pDownload);
//  FreeAndNil(pRating);
//  for i:= 1 to 5 do FreeAndNil(pRate[i]);
//  FreeAndNil(pRate);
//  FreeAndNil(pTitle);
//  FreeAndNil(pSub);
//  FreeAndNil(pDescription);
//  FreeAndNil(pContent);
//  FreeAndNil(pUserIcon);
//  FreeAndNil(pUserName);
//  FreeAndNil(pUserComment);
//  FreeAndNil(pAddComment);
//
//  for i := 1 to db.QueryContent.RecordCount do
//  begin
//    FreeAndNil(bgContent[i]);
//    FreeAndNil(bgImg[i]);
//    FreeAndNil(titleContent[i]);
//    FreeAndNil(subContent[i]);
//    FreeAndNil(descriptionContent[i]);
//  end;

  contentPage.Close;
  firstEnterprice.Close;
end;

procedure TcontentPage.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseMoving := true;
  mouseX := X;
  mouseY := Y;
  AlphaBlend := true;//opacity on/off
  AlphaBlendValue := 180;//opacity value
end;

procedure TcontentPage.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if mouseMoving then
  begin
    left := left + (x - mouseX);
    top := top + (y - mouseY);
  end;
end;


procedure TcontentPage.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseMoving := false;
  AlphaBlend := false;
end;

procedure TcontentPage.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if heightResult > 465 then
  begin
    if scrollResult < heightResult then
    begin
      ScrollBy(0, -10);
      shutdown_btn.Top := shutdown_btn.Top + 10;
      collapse_btn.Top := collapse_btn.Top + 10;
      arrow_btn.Top := arrow_btn.Top + 10;
      scrollResult := scrollResult + 10;
      contentScroll.Top := contentScroll.Top + 15;
    end;
  end;
end;

procedure TcontentPage.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if scrollResult > 465 then
  begin
      ScrollBy(0, 10);
      shutdown_btn.Top := shutdown_btn.Top - 10;
      collapse_btn.Top := collapse_btn.Top - 10;
      arrow_btn.Top := arrow_btn.Top - 10;
      scrollResult := scrollResult - 10;
      contentScroll.Top := contentScroll.Top - 15;
  end;
end;

end.