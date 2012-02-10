unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,GlEngine;
type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
   bitmap32: TBitMap;
    { Private declarations }
  public
   Procedure Render;
    { Public declarations }
  end;

  Const
   ThreadLength = 50;
   MaxThreads = 50;

type
    TVertex = Record
       X, Y : single;
     end;


var
  Form1: TForm1;
  GLE:TGLEngine;
  RndVal:single=0.4;
  ThreadsArray : Array[0..MaxThreads, 0..ThreadLength] of TVertex;
  Rnd     : Array[0..MaxThreads] of TVertex;
  dt,mx,my:single;
  im:cardinal;
  w:integer;
  h:integer;
  rect:Trect;
    zbf:TBlendFunction;
      ToBmp:Cardinal;
      DC:HDC;
implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.Render;
var
 zsize:TSize; zpoint:TPoint;
 TopLeft: TPoint;

  i,j:integer;
  P : TVertex;
   lx,ly:single;
begin
 gle.BeginRenderToTex(ToBmp,w,h);
 //gle.Clear;
 dt:=dt+0.1;
 P.X := mX-Screen.Width/2;       // mouse X
 P.Y := my-Screen.Height/2;      // mouse Y

  For I := 0 to MaxThreads do
    ThreadsArray[I, 0] := P ;
  For J := 0 to MaxThreads do
  begin
    For I := ThreadLength downto 1 do
    begin
      ThreadsArray[J, I].X :=  (ThreadsArray[J,I-1].X*2+ThreadsArray[J,I].X)/2.99 + Rnd[J].X*RndVal*sin(dt)*2;
      ThreadsArray[J, I].Y := (ThreadsArray[J,I-1].Y*2+ThreadsArray[J,I].Y)/2.99 + Rnd[J].Y*RndVal*cos(dt)*2;
    end;
 end;


// gle.SwichBlendMode(bmAdd);
 gle.SwichBlendMode(bmNormal);
 gle.SetCurrentImage(im);
  For I := 0 to MaxThreads-1 do
  begin
   lx:=mX-Screen.Width/2;
   ly:=my-Screen.Height/2;
// gle.SetColor({sin(i)+random/10} 1-cos(dt/i), sin(dt/i), cos(dt)+random/10,0.1);
      For J := 0 to ThreadLength do
      begin

     { if i>0 then
       begin
        ThreadsArray[J, ThreadLength-I].X :=  (ThreadsArray[J,ThreadLength-I-1].X*2+ThreadsArray[J,ThreadLength-I].X)/2.99 + Rnd[J].X*RndVal*sin(dt)*2;
        ThreadsArray[J, ThreadLength-I].Y := (ThreadsArray[J,ThreadLength-I-1].Y*2+ThreadsArray[J,ThreadLength-I].Y)/2.99 + Rnd[J].Y*RndVal*cos(dt)*2;
       end;  }

       gle.SetColor({sin(i)+random/10} 1-cos(dt/i), sin(dt/j), cos(dt)+random/10,0.1);
      // gle.SetColor({sin(i)+random/10} 1,1,1,1);
   //  gle.SetColor(sin(j)+0.5, cos(i),0 ,0.3);
         gle.DrawCurrentImage(ThreadsArray[I, J].X+Screen.Width/2,ThreadsArray[I, J].Y+Screen.Height/2,20,20,0,true,false);
        //  gle.DrawImage(ThreadsArray[I, J].X+Screen.Width/2,ThreadsArray[I, J].Y+Screen.Height/2,20,20,0,true,false,im);
     // gle.SetColor(1-sin(j)+0.5, 1-cos(i),0 ,0.3);

        //  gle.Line(lx+Panel1.ClientWidth/2,ly+Panel1.ClientHeight/2,ThreadsArray[I, J].X+Panel1.ClientWidth/2,ThreadsArray[I, J].Y+Panel1.ClientHeight/2);

       lx:=ThreadsArray[I, J].X;
       ly:=ThreadsArray[I, J].Y
      end;

  end;
 gle.SetCurrentImage(0);
 gle.SwichBlendMode(bmNormal);
 gle.SetColor(0,0,0,0.05);
 gle.Bar(0,0,screen.Width,screen.Height);

  // делаем пустую точку, что бы работала мышка
   gle.SwichBlendMode(bmMultiply);
   gle.SetColor(0,0,0,0);
   gle.PointSize(2);
   gle.Point(mx,my);
   gle.SwichBlendMode(BMNormal);

 gle.EndRenderToTex;
 gle.GetBMP32FromImage(ToBmp,bitmap32);
 zsize.cx := bitmap32.Width;
 zsize.cy := bitmap32.Height;
 zpoint := Point(0,0);
 TopLeft:=BoundsRect.TopLeft;
 if (mouse.CursorPos.X=0)and(mouse.CursorPos.y=0) then
  application.Terminate;
 UpdateLayeredWindow(Handle,DC,@TopLeft,@zsize,bitmap32.Canvas.Handle,@zpoint,0,@zbf, ULW_ALPHA);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 mx:=mouse.CursorPos.x;
 my:=mouse.CursorPos.y;
 Render;
 application.ProcessMessages;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 bitmap32.Free;
 ReleaseDC(self.Handle, DC);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 i:integer;
begin
 w:=screen.Width;
 h:=screen.Height;
 randomize;

 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),screen.Width,screen.Height,0);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'p.png',im,false);
 ToBmp:=gle.CreateImage(w,h);
 Randomize;
  For I := 0 to MaxThreads do
  begin
    Rnd[I].X := (Random(200)-100)/10;
    Rnd[I].Y := (Random(200)-100)/10;
  end;

 with zbf do begin
   BlendOp := AC_SRC_OVER;
   BlendFlags := 0;
   AlphaFormat := AC_SRC_ALPHA;
   SourceConstantAlpha := 255;
  end;

  bitmap32:=TBitMap.Create;
  bitmap32.PixelFormat:=pf32bit;

 timer1.Enabled:=true;
 randomize;
 self.Top:=0;
  self.Left:=0;

 SetWindowLong(Handle,GWL_EXSTYLE, GetWindowLong(Handle,GWL_EXSTYLE) or WS_EX_LAYERED);
end;

end.
