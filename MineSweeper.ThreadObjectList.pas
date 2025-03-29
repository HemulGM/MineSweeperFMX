unit MineSweeper.ThreadObjectList;

interface

uses
  System.SysUtils, System.Types, System.Generics.Collections;

type
  TThreadObjectList<T: class> = class
  private
    FList: TObjectList<T>;
    FLock: TObject;
    FDuplicates: TDuplicates;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const Item: T);
    procedure Clear;
    function LockList: TObjectList<T>;
    procedure Remove(const Item: T); inline;
    procedure RemoveItem(const Item: T; Direction: TDirection);
    procedure UnlockList; inline;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
  end;

implementation

uses
  System.RTLConsts;

{ TThreadObjectList<T> }

function TThreadObjectList<T>.LockList: TObjectList<T>;
begin
  TMonitor.Enter(FLock);
  Result := FList;
end;

procedure TThreadObjectList<T>.UnlockList;
begin
  TMonitor.Exit(FLock);
end;

procedure TThreadObjectList<T>.Add(const Item: T);
begin
  LockList;
  try
    if (Duplicates = dupAccept) or
      (FList.IndexOf(Item) = -1) then
      FList.Add(Item)
    else if Duplicates = dupError then
      raise EListError.CreateResFmt(@SDuplicateItem, [FList.ItemValue(Item)]);
  finally
    UnlockList;
  end;
end;

procedure TThreadObjectList<T>.Clear;
begin
  LockList;
  try
    FList.Clear;
  finally
    UnlockList;
  end;
end;

constructor TThreadObjectList<T>.Create;
begin
  inherited Create;
  FLock := TObject.Create;
  FList := TObjectList<T>.Create;
  FDuplicates := dupIgnore;
end;

destructor TThreadObjectList<T>.Destroy;
begin
  LockList;    // Make sure nobody else is inside the list.
  try
    FList.Free;
    inherited Destroy;
  finally
    UnlockList;
    FLock.Free;
  end;
end;

procedure TThreadObjectList<T>.Remove(const Item: T);
begin
  RemoveItem(Item, TDirection.FromBeginning);
end;

procedure TThreadObjectList<T>.RemoveItem(const Item: T; Direction: TDirection);
begin
  LockList;
  try
    FList.RemoveItem(Item, Direction);
  finally
    UnlockList;
  end;
end;

end.

