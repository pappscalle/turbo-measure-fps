
unit Fps;

interface

uses crt;

type 
  TFpsCounter = object
    frames: longint;
    lastTick: word;
    tickAcc: word;
    fps: word;
    procedure Init;
    procedure Frame;
    procedure Update;
  end;

implementation

procedure TFpsCounter.Init;
begin
  frames := 0;
  lastTick := MemW[$40:$6C];
  tickAcc := 0;
  fps := 0;
end;

procedure TFpsCounter.Frame;
begin
  Inc(frames);
end;

procedure TFpsCounter.Update;
var 
  tick:   word;
begin
  tick := MemW[$40:$6C];
  if tick <> lastTick then
    begin
      inc(tickAcc);
      lastTick := tick;

      if tickAcc >= 18 then
        begin
          fps := frames;
          frames := 0;
          tickAcc := 0;
        end;
    end;
end;

end.
