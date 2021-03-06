/////////////////////////////////////////////////////////////////////
//                                                                 //
//                   MP3 - Master Player 3xtreme                   //
//                     mp3 player and organizer                    //
//                                                                 //
//                 Copyright � Ellrohir 2007-2008                  //
//                                                                 //
//                                                                 //
//    Page Info                                                    //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
// *  Author:         *  Ellrohir [ ellrohir@seznam.cz ]         * //
// *  Homepage:       *  http://ellrohir.xf.cz/                  * //
// *  File:           *  AlbumU.pas                              * //
// *  Purpose:        *  Form for adding/editing albums          * //
// *  System Version: *  1.0                                     * //
// *  Last Modified:  *  2008-03-10 1050 GMT+1                   * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
/////////////////////////////////////////////////////////////////////

unit MP3U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtDlgs, ExtCtrls, jpeg;

type
  TMP3W = class(TForm)
    MainBox: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    OkB: TButton;
    CancelB: TButton;
    MP3Name: TEdit;
    MP3Order: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    MP3Path: TEdit;
    Button1: TButton;
    OpenMP3: TOpenDialog;
    Label4: TLabel;
    MP3Album: TComboBox;
    MP3Image: TImage;
    Label5: TLabel;
    Button2: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure AlignLabels;
    procedure FormCreate(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure CancelBClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MP3AlbumChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MP3W: TMP3W;
  Inicialization: boolean; // if the mp3 is edited (wizard should load info) or newly created (wizard fills default values)
  AlbumID: word;
  MP3ID: word;

implementation

uses Main, ImportU, MP3Utilities, ID3Utilities;

{$R *.dfm}

procedure TMP3W.AlignLabels;
begin
// dunno why...
Label1.Left:=10;
Label2.Left:=10;
Label3.Left:=180;
Label4.Left:=10;
Label5.Left:=10;
end;

procedure TMP3W.FormCreate(Sender: TObject);
// some incialization
var i: integer;
begin
UpDown1.Max:=Main.MP3Collection.Albums[AlbumID].MP3No;
if Inicialization then begin
                       MP3W.Caption:=TranslateText('MSGOkBImport',Main.Settings.Lang)+' '+TranslateText('MSGWizardMP3',Main.Settings.Lang);
                       OkB.Caption:=TranslateText('MSGOkBImport',Main.Settings.Lang);
                       UpDown1.Max:=Main.MP3Collection.Albums[AlbumID].MP3No+1;
                       UpDown1.Position:=MP3Collection.Albums[AlbumID].MP3No+1;
                       MP3Album.ItemIndex:=AlbumID;
                       if Main.MP3Collection.Albums[AlbumID].Name='_root' then MP3Album.Text:='...'
                                                                          else MP3Album.Text:=Main.MP3Collection.Albums[AlbumID].Name;
                       // trying to load album image as thumbnail (default
                       if Main.MP3Collection.Albums[AlbumID].Image<>InitDir+'EmptyAlbum.jpg' then try
                                                                                                   OpenPictureDialog1.FileName:=Main.MP3Collection.Albums[AlbumID].Image;
                                                                                                    MP3Image.Picture.LoadFromFile(Main.MP3Collection.Albums[AlbumID].Image);
                                                                                                  except
                                                                                                   try
                                                                                                    OpenPictureDialog1.FileName:=InitDir+'EmptyMP3.jpg';
                                                                                                    MP3Image.Picture.LoadFromFile(InitDir+'EmptyMP3.jpg');
                                                                                                   except
                                                                                                    // if this failes, the whole program is about to crash
                                                                                                    ShowMessage(TranslateText('FEMissingFile1',Settings.Lang)+'EmptyMP3.jpg'+TranslateText('FEMissingFile2',Settings.Lang));
                                                                                                    CrucialE:=true; // the program must be terminated with no asking
                                                                                                    MP3W.Close;
                                                                                                    Form1.Close;
                                                                                                   end;
                                                                                                  end;
                       end
                  else begin
                       // setting path is disabled now
                       MP3Path.Enabled:=false;
                       Button1.Enabled:=false;
                       // initializing components
                       MP3Name.Text:=Main.MP3Collection.MP3s[MP3ID].Name;
                       MP3Path.Text:=Main.MP3Collection.MP3s[MP3ID].Path;
                       //if Main.MP3Collection.Albums[AlbumID].Name='_root' then MP3Album.Text:='...'
                       //                                                   else MP3Album.Text:=Main.MP3Collection.Albums[AlbumID].Name;
                       //
                       MP3W.Caption:=TranslateText('MSGOkBEdit',Main.Settings.Lang)+' '+TranslateText('MSGWizardMP3',Main.Settings.Lang);
                       OkB.Caption:=TranslateText('MSGOkBEdit',Main.Settings.Lang);
                       // initial image load
                       // initial image load
                       try
                        if Main.MP3Collection.MP3s[MP3ID].Image<>'' then begin // if something is set
                                                                         OpenPictureDialog1.FileName:=Main.MP3Collection.MP3s[MP3ID].Image;
                                                                         MP3Image.Picture.LoadFromFile(OpenPictureDialog1.FileName);
                                                                         end
                                                                    else begin // it nothing is set - setting default
                                                                         try
                                                                          OpenPictureDialog1.FileName:=InitDir+'EmptyMP3.jpg';
                                                                          MP3Image.Picture.LoadFromFile(InitDir+'EmptyMP3.jpg');
                                                                          MP3Collection.MP3s[MP3ID].Image:=InitDir+'EmptyMP3.jpg';
                                                                          //ShowMessage('ERROR - Saved image for this MP3 file corrupted or missing. The image was reseted to default.');
                                                                         except
                                                                          // if this failes, the whole program is about to crash
                                                                          ShowMessage(TranslateText('FEMissingFile1',Settings.Lang)+'EmptyMP3.jpg'+TranslateText('FEMissingFile2',Settings.Lang));
                                                                          CrucialE:=true; // the program must be terminated with no asking
                                                                          MP3W.Close;
                                                                          Form1.Close;
                                                                         end;
                                                                         end;
                       except
                        try
                         OpenPictureDialog1.FileName:=InitDir+'EmptyMP3.jpg';
                         MP3Image.Picture.LoadFromFile(InitDir+'EmptyMP3.jpg');
                         MP3Collection.MP3s[MP3ID].Image:=InitDir+'EmptyMP3.jpg';
                         ShowMessage(TranslateText('ECorruptedImageMP3',Settings.Lang));
                        except
                         // if this failes, the whole program is about to crash
                         ShowMessage(TranslateText('FEMissingFile1',Settings.Lang)+'EmptyMP3.jpg'+TranslateText('FEMissingFile2',Settings.Lang));
                         CrucialE:=true; // the program must be terminated with no asking
                         MP3W.Close;
                         Form1.Close;
                        end;
                       end;
                       //
                       UpDown1.Max:=Main.MP3Collection.Albums[AlbumID].MP3No;
                       UpDown1.Position:=Main.MP3Collection.MP3s[MP3ID].Order;
                       MP3Album.ItemIndex:=AlbumID;
                       if Main.MP3Collection.Albums[AlbumID].Name='_root' then MP3Album.Text:='...'
                                                                          else MP3Album.Text:=Main.MP3Collection.Albums[AlbumID].Name;
                       end;
// fill available albums
MP3Album.Items.Clear;
MP3Album.Items.Add('...');
for i:=1  {_root album not included} to high(Main.MP3Collection.Albums) do if Main.MP3Collection.Albums[i].Name<>'_Empty' then MP3Album.Items.Add(Main.MP3Collection.Albums[i].Name);
//
AlignLabels;
end;

procedure TMP3W.OkBClick(Sender: TObject);
// processing changes
var FilePath,FilePath2: string;
    APIFrom,APITo: PAnsiChar;
    //i: ^integer; // we wont be use it so often
    OldLocation: integer; // if the MP3 album is changed
    OldName: string; // if the name of MP3 is changed
    Existing: integer;
begin
OkB.Enabled:=false; // this should prevent "double clicks"
// checking validity of name parameter
case CheckName(MP3Name.Text) of
2: ShowMessage(TranslateText('XCharNotAllowed',Main.Settings.Lang));
1: ShowMessage(TranslateText('XCharInvalid',Main.Settings.Lang));
0: begin // {loop 1}
try // maybe some error occured...
// check if selected album name is valid
FilePath:=MP3Album.Text;
if FilePath='...' then FilePath:='_root';
if Main.MP3Collection.Albums[AlbumID].Name<>FilePath then ShowMessage(TranslateText('EInvalidAlbum',Settings.Lang))
                                                     else begin
if MP3Path.Text<>'Select mp3 file' then begin
// check if file of same name isnt already imported
{
i:=-1;
repeat
i:=i+1;
until ((Main.MP3Collection.MP3s[i].Name=MP3Name.Text)and(Main.MP3Collection.MP3s[i].Album=MP3Album.ItemIndex)) // two conditions have to passed
or (i>=High(Main.MP3Collection.MP3s)); // or such a file doesnt exists yet - no problem then
}
// saving old MP3 data
if not Inicialization then begin
                           OldLocation:=Main.MP3Collection.MP3s[MP3ID].Album;
                           OldName:=Main.MP3Collection.MP3s[MP3ID].Name;
                           end;
if OldName<>MP3Name.Text then Existing:=CheckExistence(MP3Name.Text,AlbumID)
                         else Existing:=-1;
if (Existing=-1)or(MessageDlg(TranslateText('QRewriteMP3',Settings.Lang),mtConfirmation,[mbYes,mbNo],0)=IDYes) then
begin
if Existing>-1 then begin
                    MP3ID:=Existing;
                    Inicialization:=false; // we are not adding new - only overwriting old
                    end;
// setting the physical file name
FilePath:=Main.MP3Collection.Path;
CheckLastBackslash(FilePath);
FilePath:=FilePath+'_root\';
if (AlbumID>0) then FilePath:=FilePath+inttostr(Main.MP3Collection.Albums[AlbumID].Order)+' - '+Main.MP3Collection.Albums[AlbumID].Name+'\';
FilePath:=FilePath+MP3Name.Text+'.mp3';
// this is done only when new mp3 added
if Inicialization then begin
                       Main.MP3Collection.MP3s[MP3ID].ID:=MP3ID;
                       // updating file sizes, duration and mp3 count
                       Main.MP3Collection.MP3No:=Main.MP3Collection.MP3No+1;
                       Main.MP3Collection.Albums[AlbumID].MP3No:=Main.MP3Collection.Albums[AlbumID].MP3No+1;
                       try
                       // size of the file
                       Main.MP3Collection.MP3s[MP3ID].Size:=GetFileSize(MP3Path.Text);
                       Main.MP3Collection.Albums[AlbumID].Size:=Main.MP3Collection.Albums[AlbumID].Size+Main.MP3Collection.MP3s[MP3ID].Size;
                       Main.MP3Collection.Size:=Main.MP3Collection.Size+Main.MP3Collection.MP3s[MP3ID].Size;
                       // duration
                       Main.MP3Collection.MP3s[MP3ID].Duration:=Form1.GetMP3LengthViaTMediaPlayer(MP3Path.Text); // in Main.dcu
                       Main.MP3Collection.Duration:=Main.MP3Collection.Duration+Main.MP3Collection.MP3s[MP3ID].Duration;
                       Main.MP3Collection.Albums[AlbumID].Duration:=Main.MP3Collection.Albums[AlbumID].Duration+Main.MP3Collection.MP3s[MP3ID].Duration;
                       except
                       end;
                       // copying MP3 to the location
                       APIFrom:=PChar(MP3Path.Text);
                       APITo:=PChar(FilePath);
                       CopyFile(APIFrom,APITo,false);
                       if Settings.ADel then DeleteFile(APIFrom); // automatic delete of source file
                       // visualization of the import
                       Application.CreateForm(TImportW,ImportW);
                       RepaintForm('ImportW');
                       TranslateForm('ImportW',Main.Settings.Lang);
                       ImportW.Show;
                       ImportW.ImportOne;
                       //
                       if Main.Settings.ADel then DeleteFile(MP3Path.Text); // automatic "cleaning"
                       end
                  else begin // this can be only done when no new mp3 imported
                       //
                       if OldName<>MP3Name.Text then begin
                                                     // changing MP3Name
                                                     FilePath:=Main.MP3Collection.MP3s[MP3ID].Path;
                                                     APIFrom:=PChar(FilePath);
                                                     FilePath2:=Main.MP3Collection.MP3s[MP3ID].Path;
                                                     Delete(FilePath2,Length(FilePath2)-(Length(OldName)+3),Length(FilePath2));
                                                     FilePath2:=FilePath2+inttostr(Main.MP3Collection.MP3s[MP3ID].Order)+' - '+MP3Name.Text+'.mp3';
                                                     APITo:=PChar(FilePath2);
                                                     CopyFile(APIFrom,APITo,false);
                                                     DeleteFile(APIFrom);
                                                     MP3Path.Text:=FilePath2;
                                                     end;
                       if OldLocation<>AlbumID then begin
                                                    // moving MP3 from one album to another
                                                    FilePath2:=Main.MP3Collection.MP3s[MP3ID].Path;
                                                    APIFrom:=PChar(FilePath2);
                                                    FilePath:=Main.MP3Collection.Path;
                                                    CheckLastBackslash(FilePath);
                                                    if Main.MP3Collection.Albums[AlbumID].Name='_root' then FilePath:=FilePath+'_root\'+inttostr(Main.MP3Collection.MP3s[MP3ID].Order)+' - '+MP3Name.Text+'.mp3'
                                                                                                       else FilePath:=FilePath+'_root\'+inttostr(Main.MP3Collection.Albums[AlbumID].Order)+' - '+Main.MP3Collection.Albums[AlbumID].Name+'\'+inttostr(Main.MP3Collection.MP3s[MP3ID].Order)+' - '+MP3Name.Text+'.mp3';
                                                    MP3Path.Text:=FilePath;
                                                    APITo:=PChar(FilePath);
                                                    CopyFile(APIFrom,APITo,false);
                                                    DeleteFile(APIFrom);
                                                    // updating file sizes and mp3 count
                                                    // count
                                                    Main.MP3Collection.Albums[OldLocation].MP3No:=Main.MP3Collection.Albums[OldLocation].MP3No+1;
                                                    Main.MP3Collection.Albums[AlbumID].MP3No:=Main.MP3Collection.Albums[AlbumID].MP3No+1;
                                                    // size
                                                    Main.MP3Collection.Albums[OldLocation].Size:=Main.MP3Collection.Albums[OldLocation].Size-Main.MP3Collection.MP3s[MP3ID].Size;
                                                    Main.MP3Collection.Albums[AlbumID].Size:=Main.MP3Collection.Albums[AlbumID].Size+Main.MP3Collection.MP3s[MP3ID].Size;
                                                    // duration
                                                    Main.MP3Collection.Albums[OldLocation].Duration:=Main.MP3Collection.Albums[OldLocation].Duration-Main.MP3Collection.MP3s[MP3ID].Duration;
                                                    Main.MP3Collection.Albums[AlbumID].Duration:=Main.MP3Collection.Albums[AlbumID].Duration+Main.MP3Collection.MP3s[MP3ID].Duration;
                                                    end;
                       end;

//
// this is done anyway
Main.MP3Collection.MP3s[MP3ID].Name:=MP3Name.Text;
if MP3Album.ItemIndex=-1 then MP3Album.ItemIndex:=0;
Main.MP3Collection.MP3s[MP3ID].Album:=AlbumID;
Main.MP3Collection.MP3s[MP3ID].Path:=FilePath;
Main.MP3Collection.MP3s[MP3ID].Image:=OpenPictureDialog1.FileName;
// saving image thumbnail
if Main.MP3Collection.MP3s[MP3ID].Image<>InitDir+'EmptyMP3.bmp' then begin // this "default" image doesnt have to handled
                                                                     Main.MP3Collection.MP3s[MP3ID].Image:=MP3Collection.Path+'_art\MP3_'+inttostr(MP3ID)+'.jpg';
                                                                     MP3Image.Picture.SaveToFile(MP3Collection.Path+'_art\MP3_'+inttostr(MP3ID)+'.jpg');
                                                                     end;
//
try // may cause errors
// fills MP3Tags
Main.MP3Collection.MP3s[MP3ID].ID3v2:=ReadID3v2Tags(MP3Path.Text);
// automatic conversion of Tags
if Settings.CTgs then ConvertID3v2ToID3v1(MP3ID) // in ID3Utilities.dcu
                 else Main.MP3Collection.MP3s[MP3ID].ID3v1:=ReadID3v1Tags(MP3Path.Text);
// automatic setting of Track parameter
if Settings.ACTr then begin
                      Main.MP3Collection.MP3s[MP3ID].ID3v2.Track:=inttostr(Main.MP3Collection.MP3s[MP3ID].Order);
                      try
                       Main.MP3Collection.MP3s[MP3ID].ID3v1.Track:=Main.MP3Collection.MP3s[MP3ID].Order;
                      except
                       Main.MP3Collection.MP3s[MP3ID].ID3v1.Track:=0; // if order higher than 255
                      end;
                      end;
// automatic setting of Common values for album
if Settings.ASet then AutoSetTags(MP3ID,AlbumID);
// saving possible tags changes
WriteID3v1Tags(MP3Collection.MP3s[MP3ID].Path);
WriteID3v2Tags(MP3Collection.MP3s[MP3ID].Path,MP3ID);
//
except
// i will handle it later
end;
// MP3 Order has to be controlled
try
 if Inicialization then Main.MP3Collection.MP3s[MP3ID].Order:=UpDown1.Position; // otherwise no previous value
 OptimalizeMP3Order(Main.MP3Collection.MP3s[MP3ID].Order,UpDown1.Position);        // first move the rest
 SetMP3FileNumber(MP3ID,Main.MP3Collection.MP3s[MP3ID].Order,UpDown1.Position,Inicialization); // (in MP3Utilities.dcu) // than update the folder name
 Main.MP3Collection.MP3s[MP3ID].Order:=UpDown1.Position;                           // than update the order
 Form1.ResetMP3Components; // rewrite program components
 Form1.AlbumList.ItemIndex:=AlbumID;
 Form1.AlbumListClick(Sender);
 MP3W.Close; // only if this step is properly handled - otherwise it will stay opened to user can update the value
except
 ShowMessage(TranslateText('EInvalidInput',Settings.Lang));
end;
end;
end else ShowMessage(TranslateText('EInvalidMP3Input',Settings.Lang)); // if user hasn�t selected mp3 file yet...
end;
except
 Main.MP3Collection.MP3s[MP3ID].Name:='_Empty'; // setting current slot as empty - anything that was added in it, will be ignored
 ShowMessage(TranslateText('ECannotImportMP3',Settings.Lang));
end;
end; // {loop 1}
end; // end of "Case"
OkB.Enabled:=true; // should be used again
end;

procedure TMP3W.CancelBClick(Sender: TObject);
begin
MP3W.Close;
end;

procedure TMP3W.Button1Click(Sender: TObject);
var Text: string;
begin
if OpenMP3.Execute then begin
                        MP3Path.Text:=OpenMP3.FileName;
                        Text:=OpenMP3.FileName; // TCaption and string is not the same for compiler
                        CutPath(Text);
                        Delete(Text,101,256); // only 100 chars allowed
                        MP3Name.Text:=Text;
                        end;
end;

procedure TMP3W.Button2Click(Sender: TObject);
begin
if OpenPictureDialog1.Execute then begin
                                   OpenPictureDialog1.InitialDir:=GetCurrentDir;
                                   try
                                   MP3Image.Picture.LoadFromFile(OpenPictureDialog1.FileName);
                                   MP3Image.Picture.Graphic.LoadFromFile(OpenPictureDialog1.FileName);
                                   except
                                   // nothing so far
                                   end;
                                   end;
end;

procedure TMP3W.MP3AlbumChange(Sender: TObject);
// change of target album where the MP3 will be imported
var i: integer;
begin
if MP3Album.ItemIndex=0 then MP3Album.Text:='_root';
i:=-1;
repeat
i:=i+1;
until (Main.MP3Collection.Albums[i].Name=MP3Album.Text)or(i>=high(Main.MP3Collection.Albums));
AlbumID:=i;
if MP3Album.ItemIndex=0 then MP3Album.Text:='...';
// reload default album image (if any)
if Main.MP3Collection.Albums[AlbumID].Image<>InitDir+'EmptyAlbum.jpg' then try
                                                                            OpenPictureDialog1.FileName:=Main.MP3Collection.Albums[AlbumID].Image;
                                                                            MP3Image.Picture.LoadFromFile(Main.MP3Collection.Albums[AlbumID].Image);
                                                                           except
                                                                            try
                                                                             OpenPictureDialog1.FileName:=InitDir+'EmptyMP3.jpg';
                                                                             MP3Image.Picture.LoadFromFile(InitDir+'EmptyMP3.jpg');
                                                                            except
                                                                             // if this failes, the whole program is about to crash
                                                                             ShowMessage(TranslateText('FEMissingFile1',Settings.Lang)+'EmptyMP3.jpg'+TranslateText('FEMissingFile2',Settings.Lang));
                                                                             CrucialE:=true; // the program must be terminated with no asking
                                                                             MP3W.Close;
                                                                             Form1.Close;
                                                                            end;
                                                                           end
                                                                      else try
                                                                            OpenPictureDialog1.FileName:=InitDir+'EmptyMP3.jpg';
                                                                            MP3Image.Picture.LoadFromFile(InitDir+'EmptyMP3.jpg');
                                                                           except
                                                                            // if this failes, the whole program is about to crash
                                                                            ShowMessage(TranslateText('FEMissingFile1',Settings.Lang)+'EmptyMP3.jpg'+TranslateText('FEMissingFile2',Settings.Lang));
                                                                            CrucialE:=true; // the program must be terminated with no asking
                                                                            MP3W.Close;
                                                                            Form1.Close;
                                                                           end;
end;

end.

