unit AcercaFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFAcerca = class(TForm)
    LayPrinc: TLayout;
    RectPrinc: TRectangle;
    LayAcerca: TLayout;
    LayNombre: TLayout;
    Label1: TLabel;
    LayVersion: TLayout;
    Label2: TLabel;
    LayImagen: TLayout;
    Image1: TImage;
    LayAutor: TLayout;
    Label3: TLabel;
    Layout5: TLayout;
    LayLugarFecha: TLayout;
    Label4: TLabel;
    Layout7: TLayout;
    BAceptar: TButton;
    LayMensaje: TLayout;
    Label5: TLabel;
    Rectangle: TRectangle;
    procedure BAceptarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAcerca: TFAcerca;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFAcerca.BAceptarClick(Sender: TObject);
begin
  Close;
end;

procedure TFAcerca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=TCloseAction.caFree;
end;

end.
