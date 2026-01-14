program Runme;

{$G+}

uses crt, gfx, font, fps;

const 
  NUM_BOXES = 5;

type 
  TBox = object
    x, y : integer;
    dx, dy : integer;
    color : byte;
    procedure Init;
    procedure Move;
    procedure Draw;
  end;

var 
  i : integer;
  boxes : array [0..NUM_BOXES-1] of TBox;
  fpsCounter: TFpsCounter;
  s: string[10];

procedure TBox.Init;
begin
  x := random(SCREEN_WIDTH - 16);
  y := random(SCREEN_HEIGHT - 16);
  dx := random(3) + 1;
  dy := random(3) + 1;
  color := random(16);
end;

procedure TBox.Move;
begin
  x := x + dx;
  y := y + dy;

  if (x < 0) or (x > SCREEN_WIDTH - 16) then
    dx := -dx;
  if (y < 0) or (y > SCREEN_HEIGHT - 16) then
    dy := -dy;
end;

procedure TBox.Draw; assembler;
asm
  push ds

  mov ax, $A000
  mov es, ax

  lds si, Self

  mov bx, [si]            { x }
  mov dx, [si+2]          { y }
  mov al, [si+8]          { color }

  mov di, dx
  shl di, 6
  mov cx, dx
  shl cx, 8
  add di, cx
  add di, bx

  mov cx, 16
@row:
  push cx
  mov cx, 16
  rep stosb
  add di, 320 - 16
  pop cx
  loop @row

  pop ds
end;



begin

  randomize;

  for i := 0 to NUM_BOXES-1 do boxes[i].Init;

  fpsCounter.Init;
  
  SetVideoMode($13);

  repeat
    {ClearScreen(0);}
 
    for i := 0 to NUM_BOXES-1 do begin
      boxes[i].Move;
      boxes[i].Draw;
    end;  

    fpsCounter.Frame;  
    fpsCounter.Update;

    Str(fpsCounter.fps:2, s);
    DrawString(0, 180, s, 15);

  until KeyPressed;

  SetVideoMode($03);

end.
