unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,GLEngine;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

 var
  Form1: TForm1;
  GLE1,GLE2,GLE3:TGLEngine;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE1:=TGLEngine.Create;
 GLE1.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,0);

 GLE2:=TGLEngine.Create;
 GLE2.VisualInit(GetDC(Panel2.Handle),Panel2.ClientWidth,Panel2.ClientHeight,0);

 GLE3:=TGLEngine.Create;
 GLE3.VisualInit(GetDC(Panel3.Handle),Panel3.ClientWidth,Panel3.ClientHeight,0);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 gle1.BeginRender(true);
  gle1.SetColor(1,0,0,1);
  gle1.Line(Random(100),Random(100),Random(100),Random(100));
  gle1.TextOut(0,20,' Наконец-то');
 gle1.FinishRender;

 gle2.BeginRender(true);
  gle2.SetColor(0,1,0,1);
  gle2.Bar(Random(100),Random(100)+40,10,10,0);
  gle2.TextOut(0,20,' заработал');
 gle2.FinishRender;

 gle3.BeginRender(true);
  gle3.SetColor(0,0,1,1);
  gle3.Ellipse(Random(100)+20,Random(100)+20,Random(10),Random(10),1,0,10);
  gle3.TextOut(0,20,' MultiView');
 gle3.FinishRender;
end;
end.
