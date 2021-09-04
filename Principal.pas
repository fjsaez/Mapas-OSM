unit Principal;

interface

uses
  {$IFDEF ANDROID}
    FMX.Platform.Android,
  {$ENDIF}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Maps,
  FMX.WebBrowser, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, DubbiUtiles,
  FMX.Layouts, FMX.Objects, System.Sensors, System.Sensors.Components,
  System.Math, FMX.Ani, UTM_WGS84;

type
  TPosicion = record
    X,Y: Single;
    CG: TLocationCoord2D;
  end;

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
    Circle1: TCircle;
    Layout1: TLayout;
    Line1: TLine;
    Line2: TLine;
    ELon: TEdit;
    ENorte: TEdit;
    EEste: TEdit;
    LayRumbo: TLayout;
    Label6: TLabel;
    LRumbo: TLabel;
    ImgFlecha: TImage;
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
  private
    { Private declarations }
    procedure AbrirVentana(const aFormClass: TComponentClass);
  public
    { Public declarations }
  end;

var
  FPrinc: TFPrinc;
  Ubication: TUbication;
  ZoomChanged: boolean;
  FActiveForm: TForm;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.BAE2E2665F7E41AE9F0947E9D8BC3706.fmx ANDROID}

uses AcercaFrm;

procedure CargarCoordenadas(CoordGPS: TLocationCoord2D; var CoordPos: TPosicion);
var
  LatLon: TRecLatLon;
  UTM: TRecUTM;
begin
  LatLon.Lat:=CoordGPS.Latitude;
  LatLon.Lon:=CoordGPS.Longitude;
  LatLon_To_UTM(LatLon,UTM);
  CoordPos.CG:=CoordGPS;
  CoordPos.X:=UTM.X;
  CoordPos.Y:=UTM.Y;
end;

function Orientacion(Grados: double): string;
begin
  case Round(Grados) of
    0..10,350..360: Result:='N';  //norte
    11..34: Result:='N - NE';     //norte-noreste
    35..54: Result:='NE';         //noreste
    55..79: Result:='E - NE';     //este-noreste
    80..100: Result:='E';         //este
    101..124: Result:='E - SE';   //este-sureste
    125..144: Result:='SE';       //sureste
    145..169: Result:='S - SE';   //sur-sureste
    170..190: Result:='S';        //sur
    191..214: Result:='S - SW';   //sur-suroeste
    215..234: Result:='SW';       //suroeste
    235..259: Result:='W - SW';   //oeste-suroeste
    260..280: Result:='W';        //oeste
    281..304: Result:='W - NW';   //oeste-noroeste
    305..324: Result:='NW';       //noroeste
    325..349: Result:='N - NW';   //norte-noroeste
  end;
end;

procedure TFPrinc.AbrirVentana(const aFormClass: TComponentClass);
begin
  if Assigned(FActiveForm) then FreeAndNil(FActiveForm);
  Application.CreateForm(aFormClass,FActiveForm);
  FActiveForm.Show;
  //FreeAndNil(FActiveForm);
end;

procedure TFPrinc.BBuscarClick(Sender: TObject);
begin
  Ubication.Lat:=ELat.Text;
  Ubication.Lon:=ELon.Text;
  Ubication.Zoom:=Round(TrBarZoom.Value).ToString;
  Ubication.URLFull:=MapURL+'#map='+Ubication.Zoom+'/'+Ubication.Lat+'/'+Ubication.Lon;
  WebBrowser.URL:=Ubication.URLFull;
  WebBrowser.StartLoading;
end;

procedure TFPrinc.ELatChange(Sender: TObject);
begin
  TrBarZoom.Value:=StrToFloat(Ubication.Zoom);
end;

procedure TFPrinc.ELatKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (KeyChar='.') and CharactExists(TEdit(Sender).Text,'.') then KeyChar:=#0;
end;

procedure TFPrinc.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator:='.';
end;

procedure TFPrinc.FormShow(Sender: TObject);
var
  P1,P2: TPointF;
begin
  P1:=TPointF.Create(5,5);
  P2:=TPointF.Create(300,300);
  LZoom.Text:=TrBarZoom.Value.ToString;
  WebBrowser.URL:=MapURL;
  WebBrowser.StartLoading;
  WebBrowser.Canvas.BeginScene;
  WebBrowser.Canvas.DrawLine(P1,P2,1);
  WebBrowser.Canvas.EndScene;
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
var
  UTM: TPosicion;
begin
  CargarCoordenadas(NewLocation,UTM);
  Ubication.Lat:=FormatFloat('#0.######',NewLocation.Latitude);
  Ubication.Lon:=FormatFloat('#0.######',NewLocation.Longitude);
  Ubication.Este:=Round(UTM.X).ToString+' E';
  Ubication.Norte:=Round(UTM.Y).ToString+' N';
  Ubication.URLFull:=MapURL+'#map='+Ubication.Zoom+'/'+Ubication.Lat+'/'+Ubication.Lon;
  if not IsNaN(NewLocation.Longitude) then
  begin
    ELon.Text:=Ubication.Lon;
    EEste.Text:=Ubication.Este;
  end;
  if not IsNaN(NewLocation.Latitude) then
  begin
    ELat.Text:=Ubication.Lat;
    ENorte.Text:=Ubication.Norte;
  end;
  WebBrowser.URL:=Ubication.URLFull;
  WebBrowser.StartLoading;
end;

procedure TFPrinc.SBAcercaClick(Sender: TObject);
begin
  //AbrirVentana(TFAcerca);
  FAcerca.Show;
end;

procedure TFPrinc.SBSalirClick(Sender: TObject);
begin
  MainActivity.finish;
end;

procedure TFPrinc.SwGPSSwitch(Sender: TObject);
begin
  LocSensor.Active:=SwGPS.IsChecked;
  if SwGPS.IsChecked then TrBarZoom.Value:=15;
  ELon.ReadOnly:=SwGPS.IsChecked;
  ELat.ReadOnly:=SwGPS.IsChecked;
end;

procedure TFPrinc.TrBarZoomChange(Sender: TObject);
begin
  Ubication.Zoom:=Round(TrBarZoom.Value).ToString;
  LZoom.Text:=Ubication.Zoom;
end;

procedure TFPrinc.WebBrowserDidFinishLoad(ASender: TObject);
var
  P1,P2: TPointF;
begin
  ParseURLToCoords(WebBrowser.URL,Ubication);
  ELat.Text:=Ubication.Lat;
  ELon.Text:=Ubication.Lon;
  TrBarZoom.Value:=StrToFloat(Ubication.Zoom);

  P1:=TPointF.Create(0,0);
  P2:=TPointF.Create(WebBrowser.Width,WebBrowser.Height);
  WebBrowser.Canvas.BeginScene;
  WebBrowser.Canvas.Stroke.Thickness:=3;
  WebBrowser.Canvas.Stroke.Color:=TAlphaColors.Red;
  WebBrowser.Canvas.DrawLine(P1,P2,100);
  WebBrowser.Canvas.EndScene;
end;

end.
