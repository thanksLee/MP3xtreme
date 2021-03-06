/////////////////////////////////////////////////////////////////////
//                                                                 //
//                   MP3 - Master Player 3xtreme                   //
//                     mp3 player and organizer                    //
//                                                                 //
//                  Copyright � Ellrohir 2007-2008                 //
//                                                                 //
//                                                                 //
//    Page Info                                                    //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// *  Author:         *  Ellrohir [ rakcesa@seznam.cz ]          * //
// *  Homepage:       *  http://ellrohir.xf.cz/                  * //
// *  File:           *  PlayerU.pas                             * //
// *  Purpose:        *  Methods used for Player section         * //
// *  System Version: *  1.0                                     * //
// *  Last Modified:  *  2008-03-11 1600 GMT+1                   * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
/////////////////////////////////////////////////////////////////////

unit PlayerU;

interface

uses Main, Graphics, Classes, Forms, MP3Utilities, SysUtils;

function RecountMP3Duration(Miliseconds: longint): TMyTime;
function CheckIfEnd(TimeElapsed,TimeNeeded: TMyTime): boolean;
procedure AssignTrackQuery(Files: TStrings);
procedure DeleteFromTrackQuery(index: integer);
procedure RandomizeGenericBrushForGeneric;
procedure RandomizeGenericBrushForAmeoba;
procedure ResetAmeobaPosition;
procedure ResetLightsPosition;
procedure HandleAmeobaMovement(var Corner: TAmeobaMovement);
function SetHexadecimalDigit(num: integer): char;
procedure RandomizeGenericBrushColor; // only temporary function

procedure CheckMP3sInQuery(Album: word); // maybe files in Track Query need to update their paths

implementation

function RecountMP3Duration(Miliseconds: longint): TMyTime;
// makes H:M:S format from time in miliseconds
begin
Result.H:=Miliseconds div (60*60*1000);
Miliseconds:=Miliseconds - (Result.H*(60*60*1000));
Result.M:=Miliseconds div (60*1000);
Miliseconds:=Miliseconds - (Result.M*(60*1000));
Result.S:=Miliseconds div 1000;
end;

function CheckIfEnd(TimeElapsed,TimeNeeded: TMyTime): boolean;
// compares the elapsed time with the time announced for the mp3 track
// returns true when they are even (end of the track)
begin
if (TimeElapsed.H=TimeNeeded.H)
and(TimeElapsed.M=TimeNeeded.M)
and(TimeElapsed.S=TimeNeeded.S) then result:=true
                                else result:=false;
end;

procedure AssignTrackQuery(Files: TStrings);
// assigns informations into Track Query
var i: integer;
begin
Main.MP3TrackQue:=nil; // nil the previous array
Form1.TrackQuery.Items.Clear; // clear the previous visible list
SetLength(Main.MP3TrackQue,Files.Count);
for i:=0 to Files.Count-1 do begin
                             Main.MP3TrackQue[i].ID:=i;
                             Main.MP3TrackQue[i].Path:=Files[i];
                             Main.MP3TrackQue[i].Name:=Files[i];
                             CutPath(Main.MP3TrackQue[i].Name);
                             Form1.TrackQuery.Items.Add(Main.MP3TrackQue[i].Name);
                             end;
end;

procedure DeleteFromTrackQuery(index: integer);
// delete specified item from the query array and moves the rest of the array
var i: integer;
begin
for i:=index to high(Main.MP3TrackQue)-1 do Main.MP3TrackQue[i]:=Main.MP3TrackQue[i+1]; // move the rest
SetLength(Main.MP3TrackQue,high(Main.MP3TrackQue)); // cut the last
end;

procedure RandomizeGenericBrushForGeneric;
var RandomNumber: integer;
// initial values for GenericBG  brush (style "Generic")
begin

{repeat
GenericBrush.Color:=random(high(GenericBrush.Color));
until GenericBrush.Color>clBlack; }
// color
RandomizeGenericBrushColor;
// how long will current pattern being displayed
randomize;
RandomNumber:=random(50)+75;
GenericBrush.ColorDuration:=RandomNumber;
GenericBrush.ColorElapsed:=0;
// starting coords
repeat
randomize;
RandomNumber:=random(565)+100;
GenericBrush.Coords.X:=RandomNumber;
randomize;
RandomNumber:=random(260)+60;
GenericBrush.Coords.Y:=RandomNumber;
until Form1.GenericBG.Canvas.Pixels[GenericBrush.Coords.X,GenericBrush.Coords.Y]=clBlack; // never two patterns on each other
end;

