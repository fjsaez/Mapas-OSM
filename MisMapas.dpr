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
  System.StartUpCopy, System.SysUtils,
  {$IFDEF ANDROID}
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  {$ENDIF }
  FMX.Forms,
  Principal in 'Principal.pas' {FPrinc},
  Acerca in 'Acerca.pas' {FrmAcerca: TFrame},
  UtilMapas in 'UtilMapas.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF ANDROID}
    TAndroidHelper.Activity.getWindow.addFlags(
      TJWindowManager_LayoutParams.JavaClass.FLAG_KEEP_SCREEN_ON);
    {SharedActivity.getWindow.addFlags(
      TJWindowManager_LayoutParams.JavaClass.FLAG_KEEP_SCREEN_ON);}
  {$ENDIF}
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
