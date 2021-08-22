unit Acerca;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TFrAcerca = class(TFrame)
    Rectangle: TRectangle;
    LayAcerca: TLayout;
    LayNombre: TLayout;
    LayVersion: TLayout;
    LayImagen: TLayout;
    LayAutor: TLayout;
    Layout5: TLayout;
    LayLugarFecha: TLayout;
    Layout7: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    LayMensaje: TLayout;
    Label5: TLabel;
    BBuscar: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
