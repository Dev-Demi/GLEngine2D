unit UMover;

interface
 uses
  Classes,GlEngine,SysUtils;

Type

 TMover=Class;


 TMoverControl=class
  movers:Tlist;
  Constructor Create;
  procedure Draw;
  procedure DeselectAll;
  procedure HideAll;
  Function Find(x,y:integer):TMover;
 end;


 TMover=Class
  x,y:single;
  ymin,ymax:single;
  isSelect:boolean;
  isCenter:boolean;
  HoldX:boolean;
  invisible:boolean;
  ConnecttedMovers:Tlist;
  mc:TMoverControl;
  Constructor Create(ParentMC:TMoverControl;x0,y0:single);
  Procedure Draw;
  Procedure Move(Dx,dy:integer);
  function CalcPath(Target:TMover):single;
  procedure Select(yes:boolean);
  procedure ConnectMover(mover:TMover);
 end;
 Var
  GLE:TGLEngine;

  procedure Init(GLEngine:TGLEngine);


implementation

 procedure Init(GLEngine:TGLEngine);
 begin
  GLE:=GLEngine;
 end;

{ TMoverControl }

constructor TMoverControl.Create;
begin
 movers:=Tlist.Create;
end;

procedure TMoverControl.DeselectAll;
var
 i:integer;
begin
 For i:=0 to movers.Count-1 do
  TMover(movers.Items[i]).isSelect:=false;
end;

procedure TMoverControl.Draw;
var
 i,j,k:integer;
 m1,m2: TMover;
begin
 For i:=0 to movers.Count-1 do
  TMover(movers.Items[i]).Draw;

 For i:=0 to movers.Count-1 do
 begin
  m1 := TMover(movers.Items[i]);
  For j:=0 to movers.Count-1 do
  begin
  m2 := TMover(movers.Items[j]);
   if m1.CalcPath(m2)<150 then
   begin
    gle.SwichBlendMode(bmAdd);
    gle.SetColor(random,random,random,0.1);
    for k:=0 to 3 do
     gle.Bolt(m1.x,m1.y,m2.x,m2.y);
    gle.SwichBlendMode(bmNormal);
   end
  end;
 end;


end;

function TMoverControl.Find(x, y: integer): TMover;
var
 i:integer;
 mover:TMover;
begin
 result:=nil;
 For i:=0 to movers.Count-1 do
 begin
  mover:=movers.Items[i];
  if (abs(mover.x-x)<10)and(abs(mover.y-y)<10)and(not mover.invisible) then
  begin
   result:=mover;
   exit;
  end;
 end;

end;

procedure TMoverControl.HideAll;
var
 i:integer;
begin
 For i:=0 to movers.Count-1 do
  if not TMover(movers.Items[i]).isCenter then
   TMover(movers.Items[i]).Invisible:=true;

end;

{ TMover }

function TMover.CalcPath(Target: TMover): single;
begin
 result:= SQRT(sqr(self.x-Target.x)+sqr(self.y-Target.y));
end;

procedure TMover.ConnectMover(mover: TMover);
begin
 ConnecttedMovers.Add(mover);
end;

constructor TMover.Create(ParentMC:TmoverControl;x0, y0: single);
begin
 mc:=  ParentMC;
 isCenter:=false;
 ConnecttedMovers := TList.Create;
 HoldX:=false;
 invisible:=false;
 x:=x0;
 y:=y0;
 mc.movers.add(self);
 ymax:=100000;
 ymin:=0;
end;

procedure TMover.Draw;
begin
if not invisible then
begin
 if isSelect then
  Gle.SetColor(1,1,0,1)
 else
  Gle.SetColor(1,0,0,1);
 GLE.Bar(x,y,10,10,45);
 Gle.SetColor(0,0,0,1);
 // GLE.TextOut(x,y,IntToStr(Round((y-Parent.ParentStvorka.yn)/Parent.ParentStvorka.ParentFasad.mashtab)));
end; 
end;

procedure TMover.Move(Dx, dy: integer);
var
 i:integer;
begin
 if HoldX then dx:=0;
  x:=x+dx;

 if((y+dy)>=ymin) and ((y+dy)<=ymax) then
  y:=y+dy;



 For i:=0 to ConnecttedMovers.Count-1 do
  Tmover(ConnecttedMovers.Items[i]).Move(dx,dy);

end;

procedure TMover.Select(yes: boolean);
begin
 Mc.DeselectAll;
 isSelect:=yes;
end;
end.
