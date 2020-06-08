unit content;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls, FireDAC.Stan.Param, Data.DB,
  Vcl.StdCtrls, ShellApi, StrUtils;

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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
    pUserIcon: array of TImage;//������ ������������ �� ��������
    pUserName: array of TLabel;//��� ������������ �� ��������
    pAddComment:TMemo;//���������� ����������
    pUserComment: array of TLabel;//����������
    pSendComment: TImage;
    pLikeComment: array of TImage;
    pLikeCount: array of TLabel;
    pDislikeComment: array of TImage;
    pDislikeCount: array of TLabel;
    pDateComment: array of TLabel;


      //�������� �����������
    iTitle: array of TLabel;
//    iPrefix:Tlabel;
    iText:TLabel;
    iDescription:TLabel;
    iAdminBtn:Timage;
    iAdmin:TLabel;


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
    procedure DownloadClick(Sender: TObject);
    procedure iAdminClick(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure LikeClick(Sender: TObject);
    procedure DislikeClick(Sender: TObject);
    procedure LoadPage(var id:integer);//�������� ��������
    procedure LoadRate();//�������� ��������
    procedure LoadComment(var CommentAdd, CommentAthor, CommentText, CommentLike, CommentDis:boolean);
//    procedure LoadComment(var CommentAdd, CommentAthor, CommentText, CoomentLike, CommentDis:boolean);
//    procedure LoadComment(var CommentAdd:boolean; CommentAthor:boolean; CommentText:boolean; CoomentLike:boolean; CommentDis:boolean); overload;
  end;

var
  contentPage: TcontentPage;
  posInfo: array of integer;
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
  QueryTypeContent,//�������� ��������
  posComment,//������� �����������
  qID,
  qCommentID
  :integer;

  isPage,//���� �������� �������
  isRate,//���� ������� ��� ����� � ����� �� �������� ����������
  isRateClick,//������ ������� �� �������
  isObject,
  contentOn,
  contentOff,
  isAdminClosed
  :boolean;

implementation

{$R *.dfm}

uses main, database, enter, enterform, login, themes, admin;

procedure TcontentPage.CreateParams(var Params: TCreateParams);//�������� ������ �� ������ ������
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := 0;
end;

procedure getContentHeight(var count:integer; cH:integer; cTo:integer; cDo:integer);//��������� ������ ��������
var cHeight, i:integer;
begin
  cHeight := 465;
  if count > cTo then
    for i := cDo to count do
    begin
      cHeight := cHeight + cH;//
      heightResult := cHeight;
    end
  else heightResult := 465;
end;

procedure TcontentPage.arrow_btnClick(Sender: TObject);//������� �� ��������� ����� �� �������� ��� ���� �������
var i : integer;
begin
  if db.QueryContent['c_type'] = 3 then
  begin
    for i := 1 to db.QueryContent.RecordCount do FreeAndNil(iTitle[i]);
    FreeAndNil(iText);
    homePage.Show;
    contentPage.close;
    exit;
  end;

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
begin
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

procedure TcontentPage.iAdminClick(Sender: TObject);
begin
  admin_control.Show;
end;

procedure TcontentPage.FormActivate(Sender: TObject);
var i, titleLength, maxLength: integer;
begin
  if isAdminClosed = true then exit;
  isAdminClosed := false;
  isPage := false;
  isRate := false;
  isRateClick := false;
  isObject := false;
  contentOn := true;
  contentOff := false;

  maxLength := 0;

  arrow_btn.Visible := true;
  scrollResult := 465;
  bgTop := 30;
  ImageTop := 40;
  TitleTop := 40;
  subTop := 43;
  descTop := 65;
  RateLeft := 50;
  SetLength(posInfo, 4);
  posInfo[0] := 70;//������ �����
  posInfo[1] := 120;//������ ������

  db.QueryPageInfo.SQL.Text := 'SELECT * FROM users WHERE u_login = :u_login';
  db.QueryPageInfo.ParamByName('u_login').AsString := loginForm.loginField.Text;
  db.QueryPageInfo.Open;
  QueryUserID := db.QueryPageInfo['id'];

  db.QueryContent.SQL.Text := 'SELECT * FROM content WHERE c_type = :c_type';
  db.QueryContent.ParamByName('c_type').AsInteger := StateType;
  db.QueryContent.Open;

  if db.QueryPageInfo['u_admin'] = 1 then
  begin
    iAdminBtn := TImage.Create(nil);
    InsertControl(iAdminBtn);
    iAdminBtn.Left := 625;
    iAdminBtn.Top := 0;
    iAdminBtn.Width := 100;
    iAdminBtn.Height := 18;
    iAdminBtn.Picture.LoadFromFile('images/setting-field.png');

    iAdmin := TLabel.Create(nil);
    InsertControl(iAdmin);
    iAdmin.Caption := '�������� �������';
    iAdmin.Left := 628;
    iAdmin.Cursor := crHandPoint;
    iAdmin.OnClick := iAdminClick;
    iAdmin.Font.Color := clWhite;
    iAdmin.Top := 2;
  end;

  if db.QueryContent.IsEmpty = false then
  begin
        //������� ��� �����������
    if db.QueryContent['c_type'] = 3 then
    begin
      iText := TLabel.Create(nil);
      InsertControl(iText);
      iText.Left := 100;
      iText.Top := 50;
      iText.Caption := '����������';
      iText.Font.Color := clWindowFrame;
      iText.Font.Size := 16;
      iText.Caption := '����������  ';

      SetLength(iTitle, 4);
      i:=1;
      while not db.QueryContent.Eof do
      begin
        iTitle[i] := TLabel.Create(nil);
        InsertControl(iTitle[i]);
        if posInfo[0] > 660 then
        begin
          posInfo[0] := 70;
          posInfo[1] := posInfo[1] + maxLength;
          maxLength := 0;
        end;
        posInfo[0] := posInfo[0] + maxLength + 30;
        iTitle[i].Left := posInfo[0];
        iTitle[i].Top := posInfo[1];
        iTitle[i].Caption := db.QueryContent['c_title'];
        iTitle[i].Font.Size := 12;
        if maxLength < iTitle[i].Width then maxLength := iTitle[i].Width;
        iTitle[i].Font.Color := clHotLight;
        iTitle[i].Font.Style := [fsUnderline];
        inc(i);
        db.QueryContent.next;
      end;
      exit;
    end;

      //�������� ��������
      SetLength(bgContent, db.QueryContent.RecordCount + 1);
      SetLength(bgImg, db.QueryContent.RecordCount + 1);
      SetLength(titleContent, db.QueryContent.RecordCount + 1);
      SetLength(subContent, db.QueryContent.RecordCount + 1);
      SetLength(descriptionContent, db.QueryContent.RecordCount + 1);
      i:=1;
//      for i := 1 to db.QueryContent.RecordCount do
      while not db.QueryContent.Eof do
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
        bgImg[i].Stretch := true;
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

        titleContent[i].Caption := db.QueryLoadContent['c_title'];

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
         3: QueryType := '���������';
         4: QueryType := '�������';
         5: QueryType := '��������� ��������';
         6: QueryType := '����������';
        end;

        subContent[i].Caption := ', ' + QueryType+', �����: ' +db.QueryLoadContent['c_athor'];

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
        inc(i);
        db.QueryContent.next;
      end;

      //�������� �������
      QueryCount:=db.QueryContent.RecordCount;
      getContentHeight(QueryCount, 165, 3, 4);
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
  isAdminClosed := true;
end;

procedure TcontentPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isAdminClosed := false;
end;

procedure TcontentPage.FormCreate(Sender: TObject);
begin
  isAdminClosed := false;
end;

procedure TcontentPage.LoadRate();//�������� ��������
var
i:integer;
begin

  db.QueryPage.SQL.Text := 'SELECT * FROM content WHERE id = :id';
  db.QueryPage.ParamByName('id').AsInteger := PageID;
  db.QueryPage.Open;

  pRating := TLabel.Create(nil);
  InsertControl(pRating);
  pRating.Left := 150;
  pRating.Top := 228;
  pRating.Font.Color := RGB(255, 193, 7);
  pRating.Font.Size := 14;
  if db.QueryPage['c_rate'] > 0 then pRating.Caption := FloatToStrF(db.QueryPage['c_rate'], ffFixed, 1, 1)
  else pRating.Caption := '0,0';

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
var i, resultMath:integer;
math:real;
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
    db.QueryContent.Next;
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
     3: QueryType := '���������';
     4: QueryType := '�������';
     5: QueryType := '��������� ��������';
     6: QueryType := '����������';
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
  pDownload.OnClick := DownloadClick;
  pDownload.Picture.LoadFromFile('images/download.png');

  pRatingImg := TImage.Create(nil);
  InsertControl(pRatingImg);
  pRatingImg.Width := 12;
  pRatingImg.Height := 12;
  pRatingImg.Left := 133;
  pRatingImg.Top := 235;
  pRatingImg.Picture.LoadFromFile('images/star.png');

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
  pTitle.Caption := db.QueryPage['c_title'];

  pSub := TLabel.Create(nil);
  InsertControl(pSub);
  pSub.Left := 230 + pTitle.Width;
  pSub.Top := 53;
  pSub.Font.Color := clWindowFrame;
  pSub.Font.Name := 'Century Gothic';
  pSub.Font.Size := 10;
  pSub.Caption := ', '+QueryType + ', �����: '+ db.QueryPage['c_athor'];

  pDescription:=TLabel.Create(nil);
  InsertControl(pDescription);
  pDescription.Left := 230;
  pDescription.Top := 105;
  pDescription.Font.Color := clWindowFrame;
  pDescription.Font.Size := 14;
  pDescription.Caption := db.QueryPage['c_description'];
  pDescription.Width := 515;
  math := (length(pDescription.Caption)+515+25)/5;
  resultMath := trunc(math);
  pDescription.Height := resultMath;
  pDescription.AutoSize := false;
  pDescription.WordWrap := true;

  pContent:=TImage.Create(nil);
  InsertControl(pContent);
  pContent.Height := 0;

  LoadComment(contentON, contentON, contentON, contentON, contentON);

end;

//procedure TcontentPage.LoadComment(var CommentAdd:boolean; CommentAthor:boolean; CommentText:boolean; CoomentLike:boolean; CommentDis:boolean);
procedure TcontentPage.LoadComment(var CommentAdd, CommentAthor, CommentText, CommentLike, CommentDis:boolean);
var math:real;
sender, i, resultMath, like_count:integer;
begin
  iAdminBtn.BringToFront;
  iAdmin.BringToFront;
  posComment := 105 + 50 + pDescription.Height + pContent.Height;
  if isObject = true then
  begin

    if CommentAdd = true then
    begin
      FreeAndNil(pAddComment);
      FreeAndNil(pSendComment);
      FreeAndNil(pUserIcon[0]);
    end;
    if CommentAthor = true then
    begin
      for i := 1 to db.QueryPage.RecordCount do
      begin
        FreeAndNil(pUserName[i]);
        FreeAndNil(pUserIcon[i]);
      end;
    end;
    if CommentText = true then
    begin
      for i := 1 to db.QueryPage.RecordCount do
      begin
        FreeAndNil(pUserComment[i]);
      end;
    end;
    if CommentLike = true then
    begin
      for i := 1 to db.QueryPage.RecordCount do
      begin
        FreeAndNil(pLikeComment[i]);
        FreeAndNil(pLikeCount[i]);
      end;
    end;
    if CommentDis = true then
    begin
      for i := 1 to db.QueryPage.RecordCount do
      begin
        FreeAndNil(pDislikeComment[i]);
        FreeAndNil(pDislikeCount[i]);
      end;
    end;
  end;

  db.QueryPage.SQL.Text := 'SELECT * FROM comment WHERE id_page = :id_page ORDER BY id DESC';
  db.QueryPage.ParamByName('id_page').AsInteger := PageID;
  db.QueryPage.Open;

  SetLength(pUserIcon, db.QueryPage.RecordCount + 1);
  if CommentAdd = true then
  begin
    pUserIcon[0] := TImage.Create(self);
    InsertControl(pUserIcon[0]);
    pUserIcon[0].Left := 230;
    pUserIcon[0].Top := posComment;
    pUserIcon[0].Height := 35;
    pUserIcon[0].Width := 35;
    pUserIcon[0].Picture.LoadFromFile('images/user-dark.png');


    pAddComment := TMemo.Create(self);
    InsertControl(pAddComment);
    pAddComment.Left := 295;
    pAddComment.Lines.Text:='�����������������';
    pAddComment.Font.Color := clWindowFrame;
    pAddComment.Top := posComment;
    pAddComment.Height := 35;
    pAddComment.Width := 250;

    pSendComment := TImage.Create(self);
    InsertControl(pSendComment);
    pSendComment.left := pAddComment.Left + 30 + 250;
    pSendComment.Top := posComment + 6;
    pSendComment.Width := 35;
    pSendComment.Height := 35;
    pSendComment.Cursor := crHandPoint;
    pSendComment.Picture.LoadFromFile('images/send.png');
    pSendComment.OnClick := SendClick;
  end;

  if not db.QueryPage.IsEmpty then
  begin

//    for i := 1 to db.QueryPage.RecordCount do
    i:=1;
    while not db.QueryPage.Eof do
    begin
      posComment := posComment + 75;

      db.QueryInsertComment.SQL.Text := 'SELECT * FROM comment WHERE id_page = :id_page';
      db.QueryInsertComment.ParamByName('id_page').AsInteger := PageID;
      db.QueryInsertComment.Open;
      qID := db.QueryPage['id'];

      sender := db.QueryPage['id_sender'];
      db.QueryPageInfo.SQL.Text := 'SELECT * FROM users WHERE id = :id';
      db.QueryPageInfo.ParamByName('id').AsInteger := sender;
      db.QueryPageInfo.Open;

      qCommentID := db.QueryPage['id'];

      if CommentAthor = true then
      begin
        pUserIcon[i]:=TImage.Create(self);
        InsertControl(pUserIcon[i]);
        pUserIcon[i].Left := 230;
        pUserIcon[i].Top := posComment;
        pUserIcon[i].Height := 35;
        pUserIcon[i].Width := 35;
        pUserIcon[i].Picture.LoadFromFile('images/user-dark.png');

        SetLength(pUserName, db.QueryPage.RecordCount + 1);

        pUserName[i]:=TLabel.Create(self);
        InsertControl(pUserName[i]);
        pUserName[i].Left := 230 + 45;
        pUserName[i].Top := posComment;
        if loginForm.loginField.Text = db.QueryPageInfo['u_login'] then
        pUserName[i].Caption := '��:'
        else pUserName[i].Caption := db.QueryPageInfo['u_login'];
        pUserName[i].Font.Style := [fsBold];
        pUserName[i].Font.Color := clWindowFrame;
        pUserName[i].Font.Size := 10;
      end;

      if CommentText = true then
      begin
        SetLength(pUserComment, db.QueryPage.RecordCount + 1);
        pUserComment[i]:=TLabel.Create(self);
        InsertControl(pUserComment[i]);
        pUserComment[i].Left := 230 + 45;
        pUserComment[i].Top := posComment + 18;
        pUserComment[i].Caption := db.QueryPage['comment'];
        pUserComment[i].Font.Size := 10;
        pUserComment[i].Font.Color := clWindowFrame;
        pUserComment[i].Width := 300;
        math := (length(pUserComment[i].Caption)+240)/5;
        resultMath := trunc(math);
        pUserComment[i].Height := resultMath;
        pUserComment[i].AutoSize := false;
        pUserComment[i].WordWrap := true;
      end;

      db.QueryComment.SQL.Text := 'SELECT * FROM likes WHERE id_comment = :id_comment AND id_liker = :id_liker AND id_page = :id_page';
      db.QueryComment.ParamByName('id_comment').AsInteger := qCommentID;
      db.QueryComment.ParamByName('id_liker').AsInteger := QueryUserID;
      db.QueryComment.ParamByName('id_page').AsInteger := PageID;
      db.QueryComment.Open;
      
      if CommentLike = true then
      begin
      
        SetLength(pLikeComment, db.QueryPage.RecordCount + 1);
        SetLength(pLikeCount, db.QueryPage.RecordCount + 1);

        pLikeCount[i] := TLabel.Create(self);
        InsertControl(pLikeCount[i]);
        pLikeCount[i].Left := 230 + 45;
        pLikeCount[i].Top := pUserComment[i].Top + 14 + 9;
        pLikeCount[i].Font.Color := clWindowFrame;
        pLikeCount[i].Font.Size := 10;
        pLikeCount[i].Font.Name := 'Arial';
        pLikeCount[i].Caption := db.QueryPage['liked'];

        pLikeComment[i] := TImage.Create(self);
        InsertControl(pLikeComment[i]);
        pLikeComment[i].Width := 16;
        pLikeComment[i].Height := 16;
        pLikeComment[i].Top := pUserComment[i].Top + 12 + 10;
        pLikeComment[i].Left := 230 + 50 + 6;
        pLikeComment[i].Cursor := crHandPoint;
        pLikeComment[i].Tag := qID;
        pLikeComment[i].OnClick := LikeClick;
        pLikeComment[i].Picture.LoadFromFile('images/like.png');
//        if db.QueryComment['type'] = 1 then pLikeComment[i].Picture.LoadFromFile('images/like-enabled.png');
//        if db.QueryComment.IsEmpty then pLikeComment[i].Picture.LoadFromFile('images/like.png');
      end;

      if CommentDis = true then
      begin
        SetLength(pDislikeComment, db.QueryPage.RecordCount + 1);
        SetLength(pDislikeCount, db.QueryPage.RecordCount + 1);

        pDislikeCount[i] := TLabel.Create(self);
        InsertControl(pDislikeCount[i]);
        pDislikeCount[i].Left := 230 + 81;
        pDislikeCount[i].Top := pUserComment[i].Top + 14 + 9;
        pDislikeCount[i].Font.Color := clWindowFrame;
        pDislikeCount[i].Font.Size := 10;
        pDislikeCount[i].Font.Name := 'Arial';
        pDislikeCount[i].Caption := db.QueryPage['disliked'];

        pDislikeComment[i] := TImage.Create(self);
        InsertControl(pDislikeComment[i]);
        pDislikeComment[i].Width := 16;
        pDislikeComment[i].Height := 16;
        pDislikeComment[i].Top := pUserComment[i].Top + 12 + 10;
        pDislikeComment[i].Left := 230 + 92;
        pDislikeComment[i].Tag := qID;
        pDislikeComment[i].Cursor := crHandPoint;
        pDislikeComment[i].OnClick := DislikeClick;
        pDislikeComment[i].Picture.LoadFromFile('images/dislike.png');
//        if db.QueryComment['type'] = -1 then pDislikeComment[i].Picture.LoadFromFile('images/dislike-enabled.png');
//        if db.QueryComment.IsEmpty then pDislikeComment[i].Picture.LoadFromFile('images/dislike.png');
        case db.QueryComment['type'] of
          1: pLikeComment[i].Picture.LoadFromFile('images/like-enabled.png');
          -1: pDislikeComment[i].Picture.LoadFromFile('images/dislike-enabled.png');
        end;
      end;

      db.QueryPage.Next;
      db.QueryPageInfo.Next;
      db.QueryInsertComment.Next;
      db.QueryComment.next;
      inc(i);
    end;

  end;

    QueryCount:=db.QueryPage.RecordCount;
    getContentHeight(QueryCount, 75, 1, 2);
    if QueryCount > 1 then
    begin
      contentScroll.Visible := true;
      for i := 1 to QueryCount do
      begin
        if contentScroll.Height <= 20 then break;
        contentScroll.Height := contentScroll.Height - 10;
      end;
    end;

    isObject := true;

end;

procedure TcontentPage.DislikeClick(Sender: TObject);
var QueryLikeCount, QueryDisCount, id,i:integer;
getID:TImage absolute sender;
begin
  id:=GetID.Tag;

  for i := 1 to db.QueryPage.RecordCount do
  begin
    FreeAndNil(pDisLikeComment[i]);
    FreeAndNil(pDisLikeCount[i]);
  end;

  db.QueryPage.SQL.Text := 'SELECT * FROM comment WHERE id = :id';
  db.QueryPage.ParamByName('id').AsInteger := id;
  db.QueryPage.Open;

  QueryLikeCount := db.QueryPage['liked'];
  QueryDisCount := db.QueryPage['disliked'];

  if db.QueryComment['type'] = 1 then
  begin
    QueryDisCount := QueryDisCount + 1;
    if QueryLikeCount > 0 then QueryLikeCount := QueryLikeCount - 1;
    db.QueryInsertComment.SQL.Clear;
    db.QueryInsertComment.SQL.Add('UPDATE comment SET (disliked = :disliked, liked = :liked) WHERE id = :id');
    db.QueryInsertComment.ParamByName('disliked').AsInteger := QueryDisCount;
    db.QueryInsertComment.ParamByName('liked').AsInteger := QueryLikeCount;
    db.QueryInsertComment.ParamByName('id').AsInteger := id;
    db.QueryInsertComment.Execute;

    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('UPDATE likes SET type = :type WHERE id_liker = :id_liker AND id_comment = :id_comment');
    db.QueryPage.ParamByName('type').AsInteger := -1;
    db.QueryPage.ParamByName('id_liker').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_comment').AsInteger := qCommentID;

    LoadComment(contentOff, contentOff, contentOff, contentOff, contentOn);
    exit;
  end;

  if not db.QueryComment.IsEmpty then//���� �� ���� ����� �� ����������
  begin
    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('DELETE FROM likes WHERE id_liker = :id_liker AND id_comment = :id_comment');
    db.QueryPage.ParamByName('id_liker').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_comment').AsInteger := id;
    db.QueryPage.Execute;

    QueryDisCount := QueryDisCount - 1;
    db.QueryInsertComment.SQL.Clear;
    db.QueryInsertComment.SQL.Add('UPDATE comment SET liked = :liked WHERE id = :id');
    db.QueryInsertComment.ParamByName('liked').AsInteger := QueryDisCount;
    db.QueryInsertComment.ParamByName('id').AsInteger := id;
    db.QueryInsertComment.Execute;

    LoadComment(contentOff, contentOff, contentOff, contentOff, contentOn);
  end
  else
  begin
    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('INSERT INTO likes (id_liker, id_page, id_comment, type) VALUES (:id_liker, :id_page, :id_comment, :type);');
    db.QueryPage.ParamByName('id_liker').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_page').AsInteger := PageID;
    db.QueryPage.ParamByName('id_comment').AsInteger := id;
    db.QueryPage.ParamByName('type').AsInteger := -1;
    db.QueryPage.Execute;

    QueryDisCount := QueryDisCount + 1;
    db.QueryInsertComment.SQL.Clear;
    db.QueryInsertComment.SQL.Add('UPDATE comment SET disliked = :disliked WHERE id = :id');
    db.QueryInsertComment.ParamByName('disliked').AsInteger := QueryDisCount;
    db.QueryInsertComment.ParamByName('id').AsInteger := id;
    db.QueryInsertComment.Execute;

    LoadComment(contentOff, contentOff, contentOff, contentOff, contentOn);
  end;
end;

procedure TcontentPage.LikeClick(Sender: TObject);
var QueryLikeCount, QueryDisCount, id,i:integer;
getID:TImage absolute sender;
begin
  id:=GetID.Tag;

  for i := 1 to db.QueryPage.RecordCount do
  begin
    FreeAndNil(pLikeComment[i]);
    FreeAndNil(pLikeCount[i]);
  end;

  db.QueryPage.SQL.Text := 'SELECT * FROM comment WHERE id = :id';
  db.QueryPage.ParamByName('id').AsInteger := id;
  db.QueryPage.Open;

  QueryLikeCount := db.QueryPage['liked'];
  QueryDisCount := db.QueryPage['disliked'];

  if db.QueryComment['type'] = -1 then
  begin
    if QueryDisCount > 0 then QueryDisCount := QueryDisCount - 1;
    QueryLikeCount := QueryLikeCount + 1;
    db.QueryInsertComment.SQL.Clear;
    db.QueryInsertComment.SQL.Add('UPDATE comment SET (disliked = :disliked, liked = :liked) WHERE id = :id');
    db.QueryInsertComment.ParamByName('disliked').AsInteger := QueryDisCount;
    db.QueryInsertComment.ParamByName('liked').AsInteger := QueryLikeCount;
    db.QueryInsertComment.ParamByName('id').AsInteger := id;
    db.QueryInsertComment.Execute;

    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('UPDATE likes SET type = :type WHERE id_liker = :id_liker AND id_comment = :id_comment');
    db.QueryPage.ParamByName('type').AsInteger := 1;
    db.QueryPage.ParamByName('id_liker').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_comment').AsInteger := qCommentID;

    LoadComment(contentOff, contentOff, contentOff, contentOn, contentOff);
    exit;
  end;

  if not db.QueryComment.IsEmpty then//���� �� ���� ����� �� ����������
  begin
    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('DELETE FROM likes WHERE id_liker = :id_liker AND id_comment = :id_comment');
    db.QueryPage.ParamByName('id_liker').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_comment').AsInteger := id;
    db.QueryPage.Execute;

    QueryLikeCount := QueryLikeCount - 1;
    db.QueryInsertComment.SQL.Clear;
    db.QueryInsertComment.SQL.Add('UPDATE comment SET liked = :liked WHERE id = :id');
    db.QueryInsertComment.ParamByName('liked').AsInteger := QueryLikeCount;
    db.QueryInsertComment.ParamByName('id').AsInteger := id;
    db.QueryInsertComment.Execute;

    LoadComment(contentOff, contentOff, contentOff, contentOn, contentOff);
  end
  else
  begin
    db.QueryPage.SQL.Clear;
    db.QueryPage.SQL.Add('INSERT INTO likes (id_liker, id_page, id_comment, type) VALUES (:id_liker, :id_page, :id_comment, :type);');
    db.QueryPage.ParamByName('id_liker').AsInteger := QueryUserID;
    db.QueryPage.ParamByName('id_page').AsInteger := PageID;
    db.QueryPage.ParamByName('id_comment').AsInteger := id;
    db.QueryPage.ParamByName('type').AsInteger := 1;
    db.QueryPage.Execute;

    QueryLikeCount := QueryLikeCount + 1;
    db.QueryInsertComment.SQL.Clear;
    db.QueryInsertComment.SQL.Add('UPDATE comment SET liked = :liked WHERE id = :id');
    db.QueryInsertComment.ParamByName('liked').AsInteger := QueryLikeCount;
    db.QueryInsertComment.ParamByName('id').AsInteger := id;
    db.QueryInsertComment.Execute;

    LoadComment(contentOff, contentOff, contentOff, contentOn, contentOff);
  end;
end;

procedure TcontentPage.SendClick(Sender: TObject);
begin
  if (length(pAddComment.Lines.Text) > 128) or (length(pAddComment.Lines.Text) < 0) then
  begin
    showmessage('������ ����������� ������ ���� �� ����� 1 � ����� 128 ��������!');
    exit;
  end;

  db.QueryInsertComment.SQL.Clear;
  db.QueryInsertComment.SQL.Add('INSERT INTO comment (id_sender, id_page, comment) VALUES (:id_sender, :id_page, :comment)');
  db.QueryInsertComment.ParamByName('id_sender').AsInteger := QueryUserID;
  db.QueryInsertComment.ParamByName('id_page').AsInteger := PageID;
  db.QueryInsertComment.ParamByName('comment').AsString := pAddComment.Lines.Text;
  db.QueryInsertComment.Execute;
  LoadComment(contentOff, contentOn, contentOn, contentOn, contentOn);
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
  FreeAndNil(pAddComment);
  FreeAndNil(pSendComment);
  FreeAndNil(pUserIcon[0]);
  for i := 1 to db.QueryPage.RecordCount do
  begin
    FreeAndNil(pUserIcon[i]);
    FreeAndNil(pUserName[i]);
    FreeAndNil(pUserComment[i]);
    FreeAndNil(pLikeComment[i]);
    FreeAndNil(pLikeCount[i]);
    FreeAndNil(pDislikeComment[i]);
    FreeAndNil(pDislikeCount[i]);
  end;
  isAdminClosed := false;
  FormActivate(self);
  FormPaint(self);
  shutdown_btn.BringToFront;
  collapse_btn.BringToFront;
end;

procedure TcontentPage.DownloadClick(Sender: TObject);
begin
 ShellExecute(0,'Open',PWideChar(db.QueryPage.FieldByName('c_download').AsString),nil,nil,SW_NORMAL);
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
    db.QueryPage.SQL.Text := 'SELECT * FROM content WHERE id = :id';
    db.QueryPage.ParamByName('id').AsInteger := PageID;
    db.QueryPage.Open;

    RateCount := format('%1.1f', [RateCount]) + db.QueryPage['c_rate'];

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
    pRating.Caption := ' ';
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
      ScrollBy(0,-10);
      shutdown_btn.Top := shutdown_btn.Top + 10;
      collapse_btn.Top := collapse_btn.Top + 10;
      arrow_btn.Top := arrow_btn.Top + 10;
      scrollResult := scrollResult + 10;
      contentScroll.Top := contentScroll.Top + 15;
      iAdminBtn.Top := iAdminBtn.Top + 10;
      iAdmin.Top := iAdminBtn.Top + 2;
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
      iAdminBtn.Top := iAdminBtn.Top - 10;
      iAdmin.Top := iAdminBtn.Top;
  end;
end;
  //</mouseLogic>
end.
