unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,GLEngine, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CreateTex,pod,Mybrush:Cardinal;
  GLE:TGLEngine;
  down:Boolean;
implementation
 uses unit2;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 x,y:integer;
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,0);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'p.png',Mybrush,false);
 CreateTex:=GLE.CreateImage(Panel1.ClientWidth,Panel1.ClientHeight);
 pod:=GLE.CreateImage(Panel1.ClientWidth,Panel1.ClientHeight);
 GLE.Resize(Panel1.ClientWidth,Panel1.ClientHeight);

 gle.BeginRenderToTex(pod,Panel1.ClientWidth,Panel1.ClientHeight);
 Gle.SetColor(1,1,1,1);
 Gle.Bar(0,0,Panel1.ClientWidth,Panel1.ClientHeight);
 Gle.SetColor(0.3,0.3,0.3,0.3);
 for x:=0 to Panel1.ClientWidth div 10 do
  for y:=0 to Panel1.ClientHeight div 10 do
   if (x+y) mod 2 = 0 then
    Gle.Bar(x*10,y*10,x*10+10,y*10+10);
 gle.EndRenderToTex;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Gle.BeginRender(true);
 Gle.SetColor(1,1,1,1);
 Gle.DrawImage(0,0,Panel1.ClientWidth,Panel1.ClientHeight,0,false,false,pod);
 Gle.DrawImage(0,0,Panel1.ClientWidth,Panel1.ClientHeight,0,false,false,CreateTex);
 Gle.FinishRender;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Gle.FreeImage(pod);
 Gle.FreeImage(CreateTex);
 Gle.Free;
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Button  in [mbLeft] then
  down:=true;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  down:=false;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if down then
  begin

  Gle.BeginRender(false);
   case Form2.RadioGroup1.ItemIndex of
   0:   gle.SwichBlendMode(bmAdd2);
   1:   gle.SwichBlendMode(bmSrc2Dst);
   2:   gle.SwichBlendMode(bmMultiply);
   3:   gle.SwichBlendMode(bmAddMul);
   4:   gle.SwichBlendMode(bmAdd);
   5:   gle.SwichBlendMode(bmNormal);
   6:   gle.SwichBlendMode($0300,$0307);
  end;
    gle.BeginRenderToTex(CreateTex,Panel1.ClientWidth,Panel1.ClientHeight);
     gle.SetColor(Form2.RColor.Position/255,Form2.GColor.Position/255,Form2.BColor.Position/255,Form2.AColor.Position/255);
     gle.DrawImage(x,y,Form2.BrushSize.Position,Form2.BrushSize.Position,0,true,false,MyBrush);

    gle.EndRenderToTex;
     gle.SwichBlendMode(bmNormal);
  Gle.SetColor(1,1,1,1);
 Gle.DrawImage(0,0,Panel1.ClientWidth,Panel1.ClientHeight,0,false,false,pod);
 Gle.DrawImage(0,0,Panel1.ClientWidth,Panel1.ClientHeight,0,false,false,CreateTex);
   gle.FinishRender;
 //    form1.Timer1Timer(nil);
//     form1.Caption:=form1.Caption+'!';
  end
  else
   begin
      Gle.BeginRender(false);

  Gle.SetColor(1,1,1,1);
 Gle.DrawImage(0,0,Panel1.ClientWidth,Panel1.ClientHeight,0,false,false,pod);
 Gle.DrawImage(0,0,Panel1.ClientWidth,Panel1.ClientHeight,0,false,false,CreateTex);
 gle.SetColor(0.5,0.5,0.5,0.8);
 gle.SetFill(glLine);
 gle.Ellipse(x,y,Form2.BrushSize.Position/2,Form2.BrushSize.Position/2,0.01,0,32);
  gle.SetFill(glFill);
   gle.FinishRender;
   end;
end;

end.
