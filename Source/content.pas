unit content;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, FireDAC.Stan.Param, Data.DB,
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

      //�������� �������� �� ��������
    pGoBack:TImage;//��������� �����
    pItem:TImage;//�����������
    pDownload:TImage;//������ �������
    pRating:TLabel;//������� ��������
    pRatingImg:TImage;//������� ��������(�������)
    pRate: array of TImage;//������� �������� (��������� ��� ����������)
    pTitle:TLabel;//���������
    pSub:TLabel;//������������
    pDescription:TLabel;//��������
    pContent:TImage;//�����, ����� � �.�. ��� ����� ���� ����������
    pUserIcon:TImage;//������ ������������ �� ��������
    pUserName:TLabel;//��� ������������ �� ��������
    pUserComment:TLabel;//����������
    pAddComment:TMemo;//���������� ����������

      //�������� ����� ��������
    bgImg: array of TImage;//�����������
    bgContent: array of TImage;//������� ���
    titleContent: array of TLabel;//���������
    subContent: array of TLabel;//������������
    descriptionContent: array of TLabel;//��������

    procedure bgImgClick(Sender: TObject);//������� �� �������
    procedure titleContentClick(Sender: TObject);//������� �� �������
    procedure subContentClick(Sender: TObject);//������� �� �������
    procedure descriptionContentClick(Sender: TObject);//������� �� �������
    procedure bgContentClick(Sender: TObject);//������� �� �������
    procedure pRateHover(Sender: TObject);//��������� �� �������
    procedure pRateLeave(Sender: TObject);//����� ������ ������� ��������� ��������
    procedure pRateClick(Sender: TObject);//������� �� �������
    procedure GoToContent(Sender: TObject);//���������� �� �������� ��������
    procedure LoadPage(var id:integer);//�������� ��������
    procedure LoadRate();//�������� ��������
  end;

var
  contentPage: TcontentPage;
  link,//���� � �����������
  QueryType//������������ ���� QueryTypeContent � �������� �������� (�����, ���������, ���������� � �.�)
  :string;

  RateCount:real;//������� �������� QueryRateCount//���������� ��������

  scrollResult,//���������
  QueryUserID,//ID ������������
  QueryCount,
  QueryID,//ID ��������
  PageID,//ID �������� ��������
  heightResult,//���������� ������ �������� ��� �������� ������
  ImageTop,//������ ������ ��� ����������� ��������
  RateLeft,//������ ����� ��� ��������
  bgTop,//������ ������ ��� ������� ���� ��������
  TitleTop,//������ ������ ��� ���������
  subTop,//������ ������ ��� ������������
  descTop,//������ ������ ��� �������� (desc - description)
  QueryTypeContent//�������� ��������
  :integer;

  isPage,//���� �������� �������
  isRate,//���� ������� ��� ����� � ����� �� �������� ����������
  isRateClick//������ ������� �� �������
  :boolean;

implementation

{$R *.dfm}

uses main, database, enter, enterform, login, themes;

procedure TcontentPage.CreateParams(var Params: TCreateParams);//�������� ������ �� ������ ������
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure getContentHeight(var count:integer);//��������� ������ ��������
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

procedure TcontentPage.arrow_btnClick(Sender: TObject);//������� �� ��������� ����� �� �������� ��� ���� �������
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

procedure TcontentPage.shutdown_btnClick(Sender: TObject);
//var i:integer;
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

procedure TcontentPage.collapse_btnClick(Sender: TObject);//�������� ����������
begin
  WindowState:= wsMinimized;
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

