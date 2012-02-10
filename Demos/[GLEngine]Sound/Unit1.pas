unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,GLEngine, bass;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Timer1: TTimer;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TWaveData = array [ 0..2048] of DWORD;
  TFFTData  = array [0..512] of Single;

var
  Form1: TForm1;
  GLE:TGLEngine;
   stream : HSTREAM;
   WaveData:TWaveData;

  FFTPeacks  : array [0..256] of single;
  FFTFallOff : array [0..256] of single;

  PeakFall : single;
  LineFall : single;

  LeftL:single;
  RigthL:single;
   col:TGLCOLOR;
   LengthStream:QWORD;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel2.Handle),Panel2.ClientWidth,Panel2.ClientHeight,0);

	if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
	begin
		MessageBox(0,'An incorrect version of BASS.DLL was loaded',nil,MB_ICONERROR);
		Halt;
	end;

	if not BASS_Init(-1, 44100, 0, Handle, nil) then
		ShowMessage('Error initializing audio!');

 PeakFall:=3;
 LineFall:=5;
 col:=gle.ColorGL(1,0,0,0.5);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Bass_StreamFree(stream);
 BASS_Free();
 GLE.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
 var 
 i:integer;
  ly,YPos,US : single; R, L : single;
  k,progress:single;
  level:cardinal;
  nx,ny:integer;

begin

 if BASS_ChannelIsActive(stream) <> BASS_ACTIVE_PLAYING then Exit;

 progress := BASS_StreamGetFilePosition(stream, BASS_FILEPOS_CURRENT) / BASS_StreamGetFilePosition(stream, BASS_FILEPOS_END);

 k:=3;
 level := BASS_ChannelGetLevel(stream);
 LeftL:= loword(level) / (maxword / 2);
 RigthL:=Hiword(level) / (maxword / 2);

 BASS_ChannelGetData(stream, @WaveData, 2048);
 ly:=Panel2.Height/3;
 gle.BeginRender(false);

 gle.SwichBlendMode(bmNormal);
 Gle.SetColor(0,0,0,0.3);
 gle.Bar(0,0,panel2.Width,panel2.Height);
 gle.SwichBlendMode(bmAdd);

 nx:=00;
 ny:=00;

  for i:=1 to 256 do
   begin
     R := SmallInt(Loword(WaveData[i]));
     L := SmallInt(HIword(WaveData[i]));
     uS:=(R + L) / (2 * 65535);

  if ABS(uS* Panel2.Height*2) >= FFTPeacks[i] then FFTPeacks[i] := ABS(uS* Panel2.Height*2)
    else FFTPeacks[i] := FFTPeacks[i] - PeakFall;

   if ABS(uS* Panel2.Height*2) >= FFTFallOff[i] then FFTFallOff[i] := ABS(uS* Panel2.Height*2)
    else FFTFallOff[i] := FFTFallOff[i] - LineFall;


    gle.LineWidth(5);
    Gle.LineGrad(nx+i*k,Panel2.Height-ny,nx+i*k,Panel2.Height- FFTFallOff[i]-ny,gle.ColorGL(0,0,0,0.5),col);

    gle.SetColor(1-col.Red,1-col.Green,1-col.Blue,FFTPeacks[i]/Panel2.Height);
  //  gle.SwichBlendMode(bmAdd);
    gle.Ellipse(nx+i*k,Panel2.Height- FFTPeacks[i]-ny,k,k,1,0,12);

     Gle.SetColor(1,1,1,0.3);
     YPos :=uS* Panel2.Height/2+Panel2.Height/3 ;
      gle.LineWidth(2);
     gle.Line(nx+(i-1)*k,ly-ny,nx+i*k,YPos-ny);
     ly:=ypos;
   end;
   gle.SetColor(0,1,0,0.5);

   if leftl>0.96 then
    col:=Gle.ColorGL(random,random,random,0.8);

   gle.Bar(260*k,Panel2.Height-30,262*k+20,Panel2.Height-Panel2.Height*LeftL-30);
   gle.Bar(270*k,Panel2.Height-30,272*k+20,Panel2.Height-Panel2.Height*RigthL-30);

   gle.SetColor(1,1,1,0.2);
   gle.Rectangle(0,Panel2.Height-8,Panel2.Width,Panel2.Height-22,);
   gle.Bar(0,Panel2.Height-10,progress*Panel2.Width,Panel2.Height-20);

 gle.FinishRender;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 f: PChar;
 i:integer;
begin
 if OpenDialog1.Execute then
 begin
  f := PChar(OpenDialog1.FileName);
  if(stream<>0) then Bass_StreamFree(stream);
  stream := BASS_StreamCreateFile(False,f, 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
   for i:=1 to 256 do
    begin
     FFTPeacks[i]:=0;
     FFTFallOff[i]:=0;
    end;
  BASS_ChannelPlay(stream, False);
 end;
end;

end.
