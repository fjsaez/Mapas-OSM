{
    Mis Mapas
      v1.0

   Aplicación simple que muestra un mapa en un componente TWebBrowser, basándose
   en los mapas de https://www.openstreetmap.org/

   Autor: Ing. Francisco J. Sáez S.
   email: fjsaez@gmail.com

   Calabozo, septiembre de 2019.
}

program MisMapas;

uses
  System.StartUpCopy,
  FMX.Forms,
  Principal in 'Principal.pas' {FPrinc},
  AcercaFrm in 'AcercaFrm.pas' {FAcerca};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
