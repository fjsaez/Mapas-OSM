unit UtilMapas;

interface

uses
  System.Math, System.Sensors, System.Types, UTM_WGS84;

type
  TMapPoint = record
    Lat,Lon: Double;
  end;

  TTile = record
    Zoom,X,Y: Integer;
    FractX,FractY: Double;
  end;

  TUbicacion = record
    Lat,Lon,
    Este,Norte,
    URLFull,
    Zoom: string;
  end;

  TPosicion = record
    X,Y: Single;
    CG: TLocationCoord2D;
  end;

  const
    MapURL='https://www.openstreetmap.org/';

  function CaractExiste(Strng: string; Charact: char): boolean;
  function Orientacion(Grados: double): string;
  function MakeTile(FX,FY: Extended; Zoom: integer): TTile;
  function GetTileNumber(MP: TLocationCoord2D; Zoom: Integer): TTile;
  function GetLatLon(T: TTile): TMapPoint;
  procedure CargarCoordenadas(CoordGPS: TLocationCoord2D; var CoordPos: TPosicion);
  procedure ParseURLToCoords(sURL: string; var Ubic: TUbicacion);

implementation

function CaractExiste(Strng: string; Charact: char): boolean;
var
  I: byte;
  Existe: boolean;
begin
  Existe:=false;
  for I:=1 to Length(Strng) do
  begin
    Existe:=Strng[I]=Charact;
    if Existe then Break;
  end;
  Result:=Existe;
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

function MakeTile(FX,FY: Extended; Zoom: integer): TTile;
begin
  MakeTile.Zoom := Zoom;
  MakeTile.X := Trunc(FX);
  MakeTile.Y := Trunc(FY);
end;

function GetTileNumber(MP: TLocationCoord2D; Zoom: Integer): TTile;
var
  N: DWord;
  RLat, FX, FY: Extended;
begin
  N := 1 shl Zoom;
  FX := (MP.Longitude + 180) * N / 360;
  RLat := DegToRad(MP.Latitude);
  FY := (1 - Ln(Tan(RLat) + Sec(RLat)) / Pi) * N / 2;
  //Result := MakeTile(FX, FY, Zoom);
  Result.Zoom:=Zoom;
  Result.X := Trunc(FX);
  Result.Y := Trunc(FY);
end;

function GetLatLon(T: TTile): TMapPoint;
var
  N: DWord;
begin
  N:=1 shl T.Zoom;
  Result.Lat:=RadToDeg(ArcTan(Sinh(Pi*(1-2*(T.Y+T.FractY)/N))));
  Result.Lon:=(T.X+T.FractX)/N*360-180;
end;

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

procedure ParseURLToCoords(sURL: string; var Ubic: TUbicacion);
var
  I,Pos: integer;
begin
  Ubic.Zoom:='';
  Ubic.Lat:='';
  Ubic.Lon:='';
  Ubic.URLFull:=sURL;
  if sURL<>MapURL then
  begin
    //desgranar aquí partiendo de la cadena "#map="
    Pos:=Length(MapURL+'#map=')+1;
    for I:=1 to 2 do
    begin
      while Copy(sURL,Pos,1)<>'/' do
      begin
        if I=1 then Ubic.Zoom:=Ubic.Zoom+Copy(sURL,Pos,1)  //el zoom
               else Ubic.Lat:=Ubic.Lat+Copy(sURL,Pos,1);   //la latitud
        Inc(Pos);
      end;
      Pos:=Pos+1;
    end;
    //se obtiene la longitud:
    while Pos<=Length(sURL) do
    begin
      Ubic.Lon:=Ubic.Lon+Copy(sURL,Pos,1);
      Inc(Pos);
    end;
  end;
end;

end.
