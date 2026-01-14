program Runme;

{$G+}

uses crt, gfx, font, fps;

const 
  NUM_BOXES = 5;

type 
  TBox = record
    x, y : integer;
    dx, dy : integer;
    color : byte;
  end;



var 
  i : integer;
  boxes : array [0..NUM_BOXES-1] of TBox;

  fpsCounter: TFpsCounter;

  s: string[10];



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
    DrawString(0, 180, s, 15);

  until KeyPressed;

  SetVideoMode($03);

end.
