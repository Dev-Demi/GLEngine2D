unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,GLEngine, ExtCtrls, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    Procedure Render;
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GLE:TGLEngine;
  imAll,im,PNG,back,CreateTex,grass,d:Cardinal;
  aminBoom,aminBoomPlus:TGLAnim;
//  gif:TGLGifAnim;
  x,y,dx,dy:integer;
  FontIm:Cardinal;
  TestArray,TestArrayTes : array of TGLPoint;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin

 SetLength(TestArray, 11);
 SetLength(TestArrayTes, 11);



 // Создаём движёк
 GLE:=TGLEngine.Create;
 //
 //             Инициализируем графику
 //
 //             на чём будем рисовать | ширина полотна     | высота полотна      | качество сглаживания
 GLE.VisualInit(GetDC(Panel1.Handle)  , Panel1.ClientWidth , Panel1.ClientHeight , StrToInt(ComboBox1.Text));
 // Загружаем изображения

// GLE.LoadImage('e:\d.png',d,false);

 GLE.LoadImage(ExtractFilePath(application.ExeName)+'0.tga',im,false);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'1.png',png,false);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'back.jpg',back,false);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'back.jpg',imAll,false);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'tile1.jpg',grass,false);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'..\..\fonts\Courier New Bold.png',FontIm,false);
 GLE.LoadAnimation(ExtractFilePath(Application.ExeName)+'e.tga',256,256,64,64,aminBoom,false);
// GLE.LoadGifAnimation(ExtractFilePath(Application.ExeName)+'4.gif',gif);
 aminBoomPlus:=aminBoom;
 // Создаём чистое изображение
 CreateTex:=GLE.CreateImage(200,100);

//gle.BeginRenderToTex(imAll,Panel1.ClientWidth,panel1.ClientHeight);
//gle.DrawImage(0,0,panel1.ClientWidth,Panel1.ClientHeight,0,false,back);
//gle.EndRenderToTex;

 Timer1.Enabled:=true;
 dx:=10;
 dy:=10;
 x:=0;
 y:=0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Timer1.Enabled:=false;
  GLE.FreeImage(im);
  GLE.FreeImage(aminBoom.tex);
  GLE.VisualDone;
  GLE.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 render
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
 Timer1.Interval:=TrackBar1.Position;
 Label1.Caption:=Inttostr(TrackBar1.Position);
end;

procedure TForm1.Render;
var
 i:integer;
begin
 // начало рисования
 GLE.BeginRender(true);
 // включаем или выключаем сглаживание
 GLE.AntiAlias(CheckBox1.Checked);
 // устанавливаем текущий цвет рисования
 gle.SetColor(1,1,1,1);
 // указываем, что начинаем рисовать в изображение imAll
 gle.BeginRenderToTex(imAll,Panel1.ClientWidth,panel1.ClientHeight);
 GLE.DrawImage(0,0,Panel1.ClientWidth,panel1.ClientHeight,0,false,false,back);

 For i:=1 to 20 do
 begin
  GLE.SetColor(random,random,random,random);
  gle.PointSize(i);
  gle.PointSmooth((i mod 2)=0);
  GLE.Point(20,i*20);
 end ;

 GLE.SetLineStripple(1, '----    ----    ');
 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.LineWidth(i);

  if i=5 then
   gle.UnSetLineStripple;
  GlE.Line(40,i*20,80,i*20);

 end;

 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.LineWidth(i);
  GlE.LineGrad(40,200+i*20,80,200+i*20,gle.ColorGL(Random,0,0,1),gle.ColorGL(0,0,random,1));
 end;

 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.LineWidth(i);
  GLE.Triangle(100+Random(100),20+Random(100),100+Random(100),20+Random(100),100+Random(100),20+Random(100));
 end;

 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.TriangleGrad(100+Random(100),120+Random(100),100+Random(100),120+Random(100),100+Random(100),120+Random(100),gle.ColorGL(random,0,0,random),gle.ColorGL(0,random,0,random),gle.ColorGL(0,0,random,random));
 end;

 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.Bar(310+Random(100),20+Random(100),310+Random(100),20+Random(100));
 end;

 GLE.LineWidth(1);
 For i:=1 to 50 do
 begin
  GLE.SetColor(0,0,1,random);
  GLE.Bolt(450,70,410+Random(100),20+Random(100));
 end;
 GLE.LineWidth(1);
 GLE.SetColor(1,1,1,0.8);
 GLE.Bolt(410,50,510,150);

 GLE.LineWidth(1);
 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.Arrow(560,70,510+Random(100),20+Random(100),15,15,true);
 end;

 For i:=1 to 10 do
 begin
  GLE.SetColor(random,random,random,random);
  GLE.Ellipse(310+Random(100),120+Random(100),Random(50),Random(50),Random(10)/10,Random(180),Random(30));
 end;
 GLE.SetColor(1,1,1,1);
 GLE.TextOut(250,10,'TGA');
 For i:=1 to 10 do
 begin
  GLE.SetColor(1,1,1,i/10);
  GLE.DrawImage(250,i*40,50,50,i*10,true,false,im);
 end;

  GLE.LineWidth(1);

 For i:=1 to 10 do
 begin
   GLE.SetColor(random,random,random,random);
   GLE.TextOut(100+random(100),220+random(100),'время - '+TimeToStr(Time),Random(180));
 end;

 gle.SetColor(1,1,1,1);
 gle.DrawAniFrame(350,320,0,aminBoom);
 gle.SetColor(1,0,1,0.9);
 gle.DrawAniFrame(350,390,90,aminBoomPlus);
 gle.SetColor(1,1,1,1);

 gle.DrawImage(450,250,100,100,0,false,false,png);
 GLE.TextOut(450,250,'PNG');

