unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,GLEngine, Spin;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    PaintBox1: TPaintBox;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GLE:TGLEngine;
  QW:int64;
  TimeDraw,ClockRate:double;
  StartDrawTime,EndDrawTime:Int64;
  Im1,im2:cardinal;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel2.Handle),Panel2.ClientWidth,Panel2.ClientHeight,0);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'b.png',Im1,false);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'z.tga',Im2,false);
 QueryPerformanceFrequency(QW);
 ClockRate:=qw;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
 i:Integer;
begin
 gle.BeginRender(true);
 for i:=1 to SpinEdit1.Value do
 begin
  case RadioGroup1.ItemIndex of
   0:begin
      gle.SetColor(random,random,random,random);
      gle.Line(random(200),random(200),random(200),random(200));
     end;
   1:begin
      gle.SetColor(random,random,random,1);
      gle.Bar(random(200),random(200),random(200),random(200));
     end;
   2:begin
      gle.SetColor(random,random,random,1);
      gle.Ellipse(random(200),random(200),random(50),random(50),1,0,16);
     end;
   3:begin
      gle.SetColor(random,random,random,1);
      gle.TextOut(random(200),random(200),'Hello world!');
     end;
   end;
 end;
 gle.FinishRender;
// TimeDraw:=1000.0 * (EndDrawTime - StartDrawTime) / ClockRate;
 Label2.Caption:='TGLEngine - '+FloatToStrF(gle.GetTimeDrawFrame,ffFixed,5,3)+' мс';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 i:Integer;
begin

 SetBkMode(PaintBox1.Canvas.Handle, TRANSPARENT);

 QueryPerformanceCounter(StartDrawTime);
 for i:=1 to SpinEdit1.Value do
 begin
 case RadioGroup1.ItemIndex of
   0:begin
      PaintBox1.Canvas.Pen.Color:=RGB(Random(255),Random(255),Random(255));
      PaintBox1.Canvas.MoveTo(Random(200),Random(200));
      PaintBox1.Canvas.LineTo(Random(200),Random(200));
     end;
   1:begin
      PaintBox1.Canvas.Brush.Color:=RGB(Random(255),Random(255),Random(255));
      PaintBox1.Canvas.FillRect(Rect(random(200),random(200),random(200),random(200)));
     end;
   2:begin
      PaintBox1.Canvas.Brush.Color:=RGB(Random(255),Random(255),Random(255));
      PaintBox1.Canvas.Pen.Color:= PaintBox1.Canvas.Brush.Color;
      PaintBox1.Canvas.Ellipse(Rect(random(200),random(200),random(200),random(200)));
     end;
   3:begin
      PaintBox1.Canvas.Font.Color:=RGB(Random(255),Random(255),Random(255));
      PaintBox1.Canvas.TextOut(random(200),random(200),'Hello world!');
     end;
   end;
 end;
 QueryPerformanceCounter(EndDrawTime);
 TimeDraw:=1000.0 * (EndDrawTime - StartDrawTime) / ClockRate;
 Label1.Caption:='TCanvas - '+FloatToStrF(TimeDraw,ffFixed,5,3)+' мс';
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 i:integer;
begin
 gle.BeginRender(true);
 for i:=1 to SpinEdit1.Value do
 begin
  gle.DrawImage(random(200),random(200),random(200),random(200),0,true,false,im1);
//  gle.DrawImage(random(200),random(200),random(200),random(200),0,true,false,im2);
 end;
 gle.FinishRender;
 Label2.Caption:='TGLEngine - '+FloatToStrF(gle.GetTimeDrawFrame,ffFixed,5,3)+' мс';
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 i:integer;
begin
 gle.BeginRender(true);

 gle.SetCurrentImage(im1);
 for i:=1 to SpinEdit1.Value do
 begin
  gle.DrawCurrentImage(random(200),random(200),random(200),random(200),0,true,false);
 end;

{ gle.SetCurrentImage(im2);
 for i:=1 to SpinEdit1.Value do
 begin
  gle.DrawCurrentImage(random(200),random(200),random(200),random(200),0,true,false);
 end;  }
 gle.SetCurrentImage(0);

 gle.FinishRender;
 Label2.Caption:='TGLEngine - '+FloatToStrF(gle.GetTimeDrawFrame,ffFixed,5,3)+' мс';
end;

procedure TForm1.Button5Click(Sender: TObject);
 var
 i:integer;
begin
 gle.BeginRender(true);

 gle.SetCurrentImage(im1);
 for i:=1 to SpinEdit1.Value do
 begin
  gle.DrawCurrentImage2(random(200),random(200),random(200),random(200),0,true,false);
 end;

// gle.SetCurrentImage(0);

 gle.FinishRender;
 Label2.Caption:='TGLEngine - '+FloatToStrF(gle.GetTimeDrawFrame,ffFixed,5,3)+' мс';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 gle.VisualDone;
 gle.Free;
end;

end.
