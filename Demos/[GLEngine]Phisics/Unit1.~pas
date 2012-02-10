unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,GlEngine, StdCtrls, ExtCtrls,Chipmunk;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  pglColor=^TGLColor;

var
  Form1: TForm1;
  GLE:TGLEngine=nil;
  d,dx:real;

  space  : PcpSpace;
  bCount : Integer;
  Bodies : array of PcpBody;
  Shapes : array of PcpShape;
  pColor:pglColor;

implementation

{$R *.dfm}

procedure cpAddBall( x, y, r, mass, e, u,vx,vy : cpFloat );
var
 v,r0:cpVect;
begin
  INC( bCount );
  SetLength( Bodies, bCount );
  SetLength( Shapes, bCount );

  Bodies[ bCount - 1 ]   := cpBodyNew( mass, cpMomentForCircle( mass, 0, r, cpvzero ) );
  Bodies[ bCount - 1 ].p := cpv( x, y );
  cpSpaceAddBody( space, Bodies[ bCount - 1 ] );

  Shapes[ bCount - 1 ]   := cpCircleShapeNew( Bodies[ bCount - 1 ], r, cpvzero );
  Shapes[ bCount - 1 ].e := e;
  Shapes[ bCount - 1 ].u := u;

  New(pColor);
  pColor^:= gle.ColorGL(Random/2+0.5,Random/2+0.5,Random/2+0.5,Random/4+0.5);

  Shapes[ bCount - 1 ].data:=pColor;

  cpSpaceAddShape( space, Shapes[ bCount - 1 ] );
  r0.x:=0;
  r0.y:=0;
  v.x:=vx;
  v.y:=vy;
//  v.y:=5-random(10);
//  r0.y:=10;
 cpBodyApplyImpulse( Bodies[ bCount - 1 ],v,r0);
//  cpBodyApplyForce( Bodies[ bCount - 1 ],v,r0);
end;

procedure cpAddBox( x, y, w, h, mass, e, u : cpFloat );
  var
    points : array[ 0..3 ] of cpVect;
    f      : cpFloat;
begin
  INC( bCount );
  SetLength( Bodies, bCount );
  SetLength( Shapes, bCount );

  points[ 0 ].x := - w / 2;
  points[ 0 ].y := - h / 2;
  points[ 1 ].x := - w / 2;
  points[ 1 ].y := h / 2;
  points[ 2 ].x := w / 2;
  points[ 2 ].y := h / 2;
  points[ 3 ].x := w / 2;
  points[ 3 ].y := - h / 2;

  f := cpMomentForPoly( mass, 4, @points[ 0 ], cpvzero );
  Bodies[ bCount - 1 ]   := cpBodyNew( mass, f );
  Bodies[ bCount - 1 ].p := cpv( x + w / 2, y + h / 2 );
  cpSpaceAddBody( space, Bodies[ bCount - 1 ] );

  Shapes[ bCount - 1 ]   := cpPolyShapeNew( Bodies[ bCount - 1 ], 4, @points[ 0 ], cpvzero );
  Shapes[ bCount - 1 ].e := e;
  Shapes[ bCount - 1 ].u := u;
  cpSpaceAddShape( space, Shapes[ bCount - 1 ] );
end;



procedure TForm1.FormCreate(Sender: TObject);
 var
    staticBody : PcpBody;
    ground     : PcpShape;
    e, u       : cpFloat;
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,2);
 GLE.SwichBlendMode(bmAdd);
// GLE.SetFill(glLine);
/////////////////////////////////////////////////
 cpLoad( libChipmunk );

 cpInitChipmunk();
  SetGlEngine(GLE);

  // RU: Создаем новый "мир".
  // EN: Create new world.
  space            := cpSpaceNew();
  // RU: Задаем количество итераций обработки(рекомендуется 10).
  // EN: Set count of iterations of processing(recommended is 10).
  space.iterations := 10;
  space.elasticIterations := 10;
  // RU: Задаем силу гравитации.
  // EN: Set the gravity.
  space.gravity    := cpv( 1, 50 );
  // RU: Задаем коэффициент "затухания" движения объектов.
  // EN: Set the damping for moving of objects.
  space.damping    := 0.99;

  e := 1;
  u := 0.9;
  // RU: Создадим статичное "тело".
  staticBody := cpBodyNew( INFINITY, INFINITY );
  // RU: Добавим три отрезка для ограничения мира.
  // Первый параметр - указатель на созданное тело, два последующих - координаты точек отрезка, последний - толщина отрезка.
  //
  // EN: Add three segments for restriction of world.
  // First parameter - pointer of created body, next two - coordinates of segment points, the last one - width of segment.

  ground := cpSegmentShapeNew( staticBody, cpv( 5, 5 ), cpv( 795, 5 ), 1 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );

  ground := cpSegmentShapeNew( staticBody, cpv( 5, 0 ), cpv( 5, 590 ), 1 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );
  ground := cpSegmentShapeNew( staticBody, cpv( 795, 0 ), cpv( 795, 590 ), 1 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );
  ground := cpSegmentShapeNew( staticBody, cpv( 0, 590 ), cpv( 800, 590 ), 10 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );
  // RU: Добавим треугольник.
  // EN: Add the triangle.
 { staticBody := cpBodyNew( INFINITY, INFINITY );
  ground := cpSegmentShapeNew( staticBody, cpv( 400, 300 ), cpv( 200, 350 ), 1 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );
  ground := cpSegmentShapeNew( staticBody, cpv( 200, 350 ), cpv( 700, 350 ), 1 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );
  ground := cpSegmentShapeNew( staticBody, cpv( 700, 350 ), cpv( 400, 300 ), 1 );
  ground.e := e;
  ground.u := u;
  cpSpaceAddStaticShape( space, ground );   }
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

 GLE.BeginRender(true);
 gle.SetColor(1,1,1,1);
 cpDrawSpace(space,false);
 GLE.FinishRender;
 Form1.Caption:='FPS - '+FloatToStr(GLE.GetFPS);
 d:=d+dx;
 if (d<=0)or(d>=1) then
  dx:=-dx;
 cpSpaceStep( space, 1/50 );
// cpAddBall(50+random(6)-12,350+random(6)-12,4,10,0.1,0.1,300);
// cpAddBall(650+random(6)-12,350+random(6)-12,4,1,0.1,0.1,-200);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   cpSpaceFreeChildren( space );
  cpSpaceFree( space );
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button in [mbLeft] Then
    cpAddBox( x - 10, y - 10, 48, 32, 1, 0.5, 0.5 );
  if Button in [mbRight] Then
    cpAddBall( x, y, 20, 10, 0.9, 0.9,0,-5000 );
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 i,j,k:integer;
begin
 k:=6;
 Timer1.Enabled:=false;
 for j:= 1 to 30 do
  for i:=300 div k to (panel1.Width-300) div k do
  begin
   cpAddBall(i*k,50+j*k,3,random,0.99,0.99,0,0);
//   cpAddBall(50+random(6)-12,50+random(6)-12,2,1,0.5,0.5,0);
  end;
 //  cpAddBox(350+random(6)-12,350+random(6)-12,10,12,1,0.5,0.5);
 Timer1.Enabled:=true;   
end;

end.
