unit Acerca;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Effects;

type
  TFrmAcerca = class(TFrame)
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
    Layout1: TLayout;
    LayLugarFecha: TLayout;
    Label4: TLabel;
    Layout2: TLayout;
    BAceptar: TButton;
    LayMensaje: TLayout;
    Label5: TLabel;
    Rectangle: TRectangle;
    RectFondo: TRectangle;
    ShadowEffect1: TShadowEffect;
    RectAceptar: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
