unit GLEngine;

interface
uses
  Windows,   Graphics, Classes, JPEG, SysUtils,
  dglOpenGL,
{$IF CompilerVersion < 22.0}
  pngimageOLD,GifImageOLD,
 {$ifend}
 {$IF CompilerVersion >= 22.0}
  PNGImage,
 {$ifend}

 math;

Type

 TGLFill=(glPoint,glLine,glFill);

 TGLBlendMode=(bmAdd,bmNormal,bmMultiply,bmSrc2Dst,bmAddMul,bmAdd2);
{ switch (m.blend)
  case BLEND_ALPHA: glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); break;
  case BLEND_ADD: glBlendFunc(GL_ONE, GL_ONE); break;
  case BLEND_MULTIPLY: glBlendFunc(GL_DST_COLOR, GL_ZERO); break;
  case BLEND_SRC2DST: glBlendFunc(GL_SRC_COLOR, GL_ONE); break;
  case BLEND_ADDMUL: glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE); break;
  case BLEND_ADDALPHA: glBlendFunc(GL_SRC_ALPHA, GL_ONE); break;
}
 TGLPoint = record
  x,y:single;
  end;

 TGLColor = record
   Red, Green, Blue, alpha:single;
  end;

{ TGLGifAnim = record
   BitmapInfoSize	: Integer;
   BitmapSize		: longInt;
   Tex:Cardinal;
   count:integer;
   curFrame:integer;
   GifImage:TGifImage;
  end;   }

 TGLAnim = record
   Tex:Cardinal;
   dw,dh,Width,Height,cols,rows: integer;
   count:integer;
   curFrame:integer;
    AnimX      : Single;
    AnimY      : Single;
    AnimPos    : Single;
  end;

  CVert = record
    x, y, z: GLfloat;
    end;

//  CVec = CVert;

  CTexCoord = record
    u, v: GLfloat;
    end;

  TVBOPrimitive = class
     private
      g_fVBOSupported:boolean;
      m_nVertexCount: integer;
      m_pVertices: array of CVert;
      m_pTexCoords: array of CTexCoord;
      m_nVBOVertices: GLuint;
      m_nVBOTexCoords: GLuint;
      mode: TGLenum;
       procedure BuildVBOs;
     public
      constructor Create; dynamic;
      destructor Destroy; override;
      Procedure Add;  virtual;abstract;
      Procedure Draw;

      function IsExtensionSupported(szTargetExtension: string): boolean; 
    end;

  TVBOSprite = class(TVBOPrimitive)
    constructor Create; override;
    procedure add(x,y,w,h:single);
   end;


  TGLEngine=class
  private
   NeedScreenShot:Boolean;
   scs_BMP:TBitMap;
   scs_AWidth,scs_AHeight:integer;


   VBOSprite:TVBOSprite;
   AAFormat:Integer;
   xl,yl:single;
   w,h:word;


//   gmf: array [0..255] of GLYPHMETRICSFLOAT; // ìàññèâ òðåáóåòñÿ äëÿ âåêòîðíîãî

   toFrameBufer:boolean;
   DrawFrameCount:Integer;
   RealFPS:Integer;
   ClockRate:double;
   FrameBuffer: Cardinal;
   StartDrawTime,EndDrawTime,TimeDraw:Int64;
   Font: HFONT;
   Procedure DrawQuad( pWidth, pHeight : Single; Center,Tile:boolean);
   procedure GetPixelFormat(AASamples : Integer );
   procedure SetDCPixelFormat (dc : HDC);

  public
   dcvis:hdc;
   hrcvis:HGLRC;
 //  FontHandle: Integer;

  {+}Procedure VisualInit(dc:HDC;width,height:word;AntiAlias:integer);
  {+}Function GetGLEngineWidth:word;
  {+}Function GetGLEngineHeight:word;

  {+}Function GetTimeDrawFrame:double;
  {+}Function GetFPS:Integer;

  {+}Procedure Resize(w,h:integer);
  {+}Procedure BeginRender(Clear:Boolean);
  {+}Procedure AntiAlias(Enable:boolean);
  {+}Procedure VertSynh(Enable:boolean);

  {+}Function ColorGL(r,g,b,a:single):TGLColor;

  {+}Procedure Line(x1,y1,x2,y2:single);
     Procedure LineTo(x,y:single);
     Procedure MoveTo(x,y:single);
  {+}Procedure LineWidth(W:single);
  {+}Procedure LineGrad(x1,y1,x2,y2:single;Color1,Color2:TGLColor);
  {+}Procedure SetLineStripple(Factor: GLint; Line: string);
  {+}Procedure UnSetLineStripple;

  {+}Procedure Bolt(x1,y1,x2,y2:single);
  {+}Procedure Arrow(x1,y1,x2,y2, size,angle:single;Solid:Boolean);

  {+}Procedure PointSize(Size:single);
  {+}Procedure Point(x1,y1:single);
  {+}Procedure PointSmooth(Enable:Boolean);

  {+}Procedure Triangle(x1,y1,x2,y2,x3,y3:single);
  {+}Procedure TriangleGrad(x1,y1,x2,y2,x3,y3:single;c1,c2,c3:TGLColor);

  {+}Procedure Rectangle(x1, y1, x2, y2:single);
  {+}Procedure Bar(x1, y1, x2, y2, x3, y3, x4, y4:single);  Overload ;
  {+}Procedure Bar(x1, y1, x2, y2:single);  Overload;
  {+}Procedure Bar(x, y, w, h, angle:single);  Overload;
     Procedure BarClassic(x, y, w, h, angle:single);
  {+}Procedure BarGrad(x1,y1,x2,y2,x3,y3,x4,y4:single;c1,c2,c3,c4:TGLColor); Overload;

  {+}Procedure Ellipse(x,y,r1,r2,whidth,AngleRotate:single;n:integer);
     Procedure Polygon(x,y,AngleRotate,TextureAngleRotate:single; n: array of TGLPoint);
     procedure PolygonTexture(x,y,AngleRotate,TexAngle:single;Trans, Scale: TGLPoint; vertex,tex: array of TGLPoint; image:Cardinal);
     procedure PolygonTess( x, y, AngleRotate: single; n: array of TGLPoint ); // Ñïàñèáî cain
     Procedure Tesselate (var inVertexArray,outVertexArray: array of TGLPoint);

     procedure PolygonFromArray( x, y, AngleRotate: single; n: array of TGLPoint );

  {+}Procedure SetTextStyle(NameFont:string; size:integer);
  {+}Procedure TextOut(x,y:single; text:AnsiString; angle:single=0);
     Procedure TextOutUseImageFont(x,y:single; text:AnsiString; Font:Cardinal; angle:single=0;wchar:single=64;hchar:single=64);
  {+}Procedure KillFont;

  {+}Procedure SetColor(r,g,b,a:single);Overload;
  {+}Procedure SetColor(color:TGLColor);Overload;
  {+}Procedure SetBKColor(r,g,b:single);
  {+}Procedure SetFill(Mode:TGLFill);

  {+}Procedure SwichBlendMode(sfactor: TGLEnum; dfactor: TGLEnum); Overload;
  {+}Procedure SwichBlendMode(BlendMode:TGLBlendMode); Overload;

  {+}procedure AddBMPImage(Bmp:TBitMap;var Texture : Cardinal);
  {+}Function  CreateImage(w,h:integer):Cardinal;
  {+}function  LoadImage(Filename: String; var Texture : Cardinal; LoadFromRes : Boolean) : Boolean;
  {+}Procedure DrawImage(x,y,w,h,Angle:single;Center,tile:boolean;Image:Cardinal);
  {+}Procedure SetCurrentImage(Image:Cardinal);
  {+}Procedure DrawCurrentImage (x,y,w,h,Angle:single;Center,tile:boolean);
     Procedure DrawCurrentImage2(x,y,w,h,Angle:single;Center,tile:boolean);

     procedure GetImageWidth(image:cardinal; var w:Integer);
     procedure GetImageHeight(image:cardinal; var h:Integer);

     Procedure DrawTileImage(x,y,w,h,u,v,Angle:single;Image:Cardinal);
  {+}Procedure SaveImage(FileName:string;var Texture : Cardinal);
  {+}Procedure SaveImageAsPNG(Filename:String; Im:Cardinal);
  {+}Procedure GetBMP32FromImage(Im:Cardinal;var BMP32:TBitMap);


{------------------------------------------------------------------}
{  Load/Save GL textures by aliday a@kubado.ru                     }
{------------------------------------------------------------------}

     function SaveRAWTexture(FileName: string; var Texture:Cardinal) : Boolean;
     function LoadRAWTexture(Filename: String; var Texture : Cardinal; LoadFromResource : Boolean) : Boolean;

     Procedure ScreenShot(Var BMP:TBitMap;AWidth,AHeight:integer);
     Procedure _ScreenShot(Var BMP:TBitMap;AWidth,AHeight:integer);

  {+}Procedure FreeImage(var Texture : Cardinal);

  Procedure LoadAnimation(FileName:string; w,h,dw,dh:integer; var An:TGLAnim; LoadFromRes : Boolean);
  Procedure DrawAniFrame(x,y,angle:single; var An:TGLAnim);

//  Procedure LoadGifAnimation(FileName:string; var An:TGLGifAnim);
//  Procedure DrawGifFrame(x,y,angle:single; var An:TGLGifAnim);

  {+}Procedure BeginRenderToTex(Image:Cardinal; w,h:glint);
  {+}Procedure EndRenderToTex;

  {+}Function ShaderCreate(FragmentShaderFileName,VertexShaderFileName:String):Integer;

  {+}Procedure ShaderStart(Shader:Integer);
  {+}Procedure ShaderStop(Shader:Integer);
  Function  ShaderGetUniform(Shader:Integer;uniform: PAnsiChar):GLuint;
  Procedure ShaderSetUniform(Shader:Integer;uniform: GLuint; value0: Integer); Overload;
  Procedure ShaderSetUniform(Shader:Integer;uniform: GLuint; value0: Single); Overload;


  {+}Procedure Clear;
  {+}Procedure FinishRender;
  Procedure VisualDone;
  private
 end;

implementation

var
 FontHandle: Integer;

// var
//   FirstRC,SecondRC:HGLRC;

procedure SwapRGB(data : Pointer; Size : Integer);
asm
  mov ebx, eax
  mov ecx, size

@@loop :
  mov al,[ebx+0]
  mov ah,[ebx+2]
  mov [ebx+2],al
  mov [ebx+0],ah
  add ebx,3
  dec ecx
  jnz @@loop
end;

{------------------------------------------------------------------}
{  Create the Texture                                              }
{------------------------------------------------------------------}
function CreateTexture(Width, Height, Format : Word; pData : Pointer) : Integer;
var
  Texture : Cardinal;
begin
  glGenTextures(1, @Texture);

  glBindTexture(GL_TEXTURE_2D, Texture);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);  {Texture blends with object background}
//glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);  {Texture does NOT blend with object background}

  { Select a filtering type. BiLinear filtering produces very good results with little performance impact
    GL_NEAREST               - Basic texture (grainy looking texture)
    GL_LINEAR                - BiLinear filtering
    GL_LINEAR_MIPMAP_NEAREST - Basic mipmapped texture
    GL_LINEAR_MIPMAP_LINEAR  - BiLinear Mipmapped texture
  }  

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); { only first two can be used }
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST); { all of the above can be used }

  if Format = GL_RGBA then
    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, pData)
  else
    gluBuild2DMipmaps(GL_TEXTURE_2D, 3, Width, Height, GL_RGB, GL_UNSIGNED_BYTE, pData);
