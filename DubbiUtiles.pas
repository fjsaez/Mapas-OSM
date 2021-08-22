{
   Utilidades varias del sistema Dubbi Garage
   Autor: Ing. Francisco Sáez S.
   Calabozo, 09/08/2019
}

unit DubbiUtiles;

interface

uses FMX.Dialogs;

type
  TUbication = record
    Lat,Lon,
    URLFull,
    Zoom: string;
  end;

const
  MapURL='https://www.openstreetmap.org/';

  procedure ParseURLToCoords(sURL: string; var Ubic: TUbication);
  function CharactExists(Strng: string; Charact: char): boolean;

implementation

procedure ParseURLToCoords(sURL: string; var Ubic: TUbication);
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

function CharactExists(Strng: string; Charact: char): boolean;
var
  I: byte;
  Exists: boolean;
begin
  Exists:=false;
  for I:=1 to Length(Strng) do
  begin
    Exists:=Strng[I]=Charact;
    if Exists then Break;
  end;
  Result:=Exists;
end;

end.
