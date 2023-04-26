unit Principal;

interface

uses
  {$IFDEF ANDROID}
    FMX.Platform.Android,
  {$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.Objects,
  FMX.Ani, System.Sensors, System.Sensors.Components, UTM_WGS84, System.Math,
  System.IOUtils, Acerca, UtilMapas;

type
  TFPrinc = class(TForm)
    WebBrowser: TWebBrowser;
    ELat: TEdit;
    BBuscar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LZoom: TLabel;
    TrBarZoom: TTrackBar;
    SBAcerca: TSpeedButton;
    LayPrinc: TLayout;
    ToolBar1: TToolBar;
    Label4: TLabel;
    LayMapa: TLayout;
    LayPanel: TLayout;
    SBSalir: TSpeedButton;
    LayLatitud: TLayout;
    LayLongitud: TLayout;
    LayZoom: TLayout;
    LayBuscar: TLayout;
    Rectangle1: TRectangle;
    LocSensor: TLocationSensor;
    SwGPS: TSwitch;
    Label5: TLabel;
    FloatAnimation1: TFloatAnimation;
    ELon: TEdit;
    ENorte: TEdit;
    EEste: TEdit;
    LayRumbo: TLayout;
    Label6: TLabel;
    LRumbo: TLabel;
    ImgFlecha: TImage;
    LayAcerca: TLayout;
    FrmAcerca1: TFrmAcerca;
    Imagen: TImage;
    procedure FormShow(Sender: TObject);
    procedure BBuscarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrBarZoomChange(Sender: TObject);
    procedure WebBrowserDidFinishLoad(ASender: TObject);
    procedure ELatKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ELatChange(Sender: TObject);
    procedure SBAcercaClick(Sender: TObject);
    procedure SBSalirClick(Sender: TObject);
    procedure LocSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure SwGPSSwitch(Sender: TObject);
    procedure LocSensorHeadingChanged(Sender: TObject;
      const AHeading: THeading);
    procedure FrmAcerca1BAceptarClick(Sender: TObject);
  private
    procedure MostrarMapa(Loc: TLocationCoord2D);
  public
    { Public declarations }
  end;

var
  FPrinc: TFPrinc;
  Ubication: TUbicacion;
  FActiveForm: TForm;

implementation

{$R *.fmx}
{$R *.BAE2E2665F7E41AE9F0947E9D8BC3706.fmx ANDROID}

uses
  System.Permissions, FMX.DialogService;

procedure TFPrinc.MostrarMapa(Loc: TLocationCoord2D);
var
  UTM: TPosicion;
  Posc: TTile;
  Coords: TCoords;
begin
  CargarCoordenadas(Loc,UTM);
  Ubication.Lat:=FormatFloat('#0.######',Loc.Latitude);
  Ubication.Lon:=FormatFloat('#0.######',Loc.Longitude);
  Ubication.Este:=Round(UTM.X).ToString+' E';
  Ubication.Norte:=Round(UTM.Y).ToString+' N';
  Coords:=ObtenerCoordenadas(Loc,WebBrowser.Width,WebBrowser.Height,
                             Round(TrBarZoom.Value));
  Ubication.URLFull:=MapURL+FormatFloat('#0.######',Coords.TopLeft.Lon)+','+
    FormatFloat('#0.######',Coords.TopLeft.Lat)+','+
    FormatFloat('#0.######',Coords.BottomRight.Lon)+','+
    FormatFloat('#0.######',Coords.BottomRight.Lat)+'&layer=mapnik';
  if not IsNaN(Loc.Longitude) then
  begin
    ELon.Text:=Ubication.Lon;
    EEste.Text:=Ubication.Este;
  end;
  if not IsNaN(Loc.Latitude) then
  begin
    ELat.Text:=Ubication.Lat;
    ENorte.Text:=Ubication.Norte;
  end;
  WebBrowser.URL:=Ubication.URLFull;
  WebBrowser.StartLoading;
end;

/// Eventos ///

procedure TFPrinc.BBuscarClick(Sender: TObject);
var
  Coord: TLocationCoord2D;
begin
  Coord.Latitude:=ELat.Text.ToDouble;
  Coord.Longitude:=ELon.Text.ToDouble;
  MostrarMapa(Coord);
end;

procedure TFPrinc.ELatChange(Sender: TObject);
begin
  TrBarZoom.Value:=StrToFloat(Ubication.Zoom);
end;

procedure TFPrinc.ELatKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (KeyChar='.') and CaractExiste(TEdit(Sender).Text,'.') then KeyChar:=#0;
end;

procedure TFPrinc.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator:='.';
  //la URL por defecto (muestra a Venezuela):
  WebBrowser.URL:='https://www.openstreetmap.org/export/embed.html?bbox='+
                  '-73.3650,0.6350,-59.8000,12.265&layer=mapnik';
  //se cargan los valores guardados en archivo .ini:
  Sistema.ArchivoIni:=TPath.GetHomePath+'/MisMapas.ini';
  if FileExists(Sistema.ArchivoIni) then CargarINI
                                    else GuardarIni(Sistema.Zoom);
  TrBarZoom.Value:=Sistema.Zoom;
  LZoom.Text:=Sistema.Zoom.ToString;
  //esto es temporal:
  {ELon.Text:='-67.4181';
  ELat.Text:='8.9047';}
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  WebBrowser.StartLoading;
end;

procedure TFPrinc.FrmAcerca1BAceptarClick(Sender: TObject);
begin
  LayAcerca.Visible:=false;
  LayPrinc.Visible:=true;
end;

procedure TFPrinc.LocSensorHeadingChanged(Sender: TObject;
  const AHeading: THeading);
begin
  if not IsNaN(AHeading.Azimuth) then
  begin
    LRumbo.Text:=FormatFloat('#0.#',AHeading.Azimuth)+'º '+
                 Orientacion(AHeading.Azimuth);
    ImgFlecha.RotationAngle:=AHeading.Azimuth;
  end;
end;

procedure TFPrinc.LocSensorLocationChanged(Sender: TObject; const OldLocation,
  NewLocation: TLocationCoord2D);
begin
  MostrarMapa(NewLocation);
end;

procedure TFPrinc.SBAcercaClick(Sender: TObject);
begin
  LayPrinc.Visible:=false;
  LayAcerca.Visible:=true;
end;

procedure TFPrinc.SBSalirClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  MainActivity.finish;
  {$ENDIF}
end;

procedure TFPrinc.SwGPSSwitch(Sender: TObject);
const
  PermissionAccessFineLocation='android.permission.ACCESS_FINE_LOCATION';
begin
  {$IFDEF ANDROID}
  PermissionsService.RequestPermissions([PermissionAccessFineLocation],
    procedure(const APermissions: TClassicStringDynArray;
              const AGrantResults: TClassicPermissionStatusDynArray)
    begin
      if (Length(AGrantResults)=1) and (AGrantResults[0]=TPermissionStatus.Granted) then
        LocSensor.Active:=SwGPS.IsChecked
      else
      begin
        SwGPS.IsChecked:=false;
        TDialogService.ShowMessage('Permiso de Localización no está permitido');
      end;
    end);
  {$ELSE}
    LocSensor.Active := SwitchGPS.IsChecked;
  {$ENDIF}
  ELon.ReadOnly:=SwGPS.IsChecked;
  ELat.ReadOnly:=SwGPS.IsChecked;
  Ubication.Zoom:=Round(TrBarZoom.Value).ToString;
end;

procedure TFPrinc.TrBarZoomChange(Sender: TObject);
begin
  Ubication.Zoom:=Round(TrBarZoom.Value).ToString;
  Sistema.Zoom:=Round(TrBarZoom.Value);
  LZoom.Text:=Ubication.Zoom;
  if SwGPS.IsChecked then BBuscarClick(Self);
  GuardarIni(Sistema.Zoom);
end;

procedure TFPrinc.WebBrowserDidFinishLoad(ASender: TObject);
begin
  {ParseURLToCoords(WebBrowser.URL,Ubication);
  ELat.Text:=Ubication.Lat;
  ELon.Text:=Ubication.Lon;
  TrBarZoom.Value:=StrToFloat(Ubication.Zoom);}
end;

end.

  { TODO : - Guardar en archivo .ini el último valor del zoom }

{ más ajustado a Venezuela:
https://www.openstreetmap.org/export/embed.html?bbox=
        -73.400,0.400,-59.700,12.600&layer=mapnik

Ubication.URLFull:='https://tile.openstreetmap.org/'+Ubication.Zoom+
                     '/'+Posc.X.ToString+'/'+Posc.Y.ToString+'.png';

WebBrowser.URL:='https://www.openstreetmap.org/#map=6/6.447/-66.579';
}