//  glTexImage2d(Texture);
//  glTexImage2D(GL_TEXTURE_2D, 0, 3, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData);  // Use when not wanting mipmaps to be built by openGL

  result:=Texture;
end;


{------------------------------------------------------------------}
{  Load BMP textures                                               }
{------------------------------------------------------------------}
function LoadBMPTexture(Filename: String; var Texture : Cardinal; LoadFromResource : Boolean) : Boolean;
var
  FileHeader: BITMAPFILEHEADER;
  InfoHeader: BITMAPINFOHEADER;
  Palette: array of RGBQUAD;
  BitmapFile: THandle;
  BitmapLength: LongWord;
  PaletteLength: LongWord;
  ReadBytes: LongWord;
  Width, Height : Integer;
  pData : Pointer;

  // used for loading from resource
  ResStream : TResourceStream;
begin
  result :=FALSE;

  if LoadFromResource then // Load from resource
  begin
    try
      ResStream := TResourceStream.Create(hInstance, PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'BMP');
      ResStream.ReadBuffer(FileHeader, SizeOf(FileHeader));  // FileHeader
      ResStream.ReadBuffer(InfoHeader, SizeOf(InfoHeader));  // InfoHeader
      PaletteLength := InfoHeader.biClrUsed;
      SetLength(Palette, PaletteLength);
      ResStream.ReadBuffer(Palette, PaletteLength);          // Palette

      Width := InfoHeader.biWidth;
      Height := InfoHeader.biHeight;

      BitmapLength := InfoHeader.biSizeImage;
      if BitmapLength = 0 then
        BitmapLength := Width * Height * InfoHeader.biBitCount Div 8;

      GetMem(pData, BitmapLength);
      ResStream.ReadBuffer(pData^, BitmapLength);            // Bitmap Data
      ResStream.Free;
    except on
      EResNotFound do
      begin
        MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('BMP Texture'), MB_OK);
        Exit;
      end
      else
      begin
        MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
        Exit;
      end;
    end;
  end
  else
  begin   // Load image from file
    BitmapFile := CreateFile(PChar(Filename), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
    if (BitmapFile = INVALID_HANDLE_VALUE) then begin
      MessageBox(0, PChar('Error opening ' + Filename), PChar('BMP Unit'), MB_OK);
      Exit;
    end;

    // Get header information
    ReadFile(BitmapFile, FileHeader, SizeOf(FileHeader), ReadBytes, nil);
    ReadFile(BitmapFile, InfoHeader, SizeOf(InfoHeader), ReadBytes, nil);

    // Get palette
    PaletteLength := InfoHeader.biClrUsed;
    SetLength(Palette, PaletteLength);
    ReadFile(BitmapFile, Palette, PaletteLength, ReadBytes, nil);
    if (ReadBytes <> PaletteLength) then begin
      MessageBox(0, PChar('Error reading palette'), PChar('BMP Unit'), MB_OK);
      Exit;
    end;

    Width  := InfoHeader.biWidth;
    Height := InfoHeader.biHeight;
    BitmapLength := InfoHeader.biSizeImage;
    if BitmapLength = 0 then
      BitmapLength := Width * Height * InfoHeader.biBitCount Div 8;

    // Get the actual pixel data
    GetMem(pData, BitmapLength);
    ReadFile(BitmapFile, pData^, BitmapLength, ReadBytes, nil);
    if (ReadBytes <> BitmapLength) then begin
      MessageBox(0, PChar('Error reading bitmap data'), PChar('BMP Unit'), MB_OK);
      Exit;
    end;
    CloseHandle(BitmapFile);
  end;

  // Bitmaps are stored BGR and not RGB, so swap the R and B bytes.
  SwapRGB(pData, Width*Height);

  Texture :=CreateTexture(Width, Height, GL_RGB, pData);
  FreeMem(pData);
  result :=TRUE;
end;

procedure png8to24(png: TPNGObject);
var
 tmp: TPNGObject;
 tRNS: TChunktRNS;
 PLTE: TChunkPLTE;
 src, alpha: pByteArray;
 dst: pRGBLine;
 x,y: integer;
begin
 tRNS:=png.Chunks.ItemFromClass(TChunktRNS) as TChunktRNS;
 PLTE:=png.Chunks.ItemFromClass(TChunkPLTE) as TChunkPLTE;
 if (tRNS=nil) or (PLTE=nil)
  then exit;
 tmp:=TPNGObject.CreateBlank(COLOR_RGBALPHA, 8, png.Width, png.Height);
 for y:=0 to png.Height-1 do
 begin
  src:=png.Scanline[y];
  dst:=tmp.Scanline[y];
  alpha:=tmp.AlphaScanline[y];
 for x:=0 to png.Width-1 do
 begin
  dst[x].rgbtBlue:=PLTE.Item[src[x]].rgbBlue;
  dst[x].rgbtGreen:=PLTE.Item[src[x]].rgbGreen;
  dst[x].rgbtRed:=PLTE.Item[src[x]].rgbRed;
  alpha[x]:=tRNS.PaletteValues[src[x]];
 end;
end;
png.Assign(tmp);
tmp.Destroy;
end;

function LoadPNGTexture(Filename: String; var Texture : Cardinal; LoadFromResource : Boolean) : Boolean;
var
  Data : Array of byte;
  W, Width,il : Integer;
  H, Height : Integer;
  png: TPNGObject;
  pb: PByteArray;
  ResStream : TResourceStream;      // used for loading from resource
begin
  png := TPNGObject.Create;
  png.LoadFromFile(FileName);
  Width :=png.Width;
  Height :=png.Height;
  if png.Palette<>0 then
   png8to24(png);

  SetLength(Data, Width*Height*4);

  il:=0;
  For H:=0 to Height-1 do
  Begin
   pb:=png.Scanline[H];
    For W:=0 to Width-1 do
    Begin
      Data[il] :=pb[W*3+2];
      Data[il+1] :=pb[W*3+1];
      Data[il+2] :=pb[W*3];
      Data[il+3] :=png.AlphaScanline[H][W] ;
      inc(il,4);
    End;
  End;
  png.Free;
  Texture :=CreateTexture(Width, Height, GL_RGBA, addr(Data[0]));
  result :=TRUE;
end;

{------------------------------------------------------------------}
{  Load JPEG textures                                              }
{------------------------------------------------------------------}
function LoadJPGTexture(Filename: String; var Texture: Cardinal; LoadFromResource : Boolean): Boolean;
var
  Data : Array of LongWord;
  W, Width : Integer;
  H, Height : Integer;
  BMP : TBitmap;
  JPG : TJPEGImage;
  C : LongWord;
  Line : ^LongWord;
  ResStream : TResourceStream;      // used for loading from resource
begin
  result :=FALSE;
  JPG:=TJPEGImage.Create;

  if LoadFromResource then // Load from resource
  begin
    try
      ResStream := TResourceStream.Create(hInstance, PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'JPEG');
      JPG.LoadFromStream(ResStream);
      ResStream.Free;
    except on
      EResNotFound do
      begin
        MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('JPG Texture'), MB_OK);
        Exit;
      end
      else
      begin
        MessageBox(0, PChar('Couldn''t load JPG Resource - "'+ Filename +'"'), PChar('BMP Unit'), MB_OK);
        Exit;
      end;
    end;
  end
  else
  begin
    try
      JPG.LoadFromFile(Filename);
    except
      MessageBox(0, PChar('Couldn''t load JPG - "'+ Filename +'"'), PChar('BMP Unit'), MB_OK);
      Exit;
    end;
  end;

  // Create Bitmap
  BMP:=TBitmap.Create;
  BMP.pixelformat:=pf32bit;
  BMP.width:=JPG.width;
  BMP.height:=JPG.height;
  BMP.canvas.draw(0,0,JPG);

  //  BMP.SaveToFile('D:\test.bmp');
  Width :=BMP.Width;
  Height :=BMP.Height;
  SetLength(Data, Width*Height);

  For H:=0 to Height-1 do
  Begin
   // Line :=BMP.scanline[Height-H-1];   // flip JPEG
   Line :=BMP.scanline[H];
    For W:=0 to Width-1 do
    Begin
      c:=Line^ and $FFFFFF; // Need to do a color swap
      Data[W+(H*Width)] :=(((c and $FF) shl 16)+(c shr 16)+(c and $FF00)) or $FF000000;  // 4 channel.
      inc(Line);
    End;
  End;

  BMP.free;
  JPG.free;

  Texture :=CreateTexture(Width, Height, GL_RGBA, addr(Data[0]));
  result :=TRUE;
end;

{------------------------------------------------------------------}
{  Loads 24 and 32bpp (alpha channel) TGA textures                 }
{------------------------------------------------------------------}
function LoadTGATexture(Filename: String; var Texture: Cardinal; LoadFromResource : Boolean): Boolean;
var
  TGAHeader : packed record   // Header type for TGA images
    FileType     : Byte;
    ColorMapType : Byte;
    ImageType    : Byte;
    ColorMapSpec : Array[0..4] of Byte;
    OrigX  : Array [0..1] of Byte;
    OrigY  : Array [0..1] of Byte;
    Width  : Array [0..1] of Byte;
    Height : Array [0..1] of Byte;
    BPP    : Byte;
    ImageInfo : Byte;
  end;
  TGAFile   : File;
  bytesRead : Integer;
  image     : Pointer;    {or PRGBTRIPLE}
  CompImage : Pointer;
  Width, Height : Integer;
  ColorDepth    : Integer;
  ImageSize     : Integer;
  BufferIndex : Integer;
  currentByte : Integer;
  CurrentPixel : Integer;
  I : Integer;
  Front: ^Byte;
  Back: ^Byte;
  Temp: Byte;

  ResStream : TResourceStream;      // used for loading from resource

  // Copy a pixel from source to dest and Swap the RGB color values
  procedure CopySwapPixel(const Source, Destination : Pointer);
  asm
    push ebx
    mov bl,[eax+0]
    mov bh,[eax+1]
    mov [edx+2],bl
    mov [edx+1],bh
    mov bl,[eax+2]
    mov bh,[eax+3]
    mov [edx+0],bl
    mov [edx+3],bh
    pop ebx
  end;

