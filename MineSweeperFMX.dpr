program MineSweeperFMX;



uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  MineSweeper.Main in 'MineSweeper.Main.pas' {FormMain},
  FMX.Vibrate in 'FMXVibration\FMX.Vibrate.pas',
  MineSweeper.ThreadObjectList in 'MineSweeper.ThreadObjectList.pas',
  HGM.FMX.Ani in 'HGM.FMX.Ani.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
