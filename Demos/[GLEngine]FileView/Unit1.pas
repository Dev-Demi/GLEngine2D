unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,GLEngine, StdCtrls,ShellApi, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Timer1: TTimer;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    TrackBar1: TTrackBar;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TIconCollectionItem=record
   ext:string;
   image:cardinal;
  end;

  TIconCollection=class
   Icons:Tlist;
   Procedure Add(path:string);
   Function GetIcon(ext:string):Cardinal;
   Function GetFolderIcon:Cardinal;
   Procedure KillList;
  end;

  TFileViewItemState=(isNormal,isSelected);


  TFileView=class
   Files:Tlist;
   itemW,ItemH:single;
   maxW,MinW,MaxH,MinH:single;
   Procedure GotoFolder(path:string);
   Procedure Draw;
   Procedure ClearList;
   Function GetItemCursor:integer;
   Procedure FolderUp(Path:String);
  end;

  TFileViewItem=class
   IconCollection:TIconCollection;
   FileView:TFileView;
   ItemName:string;
   ItemPath:String;
   SizeStr:string;
   Icon:Cardinal;
   isFolder:Boolean;
   State:TFileViewItemState;
   Color:TGLColor;
   angle:single;
   w,h:single;

   Procedure Add(Path:String;size:cardinal;folder:boolean);
   Procedure Draw(x,y:single);
  end;

var
  Form1: TForm1;
  GLE:TGLEngine=nil;
  IconCollection:TIconCollection;
  FileView:TFileView;
  background:cardinal;
  mx,my:integer;
implementation

{$R *.dfm}

