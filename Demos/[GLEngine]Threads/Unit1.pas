unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,GLEngine;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Panel2: TPanel;
    NodeCheck: TCheckBox;
    LineCheck: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1Resize(Sender: TObject);
  private
    { Private declarations }
  public
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
  rect:Trect;

 implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 i:integer;

begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,4);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'p.png',im,false);
 gle.SetTextStyle('Arial',15);
 Randomize;
  For I := 0 to MaxThreads do
  begin
    Rnd[I].X := (Random(200)-100)/10;
    Rnd[I].Y := (Random(200)-100)/10;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 i,j:integer;
  P : TVertex;
   lx,ly:single;
begin
   dt:=dt+0.1;
  P.X := mX-Panel1.ClientWidth/2;       // mouse X
  P.Y := my-Panel1.ClientHeight/2;      // mouse Y

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

 gle.BeginRender(false);
 gle.AntiAlias(true);
 gle.SwichBlendMode(bmAdd);

  For I := 0 to MaxThreads-1 do
  begin
   lx:=mX-Panel1.ClientWidth/2;
   ly:=my-Panel1.ClientHeight/2;
// gle.SetColor({sin(i)+random/10} 1-cos(dt/i), sin(dt/i), cos(dt)+random/10,0.1);
      For J := 0 to ThreadLength do
      begin
       gle.SetColor({sin(i)+random/10} 1-cos(dt/i), sin(dt/j), cos(dt)+random/10,0.1);
   //  gle.SetColor(sin(j)+0.5, cos(i),0 ,0.3);
      if NodeCheck.Checked then
          gle.DrawImage(ThreadsArray[I, J].X+Panel1.ClientWidth/2,ThreadsArray[I, J].Y+Panel1.ClientHeight/2,20,20,0,true,false,im);
     // gle.SetColor(1-sin(j)+0.5, 1-cos(i),0 ,0.3);
      if LineCheck.Checked then
          gle.Line(lx+Panel1.ClientWidth/2,ly+Panel1.ClientHeight/2,ThreadsArray[I, J].X+Panel1.ClientWidth/2,ThreadsArray[I, J].Y+Panel1.ClientHeight/2);

       lx:=ThreadsArray[I, J].X;
       ly:=ThreadsArray[I, J].Y
      end;

  end;
 gle.SwichBlendMode(BMNormal);
 gle.SetColor(0,0,0,0.1);
 gle.Bar(0,0,Panel1.Width,Panel1.Height);
 gle.FinishRender;

end;
procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 mx:=x;my:=y;
end;

procedure TForm1.Panel1Resize(Sender: TObject);
begin
  gle.Resize(panel1.Width,panel1.Height);
end;

end.