procedure RandomizeGenericBrushForAmeoba;
var RandomNumber: integer;
// initial values for GenericBG  brush (style "Ameoba")
begin

{repeat
GenericBrush.Color:=random(high(GenericBrush.Color));
until GenericBrush.Color>clBlack; }
RandomizeGenericBrushColor;
//
// how long will current pattern being displayed
randomize;
RandomNumber:=random(50)+75;
GenericBrush.ColorDuration:=RandomNumber;
GenericBrush.ColorElapsed:=0;
// Ameoba doesnt care for init coords
end;

procedure ResetAmeobaPosition;
var i: integer;
begin
// default color
RandomizeGenericBrushColor;
//
randomize;
GenericBrush.AmeobaTop.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTop.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTop.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaLeft.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaLeft.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaLeft.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaRight.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaRight.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaRight.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottom.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottom.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottom.Movement:=((random(39)+1)mod 8)+1;

{
GenericBrush.AmeobaTopRight.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTopRight.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTopRight.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTopLeft.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTopLeft.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaTopLeft.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottomRight.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottomRight.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottomRight.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottomLeft.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottomLeft.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.AmeobaBottomLeft.Movement:=((random(39)+1)mod 8)+1;
}
end;

procedure ResetLightsPosition;
var i: integer;
begin
// default color
RandomizeGenericBrushColor;
//
randomize;
GenericBrush.LightsTopLeft1.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft1.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft1.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft2.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft2.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft2.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft3.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft3.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsTopLeft3.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight1.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight1.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight1.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight2.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight2.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight2.Movement:=((random(39)+1)mod 8)+1;
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight3.X:=random(665);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight3.Y:=random(320);
for i:=1 to 5000 do Application.ProcessMessages;
GenericBrush.LightsBottomRight3.Movement:=((random(39)+1)mod 8)+1;
end;

procedure HandleAmeobaMovement(var Corner: TAmeobaMovement);
var RandomNumber: integer;
begin
// handling if corner hit the border of the picture - then it change direction randomly
case Corner.Movement of
1,2,3,4,5: begin
           if Corner.X>=665 then begin // possible ways - 16-20
                                 RandomNumber:=random(999)+1;
                                 case (RandomNumber mod 5) of
                                 0: Corner.Movement:=16;
                                 1: Corner.Movement:=17;
                                 2: Corner.Movement:=18;
                                 3: Corner.Movement:=19;
                                 4: Corner.Movement:=20;
                                 end;
                                 end else
           if Corner.Y<=1 then begin // possible ways - 6-10
                               RandomNumber:=random(999)+1;
                               case (RandomNumber mod 5) of
                               0: Corner.Movement:=6;
                               1: Corner.Movement:=7;
                               2: Corner.Movement:=8;
                               3: Corner.Movement:=9;
                               4: Corner.Movement:=10;
                               end;
                               end;
            end;
6,7,8,9,10: begin
            if Corner.X>=665 then begin // possible ways - 11-15
                                  RandomNumber:=random(999)+1;
                                  case (RandomNumber mod 5) of
                                  0: Corner.Movement:=11;
                                  1: Corner.Movement:=12;
                                  2: Corner.Movement:=13;
                                  3: Corner.Movement:=14;
                                  4: Corner.Movement:=15;
                                  end;
                                  end else
            if Corner.Y>=320 then begin // possible ways - 1-5
                                  RandomNumber:=random(999)+1;
                                  case (RandomNumber mod 5) of
                                  0: Corner.Movement:=1;
                                  1: Corner.Movement:=2;
                                  2: Corner.Movement:=3;
                                  3: Corner.Movement:=4;
                                  4: Corner.Movement:=5;
                                  end;
                                  end;
           end;
