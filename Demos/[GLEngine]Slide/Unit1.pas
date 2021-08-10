unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,GlEngine, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Timer1: TTimer;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GLE:TGLEngine=nil;
  Im1,im2,im3:cardinal;
  d,dx:real;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,2);
  GLE.LoadImage(ExtractFilePath(Application.ExeName)+'1.jpg',Im1,false);
  GLE.LoadImage(ExtractFilePath(Application.ExeName)+'2.jpg',Im2,false);
  GLE.LoadImage(ExtractFilePath(Application.ExeName)+'1.png',Im3,false);
 d:=0; dx:=0.01;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
 if GLE.dcvis<>0 then
  gle.Resize(panel1.ClientWidth,panel1.ClientHeight);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 GLE.BeginRender(true);
 GLE.AntiAlias(true);
 gle.SetColor(1,1,1,d);
 Gle.DrawImage(0,0,panel1.ClientWidth,Panel1.ClientHeight,0,false,false,Im1);

 gle.SetColor(1,1,1,1-d);
 Gle.DrawImage(0,0,panel1.ClientWidth,Panel1.ClientHeight,0,false,false,Im2);
 gle.SetColor(1,1,1,1);
 Gle.DrawImage(0,0,100,100,0,false,false,Im3);
 GLE.FinishRender;
 Form1.Caption:='FPS - '+FloatToStr(GLE.GetFPS);
 d:=d+dx;
 if (d<=0)or(d>=1) then
  dx:=-dx;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Timer1.Enabled:=not Timer1.Enabled;
end;

end.
