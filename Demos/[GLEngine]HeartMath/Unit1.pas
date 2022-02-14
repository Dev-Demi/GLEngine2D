unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,GlEngine;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GLE:TGLEngine;
implementation

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 GLE.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,2);

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
 t,x,y:single;
begin
 t:=random*2*pi;
 x:=10*16*(sin(t)*sin(t)*sin(t))+panel1.ClientWidth/2;
 y:=Panel1.ClientHeight/2 - 10* (13*cos(t)-5*cos(2*t)-2*cos(3*t)-cos(4*t));
 GLE.BeginRender(false);
 GLE.AntiAlias(true);
 gle.SetColor(1,0,0,1);
 Gle.Line(panel1.ClientWidth/2,Panel1.ClientHeight/2,x,y);
 GLE.FinishRender;
end;

end.