11,12,13,14,15: begin
                if Corner.X<=1 then begin // possible ways - 6-10
                                    RandomNumber:=random(999)+1;
                                    case (RandomNumber mod 5) of
                                    0: Corner.Movement:=6;
                                    1: Corner.Movement:=7;
                                    2: Corner.Movement:=8;
                                    3: Corner.Movement:=9;
                                    4: Corner.Movement:=10;
                                    end;
                                    end else
                if Corner.Y>=320 then begin // possible ways - 16-20
                                      RandomNumber:=random(999)+1;
                                      case (RandomNumber mod 5) of
                                      0: Corner.Movement:=16;
                                      1: Corner.Movement:=17;
                                      2: Corner.Movement:=18;
                                      3: Corner.Movement:=19;
                                      4: Corner.Movement:=20;
                                      end;
                                      end;
                end;
16,17,18,19,20: begin
                if Corner.X<=1 then begin // possible ways - 1-5
                                    RandomNumber:=random(999)+1;
                                    case (RandomNumber mod 5) of
                                    0: Corner.Movement:=1;
                                    1: Corner.Movement:=2;
                                    2: Corner.Movement:=3;
                                    3: Corner.Movement:=4;
                                    4: Corner.Movement:=5;
                                    end;
                                    end else
                if Corner.Y<=1 then begin // possible ways - 11-15
                                    RandomNumber:=random(999)+1;
                                    case (RandomNumber mod 5) of
                                    0: Corner.Movement:=11;
                                    1: Corner.Movement:=12;
                                    2: Corner.Movement:=13;
                                    3: Corner.Movement:=14;
                                    4: Corner.Movement:=15;
                                    end;
                                    end;
                end;
end;
//
case Corner.Movement of // asking again, but it should have been updated meanwhile
// values 1-5 for quadrant 1
1: begin
   Corner.X:=Corner.X+1;
   if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.Y:=Corner.Y-3
                                            else Corner.Y:=Corner.Y-2;
   end;
2: begin
   Corner.X:=Corner.X+1;
   Corner.Y:=Corner.Y-2;
   end;
3: begin
   Corner.X:=Corner.X+1;
   Corner.Y:=Corner.Y-1;
   end;
4: begin
   Corner.X:=Corner.X+2;
   Corner.Y:=Corner.Y-1;
   end;
5: begin
   if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.X:=Corner.X+3
                                            else Corner.X:=Corner.X+2;
   Corner.Y:=Corner.Y-1;
   end;
// values 6-10 for quadrant 2
6: begin
   if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.X:=Corner.X+3
                                            else Corner.X:=Corner.X+2;
   Corner.Y:=Corner.Y+1;
   end;
7: begin
   Corner.X:=Corner.X+2;
   Corner.Y:=Corner.Y+1;
   end;
8: begin
   Corner.X:=Corner.X+1;
   Corner.Y:=Corner.Y+1;
   end;
9: begin
   Corner.X:=Corner.X+1;
   Corner.Y:=Corner.Y+2;
   end;
10: begin
   Corner.X:=Corner.X+1;
   if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.Y:=Corner.Y+3
                                            else Corner.Y:=Corner.Y+2;
   end;
// values 11-15 for quadrant 3
11: begin
    Corner.X:=Corner.X-1;
    if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.Y:=Corner.Y+3
                                             else Corner.Y:=Corner.Y+2;
    end;
12: begin
    Corner.X:=Corner.X-1;
    Corner.Y:=Corner.Y+2;
    end;
13: begin
    Corner.X:=Corner.X-1;
    Corner.Y:=Corner.Y+1;
    end;
14: begin
    Corner.X:=Corner.X-2;
    Corner.Y:=Corner.Y+1;
    end;
15: begin
    if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.X:=Corner.X-3
                                             else Corner.X:=Corner.X-2;
    Corner.Y:=Corner.Y+1;
    end;
// values 16-20 for quadrant 4
16: begin
    if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.X:=Corner.X-3
                                             else Corner.X:=Corner.X-2;
    Corner.Y:=Corner.Y-1;
    end;
17: begin
    Corner.X:=Corner.X-2;
    Corner.Y:=Corner.Y-1;
    end;
18: begin
    Corner.X:=Corner.X-1;
    Corner.Y:=Corner.Y-1;
    end;
19: begin
    Corner.X:=Corner.X-1;
    Corner.Y:=Corner.Y-2;
    end;
