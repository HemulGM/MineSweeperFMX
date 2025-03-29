unit FMX.Vibrate;

interface

uses
  System.Sysutils,
  {$IFDEF ANDROID}
  Androidapi.JNI.Os, Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNIBridge,
  {$ENDIF}
  {$IFDEF IOS}
  IOSapi.MediaPlayer, IOSapi.CoreGraphics, FMX.Platform.IOS, IOSapi.UIKit,
  Macapi.ObjCRuntime, Macapi.ObjectiveC, iOSapi.Cocoatypes,
  Macapi.CoreFoundation, iOSapi.Foundation, iOSapi.CoreImage, iOSapi.QuartzCore,
  iOSapi.CoreData,
  {$ENDIF}
  FMX.Platform;

{$IFDEF IOS}
const
  libAudioToolbox = '/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox';
  kSystemSoundID_vibrate = $FFF;

procedure AudioServicesPlaySystemSound(inSystemSoundID: integer); cdecl; external libAudioToolbox name _PU + 'AudioServicesPlaySystemSound';
{$ENDIF}

procedure Vibrate(const Duration: UInt16);

implementation

procedure Vibrate(const Duration: UInt16);
begin
  {$IFDEF ANDROID}
  var Vibrator := TJVibrator.Wrap((TAndroidHelper.Context.getSystemService(TJContext.JavaClass.VIBRATOR_SERVICE) as ILocalObject).GetObjectID);
  Vibrator.vibrate(Duration);
  {$ENDIF}
  {$IFDEF IOS}
  AudioServicesPlaySystemSound(kSystemSoundID_vibrate);
  {$ENDIF}
end;

end.

