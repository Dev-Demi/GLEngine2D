program Project1;

uses
  Forms, Graphics, Windows, Messages,
  Unit1 in 'Unit1.pas' {Form1};

var
  PrevWnd: hWnd;
  rect: TRect;
  can: TCanvas;

procedure Paint;
begin
 // Draw(can, r, g, b, rect.Right - rect.Left, rect.Bottom - rect.Top);
end;

function MyWndProc(wnd: hWnd; msg: integer;
wParam, lParam: longint): integer; stdcall;
begin
  case Msg of
    WM_DESTROY:
    begin
      PostQuitMessage(0);
      result := 0;
    end;
    WM_PAINT:
    begin
      paint;
      result := DefWindowProc(Wnd, Msg, wParam, lParam);
    end;
    else
      result := DefWindowProc(Wnd, Msg, wParam, lParam);
  end;
end;

procedure Preview;
const
  ClassName = 'MyScreenSaverClass'#0;
var
  parent: hWnd;
  WndClass: TWndClass;
  msg: TMsg;
  code: integer;
begin
  val(ParamStr(2), parent, code);
  if (code <> 0) or (parent <= 0) then
    Exit;

  with WndClass do
  begin
    style := CS_PARENTDC;
    lpfnWndProc := addr(MyWndProc);
    cbClsExtra := 0;
    cbWndExtra := 0;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 0;
    lpszMenuName := nil;
    lpszClassName := ClassName;
  end;
  WndClass.hInstance := hInstance;
  Windows.RegisterClass(WndClass);

  GetWindowRect(Parent, rect);
  PrevWnd := CreateWindow(ClassName, 'MyScreenSaver',
  WS_CHILDWINDOW or WS_VISIBLE or WS_BORDER, 0, 0, rect.Right - rect.Left,
  rect.Bottom - rect.Top, Parent, 0, hInstance, nil);
  can := TCanvas.Create;
  can.Handle := GetDC(PrevWnd);
  can.Brush.Color := clBlack;
  can.FillRect(rect);
  can.TextOut(10,10,'GLEngine2D');
  repeat
    if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    begin
      if Msg.message = WM_QUIT then
        break;
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end
  //  else
  //    Paint;
  until
    false;
  ReleaseDC(PrevWnd, can.Handle);
  can.Destroy;
end;

var
  c: char;

begin
  if (ParamCount >= 1) and (Length(ParamStr(1)) > 1) then
    c := UpCase(ParamStr(1)[2])
  else
    c := #0;
  case c of
    'P': Preview;
    'S':
    begin
      Application.Initialize;
      Application.CreateForm(TForm1, Form1);
      Application.Run;
    end;
    else
    begin
       Windows.MessageBox(0,'Заставка создана при помощи GLEngine2D специально для сайта VR-online.ru','Информация',0);
    end;
  end;
end.
