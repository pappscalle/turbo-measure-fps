program Runme;

{$G+}

uses crt, gfx, fps;

const 
  NUM_BOXES = 5;

  FONT_WIDTH = 8;
  FONT_HEIGHT = 8;

type 
  TBox = record
    x, y : integer;
    dx, dy : integer;
    color : byte;
  end;

TFont8x8 = array[0..7] of byte;

const
  FontDigits: array[0..9] of TFont8x8 = (
    ($3C,$66,$6E,$76,$66,$66,$3C,$00),  { 0 }
    ($18,$38,$18,$18,$18,$18,$7E,$00),  { 1 }
    ($3C,$66,$06,$0C,$18,$30,$7E,$00),  { 2 }
    ($3C,$66,$06,$1C,$06,$66,$3C,$00),  { 3 }
    ($0C,$1C,$3C,$6C,$7E,$0C,$0C,$00),  { 4 }
    ($7E,$60,$7C,$06,$06,$66,$3C,$00),  { 5 }
    ($3C,$60,$7C,$66,$66,$66,$3C,$00),  { 6 }
    ($7E,$06,$0C,$18,$30,$30,$30,$00),  { 7 }
    ($3C,$66,$3C,$66,$66,$66,$3C,$00),  { 8 }
    ($3C,$66,$66,$3E,$06,$66,$3C,$00)   { 9 }
  );

var 
  i : integer;
  boxes : array [0..NUM_BOXES-1] of TBox;

  fpsCounter: TFpsCounter;

  s: string[10];

{ --- Draw a single 8x8 digit --- }
procedure DrawChar(x, y: integer; ch: char; color: byte);
var
  i, j: integer;
  bitmap: TFont8x8;
begin
  if (ch >= '0') and (ch <= '9') then
    bitmap := FontDigits[ord(ch)-ord('0')]
  else exit;  { only digits implemented }

  for i := 0 to FONT_HEIGHT-1 do
    for j := 0 to FONT_WIDTH-1 do
      if (bitmap[i] shl j) and $80 <> 0 then
        SetPixel(x+j, y+i, color) 
        else 
        SetPixel(x+j, y+i, 0);
end;

{ --- Draw a string of digits --- }
procedure DrawString(x, y: integer; s: string; color: byte);
var
  i: integer;
begin
  for i := 1 to length(s) do
    DrawChar(x + (i-1)*FONT_WIDTH, y, s[i], random(16));
end;


procedure DrawBox(var b: TBox);
var ix, iy: integer;
begin
  for iy := b.y to b.y + 15 do
    for ix := b.x to b.x + 15 do
      SetPixel(ix, iy, b.color);
end;

begin

  randomize;

  for i := 0 to NUM_BOXES-1 do begin
    boxes[i].x := random(SCREEN_WIDTH - 16);
    boxes[i].y := random(SCREEN_HEIGHT - 16);
    boxes[i].dx := random(3) + 1;
    boxes[i].dy := random(3) + 1;
    boxes[i].color := random(16);
  end;

  fpsCounter.Init;
  
  SetVideoMode($13);

  repeat
    {ClearScreen(0);}
 
    for i := 0 to NUM_BOXES-1 do begin
      DrawBox(boxes[i]);

      boxes[i].x := boxes[i].x + boxes[i].dx;
      boxes[i].y := boxes[i].y + boxes[i].dy;

      if (boxes[i].x < 0) or (boxes[i].x > SCREEN_WIDTH - 16) then
        boxes[i].dx := -boxes[i].dx;

      if (boxes[i].y < 0) or (boxes[i].y > SCREEN_HEIGHT - 16) then
        boxes[i].dy := -boxes[i].dy;
    end;  

    fpsCounter.Frame;  
    fpsCounter.Update;

    Str(fpsCounter.fps, s);
    DrawString(0, 180, s + ' FPS', 15);

  until KeyPressed;

  SetVideoMode($03);

end.