begin
  result :=FALSE;
  GetMem(Image, 0);
  if LoadFromResource then // Load from resource
  begin
    try
      ResStream := TResourceStream.Create(hInstance, PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'TGA');
      ResStream.ReadBuffer(TGAHeader, SizeOf(TGAHeader));  // FileHeader
      result :=TRUE;
    except on
      EResNotFound do
      begin
        MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('TGA Texture'), MB_OK);
        Exit;
      end
      else
      begin
        MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
        Exit;
      end;
    end;
  end
  else
  begin
    if FileExists(Filename) then
    begin
      AssignFile(TGAFile, Filename);
      Reset(TGAFile, 1);
      // Read in the bitmap file header
      BlockRead(TGAFile, TGAHeader, SizeOf(TGAHeader));
      result :=TRUE;
    end
    else
    begin
      MessageBox(0, PChar('File not found  - ' + Filename), PChar('TGA Texture'), MB_OK);
      Exit;
    end;
  end;

  if Result = TRUE then
  begin
    Result :=FALSE;

    // Only support 24, 32 bit images
    if (TGAHeader.ImageType <> 2) AND    { TGA_RGB }
       (TGAHeader.ImageType <> 10) then  { Compressed RGB }
    begin
      Result := False;
      CloseFile(tgaFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Only 24 and 32bit TGA supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    // Don't support colormapped files
    if TGAHeader.ColorMapType <> 0 then
    begin
      Result := False;
      CloseFile(TGAFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Colormapped TGA files not supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    // Get the width, height, and color depth
    Width  := TGAHeader.Width[0]  + TGAHeader.Width[1]  * 256;
    Height := TGAHeader.Height[0] + TGAHeader.Height[1] * 256;
    ColorDepth := TGAHeader.BPP;
    ImageSize  := Width*Height*(ColorDepth div 8);

    if ColorDepth < 24 then
    begin
      Result := False;
      CloseFile(TGAFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Only 24 and 32 bit TGA files supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    GetMem(Image, ImageSize);

    if TGAHeader.ImageType = 2 then   // Standard 24, 32 bit TGA file
    begin
      if LoadFromResource then // Load from resource
      begin
        try
          ResStream.ReadBuffer(Image^, ImageSize);
          ResStream.Free;
        except
          MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
          Exit;
        end;
      end
      else         // Read in the image from file
      begin
        BlockRead(TGAFile, image^, ImageSize, bytesRead);
        if bytesRead <> ImageSize then
        begin
          Result := False;
          CloseFile(TGAFile);
          MessageBox(0, PChar('Couldn''t read file "'+ Filename +'".'), PChar('TGA File Error'), MB_OK);
          Exit;
        end
      end;

      // TGAs are stored BGR and not RGB, so swap the R and B bytes.
      // 32 bit TGA files have alpha channel and gets loaded differently
      if TGAHeader.BPP = 24 then
      begin
        for I :=0 to Width * Height - 1 do
        begin
          Front := Pointer(Integer(Image) + I*3);
          Back := Pointer(Integer(Image) + I*3 + 2);
          Temp := Front^;
          Front^ := Back^;
          Back^ := Temp;
        end;
        Texture :=CreateTexture(Width, Height, GL_RGB, Image);
      end
      else
      begin
        for I :=0 to Width * Height - 1 do
        begin
          Front := Pointer(Integer(Image) + I*4);
          Back := Pointer(Integer(Image) + I*4 + 2);
          Temp := Front^;
          Front^ := Back^;
          Back^ := Temp;
        end;
        Texture :=CreateTexture(Width, Height, GL_RGBA, Image);
      end;
    end;

    // Compressed 24, 32 bit TGA files
    if TGAHeader.ImageType = 10 then
    begin
      ColorDepth :=ColorDepth DIV 8;
      CurrentByte :=0;
      CurrentPixel :=0;
      BufferIndex :=0;

      if LoadFromResource then // Load from resource
      begin
        try
          GetMem(CompImage, ResStream.Size-sizeOf(TGAHeader));
          ResStream.ReadBuffer(CompImage^, ResStream.Size-sizeOf(TGAHeader));   // load compressed date into memory
          ResStream.Free;
        except
          MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('BMP Unit'), MB_OK);
          Exit;
        end;
      end
      else
      begin
        GetMem(CompImage, FileSize(TGAFile)-sizeOf(TGAHeader));
        BlockRead(TGAFile, CompImage^, FileSize(TGAFile)-sizeOf(TGAHeader), BytesRead);   // load compressed data into memory
        if bytesRead <> FileSize(TGAFile)-sizeOf(TGAHeader) then
        begin
          Result := False;
          CloseFile(TGAFile);
          MessageBox(0, PChar('Couldn''t read file "'+ Filename +'".'), PChar('TGA File Error'), MB_OK);
          Exit;
        end
      end;

      // Extract pixel information from compressed data
      repeat
        Front := Pointer(Integer(CompImage) + BufferIndex);
        Inc(BufferIndex);
        if Front^ < 128 then
        begin
          For I := 0 to Front^ do
          begin
            CopySwapPixel(Pointer(Integer(CompImage)+BufferIndex+I*ColorDepth), Pointer(Integer(image)+CurrentByte));
            CurrentByte := CurrentByte + ColorDepth;
            inc(CurrentPixel);
          end;
          BufferIndex :=BufferIndex + (Front^+1)*ColorDepth
        end
        else
        begin
          For I := 0 to Front^ -128 do
          begin
            CopySwapPixel(Pointer(Integer(CompImage)+BufferIndex), Pointer(Integer(image)+CurrentByte));
            CurrentByte := CurrentByte + ColorDepth;
            inc(CurrentPixel);
          end;
          BufferIndex :=BufferIndex + ColorDepth
        end;
      until CurrentPixel >= Width*Height;

      if ColorDepth = 3 then
        Texture :=CreateTexture(Width, Height, GL_RGB, Image)
      else
        Texture :=CreateTexture(Width, Height, GL_RGBA, Image);
    end;

    Result :=TRUE;
    FreeMem(Image);
  end;
end;

{ TGLEngine }

procedure TGLEngine.Bar(x1, y1, x2, y2:single);
begin
 glBegin(GL_QUADS);
  glVertex3d(x1,y1,0);
  glVertex3d(x1,y2,0);
  glVertex3d(x2,y2,0);
  glVertex3d(x2,y1,0);
 glEnd();
end;

procedure TGLEngine.Bar(x1, y1, x2, y2, x3, y3, x4, y4: single);
begin
 glBegin(GL_QUADS);
  glVertex3d(x1,y1,0);
  glVertex3d(x2,y2,0);
  glVertex3d(x3,y3,0);
  glVertex3d(x4,y4,0);
 glEnd();
end;

procedure TGLEngine.Bar(x, y, w, h, angle: single);
begin
glPushMatrix();
 glTranslated(x,y,0);
 glRotatef(Angle, 0,0,1);
 glBegin(GL_QUADS);
  glVertex3d(-w/2,-h/2,0);
  glVertex3d(w/2,-h/2,0);
  glVertex3d(w/2,h/2,0);
  glVertex3d(-w/2,h/2,0);
 glEnd();
glPopMatrix();
end;

procedure TGLEngine.BarClassic(x, y, w, h, angle: single);
begin
glPushMatrix();
 glTranslated(x,y,0);
 glRotatef(Angle, 0,0,1);
 glBegin(GL_QUADS);
  glVertex3d(0,0,0);
  glVertex3d(w,0,0);
  glVertex3d(w,h,0);
  glVertex3d(0,h,0);
 glEnd();
glPopMatrix();
end;

procedure TGLEngine.BarGrad(x1, y1, x2, y2, x3, y3, x4, y4: single; c1, c2,
  c3, c4: TGLColor);
begin
 glBegin(GL_QUADS);
  glColor4f(c1.Red,c1.Green,c1.Blue,c1.alpha);
  glVertex3d(x1,y1,0);
  glColor4f(c2.Red,c2.Green,c2.Blue,c2.alpha);
  glVertex3d(x2,y2,0);
  glColor4f(c3.Red,c3.Green,c3.Blue,c3.alpha);
  glVertex3d(x3,y3,0);
  glColor4f(c4.Red,c4.Green,c4.Blue,c4.alpha);
  glVertex3d(x4,y4,0);
 glEnd();
end;


procedure TGLEngine.BeginRender(clear:boolean);
begin
 QueryPerformanceCounter(StartDrawTime);
// wglMakeCurrent(0, 0);
// ActivateRenderingContext(dcvis,hrcvis);
 wglMakeCurrent(dcvis,hrcvis);

 if clear then
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glLoadIdentity;
end;

procedure TGLEngine.FinishRender;
begin
 VBOSprite.Draw;
 glFlush();

 swapBuffers(dcvis);

 if needScreenShot then
  begin
   needScreenShot:=false;
   _ScreenShot(scs_BMP,scs_AWidth,scs_AHeight);
  end;

 QueryPerformanceCounter(EndDrawTime);
 wglMakeCurrent(0, 0);

 DrawFrameCount:=DrawFrameCount+1;
 If 1000.0 *(EndDrawTime - TimeDraw) / ClockRate>1000 then
   begin
    TimeDraw:=EndDrawTime;
    RealFPS:= DrawFrameCount;
    DrawFrameCount:=0;
   end;
end;

function TGLEngine.ColorGL(r, g, b,a: single): TGLColor;
begin
 result.Red:=r;
 result.Green:=g;
 result.Blue:=b;
 result.alpha:=a;
end;

{procedure TGLEngine.DrawQuad(pX, pY, pZ, pWidth, pHeight : Single; Center:boolean);
begin
glBegin(GL_QUADS);
if center then
 begin
  glTexCoord2f(0,0); glVertex3f(-pWidth/2, -pHeight/2, -pZ);
  glTexCoord2f(1,0); glVertex3f(pWidth/2, -pHeight/2, -pZ);
  glTexCoord2f(1,1); glVertex3f(pWidth/2, pHeight/2, -pZ);
  glTexCoord2f(0,1); glVertex3f(-pWidth/2,pHeight/2, -pZ);
 end
else
 begin
 if not toFrameBufer then
  begin
   glTexCoord2f(0,0);  glVertex3f(0, 0, -pZ);
   glTexCoord2f(1,0);  glVertex3f(pWidth, 0, -pZ);
   glTexCoord2f(1,-1); glVertex3f(pWidth, pHeight, -pZ);
   glTexCoord2f(0,-1); glVertex3f(0,pHeight, -pZ);
  end
  else
  begin
   glTexCoord2f(0,0); glVertex3f(0, 0, -pZ);
   glTexCoord2f(1,0); glVertex3f(pWidth, 0, -pZ);
   glTexCoord2f(1,1); glVertex3f(pWidth, pHeight, -pZ);
   glTexCoord2f(0,1); glVertex3f(0,pHeight, -pZ);
  end;
 end;
glEnd;
end;    }

procedure TGLEngine.DrawQuad( pWidth, pHeight : Single; Center,Tile:boolean);
var
 dx,dy:single;
 Width,Height:integer;
begin
 dx:=1;
 dy:=1;
 if tile then
  begin
   glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @Width);
   glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @Height);
   dx:=pWidth/Width;
   dy:=pHeight/Height;
  end;
 glBegin(GL_QUADS);
 if center then
 begin
  if not toFrameBufer then
   begin
    glTexCoord2f(0, 0);  glVertex3f(-pWidth/2, -pHeight/2, 0);
    glTexCoord2f(dx,0);  glVertex3f( pWidth/2, -pHeight/2, 0);
    glTexCoord2f(dx,dy); glVertex3f( pWidth/2, pHeight/2,  0);
    glTexCoord2f(0, dy); glVertex3f(-pWidth/2, pHeight/2,  0);
   end
  else
   begin
    glTexCoord2f(0, 0);  glVertex3f(-pWidth/2, -pHeight/2, 0);
    glTexCoord2f(dx,0);  glVertex3f( pWidth/2, -pHeight/2, 0);
    glTexCoord2f(dx,dy); glVertex3f( pWidth/2, pHeight/2, 0);
    glTexCoord2f(0, dy); glVertex3f(-pWidth/2, pHeight/2, 0);
   end;
 end
