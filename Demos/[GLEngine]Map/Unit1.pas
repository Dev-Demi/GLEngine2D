unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,GLEngine, ExtCtrls, StdCtrls, sEdit, sSpinEdit, sButton,PathFind,
  Buttons;

 const
   SizeMap=100;
   
type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Panel2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  TMap=Class
   private
    nx,kx,ny,ky:integer;
    fdata:array[0..SizeMap,0..SizeMap]of integer;
   public
    TileCountX,TileCountY:integer;
   Constructor Create;
   procedure draw;
   procedure Zoom(kx,ky:integer);
   Procedure Move(dx,dy:integer);
   Function GetPath(x,y,tox,toy:integer):TPath;
  end;

var
  Form1: TForm1;
  gle:TGLEngine;
  map:Tmap;
  imTr,imSt:Cardinal;

  mx,my:integer;
  drag:boolean=false;

  Path : TPath;
  FPathMap:TPathMap;

  function MovingCost(X,Y,Direction : Integer) : Integer;
implementation

{$R *.dfm}

function MovingCost(X,Y,Direction : Integer) : Integer;
begin
 if map.fdata[y,x]=0 then
  Result:=2
 else
  Result:=-1
{  Result:=TerrainParams[Form1.FData[Y,X].TerrainType].MoveCost;
  if ((Direction AND 1) = 1) AND (Result > 0)
  then
    Result:=Result+(Result SHR 1); }
end;

{ TMap }

constructor TMap.Create;
var
 i,j:integer;
begin
 nx:=0;   ny:=0;
 TileCountX:=50;
 TileCountY:=50;

 kx:=nx+TileCountX; ky:=ny+TileCountY;

 for i:=0 to SizeMap do
  for j:=0 to SizeMap do
  if random>0.7 then
   fdata[i,j]:=1
  else
   fdata[i,j]:=0
end;

procedure TMap.draw;
var
 i,j:integer;
 dx,dy,x,y:single;
begin

 kx:=nx+TileCountX;
 ky:=ny+TileCountY;

 x:=0;y:=0;

 if (nx<0) then
 begin
  nx:=0;
  kx:= nx+TileCountX;
 end;

 if (kx>=500) then
 begin
  nx:=SizeMap-TileCountX;
  kx:= SizeMap;
 end;

 if (ny<0) then
 begin
  ny:=0;
  ky:= ny+TileCountY;
 end;

 if (Ky>=SizeMap) then
 begin
  ny:=SizeMap-TileCountY;
  ky:= SizeMap;
 end;

 dx:=Form1.Panel1.ClientWidth/TileCountX;
 dy:=Form1.Panel1.ClientHeight/TileCountY;

 for i:=nx to kx do
 begin
  for j:=ny to ky do
  begin
   if fdata[i,j]=0 then
    gle.DrawImage(x,y,dx,dy,0,false,false,imtr)
   else
    gle.DrawImage(x,y,dx,dy,0,false,false,imst);
   y:=y+dy;
  end ;
  y:=0;
  x:=x+dx;
 end;

 /////////////////////////////////////////////
 ///             –исуем путь               ///
 /////////////////////////////////////////////

  gle.SetColor(1,0,0,0.5);
  if path <> NIL
  then
    for i:=0 to High(path) do
      begin       // "х" и "у" надо помен€ть 
       if (path[i].Y>=nx)and(path[i].Y<=kx)and(path[i].X>=ny)and(path[i].X<=ky) then
         gle.Bar(((path[i].Y-nx))*dx,((path[i].X-nY))*dy,((path[i].Y-nx))*dx+dx/2,((path[i].X-nY))*dy+dy/2);
      end;
  gle.SetColor(1,1,1,1);
end;

function TMap.GetPath(x, y, tox, toy: integer): TPath;
begin
 FPathMap:=MakePathMap(SizeMap,SizeMap,y,x,MovingCost);
 result:=FindPathOnMap(FPathMap,toy,tox);
end;

procedure TMap.Move(dx, dy: integer);
begin
 map.nx:=map.nx-dx;  map.kx:=map.kx-dx;
 map.ny:=map.ny-dy;  map.ky:=map.ky-dy;
end;

procedure TMap.Zoom(kx, ky: integer);
begin
  map.TileCountX:=map.TileCountX+kx;
  map.TileCountY:=map.TileCountY+ky;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 randomize;
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,0);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'tr.bmp',imTr,false);
 GLE.LoadImage(ExtractFilePath(application.ExeName)+'st.bmp',imSt,false);
 map:=Tmap.Create;
 Timer1.Enabled:=true;
 path:=nil;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 gle.BeginRender(true);
 gle.SetColor(1,1,1,1);
  map.draw;

 gle.SetColor(1,1,1,0.5);
 gle.Bar(0,0,100,100);
 gle.SetColor(0,0,1,0.7);
 gle.Bar(100*map.nx/SizeMap,100*map.ny/SizeMap,100*map.kx/SizeMap,100*map.ky/SizeMap);
 gle.FinishRender;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 dx,dy,dlx,dly,kx,ky:integer;
begin
 kx:=Round(Panel1.ClientWidth/ map.TileCountX);
 ky:=Round(Panel1.ClientHeight/map.TileCountY);

 if drag then
  begin
   dx:=x-mx;
   dy:=y-my;



    dlx:=Round(dx /kx);
    dly:=Round(dy /ky);

    if (ABS(dlx)>=1) or (ABS(dly)>=1) then
     begin
      mx:=x;my:=y;
     end;

   map.Move(dlx,dly);

  end
 else
 Path:= map.GetPath(3,3,Round(x/kx),Round(y/ky));
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Button=mbLeft then
 begin
  mx:=x;my:=y;
  drag:=true;
 end;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 drag:=false;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 if WheelDelta>0 then
  map.Zoom(1,1)
 else
  map.Zoom(-1,-1)
end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
  vk_down:map.Move(0,-1);
  vk_up:map.Move(0,1);
  vk_left:map.Move(1,0);
  vk_right:map.Move(-1,0);
 end;
end;

procedure TForm1.Panel2Click(Sender: TObject);
var
 bx,by,kx,ky:integer;
begin
 repeat
  bx:=random(30);
  by:=random(30);
 until map.fdata[bx,by]=0;

 repeat
  kx:=100+random(30);
  ky:=100+random(30);
 until map.fdata[kx,ky]=0;
 
 path:=map.GetPath(bx,by,kx,ky);
end;

end.
