unit MineSweeper.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.EditBox,
  FMX.SpinBox, FMX.ListBox, FMX.Ani, System.Skia, FMX.Skia, FMX.TabControl,
  FMX.Objects, FMX.Player, System.Generics.Collections;



{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  {$DEFINE MOBILE}
{$ENDIF}

type
  {$SCOPEDENUMS ON}
  TGameDifficult = (Easy, Normal, Hard, Expert);
  {$SCOPEDENUMS OFF}

  TCellControl = TTextControl;

  TGameCell = record
    Button: TCellControl;
    Closed: Boolean;
    Bomb: Boolean;
    BombAround: Byte;
    Flag: Boolean;
    X, Y: Byte;
  end;

  TGameField = TArray<TArray<TGameCell>>;

  TFormMain = class(TForm)
    LayoutGameHead: TLayout;
    ScrollBoxField: TScrollBox;
    Timer: TTimer;
    ButtonNewGame: TButton;
    LayoutField: TLayout;
    StyleBook: TStyleBook;
    TabControlMain: TTabControl;
    TabItemGame: TTabItem;
    TabItemStart: TTabItem;
    TabItemRecords: TTabItem;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Layout3: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    PathMines: TPath;
    LabelTimer: TLabel;
    LabelMines: TLabel;
    Path1: TPath;
    ButtonEndGame: TButton;
    LayoutMenu: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    LabelFieldSize: TLabel;
    ButtonFieldSizeDown: TButton;
    ButtonFieldSizeUp: TButton;
    ButtonDiffDown: TButton;
    LabelDificult: TLabel;
    ButtonDiffUp: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    ButtonAbout: TButton;
    LayoutResult: TLayout;
    RectangleWin: TRectangle;
    Label1: TLabel;
    ButtonMoreGame: TButton;
    ButtonGameMenu: TButton;
    GridPanelLayout2: TGridPanelLayout;
    RectangleLose: TRectangle;
    Label3: TLabel;
    GridPanelLayout3: TGridPanelLayout;
    ButtonTryAgain: TButton;
    Button2: TButton;
    AnimatedImageWin: TSkAnimatedImage;
    AnimatedImageWin2: TSkAnimatedImage;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    ButtonHideResult: TButton;
    LayoutRestart: TLayout;
    Rectangle2: TRectangle;
    Button1: TButton;
    LabelWinState: TLabel;
    Label6: TLabel;
    Layout1: TLayout;
    ButtonVibrateLeft: TButton;
    LabelVibrate: TLabel;
    ButtonVibrateRight: TButton;
    TimerBombs: TTimer;
    LayoutGame: TLayout;
    Layout4: TLayout;
    ButtonSoundLeft: TButton;
    LabelSound: TLabel;
    ButtonSoundRight: TButton;
    Label8: TLabel;
    LayoutScrollField: TLayout;
    LayoutScrollLeft: TLayout;
    LayoutScrollRight: TLayout;
    LayoutScrollTop: TLayout;
    LayoutScrollBottom: TLayout;
    PathST: TPath;
    PathSR: TPath;
    PathSL: TPath;
    PathSB: TPath;
    procedure ButtonNewGameClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonEndGameClick(Sender: TObject);
    procedure ButtonFieldSizeDownClick(Sender: TObject);
    procedure ButtonFieldSizeUpClick(Sender: TObject);
    procedure ButtonDiffDownClick(Sender: TObject);
    procedure ButtonDiffUpClick(Sender: TObject);
    procedure ButtonGameMenuClick(Sender: TObject);
    procedure ButtonHideResultClick(Sender: TObject);
    procedure ButtonVibrateLeftClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerBombsTimer(Sender: TObject);
    procedure TabControlMainChange(Sender: TObject);
    procedure ButtonSoundLeftClick(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure ScrollBoxFieldViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
  private
    FField: TGameField;
    FSize: Byte;
    FGameStarted: TDateTime;
    FDifficult: TGameDifficult;
    FBombCount: Integer;
    FWasLongTap: Boolean;
    FActivateBombList: TList<TCellControl>;
    FPlayer: TFMXCustomPlayer;
    FCellMoving: Boolean;
    FCellDown: Boolean;
    FCellDownPoint: TPointF;
    FIsFirstClick: Boolean;
    function GetAroundBombCount(const X, Y: Integer): Byte;
    procedure Lose;
    procedure OpenAll(X, Y, Enum: Integer);
    procedure DoClick(X, Y, Enum: Integer);
    procedure ActivateBomb(Button: TCellControl);
    procedure InternalActivateBomb(Button: TCellControl);
    function IsValidCoords(const X, Y: Integer): Boolean;
    function CheckForWin: Boolean;
    procedure DoWin;
    procedure DoRightClick(X, Y: Integer);
    procedure UpdateDifficult;
    procedure UpdateFieldSize;
    procedure EndGame;
    procedure Sound(const FileName: string);
    {$HINTS OFF}
    procedure FOnCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FOnGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FOnTapEvent(Sender: TObject; const Point: TPointF);
    {$HINTS ON}
    procedure JumpToStart;
    procedure DoOpenAround(X, Y: Integer);
    function GetAroundFlagCount(const X, Y: Integer): Byte;
    procedure ProcAround(const X, Y: Integer; Proc: TProc<TGameCell>);
    procedure UpdateVibrate;
    procedure DoVibrate(const Duration: UInt16);
    procedure CancelBombs;
    procedure FOnCellMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FOnCellMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure RecalcBombs(const ExX, ExY: Integer);
    procedure UpdateSound;
  public
    procedure NewGame(const Size: Integer; Difficult: TGameDifficult);
    function GetSize: Integer;
    function GetDifficult: TGameDifficult;
  end;

var
  FormMain: TFormMain;
  BombQueue: integer = 0;

const
  CountColors: array[0..9] of TAlphaColor = (
    TAlphaColorRec.Null,
    TAlphaColorRec.Deepskyblue,
    TAlphaColorRec.Yellowgreen,
    TAlphaColorRec.Orangered,
    TAlphaColorRec.Hotpink,
    TAlphaColorRec.Hotpink,
    TAlphaColorRec.Hotpink,
    TAlphaColorRec.Hotpink,
    TAlphaColorRec.Black,
    TAlphaColorRec.Null
    );
  MinFieldSize = 6;
  MaxFieldSize = 32;
  CellSize = 32;
  CellGap = 4;

implementation

uses
  System.DateUtils, System.Math, FMX.Vibrate, System.IOUtils, System.Threading,
  HGM.FMX.Ani;

{$R *.fmx}

procedure TFormMain.ButtonFieldSizeDownClick(Sender: TObject);
begin
  if LabelFieldSize.Tag <= MinFieldSize then
    LabelFieldSize.Tag := MaxFieldSize
  else
    LabelFieldSize.Tag := LabelFieldSize.Tag - 1;
  UpdateFieldSize;
end;

procedure TFormMain.ButtonFieldSizeUpClick(Sender: TObject);
begin
  if LabelFieldSize.Tag >= MaxFieldSize then
    LabelFieldSize.Tag := MinFieldSize
  else
    LabelFieldSize.Tag := LabelFieldSize.Tag + 1;
  UpdateFieldSize;
end;

procedure TFormMain.JumpToStart;
begin
  TabControlMain.ActiveTab := TabItemStart;
  LayoutRestart.Margins.Bottom := -LayoutRestart.Height;
  CancelBombs;
end;

procedure TFormMain.ButtonGameMenuClick(Sender: TObject);
begin
  JumpToStart;
end;

procedure TFormMain.ButtonHideResultClick(Sender: TObject);
begin
  TAnimator.AnimateFloat(LayoutResult, 'Margins.Top', Height);
  TAnimator.AnimateFloatWithFinish(LayoutResult, 'Opacity', 0,
    procedure
    begin
      LayoutResult.Visible := False;
    end);

  LayoutRestart.Margins.Bottom := -LayoutRestart.Height;
  TAnimator.AnimateFloat(LayoutRestart, 'Margins.Bottom', 0);
end;

procedure TFormMain.UpdateDifficult;
begin
  case TGameDifficult(LabelDificult.Tag) of
    TGameDifficult.Easy:
      LabelDificult.Text := 'Easy';
    TGameDifficult.Normal:
      LabelDificult.Text := 'Normal';
    TGameDifficult.Hard:
      LabelDificult.Text := 'Hard';
    TGameDifficult.Expert:
      LabelDificult.Text := 'Expert';
  end;
end;

procedure TFormMain.UpdateVibrate;
begin
  if LabelVibrate.Tag = 1 then
    LabelVibrate.Text := 'Yes'
  else
    LabelVibrate.Text := 'No';
end;

procedure TFormMain.UpdateSound;
begin
  if LabelSound.Tag = 1 then
    LabelSound.Text := 'Yes'
  else
    LabelSound.Text := 'No';
end;

procedure TFormMain.UpdateFieldSize;
begin
  LabelFieldSize.Text := LabelFieldSize.Tag.ToString + 'x' + LabelFieldSize.Tag.ToString;
end;

procedure TFormMain.ButtonAboutClick(Sender: TObject);
begin
  ShowMessage('Created by HemulGM');
end;

procedure TFormMain.ButtonDiffDownClick(Sender: TObject);
begin
  if LabelDificult.Tag <= 0 then
    LabelDificult.Tag := Ord(TGameDifficult.Expert)
  else
    LabelDificult.Tag := LabelDificult.Tag - 1;
  UpdateDifficult;
end;

procedure TFormMain.ButtonDiffUpClick(Sender: TObject);
begin
  if LabelDificult.Tag >= Ord(TGameDifficult.Expert) then
    LabelDificult.Tag := 0
  else
    LabelDificult.Tag := LabelDificult.Tag + 1;
  UpdateDifficult;
end;

procedure TFormMain.ButtonEndGameClick(Sender: TObject);
begin
  JumpToStart;
  EndGame;
end;

procedure TFormMain.ButtonNewGameClick(Sender: TObject);
begin
  NewGame(GetSize, GetDifficult);
end;

procedure TFormMain.ButtonSoundLeftClick(Sender: TObject);
begin
  if LabelSound.Tag = 0 then
    LabelSound.Tag := 1
  else
    LabelSound.Tag := 0;
  Sound('open.mp3');
  UpdateSound;
end;

procedure TFormMain.ButtonVibrateLeftClick(Sender: TObject);
begin
  if LabelVibrate.Tag = 0 then
    LabelVibrate.Tag := 1
  else
    LabelVibrate.Tag := 0;
  DoVibrate(200);
  UpdateVibrate;
end;

function TFormMain.GetDifficult: TGameDifficult;
begin
  Result := TGameDifficult(LabelDificult.Tag);
end;

function TFormMain.GetSize: Integer;
begin
  Result := LabelFieldSize.Tag;
end;

procedure TFormMain.CancelBombs;
begin
  TimerBombs.Enabled := False;
  Inc(BombQueue);
  FActivateBombList.Clear;
end;

procedure TFormMain.InternalActivateBomb(Button: TCellControl);
begin
  Button.StyleLookup := 'cell_bomb';
  var Ani: TColorAnimation;
  if Button.FindStyleResource<TColorAnimation>('open', Ani) then
    Ani.Start;
  var Bomb: TSkAnimatedImage;
  if Button.FindStyleResource<TSkAnimatedImage>('bomb', Bomb) then
  begin
    {$IFDEF MSWINDOWS}
    var Delay := Round(Bomb.Animation.Duration * 1000 - 500);
    var CurrentBombQueue := BombQueue;
    TTask.Run(
      procedure
      begin
        Sleep(Delay);
        if CurrentBombQueue <> BombQueue then
          Exit;
        Sound('explosion.wav');
      end);
    {$ELSE}
    DoVibrate(100);
    {$ENDIF}
    Bomb.Animation.Start;
  end;
  var BombDone: TFloatAnimation;
  if Button.FindStyleResource<TFloatAnimation>('bomb_done', BombDone) then
  begin
    BombDone.Delay := Bomb.Animation.Duration * Bomb.Animation.StopProgress + Bomb.Animation.Delay;
    BombDone.Start;
  end;
  Button.StylesData['skull.Opacity'] := 1.0;
end;

function TFormMain.IsValidCoords(const X, Y: Integer): Boolean;
begin
  Result := (X >= 0) and (X < FSize) and (Y >= 0) and (Y < FSize);
end;

procedure TFormMain.ProcAround(const X, Y: Integer; Proc: TProc<TGameCell>);
begin
  for var BX := -1 to +1 do
    for var BY := -1 to +1 do
      if not ((BX = 0) and (BY = 0)) then
        if IsValidCoords(X + BX, Y + BY) then
          Proc(FField[X + BX, Y + BY]);
end;

procedure TFormMain.ScrollBoxFieldViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  PathST.Visible :=
        (ScrollBoxField.ContentBounds.Height > ScrollBoxField.Height) and
        (ScrollBoxField.ViewportPosition.Y > (ScrollBoxField.Height - ScrollBoxField.ContentBounds.Height) / 2 + 10);
  PathSB.Visible :=
        (ScrollBoxField.ContentBounds.Height > ScrollBoxField.Height) and
        (ScrollBoxField.ViewportPosition.Y < (ScrollBoxField.ContentBounds.Height - ScrollBoxField.Height) / 2 - 10);

  PathSL.Visible :=
        (ScrollBoxField.ContentBounds.Width > ScrollBoxField.Width) and
        (ScrollBoxField.ViewportPosition.X > (ScrollBoxField.Width - ScrollBoxField.ContentBounds.Width) / 2 + 10);
  PathSR.Visible :=
        (ScrollBoxField.ContentBounds.Width > ScrollBoxField.Width) and
        (ScrollBoxField.ViewportPosition.X < (ScrollBoxField.ContentBounds.Width - ScrollBoxField.Width) / 2 - 10);
end;

procedure TFormMain.Sound(const FileName: string);
begin
  if LabelSound.Tag <> 1 then
    Exit;
  var Root: string;
  {$IFDEF MSWINDOWS}
  Root := TPath.GetLibraryPath;
  {$ELSE}
  Root := TPath.GetDocumentsPath;
  {$ENDIF}
  FPlayer.QuickPlayFile(TPath.Combine(Root, 'sound', FileName));
end;

function TFormMain.GetAroundBombCount(const X, Y: Integer): Byte;
begin
  var BombCount: Byte := 0;
  ProcAround(X, Y,
    procedure(Cell: TGameCell)
    begin
      if Cell.Bomb then
        Inc(BombCount);
    end);
  Result := BombCount;
end;

function TFormMain.GetAroundFlagCount(const X, Y: Integer): Byte;
begin
  var FlagCount: Byte := 0;
  ProcAround(X, Y,
    procedure(Cell: TGameCell)
    begin
      if Cell.Flag then
        Inc(FlagCount);
    end);
  Result := FlagCount;
end;

procedure TFormMain.EndGame;
begin
  Timer.Enabled := False;
  LayoutField.Enabled := False;
end;

procedure TFormMain.FOnGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if EventInfo.GestureID = igiLongTap then
  begin
    Handled := True;
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
    begin
      var Btn := Sender as TCellControl;
      var BX := Btn.StylesData['X'].AsInteger;
      var BY := Btn.StylesData['Y'].AsInteger;
      DoVibrate(200);
      DoRightClick(BX, BY);
      FWasLongTap := True;
    end;
  end;
  if EventInfo.GestureID = igiDoubleTap then
  begin
    Handled := True;
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
    begin
      var Btn := Sender as TCellControl;
      var BX := Btn.StylesData['X'].AsInteger;
      var BY := Btn.StylesData['Y'].AsInteger;

      if IsValidCoords(BX, BY) and (not FField[BX, BY].Closed) then
      begin
        DoVibrate(300);
        DoOpenAround(BX, BY);
      end;
    end;
  end;
end;

procedure TFormMain.OpenAll(X, Y, Enum: Integer);
begin
  ProcAround(X, Y,
    procedure(Cell: TGameCell)
    begin
      if Cell.Closed then
        DoClick(Cell.X, Cell.Y, Enum);
    end);
end;

procedure TFormMain.ActivateBomb(Button: TCellControl);
begin
  FActivateBombList.Insert(Random(FActivateBombList.Count), Button);
  TimerBombs.Enabled := True;
end;

function TFormMain.CheckForWin: Boolean;
begin
  var Count: Integer := 0;
  for var i := 0 to FSize - 1 do
    for var j := 0 to FSize - 1 do
      if (FField[i, j].Closed) then
        Inc(Count);
  Result := Count = FBombCount;
end;

procedure TFormMain.DoRightClick(X, Y: Integer);
begin
  if not IsValidCoords(X, Y) then
    Exit;
  if not FField[X, Y].Closed then
    Exit;
  if FField[X, Y].Closed then
  begin
    if not FField[X, Y].Flag then
    begin
      if LabelMines.Tag <= 0 then
        Exit;
      LabelMines.Tag := LabelMines.Tag - 1;
      LabelMines.Text := LabelMines.Tag.ToString;
      FField[X, Y].Flag := True;
      FField[X, Y].Button.StyleLookup := 'cell_flag';
      var ScaleAni: TRectAnimation;
      if FField[X, Y].Button.FindStyleResource<TRectAnimation>('scale', ScaleAni) then
      begin
        FField[X, Y].Button.BringToFront;
        ScaleAni.Start;
      end;
      Sound('flag.mp3');
    end
    else
    begin
      LabelMines.Tag := LabelMines.Tag + 1;
      LabelMines.Text := LabelMines.Tag.ToString;
      FField[X, Y].Flag := False;
      FField[X, Y].Button.StyleLookup := 'cell_closed';
    end;
  end;
end;

procedure TFormMain.DoVibrate(const Duration: UInt16);
begin
  if LabelVibrate.Tag = 0 then
    Exit;
  Vibrate(Duration);
end;

procedure TFormMain.DoOpenAround(X, Y: Integer);
begin
  if not IsValidCoords(X, Y) then
    Exit;
  if FField[X, Y].Closed then
    Exit;
  if FField[X, Y].BombAround <= 0 then
    Exit;
  if GetAroundFlagCount(X, Y) <> FField[X, Y].BombAround then
  begin
    var ScaleAni: TFloatAnimation;
    if FField[X, Y].Button.FindStyleResource<TFloatAnimation>('scale', ScaleAni) then
    begin
      FField[X, Y].Button.BringToFront;
      ScaleAni.Start;
    end;
    Exit;
  end;
  var OpenCount := 0;
  ProcAround(X, Y,
    procedure(Cell: TGameCell)
    begin
      if (not Cell.Flag) and (Cell.Closed) then
      begin
        DoClick(Cell.X, Cell.Y, 0);
        Inc(OpenCount);
      end;
    end);
  if CheckForWin then
    DoWin
  else if OpenCount > 0 then
    Sound('open_around.mp3');
end;

procedure TFormMain.DoClick(X, Y, Enum: Integer);
begin
  if not IsValidCoords(X, Y) then
    Exit;
  if FIsFirstClick then
  begin
    FIsFirstClick := False;
    RecalcBombs(X, Y);
  end;
  if not FField[X, Y].Closed then
    Exit;
  if FField[X, Y].Flag then
    Exit;
  if FField[X, Y].Bomb then
  begin
    InternalActivateBomb(FField[X, Y].Button);
    for var NX := 0 to FSize - 1 do
      for var NY := 0 to FSize - 1 do
        if FField[NX, NY].Bomb and not ((NX = X) and (NY = Y)) and not FField[NX, NY].Flag then
          ActivateBomb(FField[NX, NY].Button);
    {$IFNDEF MSWINDOWS}
    var Delay := Round(2.5 * 1000 - 500);
    var CurrentBombQueue := BombQueue;
    TTask.Run(
      procedure
      begin
        Sleep(Delay);
        for var i := 1 to 4 do
        begin
          if CurrentBombQueue <> BombQueue then
            Exit;
          TThread.Queue(nil,
            procedure
            begin
              if CurrentBombQueue <> BombQueue then
                Exit;
              Sound('explosion.wav');
            end);
          Sleep(Random(400 - 100) + 100);
        end;
      end);
    {$ENDIF}
    Lose;
    Exit;
  end;
  FField[X, Y].Closed := False;
  var Btn := FField[X, Y].Button;
  if FField[X, Y].BombAround <> 0 then
  begin
    Btn.StyleLookup := 'cell_count';
    Btn.StyledSettings := Btn.StyledSettings - [TStyledSetting.FontColor];
    Btn.FontColor := CountColors[FField[X, Y].BombAround];
    var Ani: TColorAnimation;
    if Btn.FindStyleResource<TColorAnimation>('open', Ani) then
    begin
      Ani.Delay := Enum / 200;
      Ani.Start;
    end;
    if Enum = 0 then
      Sound('open.mp3');
  end
  else
  begin
    Btn.StyleLookup := 'cell_empty';
    Btn.HitTest := False;
    var Ani: TColorAnimation;
    if Btn.FindStyleResource<TColorAnimation>('open', Ani) then
    begin
      Ani.Delay := Enum / 200;
      Ani.Start;
    end;
    OpenAll(X, Y, Enum + 1);
    if Enum = 0 then
      Sound('open_empty.mp3');
  end;
end;

procedure TFormMain.Lose;
begin
  LayoutResult.Visible := True;
  LayoutResult.Margins.Top := -200;
  LayoutResult.Opacity := 0;
  LayoutResult.BringToFront;
  RectangleLose.Visible := True;
  RectangleWin.Visible := False;
  TAnimator.AnimateFloatDelay(LayoutResult, 'Margins.Top', 0, 0.2, 2);
  TAnimator.AnimateFloatDelay(LayoutResult, 'Opacity', 1, 0.2, 2);
  EndGame;
end;

procedure TFormMain.DoWin;
begin
  Sound('win.mp3');
  DoVibrate(200);
  DoVibrate(1000);
  LabelWinState.Text := LabelFieldSize.Text + ' - ' + LabelDificult.Text;
  LayoutResult.Visible := True;
  LayoutResult.Margins.Top := -200;
  LayoutResult.Opacity := 0;
  LayoutResult.BringToFront;
  RectangleLose.Visible := False;
  RectangleWin.Visible := True;
  TAnimator.AnimateFloatDelay(LayoutResult, 'Margins.Top', 0, 0.2, 0.5);
  TAnimator.AnimateFloatDelay(LayoutResult, 'Opacity', 1, 0.2, 0.5);
  AnimatedImageWin.Visible := True;
  AnimatedImageWin.Animation.Delay := 0.5;
  AnimatedImageWin.Animation.Start;
  AnimatedImageWin2.Animation.Start;
  EndGame;
end;

procedure TFormMain.FOnCellMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  Btn: TCellControl absolute Sender;
begin
  if Button = TMouseButton.mbLeft then
  begin
    SetCaptured(Btn);
    FCellMoving := False;
    FCellDown := True;
    FCellDownPoint := Btn.ConvertLocalPointTo(ScrollBoxField, TPointF.Create(X, Y));
  end;
end;

procedure TFormMain.FOnCellMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
  Btn: TCellControl absolute Sender;
begin
  var Pt := Btn.ConvertLocalPointTo(ScrollBoxField, TPointF.Create(X, Y));
  if FCellDown and (Abs(Pt.Distance(FCellDownPoint)) > 10) then
  begin
    FCellDown := False;
    FCellMoving := True;
    ScrollBoxField.AniCalculations.MouseDown(Pt.X, Pt.Y);
  end;
  ScrollBoxField.AniCalculations.MouseMove(Pt.X, Pt.Y);
end;

procedure TFormMain.FOnCellMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  Btn: TCellControl absolute Sender;
begin
  var Pt := Btn.ConvertLocalPointTo(ScrollBoxField, TPointF.Create(X, Y));
  FCellDown := False;
  SetCaptured(nil);
  if FCellMoving then
  begin
    ScrollBoxField.AniCalculations.MouseUp(Pt.X, Pt.Y);
    FCellMoving := False;
    Exit;
  end;
  var BX := Btn.StylesData['X'].AsInteger;
  var BY := Btn.StylesData['Y'].AsInteger;
  if ssDouble in Shift then
    if Button = TMouseButton.mbLeft then
    begin
      DoOpenAround(BX, BY);
      Exit;
    end;
  case Button of
    TMouseButton.mbLeft:
      begin
        DoClick(BX, BY, 0);
        if CheckForWin then
          DoWin;
      end;
    TMouseButton.mbRight:
      begin
        DoRightClick(BX, BY);
      end;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  ScrollBoxField.AniCalculations.Animation := True;
  ScrollBoxField.AniCalculations.BoundsAnimation := False;
  ScrollBoxField.AniCalculations.TouchTracking := [TTouchTrackingItem.ttVertical, TTouchTrackingItem.ttHorizontal];
  FActivateBombList := TList<TCellControl>.Create;
  FPlayer := TFMXCustomPlayer.Create(Self);
  FPlayer.Init;
  {$IFDEF MOBILE}
  LabelFieldSize.Tag := 9;
  {$ELSE}
  LabelFieldSize.Tag := 10;
  {$ENDIF}
  LabelDificult.Tag := 1;
  LabelVibrate.Tag := 1;
  LabelSound.Tag := 1;
  UpdateSound;
  UpdateVibrate;
  UpdateFieldSize;
  UpdateDifficult;
  JumpToStart;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  CancelBombs;
  FActivateBombList.Free;
end;

procedure TFormMain.FOnTapEvent(Sender: TObject; const Point: TPointF);
begin
  if FWasLongTap then
  begin
    FWasLongTap := False;
    Exit;
  end;
  var Btn := Sender as TCellControl;
  var BX := Btn.StylesData['X'].AsInteger;
  var BY := Btn.StylesData['Y'].AsInteger;
  DoVibrate(100);
  DoClick(BX, BY, 0);
  if CheckForWin then
    DoWin;
end;

procedure TFormMain.NewGame(const Size: Integer; Difficult: TGameDifficult);
begin
  FIsFirstClick := True;
  CancelBombs;
  if LayoutRestart.Margins.Bottom = 0 then
    TAnimator.AnimateFloat(LayoutRestart, 'Margins.Bottom', -LayoutRestart.Height);
  if LayoutResult.Visible then
  begin
    TAnimator.AnimateFloat(LayoutResult, 'Margins.Top', Height);
    TAnimator.AnimateFloatWithFinish(LayoutResult, 'Opacity', 0,
      procedure
      begin
        LayoutResult.Visible := False;
      end);
  end;
  LayoutField.Enabled := True;
  AnimatedImageWin.Visible := False;
  FSize := Size;
  FDifficult := Difficult;
  LabelTimer.Text := '1';
  // array
  SetLength(FField, Size, Size);

  FBombCount := 0;
  case Difficult of
    TGameDifficult.Easy:
      FBombCount := Size div 2;
    TGameDifficult.Normal:
      FBombCount := Size;
    TGameDifficult.Hard:
      FBombCount := Size * 2;
    TGameDifficult.Expert:
      FBombCount := Size * 3;
  end;
  LabelMines.Text := FBombCount.ToString;
  LabelMines.Tag := FBombCount;

  LayoutField.BeginUpdate;
  try
    // grid
    while LayoutField.ControlsCount > 0 do
      LayoutField.Controls[0].Free;
    LayoutField.Width := CellSize * Size + Size * CellGap;
    LayoutField.Height := CellSize * Size + Size * CellGap;
    for var X := 0 to Size - 1 do
      for var Y := 0 to Size - 1 do
      begin
        // button
        var Button := TCellControl.Create(LayoutField);
        Button.Size.Size := TSizeF.Create(CellSize, CellSize);
        Button.Position.Point := TPointF.Create(X * CellSize + X * CellGap, Y * CellSize + Y * CellGap);
        Button.TextSettings.HorzAlign := TTextAlign.Center;
        Button.TextSettings.VertAlign := TTextAlign.Center;
        Button.Text := '';
        Button.HitTest := True;
        {$IFDEF MOBILE}
        Button.OnTap := FOnTapEvent;
        Button.OnGesture := FOnGesture;
        Button.Touch.InteractiveGestures := [TInteractiveGesture.LongTap, TInteractiveGesture.DoubleTap];
        {$ELSE}
        Button.OnMouseUp := FOnCellMouseUp;
        Button.OnMouseDown := FOnCellMouseDown;
        Button.OnMouseMove := FOnCellMouseMove;
        Button.TouchTargetExpansion.Rect := TRectF.Empty;
        {$ENDIF}
        Button.StylesData['X'] := X;
        Button.StylesData['Y'] := Y;
        Button.StyleLookup := 'cell_closed';
        Button.DisableDisappear := True;
        LayoutField.AddObject(Button);
        // array
        FField[X, Y].Button := Button;
        FField[X, Y].Closed := True;
        FField[X, Y].Bomb := False;
        FField[X, Y].Flag := False;
        FField[X, Y].X := X;
        FField[X, Y].Y := Y;
      end;
  finally
    LayoutField.EndUpdate;
  end;

  Sound('start.mp3');

  // timer
  Timer.Enabled := True;
  FGameStarted := Now;
  TabControlMain.ActiveTab := TabItemGame;
end;

procedure TFormMain.RecalcBombs(const ExX, ExY: Integer);
begin
  for var i := 1 to FBombCount do
  begin
    var X, Y: Integer;
    repeat
      X := Random(FSize - 1);
      Y := Random(FSize - 1);
    until (not FField[X, Y].Bomb) and (not ((X = ExX) and (Y = ExY)));
    FField[X, Y].Bomb := True;
  end;

  for var X := 0 to FSize - 1 do
    for var Y := 0 to FSize - 1 do
    begin
      FField[X, Y].BombAround := GetAroundBombCount(X, Y);
      FField[X, Y].Button.Text := FField[X, Y].BombAround.ToString;
    end;
end;

procedure TFormMain.TabControlMainChange(Sender: TObject);
begin
  if TabControlMain.ActiveTab = TabItemStart then
  begin
    LayoutMenu.Opacity := 0;
    TAnimator.AnimateFloat(LayoutMenu, 'Opacity', 1);
  end;
  if TabControlMain.ActiveTab = TabItemGame then
  begin
    LayoutGame.Opacity := 0;
    TAnimator.AnimateFloat(LayoutGame, 'Opacity', 1);
  end;
end;

procedure TFormMain.TimerBombsTimer(Sender: TObject);
begin
  if FActivateBombList.Count > 0 then
  begin
    TimerBombs.Interval := Random(200 - 30) + 30;
    var Btn := FActivateBombList[0];
    FActivateBombList.Delete(0);
    InternalActivateBomb(Btn);
  end
  else
    TimerBombs.Enabled := False;
end;

procedure TFormMain.TimerTimer(Sender: TObject);
begin
  LabelTimer.Text := Max(1, SecondsBetween(Now, FGameStarted)).ToString;
end;

initialization
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

end.