procedure TForm1.FormDestroy(Sender: TObject);
begin
 GLE.VisualDone;
 GLE.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 GLE:=TGLEngine.Create;
 GLE.VisualInit(GetDC(Panel1.Handle),Panel1.ClientWidth,Panel1.ClientHeight,2);
 GLE.LoadImage(ExtractFilePath(Application.ExeName)+'back.jpg',background,false);
 IconCollection:=TIconCollection.Create;
 IconCollection.Add(ExtractFilePath(Application.ExeName)+'FileImage\');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 FileView:=TFileView.Create;
 FileView.itemW:=40;
 FileView.ItemH:=40;
 FileView.MinW:=40;
 FileView.MinH:=40;
 FileView.MaxW:=60;
 FileView.MaxH:=60;
// FileView.GotoFolder('c:\');
 timer1.Enabled:=true;
 Button2.Enabled:=true;
 Button3.Enabled:=true;

end;

{ TIconCollection }

procedure TIconCollection.Add(path: string);
var
 FD: WIN32_FIND_DATA;
 HFile: THandle;
 ti: ^TIconCollectionItem;
begin
 KillList;
 Icons:=Tlist.Create;
 HFile := FindFirstFile(Pchar(path+'*.png'), FD);
 if HFile <> INVALID_HANDLE_VALUE then
 repeat
  with FD do
   begin
    new(ti);
    ti^.ext:= '.'+ExtractFileName(LowerCase(FD.cFileName));
    GLE.LoadImage(path+FD.cFileName,ti^.image,false);
    Icons.Add(ti);
   end
  until not FindNextFile(HFile, FD);
end;

function TIconCollection.GetFolderIcon: Cardinal;
begin
 result:=GetIcon('.folder.png');
end;

function TIconCollection.GetIcon(ext: string): Cardinal;
var
 i:integer;
 ti: ^TIconCollectionItem;
 tr:cardinal;
begin
 tr:=0;
 If Icons<>nil then
  for i:=0 to Icons.Count-1 do
  begin
   ti:=Icons.Items[i];
   if ti^.ext=ext then
    tr:=ti^.image
  end;
 result:=tr;
end;

procedure TIconCollection.KillList;
var
 i:integer;
 ti: ^TIconCollectionItem;
begin
 If Icons<>nil then
 begin
  for i:=0 to Icons.Count-1 do
  begin
   ti:=Icons.Items[i];
   dispose(ti);
  end;
  Icons.Free;
 end;
end;

{ TFileViewItem }

procedure TFileViewItem.Add(Path:String;size:cardinal;folder:boolean);
begin
 ItemPath:=Path;
 State:=isNormal;
 w:=FileView.MinW; h:=FileView.MinH;

 Icon:=0;
 Color.Red:=1;
 Color.Green:=1;
 Color.Blue:=1;
 Color.alpha:=0.5;
 angle:=0;
 ItemName:=ExtractFileName(Path);
 isFolder:= folder;
 if folder then
  Icon:=IconCollection.GetFolderIcon
 else
  Icon:=IconCollection.GetIcon(ExtractFileExt(ItemName)+'.png');

 if Icon=0 then
  Icon:=IconCollection.GetIcon('.default.png');
  if size < 1024 then
   sizeStr:=IntToStr(size) + ' B'
  else
   if  size < 1024 * 1024 then
    sizeStr:=IntToStr(round( size/ 1024)) + ' KB'
   else
    sizeStr:=IntToStr(round( size / (1024 * 1024))) + ' MB';

end;

procedure TFileViewItem.Draw(x, y: single);
var
 caption:string[8];
begin
 caption:= ItemName;
 gle.SetColor(color);
 case state of
  isNormal: begin
             if w<FileView.MinW then w:=FileView.MinW;
             if h<FileView.MinH then h:=FileView.MinH;
             if w>FileView.MinW then w:=w-1;
             if h>FileView.MinH then h:=h-1;
             if angle>0 then angle:=angle-1;
             if color.alpha>=0.5 then color.alpha:=color.alpha-0.02;
              gle.TextOut(x,y+h+10,caption);
            end;
  isSelected: begin
               if w<FileView.MaxW then w:=w+3;
               if h<FileView.MaxH then h:=h+3;
               if angle<20 then angle:=angle+3;
               if color.alpha<=1 then color.alpha:=color.alpha+0.02;
               gle.TextOut(x,y+h+10,ItemName);
             end;
 end;

 gle.DrawImage(x+w/2,y+h/2,w,h,angle,true,false,Icon);
end;

{ TFileView }

procedure TFileView.ClearList;
var
 i:integer;
 ti: TFileViewItem;
begin
 If Files<>nil then
 begin
  for i:=0 to Files.Count-1 do
  begin
   ti:=Files.Items[i];
   ti.Free;
  end;
  Files.Free;
 end;
end;

procedure TFileView.Draw;
var
 i:integer;
 x,y:single;
begin
 Gle.BeginRender(true);
 Gle.SetColor(1,1,1,0.5);
 Gle.DrawImage(0,0,Form1.Panel1.ClientWidth,Form1.Panel1.ClientHeight,0,false,false,background);
 x:=5;y:=0;

 If Files<>nil then
  begin
   for i:=0 to Files.Count-1 do
   begin
    if i=GetItemCursor then
     TFileViewItem(Files[i]).State:=isSelected
    else
     TFileViewItem(Files[i]).State:=isNormal;

    TFileViewItem(Files[i]).Draw(x-5,y-5);

    x:=x+itemW*1.5;
    if x>Form1.Panel1.ClientWidth-itemW*1.5 then
     begin
      x:=5;
      y:=y+itemH*1.5;
     end;

   end;
  end;
 Gle.FinishRender;
end;

procedure TFileView.FolderUp(Path:String);
 Function FolderUp(put:string):string;
  var
   i:integer;
  begin
   i:=length(put)-1;
   while (put[i]<>'\')or(i=0)  do
    i:=i-1;
  result:=copy(put,1,i);
  end;
begin
if length(Form1.Edit1.Text)  >=4 then
 Form1.Edit1.Text:=FolderUp( Form1.Edit1.Text);
 GotoFolder(Form1.Edit1.Text);
end;

function TFileView.GetItemCursor: integer;
var
 kstrok:integer;
 kit:integer;
begin
 kstrok:=trunc(my / (itemH*1.5));
 kit:=trunc(mx / ( itemW*1.5));
 result:=kstrok*trunc(Form1.Panel1.ClientWidth/(itemW*1.5))+ kit;
end;

procedure TFileView.GotoFolder(path: string);
 var
  ListItem: TFileViewItem;
  FD: WIN32_FIND_DATA;
  Dirs: THandle;
begin
 if DirectoryExists(path) then
 begin
  ClearList;
  Files:=Tlist.Create;
  // ищем сначала каталоги
  Dirs := FindFirstFile(PChar(path+'*.*'), FD);
  if Dirs <> INVALID_HANDLE_VALUE then
   repeat
    with FD do
     if ((dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0) and
        (cFileName <> string('.')) and (cFileName <> string('..')) then
     //   if not( ((dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) <> 0)and( not form1.ShowHide.Checked)) then
         begin
          ListItem := TFileViewItem.Create;
          ListItem.IconCollection:=IconCollection;
          ListItem.FileView:=FileView;
          ListItem.Add(path+FD.cFileName,0,true);
          Files.Add(ListItem);
         end
    until not FindNextFile(Dirs, FD);
   windows.FindClose(Dirs);

 // ищем файлы
   Dirs := FindFirstFile(PChar(path+'*.*'), FD);
   if Dirs <> INVALID_HANDLE_VALUE then
    repeat
     with FD do
      if (dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY = 0 ) and (dwFileAttributes <> FILE_ATTRIBUTE_SYSTEM)
       then
    //    if not( ((dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) <> 0)and( not form1.ShowHide.Checked)) then
         begin
          ListItem := TFileViewItem.Create;
          ListItem.IconCollection:=IconCollection ;
          ListItem.FileView:=FileView;
          ListItem.Add(path+FD.cFileName,(nFileSizeHigh * MAXDWORD) + nFileSizeLow,false);
          Files.Add(ListItem);
         end
     until not FindNextFile(Dirs, FD);
     windows.FindClose(Dirs)   ;
 end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 FileView.Draw;
end;

procedure TForm1.Panel1Resize(Sender: TObject);
begin
if GLE.dcvis<>0 then
 gle.Resize(panel1.ClientWidth,panel1.ClientHeight);
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 mx:=x;my:=y;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if directoryexists(Edit1.Text) then
 FileView.GotoFolder(Edit1.Text);
end;

procedure TForm1.Panel1Click(Sender: TObject);

begin
 if FileView.GetItemCursor<=FileView.Files.Count-1 then
 if TFileViewItem(FileView.Files.Items[FileView.GetItemCursor]).isFolder then
  begin
   Edit1.Text:=Edit1.Text+TFileViewItem(FileView.Files.Items[FileView.GetItemCursor]).ItemName+'\';
   FileView.GotoFolder(Edit1.Text);
  end
 else
  ShellExecute(0,'open',PChar(TFileViewItem(FileView.Files.Items[FileView.GetItemCursor]).ItemPath),nil,nil,SW_Normal);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 FileView.FolderUp('');
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
 FileView.minW:= TrackBar1.Position;
 FileView.minH:= TrackBar1.Position;
 FileView.maxW:= TrackBar1.Position*1.5;
 FileView.maxH:= TrackBar1.Position*1.5;
 FileView.itemW:=TrackBar1.Position;
 FileView.itemH:=TrackBar1.Position;
end;

end.