else
 begin
 if not toFrameBufer then
  begin
   glTexCoord2f(0, 0);  glVertex3f(0, 0, 0);
   glTexCoord2f(dx,0);  glVertex3f(pWidth, 0, 0);
   glTexCoord2f(dx,dy); glVertex3f(pWidth, pHeight, 0);
   glTexCoord2f(0, dy); glVertex3f(0,pHeight, 0);
  end
  else
  begin
   glTexCoord2f(0, 0);   glVertex3f(0, 0, 0);
   glTexCoord2f(dx,0);   glVertex3f(pWidth, 0, 0);
   glTexCoord2f(dx,dy); glVertex3f(pWidth, pHeight, 0);
   glTexCoord2f(0, dy); glVertex3f(0,pHeight, 0);
  end;
 end;
 glEnd;
end;

procedure TGLEngine.DrawImage(x,y,w,h,Angle:single;Center,tile:boolean;Image:Cardinal);
begin
 {glMatrixMode(GL_TEXTURE);
  glLoadIdentity();
 glMatrixMode(GL_MODELVIEW); }

 glBindTexture(GL_TEXTURE_2D, Image);
 glEnable(GL_TEXTURE_2D);
 glPushMatrix();
{  if not toFrameBufer then
   glTranslated(x,y,0)
  else
   glTranslated(x,256-y,0);}

  glTranslated(x,y,0);
  glRotatef(Angle, 0,0,1);
  DrawQuad(w,h,Center,tile);
 glPopMatrix();
 glDisable(GL_TEXTURE_2D);
end;

procedure TGLEngine.SetCurrentImage(Image: Cardinal);
begin
 if image=0 then
  begin
   glDisable(GL_TEXTURE_2D);
   exit;
  end;
  glEnable(GL_TEXTURE_2D);
 glBindTexture(GL_TEXTURE_2D, Image);

end;

procedure TGLEngine.DrawCurrentImage(x, y, w, h, Angle: single; Center,
  tile: boolean);
begin
 glPushMatrix();
  glTranslated(x,y,0);
  glRotatef(Angle, 0,0,1);
  DrawQuad(w,h,Center,tile);
 glPopMatrix();
end;

procedure TGLEngine.DrawTileImage(x, y, w, h, u, v, Angle: single;
  Image: Cardinal);
begin
 glBindTexture(GL_TEXTURE_2D, Image);
 glEnable(GL_TEXTURE_2D);
 glPushMatrix();
  glTranslated(x,y,0);
  glRotatef(Angle, 0,0,1);
   glBegin(GL_QUADS);
   glTexCoord2f(0,0); glVertex3f(0, 0, 0);
   glTexCoord2f(u,0); glVertex3f(w, 0, 0);
   glTexCoord2f(u,v); glVertex3f(w, h, 0);
   glTexCoord2f(0,v); glVertex3f(0, h, 0);
   glEnd;
 glPopMatrix();
 glDisable(GL_TEXTURE_2D);
end;

procedure TGLEngine.Ellipse(x, y, r1, r2,whidth,AngleRotate: single;n:integer);
var {sx,sy,rx,ry: single;
   angle,ugol,dugol: real;
   i:integer; }
   quadDisc:PGLUquadric;
{function rot_x(x,y: Single; theta: real): single;
begin
 result := x * cos(theta) - y * sin(theta);
end;

function rot_y(x,y: Single; theta: real): single;
begin
 result := x * sin(theta) + y * cos(theta);
end; }

begin
(*
   angle:= AngleRotate*(3.1415926/180);
   sx := x + r1;//rot_x(r1,0,angle);
   sy := y + r2;// rot_y(r1,0,angle);

   ugol:=0;
   dUgol:=5.96904/n;
   glBegin(GL_POLYGON);

   for i:=1 to n do
     begin
       ugol := ugol+dUgol;
       rx := round(r1*cos(ugol));
       ry := round(r2*sin(ugol));
       glVertex3d(x + rx{rot_x(rx,ry,angle)},y + ry {rot_y(rx,ry,angle)},0);
     end;
 // glVertex3d(sx,sy,0);
  glEnd();
  *)
 glPushMatrix();
 glTranslated(x,y,0);
 glRotatef(AngleRotate, 0,0,1);
 glScalef(r1,r2,1);
 quadDisc:= gluNewQuadric();
 gluDisk(quadDisc, 1-whidth, 1, n, n);
 gluDeleteQuadric(quadDisc);
 glPopMatrix();
end;

procedure TGLEngine.Line(x1, y1, x2, y2: single);
begin
 glBegin(GL_LINES);
  glVertex3d(x1,y1,0);
  glVertex3d(x2,y2,0);
 glEnd();
end;

procedure TGLEngine.LineTo(x, y: single);
begin
 glBegin(GL_LINE_LOOP);
  glVertex3d(x,y,0);
 glEnd();
end;

procedure TGLEngine.MoveTo(x, y: single);
begin
 xl:=x;
 yl:=y;
end;

procedure TGLEngine.LineGrad(x1, y1, x2, y2: single; Color1,
  Color2: TGLColor);
begin
 glBegin(GL_LINES);
  glColor4f(color1.Red,color1.Green,color1.Blue,color1.alpha);
  glVertex3d(x1,y1,0);
  glColor4f(color2.Red,color2.Green,color2.Blue,color1.alpha);
  glVertex3d(x2,y2,0);
 glEnd();
end;

procedure TGLEngine.LineWidth(W: single);
begin
 glLineWidth(W);
end;

procedure TGLEngine.SetLineStripple(Factor: GLint; Line: string);
var
  i: integer;
  Res, Fact: Cardinal;
begin
   Res := 0; Fact := 1;
   for i := 1 to Length( Line ) do
   begin
      case Line[i] of
         '-', '.', '*' : Res := Res + Fact;
      end;
      Fact := Fact shl 1;
   end;
   glLineStipple( Factor, Res );
   glEnable( GL_LINE_STIPPLE );
end;

procedure TGLEngine.UnSetLineStripple;
begin
 glDisable( GL_LINE_STIPPLE );
end;

function TGLEngine.LoadImage(Filename: String; var Texture: Cardinal;
  LoadFromRes: Boolean): Boolean;
begin
 if copy(Uppercase(filename), length(filename)-3, 4) = '.BMP' then
  LoadBMPTexture(Filename, Texture, LoadFromRes);
 if copy(Uppercase(filename), length(filename)-3, 4) = '.JPG' then
  LoadJPGTexture(Filename, Texture, LoadFromRes);
 if copy(Uppercase(filename), length(filename)-3, 4) = '.TGA' then
  LoadTGATexture(Filename, Texture, LoadFromRes);
 if copy(Uppercase(filename), length(filename)-3, 4) = '.PNG' then
  LoadPNGTexture(Filename, Texture, LoadFromRes);

end;

procedure flipIt(buffer: Pointer;w,h:integer);
{asm
  mov ecx, 256*256
  mov ebx, buffer
@@loop :
  mov al,[ebx+0]
  mov ah,[ebx+2]
  mov [ebx+2],al
  mov [ebx+0],ah
  add ebx,3
  dec ecx
  jnz @@loop  }
var
  i: integer;
  B, R: PGLubyte;
  temp: GLubyte;
begin
  for i := 0 to w * h - 1 do
   begin
    B := Pointer(Integer(buffer) + i * 4);
    R := Pointer(Integer(buffer) + i * 4+2);
    temp := B^;
    B^ := R^;
    R^ := temp;
   end;
end;

procedure TGLEngine.Point(x1, y1: single);
begin
  glBegin(GL_POINTS);
   glVertex3d(x1,y1,0);
  glEnd();
end;

procedure TGLEngine.PointSize(Size: single);
begin
 glPointSize(Size);
end;

procedure TGLEngine.PointSmooth(Enable: Boolean);
begin
 If enable then
  glEnable(GL_POINT_SMOOTH)
 else
  glDisable(GL_POINT_SMOOTH);
end;

procedure TGLEngine.SetBKColor(r, g, b: single);
begin
 glClearColor(r,g,b,0);
end;

procedure TGLEngine.SetColor(r, g, b, a: single);
begin
 glColor4f(r,g,b,a);
end;

procedure TGLEngine.SetColor(color: TGLColor);
begin
 glColor4f(color.Red,color.Green,color.Blue,color.alpha);
end;

procedure TGLEngine.SetFill(Mode: TGLFill);
begin
  Case  Mode of
   glPoint:glPolygonMode(GL_FRONT_AND_BACK, gl_Point);
   glLine:glPolygonMode(GL_FRONT_AND_BACK, gl_Line);
   glFill:glPolygonMode(GL_FRONT_AND_BACK, gl_Fill);
  end;
end;

procedure TGLEngine.SetTextStyle(NameFont: string; size: integer);
begin
  KillFont;
  FontHandle := glGenLists(257);                                 // 96 znakù
  font := CreateFont(-size,                                 // Výška
                      0,                                  // Šíøka
                      0,                                  // Úhel escapement
                      0,                                  // Úhel orientace
                      FW_DONTCARE,                            // Tuènost
                      0,                                  // Kurzíva
                      0,                                  // Podtržení
                      0,                                  // Pøeškrtnutí
                      RUSSIAN_CHARSET,                       // Znaková sada
                      OUT_TT_PRECIS,                      // Pøesnost výstupu (TrueType)
                      CLIP_DEFAULT_PRECIS,                // Pøesnost oøezání
                      ANTIALIASED_QUALITY,                // Výstupní kvalita
                      FF_DONTCARE or DEFAULT_PITCH,       // Rodina a pitch
                      PChar(NameFont));                     // Jméno fontu
  SelectObject(dcvis,font);                                // Výbìr fontu do DC
  wglUseFontBitmaps(dcvis,0,256,FontHandle);                     // Vytvoøí 96 znakù, poèínaje 32 v Ascii
//  wglUseFontOutlines (FontHandle, 0, 255, FontHandle, 50, 0.15,
  //                    WGL_FONT_POLYGONS, nil);
// if not wglUseFontOutlines(dcvis, 0, 255, FontHandle, 50, 0.15, WGL_FONT_POLYGONS, @gmf) then
//   MessageBox(0, 'Font not create', 'glBuildFont', MB_OK);

 DeleteObject(Font);
  //wglUseFontOutlines(dcvis,0,255,FontHandle)
end;

procedure TGLEngine.KillFont;
begin
  glDeleteLists(FontHandle,257);                                 // Smaže všech 96 znakù (display listù)
  DeleteObject(font);
end;

procedure TGLEngine.TextOut(x,y:single; text:AnsiString; angle:single=0);
begin
  if text = '' then exit;

  glPushAttrib(GL_LIST_BIT);
  glPushMatrix();

  glRasterPos2f(x,y);

////////////////////

// glEnable(GL_LINE_SMOOTH);
// glEnable(GL_POLYGON_SMOOTH);

//  glTranslatef(x, y, 0.0);
 //  glRotatef(Angle, 0,0,1);
//  glScalef (15.0, -15.0, 1.0);                      // Uloží souèasný stav display listù
////////////////////////
 //  glPixelZoom(1,10);
//  glTranslatef (10,-1,1);
  glListBase(FontHandle);
  glCallLists(length(text),GL_UNSIGNED_BYTE,Pchar(text)); // Vykreslí display listy
  glPopMatrix();
  glPopAttrib;
end;

procedure TGLEngine.TextOutUseImageFont(x, y: single; text: AnsiString;
  Font: Cardinal; angle: single=0; wchar:single=64;hchar:single=64);
 var
  xp,yp{,dx,dy}:single;
  px,py:Single;
  Width,Height,i:integer;
