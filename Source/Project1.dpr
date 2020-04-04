program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {firstEnterprice},
  Unit2 in 'Unit2.pas' {showLogin};

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
  Application.CreateForm(TshowLogin, showLogin);
  Application.Run;

end.
