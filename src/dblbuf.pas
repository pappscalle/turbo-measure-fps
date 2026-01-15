
program DblBuf;

{$G+}

uses crt, gfx, gfxdbl, font, fps;

const 
  NUM_BOXES = 5;

type 
  TBox = object
    x, y: integer;
    oldx, oldy: integer;
    dx, dy: integer;
    color: byte;
    procedure Init;
    procedure Move;
    procedure Draw;
    procedure Erase;
  end;


var 
  i: integer;
  boxes: array [0..NUM_BOXES-1] of TBox;
  fpsCounter: TFpsCounter;
  s: string[10];

procedure TBox.Init;
begin
  x := random(SCREEN_WIDTH - 16);
  y := random(SCREEN_HEIGHT - 16);
  oldx := x;
  oldy := y;
  dx := random(3) + 1;
  dy := random(3) + 1;
  color := random(15) + 1;
end;

procedure TBox.Move;
begin
  oldx := x;
  oldy := y;
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
  push es
  push bp
  lds si, Self
  mov bx, [si]            { x }
  mov dx, [si+2]          { y }
  mov al, [si+12]         { color }
  mov ah, al
  les di, Buffer
  mov bp, dx
  shl bp, 6
  mov cx, dx
  shl cx, 8
  add bp, cx
  add bp, bx
  add di, bp
  mov cx, 16
  @row:
  push cx
  mov cx, 8
  rep stosw
  add di, 320 - 16
  pop cx
  loop @row
  pop bp
  pop es
  pop ds
end;

procedure TBox.Erase;
assembler;
asm
  push ds
  les di, Buffer
  lds si, Self
  mov bx, [si+4]         { oldx }
  mov dx, [si+6]         { oldy }
  xor ax, ax             { color = 0 }
  mov di, dx
  shl di, 6
  mov cx, dx
  shl cx, 8
  add di, cx
  add di, bx
  mov cx, 16
  @row:
  push cx
  mov cx, 8
  rep stosw
  add di, 320 - 16
  pop cx
  loop @row
  pop ds
end;

begin
  randomize;
  InitBuffer;
  
  for i := 0 to NUM_BOXES-1 do
    boxes[i].Init;
  
  fpsCounter.Init;
  SetVideoMode($13);
  
  repeat
  
    for i := 0 to NUM_BOXES-1 do
      boxes[i].Move;
  
    for i := 0 to NUM_BOXES-1 do
      boxes[i].Erase;
  
    for i := 0 to NUM_BOXES-1 do
      boxes[i].Draw;
  
    fpsCounter.Frame;
    fpsCounter.Update;
  
    WaitRetrace;
    FlipBuffer;
    Str(fpsCounter.fps:2, s);
    DrawString(0, 180, s, 15);
  
  until KeyPressed;
  
  SetVideoMode($03);
  DoneBuffer;

end.
