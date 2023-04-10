unit UtilMapas;

interface

uses
  System.Math, System.Sensors, System.Types;

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

  function Orientacion(Grados: double): string;
  function MakeTile(FX,FY: Extended; Zoom: integer): TTile;
  function GetTileNumber(MP: TLocationCoord2D; Zoom: Integer): TTile;
  function GetLatLon(T: TTile): TMapPoint;

implementation

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

end.
