unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,GlEngine, StdCtrls, ExtCtrls, Spin,UMover;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GLE:TGLEngine=nil;
  mc:TMoverControl;
  DragMover:boolean;
  StartX,StartY:integer;
  SelectedMover:TMover;
  c:single = 1;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 Randomize;
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel.Handle),Panel.ClientWidth,Panel.ClientHeight,2);
 Init(GLE);
 gle.SetBKColor(0,0,0);
 DragMover:=false;
 mc:=TMoverControl.Create;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 GLE.BeginRender(true);
 GLE.AntiAlias(true);
  mc.Draw;
 if c >0 then
  begin
   Gle.SetColor(c,c,0,c);
   c:=c-0.001;
   GLE.TextOut(100,100,'Right button click - add point');
   GLE.TextOut(100,120,'Left button click - move point');
  end;

 GLE.FinishRender;
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 mover:Tmover;
begin
if Button = mbRight then
 begin
  mover:=Tmover.Create(mc,x,y);
  mc.movers.Add(mover);
 end;


 SelectedMover:=nil;
 mover:=mc.Find(x,y);
  if mover<>nil then
  begin
   mover.Select(true);
   SelectedMover:=mover;
   DragMover:=true;
   StartX:=X;
   StartY:=Y;
  end;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if DragMover then
  if SelectedMover<>nil then
  begin
   SelectedMover.Move(x-startX,y-StartY);
   startX:=x;
   startY:=y;
  end
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 DragMover:=false;
 SelectedMover:=nil;
end;

end.