begin
 glBindTexture(GL_TEXTURE_2D, Font);
 glEnable(GL_TEXTURE_2D);
 glPushMatrix();
  glTranslated(x,y,0);
  glRotatef(Angle, 0,0,1);

  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @Height);

  xp:=0;
  yp:=0;

  For i:=1 to Length(text) do
   begin
    if text[i]=#13 then
     begin
      xp:=0;
      yp:=yp+hchar;
      continue;
     end;
    px:=Ord(text[i]) mod 16;
    py:=Ord(text[i]) div 16;
    px:=px+1;
    py:=py+1;
     glBegin(GL_QUADS);
      glTexCoord2f((px-1)/16, (py-1)/16); glVertex3f(xp,       yp,       0);
      glTexCoord2f(px/16,     (py-1)/16); glVertex3f(xp+wchar, yp,       0);
      glTexCoord2f(px/16,     py/16);     glVertex3f(xp+wchar, yp+hchar, 0);
      glTexCoord2f((px-1)/16, py/16);     glVertex3f(xp,       yp+hchar, 0);
     glEnd;
    xp:=xp+wchar;
   end;

 glPopMatrix();
 glDisable(GL_TEXTURE_2D);
end;

procedure TGLEngine.Triangle(x1, y1, x2, y2, x3, y3: single);
begin
 glBegin(GL_TRIANGLES);
  glVertex3d(x1,y1,0);
  glVertex3d(x2,y2,0);
  glVertex3d(x3,y3,0);
 glEnd();
end;

procedure TGLEngine.TriangleGrad(x1, y1, x2, y2, x3, y3: single; c1, c2,
  c3: TGLColor);
begin
 glBegin(GL_TRIANGLES);
  glColor4f(c1.Red,c1.Green,c1.Blue,c1.alpha);
  glVertex3d(x1,y1,0);
  glColor4f(c2.Red,c2.Green,c2.Blue,c2.alpha);
  glVertex3d(x2,y2,0);
  glColor4f(c3.Red,c3.Green,c3.Blue,c3.alpha);
  glVertex3d(x3,y3,0);
 glEnd();
end;

procedure TGLEngine.VisualDone;
begin
 VBOSprite.Destroy;
 KillFont;
 wglMakeCurrent(0,0);
 wglDeleteContext(hrcvis);
end;

procedure  TGLEngine.GetPixelFormat(AASamples : Integer );
const
  WGL_SAMPLE_BUFFERS_ARB = $2041;
  WGL_SAMPLES_ARB           = $2042;
  WGL_DRAW_TO_WINDOW_ARB = $2001;
  WGL_SUPPORT_OPENGL_ARB = $2010;
  WGL_DOUBLE_BUFFER_ARB  = $2011;
  WGL_COLOR_BITS_ARB     = $2014;
  WGL_DEPTH_BITS_ARB     = $2022;
  WGL_STENCIL_BITS_ARB   = $2023;
var

  wglChoosePixelFormatARB:
  function  (hdc: HDC;
             const piAttribIList: PGLint;
             const pfAttribFList: PGLfloat;
             nMaxFormats: GLuint;
             piFormats: PGLint;
             nNumFormats: PGLuint): BOOL; stdcall;

  fAttributes: array [0..1] of Single;
  iAttributes: array [0..21] of Integer;
  pfd        : PIXELFORMATDESCRIPTOR;
//  iFormat    : Integer;
  hwnd       : Cardinal;
  wnd        : TWndClassEx;
  numFormats : Cardinal;
  Format     : Integer;
  DC:Hdc;
begin
if AASamples>0 then
begin
  ZeroMemory(@wnd, SizeOf(wnd));
  with wnd do
  begin
    cbSize        := SizeOf(wnd);
    lpfnWndProc   := @DefWindowProc;
    hCursor       := LoadCursor(0, IDC_ARROW);
    lpszClassName := 'GetPixelFormat';
  end;
  RegisterClassEx(wnd);
  hwnd := CreateWindow('GetPixelFormat', nil, WS_POPUP, 0, 0, 0, 0, 0, 0, HInstance, nil);
  DC := GetDC(hwnd);
  FillChar(pfd, SizeOf(pfd), 0);
  with pfd do
  begin
    nSize        := SizeOf(TPIXELFORMATDESCRIPTOR);
    nVersion     := 1;
    dwFlags      := PFD_DRAW_TO_WINDOW or
                    PFD_SUPPORT_OPENGL or
                    PFD_DOUBLEBUFFER;
    iPixelType   := PFD_TYPE_RGBA;
    cColorBits   := 32;
    cDepthBits   := 24;
    cStencilBits := 8;
    iLayerType   := PFD_MAIN_PLANE;
  end;
  SetPixelFormat(DC, ChoosePixelFormat(DC, @pfd), @pfd);
  wglMakeCurrent(DC, wglCreateContext(DC));
{  fAttributes[0]  := 0;
  fAttributes[1]  := 0;
  iAttributes[0]  := WGL_DRAW_TO_WINDOW_ARB;
  iAttributes[1]  := 1;
  iAttributes[2]  := WGL_SUPPORT_OPENGL_ARB;
  iAttributes[3]  := 1;
  iAttributes[4]  := WGL_SAMPLE_BUFFERS_ARB;
  iAttributes[5]  := 1;
  iAttributes[6]  := WGL_SAMPLES_ARB;
  //iAttributes[7]:= calc;
  iAttributes[8]  := WGL_DOUBLE_BUFFER_ARB;
  iAttributes[9]  := 1;
  iAttributes[10] := WGL_COLOR_BITS_ARB;
  iAttributes[11] := 24;
  iAttributes[12] := WGL_DEPTH_BITS_ARB;
  iAttributes[13] := 24;
  iAttributes[14] := WGL_STENCIL_BITS_ARB;
  iAttributes[15] := 8;
  iAttributes[16] := 0;
  iAttributes[17] := 0;  }

  fAttributes[0] := 0;
  fAttributes[1] := 0;
//  SetLength(iAttributes,22);
  iAttributes[0] := WGL_DRAW_TO_WINDOW_ARB;
  iAttributes[1] := 1;
  iAttributes[2] := WGL_SUPPORT_OPENGL_ARB;
  iAttributes[3] := 1;
  iAttributes[4] := WGL_ACCELERATION_ARB;
  iAttributes[5] := WGL_FULL_ACCELERATION_ARB;
  iAttributes[6] := WGL_COLOR_BITS_ARB;
  iAttributes[7] := 24;
  iAttributes[8] := WGL_ALPHA_BITS_ARB;
  iAttributes[9] := 8;
  iAttributes[10] := WGL_DEPTH_BITS_ARB;
  iAttributes[11] := 16;
  iAttributes[12] := WGL_STENCIL_BITS_ARB;
  iAttributes[13] := 0;
  iAttributes[14] := WGL_DOUBLE_BUFFER_ARB;
  iAttributes[15] := 1;
  iAttributes[16] := WGL_SAMPLE_BUFFERS_ARB;
  iAttributes[17] := 1;
  iAttributes[18] := WGL_SAMPLES_ARB;
  iAttributes[19] := AASamples;
  iAttributes[20] := 0;
  iAttributes[21] := 0;
  wglChoosePixelFormatARB := wglGetProcAddress('wglChoosePixelFormatARB');
 // iAttributes[7] := AASamples;
  if wglChoosePixelFormatARB(GetDC(hWnd), @iattributes, @fattributes, 1, @Format, @numFormats) and (numFormats >= 1) then
  begin
    AAFormat := Format;
  end;
  ReleaseDC(hwnd, DC);
  DestroyWindow(hwnd);
  wglMakeCurrent(0, 0);
  wglDeleteContext(DC);
end;  
end;

procedure TGLEngine.SetDCPixelFormat (dc : HDC);
var
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);

 // With pfd do begin
 pfd.dwFlags   := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;

                 pfd.nVersion:=1;
 pfd.dwFlags:=PFD_DOUBLEBUFFER+PFD_SUPPORT_OPENGL+PFD_DRAW_TO_WINDOW;
 pfd.iPixelType:=PFD_TYPE_RGBA;
 pfd.cColorBits:=  24;
// pfd.cAlphaBits:=  64;
// pfd.cAccumBits:=  64;
// pfd.cDepthBits:=  32;
// pfd.cStencilBits:=64;
 pfd.iLayerType:=PFD_MAIN_PLANE;

 //   cDepthBits:= 24;
 // end;

  if (AAFormat > 0) then
   nPixelFormat := AAFormat
  else
   nPixelFormat := ChoosePixelFormat(DC, @pfd);

  SetPixelFormat(DC, nPixelFormat, @pfd);
end;

procedure TGLEngine.VisualInit(dc: HDC; width, height: word;AntiAlias:integer);
var
 QW:int64;
 rc0:HGLRC;
begin
 NeedScreenShot:=false;
 GetPixelFormat(AntiAlias);
 SetDCPixelFormat(DC);
 rc0:=wglCreateContext(DC);
 ActivateRenderingContext(DC, rc0);
{ glMatrixMode(GL_PROJECTION);
 glLoadIdentity();
 glOrtho (0, width, height, 0, -100,100 );
 glViewport(0, 0, width, height);
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity();   }

 dcvis:=dc;
 hrcvis:=rc0;
 //glDisable ( GL_SCISSOR_TEST);
  resize(width,height);
 glEnable(GL_ALPHA_TEST);
 glEnable(GL_BLEND);
 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
 glShadeModel(GL_SMOOTH);
 SetTextStyle('Courier New',12);
 QueryPerformanceFrequency(QW);
 ClockRate:=qw;
 QueryPerformanceCounter(TimeDraw);
 DrawFrameCount:=0;
 glGenFramebuffersEXT(1, @FrameBuffer);
 toFrameBufer:=false;
 VBOSprite:=TVBOSprite.Create;
end;

procedure TGLEngine.Bolt(x1, y1, x2, y2: single);
const
 d=20;
var
 lx,ly,lxo,lyo:real;
 dlx,dly:real;
 i:integer;
begin
 lx:=x1;
 ly:=y1;
 dlx:=(x2-x1)/d;
 dly:=(y2-y1)/d;
 For i:=1 to d-1 do
  begin
   lxo:=lx; lyo:=ly;
   lx:=lx+dlx+1-random(3);
   ly:=ly+dly+1-random(3);
   Line(lxo,lyo,lx,ly);
 end ;
  Line(lx,ly,x2,y2);
end;

procedure TGLEngine.Arrow(x1, y1, x2, y2, size,angle: single;Solid:Boolean);
var
 A:single;
 x3,y3,x4,y4:single;
begin
 Line(x1,y1,x2,y2);
 A:=180*ArcTan2(y2-y1,x2-x1)/pi;
 x3:= X2+Round(size*cos(pi*(A+(180-angle))/180));
 y3:= Y2+Round(size*sin(pi*(A+(180-angle))/180));
 x4:= X2+Round(size*cos(pi*(A-(180-angle))/180));
 y4:= Y2+Round(size*sin(pi*(A-(180-angle))/180));
 If not Solid then
  begin
   Line(x2,y2,x3,y3);
   Line(x2,y2,x4,y4);
  end
  else
  Triangle(x2,y2,x3,y3,x4,y4);
end;

procedure TGLEngine.AntiAlias(Enable: boolean);
begin
if Enable then
  glEnable(GL_MULTISAMPLE_ARB)
 else
  glDisable(GL_MULTISAMPLE_ARB)
end;