20: begin
    Corner.X:=Corner.X-1;
    if (GenericBrush.ColorElapsed mod 2 = 1) then Corner.Y:=Corner.Y-3
                                             else Corner.Y:=Corner.Y-2;
    end;
end;
end;

function SetHexadecimalDigit(num: integer): char;
begin
case num of
0: result:='0';
1: result:='1';
2: result:='2';
3: result:='3';
4: result:='4';
5: result:='5';
6: result:='6';
7: result:='7';
8: result:='8';
9: result:='9';
10: result:='A';
11: result:='B';
12: result:='C';
13: result:='D';
14: result:='E';
15: result:='F';
else result:='0';
end;
end;

procedure RandomizeGenericBrushColor;
var RandomNumber,i: integer;
    ColorPt1,ColorPt2,ColorPt3: string[2];
    Color: string;
begin
repeat
randomize;
RandomNumber:=random(15);
ColorPt1:='';
ColorPt1:=ColorPt1+SetHexadecimalDigit(RandomNumber);
for i:=1 to 5000 do Application.ProcessMessages;
RandomNumber:=random(15);
ColorPt1:=ColorPt1+SetHexadecimalDigit(RandomNumber);
for i:=1 to 5000 do Application.ProcessMessages;
RandomNumber:=random(15);
ColorPt2:='';
ColorPt2:=ColorPt2+SetHexadecimalDigit(RandomNumber);
for i:=1 to 5000 do Application.ProcessMessages;
RandomNumber:=random(15);
ColorPt2:=ColorPt2+SetHexadecimalDigit(RandomNumber);
for i:=1 to 5000 do Application.ProcessMessages;
RandomNumber:=random(15);
ColorPt3:='';
ColorPt3:=ColorPt3+SetHexadecimalDigit(RandomNumber);
for i:=1 to 5000 do Application.ProcessMessages;
RandomNumber:=random(15);
ColorPt3:=ColorPt3+SetHexadecimalDigit(RandomNumber);
until (ColorPt1<>'00')or(ColorPt2<>'00')or(ColorPt3<>'00');
Color:='$00'+ColorPt1+ColorPt2+ColorPt3;
//Form1.Memo1.Lines.Add(Color);
GenericBrush.Color:=StringToColor(Color);
{ OLD VARIANT
repeat
randomize;
RandomNumber:=random(50);
// only before i create better way for more different and really random colors...
case RandomNumber of
1,11,21,31,41: NewColor:=clAqua;
2,12,22,32,42: NewColor:=clNavy;
3,13,23,33,43: NewColor:=clLime;
4,14,24,34,44: NewColor:=clYellow;
5,15,25,35,45: NewColor:=clBlue;
6,16,26,36,46: NewColor:=clRed;
7,17,27,37,47: NewColor:=clGreen;
8,18,28,38,48: NewColor:=clGray;
9,19,29,39,49: NewColor:=clFuchsia;
10,20,30,40,50: NewColor:=clWhite;
else NewColor:=clWhite;
end;

until NewColor<>GenericBrush.Color; // never two same colors right after each other
GenericBrush.Color:=NewColor;
}
end;

procedure CheckMP3sInQuery(Album: word);
// maybe files in Track Query need to update their paths (the path was changed somehow
var i,i2,matches: integer;
begin
i:=-1;
matches:=0;
repeat
i:=i+1;
if (Main.MP3Collection.MP3s[i].Album=Album) then begin
                                                 matches:=matches+1;
                                                 for i2:=0 to high(MP3TrackQue) do
                                                  if Main.MP3Collection.MP3s[i].Path=Main.MP3TrackQue[i2].Path then
                                                   Main.MP3TrackQue[i2].Path:=Main.MP3Collection.Path+'_root\'+inttostr(Main.MP3Collection.Albums[Album].Order)+'\'+Main.MP3Collection.Albums[Album].Name+'\'+inttostr(Main.MP3Collection.MP3s[i].Order)+' - '+Main.MP3Collection.MP3s[i].Name+'.mp3';
                                                 end;
until (i>=high(Main.MP3Collection.MP3s))or(matches=Main.MP3Collection.Albums[Album].MP3No);
end;

end.
