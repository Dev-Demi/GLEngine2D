unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,GLEngine, ExtCtrls, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Panel2: TPanel;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    CheckBox1: TCheckBox;
    TrackBar1: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
   procedure DrawSpinBars;
   procedure DrawLine;
    { Public declarations }
  end;

var
  Form1: TForm1;
  GLE:TGLEngine;
  angle:single=0;
  da:single=1;
  s,b,a:cardinal;
  Im:Cardinal;
implementation

{$R *.dfm}

procedure TForm1.DrawLine;
var
 k,i:integer;
begin
 k:=10;
 gle.SetFill(glLine);
 For i:=k downto 1 do
 begin
  gle.SetColor(1-i/k,1-i/k,1-i/k,1);
  gle.Bar(230,230,300,300,-angle*i)
 end;
 gle.SetColor(1,1,1,1);
 gle.Bar(230,230,300,300,0);
end;

procedure TForm1.DrawSpinBars;
var
 i,j:integer;
begin
 gle.SetFill(glLine);
 For i:=1 to 10 do
  for j:=1 to 10 do
   begin
    gle.SetColor(i/10,1-j/10,1-angle/360,1);
    if  (i+j) mod 2 = 0 then
     gle.Bar(i*30,j*30,30,30,-angle)
    else
     gle.Bar(i*30,j*30,30,30,angle)
   end;
 gle.SetFill(glFill);
 gle.SetColor(0,0,0,0.5);
 gle.ShaderStart(s);
  gle.ShaderSetUniform(s,gle.ShaderGetUniform(s,'time_0_X'),angle/10);
  gle.ShaderSetUniform(s,gle.ShaderGetUniform(s,'rings'),TrackBar1.Position*1.0);
  gle.Bar(170,165,310,310,0);
 gle.ShaderStop(s);

 gle.SetColor(1,1,1,1);

{ gle.ShaderStart(b);
 gle.SetCurrentImage(im);
// gle.DrawImage(0,0,0,0,0,false,false,im);
 gle.ShaderSetUniform(b,gle.ShaderGetUniform(b,'Image'),0);
 gle.ShaderSetUniform(b,gle.ShaderGetUniform(b,'scale'),5.0);
 gle.ShaderSetUniform(b,gle.ShaderGetUniform(b,'pixelSize'),0.0037);
  gle.SetCurrentImage(0);
  gle.Bar(300,100,400,200,0);
 gle.ShaderStop(b); }

 gle.ShaderStart(a);
 gle.DrawImage(0,0,0,0,0,false,false,im);
 gle.ShaderSetUniform(a,gle.ShaderGetUniform(a,'image'),0);
  gle.Bar(300,300,400,200,0);
 gle.ShaderStop(a);

 gle.TextOut(10,10,IntToStr(gle.GetFPS));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDc(Panel1.Handle),panel1.ClientWidth,Panel1.ClientHeight,4);
 gle.SetFill(glLine);
 s:=Gle.ShaderCreate('b.fp','b.vp');
 a:=Gle.ShaderCreate('a.fp','a.vp');
 b:=Gle.ShaderCreate('blur.fp','blur.vp');
 gle.LoadImage('back.jpg',im,false);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Gle.VisualDone;
 Gle.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 gle.BeginRender(true);
 case RadioGroup1.ItemIndex of
  0:  DrawSpinBars;
  1:  DrawLine;
 end;
 angle:=angle+da;
 if (angle>360) or (angle<0) then da:=-da;
 gle.FinishRender;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
 angle:=0;
 case RadioGroup1.ItemIndex of
  0:   da:=1;
  1:   da:=0.1;
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 i:integer;
begin
 for i:=1 to 1000 do
  Form1.Timer1Timer(nil);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 gle.VertSynh(CheckBox1.Checked);
end;

end.
