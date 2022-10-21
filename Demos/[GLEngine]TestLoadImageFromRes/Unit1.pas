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
  Im1:cardinal;
  d,dx:real;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,2);

 // в наименовании ресурса первые три буквы должны отображать тип файла:  BMP JPG TGA PNG
 GLE.LoadImage('JpgImage_1',Im1,true);

 d:=0; dx:=1;
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
 gle.SetColor(1,1,1,1);
 Gle.DrawImage(d,0,100,50,0,false,false,Im1);

 GLE.FinishRender;
 Form1.Caption:='FPS - '+FloatToStr(GLE.GetFPS);
 d:=d+dx;
 if (d<=0)or(d>=500) then
  dx:=-dx;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Timer1.Enabled:=not Timer1.Enabled;
end;

end.
