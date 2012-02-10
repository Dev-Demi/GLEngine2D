program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  GLEngine in '../../Source/GLEngine.pas',
  OpenGL12 in '../../Source/OpenGL12.pas',
  dglOpenGL in '../../Source/dglOpenGL.pas';
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