procedure TcontentPage.FormActivate(Sender: TObject);
var i, titleLength: integer;
begin
  isPage := false;
  isRate := false;
  isRateClick := false;

  arrow_btn.Visible := true;
  scrollResult := 465;
  bgTop := 30;
  ImageTop := 40;
  TitleTop := 40;
  subTop := 43;
  descTop := 65;
  RateLeft := 50;

  db.QueryPageInfo.SQL.Text := 'SELECT * FROM users WHERE u_login = :u_login';
  db.QueryPageInfo.ParamByName('u_login').AsString := loginForm.loginField.Text;
  db.QueryPageInfo.Open;
  QueryUserID := db.QueryPageInfo['id'];

  db.QueryContent.SQL.Text := 'SELECT * FROM content WHERE c_type = :c_type';
  db.QueryContent.ParamByName('c_type').AsInteger := StateType;
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
        bgContent[i].Top := bgTop;
        bgTop := bgTop + 165;
        bgContent[i].Cursor := crHandPoint;
        bgContent[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        bgContent[i].OnClick := bgContentClick;
        bgContent[i].Picture.LoadFromFile('images/element.png');

          //�������� ��������
        QueryID := db.QueryContent['id'];
        bgImg[i]:=TImage.Create(nil);
        InsertControl(bgImg[i]);
        bgImg[i].Height := 109;
        bgImg[i].Width := 85;
        bgImg[i].Left := 120;
        bgImg[i].Top := ImageTop;
        ImageTop := ImageTop + 165;
        bgImg[i].Cursor := crHandPoint;
        bgImg[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        bgImg[i].OnClick := bgImgClick;

        db.QueryLoadContent.SQL.Text := 'SELECT * FROM content WHERE id = :id';
        db.QueryLoadContent.ParamByName('id').AsInteger := QueryID;
        db.QueryLoadContent.Open;
        link := db.QueryLoadContent['c_src'];
        bgImg[i].Picture.LoadFromFile(link);

          //�������� ���������
        titleContent[i]:=TLabel.Create(nil);
        InsertControl(titleContent[i]);
        titleContent[i].Left := 220;
        titleContent[i].Top := TitleTop;
        TitleTop := TitleTop + 165;
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
        subContent[i].Top := subTop;
        subTop := subTop + 165;
        subContent[i].Font.Color := clWindowFrame;
        subContent[i].Font.Name := 'Century Gothic';
        subContent[i].Font.Size := 10;
        subContent[i].Cursor := crHandPoint;
        subContent[i].tag := db.QueryContent.fieldByname('ID').asinteger;
        subContent[i].OnClick := subContentClick;

        QueryTypeContent := db.QueryLoadContent['c_typeContent'];
        case QueryTypeContent of
         0: QueryType := '�����';
         1: QueryType := '����������';
         2: QueryType := '������������';
        end;

        subContent[i].Caption := QueryType+', �����: ' +db.QueryLoadContent['c_athor'];

          //�������� ��������
        descriptionContent[i]:=TLabel.Create(nil);
        InsertControl(descriptionContent[i]);
        descriptionContent[i].Left := 220;
        descriptionContent[i].Top := descTop;
        descTop := descTop + 165;
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
      QueryCount:=db.QueryContent.RecordCount;
      getContentHeight(QueryCount);
      if QueryCount > 3 then
      begin
        contentScroll.Visible := true;
        for i := 4 to QueryCount do
        begin
          if contentScroll.Height <= 20 then break;
          contentScroll.Height := contentScroll.Height - 97;
        end;
      end;

  end;
end;

procedure TcontentPage.LoadRate();//�������� ��������
var test:string;
i:integer;
begin
  db.QueryPage.SQL.Text := 'SELECT * FROM rating WHERE id_page = :id_page AND id_user = :id_user';
  db.QueryPage.ParamByName('id_page').AsInteger := PageID;
  db.QueryPage.ParamByName('id_user').AsInteger := QueryUserID;
  db.QueryPage.Open;

  if isRateClick = false then
  begin
    setLength(pRate, 6);
    for i := 1 to 5 do
    begin
      pRate[i] := TImage.Create(nil);
      InsertControl(pRate[i]);
      pRate[i].Left := RateLeft;
      RateLeft := RateLeft + 26;
      pRate[i].Top := 260;
      pRate[i].Width := 22;
      pRate[i].Height := 21;
      pRate[i].Tag := i;
      pRate[i].Picture.LoadFromFile('images/star-none.png');
      pRate[i].OnClick := pRateClick;
      pRate[i].OnMouseEnter := pRateHover;
      pRate[i].OnMouseLeave := pRateLeave;
    end;
  end;

  if db.QueryPage.IsEmpty = false then
  begin
    isRate := true;
    db.QueryPageInfo.SQL.Text := 'SELECT c_rate FROM content WHERE id = :id';
    db.QueryPageInfo.ParamByName('id').AsInteger := PageID;
    db.QueryPageInfo.Open;
//    test := FloatToStrF(db.QueryPageInfo['c_rate']);
//    showmessage(test);
    pRating.Caption := FloatToStrF(db.QueryPageInfo['c_rate'], ffFixed, 1, 1);
    for i := 1 to 5 do pRate[i].Cursor := crDefault;
    if db.QueryPage['rateCount'] = 0.2 then for i := 1 to 1 do pRate[i].Picture.LoadFromFile('images/star-fill.png');
    if db.QueryPage['rateCount'] = 0.4 then for i := 1 to 2 do pRate[i].Picture.LoadFromFile('images/star-fill.png');
    if db.QueryPage['rateCount'] = 0.6 then for i := 1 to 3 do pRate[i].Picture.LoadFromFile('images/star-fill.png');
    if db.QueryPage['rateCount'] = 0.8 then for i := 1 to 4 do pRate[i].Picture.LoadFromFile('images/star-fill.png');
    if db.QueryPage['rateCount'] = 1.0 then for i := 1 to 5 do pRate[i].Picture.LoadFromFile('images/star-fill.png');
  end
  else
  begin
    isRate := false;
    for i := 1 to 5 do
    begin
      pRate[i].Picture.LoadFromFile('images/star-none.png');
      pRate[i].Cursor := crHandPoint;
    end;
  end;

end;

procedure TcontentPage.LoadPage(var id:integer);//�������� ��������
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

  db.QueryPage.SQL.Text := 'SELECT * FROM content WHERE id = :id';
  db.QueryPage.ParamByName('id').AsInteger := id;
  db.QueryPage.Open;

  QueryTypeContent := db.QueryLoadContent['c_typeContent'];
    case QueryTypeContent of
     0: QueryType := '�����';
     1: QueryType := '����������';
     2: QueryType := '������������';
    end;

  pGoBack := TImage.Create(nil);
  InsertControl(pGoBack);
  pGoBack.Width := 31;
  pGoBack.Height := 9;
  pGoBack.Left := 50;
  pGoBack.Top := 20;
  pGoBack.Picture.LoadFromFile('images/arrow.png');
  pGoBack.Cursor := crHandPoint;
  pGoBack.OnClick := GoToContent;

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
  pDownload.Cursor := crHandPoint;
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
  pSub.Caption := QueryType + ', �����: '+ db.QueryPage['c_athor'];

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

procedure TcontentPage.GoToContent(Sender: TObject);//����������� � ��������
var i:integer;
begin
  FreeAndNil(pGoBack);
  FreeAndNil(pItem);
  FreeAndNil(pDownload);
  FreeAndNil(pRating);
  for i:= 1 to 5 do FreeAndNil(pRate[i]);
  FreeAndNil(pRatingImg);
  FreeAndNil(pTitle);
  FreeAndNil(pSub);
  FreeAndNil(pDescription);
  FreeAndNil(pContent);
  FreeAndNil(pUserIcon);
  FreeAndNil(pUserName);
  FreeAndNil(pUserComment);
  FreeAndNil(pAddComment);

  FormActivate(self);
  FormPaint(self);
  shutdown_btn.BringToFront;
  collapse_btn.BringToFront;
end;

procedure TcontentPage.pRateClick(Sender: TObject);//������� �� Rate
var
  getID:TImage absolute Sender;
  id: integer;
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

//    if db.QueryPage['c_rate'] <= 0 then QueryRateCount := RateCount
//    else QueryRateCount := db.QueryPage['c_rate'] + RateCount;

    RateCount := RateCount + db.QueryPage['c_rate'];

    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('INSERT INTO rating (rateCount, id_user, id_page) VALUES (:rateCount, :id_user, :id_page);');
    db.QueryPage.ParamByName('rateCount').AsFloat := RateCount;
    db.QueryPage.ParamByName('id_user').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_page').AsInteger := PageID;
    db.QueryPage.Execute;

    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('UPDATE content SET c_rate = :c_rate WHERE id = :id');
    db.QueryPage.ParamByName('c_rate').AsFloat := RateCount;
    db.QueryPage.ParamByName('id').AsInteger := PageID;
    db.QueryPage.Execute;

    isRateClick := true;
    loadRate();
  end;
end;

procedure TcontentPage.pRateLeave(Sender: TObject);//������ ��� �������� Rate
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

procedure TcontentPage.pRateHover(Sender: TObject);//������ � �������� Rate
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

procedure TcontentPage.bgContentClick(Sender: TObject);//�������� �������� ���������� ��������
var
  getID:TImage absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.bgImgClick(Sender: TObject);//�������� �������� ���������� ��������
var
  getID:TImage absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.titleContentClick(Sender: TObject);//�������� �������� ���������� ��������
var
  getID:TLabel absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.subContentClick(Sender: TObject);//�������� �������� ���������� ��������
var
  getID:TLabel absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

procedure TcontentPage.descriptionContentClick(Sender: TObject);//�������� �������� ���������� ��������
var
  getID:TLabel absolute Sender;
  id: integer;
begin
  id := getID.Tag;
  if not db.QueryContent.locate('ID', id, []) then
    showMessage('ID �� ������');
  LoadPage(id);
end;

  //<mouseLogic>

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
  //</mouseLogic>
end.
