unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,GLEngine, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CreateTex,pod:Cardinal;
  GLE:TGLEngine;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 bmp:TBitMap;
 x,y:integer;
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle)  , Panel1.ClientWidth , Panel1.ClientHeight , 0);
 CreateTex:=GLE.CreateImage(350,500);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 i:integer;
begin
 GLE.BeginRender(true);
 GLE.AntiAlias(false);
 gle.SetColor(1,0,0,1);

  For i:=1 to 20 do
 begin
  gle.PointSize(i*2);
  gle.PointSmooth((i mod 2)=0);
  GLE.Point(20,i*20);
 end ;

 gle.SetColor(1,1,1,1);

 gle.BeginRenderToTex(CreateTex,Panel1.ClientWidth,panel1.ClientHeight);

 For i:=1 to 20 do
 begin
  gle.PointSize(i);
  gle.PointSmooth((i mod 2)=0);
  GLE.Point(20,i*20);
 end ;
   GLE.EndRenderToTex;
   GLE.DrawImage(0,0,Panel1.ClientWidth,panel1.ClientHeight,0,false,false,CreateTex);
   GLE.FinishRender;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Gle.FreeImage(pod);
 Gle.FreeImage(CreateTex);
 Gle.Free;
end;

end.