procedure TGLEngine.Resize(w, h: integer);
begin
{ if (Height=0) then		                                  // Zabezpeøený proti dülený nulou
     Height:=1;                                           // Nastavý v¤Úku na jedna
  glViewport(0, 0, Width, Height);                        // Resetuje aktuñlný nastavený
  glMatrixMode(GL_PROJECTION);                            // Zvolý projekøný matici
  glLoadIdentity();                                       // Reset matice
  gluPerspective(45.0,Width/Height,0.1,100.0);            // V¤poøet perspektivy
  glMatrixMode(GL_MODELVIEW);                             // Zvolý matici Modelview
  glLoadIdentity;   }

  self.w:=w;
  self.h:=h;

if dcvis<>0 then
 begin
  wglMakeCurrent(dcvis,hrcvis);
  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho (0, w, h, 0, -100,100 );
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
//  wglMakeCurrent(0,0);
 end;
end;

procedure TGLEngine.LoadAnimation(FileName: string; w,h,dw,dh:integer; var An: TGLAnim; LoadFromRes : Boolean);
begin
 if copy(Uppercase(filename), length(filename)-3, 4) = '.BMP' then
  LoadBMPTexture(Filename, An.Tex, LoadFromRes);
 if copy(Uppercase(filename), length(filename)-3, 4) = '.JPG' then
  LoadJPGTexture(Filename, An.Tex, LoadFromRes);
 if copy(Uppercase(filename), length(filename)-3, 4) = '.TGA' then
  LoadTGATexture(Filename, An.Tex, LoadFromRes);
 if copy(Uppercase(filename), length(filename)-3, 4) = '.PNG' then
  LoadPNGTexture(Filename, An.Tex, LoadFromRes);
 an.curFrame:=0;
 an.dw:=dw;
 an.dh:=dh;
 an.Width:=w;
 an.Height:=h;
 an.cols:=an.Width div an.dw;
 an.rows:= an.Height div an.dh;
end;

procedure TGLEngine.DrawAniFrame(x,y,angle:single; var An: TGLAnim);
begin
 glBindTexture(GL_TEXTURE_2D, An.Tex);
 glEnable(GL_TEXTURE_2D);
 glPushMatrix();
 glTranslated(x,y,0);
 glRotatef(Angle, 0,0,1);
  { glTexCoord2f(0,0); glVertex3f(-pWidth/2, -pHeight/2, -pZ);
   glTexCoord2f(1,0); glVertex3f(pWidth/2, -pHeight/2, -pZ);
   glTexCoord2f(1,1); glVertex3f(pWidth/2, pHeight/2, -pZ);
   glTexCoord2f(0,1); glVertex3f(-pWidth/2,pHeight/2, -pZ);   }
glBegin(GL_QUADS);
 glTexCoord2f(an.AnimX,           1-an.AnimY-1/an.Rows);  glVertex3f(-an.dw/2, -an.dw/2, 0);
 glTexCoord2f(an.AnimX+1/an.Cols, 1-an.AnimY-1/an.Rows);  glVertex3f( an.dw/2, -an.dw/2, 0);
 glTexCoord2f(an.AnimX+1/an.Cols, 1-an.AnimY);            glVertex3f( an.dw/2,  an.dw/2, 0);
 glTexCoord2f(an.AnimX,           1-an.AnimY);            glVertex3f(-an.dw/2,  an.dw/2, 0);
glEnd;

an.AnimPos := an.AnimPos + 2;
if an.AnimPos > 1 then
 begin
 an.AnimX   := an.AnimX + 1/an.Cols;
 an.AnimPos := 0;
 end;
if an.AnimX >= 1 then
 begin
 an.AnimY := an.AnimY + 1/an.Rows;
 an.AnimX := 0;
 end;
if an.AnimY >= 1 then
 begin
 an.AnimX := 0;
 an.AnimY := 0;
 end;

 glPopMatrix();
 glDisable(GL_TEXTURE_2D);
end;

procedure TGLEngine.SwichBlendMode(sfactor, dfactor: TGLEnum);
begin
 glBlendFunc(sfactor, dfactor);
end;

procedure TGLEngine.SwichBlendMode(BlendMode: TGLBlendMode);
begin
{ TGLBlendMode=(bmAdd,bmNormal,bmMultiply,bmSrc2Dst,bmAddMul);
 switch (m.blend)

  case BLEND_ADD: glBlendFunc(GL_ONE, GL_ONE); break;
  case BLEND_MULTIPLY: glBlendFunc(GL_DST_COLOR, GL_ZERO); break;
  case BLEND_SRC2DST: glBlendFunc(GL_SRC_COLOR, GL_ONE); break;
  case BLEND_ADDMUL: glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE); break;

}
 case BlendMode of
  bmAdd2:     glBlendFunc(GL_ONE, GL_ONE);
  bmSrc2Dst:  glBlendFunc(GL_SRC_COLOR, GL_ONE);
  bmMultiply: glBlendFunc(GL_DST_COLOR, GL_ZERO);
  bmAddMul:   glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
  bmAdd:      glBlendFunc(GL_SRC_ALPHA, GL_ONE);
  bmNormal:   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
 end;
end;

procedure TGLEngine.AddBMPImage(Bmp: TBitMap; var Texture: Cardinal);
var
  Data : Array of LongWord;
  W, Width : Integer;
  H, Height : Integer;
  C : LongWord;
  Line : ^LongWord;
begin
 Width :=BMP.Width;
 Height :=BMP.Height;
 SetLength(Data, Width*Height);
 For H:=0 to Height-1 do
  Begin
   Line :=BMP.scanline[Height-H-1];
   For W:=0 to Width-1 do
    Begin
     c:=Line^ and $FFFFFF; // Need to do a color swap
     Data[W+(H*Width)] :=(((c and $FF) shl 16)+(c shr 16)+(c and $FF00)) or $FF000000;  // 4 channel.
     inc(Line);
    End;
  End;
 Texture :=CreateTexture(Width, Height, GL_RGBA, addr(Data[0]));
end;

function TGLEngine.GetFPS: integer;
begin
 Result:=RealFPS;
// Result := 1000/GetTimeDrawFrame;
end;

function TGLEngine.GetTimeDrawFrame: double;
begin
 Result := 1000.0 * (EndDrawTime - StartDrawTime) / ClockRate;
end;

procedure TGLEngine.FreeImage(var Texture: Cardinal);
begin
 glDeleteTextures(1, @Texture);
// Imaging.FreeImage(SpriteImage);
end;

Function BitMapInfoHeaderTo_BMP ( Header:PBITMAPINFOHEADER;lpbi:pointer ):tBitmap;
VAR
 hBmp        : HBITMAP;
 lpbiWanted  : pBitmapInfoHeader;
 dc          : HDC;
 bits        : pChar;
 bmp          : TBitmap;
Begin
 bmp := tBitmap.Create;
 bits := lpbi;
 dc := getDc(0);
 hBmp := CreateDIBitmap(dc,Header^, CBM_INIT, bits, PBITMAPINFO(Header)^, DIB_RGB_COLORS );
 bmp.handle := hBmp;
 result := bmp;
 releaseDc ( 0,dc );
End;

procedure TGLEngine.SaveImage(FileName: string; var Texture: Cardinal);
type
 TRGBAArray = ARRAY[Word] of TRGBQuad;
 pRGBAArray = ^TRGBAArray;
var
 //F   : integer;
 pix,t : pRGBAArray;
 c:TRGBQuad;
 bmp:tbitmap;
 Width,Height:integer;
 i,j:integer;
begin
  glBindTexture(GL_TEXTURE_2D, Texture);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @Height);
  GetMem(pix, Width * Height * 4);
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE,  pix);

  bmp:=TBitMap.Create;
  bmp.PixelFormat:=pf32bit;
  bmp.Width:=Width;
  bmp.Height:= Height;

  for i:=0 to Height-1 do
  begin
  t:=  bmp.ScanLine[Height-i-1];
   for j:=0 to Width-1 do
   begin
    c.rgbBlue:= TRGBQuad(pix^[i*Width+j]).rgbRed;
    c.rgbGreen:= TRGBQuad(pix^[i*Width+j]).rgbGreen;
    c.rgbRed:= TRGBQuad(pix^[i*Width+j]).rgbBlue;
    c.rgbReserved:= TRGBQuad(pix^[i*Width+j]).rgbReserved;
    t[j]:=c;
   end;
  end;
  bmp.SaveToFile(FileName);
  bmp.Free;
  FreeMem(pix);
end;

procedure TGLEngine.SaveImageAsPNG(Filename: String; Im: Cardinal);
type
 TRGBAArray = ARRAY[Word] of TRGBQuad;
 pRGBAArray = ^TRGBAArray;
var
  pix : pRGBAArray;
  W, Width : Integer;
  H, Height : Integer;
  png: TPNGObject;
  pb: PByteArray;
  ResStream : TResourceStream;      // used for loading from resource
begin
  glBindTexture(GL_TEXTURE_2D, im);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @Height);
  GetMem(pix, Width * Height * 4);
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE,  pix);

  png := TPNGObject.CreateBlank(COLOR_RGBALPHA,8,Width,Height);
//  png.LoadFromFile(FileName);


 // SetLength(Data, Width*Height*4);

  For H:=0 to Height-1 do
  Begin
   pb:=png.Scanline[Height-H-1];
    For W:=0 to Width-1 do
    Begin
      {Data[il] :=pb[W*3+2];
      Data[il+1] :=pb[W*3+1];
      Data[il+2] :=pb[W*3];
      Data[il+3] :=png.AlphaScanline[H][W] ;
      inc(il,4);    }
      pb[W*3+2]:=TRGBQuad(pix^[H*Width+W]).rgbRed;
      pb[W*3+1]:=TRGBQuad(pix^[H*Width+W]).rgbGreen;
      pb[W*3]:=TRGBQuad(pix^[H*Width+W]).rgbBlue;
      png.AlphaScanline[Height-H-1][W]:=TRGBQuad(pix^[H*Width+W]).rgbReserved;
    End;
  End;
  png.SaveToFile(Filename);
  png.Free;
  //Texture :=CreateTexture(Width, Height, GL_RGBA, addr(Data[0]));
end;

procedure TGLEngine.GetBMP32FromImage(Im: Cardinal; var BMP32: TBitMap);
type
 TRGBAArray = ARRAY[Word] of TRGBQuad;
 pRGBAArray = ^TRGBAArray;
var
 t : pRGBAArray;
// c:TRGBQuad;
 Width,Height:integer;
// i,j:integer;
begin

  glBindTexture(GL_TEXTURE_2D, Im);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @Height);
  bmp32.PixelFormat:=pf32bit;
  bmp32.Width:=Width;
  bmp32.Height:= Height;
  t:=  bmp32.ScanLine[height-1];
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE,  t);

 // bmp:=TBitMap.Create;


 ////////////////////////////
// t:=  bmp32.ScanLine[height-1];
//  for i:=0 to Height-1 do
// Move(pix^[0],t^,Width * Height * 4);
 //  t:=pix;
 //  SwapRGB(t, Width*Height);

  flipIt(t,Width,  Height );
/////////////////////////////

{  for i:=0 to Height-1 do
  begin
  t:=  bmp32.ScanLine[Height-i-1];
   for j:=0 to Width-1 do
   begin
    c.rgbBlue:= TRGBQuad(pix^[i*Width+j]).rgbRed;
    c.rgbGreen:= TRGBQuad(pix^[i*Width+j]).rgbGreen;
    c.rgbRed:= TRGBQuad(pix^[i*Width+j]).rgbBlue;
    c.rgbReserved:= TRGBQuad(pix^[i*Width+j]).rgbReserved;
    t[j]:=c;
   end;
 //  sleep(1);
  end;   }
