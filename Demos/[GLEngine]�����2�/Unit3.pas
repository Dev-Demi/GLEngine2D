unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, sLabel, sSkinProvider, sButton;

type
  TForm3 = class(TForm)
    sSkinProvider1: TsSkinProvider;
    sLabelFX1: TsLabelFX;
    sButton1: TsButton;
    procedure sButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.sButton1Click(Sender: TObject);
begin
 close
end;

end.
