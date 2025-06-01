program MineSweeperFMX;



uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  MineSweeper.Main in 'MineSweeper.Main.pas' {FormMain},
  HGM.FMX.Ani in 'HGM.FMX.Ani.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