//  bmp.SaveToFile(FileName);
//  bmp.Free;

end;

{
procedure TGLEngine.LoadGifAnimation(FileName: string; var An: TGLGifAnim);
begin
 An.GifImage:=TGifImage.Create;
 An.GifImage.LoadFromFile(FileName);
 An.curFrame:=0;
 InternalGetDIBSizes(An.GifImage.Images[0].Bitmap.Handle, An.BitmapInfoSize, An.BitmapSize, pf8bit);
 An.count:=An.GifImage.Images.Count;
end;



procedure TGLEngine.DrawGifFrame(x, y, angle: single; var An: TGLGifAnim);
var
 bmp:Tbitmap;
 BitmapInfo		: PBitmapInfoHeader;
 BitmapBits		: pointer;
begin
 GetMem(BitmapInfo, an.BitmapInfoSize);
 GetMem(BitmapBits, an.BitmapSize);
 InternalGetDIB(An.GifImage.Images[an.curFrame].Bitmap.Handle, 0, BitmapInfo^, BitmapBits^, pf8bit);
 bmp:= BitMapInfoHeaderTo_BMP(BitmapInfo,BitmapBits);
 AddBMPImage(bmp,an.Tex);
 DrawImage(x,y,An.GifImage.Width,An.GifImage.Height, 0,true,false,an.Tex);
 self.FreeImage(an.Tex);
 bmp.Free;
 if (BitmapInfo <> nil) then
  FreeMem(BitmapInfo);
 if (BitmapBits <> nil) then
  FreeMem(BitmapBits);
 an.curFrame:=an.curFrame+1;
 if an.curFrame>=an.count then
  an.curFrame:=0;
end;                   }

procedure TGLEngine.BeginRenderToTex(Image: Cardinal; w,h:glint);
begin
{  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, Image);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA,
    GL_UNSIGNED_BYTE, nil);

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FrameBuffer);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT,
    GL_TEXTURE_2D, Image, 0);
  glPushAttrib(GL_VIEWPORT_BIT);
  glViewport(0, 0, w, h);

  glPushMatrix;
  glLoadIdentity;
   toFrameBufer:=true;
 glDisable(GL_TEXTURE_2D);    }

 glPushMatrix;
 glViewport(0, 0, w, h);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho (0, w, 0, h, -100,100 );
  glMatrixMode(GL_MODELVIEW);

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, Image);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA,
    GL_UNSIGNED_BYTE, nil);

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FrameBuffer);
  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT,
    GL_TEXTURE_2D, Image, 0);
    glDisable(GL_TEXTURE_2D);
end;

procedure TGLEngine.EndRenderToTex;
begin
{ glPopMatrix;
 glPopAttrib;
 glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
 toFrameBufer:=false;
 glDisable(GL_TEXTURE_2D);}
 glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT,
    GL_TEXTURE_2D, 0, 0);
 glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
 toFrameBufer:=false;
 glBindTexture(GL_TEXTURE_2D, 0);

 glViewport(0, 0, w, h);

 glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho (0, w, h, 0, -100,100 );
  glMatrixMode(GL_MODELVIEW);
 glPopMatrix;


end;

procedure TGLEngine.Rectangle(x1, y1, x2, y2: single);
begin
 glBegin(GL_LINES);
  glVertex3d(x1,y1,0);
  glVertex3d(x2,y1,0);
  glVertex3d(x2,y2,0);
  glVertex3d(x1,y2,0);
  glVertex3d(x1,y2,0);
  glVertex3d(x1,y1,0);
  glVertex3d(x2,y2,0);
  glVertex3d(x2,y1,0);
 glEnd();
end;

function TGLEngine.CreateImage(w, h: integer): Cardinal;
var
 textureId:Cardinal;
begin
 glGenTextures(1, @textureId);
 glBindTexture(GL_TEXTURE_2D, textureId);
 glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
 glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
// glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
// glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
// glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE); // automatic mipmap
 glGenerateMipmap(textureId);
 glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, w, h, 0,
             GL_RGBA, GL_UNSIGNED_BYTE, nil);
 glBindTexture(GL_TEXTURE_2D, 0);
  result :=textureId;
end;

procedure TGLEngine.Clear;
begin
 glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glLoadIdentity;
end;

function TGLEngine.ShaderCreate(FragmentShaderFileName,
  VertexShaderFileName: String): Integer;
var
  ProgramObject, FragmentShaderObject, VertexShaderObject: GLHandleARB;
  FShader: TStringList;
  FShaderText: String;
  FShaderLength: Integer;
  VShader: TStringList;
  VShaderText: String;
  VShaderLength: Integer;
begin
 if FileExists(FragmentShaderFileName) then
  if FileExists(VertexShaderFileName) then
   begin
    ProgramObject:= glCreateProgramObjectARB;

    FragmentShaderObject:= glCreateShaderObjectARB(GL_FRAGMENT_SHADER_ARB);
    VertexShaderObject:= glCreateShaderObjectARB(GL_VERTEX_SHADER_ARB);

    FShader:= TStringList.Create;
    FShader.LoadFromFile(FragmentShaderFileName);
    FShaderText:= FShader.Text;
    FShader.Free;
    FShaderLength:= Length(FShaderText);

    VShader:= TStringList.Create;
    VShader.LoadFromFile(VertexShaderFileName);
    VShaderText:= VShader.Text;
    VShader.Free;
    VShaderLength:= Length(VShaderText);

    glShaderSourceARB(VertexShaderObject, 1, @VShaderText, @VShaderLength);
    glShaderSourceARB(FragmentShaderObject, 1, @FShaderText, @FShaderLength);

    glCompileShaderARB(FragmentShaderObject);
    glCompileShaderARB(VertexShaderObject);
 //ShowMessage(CheckForErrors(FragmentShaderObject));

    glAttachObjectARB(ProgramObject, FragmentShaderObject);
    glAttachObjectARB(ProgramObject, VertexShaderObject);

    glDeleteObjectARB(FragmentShaderObject);
    glDeleteObjectARB(VertexShaderObject);
    glLinkProgramARB(ProgramObject);

    Result:= ProgramObject;
   end
end;

procedure TGLEngine.ShaderStart(Shader: Integer);
begin
 glUseProgramObjectARB(Shader)
end;

procedure TGLEngine.ShaderStop(Shader: Integer);
begin
 glUseProgramObjectARB(0)
end;

function TGLEngine.ShaderGetUniform(Shader: Integer;
  uniform: PAnsiChar): GLuint;
begin
 Result := 0;
 if not GL_ARB_shading_language_100 then exit;
  Result := glGetUniformLocationARB(Shader, uniform);
end;

procedure TGLEngine.ShaderSetUniform(Shader: Integer; uniform: GLuint;
  value0: Integer);
begin
 if not GL_ARB_shading_language_100 then exit;
  glUniform1iARB(uniform, value0);
end;

procedure TGLEngine.ShaderSetUniform(Shader: Integer; uniform: GLuint;
  value0: Single);
begin
 if not GL_ARB_shading_language_100 then exit;
  glUniform1fARB(uniform, value0);
end;

procedure TGLEngine.VertSynh(Enable: boolean);
begin
 wglSwapIntervalEXT(ord(Enable));
end;

procedure TGLEngine.DrawCurrentImage2(x, y, w, h, Angle: single; Center,
 tile: boolean);
begin
 VBOSprite.add(x,y,w,h);
end;

procedure TGLEngine.Polygon(x,y,AngleRotate,TextureAngleRotate:single; n: array of TGLPoint);
var
 i:integer;
begin
glPushMatrix();

 glMatrixMode(GL_TEXTURE);
 glRotatef(TextureAngleRotate,0,0,1);
 glMatrixMode(GL_MODELVIEW);

 glTranslated(x,y,0);
 glRotatef(AngleRotate, 0,0,1);
  glBegin(GL_POLYGON);
// glBegin(GL_TRIANGLE_FAN );
  For i:=0 to High(n)  do
   glVertex3d(n[i].x,n[i].y,0);
  glEnd();
glPopMatrix();

end;

function TGLEngine.GetGLEngineHeight: word;
begin
 result:=h;
end;

function TGLEngine.GetGLEngineWidth: word;
begin
 result:=w;
end;

{::cain}
procedure TGLEngine.PolygonTess( x, y, AngleRotate: single; n: array of TGLPoint );
var
 i:integer;
 vvv : array of TVector3d;
 tglutessobj : pGLUtesselator;
begin
 glPushMatrix();
 tglutessobj := glunewtess;
 gluTessCallback( tglutessobj, GLU_TESS_BEGIN, @glBegin );
 gluTessCallback( tglutessobj, GLU_TESS_VERTEX, @glVertex3dv );
 gluTessCallback( tglutessobj, GLU_TESS_END, @glEnd );

 SetLength( vvv, Length( n ) );

 glTranslated(x,y,0);
 glRotatef(AngleRotate, 0,0,1);

 glNewList(1, GL_COMPILE);

 gluTessBeginPolygon ( tglutessobj, nil );
  For i:=0 to High( n )  do
   begin
    vvv[ i ][ 0 ] := n[ i ].x;
    vvv[ i ][ 1 ] := n[ i ].y;
    vvv[ i ][ 2 ] := 0;
    gluTessVertex(tglutessobj, vvv[ i ], @vvv[ i ] );
   end ;
 gluTessEndPolygon( tglutessobj );
 glEndList;

 glCallList( 1 );
 glDeleteLists( 1, 1 );

 gluDeleteTess( tglutessobj );
 SetLength( vvv, 0 );

 glPopMatrix();
end;
{cain::}

Procedure myVertex(outVertex:TVector3d); stdcall;
 begin
  messagebox(0,PChar(FloatToStr(outVertex[0])),'test',0);
 end;

procedure TGLEngine.Tesselate(var inVertexArray,
  outVertexArray: array of TGLPoint);
var
 tobj : pGLUtesselator;
 inv,outv : array of TVector3d;
 i:integer;
begin
  tobj := gluNewTess();
  SetLength( inv, Length( inVertexArray ) );
  SetLength( outv, Length( inVertexArray ) );

  For i:=0 to High( inVertexArray )  do
   begin
    inv[ i ][ 0 ] := inVertexArray[ i ].x;
    inv[ i ][ 1 ] := inVertexArray[ i ].y;
    inv[ i ][ 2 ] := 0;
   end ;

 gluTessCallback( tobj, GLU_TESS_BEGIN, nil );
 gluTessCallback( tobj, GLU_TESS_VERTEX, @myVertex );
 gluTessCallback( tobj, GLU_TESS_END, nil );

   gluTessBeginPolygon(tobj, 0);
      gluTessBeginContour(tobj);

      For i:=0 to High( inVertexArray )  do
       gluTessVertex(tobj, inv[ i ], @inv[ i ] );

    gluTessEndContour(tobj);
   gluTessEndPolygon(tobj);

   For i:=0 to High( inVertexArray )  do
   begin
    outVertexArray[ i ].x:= inv[ i ][ 0 ];
    outVertexArray[ i ].y:= inv[ i ][ 1 ];
   end ;

end;

procedure TGLEngine.PolygonFromArray(x, y, AngleRotate: single;
  n: array of TGLPoint);
