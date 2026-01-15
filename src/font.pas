unit Font;

interface

uses gfx;

procedure DrawChar(x, y: integer; ch: char; color: byte);
procedure DrawString(x, y: integer; s: string; color: byte);

implementation

const
  FONT_WIDTH = 8;
  FONT_HEIGHT = 8;  

type 
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


procedure DrawString(x, y: integer; s: string; color: byte);
var
  i: integer;
begin
  for i := 1 to length(s) do
    DrawChar(x + (i-1)*FONT_WIDTH, y, s[i], color);
end;

end.