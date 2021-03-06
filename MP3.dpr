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
// *  Author:         *  Ellrohir [ ellrohir@seznam.cz ]         * //
// *  Homepage:       *  http://www.browneyer.org/xmen/ellrohir  * //
// *  System Version: *  1.0                                     * //
// *  Last Modified:  *  2008-03-11 1400 GMT+1                   * //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
/////////////////////////////////////////////////////////////////////

program MP3;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  PlayerU in 'PlayerU.pas',
  SettingsU in 'SettingsU.pas' {SettingsW},
  MP3Utilities in 'MP3Utilities.pas',
  ID3Utilities in 'ID3Utilities.pas',
  CollectionU in 'CollectionU.pas' {CollectionW},
  AlbumU in 'AlbumU.pas' {AlbumW},
  WorkingU in 'WorkingU.pas',
  MP3U in 'MP3U.pas' {MP3W},
  ImportU in 'ImportU.pas' {ImportW},
  SkinU in 'SkinU.pas' {SkinW},
  MixerU in 'MixerU.pas',
  FileSystemUtilities in 'FileSystemUtilities.pas',
  AboutU in 'AboutU.pas' {AboutW};

{$R *.res}

begin            
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  if not Main.CrucialE then Application.Run;
end.
