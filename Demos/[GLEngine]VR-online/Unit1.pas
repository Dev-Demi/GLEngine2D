unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,GLEngine;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Memo1: TMemo;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
    
  TSPoint=record
   x,y:single;
  end;

  TPart=Class(tobject)
   pos:TSpoint;
   VecMove:TSpoint;
   color:TGLColor;

   sizep:single;
   Caption:string;
   ds,smax,smin:single;
   constructor Create;
   Procedure Move;
   Function FindRound:TPart;
   procedure Draw;
   destructor Free;
  end;

 var
  Form1: TForm1;
  GLE:TGLEngine;
  im:Cardinal;
  Parts:TList;
  dy:integer=25;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 i:integer;
 o:TPart;
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,4);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'p.png',im,false);
 Parts:=TList.Create;
 gle.SetTextStyle('Arial',15);

 for i:=0 to 200 do
  begin
   o:=TPart.Create;
   Parts.Add(o);
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 i:integer;

   o:TPart;

begin
 gle.BeginRender(false);
 gle.AntiAlias(true);
 gle.SetColor(0,0,0,0);
 gle.Bar(0,0,1024,768);
  gle.SwichBlendMode(bmAdd);
 for i:=0 to Parts.Count-1 do
  begin
   o:= TPart(Parts[i]);
   o.Move;
   o.Draw;
  end;
   gle.SwichBlendMode(BMNormal);
 gle.SetColor(0,0,0,0.1);
 gle.Bar(0,0,Panel1.Width,Panel1.Height);
 gle.FinishRender;
end;
{ TPart }

constructor TPart.Create;
begin
 pos.x:=random(Form1.Panel1.Width);
 pos.y:=random(Form1.Panel1.Height);
 VecMove.x:=(0.5-random)*2;
 VecMove.y:=(-0.5+random)*2;

 smin:= 30+random(50);
 smax:= 81+ 100*random;
 if random<0.2 then
 begin
  Caption:=Form1.Memo1.Lines[RanDom(Form1.Memo1.Lines.count)];
  color:=gle.ColorGL(224/256,102/256,40/256,1);
 end
 else
 begin
  color:=gle.ColorGL(224/256,102/256,40/256,0.1);
  smin:= 10+random(10);
  smax:= smin;
 end;
 ds:=4-random*2;
 sizep:=(smin+smax)/2;
end;

procedure TPart.Draw;
var
 nearp:TPart;
 i:integer;
begin
 sizep:=sizep+ds;
 gle.SwichBlendMode(bmAdd);
 if (sizep>smax) or (sizep<smin) then ds:=-ds;
 gle.SetColor(Color.Red,color.Green,color.Blue,0.1);
 gle.DrawImage(pos.x,pos.y,sizep,sizep,0,true,false,im);
 if caption<>'' then
  for i:=1 to 3 do
   gle.DrawImage(pos.x+random(3)-6,pos.y+random(3)-6,2*sizep/i,2*sizep/i,0,true,false,im);
  gle.SwichBlendMode(bmNormal);
  gle.SetColor(0,0,0,1);
  gle.TextOut(Pos.x-1,pos.y-1,Caption);
  gle.SetColor(0,0,0,1);
  gle.TextOut(Pos.x+1,pos.y+1,Caption);
 gle.SetColor(1,1,1,1);
 gle.TextOut(Pos.x,pos.y,Caption);
 gle.SetColor(1,1,1,1);
 nearp:= FindRound;
 if nearp<>nil then
 if caption<>'' then
  gle.Line(pos.x,pos.y,nearp.pos.x,nearp.pos.y);
// gle.Ellipse(pos.x,pos.y,size/4,size/4,0,20);
end;

function TPart.FindRound: TPart;
var
 i:integer;
 min,d:single;
 o:Tpart;
begin
 min:=10000;
 for i:=0 to Parts.Count-1 do
  begin
   o:=TPart(Parts.Items[i]);
   d:=SQRT(sqr(o.pos.x-pos.x)+sqr(o.pos.y-pos.y));
   if (d<min)and(d>5)and(o.Caption<>'') then
   begin
    min:=SQRT(sqr(o.pos.x-pos.x)+sqr(o.pos.y-pos.y));
    result:=o;
   end;
  end;
end;

destructor TPart.Free;
begin

end;

procedure TPart.Move;
begin
  pos.x:=pos.x+VecMove.x;
 pos.y:=pos.y+VecMove.y;

 if (pos.x<=0)or(pos.x>=Form1.Panel1.ClientWidth) then VecMove.x:=-VecMove.x;
 if (pos.y<=0)or(pos.y>=Form1.Panel1.ClientHeight) then VecMove.y:=-VecMove.y;

end;

procedure TForm1.FormResize(Sender: TObject);
begin
 gle.Resize(Panel1.Width,Panel1.Height);
end;

end.