var
 i:integer;
begin
 glPushMatrix();
 glTranslated(x,y,0);
 glRotatef(AngleRotate, 0,0,1);
 //  glBegin(GL_POLYGON);
 glBegin(GL_TRIANGLE_FAN );
  For i:=0 to High(n)  do
   glVertex3d(n[i].x,n[i].y,0);
  glEnd();
 glPopMatrix();
end;

procedure TGLEngine.PolygonTexture(x, y, AngleRotate,TexAngle: single; Trans, Scale: TGLPoint; vertex,
  tex: array of TGLPoint; image: Cardinal);
var
 i:integer;  
begin
glPushMatrix();

 glBindTexture(GL_TEXTURE_2D, Image);
 glEnable(GL_TEXTURE_2D);

 glMatrixMode(GL_TEXTURE);
 glLoadIdentity();

 glTranslated(0.5,0.5,0);
  glRotatef(TexAngle,0,0,1);
 glTranslated(-0.5,-0.5,0); 

 glTranslated(Trans.x,Trans.y,0);
 glScalef(Scale.x,Scale.y,0);

 glMatrixMode(GL_MODELVIEW);

 glTranslated(x,y,0);
 glRotatef(AngleRotate, 0,0,1);
  glBegin(GL_POLYGON);
// glBegin(GL_TRIANGLE_FAN );
  For i:=0 to High(vertex)  do
  begin
   glTexCoord3d(tex[i].x,tex[i].y,0);
   glVertex3d(vertex[i].x,vertex[i].y,0);
  end;
  glEnd();
  glDisable(GL_TEXTURE_2D);
glPopMatrix();
end;

procedure TGLEngine.GetImageHeight(image: cardinal; var h:Integer);
begin
 glBindTexture(GL_TEXTURE_2D, image);
 glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @h);
end;

procedure TGLEngine.GetImageWidth(image: cardinal; var w:Integer);
begin
 glBindTexture(GL_TEXTURE_2D, image);
 glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @w);
end;

procedure TGLEngine.ScreenShot(var BMP: TBitMap; AWidth, AHeight: integer);
begin
 // ñîõðàíèò â BMP !ÑËÅÄÓÞÙÈÉ! êàäð! 
 needScreenShot:=true;
 scs_BMP:=BMP;
 scs_AWidth:= AWidth;
 scs_AHeight:= AHeight;
end;

procedure TGLEngine._ScreenShot(var BMP: TBitMap;AWidth,AHeight:integer);
var
  LPixels: array of Byte;
  Index: Integer;
  p1, p2: pointer;
begin
  try
    BMP.PixelFormat := pf24bit;
    BMP.Height := AHeight;
    BMP.Width := AWidth;

    SetLength(LPixels, AWidth * AHeight * 3);
    glReadBuffer(GL_BACK); //GL_FRONT     GL_BACK
    glReadPixels(0, 0, AWidth, AHeight, GL_BGR, GL_UNSIGNED_BYTE, @LPixels[0]);
    for Index := 0 to AHeight -1 do
     begin
      p1 := BMP.ScanLine[AHeight -1-Index];
      p2 := pointer( integer(LPixels)+ (Index * BMP.Width * 3));
      CopyMemory( p1, p2, BMP.Width * 3);
     end;
  finally
  end;

end;

{------------------------------------------------------------------}
{  Load/Save GL textures by aliday a@kubado.ru                     }
{------------------------------------------------------------------}

type
  TCreateTextureParams = record
    Width, Height, Format : Word;
  end;

function TGLEngine.LoadRAWTexture(Filename: String; var Texture: Cardinal;
  LoadFromResource: Boolean): Boolean;
var
  RAWFile: File;
  RawLength: LongWord;
  pData : Pointer;
  CreateTextureParams: TCreateTextureParams;
  // used for loading from resource
  ResStream : TResourceStream;
begin
  if LoadFromResource then // Load from resource
  begin
    try
      ResStream := TResourceStream.Create(hInstance, PChar(copy(Filename, 1, Pos('.', Filename)-1)), 'GL');
      //RawLength := StreamSize(RAWFile) - SizeOf(CreateTextureParams);
      GetMem(pData, RAWLength);
      ResStream.ReadBuffer(pData^, RawLength);            // RAW Data
      ResStream.ReadBuffer(CreateTextureParams, SizeOf(CreateTextureParams));  // FileHeader
      ResStream.Free;
    except on
      EResNotFound do
      begin
        MessageBox(0, PChar('File not found in resource - ' + Filename), PChar('GL Texture'), MB_OK);
        Exit;
      end
      else
      begin
        MessageBox(0, PChar('Unable to read from resource - ' + Filename), PChar('GL Unit'), MB_OK);
        Exit;
      end;
    end;
  end
  else
  begin
    AssignFile(RAWFile, Filename);
    Reset(RAWFile, 1);
    RawLength := FileSize(RAWFile) - SizeOf(CreateTextureParams);
    GetMem(pData, RawLength);
    BlockRead(RAWFile, pData^, RawLength);
    BlockRead(RAWFile, CreateTextureParams, SizeOf(CreateTextureParams));
  end;
  Texture :=CreateTexture(CreateTextureParams.Width, CreateTextureParams.Height, CreateTextureParams.Format, pData);
  FreeMem(pData);
  result :=TRUE;
end;

function TGLEngine.SaveRAWTexture(FileName: string; var Texture: Cardinal): Boolean;
var
  RAWFile: File;
  RawLength: LongWord;
  pData : Pointer;
  CreateTextureParams: TCreateTextureParams;
  Width,Height:integer;
begin
  glBindTexture(GL_TEXTURE_2D, Texture);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, @Width);
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, @Height);

  RawLength := Width * Height * 4;
  GetMem(pData, RawLength);
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE,  pData);

  CreateTextureParams.Width := Width;
  CreateTextureParams.Height := Height;
  CreateTextureParams.Format := GL_RGBA;

  AssignFile(RAWFile, Filename);
  Rewrite(RAWFile, 1);

  BlockWrite(RAWFile, pData^, RawLength);
  BlockWrite(RAWFile, CreateTextureParams, SizeOf(CreateTextureParams));
  CloseFile(RAWFile);

  FreeMem(pData);
  result :=TRUE;
end;

{ TVBOPrimitive }

procedure TVBOPrimitive.BuildVBOs;
begin
  glBindBufferARB(GL_ARRAY_BUFFER_ARB,m_nVBOVertices);
  glBufferDataARB(GL_ARRAY_BUFFER_ARB,m_nVertexCount * 3 * sizeof(glfloat),m_pVertices,GL_STATIC_DRAW_ARB);

  glBindBufferARB(GL_ARRAY_BUFFER_ARB,m_nVBOTexCoords);
  glBufferDataARB(GL_ARRAY_BUFFER_ARB,m_nVertexCount * 2 * sizeof(glfloat),m_pTexCoords,GL_STATIC_DRAW_ARB);

  SetLength(m_pVertices,0);
  SetLength(m_pTexCoords,0);
  m_pVertices := nil;
  m_pTexCoords := nil;
end;

constructor TVBOPrimitive.Create;
begin
  g_fVBOSupported := IsExtensionSupported('GL_ARB_vertex_buffer_object');
	m_pVertices := nil;
	m_pTexCoords := nil;
	m_nVertexCount := 0;
	m_nVBOVertices := 0;
  m_nVBOTexCoords := 0;
  glGenBuffersARB(1,@m_nVBOVertices);
  glGenBuffersARB(1,@m_nVBOTexCoords);
end;

destructor TVBOPrimitive.Destroy;
  var
  nBuffers: array [0..1] of GLuint;
begin

	if g_fVBOSupported then
	  begin
		nBuffers[0] := m_nVBOVertices;
    nBuffers[1] := m_nVBOTexCoords;
		glDeleteBuffersARB(2,@nBuffers);
	  end;

	if m_pVertices <> nil then
 		SetLength(m_pVertices,0);
	m_pVertices := nil;
	if m_pTexCoords <> nil then
 		SetLength(m_pTexCoords,0);
	m_pTexCoords := nil;
  inherited;
end;

procedure TVBOPrimitive.Draw;
begin
  BuildVBOs;
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  if g_fVBOSupported then
    begin
    glBindBufferARB(GL_ARRAY_BUFFER_ARB,m_nVBOVertices);
    glVertexPointer(3,GL_FLOAT,0,nil);
    glBindBufferARB(GL_ARRAY_BUFFER_ARB,m_nVBOTexCoords);
    glTexCoordPointer(2,GL_FLOAT,0,nil);
    end
    else
    begin
    glVertexPointer(3,GL_FLOAT,sizeof(CVert),m_pVertices);
    glTexCoordPointer(2,GL_FLOAT,sizeof(CTexCoord),m_pTexCoords);
    end;
  glDrawArrays(mode,0,m_nVertexCount);

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  if m_pVertices <> nil then
 		SetLength(m_pVertices,0);
	m_pVertices := nil;
	if m_pTexCoords <> nil then
 		SetLength(m_pTexCoords,0);
  m_nVertexCount:=0;

end;

function TVBOPrimitive.IsExtensionSupported(
  szTargetExtension: string): boolean;
var
  pszExtensions: string;
  pszWhere: integer;
begin
  pszWhere := Pos(' ',szTargetExtension);
  if (pszWhere <> 0) or (szTargetExtension = '') then
    begin
    Result := false;
    exit;
    end;
  pszExtensions := glGetString(GL_EXTENSIONS);
  if Pos(szTargetExtension,pszExtensions) = 0 then
    begin
    Result := false;
    exit;
    end;
  Result := true;
end;

{ TVBOSprite }

procedure TVBOSprite.add(x,y,w,h:single);
begin
 m_nVertexCount:=m_nVertexCount+4;
 SetLength(m_pVertices,m_nVertexCount);
 SetLength(m_pTexCoords,m_nVertexCount);

 m_pVertices[m_nVertexCount-4].x := x;
 m_pVertices[m_nVertexCount-4].y := y;
 m_pVertices[m_nVertexCount-4].z :=0;
 m_pTexCoords[m_nVertexCount-4].u := 0;
 m_pTexCoords[m_nVertexCount-4].v := 0;

 m_pVertices[m_nVertexCount-3].x := x+w;
 m_pVertices[m_nVertexCount-3].y := y;
 m_pVertices[m_nVertexCount-3].z :=0;
 m_pTexCoords[m_nVertexCount-3].u := 1;
 m_pTexCoords[m_nVertexCount-3].v := 0;

 m_pVertices[m_nVertexCount-2].x := x+w;
 m_pVertices[m_nVertexCount-2].y := y+h;
 m_pVertices[m_nVertexCount-2].z :=0;
 m_pTexCoords[m_nVertexCount-2].u := 1;
 m_pTexCoords[m_nVertexCount-2].v := 1;

 m_pVertices[m_nVertexCount-1].x := x;
 m_pVertices[m_nVertexCount-1].y := y+h;
 m_pVertices[m_nVertexCount-1].z :=0;
 m_pTexCoords[m_nVertexCount-1].u := 0;
 m_pTexCoords[m_nVertexCount-1].v := 1;
end;

constructor TVBOSprite.Create;
begin
  inherited;
  mode:= GL_QUADS;
end;

Initialization
 if not InitOpenGL then
  begin
   MessageBox(0,'Error init OpenGL','GLEngine2D Error',0);
   exit;
  end;
end.