// GLE.DrawGifFrame(450,350,0,gif);

 GLE.TextOut(100,10,'FPS - '+IntToStr(GLE.GetFPS));
 gle.EndRenderToTex;
  gle.SetColor(1,1,1,1);
 GLE.DrawImage(0,0,Panel1.ClientWidth,panel1.ClientHeight,0,false,false,imAll);

 gle.SetColor(1,1,1,0.3);
 Gle.DrawImage(550,275,50,25,0,false,false,imAll);

 gle.SetColor(1,1,1,0.6);
 Gle.DrawImage(550,300,100,50,0,false,false,imAll);

 gle.SetColor(1,1,1,0.9);
 Gle.DrawImage(550,350,200,100,0,false,false,imAll);

 gle.SetColor(1,0,0,1);
 
 Gle.Rectangle(550,350,750,450);

 gle.SetFill(glLine);
 gle.Bar(560,360,740,440);
 gle.SetFill(glFill);

 // Blur эффект
 gle.BeginRenderToTex(CreateTex,200,100);
  gle.SetColor(0.1,0.1,0.1,0.1);
//  gle.DrawImage(0,0,Panel1.ClientWidth,panel1.ClientHeight,0,false,CreateTex);
  gle.Bar(0,0,Panel1.ClientWidth,panel1.ClientHeight);
  gle.PointSize(10);
  gle.PointSmooth(true);
  gle.SetColor(x/Panel1.ClientWidth,y/panel1.ClientHeight,1,1);
  GLE.Point(x,y);
  x:=x+dx;
  y:=y+dy;
   if (x<=0) or(x>=Panel1.ClientWidth) then dx:=-dx;
   if (y<=0) or(y>=Panel1.ClientHeight) then dy:=-dy;



 gle.EndRenderToTex;

 gle.SetColor(1,1,1,1);
 gle.DrawImage(560,20,200,100,0,false,false,CreateTex);
 GLE.TextOut(560,10,'Blur');
 gle.SetColor(1,0,0,1);
 Gle.Rectangle(560,20,760,120);

 gle.SetColor(1,1,1,1);
 GLE.TextOut(560,140,'Tile');
 gle.SetColor(1,1,1,0.8);
 Gle.DrawTileImage(560,140,120,120,2,2,0,grass);

  gle.SetColor(0,0,0,1);
 Gle.TextOutUseImageFont(12,12,'Текстурный шрифт под углом'+#13+'Вторая строка',FontIm,x/10,24,24);
  gle.SetColor(1,1,1,0.9);
 Gle.TextOutUseImageFont(10,10,'Текстурный шрифт под углом'+#13+'Вторая строка',FontIm,x/10,24,24);

 for i:=0 to 10 do
 begin
  TestArray[i].x:=Random*50;
  TestArray[i].y:=Random*50;
 end;

 GLE.TextOut(450,370,'polygon');
 gle.SetColor(1,0,0,1);
 //gle.Polygon(450,380,0,TestArray);

 gle.PolygonTess(450,380,0,TestArray);

// gle.Tesselate(TestArray,TestArrayTes);

 // gle.PolygonFromArray(480,380,0,TestArrayTes);

 GLE.FinishRender;
end;

procedure TForm1.Panel1Resize(Sender: TObject);
begin
if gle<>nil then
 gle.Resize(Panel1.Width,Panel1.Height);
end;

end.


